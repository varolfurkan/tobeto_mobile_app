class UserModel {
  final String uid;
  final String displayName;
  final String email;

  UserModel({required this.uid, required this.displayName, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
    };
  }

}
