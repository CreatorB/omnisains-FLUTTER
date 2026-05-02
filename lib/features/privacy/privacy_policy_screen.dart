import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kebijakan Privasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Omnisains',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Terakhir diperbarui: April 2026',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            const _PolicySection(
              title: '1. Pengumpulan Data',
              content: 'Kami mengumpulkan informasi yang Anda berikan saat mendaftar, termasuk nama, email, nomor telepon, dan informasi sekolah. Data ini digunakan solely untuk keperluan kompetisi dan komunikasi terkait event.',
            ),
            const _PolicySection(
              title: '2. Penggunaan Data',
              content: 'Data yang dikumpulkan digunakan untuk: (a) memproses pendaftaran kompetisi, (b) mengkomunikasikan informasi event, (c) menghasilkan sertifikat peserta, dan (d) evaluasi program.',
            ),
            const _PolicySection(
              title: '3. Perlindungan Data',
              content: 'Kami menggunakan langkah-langkah keamanan yang sesuai untuk melindungi data Anda dari akses tidak sah, perubahan, atau penghancuran.',
            ),
            const _PolicySection(
              title: '4. Berbagi Data',
              content: 'Kami tidak menjual atau membagikan data pribadi Anda kepada pihak ketiga untuk tujuan marketing. Data hanya dibagikan jika diperlukan untuk pemrosesan kompetisi.',
            ),
            const _PolicySection(
              title: '5. Hak Anda',
              content: 'Anda memiliki hak untuk mengakses, mengubah, atau menghapus data pribadi Anda. Hubungi kami melalui email untuk permintaan terkait data pribadi.',
            ),
            const _PolicySection(
              title: '6. Cookie',
              content: 'Aplikasi ini tidak menggunakan cookie atau teknologi pelacakan lainnya.',
            ),
            const _PolicySection(
              title: '7. Perubahan Kebijakan',
              content: 'Kebijakan privasi ini dapat diperbarui sewaktu-waktu. Perubahan akan diinformasikan melalui aplikasi.',
            ),
            const _PolicySection(
              title: '8. Kontak',
              content: 'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami di: privacy@omnisains.id',
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                '© 2026 Omnisains. Hak cipta dilindungi.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}