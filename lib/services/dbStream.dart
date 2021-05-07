import 'package:BookWorms/models/group.dart';
import 'package:BookWorms/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBStream {
  Firestore _firestore = Firestore.instance;

  Stream<OurUser> getCurrentUser(String uid) {
    return _firestore
        .collection('users')
        .document(uid)
        .snapshots()
        .map((docSnapshot) => OurUser.fromDocumentSnapshot(doc: docSnapshot));
  }

  Stream<OurGroup> getCurrentGroup(String groupId) {
    return _firestore
        .collection('groups')
        .document(groupId)
        .snapshots()
        .map((docSnapshot) => OurGroup.fromDocumentSnapshot(doc: docSnapshot));
  }
}
