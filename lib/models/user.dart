import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String uid;
  String email;
  String fullName;
  Timestamp accountCreated;
  String groupId;

  OurUser({
    this.uid,
    this.email,
    this.fullName,
    this.accountCreated,
    this.groupId,
  });
  
  OurUser.fromDocumentSnapshot({DocumentSnapshot doc}) {
    uid = doc.documentID;
    email = doc.data['email'];
    accountCreated = doc.data['accountCreated'];
    fullName = doc.data['fullName'];
    groupId = doc.data['groupId'];
  }

}
