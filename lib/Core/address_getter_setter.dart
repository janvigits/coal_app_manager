class addressGetterSetter {
  final String description;


  addressGetterSetter(
      this.description);

  @override
  String toString() {
    return '{  ${this.description},}';
  }

  factory addressGetterSetter.fromJson(dynamic json) {
    return addressGetterSetter(
      json['formatted_address'] as String,


    );
  }
}