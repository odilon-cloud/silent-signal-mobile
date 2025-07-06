import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapSelector extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationSelect;
  final LatLng? initialLocation;
  final String? className;

  const MapSelector({
    super.key,
    required this.onLocationSelect,
    this.initialLocation,
    this.className,
  });

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  LatLng? _selectedLocation;
  String? _selectedAddress;
  List<Marker> _markers = [];
  bool _isGeocoding = false;
  bool _isGettingLocation = false;
  LatLng _mapCenter = const LatLng(40.7128, -74.0060); // Default to NYC
  int _currentLayerIndex = 0;
  
  // Map layer options
  final List<MapLayer> _mapLayers = [
    MapLayer(
      name: "Street Map",
      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      subdomains: const ['a', 'b', 'c'],
    ),
    MapLayer(
      name: "Satellite",
      urlTemplate: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
      subdomains: const [],
    ),
    MapLayer(
      name: "Terrain",
      urlTemplate: "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
      subdomains: const ['a', 'b', 'c'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _mapCenter = widget.initialLocation!;
      _selectedLocation = widget.initialLocation!;
      _updateMarker(widget.initialLocation!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Reverse geocode coordinates to address
  Future<String> _reverseGeocode(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&addressdetails=1'
        ),
        headers: {'User-Agent': 'CrimeReportApp/1.0'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
      }
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
    }
    return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
  }

  // Geocode address to coordinates
  Future<void> _geocodeAddress(String address) async {
    setState(() => _isGeocoding = true);
    
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(address)}&limit=1'
        ),
        headers: {'User-Agent': 'CrimeReportApp/1.0'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lng = double.parse(data[0]['lon']);
          final foundAddress = data[0]['display_name'];
          
          final location = LatLng(lat, lng);
          
          setState(() {
            _mapCenter = location;
            _selectedLocation = location;
            _selectedAddress = foundAddress;
          });
          
          _updateMarker(location);
          _mapController.move(location, 15.0);
          widget.onLocationSelect(lat, lng, foundAddress);
        } else {
          _showSnackBar('Address not found. Please try a different search term.');
        }
      }
    } catch (e) {
      debugPrint('Geocoding failed: $e');
      _showSnackBar('Failed to search address. Please try again.');
    } finally {
      setState(() => _isGeocoding = false);
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      final location = LatLng(position.latitude, position.longitude);
      final address = await _reverseGeocode(position.latitude, position.longitude);
      
      setState(() {
        _mapCenter = location;
        _selectedLocation = location;
        _selectedAddress = address;
      });
      
      _updateMarker(location);
      _mapController.move(location, 16.0);
      widget.onLocationSelect(position.latitude, position.longitude, address);
      
    } catch (e) {
      debugPrint('Geolocation error: $e');
      _showSnackBar('Unable to get your current location. Please select manually on the map.');
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  // Update marker on map
  void _updateMarker(LatLng location) {
    setState(() {
      _markers = [
        Marker(
          point: location,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
      ];
    });
  }

  // Handle map tap
  void _onMapTap(TapPosition tapPosition, LatLng location) async {
    final address = await _reverseGeocode(location.latitude, location.longitude);
    
    setState(() {
      _selectedLocation = location;
      _selectedAddress = address;
    });
    
    _updateMarker(location);
    widget.onLocationSelect(location.latitude, location.longitude, address);
  }

  // Clear selection
  void _clearSelection() {
    setState(() {
      _selectedLocation = null;
      _selectedAddress = null;
      _markers = [];
    });
    widget.onLocationSelect(0, 0, '');
  }

  // Show snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Switch map layer
  void _switchMapLayer() {
    setState(() {
      _currentLayerIndex = (_currentLayerIndex + 1) % _mapLayers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.location_on, size: 20, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'Select Crime Scene Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for an address...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _geocodeAddress(value.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    onPressed: _isGeocoding
                        ? null
                        : () {
                            if (_searchController.text.trim().isNotEmpty) {
                              _geocodeAddress(_searchController.text.trim());
                            }
                          },
                    icon: _isGeocoding
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGettingLocation ? null : _getCurrentLocation,
                    icon: _isGettingLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.my_location, size: 16),
                    label: const Text('Current Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _switchMapLayer,
                  icon: const Icon(Icons.layers, size: 16),
                  label: Text(_mapLayers[_currentLayerIndex].name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
                if (_selectedLocation != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      onPressed: _clearSelection,
                      icon: const Icon(Icons.close, size: 16),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            
            // Selected Location Display
            if (_selectedLocation != null && _selectedAddress != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Location:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            
            // Map Container
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _mapCenter,
                        initialZoom: 13.0,
                        onTap: _onMapTap,
                        minZoom: 3.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: _mapLayers[_currentLayerIndex].urlTemplate,
                          subdomains: _mapLayers[_currentLayerIndex].subdomains,
                          userAgentPackageName: 'com.example.crime_report_app',
                        ),
                        MarkerLayer(markers: _markers),
                      ],
                    ),
                    
                    // Instructions overlay
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Tap on map to select location',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    
                    // Zoom controls
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _mapController.move(
                                  _mapController.camera.center,
                                  _mapController.camera.zoom + 1,
                                );
                              },
                              icon: const Icon(Icons.add, size: 18),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _mapController.move(
                                  _mapController.camera.center,
                                  _mapController.camera.zoom - 1,
                                );
                              },
                              icon: const Icon(Icons.remove, size: 18),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for map layers
class MapLayer {
  final String name;
  final String urlTemplate;
  final List<String> subdomains;

  MapLayer({
    required this.name,
    required this.urlTemplate,
    required this.subdomains,
  });
}