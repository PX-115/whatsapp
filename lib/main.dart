// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:whatsapp/Home.dart';
import 'package:whatsapp/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /* FirebaseFirestore.instance
    .collection("usuarios")
    .doc("001")
    .set({
      "nome" : "SampleText"
    }); */

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}
