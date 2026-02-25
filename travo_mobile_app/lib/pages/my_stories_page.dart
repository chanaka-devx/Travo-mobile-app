import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';
import '../data/adventure_data.dart';

class MyStoriesPage extends StatefulWidget {
  const MyStoriesPage({super.key});

  @override
  State<MyStoriesPage> createState() => _MyStoriesPageState();
}

class _MyStoriesPageState extends State<MyStoriesPage> {

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    if (shouldExit == true) {
      SystemNavigator.pop();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final allTrips = getAllTrips();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop(context);
        }
      },
      child: Scaffold(
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
        
      ),
      body: SafeArea(
        child: allTrips.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_album_outlined,
                      size: 64,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No trips yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a trip in Plans to start your story',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: allTrips.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final trip = allTrips[index];
                  return _StoryCard(
                    imageUrl: trip.imageUrl,
                    title: trip.name,
                    dates: trip.dates,
                    duration: trip.duration,
                    trip: trip,
                  );
                },
              ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(activeRoute: '/story'),
      ),
    );
  }
}

// ===== STORY CARD WIDGET =====
class _StoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dates;
  final String duration;
  final SavedTrip trip;

  const _StoryCard({
    required this.imageUrl,
    required this.title,
    required this.dates,
    required this.duration,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/story-details', arguments: trip);
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
                      dates,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: const TextStyle(
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
