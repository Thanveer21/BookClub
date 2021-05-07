import 'package:BookWorms/models/book.dart';
import 'package:BookWorms/models/user.dart';
import 'package:BookWorms/screens/root/root.dart';
import 'package:BookWorms/services/database.dart';
import 'package:BookWorms/states/currentUser.dart';
import 'package:BookWorms/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OurAddBook extends StatefulWidget {
  final bool onGroupCreation;
  final bool onError;
  final String groupName;
  final OurUser currentUser;

  OurAddBook({
    this.onGroupCreation,
    this.onError,
    this.groupName,
    this.currentUser,
  });
  @override
  _OurAddBookState createState() => _OurAddBookState();
}

class _OurAddBookState extends State<OurAddBook> {
  final addBookKey = GlobalKey<ScaffoldState>();
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, 0, 0, 0, 0);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        await DatePicker.showDateTimePicker(context, showTitleActions: true);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addBook(BuildContext context, String groupName, OurBook book) async {
    String _returnString;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    OurUser user = OurUser();
    user.fullName = currentUser.getCurrentUserName.fullName;
    user.email = currentUser.getCurrentUserName.email;
    user.accountCreated = currentUser.getCurrentUser.accountCreated;
    if (_selectedDate.isAfter(DateTime.now().add(Duration(days: 1)))) {
      if (widget.onGroupCreation) {
        _returnString = await OurDatabase()
            .createGroup(groupName, currentUser.getCurrentUser.uid, book,user);
      } else if (widget.onError) {
        _returnString = await OurDatabase()
            .addCurrentBook(currentUser.getCurrentUser.groupId, book);
      } else {
        _returnString = await OurDatabase()
            .addNextBook(currentUser.getCurrentUser.groupId, book);
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OurRoot(),
            ),
            (route) => false);
      }
    } else {
      addBookKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Due date is less that a day from now!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addBookKey,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.book),
                      hintText: "Book Name",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: "Author",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.format_list_numbered),
                      hintText: "Length",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                  Text(DateFormat("H:mm").format(_selectedDate)),
                  FlatButton(
                    child: Text("Change Date"),
                    onPressed: () => _selectDate(context),
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      OurBook book = OurBook();
                      book.name = _bookNameController.text;
                      book.author = _authorController.text;
                      book.length = int.parse(_lengthController.text);
                      book.dateCompleted = Timestamp.fromDate(_selectedDate);

                      _addBook(context, widget.groupName, book);
                    },
                     shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
