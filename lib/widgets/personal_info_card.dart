import 'package:flutter/material.dart';

import 'info_row.dart';

class PersonalInfoCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PersonalInfoCard({super.key, required this.userData});

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
              'Kişisel Bilgiler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            InfoRow(label: 'Doğum Tarihi', value: userData['birthDate'] ?? ''),
            InfoRow(
                label: 'Adres',
                value:
                    '${userData['city'] ?? ''} ${userData['district'] ?? ''}'),
            InfoRow(
                label: 'Telefon Numarası',
                value: userData['phoneNumber'] ?? ''),
            InfoRow(label: 'E-Posta Adresi', value: userData['email'] ?? ''),
            InfoRow(label: 'Cinsiyet', value: userData['gender'] ?? ''),
            InfoRow(
                label: 'Askerlik Durumu',
                value: userData['militaryStatus'] ?? ''),
            InfoRow(
                label: 'Engellilik Durumu',
                value: userData['disabilityStatus'] ?? ''),
          ],
        ),
      ),
    );
  }
}
