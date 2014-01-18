/*
Screen decides when the menu and ui are displayed
and which one receives touch feedback from the user
*/
class Screen {

  private var ui_visible:Boolean
  private var ui:Object

  private var smenu_has_focus:Boolean
  private var smenu:Object

  function Screen(ui:Object, smenu:Object) {
    this.ui = ui
    this.smenu = smenu

    turn_on()
    listen_to_menu()
    listen_to_mouse(this)
  }

  function is_on():Boolean {
    return ui_visible
  }

  function menu_has_focus():Boolean {
    return smenu_has_focus
  }

  function show_menu() {
    smenu.show()
    smenu_has_focus = true
  }

  function turn_off() {
    ui.hide()
    smenu.hide()
    ui_visible = false
  }

  function touched(x:Number, y:Number) {
    if (!ui_visible) {
      turn_on()
    } else if (smenu_has_focus) {
      smenu.touched(x, y)
    } else {
      ui.touched(x, y)
    }
  }

  function moved(x:Number, y:Number) {
    if (smenu_has_focus) {
      smenu.moved(x, y)
    } else if (ui_visible) {
      ui.moved(x, y)
    }
  }

  function released(x:Number, y:Number) {
    if (smenu_has_focus) {
      smenu.released(x, y)
    } else if (ui_visible) {
      ui.released(x, y)
    }
  }

  private function listen_to_menu() {
    smenu.addListener(this)
  }
  
  private function listen_to_mouse(screen) {
    var hold_delay:Number = 2000 // milliseconds
    var menu_timer:Number = 0
    var timer_running:Boolean = false

    Mouse.addListener({
      onMouseDown: function() {
        if (screen.is_on()) {
          menu_timer = setInterval(
            function() {
              screen.show_menu()
              clearInterval(menu_timer)
            }, hold_delay)
          timer_running = true
        }

        screen.touched(_root._xmouse, _root._ymouse)
      },

      onMouseMove: function() {
        if (timer_running) {
          clearInterval(menu_timer)
          timer_running = false
        }

        screen.moved(_root._xmouse, _root._ymouse)
      },

      onMouseUp: function() {
        if (timer_running) {
          clearInterval(menu_timer)
          timer_running = false
        }

        screen.released(_root._xmouse, _root._ymouse)
      }
    })
  }

  private function menu_closed() {
    smenu_has_focus = false
  }

  private function turn_on() {
    ui_visible = true
    ui.show()
    if (smenu_has_focus) {
      smenu.show()
    }
  }
}
