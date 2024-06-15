import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LessonModel {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime createdAt;

  LessonModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
  });

  factory LessonModel.fromMap(Map<String, dynamic> data, String id) {
    return LessonModel(
      id: id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String formattedDate() {
    return DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(createdAt.toLocal());
  }

}