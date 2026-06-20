import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  // ✅ CALL FUNCTION (separate feature)
  void makeCall(String number) async {
    final Uri url = Uri.parse("tel:$number");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Cannot launch dialer");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),

      body: StreamBuilder<List<ChatContact>>(
        stream: ref.read(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final contacts = snapshot.data!;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(contact.profilePic),
                ),

                title: Text(contact.name),
                subtitle: Text(contact.lastMessage),

                // ✅ TAP = OPEN CHAT ONLY
                onTap: () {
                  debugPrint("Opening chat: ${contact.contactId}");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MobileChatScreen(
                        name: contact.name,
                        uid: contact.contactId,
                        isGroupChat: false,
                        profilePic: contact.profilePic,
                      ),
                    ),
                  );
                },

                // ✅ CALL BUTTON (NOT AUTO)
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    makeCall(contact.contactId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_ui/common/utils/colors.dart';
// import 'package:whatsapp_ui/common/widgets/loader.dart';
// import 'package:whatsapp_ui/features/status/controller/status_controller.dart';
// import 'package:whatsapp_ui/features/status/screens/status_screen.dart';
// import 'package:whatsapp_ui/models/status_model.dart';

// class StatusContactsScreen extends ConsumerWidget {
//   const StatusContactsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FutureBuilder<List<Status>>(
//       future: ref.read(statusControllerProvider).getStatus(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Loader();
//         }
//         return ListView.builder(
//           itemCount: snapshot.data!.length,
//           itemBuilder: (context, index) {
//             var statusData = snapshot.data![index];
//             return Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(
//                       context,
//                       StatusScreen.routeName,
//                       arguments: statusData,
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: ListTile(
//                       title: Text(
//                         statusData.username,
//                       ),
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(
//                           statusData.profilePic,
//                         ),
//                         radius: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Divider(color: dividerColor, indent: 85),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
