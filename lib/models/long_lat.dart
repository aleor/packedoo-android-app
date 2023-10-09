class LongLat {
  double lat;
  double long;

  LongLat.fromMap(Map<dynamic, dynamic> map) {
    lat = double.parse(map['lat'].toString());
    long = double.parse(map['lng'].toString());
  }

  LongLat({this.lat, this.long});

  Map toMap() => {"lat": lat, "lng": long};
}
