import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/cubits/user_cubit.dart';
import 'package:tobeto_mobile_app/screens/profile.dart';
import 'package:tobeto_mobile_app/screens/login_screen.dart';
import 'package:tobeto_mobile_app/screens/home_page.dart';
import 'package:tobeto_mobile_app/screens/reviews.dart';
import 'package:tobeto_mobile_app/screens/platform_page.dart';
import 'package:tobeto_mobile_app/screens/catalog.dart';
import 'package:tobeto_mobile_app/screens/calendar.dart';
import 'package:tobeto_mobile_app/screens/who_are_we.dart';

import '../screens/blog_page.dart';
import '../screens/individuals_page.dart';
import '../screens/institutions_page.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final Widget svg = SvgPicture.asset(
    'img/icons/tobeto_icon.svg',
    semanticsLabel: 'Acme Logo',
  );

  bool _isExpandedWhatWeOffer = false;
  bool _isExpandedWhatsHappening = false;

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
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
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
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Değerlendirmeler'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReviewsPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Eğitimlerim'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlatformPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Katalog'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CatalogPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Takvim'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalendarPage()),
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
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const WhoAreWe()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Neler Sunuyoruz?',
                        style: TextStyle(
                            color: _isExpandedWhatWeOffer
                                ? const Color.fromARGB(255, 153, 51, 255)
                                : Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          _isExpandedWhatWeOffer = !_isExpandedWhatWeOffer;
                        });
                      },
                    ),
                    if (_isExpandedWhatWeOffer)
                      Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  const Color.fromARGB(255, 153, 51, 255),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: const Text(
                                    'Bireyler için',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const IndividualsPage()),
                                    );
                                  },
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  const Color.fromARGB(255, 153, 51, 255),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: const Text(
                                    'Kurumlar için',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const InstitutionsPage()),
                                    );
                                  },
                                ),
                              )),
                        ],
                      ),
                    ListTile(
                      title: const Text('Eğitimlerimiz'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        "Tobeto'da Neler Oluyor?",
                        style: TextStyle(
                            color: _isExpandedWhatsHappening
                                ? const Color.fromARGB(255, 153, 51, 255)
                                : Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          _isExpandedWhatsHappening =
                          !_isExpandedWhatsHappening;
                        });
                      },
                    ),
                    if (_isExpandedWhatsHappening)
                      Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  const Color.fromARGB(255, 153, 51, 255),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: const Text(
                                    'Blog',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const BlogPage()),
                                    );
                                  },
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  const Color.fromARGB(255, 153, 51, 255),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: const Text(
                                    'Basında Biz',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {},
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                  const Color.fromARGB(255, 153, 51, 255),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: const Text(
                                    'İstanbul Kodluyor',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {},
                                ),
                              )),
                        ],
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
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.black),
                    minimumSize:
                    WidgetStateProperty.all<Size>(const Size(300, 48)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    state.firebaseUser != null
                        ? state.firebaseUser!.displayName ?? 'Profilim'
                        : 'Giriş Yap',
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
              onTap: () {
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
