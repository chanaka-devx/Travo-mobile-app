import 'dart:ui';

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TravoRecommendationsPage extends StatelessWidget {
  const TravoRecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _backgroundLayer(context),
          _blurLayer(),
          _bottomSheet(context),
        ],
      ),
    );
  }

  // ---------------- BACKGROUND ----------------
  Widget _backgroundLayer(BuildContext context) {
    return SafeArea(
      child: Opacity(
        opacity: 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: AppColors.shadow, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCG3UOLWg26o_TIuKGuIvWvhqMqja6VDIIPKFWZ-yprXF4WK_XuR_Jslcjt_k-hTZE179ozJTBFB14kX2BCFO5-r4wuDHRZ5O9zTck61IMIfy_hGjRkqRHoU_6Pu9Law4Rw64KIPmrHQfBjB3CaXHFi5wfChMRVQ7BM852gbWWk9jP2pxy5Oe7ddZftciWOIjBut-7Lha46YJQLjJNQq-pSSpuQX8q1hGA7MZbcDvTu0_gPF1-P2MIEszGpDmEim3jDXVVN-I1ooW0',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Leonardo',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.shadow, blurRadius: 4),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Explore the\n',
                      style: TextStyle(
                        fontSize: 36,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const TextSpan(
                      text: 'Beautiful ',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const TextSpan(
                      text: 'world!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BLUR ----------------
  Widget _blurLayer() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(color: AppColors.textPrimary.withValues(alpha: 0.4)),
    );
  }

  // ---------------- BOTTOM SHEET ----------------
  Widget _bottomSheet(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.88,
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top Picks for You',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Based on your recent interests',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.surfaceLight,
                    child: const Icon(
                      Icons.tune,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 140),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 3 / 5,
                ),
                itemCount: _demoRecommendations.length,
                itemBuilder: (_, index) =>
                    _card(context, _demoRecommendations[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD ----------------
  Widget _card(BuildContext context, RecommendationItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/place-details');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: AppColors.textPrimary.withValues(
                      alpha: 0.25,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.rating,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecommendationItem {
  final String imageUrl;
  final String title;
  final String location;
  final String rating;

  const RecommendationItem({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
  });
}

const List<RecommendationItem> _demoRecommendations = [
  RecommendationItem(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuACWWMzHvuZzWYuq1tXXagREhlC4eFYSN67pYXS1Fh-VIgi6E_iPGL79hIZXhrE7lRYANDqW7dxWoVzHWUWMN8nvJ7aHZu472KTY3xe-ksoaxHVwSeO27EeQTYQLijcQfYBD0R2qEhZ4JTESoYvPdC23iDE6HENi4130TKKzIw5DS9CbqPObBVyAX7j6S083Uji6qqVfwyoatBAz0uEusqmgAu5djpbNoLH3KI5m2kNqFOuF6xw8Ig8nVX-ImTw1qacVTo0MGyqyJY',
    title: 'Mirissa Beach',
    location: 'Galle Road, Mirissa',
    rating: '4.8',
  ),
  RecommendationItem(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD2c69Wp7sacY9G9gy1jwH_POZYVbH6oyyvf8uuFoU3xpGRt660cs9FGG7pYqMnyv-Rw5YDB_s0EG0U4EpzlAoD6ScxS6yZtwWJ37y8h13Bk1qVXl8r7xI7s9C87qpY4giQ7JKdtFucyzdAGQUxj34a0xFZ2CDFQCewdqCzNPMiBaycTtfSiLjwG6RvOcfW6FcMSw9NuGee3wiNJlTD3UqrVEOmlemjLSxOJuia7ZfDkm778EDEr2hh-MCTmYa2HkLCZvH3Fo2JJ8w',
    title: 'Yala Park',
    location: 'Darma Valley',
    rating: '4.5',
  ),
];
