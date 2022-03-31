
import 'package:flutter/cupertino.dart';

class Game {
  String id = "";

  String startTime = "";
  String endTime = "";

  bool gameType = true;
  bool gameMode = true;
  bool completed = false;

  int repetition = 0;

  //List<Map<String, int>?> buttonList = [];

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
      repetition = json['repetition'];

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


}


