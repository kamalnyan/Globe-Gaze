import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String formatTimestamp(dynamic timestamp, BuildContext context) {
  DateTime dateTime;

  if (timestamp is DateTime) {
    dateTime = timestamp;
  } else if (timestamp is int) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  } else if (timestamp is Timestamp) {
    dateTime = timestamp.toDate();
  } else {
    return 'Unknown Time';
  }
  return DateFormat.jm().format(dateTime);
}