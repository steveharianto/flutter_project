enum LayananType {
  pembuatanKTP,
  pembuatanKK,
  pembuatanAktaKelahiran,
  pembuatanAktaKematian,
  pembuatanSuratPindah,
}

enum StatusPengajuan {
  pending,
  inProgress,
  completed,
  rejected,
}

class PengajuanModel {
  final int? idPengajuan;
  final int idUser;
  final LayananType layanan;
  final StatusPengajuan status;
  final String tanggalPengajuan;
  final String nomorReferensi;
  final Map<String, dynamic>? data;

  PengajuanModel({
    this.idPengajuan,
    required this.idUser,
    required this.layanan,
    this.status = StatusPengajuan.pending,
    required this.tanggalPengajuan,
    required this.nomorReferensi,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_pengajuan': idPengajuan,
      'id_user': idUser,
      'layanan': layanan.toString().split('.').last,
      'status': status.toString().split('.').last,
      'tanggal_pengajuan': tanggalPengajuan,
      'nomor_referensi': nomorReferensi,
    };
  }

  factory PengajuanModel.fromMap(Map<String, dynamic> map) {
    return PengajuanModel(
      idPengajuan: map['id_pengajuan'],
      idUser: map['id_user'],
      layanan: LayananType.values.firstWhere(
        (e) => e.toString().split('.').last == map['layanan'],
        orElse: () => LayananType.pembuatanKTP,
      ),
      status: StatusPengajuan.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => StatusPengajuan.pending,
      ),
      tanggalPengajuan: map['tanggal_pengajuan'],
      nomorReferensi: map['nomor_referensi'],
      data: map['data'],
    );
  }
}
