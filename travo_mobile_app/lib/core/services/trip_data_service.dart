import 'package:flutter/material.dart';
import '../../data/adventure_data.dart';

/// Singleton service to share current trip data across pages
class TripDataService {
  static final TripDataService _instance = TripDataService._internal();
  
  factory TripDataService() {
    return _instance;
  }
  
  TripDataService._internal();
  
  List<TripItem> _currentTripItems = [];
  String _currentTripName = '';
  int _selectedIndex = 0;
  int _version = 0; // Track changes to trip items
  
  // Getters
  List<TripItem> get currentTripItems => _currentTripItems;
  String get currentTripName => _currentTripName;
  int get selectedIndex => _selectedIndex;
  int get version => _version;
  bool get hasCurrentTrip => _currentTripItems.isNotEmpty;
  
  // Update current trip data
  void updateCurrentTrip({
    required List<TripItem> tripItems,
    required String tripName,
    int selectedIndex = 0,
  }) {
    _currentTripItems = tripItems;
    _currentTripName = tripName;
    _selectedIndex = selectedIndex;
  }
  
  // Update only the selected index (when tapping pins)
  void updateSelectedIndex(int index) {
    if (index >= 0 && index < _currentTripItems.length) {
      _selectedIndex = index;
    }
  }
  
  // Add a new destination to current trip
  void addDestination(TripItem newItem) {
    // Set the index to be next in sequence
    newItem.index = _currentTripItems.length + 1;
    _currentTripItems.add(newItem);
    _version++; // Increment version to track changes
  }
  
  // Add destination at specific position (for My Location feature)
  void addDestinationAtPosition(TripItem newItem, int position) {
    // Insert at the specified position
    _currentTripItems.insert(position, newItem);
    // Re-index all items
    for (int i = 0; i < _currentTripItems.length; i++) {
      _currentTripItems[i].index = i + 1;
    }
    _version++; // Increment version to track changes
  }
  
  // Get the position where new location should be added
  // Returns 0 if journey hasn't started, otherwise position after current location
  int getInsertPosition() {
    if (_currentTripItems.isEmpty) return 0;
    // If we haven't started (selectedIndex is 0), add at beginning
    if (_selectedIndex == 0) return 0;
    // Otherwise add after the current/visited location
    return _selectedIndex + 1;
  }
  
  // Create a TripItem from basic place info
  TripItem createTripItemFromPlace({
    required String title,
    required String location,
    required String imageUrl,
    required double rating,
    double latitude = 0.0,
    double longitude = 0.0,
  }) {
    return TripItem(
      index: _currentTripItems.length + 1,
      title: title,
      subtitle: 'Added from recommendations',
      tag: 'NEW',
      stay: '2 nights',
      stayInfo: 'Recommended stay duration',
      icon: Icons.place,
      iconColor: Colors.blue,
      mapImage: imageUrl,
      location: location,
      nights: 2,
      priority: 'Medium',
      budget: 150.0,
      aiSummary: 'Explore this amazing destination with great activities and attractions.',
      latitude: latitude,
      longitude: longitude,
    );
  }
  
  // Clear trip data
  void clearTrip() {
    _currentTripItems = [];
    _currentTripName = '';
    _selectedIndex = 0;
  }
}
