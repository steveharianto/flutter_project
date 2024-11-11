import 'package:mysql1/mysql1.dart';
import '../models/pengajuan.dart';
import 'database_service.dart';

class PengajuanService {
  Future<void> createPengajuanKK(
    int userId,
    String nama,
    String alamat,
    String ktpUrl,
    String suratNikahUrl,
    String formulirF1Url,
  ) async {
    final conn = await DatabaseService.getConnection();
    try {
      await conn.transaction((txn) async {
        // Generate nomor referensi
        var result = await txn.query('SELECT COUNT(*) as count FROM pengajuan');
        int number = (result.first['count'] as num).toInt() + 1;
        String nomorReferensi = 'REF${number.toString().padLeft(6, '0')}';

        // Insert into pengajuan table
        var pengajuanResult = await txn.query(
          'INSERT INTO pengajuan (id_user, layanan, status, tanggal_pengajuan, nomor_referensi) VALUES (?, ?, ?, ?, ?)',
          [
            userId,
            'pembuatanKK',
            'pending',
            DateTime.now().toString().split(' ')[0],
            nomorReferensi,
          ],
        );

        int pengajuanId = pengajuanResult.insertId!;

        // Insert into pengajuan_kk table
        await txn.query(
          'INSERT INTO pengajuan_kk (id_pengajuan, nama_lengkap, alamat, img_ktp, img_surat_nikah, img_formulir_f1_01) VALUES (?, ?, ?, ?, ?, ?)',
          [pengajuanId, nama, alamat, ktpUrl, suratNikahUrl, formulirF1Url],
        );
      });
    } catch (e) {
      throw Exception('Failed to create pengajuan KK: $e');
    } finally {
      await conn.close();
    }
  }

  // Add method to get pengajuan by user
  Future<List<Map<String, dynamic>>> getPengajuanByUser(int userId) async {
    final conn = await DatabaseService.getConnection();
    try {
      var results = await conn.query('''
        SELECT p.*, pk.*
        FROM pengajuan p
        LEFT JOIN pengajuan_kk pk ON p.id_pengajuan = pk.id_pengajuan
        WHERE p.id_user = ?
        ORDER BY p.tanggal_pengajuan DESC
      ''', [userId]);

      return results.map((row) => row.fields).toList();
    } finally {
      await conn.close();
    }
  }

  // Add method to update pengajuan status
  Future<void> updatePengajuanStatus(
    int pengajuanId,
    String status,
  ) async {
    final conn = await DatabaseService.getConnection();
    try {
      await conn.query(
        'UPDATE pengajuan SET status = ? WHERE id_pengajuan = ?',
        [status, pengajuanId],
      );
    } finally {
      await conn.close();
    }
  }

  Future<void> createPengajuanAktaKelahiran(
    int userId,
    String nama,
    String alamat,
    String formulirF201Url,
    String ktpAyahUrl,
    String ktpIbuUrl,
    String suratNikahUrl,
    String suratKetLahirUrl,
    String kkUrl,
    String ktpSaksiUrl,
  ) async {
    final conn = await DatabaseService.getConnection();
    try {
      await conn.transaction((txn) async {
        // Generate nomor referensi
        var result = await txn.query('SELECT COUNT(*) as count FROM pengajuan');
        int number = (result.first['count'] as num).toInt() + 1;
        String nomorReferensi = 'REF${number.toString().padLeft(6, '0')}';

        // Insert into pengajuan table
        var pengajuanResult = await txn.query(
          'INSERT INTO pengajuan (id_user, layanan, status, tanggal_pengajuan, nomor_referensi) VALUES (?, ?, ?, ?, ?)',
          [
            userId,
            'pembuatanAktaKelahiran',
            'pending',
            DateTime.now().toString().split(' ')[0],
            nomorReferensi,
          ],
        );

        int pengajuanId = pengajuanResult.insertId!;

        // Insert into pengajuan_akta_kelahiran table
        await txn.query('''
          INSERT INTO pengajuan_akta_kelahiran (
            id_pengajuan, 
            nama_lengkap, 
            alamat, 
            img_formulir_f2_01,
            img_ktp_ayah,
            img_ktp_ibu,
            img_surat_nikah,
            img_surat_keterangan_lahir,
            img_kk,
            img_ktp_saksi
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          pengajuanId,
          nama,
          alamat,
          formulirF201Url,
          ktpAyahUrl,
          ktpIbuUrl,
          suratNikahUrl,
          suratKetLahirUrl,
          kkUrl,
          ktpSaksiUrl,
        ]);
      });
    } catch (e) {
      throw Exception('Failed to create pengajuan Akta Kelahiran: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> createPengajuanAktaKematian(
    int userId,
    String nama,
    String alamat,
    String formulirF228Url,
    String suratKetKematianUrl,
    String suratNikahUrl,
    String kkUrl,
    String ktpAlmUrl,
  ) async {
    final conn = await DatabaseService.getConnection();
    try {
      await conn.transaction((txn) async {
        // Generate nomor referensi
        var result = await txn.query('SELECT COUNT(*) as count FROM pengajuan');
        int number = (result.first['count'] as num).toInt() + 1;
        String nomorReferensi = 'REF${number.toString().padLeft(6, '0')}';

        // Insert into pengajuan table
        var pengajuanResult = await txn.query(
          'INSERT INTO pengajuan (id_user, layanan, status, tanggal_pengajuan, nomor_referensi) VALUES (?, ?, ?, ?, ?)',
          [
            userId,
            'pembuatanAktaKematian',
            'pending',
            DateTime.now().toString().split(' ')[0],
            nomorReferensi,
          ],
        );

        int pengajuanId = pengajuanResult.insertId!;

        // Insert into pengajuan_akta_kematian table
        await txn.query('''
          INSERT INTO pengajuan_akta_kematian (
            id_pengajuan,
            nama_lengkap,
            alamat,
            img_formulir_f2_28,
            img_surat_keterangan_kematian,
            img_surat_nikah,
            img_kk,
            img_ktp_alm
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          pengajuanId,
          nama,
          alamat,
          formulirF228Url,
          suratKetKematianUrl,
          suratNikahUrl,
          kkUrl,
          ktpAlmUrl,
        ]);
      });
    } catch (e) {
      throw Exception('Failed to create pengajuan Akta Kematian: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> createPengajuanKTP(
    int userId,
    String nik,
    String nama,
    DateTime tanggalLahir,
    String jenisKelamin,
    String alamat,
    String tempatLahir,
    String kkUrl,
  ) async {
    final conn = await DatabaseService.getConnection();
    try {
      await conn.transaction((txn) async {
        // Generate nomor referensi
        var result = await txn.query('SELECT COUNT(*) as count FROM pengajuan');
        int number = (result.first['count'] as num).toInt() + 1;
        String nomorReferensi = 'REF${number.toString().padLeft(6, '0')}';

        // Insert into pengajuan table
        var pengajuanResult = await txn.query(
          'INSERT INTO pengajuan (id_user, layanan, status, tanggal_pengajuan, nomor_referensi) VALUES (?, ?, ?, ?, ?)',
          [
            userId,
            'pembuatanKTP',
            'pending',
            DateTime.now().toString().split(' ')[0],
            nomorReferensi,
          ],
        );

        int pengajuanId = pengajuanResult.insertId!;

        // Insert into pengajuan_ktp table
        await txn.query('''
          INSERT INTO pengajuan_ktp (
            id_pengajuan,
            nik,
            nama_lengkap,
            tanggal_lahir,
            jenis_kelamin,
            alamat,
            tanggal_perekaman,
            img_kk
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          pengajuanId,
          nik,
          nama,
          tanggalLahir.toString().split(' ')[0],
          jenisKelamin,
          alamat,
          DateTime.now().toString().split(' ')[0],
          kkUrl,
        ]);
      });
    } catch (e) {
      throw Exception('Failed to create pengajuan KTP: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> createPengajuanSuratPindah(
    int userId,
    String nama,
    String alamat,
    int usia,
    bool isMarried,
    String kkUrl,
    String ktpUrl,
    String? suratNikahUrl,
    String suratPernyataanPindahUrl,
    String? suratPersetujuanOrtuUrl,
    String? suratPersetujuanPasanganUrl,
  ) async {
    final conn = await DatabaseService.getConnection();
    try {
      await conn.transaction((txn) async {
        // Generate nomor referensi
        var result = await txn.query('SELECT COUNT(*) as count FROM pengajuan');
        int number = (result.first['count'] as num).toInt() + 1;
        String nomorReferensi = 'REF${number.toString().padLeft(6, '0')}';

        // Insert into pengajuan table
        var pengajuanResult = await txn.query(
          'INSERT INTO pengajuan (id_user, layanan, status, tanggal_pengajuan, nomor_referensi) VALUES (?, ?, ?, ?, ?)',
          [
            userId,
            'pembuatanSuratPindah',
            'pending',
            DateTime.now().toString().split(' ')[0],
            nomorReferensi,
          ],
        );

        int pengajuanId = pengajuanResult.insertId!;

        // Insert into pengajuan_surat_pindah table
        await txn.query('''
          INSERT INTO pengajuan_surat_pindah (
            id_pengajuan,
            nama_lengkap,
            alamat,
            usia,
            status_nikah,
            img_kk,
            img_ktp,
            img_surat_nikah,
            img_surat_pernyataan_pindah,
            img_surat_persetujuan_ortu,
            img_surat_persetujuan_pasangan
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          pengajuanId,
          nama,
          alamat,
          usia,
          isMarried ? 'Menikah' : 'Belum Menikah',
          kkUrl,
          ktpUrl,
          suratNikahUrl,
          suratPernyataanPindahUrl,
          suratPersetujuanOrtuUrl,
          suratPersetujuanPasanganUrl,
        ]);
      });
    } catch (e) {
      throw Exception('Failed to create pengajuan Surat Pindah: $e');
    } finally {
      await conn.close();
    }
  }
}
