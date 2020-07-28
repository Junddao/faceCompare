import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'service/admob_service.dart';
import 'package:firebase_admob/firebase_admob.dart';

class ComparePage2 extends StatefulWidget {
  final int selectedGender;

  ComparePage2({Key key, @required this.selectedGender}) : super(key: key);
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage2> {
  final ams = AdMobService();

  bool _isLoading;
  File _image1;
  File _image2;
  List _output1;
  List _output2;

  String mlModel;
  String mlLabel;

  final picker = ImagePicker();

  // 최종 출력 결과값을 가지는 변수
  List<double> liResultScore = new List<double>();
  List<String> liResultTitle = new List<String>();

  double player1Score = 0.0;
  double player2Score = 0.0;

  String player1Result = '';
  String player2Result = '';

  bool tcVisibility = false;
  bool bReset = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedGender == 1) {
      mlModel = "assets/model_unquant1.tflite";
      mlLabel = "assets/labels1.txt";
    } else if (widget.selectedGender == 2) {
      mlModel = "assets/model_unquant2.tflite";
      mlLabel = "assets/labels2.txt";
    }
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
                      flex: 5,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10),
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
                                  bottom: 0,
                                  child: Visibility(
                                    visible: tcVisibility,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            getWinner(player1Result),
                                          ],
                                        )),
                                  ),
                                ),
                              ]),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                //margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.topLeft,
                                child: Visibility(
                                  visible: tcVisibility,
                                  child: getPlayer1Score(),
                                ),
                              ),
                              Text('    VS    ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w100)),
                              Container(
                                //margin: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.bottomRight,
                                child: Visibility(
                                  visible: tcVisibility,
                                  child: getPlayer2Score(),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
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
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            getWinner(player2Result),
                                          ],
                                        )),
                                  ),
                                ),
                              ]),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: resultButton(size),
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
        visible: !tcVisibility, //결과 출력되면 없애기
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

    double totalScore = 0.0;

    //이전 결과��� 초기화
    liResultScore.clear();
    liResultTitle.clear();

    liResultScore.add(0.0);
    liResultScore.add(0.0);

    liResultTitle.add("0 good");
    liResultTitle.add("1 bad");

    // 결과값 가져와서
    if (output != null) {
      List _output = output;
      for (int i = 0; i < _output.length; i++) {
        liFaceTitle.add(_output[i]["label"]);
        liFaceScore.add(_output[i]["confidence"]);
      }
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
            }
          }
        }
      }
    }

    totalScore = liResultScore[0]; // good score
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
        numResults: 2, // defaults to 5
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
    await Tflite.loadModel(model: mlModel, labels: mlLabel);
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

  void initScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ComparePage2(
          selectedGender: widget.selectedGender,
        ),
        transitionDuration: Duration.zero,
      ),
    );
  }

  Widget getPlayer1Score() {
    double player1resultScore;
    double temp = 100 / (player1Score + player2Score);
    if (player1Score == player2Score) {
      player1resultScore = 50;
    } else if (player2Score == 0) {
      player1resultScore = 100;
    } else
      player1resultScore = player1Score * temp;

    return Text(player1resultScore.toStringAsFixed(1),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200));
  }

  Widget getPlayer2Score() {
    double player2resultScore;
    double temp = 100 / (player1Score + player2Score);
    if (player1Score == player2Score) {
      player2resultScore = 50;
    } else if (player1Score == 0) {
      player2resultScore = 100;
    } else {
      player2resultScore = player2Score * temp;
    }

    return Text(player2resultScore.toStringAsFixed(1),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200));
  }

  Widget getWinner(playerResult) {
    Color resultColor;

    if (playerResult == 'WIN')
      resultColor = Colors.blue;
    else
      resultColor = Colors.red;
    return Text(
      playerResult,
      style: TextStyle(
          fontSize: 40, fontWeight: FontWeight.bold, color: resultColor),
    );
  }

  Widget resultButton(Size size) {
    InterstitialAd newAd = ams.getNewInterstitial();
    newAd.load();

    String buttonName;
    Color buttonColor;
    String selectMode;

    if (_output1 == null || _output2 == null) {
      // buttonName = 'Select Image  →→';
      buttonName = 'Welcome   : )';
      buttonColor = Colors.black;
      selectMode = 'select';
    } else {
      if (bReset == false) {
        buttonName = '눌러서 결과확인';
        buttonColor = Colors.blue;
        selectMode = 'go';
      } else {
        buttonName = '다시 하기';
        buttonColor = Colors.red;
        selectMode = 'retry';
      }
    }
    return FlatButton(
        // shape: new RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(10.0)),
        child: Text(buttonName,
            style: TextStyle(
                fontSize: 20, color: buttonColor, fontWeight: FontWeight.w200)),
        onPressed: () async {
          if (selectMode == 'go') {
            newAd.show(
              anchorType: AnchorType.bottom,
              anchorOffset: 0.0,
              horizontalCenterOffset: 0.0,
            );

            bReset = true;

            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                getResult(size);
                refreshScreen();
              });
            });
            //
          } else if (selectMode == 'retry') {
            bReset = false;
            initScreen();
          }
        });
  }
}
