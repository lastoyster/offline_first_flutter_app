import 'package:get/get.dart';
import 'package::offline_first_flutter/src/settings/presentation/manager/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
