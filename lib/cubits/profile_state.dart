part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String displayName;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String tcNumber;
  final String gender;
  final String militaryStatus;
  final String disabilityStatus;
  final String github;
  final String country;
  final String city;
  final String district;
  final String address;
  final String about;
  final String? photoUrl;
  final File? imageFile;
  final List<String> cities;

  ProfileLoaded({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.tcNumber,
    required this.gender,
    required this.militaryStatus,
    required this.disabilityStatus,
    required this.github,
    required this.country,
    required this.city,
    required this.district,
    required this.address,
    required this.about,
    this.photoUrl,
    this.imageFile,
    required this.cities,
  });

  ProfileLoaded copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? birthDate,
    String? tcNumber,
    String? gender,
    String? militaryStatus,
    String? disabilityStatus,
    String? github,
    String? country,
    String? city,
    String? district,
    String? address,
    String? about,
    String? photoUrl,
    File? imageFile,
    List<String>? cities,
  }) {
    return ProfileLoaded(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      tcNumber: tcNumber ?? this.tcNumber,
      gender: gender ?? this.gender,
      militaryStatus: militaryStatus ?? this.militaryStatus,
      disabilityStatus: disabilityStatus ?? this.disabilityStatus,
      github: github ?? this.github,
      country: country ?? this.country,
      city: city ?? this.city,
      district: district ?? this.district,
      address: address ?? this.address,
      about: about ?? this.about,
      photoUrl: photoUrl ?? this.photoUrl,
      imageFile: imageFile ?? this.imageFile,
      cities: cities ?? this.cities,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
