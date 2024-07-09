import 'package:flutter/material.dart';

import 'skills_item.dart';

class SkillsCard extends StatelessWidget {
  const SkillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yetkinliklerim',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            SkillItem(label: 'Uygulama Mağazası (iOS)'),
            SkillItem(label: 'Algoritmalar'),
            SkillItem(label: 'Apple iOS'),
            SkillItem(label: 'Apple Xcode'),
          ],
        ),
      ),
    );
  }
}
