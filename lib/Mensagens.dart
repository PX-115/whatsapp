import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';

// ignore: must_be_immutable
class Mensagens extends StatefulWidget {
  Usuario? contato;
  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: widget.contato!.urlImagem.isNotEmpty ? NetworkImage(widget.contato!.urlImagem) : null
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(widget.contato!.nome)
            )
          ],
        ),
        
      ),
      
      body: Container(

      ),
    );
  }
}