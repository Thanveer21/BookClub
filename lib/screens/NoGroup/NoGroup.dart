import 'package:BookWorms/screens/JoinGroup/joinGroup.dart';
import 'package:BookWorms/screens/createGroup/createGroup.dart';
import 'package:BookWorms/screens/root/root.dart';
import 'package:BookWorms/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class OurNoGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    void _goToJoin(BuildContext context) {
      CurrentUser _currentUser = Provider.of<CurrentUser>(context,listen: false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurJoinGroup(
            userModel: _currentUser.getCurrentUser.uid,
          ),
        ),
      );
    }
    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurCreateGroup(),
        ),
      );
    }
 void _signOut(BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    }
  }
    return Scaffold(
      body: Column(
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.fromLTRB(0, 10.0, 20.0, 0),
            child: IconButton(
              onPressed: () => _signOut(context),
              iconSize: 30.0,
              icon: Icon(Icons.exit_to_app),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Image.asset("assets/logo-centr.jpeg"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Welcome to BookWorms",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 45.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "Since you are not in a book club, you can select either " +
                    "to join a club or create a club.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                )),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () => _goToCreate(context),
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 2,
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "Join",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () => _goToJoin(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
