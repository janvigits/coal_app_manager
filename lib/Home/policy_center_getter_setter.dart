class policyCenterGetterSetter {
  final int appInfoId, isSeen;
  final String title, description, attachmentUrl, url;

  policyCenterGetterSetter(this.appInfoId, this.title, this.description,
      this.attachmentUrl, this.url, this.isSeen);

  @override
  String toString() {
    return '{ ${this.appInfoId}, ${this.title}, ${this.description}, ${this.attachmentUrl} , ${this.url} }';
  }

  factory policyCenterGetterSetter.fromJson(dynamic json) {
    return policyCenterGetterSetter(
        json['appInfoId'] as int,
        json['title'] as String,
        json['description'] as String,
        json['attachmentUrl'] as String,
        json['url'] as String,
        json['isSeen'] as int);
  }
}
