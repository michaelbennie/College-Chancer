import 'package:college_chancer/structures/Colleges.dart';
import 'package:college_chancer/structures/Person.dart';
import 'package:college_chancer/widget/SubMenuCard.dart';
import 'package:college_chancer/widget/bottomLeft.dart';
import 'package:college_chancer/widget/loadingPage.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
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
import 'MainMenu.dart';

class AboutTheApp extends StatefulWidget {
  @override

  AboutTheApp({Key? key}) : super(key: key);

  @override
  AboutTheAppState createState() => AboutTheAppState();

//<a href="https://www.freepik.com/vectors/banner">Banner vector created by vectorpocket - www.freepik.com</a>

}

class AboutTheAppState extends State<AboutTheApp> {
  AboutTheAppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('About the app'),
            ),
          ),
      body: Center(
        child: Image.asset((
            'Capture.PNG'),
          width:  MediaQuery.of(context).size.width,
          height:  MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
      ),
        );//drawer: NavBar(),
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
                      'studentphoto.png'),
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: new ExactAssetImage(
                      'college-building-educational-institution-banner_1441-3616.jpg'),
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

