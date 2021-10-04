class Conversa {

  String _nome = "";
  String _mensagem = "";
  String _caminhoImagem = "";
  
  Conversa(this._nome, this._mensagem, this._caminhoImagem);

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


}