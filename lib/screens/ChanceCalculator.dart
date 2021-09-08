import 'dart:math';
import 'dart:ui';

import 'package:another_xlider/another_xlider.dart';
import 'package:college_chancer/screens/CollegeList.dart';
import 'package:college_chancer/structures/DataStorage.dart';
import 'package:college_chancer/structures/Person.dart';
import 'package:college_chancer/widget/loadingPage.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../structures/Colleges.dart';

class ChanceCalculator extends StatefulWidget {
  const ChanceCalculator({Key? key, required List<College> this.colleges}) : super(key: key);

  final List<College> colleges;

  List<College> getColleges(){return colleges;}

  @override
  _ChanceCalculatorState createState() => _ChanceCalculatorState(colleges);
}

class _ChanceCalculatorState extends State<ChanceCalculator> {
  late List<College> colleges;
  bool dataLoaded = false;
  final _biggerFont = const TextStyle(fontSize: 18.0);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPersonFromStorage();
  }

   Future<void> getPersonFromStorage() async{
    if(!await Storage.getPersonFromStorage()) {
      Person.setPerson(1100, 20, -1, 3.00);
      Storage.savePersonToStorage(Person());
    }
    else{
      Storage.getPersonFromStorage();
    }
    setState(() {
      dataLoaded = true;
    });
  }

  _ChanceCalculatorState(this.colleges){
    this.colleges =colleges;
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          title: const Text('Chances of Getting Accepted to 1 College'),
        ),
        body: buildBody());
  }

  Widget buildBody(){

    print(dataLoaded);
    if (!dataLoaded) {
      return Center(
        child:loadingPage("Calculating Chances", _biggerFont),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: 220,
                  customWidths: CustomSliderWidths(progressBarWidth: 15),
                  animationEnabled: true,
                  customColors: CustomSliderColors(progressBarColors: [
                    Colors.green,
                    Colors.red[100]!,
                    Colors.red[200]!,
                    Colors.red[300]!,
                    Colors.red[400]!,
                  ]),
                ),
                min: 0,
                max: 100,
                initialValue: College.getTotalChance(colleges) * 100,
              ),
            ),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("SAT Score: " +
                  ((Person.satScore < 400) ? "Unknown" : Person.satScore.toString())),
              FlutterSlider(
                values: [Person.satScore.toDouble()],
                step: FlutterSliderStep(step: 10.0),
                max: 1600,
                min: 390,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  Person.satScore = lowerValue.toInt();
                  Storage.savePersonToStorage(Person());
                  setState(() {
                  });
                },
              )
            ]),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("ACT Score: " +
                  ((Person.actScore < 1) ? "Unknown" : Person.actScore.toString())),
              FlutterSlider(
                values: [Person.actScore.toDouble()],
                step: FlutterSliderStep(step: 1.0),
                max: 36,
                min: 0,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  Person.actScore = lowerValue.toInt();
                  Storage.savePersonToStorage(Person());
                  setState(() {
                  });
                },
              )
            ]),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("GPA: " + ((Person.gpa < 0) ? "Unknown" : Person.gpa.toString())),
              FlutterSlider(
                values: [Person.gpa],
                step: FlutterSliderStep(step: 0.05),
                max: 4,
                min: -0.05,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  Person.gpa = lowerValue;
                  Storage.savePersonToStorage(Person());
                  setState(() {
                  });
                },
              )
            ]),
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Class Rank: " + Person.classRankMeaning[Person.classRank + 1]),
              FlutterSlider(
                values: [Person.classRank.toDouble() + 1],
                step: FlutterSliderStep(step: 1.0),
                max: 5,
                min: 0,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  Person.classRank = lowerValue.toInt() - 1;
                  Storage.savePersonToStorage(Person());
                  setState(() {
                  });
                },
              )
            ]),
          ),
        ]),
      ),
    );
  }




}
