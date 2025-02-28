import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class ImageStep extends StatelessWidget {
  final File? selectedImage;
  final Function(File) onImagePick;
  final VoidCallback onImageRemove;

  const ImageStep({
    super.key,
    required this.selectedImage,
    required this.onImagePick,
    required this.onImageRemove,
  });

  Future<File> compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 85, // جودة الصورة (0-100)
      minWidth: 1024, // الحد الأدنى للعرض
      minHeight: 1024, // الحد الأدنى للارتفاع
    );

    return File(result!.path);
  }

  Future<void> handleImagePick() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File originalFile = File(pickedFile.path);
      final File compressedFile = await compressImage(originalFile);
      onImagePick(compressedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleImagePick,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: selectedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: onImageRemove,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'انقر لاختيار صورة',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} 