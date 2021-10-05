import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class Perfil extends StatefulWidget {
  const Perfil({ Key? key }) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _controllerNome = TextEditingController();
  late File imagem;

  Future? _recuperarImagem( String _origemImagem ) async {
    late File imagemSelecionada;

    switch (_origemImagem){
      case "camera" :
        imagemSelecionada = (await ImagePicker().pickImage(source: ImageSource.camera)) as File;
        break;
      case "galeria" :
        imagemSelecionada = (await ImagePicker().pickImage(source: ImageSource.gallery)) as File;
        break;
    }

    setState(() {
      imagem = imagemSelecionada;
    });
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
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil6.jpg?alt=media&token=e1c79749-8340-419e-a0f3-30bb4e786975"),
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