import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surichatapp/ChatRoom.dart';
import 'package:surichatapp/Story/models/story_model.dart';
import 'package:uuid/uuid.dart';

class ChatUsers extends StatelessWidget {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File imageFile;
  List<Story> list;


  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('Story_users')
        .doc(_auth.currentUser.uid)
        .collection('story')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser.displayName,
      "url": "",
      "profileImageUrl": "surender kumar",
      "name": _auth.currentUser.displayName,
      "time": FieldValue.serverTimestamp(),
      "start_time": FieldValue.serverTimestamp(),
    });

    var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile).catchError((error) async {
      await _firestore
          .collection('Story_users')
          .doc(_auth.currentUser.uid)
          .collection('story')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('Story_users')
          .doc(_auth.currentUser.uid)
          .collection('story')
          .doc(fileName)
          .update({"url": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "name": _message.text,
        "type": "single",
        "uid": _auth.currentUser.uid,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('Story_users')
          .doc(_auth.currentUser.uid)
          .collection('story')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),

            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chat_users')
                    .doc(_auth.currentUser.uid)
                    .collection('users')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data.docs[index]
                            .data() as Map<String, dynamic>;
                        return ListTile(
                          onTap: () {

                           Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ChatRoom(userUid: map['uid'],),
                                   ),
                                 );
                          },
                          leading: Icon(Icons.account_box, color: Colors.black),
                          title: Text(map['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text("Surender kumar"),

                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return
      ListTile(
        onTap: () {

//          Navigator.of(context).push(
//            MaterialPageRoute(builder: (_) => StoryPage(),
//            ),
//          );
        },
        leading: Icon(Icons.account_box, color: Colors.black),
        title: Text(map['name'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text("Surender kumar"),

      );

//      Container(
//      width: size.width,
//      alignment: Alignment.centerLeft,
//
//      child: Container(
//        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(15),
//          color: Colors.blue,
//        ),
//        child: Text(
//          map['name'],
//          style: TextStyle(
//            fontSize: 16,
//            fontWeight: FontWeight.w500,
//            color: Colors.white,
//          ),
//        ),
//      ),
//    );

  }

  void addData() {

    Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chat_users')
            .doc(_auth.currentUser.uid)
            .collection('users')
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map = snapshot.data.docs[index]
                    .data() as Map<String, dynamic>;

                Story story = Story(
                  url: map['url'],
                  media: MediaType.image,
                  duration: const Duration(seconds: 10),
                );

                list.add(story);

                return Container();

              },
            );
          } else {
            return Container();
          }
        },
      ),
    );

  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({ this.imageUrl, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}