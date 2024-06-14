import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageWidgets {
  // Bu widget, bir kart oluşturur ve verilen resim, başlık ve açıklamalar ile doldurur
  static Widget buildCard({
    required String imageUrl,
    required String title,
    required String description,
    required String description2,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 0), // Kartın yatay boşluğu
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Kartın köşe yuvarlatma değeri
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // İçerik hizalaması
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 32.0,
                  bottom: 24,
                  left: 28,
                  right: 28), // Resim etrafındaki boşluklar
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  24.0), // Başlık metni etrafındaki boşluklar
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 24.0,
                left: 24.0,
                bottom: 12,
              ), // Açıklama metni etrafındaki boşluklar
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            // İkinci açıklama metni ile arasındaki boşluk
            Padding(
              padding: const EdgeInsets.only(
                right: 24.0,
                left: 24.0,
                bottom: 12,
              ), // İkinci açıklama metni etrafındaki boşluklar
              child: Text(
                description2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bu widget, bilgi kartı oluşturur ve verilen simge, sayı, açıklamalar ve renklerle doldurur
  static Widget buildInfoCard({
    required String iconPath,
    required String count,
    required String description,
    required String description2,
    required Color textColor,
    required Color iconBackgroundColor,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(30), // Kartın köşe yuvarlatma değeri
      ),
      child: Padding(
        padding: const EdgeInsets.all(
            24.0), // Kartın içindeki içerik etrafındaki boşluklar
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Kartın boyutunun içeriğe göre ayarlanması
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: iconBackgroundColor, // Simge arka plan rengi
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 42,
                  height: 42,
                ),
              ),
            ),
            const SizedBox(height: 16), // Simge ile sayı arasındaki boşluk
            Text(
              count,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: textColor, // Yazı rengi
              ),
            ),
            const SizedBox(height: 16), // Sayı ile açıklama metni arasındaki boşluk
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700], // Açıklama yazısı rengi
              ),
            ),
            Text(
              description2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700], // Açıklama yazısı rengi
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildGifCard({
    required String imageUrl,
    required String title,
    required String title2,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Kartın yatay boşluğu
      child: SingleChildScrollView(
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Kartın köşe yuvarlatma değeri
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // İçerik hizalaması
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 370,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 12, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      title2,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                    24.0), // Açıklama metni etrafındaki boşluklar
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              // İkinci açıklama metni ile arasındaki boşluk
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 116, 40, 208)),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(200, 32)),
                  ),
                  child: const Text(
                    'Hemen Başla',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
