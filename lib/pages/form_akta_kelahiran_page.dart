import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/pengajuan_service.dart';

class FormAktaKelahiranPage extends StatefulWidget {
  const FormAktaKelahiranPage({super.key});

  @override
  State<FormAktaKelahiranPage> createState() => _FormAktaKelahiranPageState();
}

class _FormAktaKelahiranPageState extends State<FormAktaKelahiranPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pengajuanService = PengajuanService();
  String? _formulirF201Url;
  String? _ktpAyahUrl;
  String? _ktpIbuUrl;
  String? _suratNikahUrl;
  String? _suratKetLahirUrl;
  String? _kkUrl;
  String? _ktpSaksiUrl;
  bool _isLoading = false;

  Future<void> _pickImage(String type) async {
    if (kIsWeb) {
      final media = await ImagePickerWeb.getImageInfo;
      if (media != null) {
        final imageData = media.base64;
        if (imageData != null) {
          setState(() {
            switch (type) {
              case 'formulirF201':
                _formulirF201Url = imageData;
                break;
              case 'ktpAyah':
                _ktpAyahUrl = imageData;
                break;
              case 'ktpIbu':
                _ktpIbuUrl = imageData;
                break;
              case 'suratNikah':
                _suratNikahUrl = imageData;
                break;
              case 'suratKetLahir':
                _suratKetLahirUrl = imageData;
                break;
              case 'kk':
                _kkUrl = imageData;
                break;
              case 'ktpSaksi':
                _ktpSaksiUrl = imageData;
                break;
            }
          });
        }
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_formulirF201Url == null ||
          _ktpAyahUrl == null ||
          _ktpIbuUrl == null ||
          _suratNikahUrl == null ||
          _suratKetLahirUrl == null ||
          _kkUrl == null ||
          _ktpSaksiUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua dokumen harus diunggah')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');

        if (userId == null) {
          throw Exception('User not logged in');
        }

        await _pengajuanService.createPengajuanAktaKelahiran(
          userId,
          _nameController.text,
          _addressController.text,
          _formulirF201Url!,
          _ktpAyahUrl!,
          _ktpIbuUrl!,
          _suratNikahUrl!,
          _suratKetLahirUrl!,
          _kkUrl!,
          _ktpSaksiUrl!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pengajuan Akta Kelahiran berhasil disubmit')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildImagePicker(String type, String? imageUrl) {
    return InkWell(
      onTap: () => _pickImage(type),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              imageUrl != null ? 'File telah dipilih' : 'Tap Untuk Mengunggah',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pengajuan Akta Kelahiran'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah Formulir Akta Kelahiran F2.01',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('formulirF201', _formulirF201Url),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah KTP Ayah',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('ktpAyah', _ktpAyahUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah KTP Ibu',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('ktpIbu', _ktpIbuUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah Surat Nikah',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('suratNikah', _suratNikahUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah Surat Keterangan Lahir',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('suratKetLahir', _suratKetLahirUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah KK',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('kk', _kkUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah KTP Saksi',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('ktpSaksi', _ktpSaksiUrl),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Ajukan Permohonan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
