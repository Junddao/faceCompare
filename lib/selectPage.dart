import 'package:facecompare/comparepage.dart';
import 'package:facecompare/comparepage2.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Face Compare", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              child: Text(
                "혼자하기",
                style: TextStyle(fontSize: 50),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComparePage()),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              child: Text(
                "친구와 비교하기",
                style: TextStyle(fontSize: 50),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComparePage2()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
