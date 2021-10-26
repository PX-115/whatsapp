import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:image_picker/image_picker.dart';

import 'model/Mensagem.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class Mensagens extends StatefulWidget {
  Usuario? contato;
  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  TextEditingController _controllerMensagem = TextEditingController();
  String? _idUsuarioLogado;
  String? _idUsuarioDestinatario;

  _enviarMensagem() async {
    String? textoMensagem = _controllerMensagem.text;

    if(textoMensagem.isNotEmpty){
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    }
    
  }

  _salvarMensagem(String? idRemetente, String? idDestinatario, Mensagem msg) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("mensagens")
    .doc(idRemetente)
    .collection(idDestinatario!)
    .add(msg.toMap());
  }

  Future? _enviarImagem( String _origemImagem ) async {
    /* late XFile? imagemSelecionada;

    switch (_origemImagem){
      case "camera" :
        imagemSelecionada = await ImagePicker().pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker().pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      imagem = File(imagemSelecionada!.path);
      _subindoImagem = true;
      _uploadImagem();
    }); */
  }

  List<String> listaMensagem = [
    "Que sensacional",
    "O sorriso dessa princessa",
    "É de impressionar",
    "Quando arrasta ela pra treta"
  ];

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    _idUsuarioDestinatario = widget.contato!.idUsuario;
  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controllerMensagem,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  hintText: "Digite sua mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)
                  ),
                  prefixIcon: IconButton(
                    onPressed: (){
                      _enviarImagem("galeria");
                    }, 
                    icon: Icon(
                      Icons.camera_alt,
                      color: Color(0xff075E54),
                    ),
                  )
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: _enviarMensagem,
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send, 
              color: Colors.white
            ),
            mini: true,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
        itemCount: listaMensagem.length,
        itemBuilder: (context, index){
          double larguraContainer = MediaQuery.of(context).size.width * 0.8;

          Alignment alinhamento = Alignment.centerRight;
          Color cor = Color(0xffd2ffa5);

          if(index % 2 == 0){//Par
            alinhamento = Alignment.centerLeft;
            cor = Colors.white;
          }

          return Align(
            alignment: alinhamento,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Container(
                width: larguraContainer,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  listaMensagem[index],
                  style: TextStyle(fontSize: 18),
                  ),
              ),
            )
          );
        }
      ),
    );

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
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                listView,
                caixaMensagem
              ],
            ),
          )
        ),
      ),
    );
  }
}