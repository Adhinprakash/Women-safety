import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_saftey/controller/live_save_controller.dart';
import 'package:women_saftey/widgets/home_widgets/life_save/bus_station_card.dart';
import 'package:women_saftey/widgets/home_widgets/life_save/hospital_card.dart';
import 'package:women_saftey/widgets/home_widgets/life_save/pharmacyCard.dart';
import 'package:women_saftey/widgets/home_widgets/life_save/policestationCard.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({Key? key}) : super(key: key);

  


  @override
  Widget build(BuildContext context) {
    LiveSaveController liveSaveController=Get.put(LiveSaveController()); 
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStationCard(onMapFunction: () => liveSaveController.openMap("Police Station"),),
          HospitalCard(onMapFunction:()=> liveSaveController.openMap("Hospitals near me'"),),
          PharmacyCard(onMapFunction: ()=>liveSaveController.openMap("pharmacies near me"),),
          BusStationCard(onMapFunction: ()=>liveSaveController.openMap("bus stops near me"),),
        ],
      ),
    );
  }
}