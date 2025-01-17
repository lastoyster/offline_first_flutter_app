import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package::offline_first_flutter/shared/ui/snackbars.dart';
import 'package::offline_first_flutter/src/hive/domain/use_cases/list.dart';

import '../../../../shared/usecase/usecase.dart';
import '../../../hive/domain/entities/hive.dart';

class HomeController extends GetxController {
  final listHives = Get.find<ListHives>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void onInit() async {
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          Get.closeAllSnackbars();
          break;
        case InternetConnectionStatus.disconnected:
          showLoadingSnackbar(message: "Trying to reconnect...");
      }
    });
    super.onInit();
  }

  Stream<List<Hive>> list() async* {
    final result = await listHives(Params(user.uid));
    yield* result.fold((l) async* {
      showErrorSnackbar(message: l.message);
      yield [];
    }, (r) async* {
      yield* r;
    });
  }
}
