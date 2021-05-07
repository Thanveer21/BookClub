import 'package:BookWorms/screens/login/localwidgets/loginform.dart';
import 'package:flutter/material.dart';

class OurLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Image.asset("assets/logo-centr.jpeg"),
              ),
              SizedBox(
                height: 10.0,
                width: 100.0,
              ),
              OurLoginForm()
            ],
          ))
        ],
      ),
    );
  }
}
