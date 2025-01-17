import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offline_first_flutter/src/profile/data/remote/data_sources/profile_remote_database.dart';

import '../../../domain/entities/hive.dart';
import '../../../domain/entities/message.dart';

abstract class HiveRemoteDatabase {
  /// Returns a list of all the [Hive]s
  Stream<List<Hive>> list(String userId);

  /// Creates a new [Hive]
  Future<String> create(Hive hive);

  /// Updates an existing [Hive]
  Future<String> update(Hive hive);

  /// Deletes an existing [Hive]
  Future<String> delete(String hiveId);

  /// Joins an existing [Hive]
  Future<String> join({required String hiveId, required String userId});

  /// Leaves an existing [Hive]
  Future<String> leave({required String hiveId, required String userId});

  /// Returns details of a [Hive]
  Stream<Hive> details(String hiveId);

  /// Post a message to a [Hive]
  Future<String> postMessage({required String hiveId, required Message message});
}

class HiveRemoteDatabaseImpl implements HiveRemoteDatabase {
  final ProfileRemoteDatabase _profileRemoteDatabase;

  HiveRemoteDatabaseImpl(this._profileRemoteDatabase);

  @override
  Future<String> create(Hive hive) async {
    await FirebaseFirestore.instance.collection('hives').doc(hive.id).set(hive.toJson());
    return hive.id;
  }

  @override
  Future<String> delete(String hiveId) async {
    await FirebaseFirestore.instance.collection('hives').doc(hiveId).delete();
    return hiveId;
  }

  @override
  Future<String> join({required String hiveId, required String userId}) async {
    await FirebaseFirestore.instance.collection('hives').doc(hiveId).update({
      'members': FieldValue.arrayUnion([userId])
    });
    return hiveId;
  }

  @override
  Stream<List<Hive>> list(String userId) async* {
    yield* FirebaseFirestore.instance
        .collection('hives')
        .where('members', arrayContains: userId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Hive.fromJson(doc.data())).toList());
  }

  @override
  Future<String> update(Hive hive) async {
    await FirebaseFirestore.instance.collection('hives').doc(hive.id).update(hive.toJson());
    return hive.id;
  }

  @override
  Future<String> leave({required String hiveId, required String userId}) async {
    await FirebaseFirestore.instance.collection('hives').doc(hiveId).update({
      'members': FieldValue.arrayRemove([userId])
    });
    return hiveId;
  }

  @override
  Stream<Hive> details(String hiveId) async* {
    yield* FirebaseFirestore.instance
        .collection('hives')
        .doc(hiveId)
        .snapshots()
        .map((snapshot) => Hive.fromJson(snapshot.data()!));
  }

  @override
  Future<String> postMessage({required String hiveId, required Message message}) async {
    await FirebaseFirestore.instance.collection('hives').doc(hiveId).update({
      'conversations': FieldValue.arrayUnion([message.toJson()])
    });
    return hiveId;
  }
}
