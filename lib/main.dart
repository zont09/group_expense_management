import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/features/login/login_main_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      home: BlocProvider(
        create: (context) => MainCubit(),
        child: BlocBuilder<MainCubit, int>(
          builder: (c, s) {
            return LoginMainView();
          },
        ),
      ),
    );
  }
}
