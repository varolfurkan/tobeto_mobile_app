import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/cubits/user_cubit.dart';
import 'package:tobeto_mobile_app/screens/profile.dart';
import 'package:tobeto_mobile_app/screens/what_do_we_offer.dart';
import 'package:tobeto_mobile_app/screens/login_screen.dart';
import 'package:tobeto_mobile_app/screens/home_page.dart';
import 'package:tobeto_mobile_app/screens/reviews.dart';
import 'package:tobeto_mobile_app/screens/platform_page.dart';
import 'package:tobeto_mobile_app/screens/catalog.dart';
import 'package:tobeto_mobile_app/screens/calendar.dart';

class DrawerMenu extends StatelessWidget {
  final Widget svg = SvgPicture.asset(
    'img/icons/tobeto_icon.svg',
    semanticsLabel: 'Acme Logo',
  );

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
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
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (state.firebaseUser != null)
                Column(
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
                          MaterialPageRoute(builder: (context) => const PlatformPage()),
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
                )
              else
                Column(
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
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final userCubit = context.read<UserCubit>();
                    if (userCubit.state.firebaseUser != null) {
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
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    state.firebaseUser != null ? state.firebaseUser!.displayName ?? 'Profilim' : 'Giriş Yap',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
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
      },
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilesPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Çıkış Yap'),
              onTap: ()  {
                 context.read<UserCubit>().signOut();
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
