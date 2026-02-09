import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';

class MyStoriesPage extends StatelessWidget {
  const MyStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Stories",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _StoryCard(
              imageUrl:
                  "https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?fit=crop&w=800&h=500",
              title: "Paris Spring Getaway",
              startDate: "April 12",
              endDate: "April 19, 2023",
            ),
            SizedBox(height: 16),
            _StoryCard(
              imageUrl:
                  "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?fit=crop&w=800&h=500",
              title: "Tokyo Adventure",
              startDate: "Nov 05",
              endDate: "Nov 15, 2022",
            ),
            SizedBox(height: 16),
            _StoryCard(
              imageUrl:
                  "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?fit=crop&w=800&h=500",
              title: "New York City",
              startDate: "Dec 20",
              endDate: "Dec 28, 2022",
            ),
            SizedBox(height: 16),
            _StoryCard(
              imageUrl:
                  "https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?fit=crop&w=800&h=500",
              title: "Santorini Summer",
              startDate: "Aug 01",
              endDate: "Aug 10, 2022",
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(activeRoute: '/story'),
    );
  }
}

// ===== STORY CARD WIDGET =====
class _StoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String startDate;
  final String endDate;

  const _StoryCard({
    required this.imageUrl,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/story-details', arguments: title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$startDate - $endDate",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
