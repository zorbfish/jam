# -*- mode: ruby -*-
# vi: set ft=ruby :

task :test do
  require 'guard'

  Guard.setup
  Guard.guards('leanunit').run_all
end

task :build do
  input = 'src/Main.as'
  output = 'bin/launcher.swf'
  includes = '-cp src -cp lib -cp tests'
  params = '272:480:10:000000'

  sh "mtasc #{includes} -version 7 -swf #{output} -header #{params} -main #{input}"
end

task :default => [:test]
