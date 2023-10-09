import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeConverter {
  static DateTime fromTimestamp(dynamic value) {
    Timestamp timestamp;
    if (value is Timestamp) {
      timestamp = value;
    } else if (value is Map) {
      timestamp = Timestamp(value['_seconds'], value['_nanoseconds']);
    }

    if (timestamp != null) {
      return timestamp.toDate();
    } else {
      print('Unable to parse Timestamp from $value');
      return null;
    }
  }
}
