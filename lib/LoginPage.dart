import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/HomePage.dart';
import 'package:surichatapp/RagistrationPage.dart';

class LoginPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>
{
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> keyForm = new GlobalKey();

  Future<User> logIn() async
  {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try
        {
          debugPrint("1");
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: _email.text.toString(), password: _password.text.toString());

          debugPrint("Login Successfull");

          Navigator.push(context, MaterialPageRoute(builder:(_) => HomePage()));


          _firestore.collection('users')
          .doc(_auth.currentUser.uid)
          .get()
          .then((value) => userCredential.user.updateDisplayName(value['name']));



          return userCredential.user;
        }
        catch(e)
    {
      debugPrint(e);
      debugPrint("error find");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(1),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan[500],
              Colors.cyan[400],
              Colors.cyan[300]
            ]
          )
        ),
        child: Column(
          children: [
            SizedBox(height: 50,),

            Container(
              alignment: Alignment.center,
              child: Text(
                "Login", style: TextStyle(
                fontSize: 40,
                color: Colors.white
              ),
              ),
            ),

            SizedBox(height: 20,),

            Container(
              alignment: Alignment.center,
              child: Text(
                "Welcome to the WhatsApp", style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
              ),
            ),

            SizedBox(height: 20,),

            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)
                )
              ),

              child: Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),


                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),

                          Container(
                            margin: EdgeInsets.only(top: 20,left: 10,right: 20),
                            child: TextFormField(
                              controller: _email,

                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if(value.isEmpty)
                                  {
                                    return 'Please Enter Email';
                                  }

                              },

                              style: TextStyle(
                                color: Colors.black
                              ),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter Email",
                                labelText: "E-mail"
                              ),
                            ),
                          ),

                          SizedBox(height: 15,),


                          Container(
                            margin: EdgeInsets.only(top: 20,left: 10,right: 20),
                            child: TextFormField(
                              controller: _password,
                              obscureText: true,
                              validator: (value){
                                if(value.isEmpty)
                                  {
                                    return 'Please Enter Password';
                                  }

                              },

                              style: TextStyle(
                                  color: Colors.black
                              ),

                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Password",
                                  labelText: "Password"
                              ),
                            ),
                          ),

                          SizedBox(height: 15,),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blue,
                                ]
                              ),

                              borderRadius: BorderRadius.all(Radius.circular(7)),

                            ),
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Text("Submit", style: TextStyle(
                                color: Colors.white
                              ),
                              ),
                              onPressed: (){

                                if(keyForm.currentState.validate())
                                  {
                                    logIn().then((user) {
                                      if(user != null)
                                      {
                                      }
                                    });
                                  }

                              },

                            ),
                          ),

                          SizedBox(height: 30,),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ]
                              ),

                              borderRadius: BorderRadius.all(Radius.circular(7)),

                            ),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Text("Open Ragistration Page", style: TextStyle(
                                  color: Colors.black
                              ),
                              ),
                              onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder:(_) => RagistrationPage()));

                              },

                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}



