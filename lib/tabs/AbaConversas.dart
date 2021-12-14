import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Usuario.dart';

// ignore: must_be_immutable
class AbaConversas extends StatefulWidget {
  const AbaConversas ({Key key}) : super(key: key);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  String _idUsuarioLogado;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _streamController = StreamController<QuerySnapshot>.broadcast();

  List<Conversa> _listaConversas = [];

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

    Conversa conversa = Conversa();
    conversa.nome = "Ana Clara";
    conversa.mensagem = "Olá tudo bem?";
    conversa.caminhoImagem = "https://firebasestorage.googleapis.com/v0/b/whatsapp-36cd8.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=97a6dbed-2ede-4d14-909f-9fe95df60e30";

    _listaConversas.add(conversa);
  }

  Stream<QuerySnapshot> adicionarListenerConversa(){
    final stream = db.collection("conversas")
      .doc(_idUsuarioLogado)
      .collection("ultima_conversa")
      .snapshots();

    stream.listen((dados) {
      _streamController.add(dados);
    });

    
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;

    adicionarListenerConversa();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _streamController.stream,
      builder: (context, snapshot){
        switch (snapshot.connectionState) {
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
            if(snapshot.hasError){
              return Text("Erro ao carregar mensagens");
            } else {

              QuerySnapshot querySnapshot = snapshot.data;

              if(querySnapshot.docs.length == 0){
                return Center(
                  child: Text(
                    "Você não possui mensagens ainda",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _listaConversas.length,
                itemBuilder: (context, index){
                  List<DocumentSnapshot> conversas = querySnapshot.docs;
                  DocumentSnapshot item = conversas[index];

                  String urlImagem = item["caminhoImagem"];
                  String nome      = item["nome"];
                  String mensagem  = item["mensagem"];
                  String tipo      = item["tipoMensagem"];
                  String idDestinatario = item["idDestinatario"];

                  Usuario usuario = Usuario();
                  usuario.idUsuario = idDestinatario;
                  usuario.nome = nome;
                  usuario.urlImagem = urlImagem;


                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(
                        context, 
                        RouteGenerator.ROTA_MENSAGENS,
                        arguments: usuario
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: urlImagem.isNotEmpty ? NetworkImage(urlImagem) : null,
                      maxRadius: 30,
                    ),
                    title: Text(
                      nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    subtitle: Text(
                      tipo == "texto"
                        ? mensagem
                        : "Imagem",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),
                    ),
                  );
                }
              );
            }
            break;
          default:
            return Container(); // just to satisfy flutter analyzer
          break;
        }
      }
    );
  }
}