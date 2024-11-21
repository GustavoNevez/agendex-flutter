import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Bem-vindo!"),
            accountEmail: Text(
              user?.email ?? "Usuário não autenticado",
              style: const TextStyle(color: Colors.white),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.blue,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Meus Agendamentos"),
            onTap: () {
              Navigator.of(context).pushNamed('/meus-agendamentos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
