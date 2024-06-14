import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobeto_mobile_app/models/lesson_model.dart';
import 'package:tobeto_mobile_app/models/notification_model.dart';
import '../repository/user_repository.dart';

class UserState {
  final User? firebaseUser;
  final bool isLoading;
  final String? error;
  final bool isAdmin;
  final List<LessonModel>? lessons;
  final List<NotificationModel>? notifications;

  UserState({this.firebaseUser, this.isLoading = false, this.error, this.isAdmin = false, this.lessons, this.notifications});

  UserState copyWith({User? firebaseUser, bool? isLoading, String? error, bool? isAdmin, List<LessonModel>? lessons, List<NotificationModel>? notifications, String? adminName}) {
    return UserState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAdmin: isAdmin ?? this.isAdmin,
      lessons: lessons ?? this.lessons,
      notifications: notifications ?? this.notifications,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserCubit(this._userRepository) : super(UserState());

  Future<void> getCurrentUser() async {
    try {
      emit(UserState(isLoading: true));
      User? firebaseUser = _userRepository.getCurrentUser();
      if (firebaseUser != null) {
        emit(UserState(firebaseUser: firebaseUser, isLoading: false));
      } else {
        emit(UserState(isLoading: false));
      }
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(UserState(isLoading: true, isAdmin: false));
      await _userRepository.signInWithEmailAndPassword(email, password);
      User? user = _userRepository.getCurrentUser();

      if (user != null) {
        final doc = await _firestore.collection('admins').doc(user.uid).get();
        if (doc.exists) {
          emit(UserState(error: 'Eğitmen girişinden giriniz', isLoading: false, isAdmin: true));
        } else {
          await getLessons();
          await getNotifications();
          emit(state.copyWith(firebaseUser: user, isLoading: false));
        }
      } else {
        emit(UserState(error: 'Kullanıcı bulunamadı', isLoading: false));
      }
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }


  Future<void> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      emit(UserState(isLoading: true));
      await _userRepository.signUpWithEmailAndPassword(email, password, displayName);
      await getCurrentUser();
      await getLessons();
      await getNotifications();
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(UserState(isLoading: true));
      await _userRepository.signInWithGoogle();
      await getCurrentUser();
      await getLessons();
      await getNotifications();
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }


  Future<void> getLessons() async {
    try {
      User? user = _userRepository.getCurrentUser();
      if (user != null) {
        var lessons = await _userRepository.getLessons(user.uid);
        emit(state.copyWith(lessons: lessons));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> getNotifications() async {
    try {
      User? user = _userRepository.getCurrentUser();
      if (user != null) {
        var notifications = await _userRepository.getNotifications(user.uid);
        emit(state.copyWith(notifications: notifications));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(UserState(isLoading: true));
      await _userRepository.signOut();
      emit(UserState(firebaseUser: null, isLoading: false, error: null));
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }

}
