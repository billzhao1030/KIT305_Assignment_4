
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

        //print(buttonList.runtimeType);
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
  final List<Game> gameList = [];
  int prescribedTotal = 0;
  int designedTotal = 0;

  bool loading = false;

  CollectionReference db = FirebaseFirestore.instance.collection(DATABASE);

  GameModel() {
    fetch();
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

    await Future.delayed(Duration(seconds: 1));

    loading = false;

    notifyListeners();
  }
}


