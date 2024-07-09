import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ProfileCubit() : super(ProfileInitial());

  Future<void> loadUserData() async {
    emit(ProfileLoading());
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        var data = userDoc.data() as Map<String, dynamic>?;

        emit(ProfileLoaded(
          displayName: data?['displayName'] ?? '',
          email: data?['email'] ?? '',
          phoneNumber: data?['phoneNumber'] ?? '',
          birthDate: data?['birthDate'] ?? '',
          tcNumber: data?['tcNumber'] ?? '',
          gender: data?['gender'] ?? '',
          militaryStatus: data?['militaryStatus'] ?? '',
          disabilityStatus: data?['disabilityStatus'] ?? '',
          github: data?['github'] ?? '',
          country: data?['country'] ?? '',
          city: data?['city'] ?? '',
          district: data?['district'] ?? '',
          address: data?['address'] ?? '',
          about: data?['about'] ?? '',
          photoUrl: data?['photoUrl'],
          imageFile: null,
          cities: [
            'Adana',
            'Adıyaman',
            'Afyonkarahisar',
            'Ağrı',
            'Aksaray',
            'Amasya',
            'Ankara',
            'Antalya',
            'Ardahan',
            'Artvin',
            'Aydın',
            'Balıkesir',
            'Bartın',
            'Batman',
            'Bayburt',
            'Bilecik',
            'Bingöl',
            'Bitlis',
            'Bolu',
            'Burdur',
            'Bursa',
            'Çanakkale',
            'Çankırı',
            'Çorum',
            'Denizli',
            'Diyarbakır',
            'Düzce',
            'Edirne',
            'Elazığ',
            'Erzincan',
            'Erzurum',
            'Eskişehir',
            'Gaziantep',
            'Giresun',
            'Gümüşhane',
            'Hakkari',
            'Hatay',
            'Iğdır',
            'Isparta',
            'İstanbul',
            'İzmir',
            'Kahramanmaraş',
            'Karabük',
            'Karaman',
            'Kars',
            'Kastamonu',
            'Kayseri',
            'Kırıkkale',
            'Kırklareli',
            'Kırşehir',
            'Kilis',
            'Kocaeli',
            'Konya',
            'Kütahya',
            'Malatya',
            'Manisa',
            'Mardin',
            'Mersin',
            'Muğla',
            'Muş',
            'Nevşehir',
            'Niğde',
            'Ordu',
            'Osmaniye',
            'Rize',
            'Sakarya',
            'Samsun',
            'Siirt',
            'Sinop',
            'Sivas',
            'Şanlıurfa',
            'Şırnak',
            'Tekirdağ',
            'Tokat',
            'Trabzon',
            'Tunceli',
            'Uşak',
            'Van',
            'Yalova',
            'Yozgat',
            'Zonguldak',
          ],
        ));
      } else {
        emit(ProfileError('Kullanıcı oturumu açılmamış.'));
      }
    } catch (e) {
      emit(ProfileError('Kullanıcı verileri yüklenemedi: $e'));
    }
  }

  Future<void> saveUserData(ProfileLoaded state) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String? photoUrl = state.photoUrl;
      if (state.imageFile != null) {
        photoUrl = await _uploadImageToFirebase(user.uid, state.imageFile!);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'displayName': state.displayName,
        'email': state.email,
        'phoneNumber': state.phoneNumber,
        'birthDate': state.birthDate,
        'tcNumber': state.tcNumber,
        'gender': state.gender,
        'militaryStatus': state.militaryStatus,
        'disabilityStatus': state.disabilityStatus,
        'github': state.github,
        'country': state.country,
        'city': state.city,
        'district': state.district,
        'address': state.address,
        'about': state.about,
        if (photoUrl != null) 'photoUrl': photoUrl,
      });

      emit(state.copyWith(photoUrl: photoUrl, imageFile: null));
    }
  }

  Future<String> _uploadImageToFirebase(String userId, File imageFile) async {
    Reference storageReference = _storage.ref().child("userPhotos/$userId.jpg");
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit((state as ProfileLoaded).copyWith(imageFile: File(pickedFile.path)));
    }
  }

  void updateField(String fieldName, String value) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      final updatedState = currentState.copyWith(
        phoneNumber:
            fieldName == 'phoneNumber' ? value : currentState.phoneNumber,
        birthDate: fieldName == 'birthDate' ? value : currentState.birthDate,
        tcNumber: fieldName == 'tcNumber' ? value : currentState.tcNumber,
        github: fieldName == 'github' ? value : currentState.github,
        district: fieldName == 'district' ? value : currentState.district,
        address: fieldName == 'address' ? value : currentState.address,
        about: fieldName == 'about' ? value : currentState.about,
      );
      emit(updatedState);
    }
  }
}
