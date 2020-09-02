import 'dart:io';
import 'package:facecompare/service/admob_service.dart';
import 'package:facecompare/size_config.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_charts/multi_charts.dart';

import 'constants.dart';

class ComparePage extends StatefulWidget {
  final bool selectedGender;
  ComparePage({Key key, @required this.selectedGender}) : super(key: key);
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  final ams = AdMobService();

  bool _isLoading;
  File _image;
  List _output;

  String mlModel;
  String mlLabel;
  bool _visibleChart;

  final picker = ImagePicker();

  // 최종 출력 결과값을 가지는 변수
  List<double> liResultScore = new List<double>();
  List<String> liResultTitle = new List<String>();

  int score;
  String rank;
  String comment;

  @override
  void initState() {
    if (widget.selectedGender == false) {
      mlModel = "assets/model_unquant1.tflite";
      mlLabel = "assets/labels1.txt";
    } else if (widget.selectedGender == true) {
      mlModel = "assets/model_unquant3.tflite";
      mlLabel = "assets/labels3.txt";
    }
    _isLoading = true;
    _visibleChart = false;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    comment = '사진을 선택해주세요.';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Appbar 높이만큼 띄우기
                Padding(padding: EdgeInsets.only(top: statusBarHeight + 5)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 10,
                                    color: Colors.grey,
                                  )
                                ]),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: RichText(
                                    text: TextSpan(
                                        style: kSubtitleTextSyule,
                                        children: [
                                          TextSpan(
                                              text: 'Score',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  top: 60,
                                  left: 10,
                                  child: RichText(
                                    text: TextSpan(
                                        style: kHeadingextStyle,
                                        children: [
                                          TextSpan(
                                              text: score?.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: ' / 100',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10)),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 10,
                                    color: Colors.grey,
                                  )
                                ]),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: RichText(
                                    text: TextSpan(
                                        style: kSubtitleTextSyule,
                                        children: [
                                          TextSpan(
                                              text: 'Rank',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  top: 60,
                                  left: 10,
                                  child: RichText(
                                    text: TextSpan(
                                        style: kHeadingextStyle,
                                        children: [
                                          TextSpan(
                                              text: rank?.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            alignment: Alignment.center,
                            height: 150,

                            // height: SizeConfig.screenWidth * 0.5,
                            child: _image == null
                                ? Container()
                                : Stack(children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: getImage(),
                                    ),
                                  ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              color: Colors.grey,
                            )
                          ]),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: kTextColor),
                                  children: [
                                    TextSpan(
                                        text: comment,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: percentIndicator(_output),
                ),
              ],
            )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          createAlertDialog(context);
        },
        child: Icon(Icons.image),
      ),
    );
  }

  Widget percentIndicator(List output) {
    List<double> liFaceScore = new List<double>();
    List<String> liFaceTitle = new List<String>();

    //이전 결과값 초기화
    liResultScore.clear();
    liResultTitle.clear();

    liResultScore.add(0.0);
    liResultScore.add(0.0);
    liResultScore.add(0.0);
    liResultScore.add(0.0);
    liResultScore.add(0.0);

    liResultTitle.add("sexy");
    liResultTitle.add("cute");
    liResultTitle.add("ruggedly");
    liResultTitle.add("handsome");
    liResultTitle.add("ugly");

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
          if (liFaceTitle[j].contains(liResultTitle[i])) {
            liResultScore[i] = liFaceScore[j] * 100;
          }
        }
      }
    }

    // score 계산
    calcScoreAndRank();

    List<double> liChartValue = new List<double>();
    for (var value in liResultScore) {
      value += 2;
      if (value + 2 > 100) value = 100;
      liChartValue.add(value);
    }
    return new SafeArea(
        child: Visibility(
            visible: _visibleChart,
            child: RadarChart(
              values: liChartValue,
              labels: ['섹시', '큐트', '남자다움', '잘생김', '못생김'],
              maxValue: 100,
              fillColor: Colors.redAccent,
              chartRadiusFactor: 0.8,
            )));
  }

  void calcScoreAndRank() {
    double sum = 0.0;
    for (int i = 0; i < liResultScore.length; i++) {
      sum += liResultScore[i];
    }
    score = sum.round();
    if (score >= 95)
      rank = 'A+';
    else if (score < 95 && score >= 90)
      rank = 'A';
    else if (score < 90 && score >= 85)
      rank = 'B+';
    else if (score < 85 && score >= 80)
      rank = 'B';
    else if (score < 80 && score >= 75)
      rank = 'C+';
    else if (score < 75 && score >= 70)
      rank = 'C';
    else if (score < 70 && score >= 65)
      rank = 'D+';
    else if (score < 65 && score >= 60)
      rank = 'D';
    else if (score < 60) rank = 'F';

    double bestScore = 0;
    int bestScoreItemIndex = 0;
    for (int i = 0; i < liResultScore.length; i++) {
      if (liResultScore[i] > bestScore) {
        bestScore = liResultScore[i];
        bestScoreItemIndex = i;
      }
    }

    switch (bestScoreItemIndex) {
      case 0:
        comment = '이동욱, 유아인, 서인국과 닮은꼴 입니다.';
        break;
      case 1:
        comment = '박보검, 헨리, 피오와 닮은꼴 입니다.';
        break;
      case 2:
        comment = '하정우, 이병헌, 송승헌과 닮은꼴 입니다.';
        break;
      case 3:
        comment = '장동건, 정우성, 원빈과 닮은꼴 입니다.';
        break;
      case 4:
        comment = '그냥 못생겼습니다.';
        break;
    }
  }

  chooseImage(String select) async {
    var image;
    if (select == 'camera')
      image = await picker.getImage(source: ImageSource.camera);
    else if (select == 'gallery')
      image = await picker.getImage(source: ImageSource.gallery);
    else
      image = null;

    //사진 선택하면 광고 띄우고
    InterstitialAd newAd = ams.getNewInterstitial();
    newAd.load();
    newAd.show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
    );

    Future.delayed(Duration(seconds: 2), () {
      if (image == null) return null;
      setState(() {
        _isLoading = true;
        _image = File(image.path);
      });
      runModelOnImage(_image);
    });
  }

  runModelOnImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: _image.path,
        // numResults: 5,
        // imageMean: 117.5,
        // imageStd: 0.1,
        // threshold: 0.1,
        // imageMean: 117.5, // defaults to 117.0
        // imageStd: 117.5, // defaults to 1.0
        imageMean: 127.5, // defaults to 117.0
        imageStd: 127.5, // defaults to 1.0
        numResults: 2, // defaults to 5
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
      model: mlModel,
      labels: mlLabel,
    );
  }

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

  Widget getImage() {
    _visibleChart = true;

    return Image.file(
      _image,
      fit: BoxFit.contain,
    );
  }
}
