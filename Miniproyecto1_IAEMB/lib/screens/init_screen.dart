import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_recognizer_nd/screens/home/home_screen.dart';
import 'package:tiny_recognizer_nd/screens/tutorials/tutorial_screen.dart';
// import 'package:shop_app/providers/providers.dart';
// import 'package:shop_app/components/init_app_bar.dart';
// import 'package:shop_app/utils/app_color.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends ConsumerStatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  InitScreenState createState() => InitScreenState();
}

class InitScreenState extends ConsumerState<InitScreen> {
  
  int currentSelectedIndex = 0;
  PageController page = PageController();

  void updateCurrentIndex(int index) {
    setState(() {
      page.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  final pages = <Widget>[
    HomeScreen(),
    TutorialScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // AppColor appColor = ref.watch(AppColorProvider);
    return Scaffold(
            // appBar: AppBar(
            //   bottom: const PreferredSize(preferredSize: Size.fromHeight(5), child: InitAppBar()),
            // ),
            body: PageView(
              children: pages,
              controller: page,
              onPageChanged: (value) => setState(()=>currentSelectedIndex=value),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: updateCurrentIndex,
              currentIndex: currentSelectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.bluetooth_searching_outlined, color: Colors.grey, size: 25),
                  activeIcon: Icon(Icons.bluetooth_searching, color: Colors.black, size: 30),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline, color: Colors.grey, size: 25),
                  activeIcon: Icon(Icons.info_rounded, color: Colors.black, size: 30),
                  label: "Tutoriales",
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.groups_outlined, color: appColor.primary, size: 25),
                //   activeIcon: Icon(Icons.groups, color: appColor.primary, size: 30),
                //   label: "People",
                // ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.handyman_outlined, color: appColor.primary, size: 25),
                //   activeIcon: Icon(Icons.handyman, color: appColor.primary, size: 30),
                //   label: "Account",
                // ),
              ],
            ),
          );
  }
}
