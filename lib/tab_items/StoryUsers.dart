import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/Story/data.dart';
import 'package:surichatapp/Story/main.dart';
import 'package:surichatapp/Story/models/story_model.dart';


class StoryUsers extends StatelessWidget {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File imageFile;
  List<Story> list;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),

            Container(
              child: Container(
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.only(top: 13),
                          alignment: Alignment.topRight,
                          icon: Icon(Icons.photo),),
                      Container(
                          margin: EdgeInsets.only(left: 25,right: 60),
                          child:Text("Your story",style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),
                          )
                      ),

                      RaisedButton(
                        child: Text("View Story",style: TextStyle(
                          fontSize: 16,
                          color: Colors.cyan
                          ),
                        ),
                          onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (_) => StoryScreen(stories: stories)))
                          ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
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