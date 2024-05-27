import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/screens/what_do_we_offer.dart';
import 'package:tobeto_mobile_app/screens/login_screen.dart';
import 'package:tobeto_mobile_app/screens/home_page.dart';

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
                MaterialPageRoute(builder: (context) => NelerSunuyoruzPage()),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                minimumSize: WidgetStateProperty.all<Size>(const Size(300, 48)),
              ),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(
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
  }
}
