import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(24.8607, 67.0011); // Default Karachi
  Location location = Location();
  Marker? _userMarker;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetLocation();
  }

  Future<void> _requestPermissionAndGetLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationData currentLocation = await location.getLocation();
    LatLng userLoc = LatLng(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    setState(() {
      _center = userLoc;
      _userMarker = Marker(
        markerId: const MarkerId("user"),
        position: userLoc,
        infoWindow: const InfoWindow(title: "You are here"),
      );
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(userLoc, 16.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map Example")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
        markers: _userMarker != null ? {_userMarker!} : {},
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class GoogleMapScreen extends StatefulWidget {
//   const GoogleMapScreen({super.key});

//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   GoogleMapController? _mapController;
//   LatLng _center = const LatLng(24.8607, 67.0011); // Default Karachi
//   Location location = Location();
//   Marker? _userMarker;

//   @override
//   void initState() {
//     super.initState();
//     if (!kIsWeb) {
//       _requestPermissionAndGetLocation();
//     }
//   }

//   Future<void> _requestPermissionAndGetLocation() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }

//     _getUserLocation();
//   }

//   Future<void> _getUserLocation() async {
//     try {
//       LocationData currentLocation = await location.getLocation();
//       LatLng userLoc = LatLng(
//         currentLocation.latitude!,
//         currentLocation.longitude!,
//       );

//       setState(() {
//         _center = userLoc;
//         _userMarker = Marker(
//           markerId: const MarkerId("user"),
//           position: userLoc,
//           infoWindow: const InfoWindow(title: "You are here"),
//         );
//       });

//       if (_mapController != null) {
//         _mapController!.animateCamera(
//           CameraUpdate.newLatLngZoom(userLoc, 16.0),
//         );
//       }
//     } catch (e) {
//       debugPrint("Error getting location: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Web fallback
//     if (kIsWeb) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Google Map Example")),
//         body: const Center(
//           child: Text(
//             "Google Maps is not supported on Web.\nPlease use Android or iOS.",
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     }

//     // Mobile (Android/iOS)
//     return Scaffold(
//       appBar: AppBar(title: const Text("Google Map Example")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
//         markers: _userMarker != null ? {_userMarker!} : {},
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getUserLocation,
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
// }
