import 'package:get/get.dart';
import 'package:offline_first_flutter/src/hive/data/remote/data_sources/hive_remote_database.dart';
import 'package:offline_first_flutter/src/hive/data/repositories/hive_repository_impl.dart';
import 'package:offline_first_flutter/src/hive/domain/use_cases/details.dart';
import 'package:offline_first_flutter/src/hive/domain/use_cases/list.dart';
import 'package:offline_first_flutter/src/hive/domain/use_cases/post_message.dart';

import '../../../shared/network/network.dart';
import '../domain/repositories/hive_repository.dart';
import 'local/data_sources/hive_local_database.dart';

class HiveService extends GetxService {
  Future<HiveService> init() async {
    Get.put<HiveRemoteDatabase>(HiveRemoteDatabaseImpl(Get.find()));
    Get.put<HiveLocalDatabase>(HiveLocalDatabaseImpl());
    Get.put<HiveRepository>(HiveRepositoryImpl(
      remoteDatabase: Get.find<HiveRemoteDatabase>(),
      localDatabase: Get.find<HiveLocalDatabase>(),
      networkInfo: Get.find<NetworkInfo>(),
    ));
    Get.put<ListHives>(ListHives(Get.find()));
    Get.put<HiveDetails>(HiveDetails(Get.find()));
    Get.put<PostMessage>(PostMessage(Get.find()));
    return this;
  }
}
