import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/auth/auth_service.dart';
import 'package:tobeto_mobile_app/screens/profile.dart';
import 'package:tobeto_mobile_app/screens/what_do_we_offer.dart';
import 'package:tobeto_mobile_app/screens/login_screen.dart';
import 'package:tobeto_mobile_app/screens/home_page.dart';
import 'package:tobeto_mobile_app/screens/reviews.dart';
import 'package:tobeto_mobile_app/screens/lessons.dart';
import 'package:tobeto_mobile_app/screens/catalog.dart';
import 'package:tobeto_mobile_app/screens/calendar.dart';

class DropDownMenu extends StatelessWidget {
  DropDownMenu({super.key});
  final Widget svg = SvgPicture.asset(
    'img/icons/tobeto_icon.svg',
    semanticsLabel: 'Acme Logo',
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: SizedBox(width: 150, child: svg),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          FutureBuilder<User?>(
            future: AuthService().currentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                // Kullanıcı giriş yapmışsa gösterilecek menü öğeleri
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Anasayfa'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Değerlendirmeler'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReviewsPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Eğitimlerim'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LessonsPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Katalog'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CatalogPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Takvim'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarPage()),
                        );
                      },
                    ),
                  ],
                );
              } else {
                // Kullanıcı giriş yapmamışsa gösterilecek menü öğeleri
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Biz Kimiz?'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Neler Sunuyoruz?'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NelerSunuyoruzPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Eğitimlerimiz'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text("Tobeto'da Neler Oluyor?"),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('İletişim'),
                      onTap: () {},
                    ),
                  ],
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final authService = AuthService();
                final currentUser = await authService.currentUser;
                if (currentUser != null) {
                  // Kullanıcı giriş yapmışsa dropdown menüyü aç
                  showProfileMenu(context);
                } else {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                minimumSize: WidgetStateProperty.all<Size>(const Size(300, 48)),
              ),
              child: FutureBuilder<User?>(
                future: AuthService().currentUser, // AuthService ile mevcut kullanıcıyı al
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final displayName = snapshot.data?.displayName ?? '';
                    return Text(
                      displayName.isNotEmpty ? displayName : 'Giriş Yap',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                '© 2021 Tüm hakları saklıdır.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showProfileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Profilim'),
              onTap: () {
                Navigator.pop(context); // BottomSheet'i kapat
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilesPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Çıkış Yap'),
              onTap: () {
                // Çıkış yap işlemi yapılacak
                AuthService().signOut();
                Navigator.pop(context); // BottomSheet'i kapat
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),

          ],
        );
      },
    );
  }
}
