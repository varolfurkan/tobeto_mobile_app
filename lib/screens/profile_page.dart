import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/cubits/profile_cubit.dart';
import 'package:tobeto_mobile_app/widgets/languages_card.dart';
import '../widgets/about_card.dart';
import '../widgets/certificates_card.dart';
import '../widgets/community_card.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/education_card.dart';
import '../widgets/internship_card.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/professional_exp_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/projects_awards_card.dart';
import '../widgets/skills_card.dart';

class ProfilePage extends StatelessWidget {
  final Widget svg = SvgPicture.asset(
    'img/icons/tobeto_icon.svg',
    semanticsLabel: 'Acme Logo',
  );

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadUserData(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: SizedBox(width: 150, child: svg),
        ),
        endDrawer: const DrawerMenu(),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              var userData = {
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
                'photoUrl': state.photoUrl,
              };

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ProfileCard(userData: userData),
                      const SizedBox(height: 16),
                      AboutCard(about: userData['about'] ?? ''),
                      const SizedBox(height: 16),
                      PersonalInfoCard(userData: userData),
                      const SizedBox(height: 16),
                      const SkillsCard(),
                      const SizedBox(height: 16),
                      const LanguagesCard(),
                      const SizedBox(height: 16),
                      const CertificatesCard(),
                      const SizedBox(height: 16),
                      const ProjectsAwardsCard(),
                      const SizedBox(height: 16),
                      const ProfessionalExperienceCard(),
                      const SizedBox(height: 16),
                      const InternshipCard(),
                      const SizedBox(height: 16),
                      const CommunityCard(),
                      const SizedBox(height: 16),
                      const EducationCard(),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                  child: Text('Kullanıcı verileri yüklenemedi.'));
            }
          },
        ),
      ),
    );
  }
}
