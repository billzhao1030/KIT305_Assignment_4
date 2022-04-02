import 'package:assignment4/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class GamePage extends StatefulWidget {
  final bool gameType;
  final bool gameMode;
  final bool isFree;
  final bool isRound;

  final int buttonNum;
  final bool isRandom;
  final bool hasIndication;
  final int buttonSize;

  final int round;
  final int time;

  const GamePage({
    Key? key,
    required this.gameType,
    required this.gameMode,
    required this.isFree,
    required this.isRound,
    required this.buttonNum,
    required this.isRandom,
    required this.hasIndication,
    required this.buttonSize,
    required this.round,
    required this.time
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  CollectionReference db = FirebaseFirestore.instance.collection(DATABASE);
  var id = "";
  var repetition = 0;
  var completed = false;
  var startTime = "";
  var endTime = "";

  var completedRound = 0;
  var btnNow = 1;
  var timeLeft = 0;
  var progressText = "";
  var gameRule = "";

  var buttonList = [];
  var buttonSize = 2;

  DateFormat dateFormatID = DateFormat("yyyyMMddHHmmss");
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  @override
  void initState() {
    super.initState();

    presetGame();

    debugResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Nice"),
    );
  }

  void debugResult() {
    print("=====");
    print("gameType ${widget.gameType}");
    print("gameMode ${widget.gameMode}");
    print("isFree ${widget.isFree}");
    print("isRound ${widget.isRound}");

    print("round ${widget.round}");
    print("time ${widget.time}");

    print("buttonNum ${widget.buttonNum}");
    print("isRandom ${widget.isRandom}");
    print("hasIndication ${widget.hasIndication}");
    print("buttonSize ${widget.buttonSize}");
  }

  void uploadRound() async {
    db.doc(id).update({
      'repetition': completedRound,
      'endTime': dateFormat.format(DateTime.now())
    })
    .then((value) => print("Game updated"))
    .catchError((error) => print("Failed to update game: ${error}"));
  }

  void uploadButtonList() async {
    db.doc(id).update({
      'buttonList': buttonList,
      'endTime': dateFormat.format(DateTime.now())
    })
    .then((value) => print("Game updated"))
    .catchError((error) => print("Failed to update game: ${error}"));
  }

  void gameInitiateDatabase() async {
    id = dateFormatID.format(DateTime.now());
    endTime = startTime = dateFormat.format(DateTime.now());
    print(id);

    db.doc(id).set({
      'completed': completed,
      'buttonList': buttonList,
      'gameType': widget.gameType,
      'gameMode': widget.gameMode,
      'repetition': repetition,
      'startTime': startTime,
      'endTime': endTime
    })
    .then((value) => print("Game added"))
    .catchError((error) => print("Failed to add game: ${error}"));
  }

  void presetGame() {
    if (widget.gameType == true) {
      buttonSize = widget.buttonSize * 2;
      print("size ${buttonSize}");

      gameRule = "Tap the button in number order (from 1)";

      if (widget.gameMode == true) {
        if (widget.round != -1) {

        } else {

        }
      } else {

      }
    } else {

    }

    //gameInitiateDatabase();
  }
}
