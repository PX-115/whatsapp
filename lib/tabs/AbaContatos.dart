import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({ Key? key }) : super(key: key);

  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  List<Conversa> listaConversa = [
    Conversa(
      "Kanye East", 
      "Hey yo, check my new album: Duda", 
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=725ba1a7-5b99-4b12-90bc-835a5ec25503"
    ),
    Conversa(
      "Snoop Catt", 
      "I don't like weed bro, thx for offering tho", 
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=aaf658a2-177f-471f-87d0-4b88cdb979af"
    ),
    Conversa(
      "1Pac", 
      "Ambitions As A Pilot seems a good gangsta name", 
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil3.png?alt=media&token=66a9c2fb-947f-4902-a73e-b22f8d7c1bec"
    ),
    Conversa(
      "Brake", 
      "I'm not that type of guy y'know 😔", 
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=4a1faa89-f3ba-4ba7-b6fb-7dbd63a001b1"
    ),
    Conversa(
      "Ratuê (he's brazilian = monkee)", 
      "Hey dababy, how to stop being white?", 
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-projeto-1f5d5.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=3e65a9ae-8c0c-4d63-afdf-358aaf03636d"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaConversa.length,
      itemBuilder: (context, index){
        Conversa conversa = listaConversa[index];

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
          /* subtitle: Text(
            conversa.mensagem,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14
            ),
          ), */
        );
      }
    );
  }
}