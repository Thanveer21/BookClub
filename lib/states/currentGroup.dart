import 'package:BookWorms/models/book.dart';
import 'package:BookWorms/models/group.dart';
import 'package:BookWorms/services/database.dart';
import 'package:flutter/cupertino.dart';

class CurrentGroup extends ChangeNotifier {
  OurGroup _currentGroup = OurGroup();
  OurBook _currentBook = OurBook();
  OurBook _nextBook = OurBook();
  bool _doneWithCurrentBook = false;
  bool _added = false;

  OurGroup get getCurrentGroup => _currentGroup;
  OurBook get getCurrentBook => _currentBook;
  OurBook get getNextBook => _nextBook;
  bool get getDoneWithCurrentBook => _doneWithCurrentBook;
  bool get isNextBook => _added;

  void updateStateFromDatabase(String groupId, String userUid) async {
    try {
      _currentGroup = await OurDatabase().getGroupInfo((groupId));
      _currentBook = await OurDatabase()
          .getCurrentBook(groupId, _currentGroup.currentBookId);
      _nextBook =
          await OurDatabase().getBookInfo(groupId, _currentGroup.nextBookId);
      _doneWithCurrentBook = await OurDatabase()
          .isUserDoneWithBook(groupId, _currentGroup.currentBookId, userUid);
      _added = await OurDatabase()
          .isUseraddbook(groupId, _currentGroup.currentBookId, userUid);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void finishedBook(String userUid, int rating, String review) async {
    try {
      await OurDatabase().finishedBook(_currentGroup.id,
          _currentGroup.currentBookId, userUid, rating, review);
      _doneWithCurrentBook = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
