import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisains_mobile/providers/auth_provider.dart';
import 'package:omnisains_mobile/providers/participation_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final participationsAsync = ref.watch(myParticipationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'U',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(user?.role ?? 'participant'),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Data Diri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    _ProfileRow(label: 'Email', value: user?.email ?? '-'),
                    _ProfileRow(label: 'Sekolah', value: user?.schoolName ?? '-'),
                    _ProfileRow(label: 'No. HP', value: user?.phone ?? '-'),
                    _ProfileRow(label: 'Provinsi', value: user?.province ?? '-'),
                    _ProfileRow(label: 'Kota', value: user?.city ?? '-'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Statistik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    participationsAsync.when(
                      data: (items) => _ProfileRow(label: 'Total Pendaftaran', value: '${items.length} event'),
                      loading: () => const _ProfileRow(label: 'Total Pendaftaran', value: 'Memuat...'),
                      error: (_, __) => const _ProfileRow(label: 'Total Pendaftaran', value: '-'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Kebijakan Privasi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/privacy'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Yakin ingin logout?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(authNotifierProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          const Text(': '),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}