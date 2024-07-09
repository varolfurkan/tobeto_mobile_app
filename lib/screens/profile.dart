// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/cubits/profile_cubit.dart';

import '../widgets/drawer_menu.dart';
import 'profile_page.dart';

class ProfileEdit extends StatelessWidget {
  final Widget svg = SvgPicture.asset(
    'img/icons/tobeto_icon.svg',
    semanticsLabel: 'Acme Logo',
  );

  final _formKey = GlobalKey<FormState>();

  ProfileEdit({super.key});

  Widget buildTextFormField({
    required String labelText,
    TextEditingController? controller,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    int maxLength = 50,
    int maxLines = 1,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
    Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines,
        enabled: enabled,
        onChanged: (value) {
          onChanged?.call(value);
        },
      ),
    );
  }

  Widget buildDropdownFormField({
    required String labelText,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadUserData(),
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(width: 150, child: svg),
        ),
        endDrawer: const DrawerMenu(),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: state.imageFile != null
                                    ? FileImage(state.imageFile!)
                                    : state.photoUrl != null
                                    ? NetworkImage(state.photoUrl!)
                                    : const NetworkImage(
                                    'https://via.placeholder.com/150'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    onPressed: () {
                                      context.read<ProfileCubit>().pickImage();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        buildTextFormField(
                          labelText: 'Ad Soyad',
                          controller:
                          TextEditingController(text: state.displayName),
                          keyboardType: TextInputType.name,
                          enabled: false,
                        ),
                        buildTextFormField(
                          labelText: 'E-posta',
                          controller: TextEditingController(text: state.email),
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                        ),
                        buildTextFormField(
                          labelText: 'Telefon Numaranız',
                          initialValue: state.phoneNumber,
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              '🇹🇷',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('phoneNumber', value);
                          },
                        ),
                        buildTextFormField(
                          labelText: 'Doğum Tarihiniz',
                          initialValue: state.birthDate,
                          keyboardType: TextInputType.datetime,
                          suffixIcon: const Icon(Icons.calendar_today),
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('birthDate', value);
                          },
                        ),
                        buildTextFormField(
                          labelText: 'TC Kimlik No',
                          initialValue: state.tcNumber,
                          keyboardType: TextInputType.text,
                          suffixIcon: const Icon(Icons.calendar_today),
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('tcNumber', value);
                          },
                        ),
                        buildDropdownFormField(
                          labelText: 'Cinsiyet',
                          value: state.gender,
                          items: ['Erkek', 'Kadın', 'Belirtmek istemiyorum'],
                          onChanged: (value) {
                            context.read<ProfileCubit>().emit(
                              state.copyWith(gender: value ?? ''),
                            );
                          },
                        ),
                        buildDropdownFormField(
                          labelText: 'Askerlik Durumu',
                          value: state.militaryStatus,
                          items: ['Yaptı', 'Tecilli', 'Muaf'],
                          onChanged: (value) {
                            context.read<ProfileCubit>().emit(
                              state.copyWith(militaryStatus: value ?? ''),
                            );
                          },
                        ),
                        buildDropdownFormField(
                          labelText: 'Engellilik Durumu',
                          value: state.disabilityStatus,
                          items: ['Var', 'Yok'],
                          onChanged: (value) {
                            context.read<ProfileCubit>().emit(
                              state.copyWith(disabilityStatus: value ?? ''),
                            );
                          },
                        ),
                        buildTextFormField(
                          labelText: 'Github Adresi',
                          initialValue: state.github,
                          keyboardType: TextInputType.url,
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('github', value);
                          },
                        ),
                        buildDropdownFormField(
                          labelText: 'İl',
                          value: state.city,
                          items: state.cities,
                          onChanged: (value) {
                            context.read<ProfileCubit>().emit(
                              state.copyWith(city: value ?? ''),
                            );
                          },
                        ),
                        buildTextFormField(
                          labelText: 'İlçe',
                          initialValue: state.district,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('district', value);
                          },
                        ),
                        buildTextFormField(
                          labelText: 'Mahalle / Sokak',
                          initialValue: state.address,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('address', value);
                          },
                        ),
                        buildTextFormField(
                          labelText: 'Hakkımda',
                          initialValue: state.about,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context
                                .read<ProfileCubit>()
                                .updateField('about', value);
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<ProfileCubit>()
                                .saveUserData(state);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                          child: const Text(
                            'Kaydet',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromARGB(255, 153, 51, 255),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Bir hata oluştu.'));
            }
          },
        ),
      ),
    );
  }
}
