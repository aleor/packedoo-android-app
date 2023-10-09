class Photo {
  String url;
  String thumbUrl;
  String fileId;

  Photo.fromMap(Map<dynamic, dynamic> map) {
    url = map['url'];
    thumbUrl = map['thumbUrl'];
    fileId = map['fileId'];
  }

  Photo({this.url, this.thumbUrl, this.fileId});
}
