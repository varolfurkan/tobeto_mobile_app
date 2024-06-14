import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/career_card.dart';
import '../widgets/drawer_menu.dart';

class IndividualsPage extends StatelessWidget {
  const IndividualsPage({super.key});

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
      endDrawer: const DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            _buildIntroSection(),
            const SizedBox(height: 80),
            _buildImageSection('img/individual2.jpg'),
            const SizedBox(height: 20),
            _buildJourneySection(
              title: 'Eğitim Yolculuğu',
              description:
                  'Uzmanlaşmak istediğin alanı seç, Tobeto Platform\'da \'Eğitim Yolculuğu\'na şimdi başla.',
              points: [
                'Videolu içerikler',
                'Canlı dersler',
                'Mentör desteği',
                'Hibrit eğitim modeli',
              ],
            ),
            const SizedBox(height: 20),
            _buildJourneySection(
              title: 'Öğrenme Yolculuğu',
              description:
                  'Deneyim sahibi olmak istediğin alanda "Öğrenme Yolculuğu\'na" başla. Yazılım ekipleri ile çalış.',
              points: [
                'Sektör projeleri',
                'Fasilitatör desteği',
                'Mentör desteği',
                'Hibrit eğitim modeli',
              ],
            ),
            const SizedBox(height: 80),
            _buildImageSection('img/individual3.jpg'),
            const SizedBox(height: 80),
            _buildImageSection('img/individual4.jpg'),
            const SizedBox(height: 20),
            _buildJourneySection(
              title: 'Kariyer Yolculuğu',
              description:
                  'Kariyer sahibi olmak istediğin alanda "Kariyer Yolculuğu\'na" başla. Aradığın desteği Tobeto Platform\'da yakala.',
              points: [
                'Birebir mentör desteği',
                'CV Hazırlama desteği',
                'Mülakat simülasyonu',
                'Kariyer buluşmaları',
              ],
            ),
            const SizedBox(height: 80),
            _buildCareerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      color: const Color.fromARGB(255, 233, 232, 255),
      height: 750,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Center(
            child: Text.rich(
              TextSpan(
                text: 'Kontrol\nsende\n',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'adım at,',
                    style: TextStyle(
                      color: Color.fromARGB(255, 153, 51, 255),
                    ),
                  ),
                  TextSpan(
                    text: '\nTobeto ile\nfark yarat!',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'img/individual.png',
              width: 300,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        width: 700,
        height: 500,
      ),
    );
  }

  Widget _buildJourneySection({
    required String title,
    required String description,
    required List<String> points,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...points.map((point) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
                child: Text(
                  '• $point',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCareerSection() {
    return Container(
      height: 900,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 153, 51, 255),
            Color.fromARGB(255, 93, 98, 232),
          ],
          stops: [0.4, 0.4],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Kariyeriniz için',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'en iyi',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'yolculuklar',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(16.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: const [
              CareerCard(title: 'AI', subtitle: 'PROMPTING'),
              CareerCard(title: 'PROJE', subtitle: 'YÖNETİMİ'),
              CareerCard(title: 'FULL STACK', subtitle: 'DEVELOPER'),
              CareerCard(title: 'İŞ', subtitle: 'ANALİSTİ'),
              CareerCard(title: 'DİJİTAL', subtitle: 'PAZARLAMA'),
              CareerCard(title: 'YAZILIM', subtitle: 'KALİTE VE TEST'),
            ],
          ),
        ],
      ),
    );
  }
}
