import 'package:flutter/material.dart';
import 'package:whatsapp/Cadastro.dart';
import 'package:whatsapp/Home.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/Mensagens.dart';
import 'package:whatsapp/Perfil.dart';
import 'package:whatsapp/model/Usuario.dart';

class RouteGenerator {

  static const String ROTA_INICIAL = "/";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_HOME = "/home";
  static const String ROTA_PERFIL = "/perfil";
  static const String ROTA_MENSAGENS = "/mensagens";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ROTA_INICIAL:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const Login(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.1);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case ROTA_LOGIN:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const Login(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.1);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case ROTA_CADASTRO:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) =>
              const Cadastro(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case ROTA_HOME:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const Home(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case ROTA_PERFIL:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) =>
              const Perfil(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case ROTA_MENSAGENS:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => Mensagens(args as Usuario),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      default:
        _erroRota();
    } 
    return null;
  }

  static Route<dynamic> _erroRota() {
    return PageRouteBuilder(
      pageBuilder: (_, animation, secondaryAnimation) => const Login(),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Tela não encontrada"),
            ),

            body: Center(
              child: Text("Tela não encontrada"),
            )
          ),
        );
      },
    );
  }
}
