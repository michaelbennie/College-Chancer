
import 'package:college_chancer/structures/Colleges.dart';
import 'package:college_chancer/structures/Person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';


class Storage{
   static late  final LocalStorage storage;
  static bool preferencesInited =false;
  static int platformOffset =0;

  static void initPreferences() {
    if(!preferencesInited) {
      storage = LocalStorage('data.json');
      preferencesInited =true;
    }
  }


  static Future<void> saveCollegesToStorage(List<College> savedColleges) async {
    initPreferences();
    await storage.ready;
    await storage.deleteItem("colleges");
    storage.setItem('colleges', CollegeSerializer.toJSONEncodable(savedColleges));
  }


  static Future<List<College>> getCollegesFromStorage(List<College> colleges) async{
    initPreferences();
    await storage.ready;
    List? data = storage.getItem("colleges");
    List<College> savedColleges = <College>[];
    if(data!=null){
      print(data);
      for(int i = 0;i <data.length;i++){
        savedColleges.add(colleges[data[i+platformOffset]["index"]]);
      }
    }
    return savedColleges;
  }



  static Future<void> savePersonToStorage(Person person) async {
    initPreferences();
    await storage.ready;
    storage.setItem('person', person.toJSONEncodable());
  }

  static Future<dynamic> clearStorage() async {
    initPreferences();
    await storage.ready;
    await storage.clear();

    return storage.getItem('person') ?? [];
  }

  static Future<bool> getPersonFromStorage() async{
    initPreferences();
    await storage.ready;
    var data = storage.getItem("person");
    if(data!=null){
      Map map = data;
      Person.setPerson(map["satScore"], map["actScore"], map["classRank"], map["gpa"]);
      return true;
    }
    return false;
  }



}