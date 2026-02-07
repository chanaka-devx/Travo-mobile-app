import 'dart:ui';

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TravoPlaceDetailsPage extends StatelessWidget {
  const TravoPlaceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _hero(context),
              Expanded(child: _content()),
            ],
          ),
          _bottomCTA(context),
        ],
      ),
    );
  }

  // ---------------- HERO ----------------
  Widget _hero(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.42,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCTkH8r72U4822Oo5KKbhV7JaZqL4ZoJsFzGEH1SthikJlRao9RgnGe6WB6eZS-UmHBUQqXwp5YOVFX-dva4wJ08MHrkSrOeuJmbei7LRHE6nMgzqrFd9_0YSAOoCbAf6Qm7EIBhyjJwvH4EKy9XzKk3ssVua-Ml03ZaFTf6nQ33EhC3Mp_tQoxlizt-mSwpAUwiyDBP3aY-2yXc8vBaOv7Wi7WYgN_aFb-ti_6hTTPQt0k54h_nltGJJ7m8NXRm5w1BqaWvF6fW90',
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      const Text(
                        'Niladri Reservoir',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Tekerghat, Sunamganj',
                            style: TextStyle(color: Colors.white70),
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
                    children: const [
                      Icon(Icons.star, size: 16, color: AppColors.warning),
                      SizedBox(width: 4),
                      Text(
                        '4.7',
                        style: TextStyle(
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
  Widget _content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Destination',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text:
                      'Known as the Kashmir of Bengal, Niladri Lake offers breathtaking views of limestone hills and crystal clear blue water. A perfect serenity escape for nature lovers. ',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.6),
                ),
                const TextSpan(
                  text: 'Read more',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Explore',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final exploreItems = [
                const _ExploreItem(
                  icon: Icons.info,
                  label: 'Overview',
                  color: Colors.blue,
                ),
                const _ExploreItem(
                  icon: Icons.bed,
                  label: 'Stays',
                  color: Colors.orange,
                ),
                const _ExploreItem(
                  icon: Icons.restaurant,
                  label: 'Food',
                  color: Colors.green,
                ),
                const _ExploreItem(
                  icon: Icons.kayaking,
                  label: 'Activities',
                  color: Colors.purple,
                ),
                const _ExploreItem(
                  icon: Icons.medical_services,
                  label: 'Essentials',
                  color: Colors.red,
                ),
                const _ExploreItem(
                  icon: Icons.groups,
                  label: 'Groups',
                  color: Colors.teal,
                ),
                const _ExploreItem(
                  icon: Icons.reviews,
                  label: 'Reviews',
                  color: Colors.amber,
                ),
                _ExploreItem(
                  icon: Icons.commute,
                  label: 'Transport',
                  color: Colors.indigo,
                  onTap: () => Navigator.pushNamed(context, '/transportation'),
                ),
              ];
              final crossAxisCount = constraints.maxWidth < 360 ? 3 : 4;
              final itemAspectRatio = constraints.maxWidth < 360 ? 0.7 : 0.8;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 12,
                  childAspectRatio: itemAspectRatio,
                ),
                itemCount: exploreItems.length,
                itemBuilder: (context, index) => exploreItems[index],
              );
            },
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.schedule,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'DURATION',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '3 Days, 2 Nights',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'FROM',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '\$450',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
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
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/ai-chat');
                    },
                    icon: const Icon(Icons.add_location),
                    label: const Text('Add location to itinerary'),
                  ),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
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
