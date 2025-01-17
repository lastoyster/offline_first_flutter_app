import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_first_flutter/routes/app_pages.dart';
import 'package:offline_first_flutter/shared/extensions/strings.dart';
import 'package:offline_first_flutter/shared/ui/custom_bottomsheet.dart';
import 'package:offline_first_flutter/shared/ui/custom_listtile.dart';
import 'package:offline_first_flutter/shared/ui/spinner.dart';
import 'package:offline_first_flutter/src/settings/presentation/manager/settings_controller.dart';
import 'package:offline_first_flutter/src/settings/presentation/widgets/no_avatar.dart';
import 'package:offline_first_flutter/src/settings/presentation/widgets/user_avatar.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("your_account".tr),
      ),
      body: controller.obx(
        (profile) {
          return ListView(
            children: [
              ListTile(
                onTap: () {
                  showCustomBottomSheet(
                      horizontalPadding: 0,
                      height: profile.photoUrl != null ? Get.height * 0.25 : Get.height * 0.18,
                      child: Column(
                        children: [
                          CustomListTile(
                            onTap: () {
                              Get.back();
                              controller.chooseProfile(ImageSource.camera);
                            },
                            leading: const Icon(IconlyLight.camera),
                            title: "take_a_photo".tr,
                          ),
                          CustomListTile(
                            onTap: () {
                              Get.back();
                              controller.chooseProfile(ImageSource.gallery);
                            },
                            leading: const Icon(IconlyLight.image),
                            title: "choose_from_gallery".tr,
                          ),
                          if (profile.photoUrl != null)
                            CustomListTile(
                              onTap: () {
                                Get.back();
                                controller.deleteProfile();
                              },
                              leading: const Icon(IconlyLight.delete),
                              title: "delete_photo".tr,
                            ),
                        ],
                      ));
                },
                leading: Obx(() {
                  if (controller.uploading.value) {
                    return const Spinner();
                  }
                  return profile!.photoUrl != null
                      ? Hero(
                          tag: profile.id,
                          child: UserAvatar(url: profile.photoUrl!),
                        )
                      : Hero(
                          tag: profile.id,
                          child: NoAvatar(initials: profile.name.initials),
                        );
                }),
                subtitle: Text(profile!.bio ?? "your_personal_account".tr),
                title: Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.profile, arguments: profile);
                  },
                  child: Text(
                    "Edit",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "General",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              CustomListTile(
                onTap: () {},
                title: "theme".tr,
                subtitle: "light_mode".tr,
                leading: const Icon(IconlyLight.filter),
                trailing: const Icon(IconlyLight.arrow_right_3),
              ),
              CustomListTile(
                onTap: () {},
                title: "privacy_security".tr,
                subtitle: 'control_your_privacy'.tr,
                leading: const Icon(IconlyLight.lock),
                trailing: const Icon(IconlyLight.arrow_right_3),
              ),
              CustomListTile(
                onTap: () {},
                title: "invite_a_friend".tr,
                subtitle: "share_studyhive_with_your_friends".tr,
                leading: const Icon(IconlyLight.heart),
                trailing: const Icon(IconlyLight.arrow_right_3),
              ),
              CustomListTile(
                onTap: () {
                  showCustomBottomSheet(
                    height: Get.height * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Text(
                            "logout_prompt".tr,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              controller.signOut();
                            },
                            child: Text("logout".tr),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("cancel".tr),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                leading: const Icon(IconlyLight.logout),
                title: 'logout'.tr,
                subtitle: "logout_from_studyhive".tr,
                trailing: const Icon(IconlyLight.arrow_right_3),
              ),
            ],
          );
        },
        onLoading: const Center(
          child: Spinner(),
        ),
      ),
    );
  }
}
