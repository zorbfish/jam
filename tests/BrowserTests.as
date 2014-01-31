class BrowserTests extends leanUnit.TestCase {

  function new_browser_ui_stub():Object {
    return {
      response: "Current",
      page: [],

      browser_page_changed: function(page) {
        this.page = page
        this.response = "Changed"
      },
      page_update: function() {
        this.response = "Current"
      }
    }
  }

  function new_collection_stub():Object {
    return {
      albums: function() {
        return ["Album 1", "Album 2"]
      },
      get_tracks_from_album: function(idx:Number) {
        switch (idx) {
          case 0:
            return [1, 2, 3]
          break
          case 1:
            return [4, 5, 6]
          break
        }
      }
    }
  }

  function new_playlist_stub():Object {
    return {
      track_count: 0,
      tracks: {},

      add_tracks: function(tracks:Array) {
        for (var t in tracks) {
          ++this.track_count
          this.tracks[t] = true
        }
      },
      is_listed: function(tracks:Array) {
        var listed = true
        for (var t in tracks) {
          if (!this.tracks[t]) {
            listed = false
            break
          }
        }
        return listed
      },
      remove_tracks: function(tracks:Array) {
        for (var t in tracks) {
          --this.track_count
          this.tracks[t] = false
        }
      }
    }
  }

  function test_when_created_browser_starts_in_albums() {
    var browser = new Browser(0, {})

    assertEqual(browser.now_browsing(), "Albums")
  }

  function test_when_listener_added_notification_is_sent() {
    var collection = new_collection_stub()
    var browser = new Browser(1, collection)
    var ui = new_browser_ui_stub()

    browser.notify_on_page_change(ui)

    assertEqual(ui.response, "Changed")
  }

  function test_when_next_page_loads_notification_is_sent() {
    var collection = new_collection_stub()
    var browser = new Browser(1, collection)
    var ui = new_browser_ui_stub()

    browser.notify_on_page_change(ui)
    ui.page_update()
    browser.next_page()

    assertEqual(ui.response, "Changed")
  }

  function test_when_prev_page_loads_notification_is_sent() {
    var collection = new_collection_stub()
    var browser = new Browser(1, collection)
    var ui = new_browser_ui_stub()

    browser.notify_on_page_change(ui)
    ui.page_update()
    browser.next_page()
    ui.page_update()
    browser.prev_page()

    assertEqual(ui.response, "Changed")
  }

  function test_when_album_added_playlist_adds_all_tracks_on_album() {
    var collection = new_collection_stub()
    var playlist = new_playlist_stub()
    var browser = new Browser(1, collection, playlist)

    browser.add_index(0) // Album 1

    assertTrue(playlist.is_listed([1, 2, 3]))
  }

  function test_when_browser_uses_index_collection_correctly_accessed() {
    var collection = new_collection_stub()
    var playlist = new_playlist_stub()
    var browser = new Browser(1, collection, playlist)

    browser.next_page() // Album 2 at 0 on Page 2
    browser.add_index(0)

    assertTrue(playlist.is_listed([4, 5, 6]))
  }

  function test_when_album_removed_playlist_removes_all_tracks_on_album() {
    var collection = new_collection_stub()
    var playlist = new_playlist_stub()
    var browser = new Browser(1, collection, playlist)

    browser.add_index(0)
    browser.remove_index(0)

    assertEqual(playlist.track_count, 0)
  }
}
