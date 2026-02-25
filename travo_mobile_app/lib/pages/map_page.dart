import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';
import '../data/adventure_data.dart';
import '../core/services/trip_data_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showPlaceDetails = false;
  int _selectedLocationIndex = 0;
  List<TripItem> _tripItems = [];
  String _tripName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments passed from adventure page
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      setState(() {
        _tripItems = arguments['tripItems'] as List<TripItem>? ?? [];
        _selectedLocationIndex = arguments['selectedIndex'] as int? ?? 0;
        _tripName = arguments['tripName'] as String? ?? 'Trip Map';
        _showPlaceDetails = true;
        
        // Also update the service when navigating from destination card
        TripDataService().updateCurrentTrip(
          tripItems: _tripItems,
          tripName: _tripName,
          selectedIndex: _selectedLocationIndex,
        );
      });
    } else {
      // If no arguments provided (navigated from bottom nav), use TripDataService
      final tripService = TripDataService();
      if (tripService.hasCurrentTrip) {
        setState(() {
          _tripItems = tripService.currentTripItems;
          _selectedLocationIndex = tripService.selectedIndex;
          _tripName = tripService.currentTripName;
          _showPlaceDetails = false; // Don't auto-show bottom sheet from nav
        });
      }
    }
  }

  void _onLocationTapped(int index) {
    setState(() {
      _selectedLocationIndex = index;
      _showPlaceDetails = true;
      
      // Update the service's selected index
      TripDataService().updateSelectedIndex(index);
    });
  }

  void _centerCamera() {
    // Dummy: no live map control
  }

  void _zoomIn() {
    // Dummy: no live map control
  }

  void _zoomOut() {
    // Dummy: no live map control
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.45;

    // Calculate map center and bounds if we have trip items
    String mapUrl = 'https://tile.openstreetmap.org/14/8398/5870.png'; // Default Paris view
    
    if (_tripItems.isNotEmpty) {
      // Calculate center point
      double avgLat = _tripItems.map((e) => e.latitude).reduce((a, b) => a + b) / _tripItems.length;
      double avgLng = _tripItems.map((e) => e.longitude).reduce((a, b) => a + b) / _tripItems.length;
      
      // Determine zoom level based on spread
      double latSpread = _tripItems.map((e) => e.latitude).reduce((a, b) => a > b ? a : b) - 
                         _tripItems.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
      double lngSpread = _tripItems.map((e) => e.longitude).reduce((a, b) => a > b ? a : b) - 
                         _tripItems.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
      
      int zoom = latSpread > 5 || lngSpread > 5 ? 5 : (latSpread > 2 || lngSpread > 2 ? 7 : 10);
      
      // Use StaticMap API (free, no token required)
      mapUrl = 'https://staticmap.openstreetmap.de/staticmap.php?center=$avgLat,$avgLng&zoom=$zoom&size=600x1200&maptype=mapnik';
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop(context);
        }
      },
      child: Scaffold(
      body: Stack(
        children: [
          // Static map background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE5E3DF), // Light map-like background
            child: Image.network(
              mapUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.primary,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE5E3DF),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 64,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Map Loading...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Map overlay with route path
          if (_tripItems.length > 1)
            IgnorePointer(
              child: CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: _MapPathPainter(
                  tripItems: _tripItems,
                  selectedIndex: _selectedLocationIndex,
                ),
              ),
            ),

          // Location pins for each destination
          ..._tripItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == _selectedLocationIndex;
            
            // Convert lat/lng to screen position (simplified)
            final screenPos = _latLngToScreenPosition(
              item.latitude,
              item.longitude,
              _tripItems,
              MediaQuery.of(context).size,
            );
            
            return Positioned(
              left: screenPos.dx - 20,
              top: screenPos.dy - 40,
              child: GestureDetector(
                onTap: () => _onLocationTapped(index),
                child: _MapPin(
                  isSelected: isSelected,
                  label: '${index + 1}',
                ),
              ),
            );
          }),

          // Top Search Bar and Route Badge
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
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
                          icon: Icon(Icons.tune, color: AppColors.textPrimary),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

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
                        Text(
                          _tripItems.isNotEmpty 
                              ? 'Route: $_tripName - ${_tripItems.length} destinations'
                              : 'Route: High traffic on Blvd Malesherbes',
                          style: const TextStyle(
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
            top: MediaQuery.of(context).padding.top + 140,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MapControlButton(icon: Icons.add, onPressed: _zoomIn),
                const SizedBox(height: 1),
                Container(width: 50, height: 1, color: AppColors.divider),
                const SizedBox(height: 1),
                _MapControlButton(icon: Icons.remove, onPressed: _zoomOut),
                const SizedBox(height: 12),
                _MapControlButton(
                  icon: Icons.my_location,
                  onPressed: _centerCamera,
                ),
              ],
            ),
          ),

          // Bottom Place Details Sheet (opens on pin tap)
          if (_showPlaceDetails && _tripItems.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 80 + bottomInset - 8,
              child: _PlaceDetailsBottomSheet(
                maxHeight: maxSheetHeight,
                tripItem: _tripItems[_selectedLocationIndex],
                itemNumber: _selectedLocationIndex + 1,
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
      ),
    );
  }

  // Convert latitude/longitude to screen position
  Offset _latLngToScreenPosition(
    double lat,
    double lng,
    List<TripItem> allItems,
    Size screenSize,
  ) {
    if (allItems.isEmpty) return Offset(screenSize.width / 2, screenSize.height / 2);
    
    // Calculate bounds
    double minLat = allItems.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = allItems.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = allItems.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = allItems.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);
    
    // Add padding
    double latPadding = (maxLat - minLat) * 0.2;
    double lngPadding = (maxLng - minLng) * 0.2;
    
    // Normalize to 0-1 range
    double dx = (lng - minLng + lngPadding) / (maxLng - minLng + 2 * lngPadding);
    double dy = 1 - (lat - minLat + latPadding) / (maxLat - minLat + 2 * latPadding);
    
    // Convert to screen coordinates with margins
    double marginTop = 200;
    double marginBottom = 500;
    double marginSide = 40;
    
    double x = marginSide + dx * (screenSize.width - 2 * marginSide);
    double y = marginTop + dy * (screenSize.height - marginTop - marginBottom);
    
    return Offset(x, y);
  }
}

class _MapPin extends StatelessWidget {
  final bool isSelected;
  final String label;

  const _MapPin({
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSelected ? 44 : 36,
          height: isSelected ? 44 : 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.error,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? AppColors.primary : AppColors.error)
                    .withValues(alpha: 0.4),
                blurRadius: isSelected ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSelected ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

// ===== MAP CONTROL BUTTON WIDGET =====
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapControlButton({required this.icon, required this.onPressed});

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
  final double maxHeight;
  final TripItem tripItem;
  final int itemNumber;

  const _PlaceDetailsBottomSheet({
    required this.onClose,
    required this.maxHeight,
    required this.tripItem,
    required this.itemNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
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
        child: SingleChildScrollView(
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
                        // Destination Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Stop $itemNumber',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      tripItem.tag.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tripItem.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      tripItem.location,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    tripItem.icon,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    tripItem.stay,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tripItem.stayInfo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Destination Image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(tripItem.mapImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Duration and Budget
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
                                    Icons.nights_stay,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Duration',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${tripItem.nights} ${tripItem.nights == 1 ? 'Night' : 'Nights'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Budget
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Budget',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${tripItem.budget.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
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
                        // View Details Button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Close Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onClose,
                            icon: Icon(
                              Icons.close,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            label: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: AppColors.divider),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
  }
}

// ===== MAP PATH PAINTER (FOR DYNAMIC TRIP ROUTES) =====
class _MapPathPainter extends CustomPainter {
  final List<TripItem> tripItems;
  final int selectedIndex;

  _MapPathPainter({
    required this.tripItems,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (tripItems.length < 2) return;

    // Path paint
    final pathPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Calculate screen positions for all items
    List<Offset> positions = tripItems.map((item) {
      return _latLngToScreenPosition(item.latitude, item.longitude, tripItems, size);
    }).toList();

    // Draw paths between consecutive destinations
    for (int i = 0; i < positions.length - 1; i++) {
      final path = Path();
      path.moveTo(positions[i].dx, positions[i].dy);
      
      // Add a slight curve for visual appeal
      final midX = (positions[i].dx + positions[i + 1].dx) / 2;
      final midY = (positions[i].dy + positions[i + 1].dy) / 2;
      final offsetY = (positions[i + 1].dx - positions[i].dx) * 0.1;
      
      path.quadraticBezierTo(
        midX,
        midY - offsetY,
        positions[i + 1].dx,
        positions[i + 1].dy,
      );

      _drawDottedPath(canvas, path, pathPaint);
    }
  }

  Offset _latLngToScreenPosition(
    double lat,
    double lng,
    List<TripItem> allItems,
    Size screenSize,
  ) {
    if (allItems.isEmpty) return Offset(screenSize.width / 2, screenSize.height / 2);
    
    // Calculate bounds
    double minLat = allItems.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = allItems.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = allItems.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = allItems.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);
    
    // Add padding
    double latPadding = (maxLat - minLat) * 0.2;
    double lngPadding = (maxLng - minLng) * 0.2;
    
    // Normalize to 0-1 range
    double dx = (lng - minLng + lngPadding) / (maxLng - minLng + 2 * lngPadding);
    double dy = 1 - (lat - minLat + latPadding) / (maxLat - minLat + 2 * latPadding);
    
    // Convert to screen coordinates with margins
    double marginTop = 200;
    double marginBottom = 500;
    double marginSide = 40;
    
    double x = marginSide + dx * (screenSize.width - 2 * marginSide);
    double y = marginTop + dy * (screenSize.height - marginTop - marginBottom);
    
    return Offset(x, y);
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      const dashWidth = 8.0;
      const dashSpace = 6.0;
      double distance = 0.0;

      while (distance < metric.length) {
        final start = metric.getTangentForOffset(distance)?.position;
        distance += dashWidth;
        final end = metric.getTangentForOffset(distance.clamp(0, metric.length))?.position;
        
        if (start != null && end != null) {
          canvas.drawLine(start, end, paint);
        }
        distance += dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPathPainter oldDelegate) {
    return oldDelegate.tripItems != tripItems ||
           oldDelegate.selectedIndex != selectedIndex;
  }
}
