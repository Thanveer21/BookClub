import 'package:BookWorms/models/book.dart';
import 'package:BookWorms/models/group.dart';
import 'package:BookWorms/models/reviewModel.dart';
import 'package:BookWorms/models/user.dart';
import 'package:BookWorms/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OurDatabase {
  final Firestore _firestore = Firestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = "error";
    try {
      await _firestore.collection("users").document(user.uid).setData({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").document(uid).get();
      retVal.uid = uid;
      retVal.fullName = _docSnapshot.data["fullName"];
      retVal.email = _docSnapshot.data["email"];
      retVal.accountCreated = _docSnapshot.data["accountCreated"];
      retVal.groupId = _docSnapshot.data["groupId"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurUser> getUserName(String uid) async {
    OurUser retVal = OurUser();
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").document(uid).get();
      retVal.fullName = _docSnapshot.data["fullName"];
       retVal.email = _docSnapshot.data["email"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<CurrentUser> getUserInfofor(String uid) async {
    CurrentUser retVal = CurrentUser();
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").document(uid).get();
      retVal.getCurrentUser.uid = uid;
      retVal.getCurrentUser.fullName = _docSnapshot.data["fullName"];
      retVal.getCurrentUser.email = _docSnapshot.data["email"];
      retVal.getCurrentUser.accountCreated =
          _docSnapshot.data["accountCreated"];
      retVal.getCurrentUser.groupId = _docSnapshot.data["groupId"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createGroup(
      String groupName, String user, OurBook initialBook, OurUser _user) async {
    String retVal = "error";
    List<String> members = List();
    try {
      members.add(user);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        'name': groupName,
        'leader': user,
        'members': members,
        'groupCreate': Timestamp.now(),
        'nextBookId': "waiting",
        'indexPickingBook': 0
      });

      //add a book

      await _firestore.collection("users").document(user).updateData({
        'groupId': _docRef.documentID,
      });

      addBook(_docRef.documentID, initialBook);
      addUser(_docRef.documentID, _user);
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid, OurUser user) async {
    String retVal = "error";
    List<String> members = List();

    try {
      members.add(userUid);
      await _firestore.collection("groups").document(groupId).updateData({
        'members': FieldValue.arrayUnion(members),
      });
      await _firestore.collection("users").document(userUid).updateData({
        'groupId': groupId,
      });
      addUser(groupId, user);
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurGroup> getGroupInfo(String groupId) async {
    OurGroup retVal = OurGroup();
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("groups").document(groupId).get();
      retVal.id = groupId;
      retVal.name = _docSnapshot.data["name"];
      retVal.leader = _docSnapshot.data["leader"];
      retVal.members = List<String>.from(_docSnapshot.data["members"]);
      retVal.groupCreated = _docSnapshot.data["groupCreated"];
      retVal.currentBookId = _docSnapshot.data["currentBookId"];
      retVal.currentBookDue = _docSnapshot.data["currentBookDue"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> addBook(String groupId, OurBook book) async {
    String retVal = "error";
    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted
      });
      await _firestore.collection("groups").document(groupId).updateData({
        "currentBookId": _docRef.documentID,
        "currentBookDue": book.dateCompleted
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> addUser(String groupId, OurUser user) async {
    String retVal = "error";
    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("user")
          .add({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': user.accountCreated,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurBook> getCurrentBook(String groupId, String bookId) async {
    OurBook retVal = OurBook();
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .get();
      retVal.id = bookId;
      retVal.name = _docSnapshot.data["name"];
      retVal.author = _docSnapshot.data["author"];
      retVal.length = _docSnapshot.data["length"];
      retVal.dateCompleted = _docSnapshot.data["dateCompleted"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurBook> getBookInfo(String groupId, String bookId) async {
    OurBook retVal = OurBook();
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .get();
      retVal.id = bookId;
      retVal.name = _docSnapshot.data["name"];
      retVal.author = _docSnapshot.data["author"];
      retVal.length = _docSnapshot.data["length"];
      retVal.dateCompleted = _docSnapshot.data["dateCompleted"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> addCurrentBook(String groupId, OurBook book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await _firestore.collection("groups").document(groupId).updateData({
        "currentBookId": _docRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextBook(String groupId, OurBook book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await _firestore.collection("groups").document(groupId).updateData({
        "nextBookId": _docRef.documentID,
        "nextBookDue": book.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> finishedBook(
    String groupId,
    String bookId,
    String uid,
    int rating,
    String review,
  ) async {
    String retval = "error";
    try {
      await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .document(uid)
          .setData({
        'rating': rating,
        'review': review,
      });
    } catch (e) {
      print(e);
    }
    return retval;
  }

  Future<bool> isUserDoneWithBook(
      String groupId, String bookId, String uid) async {
    bool retval = false;
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .document(uid)
          .get();
      if (_docSnapshot.exists) {
        retval = true;
      }
    } catch (e) {
      print(e);
    }
    return retval;
  }

  Future<bool> isUseraddbook(String groupId, String bookId, String uid) async {
    bool retval = false;
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .get();
      if (_docSnapshot.exists) {
        retval = true;
      }
    } catch (e) {
      print(e);
    }
    return retval;
  }

  Future<String> leaveGroup(
      String groupId, String userId, String leader, String gleader) async {
    String retVal = "error";
    List<String> members = List();
    try {
      members.add(userId);
      if (userId != gleader) {
        await _firestore.collection("groups").document(groupId).updateData({
          'members': FieldValue.arrayRemove(members),
        });

        await _firestore.collection("users").document(userId).updateData({
          'groupId': null,
        });
        retVal = "success";
      } else {
        retVal = "error";
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> isLeader(
      String groupId, String userId, String leader, String gleader) async {
    String retVal = "error";
    try {
      if (userId != gleader) {
        retVal = "error";
      } else {
        retVal = "success";
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<ReviewModel>> getReviewHistory(
      String groupId, String bookId) async {
    List<ReviewModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .getDocuments();

      query.documents.forEach((element) {
        retVal.add(ReviewModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<OurBook>> getBookHistory(String groupId) async {
    List<OurBook> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .orderBy("dateCompleted", descending: true)
          .getDocuments();
      query.documents.forEach((element) {
        retVal.add(OurBook.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }
   Future<List<OurUser>> getUserHistory(String groupId) async {
    List<OurUser> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("user")
          .orderBy("accountCreated", descending: true)
          .getDocuments();
      query.documents.forEach((element) {
        retVal.add(OurUser.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
