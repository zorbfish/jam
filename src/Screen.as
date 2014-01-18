/*
Screen decides when the menu and ui are displayed
and which one receives touch feedback from the user
*/
class Screen {

  private var ui_visible:Boolean
  private var ui:Object
  private var smenu:Object

  function Screen(ui:Object, smenu:Object) {
    this.ui = ui
    turn_on()
  }

  function is_on() {
    return ui_visible
  }

  function turn_off() {
    ui_visible = false
  }

  function touched(x:Number, y:Number) {
    if (!ui_visible) {
      turn_on()
    } else {
      ui.touched(x, y)
    }
  }

  function moved(x:Number, y:Number) {
    if (ui_visible) {
      ui.moved(x, y)
    }
  }

  function released(x:Number, y:Number) {
    if (ui_visible) {
      ui.released(x, y)
    }
  }

  private function turn_on() {
    ui_visible = true
  }
}
