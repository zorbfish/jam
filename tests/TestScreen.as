class TestScreen extends leanUnit.TestCase {

  function no_op() {}

  function respond_with(response) {
    return function(x, y) {
      this.x = x
      this.y = y
      this.response = response
    }
  }

  function new_input_stub():Object {
    return {
      x: 0,
      y: 0,
      response: 'None',

      touched: respond_with('Touched'),
      moved: respond_with('Moved'),
      released: respond_with('Released')
    }
  }

  function new_visibility_stub():Object {
    return {
      response: 'Unknown',

      show: respond_with('Shown'),
      hide: respond_with('Hidden')
    }
  }

  function test_when_touched_screen_turns_on() {
    var screen = new Screen({}, {})

    screen.turn_off()
    screen.touched(0, 0)

    assertTrue(screen.is_on())
  }

  function test_when_screen_is_on_ui_receives_touch_input() {
    var ui = new_input_stub()
    var screen = new Screen(ui, {})

    screen.touched(1, 2)

    assertEqual(ui.x, 1)
    assertEqual(ui.y, 2)
    assertEqual(ui.response, 'Touched')
  }

  function test_when_screen_is_on_ui_receives_motion_input() {
    var ui = new_input_stub()
    var screen = new Screen(ui, {})

    screen.moved(3, 4)

    assertEqual(ui.x, 3)
    assertEqual(ui.y, 4)
    assertEqual(ui.response, 'Moved')
  }

  function test_when_screen_is_on_ui_receives_release_input() {
    var ui = new_input_stub()
    var screen = new Screen(ui, {})

    screen.released(5, 6)

    assertEqual(ui.x, 5)
    assertEqual(ui.y, 6)
    assertEqual(ui.response, 'Released')
  }

  function test_when_screen_is_off_ui_receives_no_input() {
    var ui = new_input_stub()
    var screen = new Screen(ui, {})

    screen.turn_off()

    screen.released(0, 0)
    screen.moved(0, 0)
    screen.touched(0, 0) // Remember, touch turns the screen on!

    assertEqual(ui.response, 'None')
  }

  function test_when_menu_is_not_visible_it_receives_no_input() {
    var smenu = new_input_stub()
    var screen = new Screen({}, smenu)

    // Menu must be explicitly shown with show_menu()

    screen.touched(0, 0)
    screen.moved(0, 0)
    screen.released(0, 0)

    assertEqual(smenu.response, 'None')
  }

  function test_when_menu_visible_ui_receives_no_input() {
    var ui = new_input_stub()
    var screen = new Screen(ui, {})

    screen.show_menu()

    screen.touched(0, 0)
    screen.moved(0, 0)
    screen.released(0, 0)

    assertEqual(ui.response, 'None')
  }

  function test_when_menu_closed_screen_is_notified() {
    var smenu = new ScreenMenu(no_op)
    var screen = new Screen({}, smenu)

    screen.show_menu()
    smenu.close()

    assertFalse(screen.menu_has_focus())
  }

  function test_when_screen_off_ui_and_menu_are_not_visible() {
    var ui = new_visibility_stub()
    var smenu = new_visibility_stub()
    var screen = new Screen(ui, smenu)

    screen.turn_off()

    assertEqual(ui.response, 'Hidden')
    assertEqual(smenu.response, 'Hidden')
  }

  function test_when_screen_toggled_menu_does_not_lose_focus() {
    var screen = new Screen({}, {})

    screen.show_menu()
    screen.turn_off()

    screen.touched(0, 0) // Reactivate the screen

    assertTrue(screen.menu_has_focus())
  }
}
