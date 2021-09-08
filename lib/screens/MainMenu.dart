import 'package:college_chancer/screens/AboutTheApp.dart';
import 'package:college_chancer/structures/Colleges.dart';
import 'package:college_chancer/structures/Person.dart';
import 'package:college_chancer/widget/SubMenuCard.dart';
import 'package:college_chancer/widget/bottomLeft.dart';
import 'package:college_chancer/widget/loadingPage.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:os_detect/os_detect.dart';
import 'package:os_detect/os_detect.dart';
import 'package:os_detect/os_detect.dart';
import 'package:os_detect/os_detect.dart';
import 'package:search_page/search_page.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'ChanceCalculator.dart';
import 'CollegeList.dart';
import 'CollegeList.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class MainMenu extends StatefulWidget {
  @override

  MainMenu({Key? key}) : super(key: key);

  @override
  MainMenuState createState() => MainMenuState();

  //<a href="https://www.freepik.com/vectors/banner">Banner vector created by vectorpocket - www.freepik.com</a>

}

class MainMenuState extends State<MainMenu> {
  MainMenuState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red[600],
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Oveview'),
            ),
          ),
          body: Scaffold(
            body: SingleChildScrollView(
              child: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [Text("WORK IN PROGRESS "),Text("GO TO COLEGES"),Text("V1.0"),],
                  ),
                ),
              ),
            ),
          ),
          drawer: NavBar(),
        )

    );
  }
}

class NavBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text(''),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset((
                    'assets/studentphoto.png'),
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new ExactAssetImage(
                    'assets/college-building-educational-institution-banner_1441-3616.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Colleges'),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => CollegeList()),
              );
            }
          ),
          /*
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CollegeList()),
                );
              }
          ),
           */
          /*
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CollegeList()),
                );
              }//search(),
          ),
           */
          ListTile(
              leading: Icon(Icons.work_outlined),
              title: Text('Home page'),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainMenu()),
                );
              }
          ),
          ListTile(
            leading: Icon(Icons.attach_file),
            title: Text('About the app'),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutTheApp()),
                );
              }
          ),
        ],
      )
    );
  }
}

