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
  final String id;
  final LayananType layanan;
  final StatusPengajuan status;
  final String tanggalPengajuan;
  final String nomorReferensi;
  final Map<String, dynamic> data;
  final String userId;

  PengajuanModel({
    required this.id,
    required this.layanan,
    required this.status,
    required this.tanggalPengajuan,
    required this.nomorReferensi,
    required this.data,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'layanan': layanan.toString().split('.').last,
      'status': status.toString().split('.').last,
      'tanggalPengajuan': tanggalPengajuan,
      'nomorReferensi': nomorReferensi,
      'data': data,
      'userId': userId,
    };
  }

  factory PengajuanModel.fromMap(Map<String, dynamic> map) {
    return PengajuanModel(
      id: map['id'] ?? '',
      layanan: LayananType.values.firstWhere(
          (e) => e.toString().split('.').last == map['layanan'],
          orElse: () => LayananType.pembuatanKTP),
      status: StatusPengajuan.values.firstWhere(
          (e) => e.toString().split('.').last == map['status'],
          orElse: () => StatusPengajuan.pending),
      tanggalPengajuan: map['tanggalPengajuan'] ?? '',
      nomorReferensi: map['nomorReferensi'] ?? '',
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      userId: map['userId'] ?? '',
    );
  }
}
