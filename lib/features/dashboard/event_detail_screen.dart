import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisains_mobile/models/stage.dart';
import 'package:omnisains_mobile/api/participation_repository.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String stageId;
  final Stage? stage;

  const EventDetailScreen({super.key, required this.stageId, this.stage});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isRegistering = false;

  Future<void> _handleRegister() async {
    setState(() => _isRegistering = true);
    try {
      final repo = ref.read(participationRepositoryProvider);
      await repo.register(int.parse(widget.stageId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran berhasil!')),
        );
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendaftar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.stage;
    final stageName = stage?.stageName ?? 'Event';
    final isOpen = stage?.isRegistrationOpen ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(stageName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.event, size: 64, color: Colors.blue.shade700),
                    const SizedBox(height: 16),
                    Text(
                      stage.stageName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        stage.stageType,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (stage.description != null) ...[
                const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(stage.description!),
                const SizedBox(height: 24),
              ],
              if (stage.cityNames != null && stage.cityNames!.isNotEmpty) ...[
                const Text('Kota Pelaksanaan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stage.cityNames!.map((city) => Chip(
                    label: Text(city),
                    backgroundColor: Colors.blue.shade100,
                  )).toList(),
                ),
                const SizedBox(height: 24),
              ],
              const Text('Info Penting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.calendar_today, size: 20), SizedBox(width: 8), Text('Pendaftaran dibukan untuk umum')]),
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.check_circle, size: 20), SizedBox(width: 8), Text('Sistem penilaian transparan')]),
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.workspace_premium, size: 20), SizedBox(width: 8), Text('Sertifikat resmi untuk peserta')]),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Center(child: Text('Detail tidak tersedia'))
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isOpen && !_isRegistering ? _handleRegister : null,
                child: _isRegistering
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isOpen ? 'Daftar Sekarang' : 'Pendaftaran Ditutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}