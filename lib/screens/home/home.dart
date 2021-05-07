import 'dart:async';
import 'package:BookWorms/bookHistory/bookHistory.dart';
import 'package:BookWorms/groupDetails/groupDetails.dart';
import 'package:BookWorms/screens/addBook/addBook.dart';
import 'package:BookWorms/screens/review/review.dart';
import 'package:BookWorms/screens/root/root.dart';
import 'package:BookWorms/services/database.dart';
import 'package:BookWorms/states/currentGroup.dart';
import 'package:BookWorms/states/currentUser.dart';
import 'package:BookWorms/utils/timeLeft.dart';
import 'package:BookWorms/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final key = new GlobalKey<ScaffoldState>();

  List<String> _timeUntil = List(2); //[0]-Time until book is due
  Timer _timer;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void _startTimer(CurrentGroup currentGroup) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeUntil = OurTimeLeft()
            .timeLeft(currentGroup.getCurrentGroup.currentBookDue.toDate());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    _currentGroup.updateStateFromDatabase(
        _currentUser.getCurrentUser.groupId, _currentUser.getCurrentUser.uid);
    _startTimer(_currentGroup);
  }

  @mustCallSuper
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _goToReview() {
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurReview(
            currentGroup: _currentGroup,
          ),
        ));
  }

  void _signOut(BuildContext context) async {
    String _returnString = await CurrentUser().signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    }
  }

  void _copyGroupId(BuildContext context) {
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    Clipboard.setData(ClipboardData(text: _currentGroup.getCurrentGroup.id));
    key.currentState.showSnackBar(SnackBar(
      content: Text("Copied!"),
    ));
  }

//Leave Group
  void _leaveGroup(BuildContext context) async {
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await OurDatabase().leaveGroup(
        _currentGroup.getCurrentGroup.id,
        _currentUser.getCurrentUser.uid,
        _currentUser.getCurrentUser.groupId,
        _currentGroup.getCurrentGroup.leader);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OurRoot(),
        ),
        (route) => false,
      );
    } else {
      key.currentState.showSnackBar(SnackBar(
        content: Text("You are the leader of the group, you can't leave"),
      ));
    }
  }

  void _goToBookHistory() {
    CurrentGroup group = Provider.of<CurrentGroup>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookHistory(
          groupId: group.getCurrentGroup.id,
        ),
      ),
    );
  }

  void _goToUserHistory() {
    CurrentGroup group = Provider.of<CurrentGroup>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetails(
          groupId: group.getCurrentGroup.id,
        ),
      ),
    );
  }

  void _addNewBook(BuildContext context) async {
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await OurDatabase().isLeader(
        _currentGroup.getCurrentGroup.id,
        _currentUser.getCurrentUser.uid,
        _currentUser.getCurrentUser.groupId,
        _currentGroup.getCurrentGroup.leader);
    if (_returnString != "success") {
      key.currentState.showSnackBar(SnackBar(
        content: Text("Only a leader can add the book"),
      ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OurAddBook(
              onGroupCreation: false,
              onError: false,
              groupName: _currentGroup.getCurrentGroup.name,
            ),
          ));
    }
  }

  String _getNextBook() {
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    String retVal;
    retVal = _currentGroup.getNextBook.name;
    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
            child: IconButton(
              onPressed: () => _signOut(context),
              iconSize: 30.0,
              icon: Icon(Icons.exit_to_app),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Consumer<CurrentGroup>(
                builder: (BuildContext context, value, Widget child) {
                  return Column(
                    children: <Widget>[
                      Text(
                        value.getCurrentBook.name ?? "loading..",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Due In: ",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey[600],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _timeUntil[0] ?? "loading...",
                                style: TextStyle(
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        child: Text(
                          "Finished Book",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed:
                            value.getDoneWithCurrentBook ? null : _goToReview,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          /*
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Consumer<CurrentGroup>(
                builder: (BuildContext context, value, Widget child) {
                  return Column(
                    children: <Widget>[
                      Text(
                        _getNextBook() ??
                            "Your leader hasn't yet revealed the book!!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      RaisedButton(
                        child: Text(
                          "Add Book ",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () => _addNewBook(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
*/
           Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Next book will\nbe revealed in: ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[600],
                          fontFamily: 'sans-serif'),
                    ),
                    Text(
                      _timeUntil[1] ?? "loading..",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 120.0, vertical: 20.0),
            child: RaisedButton(
              child: Text(
                "Club Details",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => _goToUserHistory(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 120.0, vertical: 20.0),
            child: RaisedButton(
              child: Text(
                "Club History",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => _goToBookHistory(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 120.0, vertical: 5.0),
            child: RaisedButton(
              child: Text(
                "Copy Group Id",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => _copyGroupId(context),
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 2,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: FlatButton(
              child: Text("Leave Group"),
              onPressed: () => _leaveGroup(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
