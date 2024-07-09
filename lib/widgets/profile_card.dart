// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tobeto_mobile_app/cubits/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/profile.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userData.containsKey('photoUrl') &&
                          userData['photoUrl'] != null
                      ? NetworkImage(userData['photoUrl'])
                      : const NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ad Soyad',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        userData['displayName'] ?? 'Kullanıcı Adı',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: () {
                          String url = userData['github'] ?? '';
                          if (url.isNotEmpty) {
                            launch(url);
                          }
                        },
                        child: GestureDetector(
                          onTap: () async {
                            String url = userData['github'] ?? '';
                            if (url.isNotEmpty) {
                              final Uri uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('GitHub URL açılamıyor'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            userData['github'] ?? '',
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset(
                    'img/linkedin.png',
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Linkedin bağlantısı'),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.pen,
                          color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<ProfileCubit>(
                              create: (context) => ProfileCubit(),
                              child: ProfileEdit(),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.grey),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profili paylaş'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
