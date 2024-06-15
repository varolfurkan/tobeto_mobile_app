class FieldModel {
  final String id;
  final String uid;
  final String fieldName;
  final String fieldLessons;

  FieldModel({required this.id, required this.uid, required this.fieldName, required this.fieldLessons});


  factory FieldModel.fromMap(Map<String, dynamic> data, String id) {
    return FieldModel(
      id: id,
      uid: data['uid'] ?? '',
      fieldName: data['fields_name'] ?? '',
      fieldLessons:  data['field_lessons'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'field_name': fieldName,
    };
  }
}
