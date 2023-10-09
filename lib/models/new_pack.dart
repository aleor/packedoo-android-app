import 'dart:io';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/models/location.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/models/price.dart';


class NewPack {
  String documentId;
  String name;
  DateTime createdOn;
  DateTime desiredDate;
  int distance;
  bool meetingMyself;
  bool sendingMyself;
  int status;
  String uid;
  List<Photo> photos;
  Price price;
  Location destination;
  Location origin;
  String description;
  int size;
  Contact originContact;
  Contact destinationContact;
  File picture;

  NewPack() {
    status = PackConstants.statusIdMap[Status.PENDING];
    price = Price();
    photos = List<Photo>();
    destination = Location();
    origin = Location();
    originContact = Contact();
    destinationContact = Contact();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map.from({
      'uid': this.uid,
      'date': this.desiredDate,
      'createdOn': DateTime.now(),
      'meetingMyself': this.meetingMyself,
      'sendingMyself': this.sendingMyself,
      'size': this.size,
      'status': this.status,
      'price': {
        'currency': 'RUB',
        'value': this.price.value,
      },
      'originContact': {
        'name': this.originContact?.name,
        'phoneNumber': this.originContact?.phoneNumber,
      },
      'destinationContact': {
        'name': this.destinationContact?.name,
        'phoneNumber': this.destinationContact?.phoneNumber,
      },
      'name': this.name,
      'description': this.description,
      'origin': {
        'description': this.origin.description,
        'city': this.origin.city,
        'country': this.origin.country,
        'coordinate': {
          'lat': this.origin.coordinate.lat,
          'lng': this.origin.coordinate.long
        }
      },
      'destination': {
        'description': this.destination.description,
        'city': this.destination.city,
        'country': this.destination.country,
        'coordinate': {
          'lat': this.destination.coordinate.lat,
          'lng': this.destination.coordinate.long
        }
      },
      'distance': this.distance
    });

    if (this.photos.isNotEmpty) {
      map.addAll({
        'photos': [
          {
            'url': this.photos.first.url,
            'thumbUrl': this.photos.first.url,
            'fileId': this.photos.first.fileId
          }
        ]
      });
    }

    return map;
  }
}
