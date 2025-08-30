// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:kam_wala_app/dashboard/AddPost.dart';

// class Fatechdata extends StatefulWidget {
//   const Fatechdata({super.key});

//   @override
//   State<Fatechdata> createState() => _FatechdataState();
// }

// class _FatechdataState extends State<Fatechdata> {
//   //step 74 making ref instance

//   final DatabaseRef = FirebaseDatabase.instance.ref('category');

//   // step 88 making delete function

//   void DataDelete(String PostId) async {
//     // step 91 category deleted

//     EasyLoading.show(status: "Deleting..........");
//     DatabaseRef.child(PostId)
//         .remove()
//         .then((value) {
//           EasyLoading.showSuccess("Category is Deleted");
//         })
//         .catchError((error) {
//           EasyLoading.showError("Failed TO Deleted $error");
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // step 72
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Data Fatech",
//           style: TextStyle(
//             backgroundColor: const Color.fromARGB(255, 20, 20, 20),
//             color: const Color.fromARGB(255, 250, 175, 12),
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         centerTitle: true,
//       ),

//       //step 74 making floating button
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Post()),
//           );
//         },

//         child: Icon(Icons.add),
//       ),

//       //step 76 creating data loading
//       body: Container(
//         child: Expanded(
//           child: FirebaseAnimatedList(
//             query: DatabaseRef,
//             itemBuilder: (context, Snapshot, Animation, Index) {
//               String postid = Snapshot.key!;
//               // String Title =
//               //     Snapshot.child("product Name").value as String? ??
//               //     "No data found";
//               String Title =
//                   Snapshot.child("productName").value as String? ??
//                   "No data found";

//               String description =
//                   Snapshot.child("description").value as String? ??
//                   "No data found";

//               return ListTile(
//                 title: Text(Title),
//                 subtitle: Text(description),

//                 // step 77 making buttons edit or delete
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         //step 80 calling route
//                         // Navigator.pushReplacement(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder:
//                         //         (context) => updatedata(
//                         //           //step 81 add 3 parametters
//                         //           postId: postid,
//                         //           Title: Title,
//                         //           desc: description,
//                         //         ),
//                         //   ),
//                         // );
//                       },
//                       icon: Icon(Icons.edit, color: Colors.blueAccent),
//                     ),

//                     IconButton(
//                       //step 90 call function
//                       //onPressed: DataDelete,
//                       icon: Icon(
//                         Icons.delete,
//                         color: const Color.fromARGB(255, 152, 2, 95),
//                       ),

//                       //step 92
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder:
//                               (value) => AlertDialog(
//                                 title: Text("Confirm Deleted..........."),
//                                 content: Text(
//                                   "Are You Sure This Data Is Deleted .............",
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: Text("Cancel"),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       DataDelete(postid);
//                                     },
//                                     child: Text("Okay ........."),
//                                   ),
//                                 ],
//                               ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kam_wala_app/dashboard/AddPost.dart';

class Fatechdata extends StatefulWidget {
  const Fatechdata({super.key});

  @override
  State<Fatechdata> createState() => _FatechdataState();
}

class _FatechdataState extends State<Fatechdata> {
  final DatabaseRef = FirebaseDatabase.instance.ref('category');

  void DataDelete(String PostId) async {
    EasyLoading.show(status: "Deleting...");
    DatabaseRef.child(PostId)
        .remove()
        .then((value) {
          EasyLoading.showSuccess("Category Deleted");
        })
        .catchError((error) {
          EasyLoading.showError("Failed To Delete $error");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "User service data add",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Post()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF4FF), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 90, left: 12, right: 12),
          child: FirebaseAnimatedList(
            query: DatabaseRef,
            itemBuilder: (context, snapshot, animation, index) {
              String postid = snapshot.key!;
              String Title =
                  snapshot.child("productName").value as String? ??
                  "No data found";
              String description =
                  snapshot.child("description").value as String? ??
                  "No data found";

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    title: Text(
                      Title,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Edit logic here
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (value) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Text("Confirm Delete"),
                                    content: const Text(
                                      "Are you sure you want to delete this record?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          DataDelete(postid);
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
