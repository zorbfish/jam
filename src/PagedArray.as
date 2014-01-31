/*
Splits an array into pages of length N
*/
class PagedArray {

  private var source:Array
  private var page:Number
  private var page_count:Number
  private var page_length:Number

  function PagedArray(page_length:Number, source:Array) {
    this.source = source
    page = 0
    page_count = Math.round(source.length / page_length)
    this.page_length = page_length
  }

  function current_page():Number {
    return page
  }

  function get_page(i:Number, target:Array):Boolean {
    if ((i < 0) || (i > page_count)) {
      return false
    }
    slice_into(target, i)
    return true
  }

  function next_page(target:Array):Boolean {
    if (page > page_count) {
      return false
    }
    slice_into(target, ++page)
    return true
  }

  function prev_page(target:Array):Boolean {
    if (page < 0) {
      return false
    }
    slice_into(target, --page)
    return true
  }

  function total_pages():Number {
    return page_count
  }

  private function slice_into(target:Array, page:Number) {
    var i = page * page_length
    var j = 0
    var end_index = i + page_length
    while (i < end_index) {
      target[j++] = source[i++]
    }
  }
}
