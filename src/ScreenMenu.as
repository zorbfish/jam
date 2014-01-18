/*
ScreenMenu provides navigation between UI modes
and access to powering down/sleeping the device
*/
class ScreenMenu {

  private var fw_func:Function
  private var broadcastMessage:Function

  function ScreenMenu(fw_func:Function) {
    AsBroadcaster.initialize(this)
  }

  private function close() {
    broadcastMessage('menu_closed')
  }
}
