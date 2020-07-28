import 'package:facecompare/comparepage.dart';
import 'package:facecompare/comparepage2.dart';
import 'package:facecompare/manualpage.dart';
import 'package:flutter/material.dart';
import 'package:gender_selection/gender_selection.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

// ignore: must_be_immutable
class _SelectPageState extends State<SelectPage> {
  int selectedGender = 0; // 1 : man, 2 : women

  @override
  void initState() {
    super.initState();
  }

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
          GenderSelection(
            maleText: "남", //default Male
            femaleText: "여", //default Female
            linearGradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.green,
              ],
            ),
            selectedGenderIconBackgroundColor: Colors.indigo, // default red
            checkIconAlignment: Alignment.centerRight, // default bottomRight
            selectedGenderCheckIcon: null, // default Icons.check
            onChanged: (Gender gender) {
              print(gender);
              selectedGender = gender.index + 1;
            },
            equallyAligned: true,
            animationDuration: Duration(milliseconds: 400),
            isCircular: true, // default : true,
            isSelectedGenderIconCircular: true,
            opacityOfGradient: 0.6,
            padding: const EdgeInsets.all(3),
            size: 120, //default : 120
          ),
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
              onPressed: () => (selectedGender == 0)
                  ? _showDialog(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ComparePage(selectedGender: selectedGender)),
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
              onPressed: () => (selectedGender == 0)
                  ? _showDialog(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ComparePage2(selectedGender: selectedGender))),
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          // title: new Text(""),
          content: SingleChildScrollView(child: new Text("성별을 먼저 선택하세요.")),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
