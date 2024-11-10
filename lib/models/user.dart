class UserModel {
  final String email;
  final String password;
  final String nama;
  final String alamat;
  final String nomorTelepon;

  UserModel({
    required this.email,
    required this.password,
    required this.nama,
    required this.alamat,
    required this.nomorTelepon,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'nama': nama,
      'alamat': alamat,
      'nomorTelepon': nomorTelepon,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      nama: map['nama'] ?? '',
      alamat: map['alamat'] ?? '',
      nomorTelepon: map['nomorTelepon'] ?? '',
    );
  }
}
