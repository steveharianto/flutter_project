class UserModel {
  final int? idUser;
  final String email;
  final String password;
  final String nama;
  final String alamat;
  final String nomorTelepon;

  UserModel({
    this.idUser,
    required this.email,
    required this.password,
    required this.nama,
    required this.alamat,
    required this.nomorTelepon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'email': email,
      'password': password,
      'nama': nama,
      'alamat': alamat,
      'nomor_telepon': nomorTelepon,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idUser: map['id_user'],
      email: map['email'],
      password: map['password'],
      nama: map['nama'],
      alamat: map['alamat'],
      nomorTelepon: map['nomor_telepon'],
    );
  }
}
