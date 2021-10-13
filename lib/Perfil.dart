import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Perfil extends StatefulWidget {
  const Perfil({ Key? key }) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _controllerNome = TextEditingController();
  String _idUsuarioLogado = "";
  String _urlRecuperada = "";
  late File imagem;
  bool _subindoImagem = false;

  Future? _recuperarImagem( String _origemImagem ) async {
    late XFile? imagemSelecionada;

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
    });
  }

  Future? _uploadImagem(){
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
      .child("perfil")
      .child("perfil_" + _idUsuarioLogado + ".jpg");

    UploadTask task = arquivo.putFile(imagem);

    task.snapshotEvents.listen((TaskSnapshot event) { 
      if(event.state == TaskState.running){
        setState(() {
          _subindoImagem = true;
        });
      }else if (event.state == TaskState.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    task.whenComplete(() => _recuperarUrlImagem(task.snapshot));
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url){
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> atualizarDados = {
      "urlImagem" : url
    };

    db.collection("usuarios")
      .doc(_idUsuarioLogado)
      .update(atualizarDados);
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await  auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),

      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _subindoImagem
                  ? CircularProgressIndicator()
                  : Container(),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: _urlRecuperada.isNotEmpty ? NetworkImage(_urlRecuperada) : null
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: (){
                        _recuperarImagem("camera");
                      }, 
                      child: Text("Câmera")
                    ),

                    TextButton(
                      onPressed: (){
                        _recuperarImagem("galeria");
                      },
                      child: Text("Galeria")
                    )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        primary: Colors.green),
                    onPressed: () {
                      
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}