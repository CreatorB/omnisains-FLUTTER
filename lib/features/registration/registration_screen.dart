import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisains_mobile/models/stage.dart';
import 'package:omnisains_mobile/api/wilayah_repository.dart';
import 'package:omnisains_mobile/api/participation_repository.dart';
import 'package:omnisains_mobile/models/region.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  final int stageId;
  final Stage? stage;

  const RegistrationScreen({super.key, required this.stageId, this.stage});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolController = TextEditingController();

  String? _selectedCity;
  List<Region> _cities = [];
  bool _isSearching = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.stage?.cityNames != null && widget.stage!.cityNames!.isNotEmpty) {
      _loadCitiesFromStage();
    }
  }

  void _loadCitiesFromStage() {
    setState(() {
      _cities = widget.stage!.cityNames!.map((name) => Region(code: name, name: name)).toList();
    });
  }

  Future<void> _searchCities(String query) async {
    if (query.length < 2) {
      setState(() => _cities = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final repo = ref.read(wilayahRepositoryProvider);
      final results = await repo.searchCities(query);
      setState(() {
        _cities = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih kota')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(participationRepositoryProvider);
      await repo.register(widget.stageId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran berhasil!')),
        );
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.stage;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar ${stage?.stageName ?? "Event"}'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stage?.stageName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(stage?.stageType ?? '', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'No. WhatsApp', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(labelText: 'Nama Sekolah', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              if (stage?.cityNames != null && stage!.cityNames!.isNotEmpty) ...[
                const Text('Pilih Kota', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stage.cityNames!.map((city) => ChoiceChip(
                    label: Text(city),
                    selected: _selectedCity == city,
                    onSelected: (selected) => setState(() => _selectedCity = selected ? city : null),
                  )).toList(),
                ),
              ] else ...[
                const Text('Cari Kota', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Autocomplete<Region>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.length < 2) return const [];
                    await _searchCities(textEditingValue.text);
                    return _cities;
                  },
                  displayStringForOption: (option) => option.name,
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Ketik nama kota...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => _searchCities(value),
                    );
                  },
                  onSelected: (option) {
                    setState(() => _selectedCity = option.name);
                  },
                ),
                if (_isSearching) const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Kirim Pendaftaran'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}