import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class ImagePickerWidget extends StatefulWidget {
  final ValueChanged<String?> onImagePicked;

  /// Path of the product's current image, if any. Only used by Edit
  /// Product — Add Product leaves this null and starts from the empty
  /// "select an image" state exactly as before. When set, the picker
  /// opens already showing the existing image instead of an empty form
  /// field, per "Image: Optional. Keep existing image if user does not
  /// change it."
  final String? initialImageUrl;

  const ImagePickerWidget({
    super.key,
    required this.onImagePicked,
    this.initialImageUrl,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialImageUrl;
    if (initial != null && initial.isNotEmpty) {
      _imageFile = File(initial);
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null) {
      // User cancelled the picker — keep whatever image (existing or
      // none) was already set instead of clearing it.
      return;
    }

    final sourcePath = result.files.single.path;

    if (sourcePath == null) {
      return;
    }

    final sourceFile = File(sourcePath);

    // Create data/images directory
    final exeDir =
        File(Platform.resolvedExecutable).parent.path;

    final imagesDir = Directory(
      p.join(
        exeDir,
        'data',
        'images',
      ),
    );

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // Generate unique name
    final extension = p.extension(sourcePath);

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}$extension';

    final destinationPath = p.join(
      imagesDir.path,
      fileName,
    );

    // Copy image
    final copiedFile = await sourceFile.copy(
      destinationPath,
    );

    setState(() {
      _imageFile = copiedFile;
    });

    widget.onImagePicked(destinationPath);

    debugPrint('Image saved to: $destinationPath');
    debugPrint('imagesDir saved to: $imagesDir');
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });

    widget.onImagePicked(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageFile == null)
          InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text('Select Product Image'),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              ClipRRect(clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.edit),
                    label: const Text('Change'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _removeImage,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
