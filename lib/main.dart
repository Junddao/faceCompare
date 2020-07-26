import 'package:facecompare/rootpage.dart';
import 'package:facecompare/service/admob_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  // admob 광고 초기화
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance
      .initialize(appId: AdMobService().getInterstitialAdId());

  // 폰트 라이센스 등록
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(new MaterialApp(
    home: FaceCompare(),
  ));
}

class FaceCompare extends StatefulWidget {
  @override
  _FaceCompareState createState() => _FaceCompareState();
}

class _FaceCompareState extends State<FaceCompare> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.grey,
      title: 'Simple Lotto',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 1,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text(
        '/ J T B /',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),

      backgroundColor: Colors.grey[600],
      styleTextUnderTheLoader: new TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
      photoSize: 100.0,
      loaderColor: Colors.white,
      //loadingText: Text('Now Loading'),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // permission();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.gothicA1TextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: RootPage(),
    );
  }

  // void permission() async {

  //   // await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  //   await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  //   // await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
  // }

}
