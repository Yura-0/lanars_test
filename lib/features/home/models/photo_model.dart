class Photo {
  final int id;
  final String photographer;
  final String imageUrl;

  Photo({
    required this.id,
    required this.photographer,
    required this.imageUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      photographer: json['photographer'],
      imageUrl: json['src']['original'],
    );
  }
}

