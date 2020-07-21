import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class ComparePage2 extends StatefulWidget {
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage2> {
  bool _isLoading;
  File _image;
  List _output;

  final picker = ImagePicker();

  // 최종 출력 결과값을 가지는 변수
  List<double> liResultScore = new List<double>();
  List<String> liResultTitle = new List<String>();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Appbar 높이만큼 띄우기
                    Padding(padding: EdgeInsets.only(top: statusBarHeight + 5)),
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        height: size.width,
                        child: _image == null
                            ? Container()
                            : Stack(children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  height: size.height * 0.7,
                                  child: Container(
                                    width: size.width * 0.7,
                                    height: size.width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        )),
                                  ),
                                )
                              ]),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text('VS'),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        height: size.width,
                        child: _image == null
                            ? Container()
                            : Stack(children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                // Positioned(
                                //   right: 0,
                                //   bottom: size.width / 2,
                                //   child: Container(
                                //     width: size.width *0.7,
                                //     height: size.width *0.2,
                                //     decoration: BoxDecoration(
                                //       color: Colors.white.withOpacity(0.9),
                                //       borderRadius: BorderRadius.only(
                                //         bottomLeft: Radius.circular(20),
                                //         topLeft: Radius.circular(20),
                                //       )
                                //     ),
                                //   ),)
                              ]),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('결과 보기'),
                        onPressed: () => {
                          getResult(),
                          refreshScreen(),
                        },
                      ),
                    )
                    // _output == null
                    //     ? Text("")
                    //     : Text("${_output[0]["label"]}" +
                    //         "  " +
                    //         "${_output[0]["confidence"]}")
                  ],
                )),
              ],
            ),
      floatingActionButton: SpeedDial(
        // both default to 16
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        // tooltip: 'Speed Dial',
        // heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.image),
            backgroundColor: Colors.red,
            label: 'Player 2',
            labelStyle: TextStyle(fontSize: 12.0),
            onTap: () => setState(() {
              createAlertDialog(context);
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.image),
            backgroundColor: Colors.blue,
            label: 'Player 1',
            labelStyle: TextStyle(fontSize: 12.0),
            onTap: () => setState(() {
              createAlertDialog(context);
            }),
          ),
        ],
      ),
    );
  }

  String percentIndicator(Size size, List output) {
    String strScore;

    List<double> liFaceScore = new List<double>();
    List<String> liFaceTitle = new List<String>();

    double myBestScore = 0.0;
    String myStyle;
    String comment = "사진을 선택하세요.";
    double totalScore = 0.0;

    //이전 결과��� 초기화
    liResultScore.clear();
    liResultTitle.clear();

    liResultScore.add(0.0);
    liResultScore.add(0.0);
    liResultScore.add(0.0);
    liResultScore.add(0.0);
    liResultScore.add(0.0);

    liResultTitle.add("0 sexy");
    liResultTitle.add("1 cute");
    liResultTitle.add("2 ruggedly");
    liResultTitle.add("3 handsome");
    liResultTitle.add("4 ugly");

    // 결과값 가져와서
    if (output != null) {
      List _output = output;
      for (int i = 0; i < _output.length; i++) {
        liFaceTitle.add(_output[i]["label"]);
        liFaceScore.add(_output[i]["confidence"]);
      }
      //출력 리스트에 복사
      for (int i = 0; i < liResultTitle.length; i++) {
        for (int j = 0; j < liFaceTitle.length; j++) {
          if (liResultTitle[i] == liFaceTitle[j]) {
            liResultScore[i] = liFaceScore[j];
            if (liResultScore[i] > myBestScore) {
              myBestScore = liResultScore[i];
              myStyle = liResultTitle[i];
            }
            if (liResultTitle[i].contains('sexy')) {
              totalScore =
                  totalScore + liResultScore[i] - (liResultScore[i] * 0.05);
            } else if (liResultTitle[i].contains('cute')) {
              totalScore =
                  totalScore + liResultScore[i] - (liResultScore[i] * 0.09);
            } else if (liResultTitle[i].contains('ruggedly')) {
              totalScore =
                  totalScore + liResultScore[i] - (liResultScore[i] * 0.05);
            } else if (liResultTitle[i].contains('handsome')) {
              totalScore += liResultScore[i];
            } else if (liResultTitle[i].contains('ugly')) {
              totalScore -= liResultScore[i] / 20;
              if (totalScore < 0) totalScore = 0;
            }

            break;
          }
        }
      }
      if (myStyle.contains('sexy')) {
        comment = '당신은 섹시한 스타일 입니다.\n닮은 연애인은 서강준, 서인국, 유아인 등이 있습니다.';
      } else if (myStyle.contains('cute')) {
        comment = '당신은 귀여운 스타일 입니다.\n닮은 연예인은 박보검, 피오, 헨리 등이 있습니다.';
      } else if (myStyle.contains('ruggedly')) {
        comment = '당신은 남자다운 스타일 입니다.\n닮은 연예���은 고수, 소지섭, 송승헌 등이 있습니다.';
      } else if (myStyle.contains('handsome')) {
        comment = '당신은 잘생겼습니다.\n닮은 연예인은 장동건, 원빈, 강동���, 정우성, 현빈 등이 있습니다.';
      } else if (myStyle.contains('ugly')) {
        comment = '당신은 못생겼습니다.';
      }
    }
    return strScore;
  }

  chooseImage(String select) async {
    var image;
    if (select == 'camera')
      image = await picker.getImage(source: ImageSource.camera);
    else if (select == 'gallery')
      image = await picker.getImage(source: ImageSource.gallery);
    else
      image = null;

    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = File(image.path);
    });
    runModelOnImage(_image);
  }

  runModelOnImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: _image.path,
        // numResults: 5,
        // imageMean: 117.5,
        // imageStd: 0.1,
        // threshold: 0.1,
        imageMean: 127.5, // defaults to 117.0
        imageStd: 127.5, // defaults to 1.0
        numResults: 5, // defaults to 5
        threshold: 0.001, // defaults to 0.1
        asynch: true // defaults to true
        );
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  getResult() {}

  refreshScreen() {}

  createAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            // title: Text('Input Phone Number'),
            // content: TextField(
            //   controller: customController,
            // ),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 200.0,
                child: FlatButton(
                  textColor: Colors.black,
                  color: Colors.red[200],
                  child: Text('카메라로 촬영'),
                  onPressed: () {
                    chooseImage('camera');
                    Navigator.pop(context);
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 200.0,
                child: FlatButton(
                  textColor: Colors.black,
                  color: Colors.yellow,
                  child: Text('갤러리에서 찾기'),
                  onPressed: () {
                    chooseImage('gallery');
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }
}
