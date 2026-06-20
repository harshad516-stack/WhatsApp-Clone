import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  void showFirebaseUsers(BuildContext context, WidgetRef ref) async {
    try {
      final firestore = FirebaseFirestore.instance;
      var userCollection = await firestore.collection('users').get();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Firebase Users'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userCollection.docs.length,
              itemBuilder: (context, index) {
                var userData = UserModel.fromMap(
                  userCollection.docs[index].data(),
                );
                return ListTile(
                  title: Text(userData.name),
                  subtitle: Text('Phone: ${userData.phoneNumber}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to load users: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    // 🚨 IMPORTANT: ONLY CHAT NAVIGATION (NO CALL HERE)
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () => showFirebaseUsers(context, ref),
            icon: const Icon(Icons.people),
            tooltip: 'Show Firebase Users',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) {
              if (contactList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.contacts_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No contacts found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Make sure you granted permission to access contacts',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          ref.refresh(getContactsProvider);
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];

                  return InkWell(
                    onTap: () {
                      debugPrint("Opening chat with: ${contact.displayName}");

                      // ✅ FORCE CHAT ONLY
                      selectContact(ref, contact, context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: contact.photo == null
                            ? const CircleAvatar(
                                child: Icon(Icons.person),
                                radius: 30,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    MemoryImage(contact.photo!),
                                radius: 30,
                              ),
                      ),
                    ),
                  );
                },
              );
            },
            error: (err, trace) {
              debugPrint('Error: $err');
              debugPrint('Trace: $trace');
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_ui/common/widgets/error.dart';
// import 'package:whatsapp_ui/common/widgets/loader.dart';
// import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';
// import 'package:whatsapp_ui/models/user_model.dart';

// class SelectContactsScreen extends ConsumerWidget {
//   static const String routeName = '/select-contact';
//   const SelectContactsScreen({Key? key}) : super(key: key);

//   void showFirebaseUsers(BuildContext context, WidgetRef ref) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       var userCollection = await firestore.collection('users').get();
      
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Firebase Users'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: userCollection.docs.length,
//               itemBuilder: (context, index) {
//                 var userData = UserModel.fromMap(userCollection.docs[index].data());
//                 return ListTile(
//                   title: Text(userData.name),
//                   subtitle: Text('Phone: ${userData.phoneNumber}'),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: Text('Failed to load users: $e'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   void selectContact(
//       WidgetRef ref, Contact selectedContact, BuildContext context) {
//     ref
//         .read(selectContactControllerProvider)
//         .selectContact(selectedContact, context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select contact'),
//         actions: [
//           IconButton(
//             onPressed: () => showFirebaseUsers(context, ref),
//             icon: const Icon(Icons.people),
//             tooltip: 'Show Firebase Users',
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.search,
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.more_vert,
//             ),
//           ),
//         ],
//       ),
//       body: ref.watch(getContactsProvider).when(
//             data: (contactList) {
//               if (contactList.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.contacts_outlined,
//                         size: 80,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'No contacts found',
//                         style: TextStyle(fontSize: 18, color: Colors.grey),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Make sure you granted permission to access contacts',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Refresh the contacts
//                           ref.refresh(getContactsProvider);
//                         },
//                         child: const Text('Try Again'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return ListView.builder(
//                   itemCount: contactList.length,
//                   itemBuilder: (context, index) {
//                     final contact = contactList[index];
//                     return InkWell(
//                       onTap: () => selectContact(ref, contact, context),
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: ListTile(
//                           title: Text(
//                             contact.displayName,
//                             style: const TextStyle(
//                               fontSize: 18,
//                             ),
//                           ),
//                           leading: contact.photo == null
//                               ? null
//                               : CircleAvatar(
//                                   backgroundImage: MemoryImage(contact.photo!),
//                                   radius: 30,
//                                 ),
//                         ),
//                       ),
//                     );
//                   });
//             },
//             error: (err, trace) {
//               debugPrint('Error: $err');
//               debugPrint('Trace: $trace');
//               return ErrorScreen(error: err.toString());
//             },
//             loading: () => const Loader(),
//           ),
//     );
//   }
// }
