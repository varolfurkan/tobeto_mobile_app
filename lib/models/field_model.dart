class FieldModel {
  final String uid;
  final String fieldName;

  FieldModel({required this.uid, required this.fieldName});

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'fieldName': fieldName,
    };
  }

  factory FieldModel.fromMap(Map<String, dynamic> data) {
    return FieldModel(
      uid: data['uid'] ?? '',
      fieldName: data['fields_name'] ?? '',
    );
  }
}
