import 'package:flutter/material.dart';
import '../models/pengajuan.dart';
import '../pages/form_ktp_page.dart';
import '../pages/form_kk_page.dart';
import '../pages/form_akta_kelahiran_page.dart';
import '../pages/form_akta_kematian_page.dart';
import '../pages/form_surat_pindah_page.dart';
import 'status_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToPengajuan(BuildContext context, LayananType type) {
    switch (type) {
      case LayananType.pembuatanKTP:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormKTPPage()),
        );
        break;
      case LayananType.pembuatanKK:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormKKPage()),
        );
        break;
      case LayananType.pembuatanAktaKelahiran:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const FormAktaKelahiranPage()),
        );
        break;
      case LayananType.pembuatanAktaKematian:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormAktaKematianPage()),
        );
        break;
      case LayananType.pembuatanSuratPindah:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormSuratPindahPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halo Pengguna'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Selamat Datang di Aplikasi Pelayanan Administrasi Kependudukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _ServiceCard(
                  icon: Icons.credit_card,
                  title: 'Pengajuan KTP',
                  onTap: () => _navigateToPengajuan(
                    context,
                    LayananType.pembuatanKTP,
                  ),
                ),
                _ServiceCard(
                  icon: Icons.family_restroom,
                  title: 'Pengajuan KK',
                  onTap: () => _navigateToPengajuan(
                    context,
                    LayananType.pembuatanKK,
                  ),
                ),
                _ServiceCard(
                  icon: Icons.child_care,
                  title: 'Pengajuan Akta Kelahiran',
                  onTap: () => _navigateToPengajuan(
                    context,
                    LayananType.pembuatanAktaKelahiran,
                  ),
                ),
                _ServiceCard(
                  icon: Icons.sentiment_very_dissatisfied,
                  title: 'Pengajuan Akta Kematian',
                  onTap: () => _navigateToPengajuan(
                    context,
                    LayananType.pembuatanAktaKematian,
                  ),
                ),
                _ServiceCard(
                  icon: Icons.moving,
                  title: 'Pengajuan Surat Pindah',
                  onTap: () => _navigateToPengajuan(
                    context,
                    LayananType.pembuatanSuratPindah,
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatusPage()),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Status',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
