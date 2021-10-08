import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/HomePage.dart';
import 'package:surichatapp/LoginPage.dart';

class RagistrationPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return RagistrationPageState();
  }
}

class RagistrationPageState extends State<RagistrationPage>
{
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> keyForm = new GlobalKey();

  Future<User> CreateAccount() async
  {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try
    {
      print("1");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email.text.toString(), password: _password.text.toString());

      debugPrint("Account create Successfull");

      _firestore.collection('users')
          .doc(_auth.currentUser.uid)
          .set({
               "name":_name.text.toString(),
               "email":_email.text.toString(),
               "status": "Unavailable",
               "uid":_auth.currentUser.uid
      });

      return userCredential.user;
    }
    catch(e)
    {
      print(e);

      debugPrint("ramesh");
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
                "Ragistration", style: TextStyle(
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

            Expanded(child: Container(
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

                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Form(
                    key: keyForm,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.only(top: 20,left: 10,right: 20),
                            child: TextFormField(
                              controller: _name,
                              validator: (value){
                                if(value.isEmpty)
                                  {
                                    return 'Please Enter name';
                                  }
                              },

                              style: TextStyle(
                                  color: Colors.black
                              ),

                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Name",
                                  labelText: "Name"
                              ),
                            ),
                          ),

                          SizedBox(height: 15,),

                          Container(
                            margin: EdgeInsets.only(top: 20,left: 10,right: 20),
                            child: TextFormField(
                              controller: _email,
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
                                  labelText: "Email"
                              ),
                            ),
                          ),

                          SizedBox(height: 15,),


                          Container(
                            margin: EdgeInsets.only(top: 20,left: 10,right: 20),
                            child: TextFormField(
                              controller: _password,
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
                                    CreateAccount()
                                        .then((user) {
                                      if(user != null)
                                      {
                                        Navigator.push(context, MaterialPageRoute(builder:(_) => HomePage()));
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
                              child: Text("Open Login Page", style: TextStyle(
                                  color: Colors.black
                              ),
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder:(_) => LoginPage()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
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