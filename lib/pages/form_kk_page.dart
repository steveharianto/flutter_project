import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';
import '../models/pengajuan.dart';
import '../services/pengajuan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormKKPage extends StatefulWidget {
  const FormKKPage({super.key});

  @override
  State<FormKKPage> createState() => _FormKKPageState();
}

class _FormKKPageState extends State<FormKKPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pengajuanService = PengajuanService();
  String? _ktpUrl;
  String? _suratNikahUrl;
  String? _formulirF1Url;
  bool _isLoading = false;

  Future<void> _pickImage(String type) async {
    if (kIsWeb) {
      final media = await ImagePickerWeb.getImageInfo;
      if (media != null) {
        final imageData = media.base64;
        if (imageData != null) {
          setState(() {
            switch (type) {
              case 'ktp':
                _ktpUrl = imageData;
                break;
              case 'suratNikah':
                _suratNikahUrl = imageData;
                break;
              case 'formulirF1':
                _formulirF1Url = imageData;
                break;
            }
          });
        }
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_ktpUrl == null || _suratNikahUrl == null || _formulirF1Url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua dokumen harus diunggah')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Get user ID from shared preferences
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');

        if (userId == null) {
          throw Exception('User not logged in');
        }

        await _pengajuanService.createPengajuanKK(
          userId,
          _nameController.text,
          _addressController.text,
          _ktpUrl!,
          _suratNikahUrl!,
          _formulirF1Url!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengajuan KK berhasil disubmit')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pengajuan KK'),
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
              const Text('Silahkan Unggah KTP',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('ktp', _ktpUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah Surat Nikah',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('suratNikah', _suratNikahUrl),
              const SizedBox(height: 16),
              const Text('Silahkan Unggah Formulir F1 01',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              _buildImagePicker('formulirF1', _formulirF1Url),
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
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
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
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
