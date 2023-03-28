import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/chat_user.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/api/apis.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(),
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
                        log('Data: ${jsonEncode(data![0].data())}');
                        // _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                        final _list = [];
                        if(_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * 0.01),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Text(
                                  'Message: ${_list[index]}',
                                );
                              }
                          );
                        }
                        else {
                          return Center(
                            child: Text(
                              'Say Hii!',
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
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar(){
    return InkWell(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              width: mq.height * 0.05,
              height: mq.height * 0.05,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Last seen not available',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * 0.01,
        horizontal: mq.width * 0.025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    )
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none,
                      ),
                    )
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                        size: 26,
                      )
                  ),
                  SizedBox(
                    width: mq.width * 0.02,
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 5,
              left: 10,
            ),
            color: Colors.green,
            onPressed: () {},
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}