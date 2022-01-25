import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_google/main.dart';
import 'package:map_google/screens/home_page.dart';
import 'package:map_google/screens/registerPage.dart';
import 'package:map_google/screens/scroll.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController tcon1 = TextEditingController();
  TextEditingController tcon2 = TextEditingController();
  giris() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: tcon1.text, password: tcon2.text)
        .then((kullanici) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
  void detectUser() async {if(FirebaseAuth.instance.currentUser != null){
      // wrong call in wrong place!
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ScrollPage()///////////////
      ));
}
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {detectUser();});
  }

  Widget build(BuildContext context) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // ignore: prefer_const_constructors
              SizedBox(
                height: yukseklik * 0.10,
              ),
              Center(
                child: Text(
                  ' MAP ',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: yukseklik * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 18),
                child: Text(
                  'Giriş yap',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: genislik * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: tcon1,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white, height: 7),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: yukseklik * 0.025,
              ),
              Center(
                child: Container(
                  width: genislik * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    controller: tcon2,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: TextStyle(color: Colors.white, height: 7),
                      hintText: 'Şifre',
                      contentPadding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: yukseklik * 0.05,
              ),
              Center(
                child: Container(
                    width: genislik * 0.55,
                    height: yukseklik * 0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.lightBlueAccent],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight)),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          giris();
                        },
                        child: Text(
                          'Giriş yap',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: yukseklik * 0.02,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  child: Text(
                    'Kayıt Ol',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: yukseklik * 0.26,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Future<void> resetPassword(String email) async {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: tcon1.text);
                    }
                  },
                  child: Text(
                    'Şifremi Unuttum',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}