import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tobeto_mobile_app/models/lesson_model.dart';
import 'package:tobeto_mobile_app/models/notification_model.dart';
import 'package:tobeto_mobile_app/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      throw Exception('E-posta veya şifre hatalı.');
    } catch (e) {
      throw Exception('Giriş sırasında bir hata oluştu.');
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        User? user = userCredential.user;
        await user?.updateDisplayName(displayName);
        if (user != null) {
          UserModel newUser = UserModel(uid: user.uid, displayName: displayName, email: email);
          await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Bu e-posta adresi ile zaten bir kullanıcı kayıtlı.');
      } else {
        throw Exception('Kayıt sırasında bir hata oluştu.');
      }
    } catch (e) {
      throw Exception('Kayıt sırasında bir hata oluştu.');
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);

      String? displayName = googleUser.displayName;
      displayName ??= '';

      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        UserModel newUser = UserModel(uid: user.uid, displayName: displayName, email: user.email ?? '');
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }
    }
  }


  Future<void> assignLesson(String userId, String fieldName) async {
    if (fieldName.isEmpty || userId.isEmpty) {
      throw Exception('Field name or User ID is empty');
    }
    try {
      List<LessonModel> fieldLessons = await getFieldLessons(fieldName);

      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.set(userDocRef.collection('fields').doc(fieldName), {'fields_name': fieldName});

      for (var lesson in fieldLessons) {
        DocumentReference lessonDocRef =
        userDocRef.collection('fields').doc(fieldName).collection('field_lessons').doc();

        // Prepare videos for assignment to user
        Map<String, dynamic> videos = {};

        // Iterate through each video entry in lesson's videos
        lesson.videos.forEach((videoName, videoList) {
          // Convert videoList to List<Map<String, dynamic>>
          List<Map<String, dynamic>> formattedVideoList =
          videoList.map((video) => {'videoName': video['videoName'], 'videoUrl': video['videoUrl']}).toList();

          videos[videoName] = formattedVideoList;
        });

        // Create lesson data to save
        Map<String, dynamic> lessonData = {
          ...lesson.toMap(),
          'videos': videos,
        };

        batch.set(lessonDocRef, lessonData);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error assigning lessons to user: $e');
    }
  }





  Future<List<LessonModel>> getFieldLessons(String fieldName) async {
    if (fieldName.isEmpty) {
      throw Exception('Field name is empty');
    }

    try {
      var fieldsSnapshot = await FirebaseFirestore.instance
          .collection('fields')
          .where('fields_name', isEqualTo: fieldName)
          .get();

      if (fieldsSnapshot.docs.isEmpty) {
        throw Exception('No field found with this name: $fieldName');
      }

      var fieldId = fieldsSnapshot.docs.first.id;

      var lessonsSnapshot = await FirebaseFirestore.instance
          .collection('fields')
          .doc(fieldId)
          .collection('field_lessons')
          .get();

      if (lessonsSnapshot.docs.isEmpty) {
        throw Exception('No lessons found for this field name: $fieldName');
      }

      List<LessonModel> allLessons = [];

      for (var lessonDoc in lessonsSnapshot.docs) {
        var lessonData = lessonDoc.data();

        // Fetch videos for the current lesson
        var videosSnapshot = await lessonDoc.reference.collection('videos').get();
        Map<String, List<Map<String, String>>> videos = {};

        // Iterate through each video document
        for (var videoDoc in videosSnapshot.docs) {
          var videoData = videoDoc.data();
          var videoName = videoDoc.id; // Video document ID as video name

          List<Map<String, String>> videoFields = [];
          // Extract each field and its value from the video document
          videoData.forEach((field, value) {
            videoFields.add({
              'videoName': field,
              'videoUrl': value.toString(),
            });
          });

          videos[videoName] = videoFields;
        }

        LessonModel lesson = LessonModel.fromMap({
          ...lessonData,
          'videos': videos,
        }, lessonDoc.id);

        allLessons.add(lesson);
      }

      return allLessons;
    } catch (e) {
      throw Exception('Error fetching lessons: $e');
    }
  }






  Future<List<LessonModel>> getLessons(String userId) async {
    try {
      var fieldsSnapshot = await _firestore.collection('users').doc(userId).collection('fields').get();

      if (fieldsSnapshot.docs.isEmpty) {
        return [];
      }

      List<LessonModel> allLessons = [];

      for (var fieldDoc in fieldsSnapshot.docs) {
        var lessonsSnapshot = await fieldDoc.reference.collection('field_lessons').get();

        var fieldLessons = lessonsSnapshot.docs.map((doc) async {
          var lessonData = doc.data();

          // Ensure videos structure matches new format
          Map<String, List<Map<String, String>>> videos = {};
          if (lessonData['videos'] != null) {
            lessonData['videos'].forEach((videoName, videoList) {
              List<Map<String, String>> parsedVideos = [];
              (videoList as List<dynamic>).forEach((video) {
                if (video is Map<String, dynamic>) {
                  parsedVideos.add({
                    'videoName': video['videoName'] ?? '',
                    'videoUrl': video['videoUrl'] ?? '',
                  });
                }
              });
              videos[videoName] = parsedVideos;
            });
          }

          return LessonModel.fromMap({
            ...lessonData,
            'videos': videos,
          }, doc.id);
        });

        // Wait for all lessons to be fetched before adding to allLessons list
        allLessons.addAll(await Future.wait(fieldLessons));
      }

      return allLessons;
    } catch (e) {
      throw Exception('Error fetching lessons for user $userId: $e');
    }
  }





  Future<List<NotificationModel>> getNotifications(String userId) async {
    var notificationsCollection = _firestore.collection('notifications');
    var notificationsSnapshot = await notificationsCollection.get();
    return notificationsSnapshot.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}
