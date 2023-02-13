class blogGetterSetter {
   int blog,isSeen,totalCnt;
  final String blogImage,clientName,blogTitle ,blogByName,blogDate,blogUrl;


  blogGetterSetter(
      this.blog, this.blogImage,this.clientName,this.blogTitle,this.blogByName,this.blogDate,this.isSeen,this.blogUrl,this.totalCnt);

  @override
  String toString() {
    return '{ ${this.blog}, ${this.blogImage}, ${this.clientName}, ${this.blogTitle}, ${this.blogByName}, ${this.blogDate}, ${this.isSeen}, ${this.blogUrl}, ${this.totalCnt}}';
  }

  factory blogGetterSetter.fromJson(dynamic json) {
    return blogGetterSetter(
      json['blog'] as int,
      json['blogImage'] as String,
      json['clientName'] as String,
      json['blogTitle'] as String,
      json['blogByName'] as String,
      json['blogDate'] as String,
      json['isSeen'] as int,
      json['blogUrl'] as String, json['totalCnt'] as int
    );
  }
}