import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/LoginPage.dart';
import 'package:surichatapp/tab_items/Chat_Users.dart';
import 'package:surichatapp/tab_items/SearchUsers.dart';
import 'package:surichatapp/tab_items/StoryUsers.dart';


class HomePage extends StatelessWidget
{
  Future logOut(BuildContext context) async
  {
    FirebaseAuth auth = FirebaseAuth.instance;

    try{
      await auth.signOut().then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      });
    }
    catch(e)
    {
      print('error');
    }
  }

  List<Widget> containers = [
    Container(
      child: ChatUsers(),
    ),

    Container(
      child:StoryUsers(),
    ),

    Container(
      child: SearchUsers(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
        child: Container(
          padding: EdgeInsets.only(top: 7),
          child: Scaffold(
            appBar: AppBar(
              title: Text("WhatsApp",style: TextStyle(
                fontSize: 25,
              ),
              ),
              actions: [
                IconButton(onPressed: ()=> logOut(context), icon: Icon(Icons.logout)),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Chats',
                  ),
                  Tab(
                    text: 'Status',
                  ),
                  Tab(
                    text: 'Cotacts',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: containers,
            ),
          ),
        )
    );
  }
}




