import 'package:facecompare/comparepage.dart';
import 'package:facecompare/comparepage2.dart';
import 'package:facecompare/constants.dart';
import 'package:facecompare/data/appbarcontents.dart';
import 'package:facecompare/getContactsPage.dart';
import 'package:facecompare/manualpage.dart';
import 'package:facecompare/model/category.dart';
import 'package:facecompare/size_config.dart';
import 'package:facecompare/video_test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  bool selectedGender; // true : man, false : women

  @override
  void initState() {
    selectedGender = true;
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
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Face Compare", style: TextStyle(color: Colors.black)),
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
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 30),
          Container(
            height: 130,
            width: SizeConfig.screenWidth * 0.9,
            child: Stack(
              children: [
                Positioned(
                    child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          color: Colors.grey,
                        )
                      ]),
                )),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                      height: 80,
                      width: 202,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: kTextColor),
                            children: [
                              TextSpan(
                                  text: "성별을 선택하세요.",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      )),
                ),
                Positioned(
                  top: 50,
                  left: 30,
                  child: Container(
                      height: 80,
                      width: 202,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: kTextColor),
                            children: [
                              TextSpan(
                                  text:
                                      selectedGender == false ? 'Women' : "Man",
                                  style: selectedGender == false
                                      ? TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red)
                                      : TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blue)),
                            ]),
                      )),
                ),
                Positioned(
                  top: 30,
                  right: 30,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: 30.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: selectedGender
                            ? Colors.blueAccent[100].withOpacity(0.15)
                            : Colors.redAccent[100].withOpacity(0.15)),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          child: InkWell(
                              onTap: selectedGenderButton,
                              child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: selectedGender
                                      ? Icon(Icons.add_circle_outline,
                                          color: Colors.blue,
                                          size: 25.0,
                                          key: UniqueKey())
                                      : Icon(Icons.remove_circle_outline,
                                          color: Colors.red,
                                          size: 25.0,
                                          key: UniqueKey()))),
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          top: 3.0,
                          left: selectedGender ? 40.0 : 0.0,
                          right: selectedGender ? 0.0 : 40.0,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // SizedBox(height: 10),
          Expanded(
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(20),
              crossAxisCount: 2,
              itemCount: categories.length,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: index.isEven ? 200 : 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(categories[index].image),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 10,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () => {openPage(context, index)},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          categories[index].name,
                          style: kTitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            ),
          ),
        ],
      ),
    );
  }

  selectedGenderButton() {
    setState(() {
      selectedGender = !selectedGender;
    });
  }

  // void _showDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  //         // title: new Text(""),
  //         content: SingleChildScrollView(child: new Text("성별을 먼저 선택하세요.")),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Close"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

  openPage(context, index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ComparePage(selectedGender: selectedGender)),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ComparePage2(selectedGender: selectedGender)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManualPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VideoTestPage(selectedGender: selectedGender)),
      );
    }
  }
}
