import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat_app/api/apis.dart';
import 'package:my_chat_app/models/chat_user.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/widgets/chat_user_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('Profile Screen'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.search)
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),

    );
  }
}
