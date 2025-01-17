import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:offline_first_flutter/shared/theme/theme.dart';
import 'package:offline_first_flutter/shared/ui/custom_bottomsheet.dart';
import 'package:offline_first_flutter/shared/ui/empty_state.dart';
import 'package:offline_first_flutter/shared/ui/spinner.dart';
import 'package:offline_first_flutter/src/hive/presentation/manager/hive_controller.dart';

import '../../../../generated/assets.dart';
import '../../../../shared/ui/custom_listtile.dart';
import 'new_material.dart';
import 'new_poll.dart';
import 'new_question.dart';

class HivePage extends GetView<HiveController> {
  const HivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.hive.name),
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Get.back();
          },
          splashRadius: 20,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              splashRadius: 22,
              onPressed: () {},
              icon: const Icon(IconlyLight.setting),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: controller.details(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Spinner());
                  } else if (snapshot.hasError) {
                    return const Text("We had an error");
                  }
                  final data = snapshot.data!;
                  return data.conversations.isEmpty
                      ? const EmptyState(text: "", asset: Assets.discussion)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          itemCount: data.conversations.length,
                          itemBuilder: (context, index) {
                            final message = data.conversations[index];
                            return Text(message.text ?? "");
                          },
                        );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: controller.textController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding: inputPadding,
                  hintText: 'Share your thoughts...',
                  suffixIcon: Obx(() {
                    return IconButton(
                      onPressed: controller.showSendButton.value
                          ? () {
                              controller.sendMessage();
                            }
                          : null,
                      icon: const Icon(IconlyLight.send),
                    );
                  }),
                  prefixIcon: IconButton(
                    onPressed: () {
                      showCustomBottomSheet(
                        horizontalPadding: 0,
                        height: Get.height * 0.24,
                        child: Column(
                          children: [
                            CustomListTile(
                              onTap: () {
                                Get.back();
                                Get.to(() => const NewQuestion(), fullscreenDialog: true);
                              },
                              title: "Ask a Question",
                              leading: const Icon(IconlyLight.paper),
                            ),
                            CustomListTile(
                              onTap: () {
                                Get.back();
                                Get.to(() => const NewMaterial(), fullscreenDialog: true);
                              },
                              title: "Share a Material",
                              leading: const Icon(IconlyLight.paper_plus),
                            ),
                            CustomListTile(
                              onTap: () {
                                Get.back();
                                Get.to(() => const NewPoll(), fullscreenDialog: true);
                              },
                              title: "Create a Poll",
                              leading: const Icon(IconlyLight.chart),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(IconlyLight.activity),
                  ),
                ),
                // onFieldSubmitted: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
