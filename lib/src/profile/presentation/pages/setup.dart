import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first_flutter/shared/extensions/buttons.dart';
import 'package:offline_first_flutter/shared/theme/theme.dart';
import 'package:offline_first_flutter/src/profile/presentation/manager/setup_controller.dart';

class SetupProfilePage extends GetView<SetupProfileController> {
  const SetupProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 48, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'what_is_your_name'.tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 30),
                child: Text(
                  'we_will_use_this_for_your_profile'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Obx(() {
                return TextFormField(
                  autofocus: true,
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  enabled: !controller.loading.value,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: 'full_name'.tr,
                    contentPadding: inputPadding,
                  ),
                );
              }),
              const Spacer(),
              SizedBox(
                width: double.maxFinite,
                child: Obx(
                  () {
                    return ElevatedButton(
                      onPressed: controller.enableFinishButton.value ? controller.updateProfile : null,
                      child: Text(
                        'continue'.tr,
                      ),
                    ).withLoading(loading: controller.loading);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
