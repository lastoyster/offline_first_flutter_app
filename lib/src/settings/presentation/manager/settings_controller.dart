
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_first_flutter/routes/app_pages.dart';
import 'package:offline_first_flutter/shared/ui/snackbars.dart';
import 'package:offline_first_flutter/src/profile/domain/entities/profile.dart';
import 'package:offline_first_flutter/src/profile/domain/use_cases/update.dart';

import '../../../../shared/usecase/usecase.dart';
import '../../../../shared/utils/pick_image.dart';
import '../../../../shared/utils/upload_image.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../profile/domain/use_cases/retrieve.dart';

class SettingsController extends GetxController with StateMixin<Profile> {
  final retrieveProfileUseCase = Get.find<RetrieveProfile>();
  final updateProfileUseCase = Get.find<UpdateProfile>();
  final authRepositoryUseCase = Get.find<AuthRepository>();
  Profile _profile = Profile.empty();
  RxBool uploading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _retrieveProfile();
  }

  Future<void> _retrieveProfile() async {
    final result = await retrieveProfileUseCase(Params(currentUser!.uid));
    return result.fold(
        (failure) => change(Profile.empty(), status: RxStatus.error("There was an error retrieving your profile")),
        (profile) {
      _profile = profile;
      change(profile, status: RxStatus.success());
    });
  }

  Future<void> _updateProfile(Profile profile) async {
    final result = await updateProfileUseCase(Params(profile));
    return result.fold((failure) => showErrorSnackbar(message: failure.message), (profile) {
      _profile = profile;
      change(profile, status: RxStatus.success());
    });
  }

  Future<void> chooseProfile(ImageSource source) async {
    final pickedImage = await pickImage(maxHeight: 512, maxWidth: 512, source: source);
    if (pickedImage != null) {
      final croppedImage = await cropImage(imagePath: pickedImage.path, title: 'Choose Profile');
      if (croppedImage != null) {
        uploading.value = true;
        final downloadUrl = await uploadImage(imagePath: croppedImage.path, folder: "user_profiles");
        if (downloadUrl != null) {
          _profile = _profile.copyWith(photoUrl: downloadUrl);
          await _updateProfile(_profile);
          uploading.value = false;
        } else {
          showErrorSnackbar(message: "There was an error updating your profile picture");
          uploading.value = false;
        }
      }
    } else {}
  }

  Future<void> deleteProfile() async {
    uploading.value = true;
    _profile = _profile.copyWith(photoUrl: null);
    await _updateProfile(_profile);
    uploading.value = false;
  }

  Future<void> signOut() async {
    final results = await authRepositoryUseCase.signOut();
    results.fold(
        (failure) => showErrorSnackbar(message: failure.message), (unit) => Get.offAllNamed(AppRoutes.onboarding));
  }
}
