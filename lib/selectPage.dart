import 'package:facecompare/comparepage.dart';
import 'package:facecompare/comparepage2.dart';
import 'package:facecompare/data/appbarcontents.dart';
import 'package:facecompare/getContactsPage.dart';
import 'package:facecompare/manualpage.dart';
import 'package:facecompare/video_test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

// ignore: must_be_immutable
class _SelectPageState extends State<SelectPage> {
  String _url =
      'https://play.google.com/store/apps/details?id=com.jtb.facecompare';
  String friendPhoneNumber;
  int selectedGender; // 1 : man, 2 : women

  @override
  void initState() {
    selectedGender = 0;
    super.initState();

    InAppUpdate.checkForUpdate().then((update) {
      if (update.updateAvailable) {
        InAppUpdate.startFlexibleUpdate();
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("선택", style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return AppBarContants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }),
        ],
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
            femaleImage: AssetImage("assets/images/female.png"),
            maleImage: AssetImage("assets/images/male.png"),

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
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.person),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "싱글 모드",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w100),
                  ),
                ],
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
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.people),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "대전 모드",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w100),
                  ),
                ],
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
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.library_books),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "참고 사항",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManualPage()),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.check_circle_outline),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "어플 정확성 확인",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
              onPressed: () => (selectedGender == 0)
                  ? _showDialog(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VideoTestPage(selectedGender: selectedGender)),
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

  Future<void> choiceAction(String choice) async {
    await permission('contacts');
    friendPhoneNumber = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => GetContactPage()));
    await _sendSMS();
  }

  Future<void> _sendSMS() async {
    try {
      String smsMessage = '인공지능 얼굴평가 앱 다운로드를 초대합니다.\n';
      await sendSMS(
          message: smsMessage + _url, recipients: [friendPhoneNumber]);
      setState(() {});
    } catch (error) {
      setState(() {});
    }
  }

  Future<void> permission(String choice) async {
    if (choice == 'camera')
      await Permission.camera.request();
    else if (choice == 'contacts') await Permission.contacts.request();
  }
}
