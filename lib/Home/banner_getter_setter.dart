class bannerGetterSetter {
  final String title,imageUrl,webUrl;


  bannerGetterSetter(
      this.title, this.imageUrl,this.webUrl);

  @override
  String toString() {
    return '{  ${this.title}, ${this.imageUrl}, ${this.webUrl}}';
  }

  factory bannerGetterSetter.fromJson(dynamic json) {
    return bannerGetterSetter(
      json['title'] as String,
      json['imageUrl'] as String,
      json['webUrl'] as String,

    );
  }
}