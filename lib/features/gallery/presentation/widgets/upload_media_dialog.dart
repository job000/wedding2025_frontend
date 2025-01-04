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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
        // Auto-fill title from filename
        if (_titleController.text.isEmpty) {
          _titleController.text = _selectedImage!.name.split('.').first;
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

    setState(() => _isUploading = true);

    try {
      final provider = context.read<GalleryProvider>();
      final file = kIsWeb ? _webImage : await _selectedImage!.readAsBytes();
      
      if (file == null) return;

      await provider.uploadMedia(
        file: file,
        filename: _selectedImage!.name,
        title: _titleController.text,
        description: _descriptionController.text,
        mediaType: 'image',
        visibility: 'public',
        tags: ['bryllup'],
      );

      if (mounted) {
        Navigator.pop(context, true);
        _showSuccessSnackBar('Bildet ble lastet opp!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Kunne ikke laste opp bilde: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.error.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.success.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CustomColors.primary.withOpacity(0.2)),
        color: CustomColors.primary.withOpacity(0.05),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: CustomColors.primary.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: CustomColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedImage!.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: CustomColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Valgt bilde',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.edit),
                  tooltip: 'Endre bilde',
                  color: CustomColors.primary,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              width: double.infinity,
              child: kIsWeb
                  ? _webImage != null
                      ? Image.memory(_webImage!, fit: BoxFit.contain)
                      : const SizedBox.shrink()
                  : FutureBuilder<Uint8List>(
                      future: _selectedImage!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(snapshot.data!, fit: BoxFit.contain);
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: CustomColors.background,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CustomColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.cloud_upload, 
                        color: CustomColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Last opp bilde',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: CustomColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: CustomColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_selectedImage == null)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CustomColors.primary.withOpacity(0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 48,
                            color: CustomColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Klikk for å velge bilde',
                            style: TextStyle(
                              color: CustomColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  _buildImagePreview(),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Tittel',
                  prefixIcon: Icons.title,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vennligst skriv inn en tittel';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Beskrivelse (valgfritt)',
                  prefixIcon: Icons.description,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isUploading ? null : () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: CustomColors.textSecondary,
                      ),
                      child: const Text('Avbryt'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isUploading || _selectedImage == null
                          ? null
                          : _uploadImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Last opp'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}