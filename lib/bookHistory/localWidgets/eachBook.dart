import 'package:BookWorms/models/book.dart';
import 'package:BookWorms/reviewHistory/reviewHistory.dart';
import 'package:BookWorms/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachBook extends StatelessWidget {
  final OurBook book;
  final String groupId;

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId,
          bookId: book.id,
        ),
      ),
    );
  }

  EachBook({this.book, this.groupId});
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text("Name: "+
            book.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Author: "+
            book.author,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text("Reviews"),
            onPressed: () => _goToReviewHistory(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          )
        ],
      ),
    );
  }
}
