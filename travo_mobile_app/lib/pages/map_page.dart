// import 'dart:async'; // Not needed for now
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Not needed for now
import '../core/constants/app_colors.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showPlaceDetails = true;

  @override
  void initState() {
    super.initState();
  }

  void _centerCamera() {
    // Placeholder for future map interaction
  }

  void _zoomIn() {
    // Placeholder for future map interaction
  }

  void _zoomOut() {
    // Placeholder for future map interaction
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background Image (Placeholder)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              image: DecorationImage(
                image: const NetworkImage(
                  'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/2.3376,48.8606,13,0/400x800?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw',
                ),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // If image fails to load, show a default background
                },
              ),
            ),
          ),
          
          // Map overlay with route path illustration
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 
                       MediaQuery.of(context).size.height),
            painter: _MapPathPainter(),
          ),

          // Top Search Bar and Route Badge
          SafeArea(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Search Field
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for a destination',
                              hintStyle: TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.textDisabled,
                                size: 24,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter Button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () {
                            // Handle filter action
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Route Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B5998),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Route: High traffic on Blvd Malesherbes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map Controls (Right Side)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 160,
            child: Column(
              children: [
                // Zoom In Button
                _MapControlButton(
                  icon: Icons.add,
                  onPressed: _zoomIn,
                ),
                const SizedBox(height: 1),
                // Divider
                Container(
                  width: 50,
                  height: 1,
                  color: AppColors.divider,
                ),
                const SizedBox(height: 1),
                // Zoom Out Button
                _MapControlButton(
                  icon: Icons.remove,
                  onPressed: _zoomOut,
                ),
              ],
            ),
          ),

          // Center Location Button
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 280,
            child: _MapControlButton(
              icon: Icons.my_location,
              onPressed: _centerCamera,
            ),
          ),

          // Bottom Place Details Sheet
          if (_showPlaceDetails)
            Positioned(
              left: 0,
              right: 0,
              bottom: 80, // Leave space for bottom nav
              child: _PlaceDetailsBottomSheet(
                onClose: () {
                  setState(() {
                    _showPlaceDetails = false;
                  });
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNavBar(activeRoute: '/map'),
    );
  }
}

// ===== MAP CONTROL BUTTON WIDGET =====
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimary, size: 24),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// ===== PLACE DETAILS BOTTOM SHEET WIDGET =====
class _PlaceDetailsBottomSheet extends StatelessWidget {
  final VoidCallback onClose;

  const _PlaceDetailsBottomSheet({
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recommended Badge and Rating
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'RECOMMENDED',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFC107),
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Place Name
                          Text(
                            'Louvre Museum',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Address
                          Text(
                            'Musée du Louvre, 75001 Paris, France',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Place Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=300',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Duration and Distance
                Row(
                  children: [
                    // Duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.textDisabled,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'DURATION',
                                style: TextStyle(
                                  color: AppColors.textDisabled,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '12 mins',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Distance
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: AppColors.textDisabled,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'DISTANCE',
                                style: TextStyle(
                                  color: AppColors.textDisabled,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '3.4 miles',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Start Navigation Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle navigation start
                        },
                        icon: const Icon(
                          Icons.navigation,
                          color: AppColors.textOnPrimary,
                          size: 20,
                        ),
                        label: const Text(
                          'Start Navigation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006064),
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Save Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Handle save action
                        },
                        icon: Icon(
                          Icons.bookmark_border,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                        label: Text(
                          'Save',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
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
}

// ===== MAP PATH PAINTER (FOR STATIC MAP) =====
class _MapPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw route path
    final pathPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Example path from bottom-left to center
    path.moveTo(size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * 0.55,
      size.width * 0.5, size.height * 0.45,
    );

    // Draw dotted line effect
    _drawDottedPath(canvas, path, pathPaint);

    // Draw markers
    _drawMarker(canvas, Offset(size.width * 0.3, size.height * 0.7), 
                AppColors.accent, true); // Start (green)
    _drawMarker(canvas, Offset(size.width * 0.5, size.height * 0.45), 
                const Color(0xFF1976D2), false); // End (blue)
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final metric = path.computeMetrics().first;
    const dashWidth = 10.0;
    const dashSpace = 8.0;
    double distance = 0.0;

    while (distance < metric.length) {
      final start = metric.getTangentForOffset(distance)!.position;
      distance += dashWidth;
      final end = metric.getTangentForOffset(distance)!.position;
      canvas.drawLine(start, end, paint);
      distance += dashSpace;
    }
  }

  void _drawMarker(Canvas canvas, Offset position, Color color, bool isStart) {
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(position + const Offset(0, 2), 12, shadowPaint);

    // Marker circle
    final markerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 10, markerPaint);

    // Inner white circle
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 4, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
