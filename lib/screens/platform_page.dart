import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tobeto_mobile_app/cubits/user_cubit.dart';
import 'package:tobeto_mobile_app/widgets/drawer_menu.dart';

class PlatformPage extends StatelessWidget {
  const PlatformPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'img/icons/tobeto_icon.svg',
          width: 150,
          semanticsLabel: 'Tobeto Logo',
        ),
      ),
      endDrawer: DrawerMenu(),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text('Hata: ${state.error}'));
          } else {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (state.firebaseUser != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'TOBETO',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff9933ff),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\'ya hoş geldin\n',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xff4d4d4d),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: state.firebaseUser?.displayName ?? 'Kullanıcı',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xff4d4d4d),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Yeni nesil öğrenme deneyimi ile Tobeto kariyer yolculuğunda senin yanında!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff4d4d4d),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  SvgPicture.asset(
                                    'img/icons/ik_logo.svg',
                                    width: 200,
                                    semanticsLabel: 'İstanbul Kodluyor Logo',
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Ücretsiz eğitimlerle, geleceğin mesleklerinde sen de yerini al.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff4d4d4d),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Aradığın ',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '"',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff00d29f),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'İş',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '"',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff00d29f),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Burada!',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ];
              },
              body: DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    const TabBar(
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'Başvurularım'),
                        Tab(text: 'Eğitimlerim'),
                        Tab(text: 'Duyuru ve Haberlerim'),
                        Tab(text: 'Anketlerim'),
                        Tab(text: 'İş Süreçlerim'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          const Center(child: Text('Başvurularım içerikleri')),
                          _buildLessonsList(state),
                          _buildNotificationsList(state),
                          const Center(child: Text('Anketlerim içerikleri')),
                          const Center(child: Text('İş Süreçlerim içerikleri')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLessonsList(UserState state) {
    if (state.lessons == null || state.lessons!.isEmpty) {
      return const Center(child: Text('Şu an atanmış bir dersiniz bulunmamaktadır.'));
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.lessons!.length,
        itemBuilder: (context, index) {
          var lesson = state.lessons![index];
          var formattedDate = lesson.formattedDate();
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: lesson.imageUrl.isNotEmpty
                        ? Image.network(lesson.imageUrl)
                        : const Icon(Icons.photo, size: 150),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Implement navigation to lesson details or another action
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black, backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text('Eğitime Git'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildNotificationsList(UserState state) {
    if (state.notifications == null || state.notifications!.isEmpty) {
      return const Center(child: Text('Şu an bir duyurunuz bulunmamaktadır.'));
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.notifications!.length,
        itemBuilder: (context, index) {
          var notification = state.notifications![index];
          var formattedDate = notification.formattedDate();
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.type,
                          style: const TextStyle(color: Color(0xff00956e)),
                        ),
                        const Text(
                          'İstanbul Kodluyor',
                          style: TextStyle(color: Color(0xff00956e)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xff4d4d4d)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        Text(
                          formattedDate,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => SingleChildScrollView(
                                  child: AlertDialog(
                                    title: Text(notification.title),
                                    content: Text(notification.contents),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Kapat'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Devamını Oku'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

}
