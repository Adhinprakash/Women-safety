import 'dart:math';

import 'package:flutter/material.dart';
import 'package:women_saftey/controller/login_child_controller.dart';
import 'package:women_saftey/utils/quotes.dart';
import 'package:women_saftey/widgets/home_widgets/curosel_widget.dart';
import 'package:women_saftey/widgets/home_widgets/emergency.dart';
import 'package:women_saftey/widgets/home_widgets/live_safe.dart';
import 'package:women_saftey/widgets/home_widgets/safehome/safe_home.dart';
import '../../../widgets/home_widgets/custom_appbar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int quoteIndex = 0;

  getrandomQuote() {
    setState(() {
      quoteIndex = Random().nextInt(sweetSayings.length);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              quoteIndex: quoteIndex,
              onTap: () {
                getrandomQuote();
              },
            ),
            Expanded(child: ListView(
              shrinkWrap: true,
              children: [
                CustomCarouel(),
                const Padding(padding: 
                EdgeInsets.all(8),
                child: Text("Emergency",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Emergency(),

                Padding(padding: 
                EdgeInsets.all(8.0),
                child: Text('Explore Livesafe',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                LiveSafe(),
                SafeHome(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}