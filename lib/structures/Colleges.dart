import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'Person.dart';

class College {
  late final String name, state, city;
  late final double gpa, gpaStandardDeviation;
  late final double acceptanceRate;
  late final int sat;
  late final satRange = <int>[];
  late final satRanks = <int>[];
  late final int act;
  late final actRange = <int>[];
  late final actRanks = <int>[];
  late final double classRankMean, classRankStandardDeviation ;
  late final satRankLevel = <int>[];
  late final actRankLevel = <int>[];
  late final bool isOpenAdmission, hasData;
  late final applicationRequirements = <String>[];
  late final creditsAccepted = <bool>[];
  late final int index;

  late final List<dynamic> storedData;
  bool hasLoaded = false;


  static const classRankMidPointsOfRange = <double>[(100+100.0-10.0)/2,
    (100.0-10.0+100.0-25.0)/2,
    (100.0-25.0+100.0-50.0)/2,
    (50.0+25.0)/2,
    (25.0+0.0)/2,
  ];

  static const GPAMidPointsOfRange = <double>[
    (4.00+3.75)/2,
    (3.75+3.50)/2,
    (3.50+3.25)/2,
    (3.25+3.00)/2,
    (3.00+2.75)/2,
    (2.75+2.50)/2,
    (2.50+2.25)/2,
    (2.25+2.00)/2,
  ];

  College(List<dynamic> csvLine) {
    this.index = safeConvertInt(csvLine[0]-1);
    this.name = csvLine[1];
    this.state = csvLine[2];
    this.city = csvLine[3];
    this.isOpenAdmission = csvLine[4] == "True" ? true : false;
    this.hasData = csvLine[5] == "True" ? true : false;

    this.gpa = safeConvertDouble(csvLine[6]);
    this.gpaStandardDeviation = safeConvertDouble(csvLine[7]);
    this.acceptanceRate = safeConvertDouble(csvLine[8]);
    this.sat = safeConvertInt(csvLine[15]);
    this.act = safeConvertInt(csvLine[27]);
    storedData = csvLine;

    for (int i = 43; i <= 48; i++) {
      applicationRequirements.add(storedData[i]);
    }

    for (int i = 49; i <= 51; i++) {
      creditsAccepted.add((storedData[i]) == "Yes" ? true : false);
    }
    loadInBackground();
  }

  //used to load less important things in the background
  //run this when there is free time
  void loadInBackground() async {
    if (!hasLoaded) {
      hasLoaded = true;
      for (int i = 9; i <= 14; i++) {
        satRange.add(safeConvertInt(storedData[i]));
      }
      for (int i = 16; i <= 20; i++) {
        satRanks.add(safeConvertInt(storedData[i]));
      }

      for (int i = 21; i <= 26; i++) {
        actRange.add(safeConvertInt(storedData[i]));
      }

      for (int i = 28; i <= 32; i++) {
        actRanks.add(safeConvertInt(storedData[i]));
      }

      classRankMean = safeConvertDouble(storedData[33]);
      classRankStandardDeviation = safeConvertDouble(storedData[34]);

      for (int i = 35; i <= 38; i++) {
        satRankLevel.add(safeConvertInt(storedData[i]));
      }
      for (int i = 39; i <= 42; i++) {
        actRankLevel.add(safeConvertInt(storedData[i]));
      }
    }
  }





  int safeConvertInt(dynamic integer) {
    return (integer == "N/A" || integer == "N" || integer == "N/") ? -1 : integer;
  }

  double safeConvertDouble(dynamic doubleNum) {
    return (doubleNum.toString() == "N/A" ||
            doubleNum.toString() == "N" ||
            doubleNum.toString() == "N/")
        ? -1.0
        : 1.0 * doubleNum;
  }

  /* math area
  * sat and act are calculated seperately and whichever is better should be used
  * what we get from the user: sat score and/or act score, gpa, class rank
  *  if the college does not have detailed records then we extrapolate with just use average
  * if there is no data then the user will have to input the average score
  * output: percent chance
   */

  //I wrote alot but honestly i have not checked this and i feel to tired to do so
  //for the past 5 days i worked on this 10 hours each day

  // class rank is a int where 5 is bottom 25% and 1 is top 10%
  double getPercentChance(double personGPA, double sat, double act, int classRank) {
    loadInBackground();
    if (isOpenAdmission || !hasData || (sat == -1 && act == -1)) {
      return acceptanceRate>0 ? acceptanceRate : 42.0;
    }

    double satChance = satPercentChance(sat);
    double actChance = actPercentChance(act);

    if ((satChance > 0 && satChance > actChance) || actChance.isNaN) {
      if (satChance * gpaPercentChance(personGPA) * classRankPercentChance(classRank) > 98) {
        return 98.0;
      }
      return satChance * gpaPercentChance(personGPA) * classRankPercentChance(classRank);
    }
    if (actChance > 0) {
      if (actChance * gpaPercentChance(personGPA) * classRankPercentChance(classRank) > 98) {
        return 98.0;
      }
      return actChance * gpaPercentChance(personGPA) * classRankPercentChance(classRank);
    }
    return acceptanceRate < 0 ? 0 : acceptanceRate;
  }

  // gpa and class rank assume the data is a bell curve and ignores results within one standard dev

  // punishments are stronger than rewards due to being cautious


  //basically a worse classRank
  double gpaPercentChance(double personGPA) {
    if (gpa < 0) {
      return 1.0;
    }

    double competiveness = (personGPA - gpa)/gpaStandardDeviation;

    double chances = 100.0;


    if (competiveness>1) {
      chances += exp(competiveness-2);
    }
    else if (competiveness < -1){
      chances -= 2*exp(-1*competiveness-2);
    }

    if (chances<10){
      chances =10.0;
    }
    return chances/100;
  }

  double classRankPercentChance(int classRank) {
    if (classRank < 0 || classRankMean< 0) {
      return 1.0;
    }
    double competitiveness = 0;


    //please make this a switch case im dying very inefficient
    if (classRank == 4) {
      competitiveness += classRankMidPointsOfRange[4];
    }
    if (classRank == 3) {
      competitiveness += classRankMidPointsOfRange[3];
    }
    if (classRank == 2) {
      competitiveness += classRankMidPointsOfRange[2];
    }
    if (classRank == 1) {
      competitiveness += classRankMidPointsOfRange[1];
    }
    if (classRank == 0) {
      competitiveness += classRankMidPointsOfRange[0];
    }


    competitiveness -= classRankMean;
    competitiveness/= classRankStandardDeviation;

    print("Competitiveness: "+competitiveness.toString()+" sd:"+classRankStandardDeviation.toString()+" mean:"+classRankMean.toString());

    double chances = 100.0;
    if(competitiveness>4){
      chances += 7;
    }
    if(competitiveness>3){
      chances += 5;
    }
    if(competitiveness>2){
      chances += 3;
    }
    if(competitiveness>1){
      chances += 1;
    }
    if(competitiveness<-1){
      chances -= 2;
    }
    if(competitiveness<-2){
      chances -= 6;
    }
    if(competitiveness<-3){
      chances -= 10;
    }
    if(competitiveness<-4){
      chances -= 14;
    }
    if(competitiveness<-5){
      chances -= 18;
    }
    if(competitiveness<-6){
      chances -= 22;
    }
    if(competitiveness<-7){
      chances -= 26;
    }

    return chances / 100.0;
  }

  double calculateMean(List<double> means,List<int> fequencies, [int sampleNum = 100]){
    double total =0;
    for(int i =0; i< means.length;i++){
      total += means[i]*fequencies[i];
    }
    return total /sampleNum;
  }


  double caculateStandartDeviation(List<double> means,List<int> fequencies, double dataMean, [int sampleNum = 100]){
    double variance = calculateDataVariance(means, fequencies,  dataMean, sampleNum);
    return sqrt(variance);
  }

  double calculateDataVariance(List<double> means,List<int> fequencies, double dataMean, [int sampleNum = 100]){
    double total =0;
    for(int i =0; i< means.length;i++){
      total += means[i]*means[i]*fequencies[i];
    }
    return (total -sampleNum*dataMean*dataMean)/(sampleNum-1);
  }


  //we use linear regress ion to calculate sat and act chance
  //for the extremes, we use eponentiol to punsih and reward more
  double satPercentChance(double sat) {

    double slope = (satRanks[3] - satRanks [0])/(satRankLevel[3] -satRankLevel[0])*0.8 ;

    if(sat>satRankLevel[0]){
      return satRanks[0]*exp((sat/satRankLevel[0]-1)*0.3);
    }

    if(sat<satRankLevel[3]){
      return satRanks[3]*exp((sat/satRankLevel[3]-1)*2);
    }

    print(slope*(sat-satRankLevel[0])+satRanks[0] );
    return slope*(sat-satRankLevel[0])+satRanks[0] ;
  }

  double actPercentChance(double act) {

    double slope = (actRanks[3] - actRanks [0])/(actRankLevel[3] -actRankLevel[0])*0.8 ;

    if(act>actRankLevel[0]){
      return actRanks[0]*exp((act/actRankLevel[0]-1)*0.3);
    }

    if(act<actRankLevel[3]){
      return actRanks[3]*exp((act/actRankLevel[3]-1)*2);
    }

    print(slope*(act-actRankLevel[0])+actRanks[0] );
    return slope*(act-actRankLevel[0])+actRanks[0] ;
  }


  //idk if this is the lazy or smart way to do this
  Map toJSONEncodable() {
    Map m = new Map();
    m["index"] = index;
    return m;
  }

  static double getTotalChance(List<College> colleges) {
    if (colleges.isEmpty) {
      return -1.0;
    }
    print(Person.gpa);
    double chanceNotToHappen = 1 -
        colleges[0].getPercentChance(
            Person.gpa, Person.satScore * 1.0, Person.actScore * 1.0, Person.classRank) /
            100;
    print("Chance not to happen:"+chanceNotToHappen.toString());
    for (int i = 1; i < colleges.length; i++) {
      chanceNotToHappen *= (1 -
          colleges[i].getPercentChance(
              Person.gpa, Person.satScore * 1.0, Person.actScore * 1.0, Person.classRank) /
              100);

    }
    print(1-chanceNotToHappen);
    return 1 - chanceNotToHappen;
  }



}

class CollegeSerializer{
  static List toJSONEncodable(List<College> colleges){
    return colleges.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}