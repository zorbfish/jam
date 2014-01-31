/*
Browser navigates the music collection and modifies the selected playlist
*/
class Browser {

  private static var BROWSING_ALBUMS = 0

  private var location:Number
  private var collection:Object
  private var playlist:Object
  private var page:Array
  private var page_length:Number
  private var paginator:PagedArray

  private var addListener:Function
  private var broadcastMessage:Function

  function Browser(page_length:Number, collection:Object, playlist:Object) {
    this.location = Browser.BROWSING_ALBUMS
    this.collection = collection
    this.playlist = playlist
    this.page = new Array(page_length)
    this.page_length = page_length
    this.paginator = new PagedArray(page_length, collection.albums())

    paginator.get_page(0, page)
    AsBroadcaster.initialize(this)
  }

  function add_index(idx:Number) {
    var real_idx = revert_paged_index(idx)
    switch (location) {
      case Browser.BROWSING_ALBUMS:
        var tracks = collection.get_tracks_from_album(real_idx)
        playlist.add_tracks(tracks)
      break
    }
  }

  function remove_index(idx:Number) {
    var real_idx = revert_paged_index(idx)
    switch (location) {
      case Browser.BROWSING_ALBUMS:
        var tracks = collection.get_tracks_from_album(real_idx)
        playlist.remove_tracks(tracks)
      break
    }
  }

  function notify_on_page_change(listener:Object) {
    addListener(listener)
    notify_page_changed()
  }

  function now_browsing():String {
    switch (location) {
      case Browser.BROWSING_ALBUMS:
        return "Albums"
      break
    }
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
