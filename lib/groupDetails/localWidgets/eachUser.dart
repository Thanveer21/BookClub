import 'package:BookWorms/models/user.dart';
import 'package:BookWorms/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachUser extends StatelessWidget {
  final OurUser user;
  final String groupId;

 

  EachUser({this.user, this.groupId});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(" Name: " + user.fullName,style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),),
                            Text(" Email: " +user.email,style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),),
                            
               SizedBox(
            height: 10,
          ),
                          ],
                          
      ),
      
    );
  }
}
