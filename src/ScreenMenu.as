/*
ScreenMenu provides navigation between UI modes
and access to powering down/sleeping the device
*/
class ScreenMenu {

  private var fw_func:Function
  private var addListener:Function
  private var broadcastMessage:Function

  function ScreenMenu(fw_func:Function) {
    AsBroadcaster.initialize(this)
  }

  function notify_on_close(listener:Object) {
    addListener(listener)
  }

  private function close() {
    broadcastMessage('menu_closed')
  }
}
