import 'package:flutter/material.dart';

class DmRoomScreen extends StatefulWidget {
  const DmRoomScreen({Key? key, required this.title}) : super(key: key);

  static const String routeName = "dm/room";
  static const String routeURL = "/dm/room";

  final String title;

  @override
  State<DmRoomScreen> createState() => _DmRoomScreenState();
}

class _DmRoomScreenState extends State<DmRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text("DmRoomScreen")));
  }
}
