import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class UserDetailsSetupPage extends StatelessWidget {
  const UserDetailsSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // ===== PROFILE IMAGE =====
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceLight,
                              border: Border.all(color: AppColors.border),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCBPqJ5iQLHbPojMT_WkiK3A4fztus2_--lUNAQzkicpFi9y0a11MmccLZB9L0TQ9HG9TcEvq3vWZfZ3r_q7zb-zTlMMlYa034NVTJQqmaNTe0jzsqQenYqpIiqb0xowPYRUNPexCCQ4NJVmVYEa8aK4_08SabJsRplh1qEJK3ZebRfZAFhlKNxgFpCgZtiPsjqRWyKIMO2w8LhSojCzud-YaTMopsP4rmP0nG58eifyFWrummMoAd_g1gw9h2cjP5vO5wRdTQat-Y',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                // Image picker logic
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.photo_camera,
                                  color: AppColors.textOnPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ===== TITLE & SUBTITLE =====
                      const Text(
                        "Let's get to know you",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add a photo and details so Travo can personalize your trips.",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // ===== FORM =====
                      Column(
                        children: const [
                          // Username
                          _InputField(
                            label: "Username",
                            hint: "e.g. wanderlust_jane",
                            icon: Icons.alternate_email,
                          ),

                          SizedBox(height: 16),

                          // Full Name
                          _InputField(
                            label: "Full Name",
                            hint: "Enter your name",
                          ),

                          SizedBox(height: 16),

                          // Travel Style
                          _InputField(
                            label: "Travel Style",
                            hint:
                                "Tell us about your travel style... Adventure, luxury, or hidden gems? ✨",
                            maxLines: 5,
                            icon: Icons.explore,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ===== SAVE BUTTON =====
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Save Profile",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== INPUT FIELD WIDGET =====
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.hint,
    this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            TextField(
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: AppColors.textDisabled),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            if (icon != null)
              Positioned(
                right: 12,
                top: maxLines == 1 ? 16 : 16,
                child: Icon(icon, size: 20, color: AppColors.textDisabled),
              ),
          ],
        ),
      ],
    );
  }
}
