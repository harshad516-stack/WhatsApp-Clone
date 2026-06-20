import 'package:flutter/material.dart';
// import 'package:story_view/story_view.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;

  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.status.photoUrl.isEmpty) {
      return const Scaffold(
        body: Loader(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.status.username),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(
          widget.status.photoUrl[currentIndex],
          fit: BoxFit.contain,
        ),
      ),

      // 👉 Tap to change status image (basic functionality)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (currentIndex < widget.status.photoUrl.length - 1) {
              currentIndex++;
            } else {
              Navigator.pop(context);
            }
          });
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}