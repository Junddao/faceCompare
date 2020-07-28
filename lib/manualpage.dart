import 'package:flutter/material.dart';

class ManualPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("참고", style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            child: RichText(
              text: TextSpan(
                text: '사진은 \n',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.w100),
                children: <TextSpan>[
                  TextSpan(
                      text: '정면 얼굴을\n',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text: '혼자만 나오게\n',
                      style: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.w100)),
                  TextSpan(
                      text: '찍으세요.\n',
                      style: TextStyle(
                          color: Colors.blue[200],
                          fontWeight: FontWeight.w100)),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              makeRow('assets/images/OK.jpg', 'assets/images/NG1.jpg'),
              makeRowText('( O ) 좋아요!', '( X ) 얼굴을 가리지 마세요.'),
              makeRow('assets/images/NG2.png', 'assets/images/NG3.jpg'),
              makeRowText('( X ) 너무 어두워요.', '( X ) 혼자만 나오게 찍으세요.'),
            ],
          )
        ]),
      ),
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
        child: Image.asset(imagePath, fit: BoxFit.fitHeight),
        margin: EdgeInsets.all(5.0),
      ),
    );
  }

  Widget makeRowText(String leftText, String rightText) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          makeExpandedText(leftText),
          makeExpandedText(rightText),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  Widget makeExpandedText(String text) {
    TextStyle textStyle;
    if (text.contains('O')) {
      textStyle = TextStyle(
        color: Colors.blue,
        fontSize: 15,
      );
    } else {
      textStyle = TextStyle(
        color: Colors.red,
        fontSize: 15,
      );
    }
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle,
        ),
        margin: EdgeInsets.only(top: 10, bottom: 10),
      ),
    );
  }
}
