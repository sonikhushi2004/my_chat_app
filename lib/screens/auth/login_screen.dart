import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/home_screen.dart';
import 'package:my_chat_app/helper/dialogs.dart';
import 'package:my_chat_app/api/apis.dart';
import 'package:my_chat_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleButtonClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async{
      Navigator.pop(context);
      if(user != null) {
        log('\nUser:  ${user.user}');
        log('\nUserAdditionalInfo:  ${user.additionalUserInfo}');
        if(await APIs.userExists()) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              )
          );
        }
        else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                )
            );
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }
    catch(e){
      log('_signInWithGoogle: $e');
      Dialogs.showSnackBar(context, 'Something went Wrong (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome to ChitChat'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            child: Image.asset('images/chat.png'),
            duration: Duration(seconds: 1),
            top: mq.height * 0.15,
            width: mq.width * 0.5,
            right: _isAnimate ? mq.width * 0.25 : -mq.width * .5,
          ),
          Positioned(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                  shape: const StadiumBorder(),
                  elevation: 1
              ),
              onPressed: () {
                _handleGoogleButtonClick();
              },
              icon: Image.asset(
                'images/google.png',
                height: mq.height * 0.03,
              ),
              label: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'LogIn with ',
                    ),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ]
                ),
              ),
            ),
            bottom: mq.height * 0.15,
            width: mq.width * 0.9,
            left: mq.width * 0.05,
            height: mq.height * 0.06,
          ),
        ],
      ),
    );
  }
}
