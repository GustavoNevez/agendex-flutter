import 'package:agendex_flutter/views/autenticacao_tela.dart';
import 'package:agendex_flutter/views/home_view.dart';
import 'package:agendex_flutter/views/scheduling_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agendex',
      home: const RouterScript(),
      routes: {
        '/meus-agendamentos': (context) => const MySchedulesScreen(),
      },
    );
  }
}

class RouterScript extends StatelessWidget {
  const RouterScript({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeView();
        } else {
          return const AutenticacaoTela();
        }
      },
    );
  }
}
