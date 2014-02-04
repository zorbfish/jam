# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'guard/guard'

module ::Guard
  class LeanUnit < ::Guard::Guard
    def run_all
      run_on_changes(all_tests)
    end

    def run_on_additions(paths)
      true
    end

    def run_on_changes(test_names)
      swf_built = build_swf(test_names.select { |name| tests_exist?(name) })
      run_tests_and_display_results if swf_built
    end

    def run_on_removals(paths)
      true
    end

  private

    def all_tests
      Dir.glob('test/**/*Tests.as').map do |file_name|
        File.basename(file_name, File.extname(file_name))
      end
    end

    def build_swf(case_names)
      return false if case_names.empty?

      includes = '-cp src -cp lib -cp test'
      input = 'bin/Main.as'

      File.open("#{input}", 'w+') do |f|
        f.write <<BODY
class Main {
  static function main() {
    var suite = new leanUnit.TestSuite(#{case_names.join(',')})
    suite.run()
    trace('exit')
  }
}
BODY
      end
      error =
        `mtasc #{includes} -swf #{output} -header 1:1:24 -main #{input} 2>&1`
      $?.success? || (puts "Compilation failed: #{error}")
    end

    def format_print(line)
      %w{. F}.include?(line) ? print(line) : puts(line)
    end

    def output
      'bin/Tests.swf'
    end

    def run_tests_and_display_results
      results = IO.popen("gnash -v #{output}")

      results.each do |line|
        cleaned_line = remove_gnash_verbosity(line)
        if cleaned_line == 'exit'
          Process.kill(:SIGTERM, results.pid)
        else
          format_print(cleaned_line) unless cleaned_line.nil?
        end
      end
    end

    def remove_gnash_verbosity(line)
      m = /\d+\s*\TRACE:\s(.*)/.match(line)

      # Returns nil for lines that are not trace messages
      m && m[1] || nil
    end

    def tests_exist?(case_name)
      File.exists?("test/#{case_name}.as")
    end
  end
end

guard :leanunit do
  watch(%r{^src/(.+)\.as$}) { |m| "#{m[1]}Tests" }
  watch(%r{^test/(.+Tests)\.as$}) { |m| m[1] } 
end

guard :test do
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb') { 'test' }
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
end
