import 'package:college_chancer/screens/ChanceCalculator.dart';
import 'package:college_chancer/structures/Person.dart';
import 'package:college_chancer/widget/SubMenuCard.dart';
import 'package:college_chancer/widget/bottomLeft.dart';
import 'package:college_chancer/widget/loadingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:search_page/search_page.dart';
import 'package:super_tooltip/super_tooltip.dart';
import '../structures/Colleges.dart';
import 'package:flutter/widgets.dart';
import "package:os_detect/os_detect.dart" as Platform;
import 'package:college_chancer/structures/DataStorage.dart';
import 'AboutTheApp.dart';

class CollegeList extends StatefulWidget {
  @override
  CollegeList({Key? key}) : super(key: key);

  @override
  _CollegeListState createState() => _CollegeListState();
}

class _CollegeListState extends State<CollegeList> {
  _CollegeListState();

  static late final List<College> _saved;
  bool stateUpdated = false;
  final _suggestions = <College>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  static bool csvLoaded = false;
  static bool searching = false;
  static bool storageLoaded = false;

  static List<College> _data = [];

  static late SearchPage searcher;

  get key => key;


  // This function is triggered when the floating button is pressed
  void _loadCSV() async {
    if (!csvLoaded) {
      final _rawData = await rootBundle.loadString("assets/collegeData.csv");
      List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
      for (int entry = 1; entry < _listData.length; entry++) {
        Storage.platformOffset=entry-_listData[entry][0] as int;
        _data.add(College(_listData[entry]));
      }
    }
    setState(() {
      csvLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    searcher = SearchPage<dynamic>(
      items: _data,
      searchLabel: 'Search Colleges',
      suggestion: Center(
        child: Text(
          'Filter by College name or State',
          style: _biggerFont,
        ),
      ),
      failure: Center(
        child: Text('No College found :('),
      ),
      filter: (college) => [
        college.name,
        college.state,
      ],
      builder: (college) => _buildRow(college),
    );
  }

  Future<void> getCollegesFromStorage() async{
    _saved = await Storage.getCollegesFromStorage(_data);

    if(!await Storage.getPersonFromStorage()) {
      Person.setPerson(1100, 20, -1, 3.00);
      Storage.savePersonToStorage(Person());
    }
    else{
      Storage.getPersonFromStorage();
    }

    setState(() {
      storageLoaded = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    _loadCSV();
    return Scaffold(
        appBar: AppBar(
          title: Text("College Selector"),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        drawer: NavBar(),
        body: _buildSuggestions(),
        floatingActionButton: bottomLeft(
          FloatingActionButton(
            child: Icon(Icons.search),
            tooltip: 'Search Colleges',
            onPressed: () => search(),
          ),
        ));
  }

  void search() {
    searching = true;
    showSearch(context: context, delegate: searcher);
  }

  Widget _buildSuggestions() {
    if (!csvLoaded ) {
      return Center(
        child: loadingPage("Colleges", _biggerFont),
      );
    }
    if(!storageLoaded){
      getCollegesFromStorage();
      return Center(
        child: loadingPage("Colleges", _biggerFont),
      );
    }

    return Scrollbar(
        isAlwaysShown: true,
        child: ListView.builder(
            itemCount: 4226,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return const Divider(); /*2*/

              final index = i ~/ 2; /*3*/
              if (index >= _suggestions.length) {
                _suggestions.addAll(getColleges(index)); /*4*/
              }

              return _buildRow(_suggestions[index]);
            })
    );
  }

  Widget _buildRow(College college) {
    final alreadySaved = _saved.contains(college);
    return GestureDetector(
      onSecondaryTap: () => handleSecondaryTap(context, college),
      child: ListTile(
        title: Text(
          college.name,
          style: _biggerFont,
        ),
        subtitle: Text(college.city + ", " + college.state),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : Colors.black45,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(college);
            } else {
              _saved.add(college);
            }
            Storage.saveCollegesToStorage(_saved);
            if (searching) {
              searching = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CollegeList()));
            }
          });
        },
        onLongPress: () => handleSecondaryTap(context, college),
      ),
    );
  }

  void handleSecondaryTap(BuildContext context, College college) {
    //toast("cum");

    String text = "Average SAT: " +
        (college.sat < 0 ? "Unknown" : college.sat.toString()) +
        "\n\n" +
        "Average ACT: " +
        (college.act < 0 ? "Unknown" : college.act.toString()) +
        "\n\n" +
        "Average GPA: " +
        (college.gpa < 0 ? "Unknown" : college.gpa.toStringAsPrecision(3)) +
        "\n\n" +
        "Test Scores: " +
        (college.applicationRequirements[0]) +
        "\n\n" +
        "High School GPA: " +
        (college.applicationRequirements[1]) +
        "\n\n" +
        "Acceptance Rate: " +
        (college.acceptanceRate < 0 ? "Unknown" : college.acceptanceRate.toString() + "%") +
        "\n\n" +
        "Open Admission: " +
        (college.isOpenAdmission ? "Yes" : "No") +
        "\n\n" +
        "Your chance: " +
        (college.getPercentChance(Person.gpa, Person.satScore*1.0, Person.actScore*1.0, Person.classRank)  < 0
            ? "Unknown"
            : (college.getPercentChance(Person.gpa, Person.satScore*1.0, Person.actScore*1.0, Person.classRank).toStringAsPrecision(3)) + "%") +
        "\n\n" +
        "Accepts AP Credits: " +
        (college.creditsAccepted[0] ? "Yes" : "No") +
        "\n\n" +
        "Accepts Dual Credits: " +
        (college.creditsAccepted[1] ? "Yes" : "No") +
        "\n\n" +
        "Accepts Life Experience Credits: " +
        (college.creditsAccepted[2] ? "Yes" : "No") +
        "\n\n" +
        "High School Class Rank: " +
        (college.applicationRequirements[2]) +
        "\n\n" +
        "Completion of College Preparatory Program: " +
        (college.applicationRequirements[3]) +
        "\n\n" +
        "Recommendations: " +
        (college.applicationRequirements[4]) +
        "\n\n" +
        "Demonstration of Competencies: " +
        (college.applicationRequirements[5]) +
        "\n\n";

    SuperTooltip tooltip = SuperTooltip(
      arrowTipDistance: 0.0,
      arrowLength: 0.0,
      popupDirection: TooltipDirection.down,
      minimumOutSidePadding: 5.0,
      borderColor: Colors.red,
      backgroundColor: Colors.redAccent,
      content: new Material(
        child: Platform.isAndroid
            ? Text(text)
            : GridView.count(
          crossAxisCount: 3,
          children: [
            SubMenuCard(width: 5, text: collegeFormatText(college)[0]),
            SubMenuCard(width: 5, text: collegeFormatText(college)[1]),
            SubMenuCard(width: 5, text: collegeFormatText(college)[2]),
          ],
        ),
      ),
    );

    tooltip.show(context);
  }

  List<String> collegeFormatText(College college) {
    String text = "Average SAT: " +
        (college.sat < 0 ? "Unknown" : college.sat.toString()) +
        "\n\n" +
        "Average ACT: " +
        (college.act < 0 ? "Unknown" : college.act.toString()) +
        "\n\n" +
        "Average GPA: " +
        (college.gpa < 0 ? "Unknown" : college.gpa.toStringAsPrecision(3)) +
        "\n\n" +
        "Test Scores: " +
        (college.applicationRequirements[0]) +
        "\n\n" +
        "High School GPA: " +
        (college.applicationRequirements[1]) +
        "\n\n";
    List<String> info = [];
    info.add(text);
    text = "Acceptance Rate: " +
        (college.acceptanceRate < 0 ? "Unknown" : college.acceptanceRate.toString() + "%") +
        "\n\n" +
        "Open Admission: " +
        (college.isOpenAdmission ? "Yes" : "No") +
        "\n\n" +
        "Your chance: " +
        (college.getPercentChance(Person.gpa, Person.satScore*1.0, Person.actScore*1.0, Person.classRank)  < 0
            ? "Unknown"
            : (college.getPercentChance(Person.gpa, Person.satScore*1.0, Person.actScore*1.0, Person.classRank).toStringAsPrecision(3)) + "%") +
        "\n\n" +
        "Accepts AP Credits: " +
        (college.creditsAccepted[0] ? "Yes" : "No") +
        "\n\n" +
        "Accepts Dual Credits: " +
        (college.creditsAccepted[1] ? "Yes" : "No") +
        "\n\n" +
        "Accepts Life Experience Credits: " +
        (college.creditsAccepted[2] ? "Yes" : "No") +
        "\n\n";
    info.add(text);
    text = "High School Class Rank: " +
        (college.applicationRequirements[2]) +
        "\n\n" +
        "Completion of College Preparatory Program: " +
        (college.applicationRequirements[3]) +
        "\n\n" +
        "Recommendations: " +
        (college.applicationRequirements[4]) +
        "\n\n" +
        "Demonstration of Competencies: " +
        (college.applicationRequirements[5]) +
        "\n\n";
    info.add(text);

    return info;
  }

  Iterable<College> getColleges(int startingIndex, {int ammount = 10}) {
    if((startingIndex + ammount + 1) > _data.length){
      ammount = _data.length - startingIndex - 2 < 0 ? 0 : _data.length - startingIndex - 2;
    }
    return _data.getRange(
        startingIndex + 1, startingIndex + ammount + 1); // +1 was done to remove geaders
  }

  void updateList(College college) {
    stateUpdated = true;
    setState(() {
      _saved.remove(college);
      Storage.saveCollegesToStorage(_saved);
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.push(context,MaterialPageRoute(builder: (context) => CollegeList()));
    return false;
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map(
              (College college) {
            return WillPopScope(
                onWillPop: () => _onWillPop(context),
                child:ListTile(
                  title: GestureDetector(
                    onTap: () => handleSecondaryTap(context, college),
                      onSecondaryTap: ()=>handleSecondaryTap(context, college),
                      child: Text(
                    college.name,
                    style: _biggerFont,
                  )
                  ),
                  trailing: GestureDetector(
                      child:Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                      ),
                      onTap:(){
                        updateList(college);
                        if(_saved.isEmpty) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CollegeList()));
                        }else {
                          _pushSaved();
                        }
                      }
                  ),

                  subtitle: new Text(("Acceptance Chance: " +
                      (college.getPercentChance(Person.gpa, Person.satScore * 1.0, Person.actScore * 1.0,
                          Person.classRank) >
                          0
                          ? college.getPercentChance(
                          Person.gpa, Person.satScore * 1.0, Person.actScore * 1.0, Person.classRank)
                          : 0)
                          .toStringAsPrecision(3) +
                      "%")
                  ),
                ));
          },
        );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(context: context, tiles: tiles).toList()
            : <Widget>[];

        return Scaffold(
            appBar: AppBar(
              title: Text('Saved Colleges'),
            ),
            body: ListView(children: divided),
            floatingActionButton: bottomLeft(
              FloatingActionButton(
                child: Icon(Icons.info),
                tooltip: 'See Total Chances',
                //Make a checker
                onPressed: () => _goToChanceCalculator(),
              ),
            )
        );
      },
    ));
  }

  void _goToChanceCalculator() {
    if(_saved.length != 0) {
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ChanceCalculator(colleges: _saved, key: UniqueKey());
        },
      ));
    }
  }

}