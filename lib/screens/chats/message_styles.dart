import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class MessageStyles {
  static const TextStyle dealNameStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
  );

  static const TextStyle dealLatestMessageStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    color: Color(0xff9b9b9b9),
  );

  static const TextStyle dealLatestMessageTimeStampStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.08,
    color: Color(0xffb9b8c3),
  );

  static const TextStyle dealUnreadsCountStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.08,
    color: Colors.white,
  );

  // chat

  static const TextStyle messageSenderNameStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
  );

  static const TextStyle messageTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: Color(0xff4a4a4a),
  );

  static const TextStyle messageTimestampStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.08,
    color: myMessageStatusColor,
  );

  static const TextStyle myMessageTimestampStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.08,
    color: myMessageStatusColor,
  );

  static const TextStyle myMessageStatusStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.08,
    color: myMessageStatusColor,
  );

  static const Color messageBackgroundColor = Color.fromRGBO(0, 140, 148, 0.1);

  static const Color messageTimestampColor = Color.fromRGBO(0, 0, 0, 0.3);

  static const Color myMessageStatusColor = Color.fromRGBO(0, 0, 0, 0.54);

  static const Color myMessageBackgroundColor =
      Color.fromRGBO(0, 140, 148, 0.3);
}
