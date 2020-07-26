import 'package:facecompare/comparepage.dart';
import 'package:facecompare/comparepage2.dart';
import 'package:facecompare/manualpage.dart';
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
                "Single play",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.w100),
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
                "VS Mode",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                    fontWeight: FontWeight.w100),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComparePage2()),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              child: Text(
                "참고 사항",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w100),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManualPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
