import 'package:flutter/material.dart';
import '../models/pengajuan.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  String _getStatusText(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.pending:
        return 'Menunggu Verifikasi';
      case StatusPengajuan.inProgress:
        return 'Sedang Diproses';
      case StatusPengajuan.completed:
        return 'Selesai, Silahkan ambil di Kantor Kecamatan';
      case StatusPengajuan.rejected:
        return 'Ditolak';
      default:
        return 'Status Tidak Diketahui';
    }
  }

  String _getLayananText(LayananType layanan) {
    switch (layanan) {
      case LayananType.pembuatanKTP:
        return 'Pembuatan KTP';
      case LayananType.pembuatanKK:
        return 'Pembuatan KK';
      case LayananType.pembuatanAktaKelahiran:
        return 'Pembuatan Akta Kelahiran';
      case LayananType.pembuatanAktaKematian:
        return 'Pembuatan Akta Kematian';
      case LayananType.pembuatanSuratPindah:
        return 'Pembuatan Surat Pindah';
      default:
        return 'Layanan Tidak Diketahui';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Current userId: $userId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pengajuan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<PengajuanModel>>(
        stream: FirebaseService().getPengajuanByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error in StreamBuilder: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final pengajuanList = snapshot.data ?? [];
          print('Pengajuan list length: ${pengajuanList.length}');

          if (pengajuanList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Belum ada pengajuan'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengajuanList.length,
            itemBuilder: (context, index) {
              final pengajuan = pengajuanList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    _getLayananText(pengajuan.layanan),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${_getStatusText(pengajuan.status)}',
                        style: TextStyle(
                          color: _getStatusColor(pengajuan.status),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Tanggal: ${pengajuan.tanggalPengajuan}'),
                      const SizedBox(height: 4),
                      Text('No. Ref: ${pengajuan.nomorReferensi}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      _showDetailDialog(context, pengajuan);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
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
    );
  }

  Color _getStatusColor(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.pending:
        return Colors.orange;
      case StatusPengajuan.inProgress:
        return Colors.blue;
      case StatusPengajuan.completed:
        return Colors.green;
      case StatusPengajuan.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDetailDialog(BuildContext context, PengajuanModel pengajuan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Detail Pengajuan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Layanan: ${_getLayananText(pengajuan.layanan)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${_getStatusText(pengajuan.status)}',
              style: TextStyle(
                fontSize: 16,
                color: _getStatusColor(pengajuan.status),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tanggal Pengajuan: ${pengajuan.tanggalPengajuan}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Nomor Referensi: ${pengajuan.nomorReferensi}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
