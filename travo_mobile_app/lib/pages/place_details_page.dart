import 'dart:ui';

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/nearby_places_data.dart';
import '../data/explore_categories_data.dart';
import '../core/services/trip_data_service.dart';
import 'explore_category_page.dart';
import 'place_group_chat_page.dart';
import 'place_reviews_page.dart';

class TravoPlaceDetailsPage extends StatefulWidget {
  final String title;
  final String location;
  final String imageUrl;
  final double rating;
  final String? description;

  const TravoPlaceDetailsPage({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.rating,
    this.description,
  });

  @override
  State<TravoPlaceDetailsPage> createState() => _TravoPlaceDetailsPageState();
}

class _TravoPlaceDetailsPageState extends State<TravoPlaceDetailsPage> {
  bool _isDescriptionExpanded = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutSectionKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _expandDescription() {
    setState(() {
      _isDescriptionExpanded = true;
    });
    // Scroll to about section
    Future.delayed(const Duration(milliseconds: 100), () {
      final context = _aboutSectionKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _hero(context),
              Expanded(child: _content(context)),
            ],
          ),
          _bottomCTA(context),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    final fullDescription = widget.description ??
        '''Discover the beauty and charm of this amazing destination. Experience unforgettable moments and create lasting memories in this wonderful place.

This destination offers a perfect blend of natural beauty, rich culture, and modern amenities. Whether you're seeking adventure, relaxation, or cultural immersion, you'll find it all here.

Key Highlights:
• Stunning natural landscapes and scenic views
• Rich cultural heritage and local traditions
• World-class accommodations and dining options
• Variety of activities for all age groups
• Excellent transportation and connectivity
• Safe and welcoming environment for travelers

The best time to visit is during the dry season when the weather is pleasant and ideal for outdoor activities. Local guides are available to help you explore hidden gems and experience authentic local culture.

Don't miss the opportunity to try local cuisine, visit traditional markets, and interact with friendly locals who are always eager to share their stories and traditions.''';

    if (_isDescriptionExpanded) {
      return Text(
        fullDescription,
        style: const TextStyle(
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      );
    } else {
      final shortDescription = widget.description ??
          'Discover the beauty and charm of this amazing destination. Experience unforgettable moments and create lasting memories in this wonderful place. ';
      return Text(
        shortDescription,
        style: const TextStyle(
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  // ---------------- HERO ----------------
  Widget _hero(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.32,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _glassIcon(
                      Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        _glassIcon(Icons.share, onTap: () {}),
                        const SizedBox(width: 12),
                        _glassIcon(Icons.favorite_border, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.location,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        widget.rating.toString(),
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassIcon(IconData icon, {VoidCallback? onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.white24,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, color: AppColors.textOnPrimary),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- CONTENT ----------------
  Widget _content(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            key: _aboutSectionKey,
            child: const Text(
              'About Destination',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          _buildDescriptionText(),
          if (!_isDescriptionExpanded)
            GestureDetector(
              onTap: _expandDescription,
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Read more',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Explore',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              final exploreItems = [
                _ExploreItem(
                  icon: Icons.info,
                  label: 'Overview',
                  color: Colors.blue,
                  onTap: _expandDescription,
                ),
                _ExploreItem(
                  icon: Icons.bed,
                  label: 'Stays',
                  color: Colors.orange,
                  onTap: () {
                    final categoryData = exploreCategoriesMap['Stays'];
                    if (categoryData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreCategoryPage(categoryData: categoryData),
                        ),
                      );
                    }
                  },
                ),
                _ExploreItem(
                  icon: Icons.restaurant,
                  label: 'Food',
                  color: Colors.green,
                  onTap: () {
                    final categoryData = exploreCategoriesMap['Food'];
                    if (categoryData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreCategoryPage(categoryData: categoryData),
                        ),
                      );
                    }
                  },
                ),
                _ExploreItem(
                  icon: Icons.kayaking,
                  label: 'Activities',
                  color: Colors.purple,
                  onTap: () {
                    final categoryData = exploreCategoriesMap['Activities'];
                    if (categoryData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreCategoryPage(categoryData: categoryData),
                        ),
                      );
                    }
                  },
                ),
                const _ExploreItem(
                  icon: Icons.medical_services,
                  label: 'Essentials',
                  color: Colors.red,
                ),
                _ExploreItem(
                  icon: Icons.groups,
                  label: 'Groups',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceGroupChatPage(
                          placeName: widget.title,
                          placeImage: widget.imageUrl,
                        ),
                      ),
                    );
                  },
                ),
                _ExploreItem(
                  icon: Icons.reviews,
                  label: 'Reviews',
                  color: Colors.amber,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceReviewsPage(
                          placeName: widget.title,
                          placeRating: widget.rating,
                        ),
                      ),
                    );
                  },
                ),
                _ExploreItem(
                  icon: Icons.commute,
                  label: 'Transport',
                  color: Colors.indigo,
                  onTap: () {
                    final categoryData = exploreCategoriesMap['Transport'];
                    if (categoryData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreCategoryPage(categoryData: categoryData),
                        ),
                      );
                    }
                  },
                ),
              ];
              final crossAxisCount = constraints.maxWidth < 360 ? 3 : 4;
              final itemAspectRatio = constraints.maxWidth < 360 ? 0.9 : 1.0;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  childAspectRatio: itemAspectRatio,
                ),
                itemCount: exploreItems.length,
                itemBuilder: (context, index) => exploreItems[index],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Nearby Places',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: nearbyPlacesMap[widget.title]?.length ?? defaultNearbyPlaces.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final places = nearbyPlacesMap[widget.title] ?? defaultNearbyPlaces;
                final place = places[index];
                return _NearbyPlaceCard(
                  imageUrl: place.imageUrl,
                  title: place.title,
                  location: place.location,
                  rating: place.rating,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- BOTTOM CTA ----------------
  Widget _bottomCTA(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.85),
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            // Add to itinerary functionality
                            final tripService = TripDataService();
                            
                            if (!tripService.hasCurrentTrip) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a trip first in the Plans tab'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            
                            // Create new trip item from place details
                            final newDestination = tripService.createTripItemFromPlace(
                              title: widget.title,
                              location: widget.location,
                              imageUrl: widget.imageUrl,
                              rating: widget.rating,
                            );
                            
                            // Add to current trip
                            tripService.addDestination(newDestination);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.title} added to ${tripService.currentTripName}'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'VIEW',
                                  textColor: AppColors.accent,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/adventure');
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_location, size: 20),
                          label: const Text(
                            'Add to Itinerary',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/ai-chat');
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 20),
                          label: const Text(
                            'Chat',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ExploreItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final double rating;

  const _NearbyPlaceCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravoPlaceDetailsPage(
              title: title,
              location: location,
              imageUrl: imageUrl,
              rating: rating,
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
