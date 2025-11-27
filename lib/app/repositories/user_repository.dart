import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      print('Error fetching user $uid: $e');
      return null;
    }
  }

  Future<List<AppUser>> getUsers(List<String> uids) async {
    if (uids.isEmpty) return [];
    try {
      // Firestore 'in' query is limited to 10 items.
      // For simplicity in this iteration, we'll fetch individually or in batches.
      // Fetching individually for now as it's easier to implement and robust for small lists.
      // For production with large lists, we should use batched queries or pagination.
      final List<AppUser> users = [];
      for (final uid in uids) {
        final user = await getUser(uid);
        if (user != null) {
          users.add(user);
        }
      }
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}
