// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsapp_ui/common/utils/colors.dart';
// import 'package:whatsapp_ui/common/widgets/error.dart';
// import 'package:whatsapp_ui/common/widgets/loader.dart';
// import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
// import 'package:whatsapp_ui/features/landing/screens/landing_screen.dart';
// import 'package:whatsapp_ui/firebase_options.dart';
// import 'package:whatsapp_ui/router.dart';
// import 'package:whatsapp_ui/mobile_layout_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Whatsapp UI',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: backgroundColor,
//         appBarTheme: const AppBarTheme(
//           color: appBarColor,
//         ),
//       ),
//       onGenerateRoute: (settings) => generateRoute(settings),
//       home: ref.watch(userDataAuthProvider).when(
//             data: (user) {
//               if (user == null) {
//                 return const LandingScreen();
//               }
//               return const MobileLayoutScreen();
//             },
//             error: (err, trace) {
//               return ErrorScreen(
//                 error: err.toString(),
//               );
//             },
//             loading: () => const Loader(),
//           ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'common/utils/colors.dart';
import 'common/widgets/error.dart';
import 'common/widgets/loader.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/landing/screens/landing_screen.dart';
import 'mobile_layout_screen.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataAuthProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp UI',

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),

      onGenerateRoute: (settings) => generateRoute(settings),

      home: userAsync.when(
        data: (user) {
          if (user == null) {
            return const LandingScreen();
          } else {
            return const MobileLayoutScreen();
          }
        },
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        },
        loading: () => const Loader(),
      ),
    );
  }
}