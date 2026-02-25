import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../data/adventure_data.dart';
import '../core/services/trip_data_service.dart';
import '../core/widgets/shared_bottom_nav_bar.dart';

class TravoAdventurePage extends StatefulWidget {
  const TravoAdventurePage({super.key});

  @override
  State<TravoAdventurePage> createState() => _TravoAdventurePageState();
}

class _TravoAdventurePageState extends State<TravoAdventurePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SavedTrip _selectedTrip;
  late List<TripItem> _currentTripItems;
  late List<SavedTrip> _allTrips;
  int _lastKnownServiceVersion = 0; // Track service version

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allTrips = getAllTrips();
    _selectedTrip = _allTrips[0];
    _currentTripItems = List.from(_selectedTrip.itinerary);
    
    // Update the trip data service
    _updateTripService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Sync trip items from service when returning to this page
    _syncTripItemsFromService();
  }

  void _syncTripItemsFromService() {
    final tripService = TripDataService();
    
    // Check if service version changed (meaning items were added/modified externally)
    if (tripService.hasCurrentTrip && 
        tripService.currentTripName == _selectedTrip.name &&
        tripService.version != _lastKnownServiceVersion) {
      setState(() {
        // Sync the latest items from service
        _currentTripItems = tripService.currentTripItems;
        _lastKnownServiceVersion = tripService.version;
      });
    }
  }

  void _updateTripService() {
    TripDataService().updateCurrentTrip(
      tripItems: _currentTripItems,
      tripName: _selectedTrip.name,
    );
    _lastKnownServiceVersion = TripDataService().version;
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop(context);
        }
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCurrentTripTab(),
                  _buildAllTripsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(activeRoute: '/adventure'),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(text: 'Current Trip'),
          Tab(text: 'All Trips'),
        ],
      ),
    );
  }

  Widget _buildCurrentTripTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _selectedTrip.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _showEditTripNameDialog(),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedTrip.dates} • ${_selectedTrip.duration}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                color: AppColors.primary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Share ${_selectedTrip.name}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Itinerary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _currentTripItems.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = _currentTripItems.removeAt(oldIndex);
                _currentTripItems.insert(newIndex, item);
                // Update indices
                for (int i = 0; i < _currentTripItems.length; i++) {
                  _currentTripItems[i].index = i + 1;
                }
                
                // Update the trip data service
                _updateTripService();
              });
            },
            itemBuilder: (context, index) {
              final item = _currentTripItems[index];
              return Padding(
                key: ValueKey(item.title),
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildTimelineItem(
                  context: context,
                  item: item,
                  isLast: index == _currentTripItems.length - 1,
                  itemIndex: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllTripsTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: const Text(
            'My Trips',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _allTrips.length,
            itemBuilder: (context, index) {
              final trip = _allTrips[index];
              return _buildTripCard(trip);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(SavedTrip trip) {
    final isSelected = _selectedTrip.id == trip.id;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTrip = trip;
          _currentTripItems = List.from(trip.itinerary);
          _tabController.animateTo(0);
          
          // Update the trip data service
          _updateTripService();
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        trip.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          setState(() {
                            _selectedTrip = trip;
                            _currentTripItems = List.from(trip.itinerary);
                            _tabController.animateTo(0); // Switch to Current Trip tab
                            
                            // Update the trip data service
                            _updateTripService();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Now editing ${trip.name}'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else if (value == 'delete') {
                          _showDeleteDialog(trip);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      trip.dates,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      trip.duration,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${trip.destinations} destinations',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

  void _showDeleteDialog(SavedTrip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allTrips.remove(trip);
                // If deleted trip was selected, switch to first available trip
                if (_selectedTrip.id == trip.id && _allTrips.isNotEmpty) {
                  _selectedTrip = _allTrips[0];
                  _currentTripItems = List.from(_selectedTrip.itinerary);
                  
                  // Update the trip data service
                  _updateTripService();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${trip.name} deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.background,
                  child: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedTrip.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${_selectedTrip.dates} • ${_selectedTrip.duration}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.background,
            child: const Icon(Icons.share, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required TripItem item,
    required bool isLast,
    required int itemIndex,
  }) {
    return ReorderableDelayedDragStartListener(
      index: itemIndex,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEditDestinationDialog(item, itemIndex),
          borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: item.index == 1
                        ? AppColors.primary
                        : AppColors.surface,
                    foregroundColor: item.index == 1
                        ? AppColors.textOnPrimary
                        : AppColors.primary,
                    child: Text(
                      item.index.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 16),
                    Container(width: 2, height: 80, color: AppColors.divider),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.tag.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STAY',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.stay,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 14,
                                    color: item.iconColor ?? AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.stayInfo,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: item.iconColor ?? AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/map',
                            arguments: {
                              'tripItems': _currentTripItems,
                              'selectedIndex': itemIndex,
                              'tripName': _selectedTrip.name,
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                            image: DecorationImage(
                              image: NetworkImage(item.mapImage),
                              fit: BoxFit.cover,
                              opacity: 0.6,
                            ),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.surface.withValues(
                                alpha: 0.7,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.drag_handle,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showEditDestinationDialog(TripItem item, int itemIndex) {
    final nightsController = TextEditingController(text: item.nights.toString());
    final budgetController = TextEditingController(text: item.budget.toStringAsFixed(2));
    String selectedPriority = item.priority;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor ?? AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
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
                  const SizedBox(height: 24),
                  
                  // AI Summary Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Summary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.aiSummary,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nights Field
                  const Text(
                    'Nights',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nightsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Number of nights',
                      prefixIcon: const Icon(Icons.hotel, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Priority Field
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.flag, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: ['Low', 'Medium', 'High'].map((priority) {
                        Color priorityColor = priority == 'High'
                            ? Colors.red
                            : priority == 'Medium'
                                ? AppColors.warning
                                : Colors.green;
                        
                        return DropdownMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: priorityColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(priority),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Budget Field
                  const Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: budgetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Budget amount',
                      prefixIcon: const Icon(Icons.attach_money, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: AppColors.divider),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final nights = int.tryParse(nightsController.text) ?? item.nights;
                            final budget = double.tryParse(budgetController.text) ?? item.budget;
                            
                            setState(() {
                              _currentTripItems[itemIndex].nights = nights;
                              _currentTripItems[itemIndex].priority = selectedPriority;
                              _currentTripItems[itemIndex].budget = budget;
                              _currentTripItems[itemIndex].subtitle = 
                                  '${item.subtitle.split('•')[0].trim()} • $nights ${nights == 1 ? 'Night' : 'Nights'}';
                            });
                            
                            Navigator.pop(context);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.title} updated successfully!'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditTripNameDialog() {
    final TextEditingController nameController = TextEditingController(
      text: _selectedTrip.name,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Trip Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter trip name',
              hintStyle: const TextStyle(color: AppColors.textDisabled),
              filled: true,
              fillColor: AppColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    _selectedTrip = SavedTrip(
                      id: _selectedTrip.id,
                      name: newName,
                      dates: _selectedTrip.dates,
                      duration: _selectedTrip.duration,
                      imageUrl: _selectedTrip.imageUrl,
                      destinations: _selectedTrip.destinations,
                      itinerary: _selectedTrip.itinerary,
                    );
                    
                    // Update the trip data service with new name
                    _updateTripService();
                  });
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Trip name updated successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}