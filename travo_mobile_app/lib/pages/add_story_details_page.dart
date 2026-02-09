import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AddStoryDetailsPage extends StatefulWidget {
  final String destinationName;

  const AddStoryDetailsPage({
    super.key,
    this.destinationName = "Destination",
  });

  @override
  State<AddStoryDetailsPage> createState() => _AddStoryDetailsPageState();
}

class _AddStoryDetailsPageState extends State<AddStoryDetailsPage> {
  final TextEditingController _storyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MEDIA Section
            const Text(
              "MEDIA",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),

            // Pick from Gallery button
            _buildMediaButton(
              icon: Icons.photo_library,
              label: "Pick from Gallery",
              onTap: () {
                // TODO: Implement image picker from gallery
              },
            ),
            const SizedBox(height: 12),

            // Take Photo button
            _buildMediaButton(
              icon: Icons.camera_alt,
              label: "Take Photo",
              onTap: () {
                // TODO: Implement camera
              },
            ),

            const SizedBox(height: 32),

            // YOUR STORY Section
            const Text(
              "YOUR STORY",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),

            // Story text field
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _storyController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText:
                      "Describe the hidden gems you found, the food you tasted, or the people you met...",
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled.withValues(alpha: 0.7),
                    fontSize: 15,
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Save and go back
                Navigator.pop(context);
              },
              child: const Text(
                "Save to Story",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.textOnPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }
}
