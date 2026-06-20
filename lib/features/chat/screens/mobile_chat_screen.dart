import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/colors.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';

  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  /// ✅ CALL FUNCTION (SAFE)
  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ❌ REMOVED CallPickupScreen (MAIN FIX)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream:
                    ref.read(authControllerProvider).userDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Loader();
                  }

                  if (!snapshot.hasData) {
                    return Text(name);
                  }

                  final user = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Text(
                        user.isOnline ? 'online' : 'offline',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                },
              ),

        /// 🔴 ACTION BUTTONS
        actions: [
          /// VIDEO CALL
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () => makeCall(ref, context),
          ),

          /// VOICE CALL
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => makeCall(ref, context),
          ),

          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      /// 🟢 CHAT UI
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomChatField(
            recieverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_ui/common/utils/colors.dart';
// import 'package:whatsapp_ui/common/widgets/loader.dart';
// import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
// import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
// import 'package:whatsapp_ui/features/call/screens/call_pickup_screen.dart';
// import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field.dart';
// import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';
// import 'package:whatsapp_ui/models/user_model.dart';

// class MobileChatScreen extends ConsumerWidget {
//   static const String routeName = '/mobile-chat-screen';

//   final String name;
//   final String uid;
//   final bool isGroupChat;
//   final String profilePic;

//   const MobileChatScreen({
//     Key? key,
//     required this.name,
//     required this.uid,
//     required this.isGroupChat,
//     required this.profilePic,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CallPickupScreen(
//       // IMPORTANT: This ensures chat is shown when no call is active
//       scaffold: Scaffold(
//         appBar: AppBar(
//           backgroundColor: appBarColor,
//           title: isGroupChat
//               ? Text(name)
//               : StreamBuilder<UserModel>(
//                   stream: ref
//                       .read(authControllerProvider)
//                       .userDataById(uid),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const Loader();
//                     }

//                     if (!snapshot.hasData) {
//                       return Text(name);
//                     }

//                     final user = snapshot.data!;

//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(name),
//                         Text(
//                           user.isOnline ? 'online' : 'offline',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//           actions: [
//             /// 🔴 VIDEO CALL BUTTON
//             IconButton(
//               icon: const Icon(Icons.video_call),
//               onPressed: () {
//                 ref.read(callControllerProvider).makeCall(
//                       context,
//                       name,
//                       uid,
//                       profilePic,
//                       isGroupChat,
//                     );
//               },
//             ),

//             /// 🔴 VOICE CALL BUTTON
//             IconButton(
//               icon: const Icon(Icons.call),
//               onPressed: () {
//                 ref.read(callControllerProvider).makeCall(
//                       context,
//                       name,
//                       uid,
//                       profilePic,
//                       isGroupChat,
//                     );
//               },
//             ),

//             IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () {},
//             ),
//           ],
//         ),

//         /// 🟢 CHAT AREA
//         body: Column(
//           children: [
//             Expanded(
//               child: ChatList(
//                 recieverUserId: uid,
//                 isGroupChat: isGroupChat,
//               ),
//             ),

//             BottomChatField(
//               recieverUserId: uid,
//               isGroupChat: isGroupChat,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:whatsapp_ui/common/utils/colors.dart';
// // import 'package:whatsapp_ui/common/widgets/loader.dart';
// // import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
// // import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
// // import 'package:whatsapp_ui/features/call/screens/call_pickup_screen.dart';
// // import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field.dart';
// // import 'package:whatsapp_ui/models/user_model.dart';
// // import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';

// // class MobileChatScreen extends ConsumerWidget {
// //   static const String routeName = '/mobile-chat-screen';
// //   final String name;
// //   final String uid;
// //   final bool isGroupChat;
// //   final String profilePic;
// //   const MobileChatScreen({
// //     Key? key,
// //     required this.name,
// //     required this.uid,
// //     required this.isGroupChat,
// //     required this.profilePic,
// //   }) : super(key: key);

// //   void makeCall(WidgetRef ref, BuildContext context) {
// //     ref.read(callControllerProvider).makeCall(
// //           context,
// //           name,
// //           uid,
// //           profilePic,
// //           isGroupChat,
// //         );
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     return CallPickupScreen(
// //       scaffold: Scaffold(
// //         appBar: AppBar(
// //           backgroundColor: appBarColor,
// //           title: isGroupChat
// //               ? Text(name)
// //               : StreamBuilder<UserModel>(
// //                   stream: ref.read(authControllerProvider).userDataById(uid),
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return const Loader();
// //                     }
// //                     return Column(
// //                       children: [
// //                         Text(name),
// //                         Text(
// //                           snapshot.data!.isOnline ? 'online' : 'offline',
// //                           style: const TextStyle(
// //                             fontSize: 13,
// //                             fontWeight: FontWeight.normal,
// //                           ),
// //                         ),
// //                       ],
// //                     );
// //                   }),
// //           centerTitle: false,
// //           actions: [
// //             IconButton(
// //               onPressed: () => makeCall(ref, context),
// //               icon: const Icon(Icons.video_call),
// //             ),
// //             IconButton(
// //               onPressed: () {},
// //               icon: const Icon(Icons.call),
// //             ),
// //             IconButton(
// //               onPressed: () {},
// //               icon: const Icon(Icons.more_vert),
// //             ),
// //           ],
// //         ),
// //         body: Column(
// //           children: [
// //             Expanded(
// //               child: ChatList(
// //                 recieverUserId: uid,
// //                 isGroupChat: isGroupChat,
// //               ),
// //             ),
// //             BottomChatField(
// //               recieverUserId: uid,
// //               isGroupChat: isGroupChat,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
