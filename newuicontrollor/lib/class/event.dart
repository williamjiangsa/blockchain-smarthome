
import 'package:event_bus/event_bus.dart';

class Event {
  static EventBus eventBus = new EventBus();
}

class ServerChanged {
  String server;
  ServerChanged(this.server);
}


class DeviceAdd {
  String device;
  DeviceAdd(this.device);
}