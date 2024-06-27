import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LessonModel {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime createdAt;
  final Map<String, List<Map<String, String>>> videos;

  LessonModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
    required this.videos,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map, String id) {
    return LessonModel(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videos: (map['videos'] ?? {}).map<String, List<Map<String, String>>>((key, value) {
        return MapEntry<String, List<Map<String, String>>>(key, (value as List<dynamic>).cast<Map<String, String>>());
      }),
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'videos': videos,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String formattedDate() {
    return DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(createdAt.toLocal());
  }
}
