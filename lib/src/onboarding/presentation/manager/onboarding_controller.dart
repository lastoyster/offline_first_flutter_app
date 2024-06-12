import 'package:get/get.dart';
import 'package:offline_first_flutter/routes/app_pages.dart';
import 'package:offline_first_flutter/shared/ui/snackbars.dart';
import 'package:offline_first_flutter/src/auth/domain/repositories/auth_repository.dart';

import '../../../profile/domain/entities/profile.dart';

class OnboardingController extends GetxController {
  final AuthRepository _authRepository;

  OnboardingController(this._authRepository);

  final RxBool loading = false.obs;

  Future<void> signInWithGoogle() async {
    loading.value = true;
    final results = await _authRepository.continueWithGoogle(Profile.empty());
    results.fold((failure) {
      loading.value = false;
      showErrorSnackbar(message: failure.message);
    }, (exists) {
      loading.value = false;
      if (exists) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.setupProfile);
      }
    });
  }
}
