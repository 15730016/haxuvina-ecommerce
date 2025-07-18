class SingleBanner {
  final String photo;
  final String url;

  SingleBanner({
    required this.photo,
    required this.url,
  });

  factory SingleBanner.fromJson(Map<String, dynamic> json) {
    return SingleBanner(
      photo: (json['photo'] ?? '').toString().trim(),
      url: (json['url'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'url': url,
    };
  }
}
