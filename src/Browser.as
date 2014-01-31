/*
Browser navigates the music collection and modifies the selected playlist
*/
class Browser {

  private var collection:Object
  private var page:Array
  private var page_length:Number
  private var paginator:PagedArray

  private var addListener:Function
  private var broadcastMessage:Function

  function Browser(page_length:Number, collection:Object) {
    this.collection = collection
    this.page = new Array(page_length)
    this.page_length = page_length
    this.paginator = new PagedArray(page_length, collection.albums())

    paginator.get_page(0, page)
    AsBroadcaster.initialize(this)
  }

  function add_index(idx:Number) {
    revert_paged_index(idx)
  }

  function notify_on_page_change(listener:Object) {
    addListener(listener)
    notify_page_changed()
  }

  function now_browsing():String {
    return 'Albums'
  }

  function next_page() {
    if (paginator.next_page(page)) {
      notify_page_changed()
    }
  }

  function prev_page() {
    if (paginator.prev_page(page)) {
      notify_page_changed()
    }
  }

  private function revert_paged_index(idx:Number):Number {
    return paginator.current_page() * page_length + idx
  }

  private function notify_page_changed() {
    broadcastMessage('browser_page_changed', page)
  }
}
