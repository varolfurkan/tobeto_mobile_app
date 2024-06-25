import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tobeto_mobile_app/widgets/dropdown_widget.dart';
import 'package:tobeto_mobile_app/widgets/homepage_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class WhoAreWe extends StatefulWidget {
  const WhoAreWe({Key? key}) : super(key: key);

  @override
  State<WhoAreWe> createState() => _WhoAreWeState();
}

class _WhoAreWeState extends State<WhoAreWe> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset('img/who_are_we1.mp4');
    videoPlayerController.initialize().then((_) {
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
        );
      });
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: DropDownMenu(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomPaint(
                painter: BorderPainter(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: HeaderSection(
                    videoPlayerController: videoPlayerController,
                    chewieController: chewieController,
                  ),
                ),
              ),
            ),
            buildInfoCards(),

            buildTextAnimeSection(), // Bu satırı ekleyin
            tobetoTeams(),
            officeAndSocial()
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final ChewieController? chewieController;

  const HeaderSection({
    Key? key,
    required this.videoPlayerController,
    this.chewieController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'img/icons/who_are_we_icon.svg',
                ),
                const SizedBox(width: 40),
                const Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Yeni Nesil ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Mesleklere,',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Yeni Nesil',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '"Platform!"',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: chewieController != null &&
                      chewieController!
                          .videoPlayerController.value.isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Chewie(
                        controller: chewieController!,
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Sol üst köşe
    path.moveTo(0, 0);
    path.lineTo(100, 0);
    path.moveTo(0, 0);
    path.lineTo(0, 100);

    // Sağ alt köşe
    path.moveTo(size.width, size.height);
    path.lineTo(size.width - 100, size.height);
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, size.height - 100);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Widget buildInfoCards() {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            'img/who_are_we2.png',
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Yeni nesil mesleklerdeki yetenek açığının mevcut yüksek deneyim ve beceri beklentisinden uzaklaşıp yeteneği keşfederek ve onları en iyi versiyonlarına ulaştırarak çözülebileceğine inanıyoruz. Tobeto; yetenekleri potansiyellerine göre değerlendirir, onları en uygun alanlarda geliştirir ve değer yaratacak projelerle eşleştirir. YES (Yetiş-Eşleş-Sürdür) ilkesini benimseyen herkese Tobeto Ailesi'ne katılmaya davet ediyor.",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            'img/who_are_we3.jpg',
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Günümüzde meslek hayatında yer almak ve kariyerinde yükselmek için en önemli unsurların başında dijital beceri sahibi olmak geliyor. Bu ihtiyaçların tamamını karşılamak için içeriklerimizi Tobeto Platform’da birleştirdik.",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            'img/homepage_1.png',
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Öğrencilerin teoriyi anlamalarını önemsemekle beraber uygulamayı merkeze alan bir öğrenme yolculuğu sunuyoruz. Öğrenciyi sürekli gelişim, geri bildirim döngüsünde tutarak yetenek ve beceri kazanımını hızlandırıyoruz.",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ],
    ),
  );
}

Widget tobetoDifference() {
  return const Padding(
    padding: EdgeInsets.all(20.0),
    child: Column(
      children: [
        Text(
          "Tobeto Farkı Nedir?",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget tobetoTeamCard(String teamImg, String teamName, String teamPosition) {
  return Padding(
    padding: EdgeInsets.all(20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(teamImg),
          radius: 80,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          teamName,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          teamPosition,
          style: TextStyle(
            fontSize: 22,
          ),
        )
      ],
    ),
  );
}

Widget tobetoTeams() {
  return Column(
    children: [
      const Text(
        'Ekibimiz',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomPaint(
            painter: BorderPainter(),
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: tobetoTeamCard(
                      'img/tobetoElif.jpeg', 'Elif Kılıç', 'Kurucu Direktör'),
                ),
              ],
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomPaint(
            painter: BorderPainter(),
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: tobetoTeamCard('img/tobetoKader.jpg', 'Kader Yavuz',
                      'Eğitim ve Proje Koordinatörü'),
                ),
              ],
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomPaint(
            painter: BorderPainter(),
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: tobetoTeamCard('img/tobetoKader.jpg', 'Pelin Batır',
                      'İş Geliştirme Yöneticisi'),
                ),
              ],
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomPaint(
            painter: BorderPainter(),
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: tobetoTeamCard(
                      'img/tobetoGurkan.jfif',
                      'Gürkan İlişen',
                      'Eğitim Teknolojileri ve Platform Sorumlusu'),
                ),
              ],
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomPaint(
            painter: BorderPainter(),
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: tobetoTeamCard('img/tobetoAli.jpg', 'Ali Seyhan',
                      'Operasyon Uzman Yardımcısı'),
                ),
              ],
            )),
      ),
    ],
  );
}

Widget textAnime() {
  return TextAnimatorSequence(
    tapToProceed: true,
    loop: true,
    transitionTime: const Duration(seconds: 3),
    children: [
      TextAnimator(
        'Zengin eğitim kütüphanesi',
        textAlign: TextAlign.center,
        maxLines: 2,
        incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
        outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToBottom(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.purple,
          color: Colors.white,
          letterSpacing: -1,
          fontSize: 20,
        ),
      ),
      TextAnimator(
        'Codecademy ile uluslararası geçerliliğe sahip sertifika fırsatı',
        textAlign: TextAlign.center,
        maxLines: 2,
        incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
        outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToBottom(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.purple,
          color: Colors.white,
          letterSpacing: -1,
          fontSize: 20,
        ),
      ),
      TextAnimator(
        'Global kariyer fırsatları',
        textAlign: TextAlign.center,
        maxLines: 2,
        incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
        outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToBottom(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.purple,
          color: Colors.white,
          letterSpacing: -1,
          fontSize: 20,
        ),
      ),
    ],
  );
}

Widget buildTextAnimeSection() {
  return SizedBox(
    height: 300,
    width: 400,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Tobeto Farkı Nedir?",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        textAnime(),
      ],
    ),
  );
}

Widget officeAndSocial() {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ofisimiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Kavacık, Rüzgarlıbahçe Mah. Çampınarı Sok. No:4 Smart Plaza B Blok Kat:3 34805, Beykoz, İstanbul',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SocialMediaButton(
            iconData: FontAwesomeIcons.facebook,
            color: Color(0xFF3b5998),
            url: 'https://www.facebook.com',
          ),
          SocialMediaButton(
            iconData: FontAwesomeIcons.twitter,
            color: Color(0xFF00acee),
            url: 'https://www.twitter.com',
          ),
          SocialMediaButton(
            iconData: FontAwesomeIcons.linkedin,
            color: Color(0xFF0e76a8),
            url: 'https://www.linkedin.com',
          ),
          SocialMediaButton(
            iconData: FontAwesomeIcons.instagram,
            color: Color(0xFFe4405f),
            url: 'https://www.instagram.com',
          ),
        ],
      ),
    ],
  );
}

class SocialMediaButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final String url;

  SocialMediaButton(
      {required this.iconData, required this.color, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle the social media button tap here
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
