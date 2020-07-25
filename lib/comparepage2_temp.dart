import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class ComparePage2 extends StatefulWidget {
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage2> {
  bool _isLoading;
  File _image1;
  File _image2;
  List _output1;
  List _output2;

  final picker = ImagePicker();

  // 최종 출력 결과값을 가지는 변수
  List<double> liResultScore = new List<double>();
  List<String> liResultTitle = new List<String>();

  double player1Score = 0.0;
  double player2Score = 0.0;

  String player1Result = '';
  String player2Result = '';

  bool tcVisibility = false;

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
                        child: _image1 == null
                            ? Container()
                            : Stack(children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _image1,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  // right: 0,
                                  // bottom: size.width * 0.1,
                                  top: size.height * 0.1,
                                  child: Visibility(
                                    visible: tcVisibility,
                                    child: Container(
                                        width: Image.file(_image1,
                                                fit: BoxFit.contain)
                                            .width,
                                        height: Image.file(_image1,
                                                fit: BoxFit.contain)
                                            .height,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              (player1Score * 100)
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              player1Result,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ]),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('VS',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        height: size.width,
                        child: _image2 == null
                            ? Container()
                            : Stack(children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _image2,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  // bottom: size.width * 0.1,
                                  child: Visibility(
                                    visible: tcVisibility,
                                    child: Container(
                                        width: Image.file(_image2,
                                                fit: BoxFit.contain)
                                            .width,
                                        height: Image.file(_image2,
                                                fit: BoxFit.contain)
                                            .height,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              (player2Score * 100)
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              player2Result,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ]),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('결과 보기'),
                        onPressed: () => setState(() {
                          getResult(size);
                          refreshScreen();
                        }),
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
              createAlertDialog(context, 2);
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.image),
            backgroundColor: Colors.blue,
            label: 'Player 1',
            labelStyle: TextStyle(fontSize: 12.0),
            onTap: () => setState(() {
              createAlertDialog(context, 1);
            }),
          ),
        ],
      ),
    );
  }

  double getScore(Size size, List output) {
    List<double> liFaceScore = new List<double>();
    List<String> liFaceTitle = new List<String>();

    double myBestScore = 0.0;

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
    }
    return totalScore;
  }

  chooseImage(String select, int player) async {
    var image;
    if (select == 'camera')
      image = await picker.getImage(source: ImageSource.camera);
    else if (select == 'gallery')
      image = await picker.getImage(source: ImageSource.gallery);
    else
      image = null;

    if (image == null) return null;
    if (player == 1) {
      setState(() {
        _isLoading = true;
        _image1 = File(image.path);
      });
      runModelOnImage(_image1, player);
    } else {
      setState(() {
        _isLoading = true;
        _image2 = File(image.path);
      });
      runModelOnImage(_image2, player);
    }
  }

  runModelOnImage(File image, int player) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
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
      if (player == 1)
        _output1 = output;
      else
        _output2 = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  getResult(Size size) {
    player1Score = getScore(size, _output1);
    player2Score = getScore(size, _output2);

    if (player1Score < player2Score) {
      player1Result = 'LOSE';
      player2Result = 'WIN';
    } else if (player1Score > player2Score) {
      player1Result = 'WIN';
      player2Result = 'LOSE';
    } else {
      player1Result = 'SAME';
      player2Result = 'SAME';
    }
  }

  refreshScreen() {
    tcVisibility = true;
  }

  createAlertDialog(BuildContext context, int player) async {
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
                    chooseImage('camera', player);
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
                    chooseImage('gallery', player);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }
}
