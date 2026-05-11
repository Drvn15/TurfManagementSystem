import 'dart:io'; // Make sure you have this import for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import 'add_sports_courts_screen.dart';

class AddPhotosScreen extends StatefulWidget {
  final int turfId;

  const AddPhotosScreen({super.key, required this.turfId});

  @override
  State<AddPhotosScreen> createState() => _AddPhotosScreenState();
}

class _AddPhotosScreenState extends State<AddPhotosScreen> {
  final List<XFile?> _selectedImages = List.filled(4, null);
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _selectedImages[index] = image;
      });
    }
  }

  Future<void> _uploadImagesAndContinue() async {
    // Count how many images are selected
    final selectedCount = _selectedImages.where((img) => img != null).length;

    if (selectedCount == 0) {
      // Allow skip? Or force at least one photo?
      // For now, let's allow continue with warning
      _showSkipDialog();
      return;
    }

    setState(() => _isUploading = true);

    try {
      // TODO: Implement actual image upload endpoint
      // For now, we'll simulate upload and continue

      // You'll need an endpoint like POST /turfs/:id/photos
      // For each image, you'd do:
      // final formData = FormData.fromMap({
      //   'file': await MultipartFile.fromFile(image.path),
      // });
      // await _api.post("/turfs/${widget.turfId}/photos", body: formData, isFormData: true);

      await Future.delayed(const Duration(seconds: 2)); // Simulate upload

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddSportsCourtsScreen(turfId: widget.turfId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${e.toString()}")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Photos Selected"),
        content: Text(
            "You haven't added any photos. You can add them later from settings. Continue anyway?"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Add Photos"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSportsCourtsScreen(turfId: widget.turfId),
                ),
              );
            },
            child: Text("Skip for Now"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.purpleBackground,
      appBar: AppBar(
        title: const Text("Add Photos"),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Row(
              children: [
                _buildStepIndicator(1, true),
                Expanded(child: Divider(color: Colors.grey.shade300)),
                _buildStepIndicator(2, true),
                Expanded(child: Divider(color: Colors.grey.shade300)),
                _buildStepIndicator(3, false),
              ],
            ),

            SizedBox(height: 40),

            Text(
              "Add photos of your turf",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Showcase your facility (up to 4 photos)",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            SizedBox(height: 32),

            // Photo Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _pickImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                      image: _selectedImages[index] != null
                          ? DecorationImage(
                        image: FileImage(File(_selectedImages[index]!.path)),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _selectedImages[index] == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Add Photo",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                        : Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image is already set in decoration
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImages[index] = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _uploadImagesAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purplePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Next →",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppTheme.purplePrimary : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
