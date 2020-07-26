import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ComparePage extends StatefulWidget {
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
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
                          ]),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: percentIndicator(size, _output),
                )

                // _output == null
                //     ? Text("")
                //     : Text("${_output[0]["label"]}" +
                //         "  " +
                //         "${_output[0]["confidence"]}")
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

  Widget percentIndicator(Size size, List output) {
    List<double> liFaceScore = new List<double>();
    List<String> liFaceTitle = new List<String>();

    String comment = "사진을 선택하세요.";

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
      if (liResultScore[0] > 0.9) {
        comment = '굉장히 잘생겼어요!! \n장동건, 현빈, 원빈 등급 입니다.';
      } else if (liResultScore[0] > 0.7 && liResultScore[0] <= 0.9) {
        comment = '훈훈한 외모의 소유자!! \n박보검, 박서준, 조승우 등급 입니다.';
      } else if (liResultScore[0] > 0.5 && liResultScore[0] <= 0.7) {
        comment = '평균 이상의 외모이십니다. \n음... 잘생긴 일반인??';
      } else if (liResultScore[0] > 0.3 && liResultScore[0] <= 0.5) {
        comment = '평균 이하의 외모를 가지셨습니다. \n거울은 거짓말을 하지 않아요.';
      } else {
        comment = '그냥 못생겼어요. \n사진이 잘못 됐을수도 있으니 \n다시 찍어보세요.';
      }
    }

    return new SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(comment,
                style: new TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w200))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Good",
                    style: new TextStyle(
                        foreground: Paint()..color = Colors.blue[500],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300))),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.6,
                animationDuration: 1000,
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
              child: Text("Ugly",
                  style: new TextStyle(
                      color: Colors.red[500],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.6,
                animation: true,
                animationDuration: 1000,
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
      ]),
    );
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
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
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
}
