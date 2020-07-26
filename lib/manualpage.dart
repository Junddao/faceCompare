import 'package:flutter/material.dart';

class ManualPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("참고", style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: <Widget>[
        Container(
          child: RichText(
            text: TextSpan(
              text: '사진은 \n',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[200],
                  fontWeight: FontWeight.w100),
              children: <TextSpan>[
                TextSpan(
                    text: '정면 얼굴을\n',
                    style: TextStyle(
                        color: Colors.blue[400], fontWeight: FontWeight.w300)),
                TextSpan(
                    text: '혼자만 나오게\n',
                    style: TextStyle(
                        color: Colors.blue[600], fontWeight: FontWeight.w100)),
              ],
            ),
          ),
        ),
        Column(
          children: <Widget>[
            makeRow('assets/images/OK.jpg', 'assets/images/NG1.jpg'),
            makeRow('assets/images/NG2.png', 'assets/images/ng3.jpg'),
          ],
        )
      ]),
    );
  }

  Widget makeRow(String leftPath, String rightPath) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          makeExpandedImage(leftPath),
          makeExpandedImage(rightPath),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  Widget makeExpandedImage(String imagePath) {
    return Expanded(
      child: Container(
        child: Image.asset(imagePath, fit: BoxFit.contain),
        margin: EdgeInsets.all(5.0),
      ),
    );
  }
}
