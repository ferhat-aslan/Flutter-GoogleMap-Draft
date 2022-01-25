import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_google/main.dart';
import 'package:map_google/screens/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController tcon1 = TextEditingController(); //email
  TextEditingController tcon2 = TextEditingController(); //kullanıcı adı
  TextEditingController tcon3 = TextEditingController(); //şifre
  Future<void> kayit() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: tcon1.text, password: tcon3.text)
        .then((kullanici) {
      FirebaseFirestore.instance
          .collection("kullanicilar")
          .doc(tcon1.text)
          .set({
        "KullaniciEposta": tcon1.text,
        "KullaniciUsername": tcon2.text,
        "KullaniciSifre": tcon3.text,
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
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

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
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
                  'Kayıt Ol',
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
              // Center(
              //   child: Container(
              //     width: genislik * 0.8,
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.cyan),
              //         borderRadius: BorderRadius.circular(15)),
              //     child: TextFormField(
              //       style: TextStyle(color: Colors.white),
              //       controller: tcon2,
              //       decoration: InputDecoration(
              //         labelText: 'Kullanıcı Adı',
              //         labelStyle: TextStyle(color: Colors.white, height: 7),
              //         hintText: 'Kullanıcı Adı',
              //         contentPadding: EdgeInsets.fromLTRB(25, 0, 0, 0),
              //         hintStyle: TextStyle(
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: yukseklik * 0.025,
              // ),
              Center(
                child: Container(
                  width: genislik * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    controller: tcon3,
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
                        onPressed: kayit,
                        child: Text(
                          'Kayıt Ol',
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
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(color: Colors.white, fontSize: 30),
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