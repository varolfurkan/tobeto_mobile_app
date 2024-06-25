import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/drawer_menu.dart';

class InstitutionsPage extends StatelessWidget {
  const InstitutionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'img/icons/tobeto_icon.svg',
              semanticsLabel: 'Acme Logo',
              width: 30,
              height: 30,
            ),
          ],
        ),
      ),
      endDrawer:  DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const _IntroSection(),
            const SizedBox(height: 80),
            _InfoSection(
              color: const Color.fromARGB(255, 97, 4, 190),
              title: 'Doğru yeteneğe ulaşmak için',
              subtitle:
                  'Kurumların değişen yetenek ihtiyaçları için istihdama hazır adaylar yetiştirir.',
              cards: [
                _buildCard(
                  title: 'DEĞERLENDİRME',
                  description:
                      'Değerlendirilmiş ve yetişmiş geniş yetenek havuzuna erişim olanağı ve ölçme, değerlendirme, seçme ve raporlama hizmeti.',
                ),
                _buildCard(
                  title: 'BOOTCAMP',
                  description:
                      'Değerlendirilmiş ve yetişmiş geniş yetenek havuzuna erişim olanağı ve ölçme, değerlendirme, seçme ve raporlama hizmeti.',
                ),
                _buildCard(
                  title: 'EŞLEŞTİRME',
                  description:
                      'Esnek, uzaktan, tam zamanlı iş gücü için doğru ve hızlı işe alım.',
                ),
              ],
            ),
            const SizedBox(height: 80),
            _InfoSection(
              color: const Color.fromARGB(255, 29, 68, 153),
              title: 'Çalışanlarınız için Tobeto',
              subtitle:
                  'Çalışanların ihtiyaçları doğrultusunda, mevcut becerilerini güncellemelerine veya yeni beceriler kazanmalarına destek olur.',
              cards: [
                _buildCard(
                  title: 'ÖLÇME ARAÇLARI',
                  description:
                      'Uzmanlaşmak için yeni beceriler kazanmak (reskill) veya yeni bir role başlamak (upskill) isteyen adaylar için, teknik ve yetkinlik ölçme araçları.',
                ),
                _buildCard(
                  title: 'EĞİTİM',
                  description:
                      'Yeni uzmanlık becerileri ve yeni bir rol için gerekli yetkinlik kazanımı ihtiyaçlarına bağlı olarak açılan eğitimlere katılım ve kuruma özel sınıf açma olanakları.',
                ),
                _buildCard(
                  title: 'GELİŞİM',
                  description:
                      'Kurumsal hedefler doğrultusunda mevcut yetenek gücünün gelişimi ve konumlandırılmasına destek.',
                ),
              ],
            ),
            const SizedBox(height: 60),
            const _ContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Tobeto;\nyetenekleri\nKeşfeder,\ngeliştirir ve\nyeni işine\nhazırlar\n',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 54, 43, 84),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage('img/institutions1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          width: 370,
          height: 250,
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final List<Widget> cards;

  const _InfoSection({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      padding: const EdgeInsets.all(16.0),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ...cards,
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF8A2BE2),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Kurumlara özel eğitim paketleri ve bootcamp programları için bizimle iletişime geçin.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 153, 51, 255),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Bize Ulaşın',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
