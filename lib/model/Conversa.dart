import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {

  String _idRemetente;
  String _idDestinatario;
  String _nome = "";
  String _mensagem = "";
  String _caminhoImagem = "";
  String _tipoMensagem;

  Conversa();

  salvar() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("conversas")
      .doc(this.idRemetente)
      .collection("ultima_mensagem")
      .doc(this.idDestinatario)
      .set(this.toMap());

  }

  Map<String ,dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRemetente"    : this.idRemetente,
      "idDestinatario" : this.idDestinatario,
      "nome"           : this.nome,
      "mensagem"       : this.mensagem,
      "caminhoImagem"  : this.caminhoImagem,
      "tipoMensagem"   : this.tipoMensagem
    };

    return map;
  }

  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get mensagem => _mensagem;

  String get caminhoImagem => _caminhoImagem;

  set caminhoImagem(String value) {
    _caminhoImagem = value;
  }

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idDestinatario => _idDestinatario;

  String get tipoMensagem => _tipoMensagem;

  set tipoMensagem(String value) {
    _tipoMensagem = value;
  }

  set idDestinatario(String value) {
    _idDestinatario = value;
  }

}