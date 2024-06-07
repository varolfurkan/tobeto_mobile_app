import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tobeto_mobile_app/cubits/admin_cubit.dart';
import 'package:tobeto_mobile_app/repository/user_repository.dart';
import 'package:tobeto_mobile_app/widgets/drawer_menu.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

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
      body: BlocProvider(
        create: (context) => AdminCubit(UserRepository())..getCurrentUser(),
        child: BlocBuilder<AdminCubit, AdminState>(
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
                                            text: state.adminName ?? 'Admin',
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
                                      'Admin paneline hoş geldiniz!',
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
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ];
                },
                body: const Center(child: Text('Admin sayfası içerikleri burada yer alacak.')),
              );
            }
          },
        ),
      ),
    );
  }
}

