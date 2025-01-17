import 'package:get/get.dart';
import 'package:offline_first_flutter/src/profile/presentation/manager/profile_controller.dart';
import 'package:offline_first_flutter/src/profile/presentation/manager/setup_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => SetupProfileController());
  }
}
