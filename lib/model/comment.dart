import 'package:flutter/foundation.dart';

class Comment {
  String username;
  DateTime dateTime;
  String message;

  Comment({
    @required this.username,
    @required this.dateTime,
    @required this.message,
  });
}
