import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String contents;
  final String type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.contents,
    required this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      contents: data['contents'] ?? '',
      type: data['type'] ?? '',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }



    Map<String, dynamic> toMap() {
    return {
      'title': title,
      'contents': contents,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String formattedDate() {
    return DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(createdAt.toLocal());
  }

}