class BannerModel {
  final String id;
  final String? titulo;
  final String? subtitulo;
  final String imageUrl;
  final bool ativo;
  final int ordem;

  BannerModel({
    required this.id,
    this.titulo,
    this.subtitulo,
    required this.imageUrl,
    required this.ativo,
    required this.ordem,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String?,
      subtitulo: json['subtitulo'] as String?,
      imageUrl: json['image_url'] as String,
      ativo: json['ativo'] as bool? ?? false,
      ordem: json['ordem'] as int? ?? 0,
    );
  }
}
