import 'package:flutter/material.dart';

class ParentHome extends StatelessWidget {
  const ParentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(child: Text("Parent Home"),),
    ));
  }
}