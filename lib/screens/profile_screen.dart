import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/api/apis.dart';
import 'package:my_chat_app/models/chat_user.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/screens/auth/login_screen.dart';

import '../helper/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Screen'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.03,
                  ),
                  Stack(
                    children: [
                      _image != null ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * 0.1),
                        child: Image.file(
                          File(_image!),
                          width: mq.height * 0.2,
                          height: mq.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      )
                      :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * 0.1),
                        child: CachedNetworkImage(
                          width: mq.height * 0.2,
                          height: mq.height * 0.2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Colors.white,
                          elevation: 1,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.03,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg. Happy Singh',
                        label: Text('Name')
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg. Feeling happy',
                        label: Text('About')
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width * 0.4, mq.height * 0.06),
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackBar(
                            context,
                            'Profile Updated Successfully!'
                          );
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      'UPDATE',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen()
                    )
                  );
                });
              });
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ),

      ),
    );
  }
  void _showBottomSheet(){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: mq.height * 0.03,
            bottom: mq.height * 0.05,
          ),
          children: [
            Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: mq.height * 0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      mq.width * 0.3,
                      mq.height * 0.15,
                    )
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                    if(image != null){
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('images/add_image.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.white,
                      fixedSize: Size(
                        mq.width * 0.3,
                        mq.height * 0.15,
                      )
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                    if(image != null){
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('images/camera.png'),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}
