import 'package:flutter/material.dart';

import 'education_item.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({super.key});

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
              'Eğitim Hayatım',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            EducationItem(
              date: 'Ocak 2014 - Ocak 2019',
              description: 'Beykent Üniversitesi - Bilgisayar Mühendisliği',
            ),
          ],
        ),
      ),
    );
  }
}
