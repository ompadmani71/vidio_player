class Videos {
  final String image;
  final String category;
  final List networkVideos;

  Videos({
    required this.image,
    required this.category,
    required this.networkVideos,
  });
  factory Videos.fromJSON(Map json) {
    return Videos(
      image: json["image"],
      category: json["category"],
      networkVideos: json["networkVideos"],
    );
  }
}
