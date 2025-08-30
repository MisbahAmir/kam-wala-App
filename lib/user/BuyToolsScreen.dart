// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BuyToolsScreen extends StatelessWidget {
//   const BuyToolsScreen({super.key});

//   final List<Map<String, dynamic>> products = const [
//     {
//       'name': 'Screwdriver Set',
//       'price': 450,
//       'image': 'assets/images/screwdriver.png',
//     },
//     {'name': 'Hammer', 'price': 350, 'image': 'assets/images/hammer.png'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Buy Tools"),
//         backgroundColor: Colors.yellow,
//         foregroundColor: Colors.black,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return Card(
//             color: Colors.grey[900],
//             margin: const EdgeInsets.only(bottom: 16),
//             child: ListTile(
//               leading: Image.asset(product['image'], height: 40),
//               title: Text(
//                 product['name'],
//                 style: const TextStyle(color: Colors.white),
//               ),
//               subtitle: Text(
//                 "Rs. ${product['price']}",
//                 style: const TextStyle(color: Colors.white70),
//               ),
//               trailing: const Icon(Icons.shopping_cart, color: Colors.yellow),
//               onTap: () {
//                 _logProductClick(product['name']);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Purchase feature coming soon")),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _logProductClick(String productName) {
//     FirebaseFirestore.instance.collection('product_logs').add({
//       'product': productName,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyToolsScreen extends StatefulWidget {
  const BuyToolsScreen({super.key});

  @override
  State<BuyToolsScreen> createState() => _BuyToolsScreenState();
}

class _BuyToolsScreenState extends State<BuyToolsScreen> {
  late Future<List<Map<String, dynamic>>> _toolsFuture;

  Future<List<Map<String, dynamic>>> _fetchTools() async {
    final snapshot = await FirebaseFirestore.instance.collection('tools').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  void initState() {
    super.initState();
    _toolsFuture = _fetchTools();
  }

  Future<void> _refresh() async {
    setState(() {
      _toolsFuture = _fetchTools();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Buy Tools",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.yellow,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _toolsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.yellow),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error fetching tools.",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              );
            }

            final tools = snapshot.data ?? [];

            if (tools.isEmpty) {
              return Center(
                child: Text(
                  "No tools available.",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tools.length,
              itemBuilder: (context, index) {
                final tool = tools[index];
                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            tool['imageUrl'] ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tool['name'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tool['description'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "PKR ${tool['price'] ?? 0}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Purchase feature coming soon!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Text("Buy"),
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
      ),
    );
  }
}
