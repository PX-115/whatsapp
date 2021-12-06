import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({ Key key }) : super(key: key);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> _listaConversas = List();

  @override
  void initState() {
    super.initState();

    Conversa conversa = Conversa();
    conversa.nome = "Kanye East";
    conversa.mensagem = "Cambodian Death Combo";
    conversa.caminhoImagem = "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=725ba1a7-5b99-4b12-90bc-835a5ec25503";

    _listaConversas.add(conversa);
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listaConversas.length,
      itemBuilder: (context, index){
        Conversa conversa = _listaConversas[index];

        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversa.caminhoImagem),
            maxRadius: 30,
          ),
          title: Text(
            conversa.nome,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          subtitle: Text(
            conversa.mensagem,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14
            ),
          ),
        );
      }
    );
  }
}