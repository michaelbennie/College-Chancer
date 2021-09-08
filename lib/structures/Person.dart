class Person {
  static late int satScore, actScore, classRank;
  static late double gpa;
  static const List<String> classRankMeaning = [
    "Unknown",
    "Top 10% of class",
    "Top 25% of class",
    "Top 50% of class",
    "Bottom 50% of class",
    "Bottom 25% of class"
  ];

  static setPerson(int satScore1, int actScore1, int classRank1, double gpa1) {
    satScore = satScore1;
    actScore = actScore1;
    classRank = classRank1;
    gpa = gpa1;
  }

  Map toJSONEncodable() {
    Map m  =new Map();
    m["satScore"] =satScore;
    m["actScore"] = actScore;
    m["classRank"] = classRank;
    m["gpa"] = gpa;
    return m;
  }

}
