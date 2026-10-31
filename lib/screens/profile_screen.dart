import 'package:flutter/material.dart';
import 'catalog_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Coffee Lover',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text('coffee.lover@example.com'),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Notifications'),
              value: notifications,
              onChanged: (value) {
                setState(() {
                  notifications = value;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Smart Catalog (LW8)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CatalogScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}