// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:whatsapp/Home.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/RouteGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /* FirebaseFirestore.instance
    .collection("usuarios")
    .doc("001")
    .set({
      "nome" : "SampleText"
    }); */

  final ThemeData theme = ThemeData();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    initialRoute: RouteGenerator.ROTA_INICIAL,
    onGenerateRoute: RouteGenerator.generateRoute,
    theme: theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: Color(0xff075E54),
        secondary: Color(0xff25D366)
      ),
    ),
  ));
}
