import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkerTrackingPage extends StatefulWidget {
  final String workerId;
  final String workerName;
  final String workerPhone;
  final String eta;
  final String serviceName;
  final String charges;

  const WorkerTrackingPage({
    super.key,
    required this.workerId,
    required this.workerName,
    required this.workerPhone,
    required this.eta,
    required this.serviceName,
    required this.charges,
  });

  @override
  State<WorkerTrackingPage> createState() => _WorkerTrackingPageState();
}

class _WorkerTrackingPageState extends State<WorkerTrackingPage> {
  GoogleMapController? _mapController;
  LatLng _workerLocation = const LatLng(24.8607, 67.0011); // Karachi default
  LatLng _userLocation = const LatLng(
    24.9207,
    67.0300,
  ); // user dummy (fetch from Firestore)
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    // Worker ki location Firestore se real-time
    FirebaseFirestore.instance
        .collection("workersLocation")
        .doc(widget.workerId)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            final data = doc.data()!;
            final lat = data["lat"] ?? 24.8607;
            final lng = data["lng"] ?? 67.0011;
            setState(() {
              _workerLocation = LatLng(lat, lng);
              _setMarkers();
            });
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(_workerLocation, 14),
            );
          }
        });

    // User location (Firestore se fetch karo, dummy rakh diya abhi)
    FirebaseFirestore.instance
        .collection("usersLocation")
        .doc("USER_ID") // 👈 isko actual userId se replace karo
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            final data = doc.data()!;
            final lat = data["lat"] ?? 24.9207;
            final lng = data["lng"] ?? 67.0300;
            setState(() {
              _userLocation = LatLng(lat, lng);
              _setMarkers();
            });
          }
        });
  }

  void _setMarkers() {
    _markers.clear();
    // Worker Marker
    _markers.add(
      Marker(
        markerId: const MarkerId("worker"),
        position: _workerLocation,
        infoWindow: InfoWindow(title: widget.workerName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
    // User Marker
    _markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: _userLocation,
        infoWindow: const InfoWindow(title: "You"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> _launchCaller() async {
    final Uri url = Uri(scheme: 'tel', path: widget.workerPhone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchSMS() async {
    final Uri url = Uri(scheme: 'sms', path: widget.workerPhone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/${widget.workerPhone}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _markJobDone() async {
    await FirebaseFirestore.instance.collection("orders").add({
      "workerId": widget.workerId,
      "workerName": widget.workerName,
      "serviceName": widget.serviceName,
      "charges": widget.charges,
      "status": "completed",
      "timestamp": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Job marked as done ✅"),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f7fe),
      appBar: AppBar(
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff00c6ff), Color(0xff0072ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Worker Tracking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Google Map
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _workerLocation,
                  zoom: 13,
                ),
                onMapCreated: (controller) => _mapController = controller,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ),

          // Worker Details Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        widget.workerName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.workerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text("ETA: ${widget.eta}"),
                        Text("Charges: Rs. ${widget.charges}"),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _launchCaller,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          133,
                          146,
                          244,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.call),
                      label: const Text("Call"),
                    ),

                    ElevatedButton.icon(
                      onPressed: _launchWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          139,
                          239,
                          88,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                      label: const Text("WhatsApp"),
                    ),
                    ElevatedButton.icon(
                      onPressed: _markJobDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          252,
                          237,
                          102,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Job Done"),
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
