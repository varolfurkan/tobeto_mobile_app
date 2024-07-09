import 'package:flutter/material.dart';
import 'experience_item.dart';

class ProfessionalExperienceCard extends StatelessWidget {
  const ProfessionalExperienceCard({super.key});

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
              'Profesyonel İş Deneyimi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            ExperienceItem(
              date: 'Kasım 2021 - Ocak 2023',
              description: 'Anibal Bilişim - Flutter Developer',
            ),
          ],
        ),
      ),
    );
  }
}
