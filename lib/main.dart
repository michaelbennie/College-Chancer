import 'package:college_chancer/screens/MainMenu.dart';
import 'package:college_chancer/structures/Person.dart';
import 'package:college_chancer/web/fakeWebHandler.dart';

export ""
    if (dart.library.js) 'package:college_chancer/web/WebHandler.dart'
    if (dart.library.io) 'package:college_chancer/web/fakeWebHandler.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
//app icon from
//<a href="https://www.vecteezy.com/free-vector/ornament">Ornament Vectors by Vecteezy</a>
//<a href="https://www.freepik.com/vectors/banner">Banner vector created by vectorpocket - www.freepik.com</a>
//https://icon-library.com/icon/student-icon-png-26.html.html>Student Icon Png # 282326
//

/*
*
* remember to change star_menu gesture detector with this
                    GestureDetector(
                    onLongPress: () {
                      // this optional check is to just not call closeMenu() if an
                      // item without an onTap event is tapped. Else the
                      // tap is on background and the menu must be closed
                      if (!(menuState == MenuState.closing ||
                          menuState == MenuState.closed)) closeMenu();
                    },
                    onSecondaryTap: () {
                      // this optional check is to just not call closeMenu() if an
                      // item without an onTap event is tapped. Else the
                      // tap is on background and the menu must be closed
                      if (!(menuState == MenuState.closing ||
                          menuState == MenuState.closed)) closeMenu();
                    },
                  )

                   Widget build(BuildContext context) {
    return GestureDetector(
        onSecondaryTap: (event) => showMenu(),
        onLongPress: (event) => showMenu(), child: widget.child,
        child: widget.child
    );
  }

*
 */

void main() {
  WebHandler hander = WebHandler();
  hander.handleWeb();
  Person.setPerson(1480, 0, -1, 3.85);
  runApp(OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Chancer',
      theme: ThemeData(
        primaryColor: Colors.red[600],
      ),
      home: MainMenu(key: UniqueKey()), //CollegeList(key: UniqueKey()),
    );
  }
}
