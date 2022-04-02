
import 'dart:math';

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

  var xList = [];
  var yList = [];

  var finshOrMenu = "Go back to Menu";

  DateFormat dateFormatID = DateFormat("yyyyMMddHHmmss");
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  @override
  void initState() {
    super.initState();

    presetGame();

    debugResult();

    xList = getX();
    yList = getY();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(16.0)),
            Stack(
              children: [
                SizedBox(
                  width: 720,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      progressText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      _displayDialog(context);
                    },
                    child: Text(
                      "Pause"
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                gameRule,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.blue,
                  ),
                  for (var i=0; i<widget.buttonNum; i++) buildPositioned(xList[i], yList[i], (i+1))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Positioned buildPositioned(int mLeft, int mTop, int id) {
    return Positioned(
                  left: mLeft.toDouble(),
                  top: mTop.toDouble(),
                  child: ElevatedButton(
                    key: Key(id.toString()),
                    onPressed: () {
                      if (btnNow == id) {
                        setState(() {
                          btnNow++;
                          if (btnNow == widget.buttonNum + 1) {
                            btnNow = 1;
                            completedRound++;

                            this.xList = getX();
                            this.yList = getY();
                          }
                          print(btnNow);
                        });
                      }
                    },
                    child: Text(
                      id.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                      fixedSize: Size(120, 120)
                    ),
                  )
                );
  }

  void reposition() {

  }

  _displayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: SimpleDialog(
            title: Text(
              'Pause',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 40
              ),
            ),
            children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 350,
                  height: 100,
                  child: SimpleDialogOption(
                    onPressed: () {},
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        finshOrMenu,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 350,
                  height: 100,
                  child: SimpleDialogOption(
                    onPressed: () {},
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Continue Exercise',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ),
                ),
              ),
            ],
            elevation: 10,
          ),
        );
      },
    );
  }

  Widget creatButtons() {
    return Expanded(
      child: Text(""),
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
          progressText = "1 of ${widget.round} round";
        } else {
          timeLeft = widget.time;

        }
      } else {
        progressText = "Round 1";
      }
    } else {
      gameRule = "Press and drag the number to pair them up";
      progressText = "Round 1";
    }

    //gameInitiateDatabase();
  }

  List getX() {
    List x_list = [];
    int randomX = 0;
    var generator = new Random();

    var numList = <int>[];

    if (widget.gameType == true) {
      for (var i = 1; i <= widget.buttonNum; i++) {
        var random = generator.nextInt(5);
        while (numList.contains(random)) {
          random = generator.nextInt(5);
        }
        numList.add(random);

        randomX = random * 160 + 1;
        x_list.add(randomX);
      }
    } else {
      for (var i = 1; i <= widget.buttonNum; i++) {
        var random = generator.nextInt(5);
        while (numList.contains(random)) {
          random = generator.nextInt(5);
        }
        numList.add(random);

        randomX = random * 160 + 1;
      }
    }

    for (int i in x_list) {
      print(i);
    }

    return x_list;
  }

  List getY() {
    List y_List= [];
    int randomY = 0;
    var generator = new Random();

    var numList = <int>[];

    if (widget.gameType == true) {
      for (var i = 1; i <= widget.buttonNum; i++) {
        var random = generator.nextInt(5);
        while (numList.contains(random)) {
          random = generator.nextInt(5);
        }
        numList.add(random);

        randomY = random * 160 + 30;
        y_List.add(randomY);
      }
    } else {

    }

    for (int i in y_List) {
      print(i);
    }

    return y_List;
  }
}


