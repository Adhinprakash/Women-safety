import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_saftey/bindings.dart';
import 'package:women_saftey/controller/login_child_controller.dart';
import 'package:women_saftey/db/sharedprefereces.dart';
import 'package:women_saftey/firebase_options.dart';
import 'package:women_saftey/services/background_service.dart';
import 'package:women_saftey/utils/consts.dart';
import 'package:women_saftey/view/child/bottom_page.dart';
import 'package:women_saftey/view/child/register_child.dart';
import 'package:women_saftey/view/child/bottom_pages/home_screen.dart';
import 'package:women_saftey/view/child/login_child_screen.dart';
import 'package:women_saftey/view/prarent/parent_home.dart';
import 'package:women_saftey/view/prarent/register_parent_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await MySharedPrefference.init();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: "/loginChild",
        initialBinding: LocationBinding(),
        getPages: [
          GetPage(
              name: '/loginChild',
              page: () => LoginChildScreen(),
              binding: BindingsBuilder(() => LoginChildController())),
          GetPage(
            name: '/Home',
            page: () => HomeScreen(),
          ),
          GetPage(name: '/registerChild', page: () => const RegisterChild()),
          GetPage(
              name: '/registerParent', page: () => const RegisterParentPage()),
          GetPage(name: '/parentHome', page: () => const ParentHome()),
          GetPage(name: '/bottompage', page: () => const Bottompage())
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.firaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
            future: MySharedPrefference.getUserType(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == '') {
                return const LoginChildScreen();
              }
              if (snapshot.data == 'parent') {
                return const ParentHome();
              }
              if (snapshot.data == 'child') {
                return const Bottompage();
              }
              return progressIndicator(context);
            }));
  }
}
