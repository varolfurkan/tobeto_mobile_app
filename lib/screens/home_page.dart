import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/widgets/drawer_menu.dart';
import 'package:tobeto_mobile_app/widgets/homepage_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Map<String, String>> profiles = [
    {
      'image': 'img/students.png',
      'username': 'Emre',
      'comment':
      'Tobeto’daki .NET ve React Fullstack eğitimi, yazılım dünyasında daha sağlam adım atmamı sağlayan önemli bir deneyim oldu. Bu eğitimde hem teknik bilgi hem de pratik uygulama becerileri kazandım.',
    },
    {
      'image': 'img/students.png',
      'username': 'Ali',
      'comment':
      'Tobeto ekibi her zaman yardımcı oldu ve sorularımı cevaplamak için ellerinden geleni yaptı. Bu süreçte aldığım destek sayesinde, şimdi daha güvenli bir şekilde yazılım geliştirme yolculuğuma devam edebiliyorum.',
    },
    {
      'image': 'img/students.png',
      'username': 'Ayşe',
      'comment':
      'Tobeto’daki eğitim süreci, şimdi iş dünyasına hazır olduğumu hissettiriyor. Teşekkürler Tobeto!',
    },
    {
      'image': 'img/students.png',
      'username': 'Ahmet',
      'comment':
      'Ayrıca, softskill eğitimleri sayesinde iletişim ve problem çözme yeteneklerim de gelişti.',
    },
  ];

  void onProfileTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E7E7),
      appBar: AppBar(
        title: SizedBox(
          width: 150,
          child: SvgPicture.asset('img/icons/tobeto_icon.svg',
              semanticsLabel: 'Acme Logo'), // Uygulama logosu
        ),
      ),
      endDrawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 35,),
                buildPageView(), // PageView içeren widget
                buildHeaderText(), // Başlık metni içeren widget
                const SizedBox(height: 40),
                buildInfoCards(), // Bilgi kartlarını içeren widget
                const SizedBox(height: 30),
                buildProfileSection(), // Profil ve yorumları içeren widget
              ],
            ),
          ),
        ),
      ),
    );
  }

  // PageView içeren widget
  Widget buildPageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.83, // Yükseklik oranı
      child: PageView(
        children: [
          HomePageWidgets.buildCard(
            imageUrl: 'img/homepage_1.png',
            title: 'Hayalindeki teknoloji kariyerini Tobeto ile başlat.',
            description:
            'Tobeto eğitimlerine katıl, sen de harekete geç, iş hayatında yerini al.',
            description2: '',
          ),
          HomePageWidgets.buildCard(
            imageUrl: 'img/homepage_2.jpg',
            title: 'Tobeto Platform',
            description: 'Eğitim ve istihdam arasında köprü görevi görür',
            description2:
            'Eğitim, değerlendirme, istihdam süreçlerinin tek yerden yönetilebileceği dijital platform olarak hem bireylere hem kurumlara hizmet eder.',
          ),
        ],
      ),
    );
  }

  // Başlık metni içeren widget
  Widget buildHeaderText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Birlikte ',
          style: TextStyle(color: Colors.deepPurple[400], fontSize: 34),
        ),
        Text(
          'Büyüyoruz!',
          style: TextStyle(
              color: Colors.deepPurple[600],
              fontSize: 34,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  // Bilgi kartlarını içeren widget
  Widget buildInfoCards() {
    return Column(
      children: [
        SizedBox(
          width: 280,
          child: HomePageWidgets.buildInfoCard(
            iconPath: 'img/icons/asenkron_egitim_icon.svg',
            count: '8,000',
            description: 'Asenkron Eğitim ',
            description2: 'İçeriği',
            textColor: const Color(0xFF6E2089),
            iconBackgroundColor: const Color.fromARGB(255, 166, 148, 172),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 280,
          child: HomePageWidgets.buildInfoCard(
            iconPath: 'img/icons/company.svg',
            count: '1,000',
            description: 'Saat Canlı Ders',
            description2: '',
            textColor: const Color(0xFF6E2089),
            iconBackgroundColor: const Color.fromARGB(255, 166, 148, 172),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 280,
          child: HomePageWidgets.buildInfoCard(
            iconPath: 'img/icons/student.svg',
            count: '17,600',
            description: ' Öğrenci ',
            description2: ' ',
            textColor: const Color(0xFF0E56A3),
            iconBackgroundColor: const Color(0xFFA2C3E6),
          ),
        ),
        const SizedBox(height: 30),
        HomePageWidgets.buildGifCard(
            imageUrl: 'img/homepage_3.gif',
            title: 'Tobeto "İşte Başarı Modeli"mizi ',
            title2: 'Keşfet!',
            description:
            "Üyelerimize ücretsiz sunduğumuz, iş bulma ve işte başarılı olma sürecinde gerekli 80 tane davranış ifadesinden oluşan Tobeto 'İşte Başarı Modeli' ile, profesyonellik yetkinliklerini ölç, raporunu gör.")
      ],
    );
  }

  // Profil ve yorumları içeren widget
  Widget buildProfileSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Text(
                      'Öğrenci Görüşleri',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Tobeto’yu öğrencilerimizin gözünden keşfedin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(profiles.length, (index) {
                  return GestureDetector(
                    onTap: () => onProfileTap(index),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(profiles[index]['image']!),
                      backgroundColor: selectedIndex == index
                          ? Colors.purple
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.purple, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      profiles[selectedIndex]['comment']!,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                        AssetImage(profiles[selectedIndex]['image']!),
                      ),
                    ),
                    Text(
                      profiles[selectedIndex]['username']!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
