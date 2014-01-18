class TestScreen extends leanUnit.TestCase {

  function no_op() {}

  function new_feedback_stub():Object {
    var respond = function(feedback) {
      return function(x, y) {
        this.x = x
        this.y = y
        this.feedback = feedback
      }
    }

    return {
      x: 0,
      y: 0,
      feedback: 'None',

      touched: respond('Touched'),
      moved: respond('Moved'),
      released: respond('Released')
    }
  }

  function test_when_touched_screen_turns_on() {
    var screen = new Screen({}, {})

    screen.turn_off()
    screen.touched(0, 0)

    assertTrue(screen.is_on())
  }

  function test_when_screen_is_on_ui_receives_touch_feedback() {
    var ui = new_feedback_stub()
    var screen = new Screen(ui, {})

    screen.touched(1, 2)

    assertEqual(ui.x, 1)
    assertEqual(ui.y, 2)
    assertEqual(ui.feedback, 'Touched')
  }

  function test_when_screen_is_on_ui_receives_motion_feedback() {
    var ui = new_feedback_stub()
    var screen = new Screen(ui, {})

    screen.moved(3, 4)

    assertEqual(ui.x, 3)
    assertEqual(ui.y, 4)
    assertEqual(ui.feedback, 'Moved')
  }

  function test_when_screen_is_on_ui_receives_release_feedback() {
    var ui = new_feedback_stub()
    var screen = new Screen(ui, {})

    screen.released(5, 6)

    assertEqual(ui.x, 5)
    assertEqual(ui.y, 6)
    assertEqual(ui.feedback, 'Released')
  }

  function test_when_screen_is_off_ui_receives_no_feedback() {
    var ui = new_feedback_stub()
    var screen = new Screen(ui, {})

    screen.turn_off()

    screen.released(0, 0)
    screen.moved(0, 0)
    screen.touched(0, 0) // Remember, touch turns the screen on!

    assertEqual(ui.feedback, 'None')
  }

  function test_when_menu_is_not_visible_it_receives_no_feedback() {
    var smenu = new_feedback_stub()
    var screen = new Screen({}, smenu)

    // Menu must be explicitly shown with show_menu()

    screen.touched(0, 0)
    screen.moved(0, 0)
    screen.released(0, 0)

    assertEqual(smenu.feedback, 'None')
  }

  function test_when_menu_visible_ui_receives_no_feedback() {
    var ui = new_feedback_stub()
    var screen = new Screen(ui, {})

    screen.show_menu()

    screen.touched(0, 0)
    screen.moved(0, 0)
    screen.released(0, 0)

    assertEqual(ui.feedback, 'None')
  }

  function test_when_menu_closed_screen_is_notified() {
    var smenu = new ScreenMenu(no_op)
    var screen = new Screen({}, smenu)

    screen.show_menu()
    smenu.close()

    assertFalse(screen.menu_is_visible())
  }
}
