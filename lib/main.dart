import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/features/login/login_main_view.dart';
import 'package:group_expense_management/features/overview/views/overview_main_view.dart';
import 'package:group_expense_management/features/splash/splash_screen.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider(
    create: (context) => MainCubit()..initData(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Expense Management',
      theme: ThemeData(
        fontFamily: 'Afacad',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: BlocBuilder<MainCubit, int>(
        builder: (c, s) {
          if(s == 0) {
            return const SplashScreen();
          }
          if (AuthService.isLoggedIn) {
            return const OverviewMainView();
          }
          return const LoginMainView();
        },
      ),
    );
  }
}
