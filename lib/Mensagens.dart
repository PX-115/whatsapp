import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Mensagens extends StatefulWidget {
  Usuario? contato;
  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() async {

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
            onPressed: (){
              _enviarMensagem;
            },
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
                Text("Sample Text"),
                caixaMensagem
              ],
            ),
          )
        ),
      ),
    );
  }
}