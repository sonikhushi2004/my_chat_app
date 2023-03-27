import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat_app/api/apis.dart';
import 'package:my_chat_app/models/chat_user.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/screens/profile_screen.dart';
import 'package:my_chat_app/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title:
              _isSearching ? TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name, Email, ...',
                ),
                autofocus: true,
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
                onChanged: (val) {
                  _searchList.clear();
                  for(var i in _list){
                    if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              )
              : Text('ChitChat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search
                )
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me,)
                      )
                    );
                  },
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
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                  if(_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * 0.01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: _isSearching ? _searchList[index] : _list[index]);
                        }
                    );
                  }
                  else {
                    return Center(
                      child: Text(
                        'No Connection Found.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                }
              }
          ),
        ),
      ),
    );
  }
}
