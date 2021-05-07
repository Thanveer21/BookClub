import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup {
  String id;
  String name;
  String leader;
  List<String> members;
  Timestamp groupCreated;
  String currentBookId;
  Timestamp currentBookDue;
  int indexPickingBook;
  String nextBookId;
  Timestamp nextBookDue;

  OurGroup({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
    this.currentBookId,
    this.currentBookDue,
    this.indexPickingBook,
    this.nextBookId,
    this.nextBookDue,
  });
  OurGroup.fromDocumentSnapshot({DocumentSnapshot doc}) {
    id = doc.documentID;
    name = doc.data["name"];
    leader = doc.data["leader"];
    members = List<String>.from(doc.data["members"]);
    groupCreated = doc.data["groupCreated"];
    currentBookId = doc.data["currentBookId"];
    currentBookDue = doc.data["currentBookDue"];
    indexPickingBook = doc.data["indexPickingBook"];
    nextBookId = doc.data["nextBookId"];
    nextBookDue = doc.data["nextBookDue"];
  }
}
