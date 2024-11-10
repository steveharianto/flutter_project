import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../models/pengajuan.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Operations
  Future<UserCredential> registerUser(UserModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': user.email,
        'nama': user.nama,
        'alamat': user.alamat,
        'nomorTelepon': user.nomorTelepon,
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Pengajuan Operations
  Future<String> createPengajuan(PengajuanModel pengajuan) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Generate nomor referensi
      QuerySnapshot ref = await _firestore.collection('pengajuan').get();
      int number = ref.docs.length + 1;
      String nomorReferensi = 'REF' + number.toString().padLeft(6, '0');

      DocumentReference docRef = await _firestore.collection('pengajuan').add({
        ...pengajuan.toMap(),
        'userId': userId,
        'nomorReferensi': nomorReferensi,
        'tanggalPengajuan': DateTime.now().toString().split(' ')[0],
      });

      return docRef.id;
    } catch (e) {
      print('Error creating pengajuan: $e');
      rethrow;
    }
  }

  Stream<List<PengajuanModel>> getPengajuanByUser(String userId) {
    print('Querying for userId: $userId');

    return _firestore
        .collection('pengajuan')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Number of documents: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Document data: $data');
        return PengajuanModel.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }
}
