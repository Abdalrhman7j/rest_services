import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../auth/data/repositories/auth_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CircleAvatar(radius: 34, child: Text((user.displayName ?? user.email ?? 'U').substring(0, 1).toUpperCase())),
            const SizedBox(height: 12),
            Text(user.displayName?.isNotEmpty == true ? user.displayName! : 'Customer', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
            Text(user.email ?? '', textAlign: TextAlign.center),
            const SizedBox(height: 28),
            const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Addresses'), subtitle: Text('Address management is coming next.')),
            const Divider(),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Sign out'), onTap: () => AuthRepository().signOut()),
          ],
        ),
      ),
    );
  }
}
