import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women_saftey/components/fab_bar_button.dart';
import 'package:women_saftey/view/child/bottom_pages/add_contact_page.dart';
import 'package:women_saftey/view/child/bottom_pages/chat_page.dart';
import 'package:women_saftey/view/child/bottom_pages/contact_page.dart';
import 'package:women_saftey/view/child/bottom_pages/home_screen.dart';
import 'package:women_saftey/view/child/bottom_pages/profile_page.dart';
import 'package:women_saftey/view/child/bottom_pages/review_page.dart';

class Bottompage extends StatefulWidget {
  const Bottompage({super.key});

  @override
  State<Bottompage> createState() => _BottompageState();
}

class _BottompageState extends State<Bottompage> {
    int currentIndex = 0;

  List<Widget> pages = [
    HomeScreen(),
    AddContactPage(),
    ChatPage(),
    ProfilePage(),
    ReviewPage(),
  ]; 

    onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
    Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: DefaultTabController(
          initialIndex: currentIndex,
          length: pages.length,
          child: Scaffold(
              body: pages[currentIndex],
              bottomNavigationBar: FABBottomAppBar(
                onTabSelected: onTapped,
                items: [
                  FABBottomAppBarItem(iconData: Icons.home, text: "home"),
                  FABBottomAppBarItem(
                      iconData: Icons.contacts, text: "contacts"),
                  FABBottomAppBarItem(iconData: Icons.chat, text: "chat"),
                  FABBottomAppBarItem(
                      iconData: Icons.rate_review, text: "Ratings"),
                  FABBottomAppBarItem(
                      iconData: Icons.settings, text: "Settings"),
                ],
              )),
        ));
  }
}