import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../widgets/drawer_menu.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

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
      body: Column(
        children: [
          const Text(
            'Blog',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('blogs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No blogs available'));
                }

                List<DocumentSnapshot> blogs = snapshot.data!.docs;

                blogs.sort((a, b) {
                  DateTime dateA = parseDate(a['createdAt']);
                  DateTime dateB = parseDate(b['createdAt']);
                  return dateB.compareTo(dateA);
                });

                return ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    var blog = blogs[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Blog Adı'),
                              content: Text('Tıklandı: ${blog['title']}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Tamam'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  blog['img'],
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                blog['createdAt'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                blog['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                blog['description'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DateTime parseDate(String date) {
    final format = DateFormat('d MMMM yyyy', 'tr');
    return format.parse(date);
  }
}
