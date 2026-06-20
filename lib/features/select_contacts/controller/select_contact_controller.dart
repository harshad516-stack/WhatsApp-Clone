import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' show Contact;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final repo = ref.watch(selectContactsRepositoryProvider);
  return repo.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final repo = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: repo,
  );
});

class SelectContactController {
  final Ref ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    // 🚨 FORCE CHAT NAVIGATION ONLY (NO CALL EVER HERE)

    Navigator.pushNamed(
      context,
      '/mobile-chat', // your chat screen route
      arguments: {
        'name': selectedContact.displayName,
        'uid': selectedContact.id,
        'isGroupChat': false,
        'profilePic': selectedContact.photo,
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart' show Contact;
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

// final getContactsProvider = FutureProvider((ref) {
//   final selectContactRepository =
//       ref.watch(selectContactsRepositoryProvider);
//   return selectContactRepository.getContacts();
// });

// final selectContactControllerProvider = Provider((ref) {
//   final selectContactRepository =
//       ref.watch(selectContactsRepositoryProvider);
//   return SelectContactController(
//     ref: ref,
//     selectContactRepository: selectContactRepository,
//   );
// });

// class SelectContactController {
//   final Ref ref;
//   final SelectContactRepository selectContactRepository;

//   SelectContactController({
//     required this.ref,
//     required this.selectContactRepository,
//   });

//   void selectContact(Contact selectedContact, BuildContext context) {
//     // 🚨 IMPORTANT: DO NOT CALL ANY CALL FUNCTION HERE

//     // 🔥 Navigate ONLY to chat screen
//     Navigator.pushNamed(
//       context,
//       '/mobile-chat', // make sure this route exists in your routes
//       arguments: {
//         'name': selectedContact.displayName,
//         'uid': selectedContact.id,
//         'isGroupChat': false,
//         'profilePic': selectedContact.photo,
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart' show Contact;
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

// final getContactsProvider = FutureProvider((ref) {
//   final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
//   return selectContactRepository.getContacts();
// });

// final selectContactControllerProvider = Provider((ref) {
//   final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
//   return SelectContactController(
//     ref: ref,
//     selectContactRepository: selectContactRepository,
//   );
// });

// class SelectContactController {
//   final Ref ref;
//   final SelectContactRepository selectContactRepository;
//   SelectContactController({
//     required this.ref,
//     required this.selectContactRepository,
//   });

//   void selectContact(Contact selectedContact, BuildContext context) {
//     selectContactRepository.selectContact(selectedContact, context);
//   }
// }
