import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'camera.dart';

class VideoTestPage extends StatefulWidget {
  final bool selectedGender;
  VideoTestPage({Key key, @required this.selectedGender}) : super(key: key);

  @override
  _VideoTestPageState createState() => _VideoTestPageState();
}

class _VideoTestPageState extends State<VideoTestPage> {
  List<CameraDescription> cameras;
  // Camera Video controller

  String _model = "";

  int selectedCameraIdx;
  bool _isLoading;
  bool isDetecting;

  List<dynamic> _output;

  String mlModel;
  String mlLabel;

  final picker = ImagePicker();

  // 최종 출력 결과값을 가지는 변수
  List<double> liResultScore = new List<double>();
  List<String> liResultTitle = new List<String>();

  @override
  void initState() {
    if (widget.selectedGender == false) {
      mlModel = "assets/model_unquant1.tflite";
      mlLabel = "assets/labels1.txt";
    } else if (widget.selectedGender == true) {
      mlModel = "assets/model_unquant2.tflite";
      mlLabel = "assets/labels2.txt";
    }

    _isLoading = true;

    loadModel().then((value) {
      setState(() {
        _isLoading = false;
        _model = value;
      });
    });

    cameraInitialize();

    super.initState();
  }

  Future<Null> cameraInitialize() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }

  setOutput(output) {
    setState(() {
      _output = output;
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
          : Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Appbar 높이만큼 띄우기
                Padding(padding: EdgeInsets.only(top: statusBarHeight + 5)),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.width,
                    child: Stack(children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Camera(cameras, setOutput, _model),
                      ),
                    ]),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: percentIndicator(size, _output),
                )
              ],
            )),
    );
  }

  Widget percentIndicator(Size size, List output) {
    List<double> liFaceScore = new List<double>();
    List<String> liFaceTitle = new List<String>();

    //이전 결과값 초기화
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
      //출력 리스트에 복사
      for (int i = 0; i < liResultTitle.length; i++) {
        for (int j = 0; j < liFaceTitle.length; j++) {
          if (liResultTitle[i] == liFaceTitle[j]) {
            liResultScore[i] = liFaceScore[j];
          }
        }
      }
    }

    return new SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(
                      text: '조명, 각도, 배경에 따라\n',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w200),
                      children: <TextSpan>[
                        TextSpan(
                            text: '점수가 다를 수 있으니\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w200)),
                        TextSpan(
                            text: '상심하지 마세요. ^__^\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Good",
                            style: new TextStyle(
                                foreground: Paint()..color = Colors.blue[500],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold))),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new LinearPercentIndicator(
                        width: size.width * 0.6,
                        animation: false,
                        lineHeight: 30,
                        percent: liResultScore[0],
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        center: Text(
                          (liResultScore[0] * 100).toStringAsFixed(1) + "%",
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        progressColor: Colors.blue[500],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Bad",
                          style: new TextStyle(
                              color: Colors.red[500],
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new LinearPercentIndicator(
                        width: size.width * 0.6,
                        animation: false,
                        lineHeight: 30,
                        percent: liResultScore[1],
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        center: Text(
                          (liResultScore[1] * 100).toStringAsFixed(1) + "%",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300),
                        ),
                        progressColor: Colors.red[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  loadModel() async {
    await Tflite.loadModel(
      model: mlModel,
      labels: mlLabel,
    );
  }
}
