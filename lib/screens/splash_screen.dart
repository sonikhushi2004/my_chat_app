import 'dart:developer';
import 'package:my_chat_app/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chat_app/screens/auth/login_screen.dart';
import 'package:my_chat_app/screens/home_screen.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      if(APIs.auth.currentUser != null){
        log('\nUser:  ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            )
        );
      }
      else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome to ChitChat'),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Image.asset('images/chat.png'),
            top: mq.height * 0.15,
            width: mq.width * 0.5,
            right: mq.width * 0.25,
          ),
          Positioned(
            bottom: mq.height * 0.15,
            width: mq.width,
            child: Text(
              'Made in India by ME',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
