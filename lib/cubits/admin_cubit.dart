import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobeto_mobile_app/models/field_model.dart';
import 'package:tobeto_mobile_app/models/lesson_model.dart';
import 'package:tobeto_mobile_app/models/notification_model.dart';
import 'package:tobeto_mobile_app/models/user_model.dart';
import '../repository/user_repository.dart';

class AdminState {
  final User? firebaseUser;
  final bool isLoading;
  final String? error;
  final bool isAdmin;
  final String? adminName;
  final List<UserModel>? users;
  final List<FieldModel>? fields;
  final List<NotificationModel>? notifications;
  final List<LessonModel>? lessons;
  final String? selectedFieldId;

  AdminState({
    this.firebaseUser,
    this.isLoading = false,
    this.error,
    this.isAdmin = false,
    this.adminName,
    this.users,
    this.fields,
    this.notifications,
    this.lessons,
    this.selectedFieldId,
  });

  AdminState copyWith({
    User? firebaseUser,
    bool? isLoading,
    String? error,
    bool? isAdmin,
    String? adminName,
    List<UserModel>? users,
    List<FieldModel>? fields,
    List<NotificationModel>? notifications,
    List<LessonModel>? lessons,
    String? selectedFieldId,
  }) {
    return AdminState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAdmin: isAdmin ?? this.isAdmin,
      adminName: adminName ?? this.adminName,
      users: users ?? this.users,
      fields: fields ?? this.fields,
      notifications: notifications ?? this.notifications,
      lessons: lessons ?? this.lessons,
      selectedFieldId: selectedFieldId ?? this.selectedFieldId,
    );
  }
}


class AdminCubit extends Cubit<AdminState> {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminCubit(this._userRepository) : super(AdminState());


  Future<void> getCurrentUser() async {
    try {
      emit(AdminState(isLoading: true));
      User? firebaseUser = _userRepository.getCurrentUser();
      bool isAdmin = false;
      String? adminName;

      if (firebaseUser != null) {
        final doc = await _firestore.collection('admins').doc(firebaseUser.uid).get();
        isAdmin = doc.exists;
        adminName = doc.data()?['adminName'];
        emit(AdminState(firebaseUser: firebaseUser, isLoading: false, isAdmin: isAdmin, adminName: adminName));
      } else{
        emit(AdminState(isLoading: false, isAdmin: false));
      }

      await loadUsers();
      await loadFields();
      await loadNotifications();


    } catch (e) {
      emit(AdminState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> signInAsAdmin(String email, String password) async {
    emit(state.copyWith(isLoading: true));
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        final doc = await _firestore.collection('admins').doc(user.uid).get();
        if (doc.exists) {
          emit(state.copyWith(firebaseUser: user, isLoading: false, isAdmin: true));
        } else {
          emit(state.copyWith(error: 'Admin hesabı bulunamadı', isLoading: false));
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error: e.message, isLoading: false));
    }
  }

  Future<void> loadUsers() async {
    try {
      emit(state.copyWith(isLoading: true));
      var usersSnapshot = await _firestore.collection('users').get();
      var users = usersSnapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> loadFields() async {
    try {
      emit(state.copyWith(isLoading: true));
      var fieldsSnapshot = await _firestore.collection('fields').get();
      var fields = fieldsSnapshot.docs.map((doc) => FieldModel.fromMap(doc.data(),doc.id)).toList();
      emit(state.copyWith(fields: fields, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> loadNotifications() async {
    try {
      emit(state.copyWith(isLoading: true));
      var notificationsSnapshot = await _firestore.collection('notifications').get();
      var notifications = notificationsSnapshot.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList();
      emit(state.copyWith(notifications: notifications, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> assignLesson(String userId, String fieldName) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _userRepository.assignLesson(userId, fieldName);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<List<LessonModel>> getFieldLessons(String fieldName) async {
    try {
      emit(state.copyWith(isLoading: true));
      var lessonsSnapshot = await _userRepository.getFieldLessons(fieldName);
      emit(state.copyWith(isLoading: false));
      return lessonsSnapshot;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return [];
    }
  }

  void updateSelectedFieldId(String? fieldName) async {
    if (fieldName != null) {
      emit(state.copyWith(selectedFieldId: fieldName));
      try {
        List<LessonModel> fetchedLessons = await getFieldLessons(fieldName);
        emit(state.copyWith(lessons: fetchedLessons, isLoading: false));
      } catch (e) {

        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    } else {

      emit(state.copyWith(selectedFieldId: null, lessons: null, isLoading: false));
    }
  }

  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toMap());
      await loadNotifications();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      await loadNotifications();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

}
