import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/ChatRoom.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> with WidgetsBindingObserver {
  Map<String, dynamic> userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }



  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }



  Future addContact(String name, String uid,String email) async
  {
    if(name.isNotEmpty)
      {
        Map<String, dynamic> addSenderSide = {
          "name": name,
          "type": "single",
          "uid": uid,
          "email":email,
          "time": FieldValue.serverTimestamp(),
        };
        await _firestore
            .collection('chat_users')
            .doc(_auth.currentUser.uid)
            .collection('users')
            .add(addSenderSide);

        debugPrint("complete" + addSenderSide.toString());



        Map<String, dynamic> addMap;

        await _firestore
            .collection('users')
            .where("uid", isEqualTo: _auth.currentUser.uid)
            .get()
            .then((value) {
          setState(() {
            addMap = value.docs[0].data();
          });
        });


        Map<String, dynamic> addRecieverSide = {
          "name": addMap['name'],
          "type": "single",
          "uid": _auth.currentUser.uid,
          "email":addMap['email'],
          "time": FieldValue.serverTimestamp(),
        };

        await _firestore
            .collection('chat_users')
            .doc(uid)
            .collection('users')
            .add(addRecieverSide);

        debugPrint("complete" + addRecieverSide.toString());
      }
    else
      {
        debugPrint('error');
      }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(

      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          addContact(userMap['name'],userMap['uid'],userMap['email']);

                        },

                        leading: Icon(Icons.account_box, color: Colors.black),
                        title: Text(
                          userMap['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap['email']),
                        trailing: Icon(Icons.add, color: Colors.black),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
