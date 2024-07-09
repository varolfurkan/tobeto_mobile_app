import 'package:flutter/material.dart';

import 'language_item.dart';

class LanguagesCard extends StatelessWidget {
  const LanguagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yabancı Dillerim',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            LanguageItem(label: 'İngilizce', level: 'Orta Seviye (B1, B2)'),
          ],
        ),
      ),
    );
  }
}
