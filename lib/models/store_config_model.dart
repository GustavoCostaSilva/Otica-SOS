class StoreConfigModel {
  final String id;
  final String nome;
  final String endereco;
  final String whatsapp;
  final String horario;
  final String? instagram;
  final String? logoUrl;

  StoreConfigModel({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.whatsapp,
    required this.horario,
    this.instagram,
    this.logoUrl,
  });

  factory StoreConfigModel.fromJson(Map<String, dynamic> json) {
    return StoreConfigModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      endereco: json['endereco'] as String,
      whatsapp: json['whatsapp'] as String,
      horario: json['horario'] as String,
      instagram: json['instagram'] as String?,
      logoUrl: json['logo_url'] as String?,
    );
  }
}
