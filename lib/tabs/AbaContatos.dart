import 'package:flutter/material.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  String? _idUsuarioLogado;
  String? _emailUsuarioLogado;

  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuarios").get();

    List<Usuario> listaUsuarios = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map<String, dynamic>;
      if(dados["email"] == _emailUsuarioLogado) continue;

      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.email = dados["email"];
      usuario.urlImagem = dados["urlImagem"];

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;
    _emailUsuarioLogado = usuarioLogado!.email;
    _idUsuarioLogado = usuarioLogado.uid;
  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text("Carregando contatos..."),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  List<Usuario>? listaItens = snapshot.data;
                  Usuario usuario = listaItens![index];

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
                      backgroundImage: usuario.urlImagem.isNotEmpty ? NetworkImage(usuario.urlImagem) : null
                    ),
                    title: Text(
                      usuario.nome,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                }
            );
        }
      },
    );
  }
}
