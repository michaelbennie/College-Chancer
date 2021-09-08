import "package:os_detect/os_detect.dart" as Platform;
import 'dart:html';

class WebHandler {
  void handleWeb() {
    if (Platform.isBrowser) {
      window.document.onContextMenu.listen((evt) => evt.preventDefault());
    }
  }
}
