class ImagemModelo {
  final String asset;
  final String descricao;
  bool favorita;

  ImagemModelo({
    required this.asset,
    required this.descricao,
    this.favorita = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'asset': asset,
      'descricao': descricao,
      'favorita': favorita,
    };
  }

  // CORREÇÃO: Esta versão é mais segura e evita erros de tipo de dados.
  factory ImagemModelo.fromMap(Map<String, dynamic> map) {
    return ImagemModelo(
      asset: map['asset'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      favorita: map['favorita'] as bool? ?? false,
    );
  }
}

