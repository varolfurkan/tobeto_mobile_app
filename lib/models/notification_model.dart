import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String contents;
  final String type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.contents,
    required this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      contents: data['contents'] ?? '',
      type: data['type'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }


  /*
    Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'contents': contents,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
   */

}