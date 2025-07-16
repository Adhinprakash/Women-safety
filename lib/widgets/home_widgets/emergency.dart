import 'package:flutter/material.dart';
import 'package:women_saftey/widgets/home_widgets/emergencies/police_emergency.dart';
import 'package:women_saftey/widgets/home_widgets/emergencies/ambulance_emergency.dart';
import 'package:women_saftey/widgets/home_widgets/emergencies/fire_force_emergency.dart';
import 'package:women_saftey/widgets/home_widgets/emergencies/army_emergency.dart';
class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 210,
    child: 
    ListView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: [
        PoliceEmergency(),
        AmbulanceEmergency(),
        FireForceEmergency(),
        ArmyEmergency(),
      ],
    ),
    );
  }
}