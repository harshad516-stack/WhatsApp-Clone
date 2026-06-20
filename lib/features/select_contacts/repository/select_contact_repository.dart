import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];

    try {
      debugPrint("🔵 Requesting contacts permission...");
      
      // Request permission - this will show the system dialog
      final permission = await FlutterContacts.requestPermission(readonly: true);

      debugPrint("🔹 Permission granted: $permission");

      if (permission == true) {
        debugPrint("🔵 Fetching contacts...");
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
        debugPrint("🟢 Contacts fetched: ${contacts.length} contacts found");
      } else {
        debugPrint("🔴 Permission denied by user");
      }
    } catch (e) {
      debugPrint("🔴 Error fetching contacts: $e");
      rethrow; // This allows Riverpod to show the error
    }

    return contacts;
  }

  /// Normalize phone number by removing all non-digit characters
  String _normalizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\D'), '');
  }

  /// Compare two phone numbers with flexibility for different formats
  bool _phoneNumbersMatch(String contactNumber, String firestoreNumber) {
    String normalized1 = _normalizePhoneNumber(contactNumber);
    String normalized2 = _normalizePhoneNumber(firestoreNumber);

    debugPrint('📞 Comparing: "$contactNumber" vs "$firestoreNumber"');
    debugPrint('📞 Normalized: "$normalized1" vs "$normalized2"');

    // Exact match
    if (normalized1 == normalized2) {
      return true;
    }

    // If one has country code and other doesn't, try matching without it
    // For example: 919876543210 vs 9876543210
    if (normalized1.length > normalized2.length) {
      if (normalized1.endsWith(normalized2)) {
        return true;
      }
    } else if (normalized2.length > normalized1.length) {
      if (normalized2.endsWith(normalized1)) {
        return true;
      }
    }

    return false;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      if (selectedContact.phones.isEmpty) {
        showSnackBar(
          context: context,
          content: 'This contact has no phone number.',
        );
        return;
      }

      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      String selectedPhoneNum = selectedContact.phones[0].number;
      debugPrint('🔵 Selected contact phone: $selectedPhoneNum');
      debugPrint('🔵 Fetched ${userCollection.docs.length} users from Firebase');

      // Show debug dialog with all users and comparison
      String debugMessage = 'Contact Phone: $selectedPhoneNum\n\nFirebase Users:\n';
      
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        debugMessage += '${userData.name}: ${userData.phoneNumber}\n';
        
        if (_phoneNumbersMatch(selectedPhoneNum, userData.phoneNumber)) {
          isFound = true;
          debugPrint('✅ Found match! User: ${userData.name}');
          debugMessage += '\n✅ MATCH FOUND!\n';
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroupChat': false,
              'profilePic': userData.profilePic,
            },
          );
          break; // Exit loop after finding a match
        }
      }

      if (!isFound) {
        debugPrint('❌ No matching user found in Firebase');
        debugMessage += '\n❌ NO MATCH FOUND!\n';
        
        // Show detailed debug dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Phone Number Mismatch'),
            content: SingleChildScrollView(
              child: Text(debugMessage),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
        
        // Don't show the snackbar since we're showing the dialog
        return;
      }
    } catch (e) {
      debugPrint('❌ Error in selectContact: $e');
      showSnackBar(context: context, content: e.toString());
    }
  }
}
