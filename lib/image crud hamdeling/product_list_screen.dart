import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kam_wala_app/image%20crud%20hamdeling/product_model.dart';
import 'package:kam_wala_app/image%20crud%20hamdeling/worker_tracking_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class ProductListScreen extends StatelessWidget {
  final String category;
  const ProductListScreen({super.key, required this.category});

  Future<List<ProductModel>> fetchProductsByCategory() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .where('Category', isEqualTo: category)
            .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchWorkers() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "worker")
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void _showRadarAnimation(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Multiple animated circles
                ...List.generate(3, (i) {
                  return AnimatedContainer(
                    duration: Duration(seconds: 2 + i),
                    curve: Curves.easeInOutCubic,
                    width: 220 - (i * 60).toDouble(),
                    height: 220 - (i * 60).toDouble(),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.25),
                          Colors.teal.withOpacity(0.05),
                        ],
                        stops: const [0.2, 1],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  );
                }),

                // Glowing radar icon
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyanAccent.withOpacity(0.8),
                        Colors.tealAccent.withOpacity(0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.radar, size: 70, color: Colors.black),
                ),

                // Pulsing glow effect
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.9, end: 1.1),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                    onEnd: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showWorkerDetails(context, product);
    });
  }

  void _showWorkerDetails(BuildContext context, ProductModel product) async {
    List<Map<String, dynamic>> workers = await fetchWorkers();

    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No workers available right now")),
      );
      return;
    }

    Map<String, dynamic> randomWorker =
        workers[Random().nextInt(workers.length)];

    String selectedETA = "15 min";
    String workerId = randomWorker["uid"] ?? "WRK-${Random().nextInt(9999)}";
    String workerName = randomWorker["name"] ?? "Unnamed Worker";
    String workerPhone = randomWorker["phone"] ?? "03001234567";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 140, 212, 245),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 60,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Text(
                      "Worker Found ✅",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        workerName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Name: $workerName",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text("Worker ID: $workerId"),

                    // Wrap(
                    //   spacing: 10,
                    //   children:
                    //       ["15 min", "30 min", "1 hr"].map((eta) {
                    //         return ChoiceChip(
                    //           label: Text(eta),
                    //           selected: selectedETA == eta,
                    //           onSelected:
                    //               (_) => setState(() => selectedETA = eta),
                    //         );
                    //       }).toList(),
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      "Service: ${product.protitle}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Charges: ${product.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          243,
                          204,
                          114,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                      ),
                      icon: const Icon(Icons.done),

                      label: const Text("Confirm & Save"),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("orders")
                            .add({
                              "workerId": workerId,
                              "workerName": workerName,
                              "ETA": selectedETA,
                              "serviceName": product.protitle,
                              "charges": product.price,
                              "status": "assigned",
                              "timestamp": FieldValue.serverTimestamp(),
                            });

                        // Confirm ke baad Tracking page pe le jao
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WorkerTrackingPage(
                                  workerId: workerId,
                                  workerName: workerName,
                                  workerPhone: workerPhone,
                                  eta: selectedETA,
                                  serviceName: product.protitle,
                                  charges: product.price,
                                ),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Worker assigned successfully!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.teal.shade600,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: "OK",
                              textColor: Colors.yellowAccent,
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  //change

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f7fe),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff2193b0), Color(0xff6dd5ed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 6,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: fetchProductsByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching products"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Products Found"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => _showRadarAnimation(context, product),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            product.image.isNotEmpty
                                ? Image.memory(
                                  base64Decode(product.image),
                                  width: 180,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.blue.shade100,
                                  child: const Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.protitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0a7bfc),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rs. ${product.price}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
