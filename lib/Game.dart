
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'main.dart';

class Game {
  String id = "";

  String startTime = "";
  String endTime = "";

  bool gameType = true;
  bool gameMode = true;
  bool completed = false;

  int repetition = 0;

  List<Map<String, int>> buttonList = [];

  int totalClick = 0;
  int righClick = 0;

  Game();

  String toDebug() {
    var debugInfo = "";

    debugInfo = "ID: ${id}\n"
        "startAt: ${startTime}\n"
        "endAt: ${endTime}\n"
        "gameType: ${gameType}\n"
        "gameMode: ${gameMode}\n"
        "completed: ${completed}\n"
        "repetition: ${repetition}";

    return debugInfo;
  }

  String toShare() {
    String type = (gameType == true) ? "number in order" : "matching numbers";
    var complete = (completed == true) ? "" : "not";

    var buttonClickStr = "{";
    for (var click in buttonList) {
      var time = "${click.keys}";
      var button = "${click.values}";
      buttonClickStr += "${time} : ${button}, ";
    }
    buttonClickStr += "}";

    var prescribed = (gameType == true) ? ", Total press of buttons: ${totalClick}, " +
    "correct press of buttons: ${righClick}, The button list: ${buttonClickStr}" : "";


    return "Exercise: ${type}, ${complete} completed, Start at ${startTime}, End at ${endTime}, " +
    "${repetition} round(s) in total${prescribed}";
  }

  String toSummary(bool _isRound, bool _isFree, bool _completed) {
    var head = (_completed == true) ? "Congratulations!\nYou have completed\n" : "We are almost there!\nYou have tried\n";
    var type = (gameType == true) ? "Number in order" : "Matchig Numbers";

    var extra = "";
    if (_isFree) {
      extra += "From: ${startTime}\nTo: ${endTime}\nWith ${repetition} round(s) in total";
    } else {
      if (_isRound) {
        extra += "From: ${startTime}\nTo: ${endTime}";
      } else {
        extra += "With ${repetition} round(s) in total";
      }
    }

    return "${head}${type} exercise\n${extra}";
  }

  Game.fromJson(Map<String, dynamic> json, String docID)
    :
      id = docID,
      startTime = json['startTime'],
      endTime = json['endTime'],
      gameType = json['gameType'],
      gameMode = json['gameMode'],
      completed = json['completed'],
      repetition = json['repetition']
      {
        buttonList = [];
        (json['buttonList']).forEach((element) {
          buttonList.add(Map.from(element));
        });

        totalClick = 0;
        righClick = 0;
        for (var clicks in buttonList) {
          totalClick++;
          if (!(clicks.values.contains(10) || clicks.values.contains(20) ||
              clicks.values.contains(30) || clicks.values.contains(40) ||
              clicks.values.contains(50))) {
            righClick++;
          }
        }
      }

  Map<String, dynamic> toJson() =>
      {
        'startTime': startTime,
        'endTime': endTime,
        'gameType': gameType,
        'gameMode': gameMode,
        'repetition': repetition,
        'completed': completed
      };
}

class GameModel extends ChangeNotifier {
  List<Game> gameList = [];
  List<Game> subList = [];

  int prescribedTotal = 0;
  int designedTotal = 0;

  bool loading = false;

  CollectionReference db = FirebaseFirestore.instance.collection(DATABASE);

  GameModel() {
    fetch();
    fetchDisplay(true, "");
  }

  Future fetch() async {
    gameList.clear();
    loading = true;

    prescribedTotal = 0;
    designedTotal = 0;

    notifyListeners();

    var gameDoc = await db.get();

    gameDoc.docs.forEach((doc) {
      var game = Game.fromJson(doc.data()! as Map<String, dynamic>, doc.id);

      var repetition = game.repetition;

      if (game.gameType == true) {
        prescribedTotal += repetition;
      } else {
        designedTotal += repetition;
      }

      gameList.add(game);
    });

    await Future.delayed(Duration(milliseconds: 1000));

    loading = false;

    notifyListeners();
  }

  Future fetchDisplay(bool gameType, String searchStr) async {
    subList.clear();
    loading = true;

    notifyListeners();

    var gameDoc = await db.get();

    gameDoc.docs.forEach((doc) {
      var game = Game.fromJson(doc.data()! as Map<String, dynamic>, doc.id);

      if (game.gameType == gameType && game.id.contains(searchStr)) {
        print(game.id);
        subList.add(game);
      }
    });

    await Future.delayed(Duration(milliseconds: 1000));

    loading = false;

    notifyListeners();
  }

  Future delete(String id) async {
    await db.doc(id).delete();
    await Future.delayed(Duration(milliseconds: 1000));
  }
}


