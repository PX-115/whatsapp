import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/Usuario.dart';

import 'model/Mensagem.dart';

// ignore: must_be_immutable
class Mensagens extends StatefulWidget {
  Usuario contato;
  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  TextEditingController _controllerMensagem = TextEditingController();
  String _idUsuarioLogado;
  String _idUsuarioDestinatario;
  String urlRecuperada;
  File imagemSelecionada;
  bool subindoImagem = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

  _enviarMensagem() async {
    String textoMensagem = _controllerMensagem.text;

    if(textoMensagem != null){
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      // Salva a mensagem para o remetente
      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

      //Salva a mensagem para o destinatário
      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
    }
    
    //Limpar o texto da caixa de mensagem
    _controllerMensagem.text = "";
  }

  _salvarMensagem(String idRemetente, String idDestinatario, Mensagem msg) async {
    await db.collection("mensagens")
    .doc(idRemetente)
    .collection(idDestinatario)
    .add(msg.toMap());
  }

  Future _enviarImagem() async {

    XFile imagemPickada = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      imagemSelecionada = File(imagemPickada.path);
    });

    // O método de upload da imagem agora é integrado ao método que envia a mensagem
    subindoImagem = true;
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
      .child("mensagens")
      .child(_idUsuarioLogado)
      .child(nomeImagem + ".png");

    UploadTask task = arquivo.putFile(imagemSelecionada);

    task.snapshotEvents.listen((TaskSnapshot event) { 
      if(event.state == TaskState.running){
        setState(() {
          subindoImagem = true;
        });
      }else if (event.state == TaskState.success){
        setState(() {
          subindoImagem = false;
        });
      }
    });

    task.whenComplete(() => _recuperarUrlImagem(task.snapshot));
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

     Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = "";
      mensagem.urlImagem = url;
      mensagem.tipo = "imagem";

      // Salva a mensagem para o remetente
      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

      //Salva a mensagem para o destinatário
      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

    setState(() {
      urlRecuperada = url;
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;

    _idUsuarioDestinatario = widget.contato.idUsuario;
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
                      _enviarImagem();
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

    var stream = StreamBuilder(
      stream: db.collection("mensagens")
              .doc(_idUsuarioLogado)
              .collection(_idUsuarioDestinatario).snapshots(),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text("Carregando mensagens..."),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

            if(snapshot.hasError){
              return Expanded(
                child: Text("Erro ao carregar mensagens")
              );
            } else {
              return Expanded(
                  child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {

                        List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();
                        DocumentSnapshot item = mensagens[index];

                        double larguraContainer =
                            MediaQuery.of(context).size.width * 0.8;

                        Alignment alinhamento = Alignment.centerRight;
                        Color cor = Color(0xffd2ffa5);

                        if (index % 2 == 0) {
                          //Par
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: 
                                item["tipo"] == "texto"
                                  ? Text(item["mensagem"], style: TextStyle(fontSize: 18))
                                  : Image.network(item["urlImagem"])
                              ),
                            ));
                      }),
                );
            } 
          break;
          default:
            return Container(); // just to satisfy flutter analyzer
          break;
        }
      }
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: widget.contato.urlImagem.isNotEmpty ? NetworkImage(widget.contato.urlImagem) : null
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(widget.contato.nome)
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
                stream,
                caixaMensagem
              ],
            ),
          )
        ),
      ),
    );
  }
}