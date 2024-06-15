import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:tobeto_mobile_app/cubits/admin_cubit.dart';
import 'package:tobeto_mobile_app/cubits/user_cubit.dart';
import 'package:tobeto_mobile_app/firebase_options.dart';
import 'package:tobeto_mobile_app/repository/user_repository.dart';
import 'package:tobeto_mobile_app/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await findSystemLocale().then((locale) {
    Intl.defaultLocale = locale;
    return initializeDateFormatting(locale, null);
  });
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(UserRepository()),
        ),
        BlocProvider<AdminCubit>(
            create: (context) => AdminCubit(UserRepository()..getCurrentUser()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
          useMaterial3: true,
        ),
        home:  const HomePage(),
      ),
    );
  }
}
