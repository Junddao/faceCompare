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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("나의 외모 점수는?", style: TextStyle(color: Colors.black)),
      ),
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
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.width,
                    child: _image == null
                        ? Container()
                        : (Image.file(
                            _image,
                            fit: BoxFit.contain,
                          )),
                  ),
                ),

                Expanded(
                  flex: 6,
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
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            chooseImage();
          });
        },
        child: Icon(Icons.image),
      ),
    );
  }

  Widget displayComment(List output) {
    if (output != null) {}
  }

  Widget percentIndicator(Size size, List output) {
    List<double> liFaceScore = new List<double>();
    List<String> liFaceTitle = new List<String>();

    double myBestScore = 0.0;
    String myStyle;
    String comment = "사진을 선택하세요.";
    double totalScore = 0.0;

    //이전 결과값 초기화
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
                  totalScore + liResultScore[i] - (liResultScore[i] * 0.07);
            } else if (liResultTitle[i].contains('ruggedly')) {
              totalScore =
                  totalScore + liResultScore[i] - (liResultScore[i] * 0.09);
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
        comment = '당신은 남자다운 스타일 입니다.\n닮은 연예인은 고수, 소지섭, 송승헌 등이 있습니다.';
      } else if (myStyle.contains('handsome')) {
        comment = '당신은 잘생겼습니다.\n닮은 연예인은 장동건, 원빈, 강동원, 정우성, 현빈 등이 있습니다.';
      } else if (myStyle.contains('ugly')) {
        comment = '당신은 못생겼습니다.';
      }
    }

    return new SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Text((totalScore * 100).toStringAsFixed(1) + "점",
                style: new TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(comment,
                style: new TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.bold))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("섹시함",
                    style: new TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold))),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.5,
                animationDuration: 1000,
                lineHeight: 20,
                percent: liResultScore[0],
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  (liResultScore[0] * 100).toStringAsFixed(1) + "%",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.brown[300],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("귀여움",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.5,
                animation: true,
                animationDuration: 1000,
                lineHeight: 20,
                percent: liResultScore[1],
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  (liResultScore[1] * 100).toStringAsFixed(1) + "%",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.yellow[300],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("남성미",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.5,
                animation: true,
                animationDuration: 1000,
                lineHeight: 20,
                percent: liResultScore[2],
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  (liResultScore[2] * 100).toStringAsFixed(1) + "%",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.green[300],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("잘생김",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.5,
                animation: true,
                animationDuration: 1000,
                lineHeight: 20,
                percent: liResultScore[3],
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  (liResultScore[3] * 100).toStringAsFixed(1) + "%",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.blue[300],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("못생김",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new LinearPercentIndicator(
                width: size.width * 0.5,
                animation: true,
                animationDuration: 1000,
                lineHeight: 20,
                percent: liResultScore[4],
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  (liResultScore[4] * 100).toStringAsFixed(1) + "%",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.red[300],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  chooseImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
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
        imageMean: 117.5, // defaults to 117.0
        imageStd: 117.5, // defaults to 1.0
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
}
