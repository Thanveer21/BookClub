import 'package:BookWorms/screens/NoGroup/NoGroup.dart';
import 'package:BookWorms/screens/home/home.dart';
import 'package:BookWorms/screens/login/login.dart';
import 'package:BookWorms/screens/splashScreen/splashScreen.dart';
import 'package:BookWorms/states/currentGroup.dart';
import 'package:BookWorms/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus { unknown, notLoggedIn, notInGroup, inGroup }

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;

  @override
  void didChangeDependencies() async {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    //get the state, check current user, set AuthStatus based on status
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await _currentUser.onStartUp();
    if (returnString == "success") {
      if (_currentUser.getCurrentUser.groupId != null) {
        setState(() {
          _authStatus = AuthStatus.inGroup;
        });
      } else {
        setState(() {
          _authStatus = AuthStatus.notInGroup;
        });
      }
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;
    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;
      case AuthStatus.notInGroup:
        retVal = OurNoGroup();
        break;
      case AuthStatus.inGroup:
        retVal = ChangeNotifierProvider(
            create: (context) => CurrentGroup(), child: HomeScreen());
        break;
      default:
    }
    return retVal;
  }
}
