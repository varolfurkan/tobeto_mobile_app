import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repository.dart';

class AdminState {
  final User? firebaseUser;
  final bool isLoading;
  final String? error;
  final bool isAdmin;

  final String? adminName;

  AdminState({this.firebaseUser, this.isLoading = false, this.error, this.isAdmin = false, this.adminName});

  AdminState copyWith({User? firebaseUser, bool? isLoading, String? error, bool? isAdmin, String? adminName}) {
    return AdminState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAdmin: isAdmin ?? this.isAdmin,
      adminName: adminName ?? this.adminName,
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
      }

      emit(AdminState(firebaseUser: firebaseUser, isLoading: false, isAdmin: isAdmin, adminName: adminName));
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

}
