import 'package:BookWorms/models/user.dart';
import 'package:BookWorms/services/database.dart';
import 'package:flutter/material.dart';

import 'localWidgets/eachUser.dart';

class GroupDetails extends StatefulWidget {
  final String groupId;

  GroupDetails({
    this.groupId,
  });
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
   Future<List<OurUser>> users;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    users = OurDatabase().getUserHistory(widget.groupId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: users,
        builder: (BuildContext context, AsyncSnapshot<List<OurUser>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        BackButton(),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: EachUser(
                      user: snapshot.data[index - 1],
                      groupId: widget.groupId,
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}