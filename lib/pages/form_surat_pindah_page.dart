import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/pengajuan_service.dart';

class FormSuratPindahPage extends StatefulWidget {
  const FormSuratPindahPage({super.key});

  @override
  State<FormSuratPindahPage> createState() => _FormSuratPindahPageState();
}

class _FormSuratPindahPageState extends State<FormSuratPindahPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  String? _kkUrl;
  String? _ktpUrl;
  String? _suratNikahUrl;
  String? _suratPernyataanPindahUrl;
  String? _suratPersetujuanOrtuUrl;
  String? _suratPersetujuanPasanganUrl;
  bool _isUnder17 = false;
  bool _isMarried = false;
  bool _isLoading = false;
  final _pengajuanService = PengajuanService();

  Future<void> _pickImage(String type) async {
    if (kIsWeb) {
      final media = await ImagePickerWeb.getImageInfo;
      if (media != null) {
        final imageData = media.base64;
        if (imageData != null) {
          setState(() {
            switch (type) {
              case 'kk':
                _kkUrl = imageData;
                break;
              case 'ktp':
                _ktpUrl = imageData;
                break;
              case 'suratNikah':
                _suratNikahUrl = imageData;
                break;
              case 'suratPernyataanPindah':
                _suratPernyataanPindahUrl = imageData;
                break;
              case 'suratPersetujuanOrtu':
                _suratPersetujuanOrtuUrl = imageData;
                break;
              case 'suratPersetujuanPasangan':
                _suratPersetujuanPasanganUrl = imageData;
                break;
            }
          });
        }
      }
    }
  }

  void _checkAge(String value) {
    if (value.isNotEmpty) {
      final age = int.tryParse(value);
      if (age != null) {
        setState(() {
          _isUnder17 = age < 17;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_kkUrl == null ||
          _ktpUrl == null ||
          _suratPernyataanPindahUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen wajib harus diunggah')),
        );
        return;
      }

      if (_isMarried &&
          (_suratNikahUrl == null || _suratPersetujuanPasanganUrl == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen pernikahan harus diunggah')),
        );
        return;
      }

      if (_isUnder17 && _suratPersetujuanOrtuUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Surat persetujuan orang tua harus diunggah')),
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

        await _pengajuanService.createPengajuanSuratPindah(
          userId,
          _nameController.text,
          _addressController.text,
          int.parse(_ageController.text),
          _isMarried,
          _kkUrl!,
          _ktpUrl!,
          _suratNikahUrl,
          _suratPernyataanPindahUrl!,
          _suratPersetujuanOrtuUrl,
          _suratPersetujuanPasanganUrl,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pengajuan Surat Pindah berhasil disubmit')),
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
        title: const Text('Form Pengajuan Surat Pindah'),
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
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Usia',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: _checkAge,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Usia tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Sudah Menikah'),
                value: _isMarried,
                onChanged: (bool? value) {
                  setState(() {
                    _isMarried = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah KK',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('kk', _kkUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah KTP',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('ktp', _ktpUrl),
              if (_isMarried) ...[
                const SizedBox(height: 16),
                const Text('Silahkan Unggah Surat Nikah',
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildImagePicker('suratNikah', _suratNikahUrl),
              ],
              const SizedBox(height: 16),
              const Text('Silahkan Unggah Surat Pernyataan Pindah',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker(
                  'suratPernyataanPindah', _suratPernyataanPindahUrl),
              if (_isUnder17) ...[
                const SizedBox(height: 16),
                const Text(
                    'Silahkan Unggah Surat Persetujuan Orang Tua Bermaterai',
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildImagePicker(
                    'suratPersetujuanOrtu', _suratPersetujuanOrtuUrl),
              ],
              if (_isMarried) ...[
                const SizedBox(height: 16),
                const Text(
                    'Silahkan Unggah Surat Persetujuan Suami/Istri Bermaterai',
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildImagePicker(
                    'suratPersetujuanPasangan', _suratPersetujuanPasanganUrl),
              ],
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
    _ageController.dispose();
    super.dispose();
  }
}
