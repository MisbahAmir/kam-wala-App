import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';

/// ========================= LIST SCREEN =========================
class SalonProductsList extends StatefulWidget {
  const SalonProductsList({super.key});

  @override
  State<SalonProductsList> createState() => _SalonProductsListState();
}

class _SalonProductsListState extends State<SalonProductsList> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  String _activeCategory = 'All';

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() => _query = _search.text.trim()));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const LinearGradient(
      colors: [Color(0xFFFFF1F6), Color(0xFFFFDFEA), Color(0xFFFFF6FB)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: bg),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Row(
                  children: [
                    _softIconButton(
                      context,
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.maybePop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Salon Services",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD81B60),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    _softIconButton(
                      context,
                      icon: Icons.more_horiz_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withOpacity(.5),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          decoration: const InputDecoration(
                            hintText: "Search service name",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _softMiniIcon(icon: Icons.tune_rounded, onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _CategoriesBar(
                active: _activeCategory,
                onChanged: (v) => setState(() => _activeCategory = v),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('salonProducts')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snap.hasData || snap.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No products yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final docs =
                        snap.data!.docs.where((d) {
                          final m = d.data() as Map<String, dynamic>;
                          final title =
                              (m['title'] ?? '').toString().toLowerCase();
                          final cat = (m['category'] ?? '').toString();
                          final matchesSearch =
                              _query.isEmpty ||
                              title.contains(_query.toLowerCase());
                          final matchesCat =
                              _activeCategory == 'All' ||
                              cat == _activeCategory;
                          return matchesSearch && matchesCat;
                        }).toList();

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder:
                          (context, i) => _ProductRowCard(doc: docs[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _softIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withOpacity(.6),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFFD81B60), size: 20),
      ),
    );
  }

  Widget _softMiniIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEF5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFD81B60), size: 18),
      ),
    );
  }
}

class _CategoriesBar extends StatelessWidget {
  final String active;
  final ValueChanged<String> onChanged;
  const _CategoriesBar({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('salonProducts').snapshots(),
      builder: (context, snap) {
        final base = <String>['All'];
        if (snap.hasData) {
          final set = <String>{};
          for (final d in snap.data!.docs) {
            final m = d.data() as Map<String, dynamic>;
            if (m['category'] != null) set.add(m['category'].toString());
          }
          base.addAll(set.toList()..sort());
        }
        return SizedBox(
          height: 76,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: base.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final isActive = base[i] == active;
              return GestureDetector(
                onTap: () => onChanged(base[i]),
                child: Container(
                  width: 86,
                  decoration: BoxDecoration(
                    gradient:
                        isActive
                            ? const LinearGradient(
                              colors: [Color(0xFFFF97B8), Color(0xFFFFC2D7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: isActive ? null : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withOpacity(.5),
                        blurRadius: 14,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.spa,
                        color:
                            isActive ? Colors.white : const Color(0xFFD81B60),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        base[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              isActive ? Colors.white : const Color(0xFFD81B60),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductRowCard extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  const _ProductRowCard({required this.doc});

  @override
  State<_ProductRowCard> createState() => _ProductRowCardState();
}

class _ProductRowCardState extends State<_ProductRowCard> {
  Uint8List _safeDecode(String base64Str) {
    try {
      if (base64Str.isEmpty) return Uint8List(0);
      return base64Decode(base64Str);
    } catch (_) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.doc.data() as Map<String, dynamic>;
    final title = (m['title'] ?? '').toString();
    final desc = (m['description'] ?? '').toString();
    final priceStr = (m['price'] ?? '').toString();
    final price = double.tryParse(priceStr) ?? 0.0;
    final cat = (m['category'] ?? '').toString();
    final img = _safeDecode((m['image'] ?? '').toString());

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder:
                (_, a1, a2) => FadeTransition(
                  opacity: a1,
                  child: SalonProductDetail(
                    title: title,
                    description: desc,
                    price: price,
                    category: cat,
                    imageBytes: img,
                    heroTag: widget.doc.id,
                  ),
                ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withOpacity(.5),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: widget.doc.id,
              child: Container(
                height: 110,
                width: 110,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      img.isEmpty
                          ? const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          )
                          : Image.memory(img, fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "\$${price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Color(0xFFD81B60),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cat,
                        style: const TextStyle(
                          color: Color(0xFFD81B60),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
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

/// ========================= DETAIL SCREEN =========================
class SalonProductDetail extends StatefulWidget {
  final String title, description, category, heroTag;
  final double price;
  final Uint8List imageBytes;
  const SalonProductDetail({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageBytes,
    required this.heroTag,
  });

  @override
  State<SalonProductDetail> createState() => _SalonProductDetailState();
}

class _SalonProductDetailState extends State<SalonProductDetail> {
  bool fav = false;

  Future<void> _bookAppointment() async {
    final picked = await showModalBottomSheet<_PickedDateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _PickDateTimeSheet(),
    );

    if (picked == null) return;

    try {
      final col = FirebaseFirestore.instance.collection('appointments');
      final docRef = col.doc();
      // await docRef.set({
      //   'appointmentId': docRef.id,
      //   'serviceName': widget.title,
      //   'category': widget.category,
      //   'price': widget.price,
      //   'date': DateFormat('yyyy-MM-dd').format(picked.date),
      //   'time': picked.time.format(context),
      //   'status': 'pending',
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      await docRef.set({
        'appointmentId': docRef.id,
        'serviceName': widget.title,
        'category': widget.category,
        'price': widget.price,
        'date': DateFormat('yyyy-MM-dd').format(picked.date),
        'time': picked.time.format(context),
        'location': picked.location, // <-- yeh line add karo
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => _AppointmentSuccessDialog(
              serviceName: widget.title,
              date: picked.date,
              time: picked.time,
              docId: docRef.id,
            ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Hero(
            tag: widget.heroTag,
            child: Image.memory(
              widget.imageBytes,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            "Category: ${widget.category}",
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            "Price: Rs. ${widget.price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            onPressed: _bookAppointment,
            child: const Text(
              "Add Appointment Now",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// ========================= SUCCESS DIALOG =========================
/// ========================= SUCCESS DIALOG =========================
class _AppointmentSuccessDialog extends StatefulWidget {
  final String serviceName;
  final DateTime date;
  final TimeOfDay time;
  final String docId;
  const _AppointmentSuccessDialog({
    required this.serviceName,
    required this.date,
    required this.time,
    required this.docId,
  });

  @override
  State<_AppointmentSuccessDialog> createState() =>
      _AppointmentSuccessDialogState();
}

class _AppointmentSuccessDialogState extends State<_AppointmentSuccessDialog> {
  bool confirmed = false;
  bool rejected = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    // Listen to live status updates
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.docId)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;
          final status = doc['status'];
          if (status == 'confirmed') {
            setState(() {
              confirmed = true;
              rejected = false;
            });
            _confettiController.play();
          } else if (status == 'rejected') {
            setState(() {
              rejected = true;
              confirmed = false;
            });
          }
        });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        confirmed
            ? "🎉 Appointment Confirmed!"
            : rejected
            ? "❌ Appointment Rejected"
            : "⏳ Waiting for Confirmation",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Service: ${widget.serviceName}"),
          Text("Date: ${DateFormat('yyyy-MM-dd').format(widget.date)}"),
          Text("Time: ${widget.time.format(context)}"),
          const SizedBox(height: 16),
          if (confirmed)
            Column(
              children: [
                const Text(
                  "Your appointment has been confirmed!",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                  ),
                ),
              ],
            )
          else if (rejected)
            const Text(
              "Sorry! Your appointment request was rejected.",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )
          else
            const Text("Salon needs to confirm your appointment..."),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}

class _PickDateTimeSheet extends StatefulWidget {
  const _PickDateTimeSheet();

  @override
  State<_PickDateTimeSheet> createState() => _PickDateTimeSheetState();
}

class _PickDateTimeSheetState extends State<_PickDateTimeSheet> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;

  final List<String> _locations = [
    "Glamour Beauty Salon - Korangi No.1",
    "Kashee’s Beauty Parlor - Korangi No.2",
    "Depilex Beauty Clinic & Salon - Korangi No.4",
    "Nabila’s Salon - Korangi Industrial Area",
    "Allenora Beauty Salon - Korangi Crossing",
    "Sabs the Salon - Korangi No.5",
    "Toni & Guy - Korangi Creek Road",
    "Blazon Salon & Spa - Korangi No.6",
    "Natasha’s Salon - Korangi No.3",
    "Diva’s Beauty Parlor - Korangi 100 Quarters",
    "Rukhsar Beauty Salon - Korangi Township",
    "Style & Smile Beauty Parlor - Korangi No.2",
    "Rani’s Salon & Spa - Korangi No.5",
    "Sapphire Salon - Korangi Expressway",
    "Dreams Beauty Salon - Korangi Crossing",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Date, Time & Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Date
            ListTile(
              leading: const Icon(Icons.date_range, color: Colors.purple),
              title: Text(
                selectedDate == null
                    ? "Pick a Date"
                    : DateFormat('EEE, MMM d, yyyy').format(selectedDate!),
              ),
              onTap: () async {
                final now = DateTime.now();
                final date = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 365)),
                );
                if (date != null) setState(() => selectedDate = date);
              },
            ),
            const SizedBox(height: 8),

            // Time
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.pink),
              title: Text(
                selectedTime == null
                    ? "Pick a Time"
                    : selectedTime!.format(context),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) setState(() => selectedTime = time);
              },
            ),
            const SizedBox(height: 8),

            // Location
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.teal),
              title: DropdownButton<String>(
                value: selectedLocation,
                hint: const Text("Select Location"),
                isExpanded: true,
                items:
                    _locations
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => selectedLocation = v),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed:
                  (selectedDate != null &&
                          selectedTime != null &&
                          selectedLocation != null)
                      ? () => Navigator.pop(
                        context,
                        _PickedDateTime(
                          date: selectedDate!,
                          time: selectedTime!,
                          location: selectedLocation!,
                        ),
                      )
                      : null,
              child: const Text(
                "Confirm Appointment",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PickedDateTime {
  final DateTime date;
  final TimeOfDay time;
  final String location;
  _PickedDateTime({
    required this.date,
    required this.time,
    required this.location,
  });
}
