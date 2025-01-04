import 'package:cross_file/cross_file.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/gallery_provider.dart';

class UploadMediaDialog extends StatefulWidget {
  const UploadMediaDialog({super.key});

  @override
  State<UploadMediaDialog> createState() => _UploadMediaDialogState();
}

class _UploadMediaDialogState extends State<UploadMediaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  XFile? _selectedImage;
  Uint8List? _webImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      
      if (image != null) {
        _selectedImage = image;
        if (kIsWeb) {
          _webImage = await _selectedImage!.readAsBytes();
        }
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Kunne ikke velge bilde. Prøv igjen.');
      }
    }
  }

  Future<void> _uploadImage() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedImage == null) return;
    
    setState(() {
      _isUploading = true;
    });

    try {
      final provider = context.read<GalleryProvider>();
      
      if (kIsWeb) {
        if (_webImage == null) return;
        
        await provider.uploadMedia(
          file: _webImage,
          filename: _selectedImage!.name,
          uploadedBy: _nameController.text,
        );
      } else {
        await provider.uploadMedia(
          file: await _selectedImage!.readAsBytes(),
          filename: _selectedImage!.name,
          uploadedBy: _nameController.text,
        );
      }

      if (mounted) {
        Navigator.pop(context,true);
        _showSuccessSnackBar('Bilde lastet opp!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Kunne ikke laste opp bilde: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CustomColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: CustomColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valgt bilde:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      _selectedImage!.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
              maxWidth: double.infinity,
            ),
            child: kIsWeb
                ? _webImage != null
                    ? Image.memory(
                        _webImage!,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox.shrink()
                : FutureBuilder<Uint8List>(
                    future: _selectedImage!.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.contain,
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.9,
          maxHeight: screenSize.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cloud_upload, size: 24, color: CustomColors.primary),
                      const SizedBox(width: 8),
                      const Text('Last opp bilde'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Ditt navn',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vennligst skriv inn navnet ditt';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildImagePreview(),
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.photo_library),
                    label: Text(_selectedImage == null ? 'Velg bilde' : 'Endre bilde'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _isUploading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Avbryt'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _isUploading || _selectedImage == null ? null : _uploadImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.success,
                          foregroundColor: Colors.white,
                        ),
                        icon: _isUploading 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.upload),
                        label: Text(_isUploading ? 'Laster opp...' : 'Last opp'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}