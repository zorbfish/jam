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
}
