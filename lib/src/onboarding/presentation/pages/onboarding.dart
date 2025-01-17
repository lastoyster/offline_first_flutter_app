import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:offline_first_flutter/generated/assets.dart';
import 'package:offline_first_flutter/routes/app_pages.dart';
import 'package:offline_first_flutter/shared/extensions/buttons.dart';

import '../manager/onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Image.asset(
                  Assets.onboarding,
                ),
              ),
              const Spacer(),
              Text(
                'welcome'.tr,
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 2,
                    ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Text(
                  "welcome_sub_text".tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.signInWithGoogle,
                    label: Text('continue_with_google'.tr),
                    icon: const Icon(Ionicons.logo_google),
                  ).withLoading(
                    loading: controller.loading,
                    text: 'signing_in'.tr,
                    icon: const Icon(Ionicons.logo_google),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.phoneAuth);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  label: Text('continue_with_phone'.tr),
                  icon: const Icon(IconlyBold.call),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
