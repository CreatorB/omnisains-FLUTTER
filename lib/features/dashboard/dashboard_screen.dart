import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisains_mobile/providers/event_provider.dart';
import 'package:omnisains_mobile/providers/participation_provider.dart';
import 'package:omnisains_mobile/providers/auth_provider.dart';
import 'package:omnisains_mobile/models/stage.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(stagesProvider);
    final participationsAsync = ref.watch(myParticipationsProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Omnisains'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(stagesProvider);
          ref.invalidate(myParticipationsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (authState.user != null) ...[
                Text(
                  'Halo, ${authState.user!.fullName}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  authState.user!.schoolName ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
              ],
              const Text(
                'Pendaftaran Event',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              stagesAsync.when(
                data: (stages) {
                  if (stages.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: Text('Tidak ada event aktif saat ini')),
                      ),
                    );
                  }
                  return Column(
                    children: stages.map((stage) => _StageCard(stage: stage)).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text('Gagal memuat: $e'),
                        TextButton(
                          onPressed: () => ref.invalidate(stagesProvider),
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Event Saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              participationsAsync.when(
                data: (participations) {
                  if (participations.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: Text('Belum ada pendaftaran')),
                      ),
                    );
                  }
                  return Column(
                    children: participations.map((p) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(p.eventDisplayName),
                        subtitle: Text('No. Peserta: ${p.participantNumber}'),
                        trailing: Chip(
                          label: Text(
                            p.paymentStatus ?? p.status ?? 'Unknown',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    )).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Gagal memuat: $e'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final Stage stage;

  const _StageCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/event/${stage.id}', extra: stage),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      stage.stageType,
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                  const Spacer(),
                  if (stage.isRegistrationOpen)
                    const Chip(
                      label: Text('Buka', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                stage.stageName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (stage.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  stage.description!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (stage.cityNames != null && stage.cityNames!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: stage.cityNames!.take(5).map((city) => Chip(
                    label: Text(city, style: const TextStyle(fontSize: 10)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: stage.isRegistrationOpen
                      ? () => context.push('/register/${stage.id}', extra: stage)
                      : null,
                  child: const Text('Daftar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}