import 'package:get/get.dart';
import 'package:offline_first_flutter/src/hive/presentation/manager/discussions_controller.dart';
import 'package:offline_first_flutter/src/hive/presentation/manager/hive_controller.dart';
import 'package:offline_first_flutter/src/hive/presentation/manager/poll_controller.dart';
import 'package:offline_first_flutter/src/hive/presentation/manager/questions_controller.dart';

class HiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HiveController());
    Get.put(DiscussionsController());
    Get.put(PollController());
    Get.put(QuestionsController());
  }
}
