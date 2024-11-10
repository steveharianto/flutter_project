import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';
import '../models/pengajuan.dart';
import '../services/firebase_service.dart';

class FormKKPage extends StatefulWidget {
  const FormKKPage({super.key});

  @override
  State<FormKKPage> createState() => _FormKKPageState();
}

class _FormKKPageState extends State<FormKKPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
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
      setState(() {
        _isLoading = true;
      });

      try {
        final pengajuan = PengajuanModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          layanan: LayananType.pembuatanKK,
          status: StatusPengajuan.pending,
          tanggalPengajuan: DateTime.now().toIso8601String(),
          nomorReferensi: 'REF-${DateTime.now().millisecondsSinceEpoch}',
          userId: 'current-user-id',
          data: {
            'nama': _nameController.text,
            'alamat': _addressController.text,
            'ktpUrl': _ktpUrl,
            'suratNikahUrl': _suratNikahUrl,
            'formulirF1Url': _formulirF1Url,
          },
        );

        await FirebaseService().createPengajuan(pengajuan);

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
        setState(() {
          _isLoading = false;
        });
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
