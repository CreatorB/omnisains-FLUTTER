import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omnisains_mobile/providers/auth_provider.dart';
import 'package:omnisains_mobile/api/wilayah_repository.dart';
import 'package:omnisains_mobile/models/region.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  String _gender = 'L';
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedVillage;

  List<Province> _provinces = [];
  List<Region> _cities = [];
  List<Region> _districts = [];
  List<Region> _villages = [];

  bool _obscurePassword = true;
  bool _isLoadingRegions = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _schoolNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadProvinces() async {
    setState(() => _isLoadingRegions = true);
    try {
      final repo = ref.read(wilayahRepositoryProvider);
      final provinces = await repo.getProvinces();
      setState(() {
        _provinces = provinces;
        _isLoadingRegions = false;
      });
    } catch (e) {
      setState(() => _isLoadingRegions = false);
    }
  }

  Future<void> _loadCities(String provinceCode) async {
    try {
      final repo = ref.read(wilayahRepositoryProvider);
      final cities = await repo.getRegencies(provinceCode);
      setState(() {
        _cities = cities;
        _selectedCity = null;
        _districts = [];
        _villages = [];
      });
    } catch (e) {
      debugPrint('Error loading cities: $e');
    }
  }

  Future<void> _loadDistricts(String regencyCode) async {
    try {
      final repo = ref.read(wilayahRepositoryProvider);
      final districts = await repo.getDistricts(regencyCode);
      setState(() {
        _districts = districts;
        _selectedDistrict = null;
        _villages = [];
      });
    } catch (e) {
      debugPrint('Error loading districts: $e');
    }
  }

  Future<void> _loadVillages(String districtCode) async {
    try {
      final repo = ref.read(wilayahRepositoryProvider);
      final villages = await repo.getVillages(districtCode);
      setState(() {
        _villages = villages;
        _selectedVillage = null;
      });
    } catch (e) {
      debugPrint('Error loading villages: $e');
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProvince == null || _selectedCity == null ||
        _selectedDistrict == null || _selectedVillage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data wilayah')),
      );
      return;
    }

    await ref.read(authNotifierProvider.notifier).register(
      email: _emailController.text.trim(),
      fullName: _fullNameController.text.trim(),
      schoolName: _schoolNameController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: _gender,
      password: _passwordController.text,
      province: _selectedProvince!,
      city: _selectedCity!,
      district: _selectedDistrict!,
      village: _selectedVillage!,
      address: _addressController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      } else if (next.status == AuthStatus.authenticated) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schoolNameController,
                decoration: const InputDecoration(labelText: 'Nama Sekolah', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Nomor WhatsApp', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? 'L'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (v) => v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 24),
              const Text('Alamat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (_isLoadingRegions)
                const Center(child: CircularProgressIndicator())
              else ...[
                DropdownButtonFormField<String>(
                  value: _selectedProvince,
                  decoration: const InputDecoration(labelText: 'Provinsi', border: OutlineInputBorder()),
                  items: _provinces.map((p) => DropdownMenuItem<String>(
                    value: p.code,
                    child: Text(p.name),
                  )).toList(),
                  onChanged: (v) {
                    setState(() => _selectedProvince = v);
                    if (v != null) _loadCities(v);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: const InputDecoration(labelText: 'Kota/Kabupaten', border: OutlineInputBorder()),
                  items: _cities.map((c) => DropdownMenuItem<String>(
                    value: c.code,
                    child: Text(c.name),
                  )).toList(),
                  onChanged: _selectedProvince == null ? null : (v) {
                    setState(() => _selectedCity = v);
                    if (v != null) _loadDistricts(v);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDistrict,
                  decoration: const InputDecoration(labelText: 'Kecamatan', border: OutlineInputBorder()),
                  items: _districts.map((d) => DropdownMenuItem<String>(
                    value: d.code,
                    child: Text(d.name),
                  )).toList(),
                  onChanged: _selectedCity == null ? null : (v) {
                    setState(() => _selectedDistrict = v);
                    if (v != null) _loadVillages(v);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedVillage,
                  decoration: const InputDecoration(labelText: 'Kelurahan/Desa', border: OutlineInputBorder()),
                  items: _villages.map((v) => DropdownMenuItem<String>(
                    value: v.code,
                    child: Text(v.name),
                  )).toList(),
                  onChanged: _selectedDistrict == null ? null : (v) => setState(() => _selectedVillage = v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Alamat Lengkap', border: OutlineInputBorder()),
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading ? null : _handleRegister,
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Daftar'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}