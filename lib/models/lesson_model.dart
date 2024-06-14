import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final String userId;
  final String title;
  final String imageUrl;
  final DateTime createdAt;

  LessonModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
  });

  factory LessonModel.fromMap(Map<String, dynamic> data, String id) {
    return LessonModel(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

}