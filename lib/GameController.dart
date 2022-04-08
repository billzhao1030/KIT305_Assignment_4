
import 'dart:async';
import 'dart:math';

import 'package:assignment4/Game.dart';
import 'package:assignment4/GameFinish.dart';
import 'package:assignment4/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  List<bool> highlightList = List.filled(1, false, growable: true);
  List<bool> completeList = List.filled(1, false, growable: true);

  var finshOrMenu = "Go back to Menu";

  DateFormat dateFormatID = DateFormat("yyyyMMddHHmmss");
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  DateFormat clickFormat = DateFormat("HH:mm:ss");
  
  Timer? countDownTimer;
  Duration gameDuration = Duration(days: 1);

  var numButtonPair = 0;
  bool isPair = false;

  List<Color> dropboxColor = [Colors.green, Colors.blue, Colors.purple, Colors.red, Colors.brown];
  List<bool> pairedList = List.filled(1, false, growable: true);

  @override
  void initState() {
    super.initState();

    presetGame();
  }

  @override void dispose() {
    super.dispose();
  }
  
  void startTimer() {
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setCountDown();
    });
  }

  void stopTimer() {
    if (!mounted) return;
    setState(() {
      countDownTimer!.cancel();
    });
  }

  void setCountDown() {
    if (!mounted) return;
    setState(() {
      timeLeft = gameDuration.inSeconds - 1;
      if (timeLeft < 0) {
        countDownTimer!.cancel();

        completeGame();
      } else {
        gameDuration = Duration(seconds: timeLeft);
        progressText = "${timeLeft}s  Round ${completedRound + 1}";
      }
    });
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
                      if (widget.gameType == true && widget.gameMode == true
                          && widget.isRound == false) {
                        stopTimer();
                      }
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
            buildGame()
          ],
        ),
      ),
    );
  }

  Expanded buildGame() {
    if (widget.gameType == true) {
      return Expanded(
        child: Stack(
          children: [
            Container(),
            for (var i=0; i<widget.buttonNum; i++) buildPrescribedButton(xList[i], yList[i], (i+1))
          ],
        ),
      );
    } else {
      return Expanded(
        child: Stack(
          children: [
            Container(),
            for (var i=0; i<widget.buttonNum; i++) designedDropBox(((764-widget.buttonNum * 110)/2).toInt() + 110 *i + 15, 720, i+1),
            for (var i=0; i<widget.buttonNum; i++) buildDesignedButton(xList[i], yList[i], i+1)
          ],
        )
      );
    }
  }

  Positioned buildPrescribedButton(int mLeft, int mTop, int id) {
    return Positioned(
                  left: mLeft.toDouble(),
                  top: mTop.toDouble(),
                  child: ElevatedButton(
                    key: Key(id.toString()),
                    onPressed: () {
                      if (btnNow == id) {
                        final Map<String, int> clickMap = {
                          clickFormat.format(DateTime.now()): id
                        };

                        setState(() {
                          buttonList.add(clickMap);
                          uploadButtonList();

                          if (widget.hasIndication == true) {
                            highlightList[btnNow - 1] = false;
                          }

                          completeList[id-1] = true;

                          btnNow++;
                          if (btnNow > widget.buttonNum) {
                            btnNow = 1;
                            completedRound++;

                            if (widget.gameMode == false) {
                              completed = true;
                            } else if (widget.isRound == false) {
                              completed = true;
                            }

                            uploadRound();

                            resetStr();

                            if (widget.gameMode == false) {
                              completed = true;
                            }

                            if (widget.gameMode == true) {
                              if (widget.round != -1) {
                                if (completedRound == widget.round) {
                                  completed = true;
                                  print("completed");
                                  completeGame();
                                } else {
                                  reposition();
                                  progressText = "${completedRound+1} of ${widget.round} round";
                                }
                              } else {
                                this.xList = getX();
                                this.yList = getY();
                                progressText = "${timeLeft}s  Round ${completedRound + 1}";
                              }
                            } else {
                              reposition();
                              progressText = "Round ${completedRound + 1}";
                            }
                          }

                          if (widget.hasIndication == true) {
                            highlightList[btnNow-1] = true;
                          }
                        });
                      } else {
                        setState(() {
                          final Map<String, int> clickMap = {
                            clickFormat.format(DateTime.now()): id * 10
                          };
                          buttonList.add(clickMap);
                          uploadButtonList();
                        });
                      }
                    },
                    child: Text(
                        (completeList[id-1] ? "\u2713" : id.toString()),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: (24 + widget.buttonSize *2)
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: highlightList[id-1] ? Colors.red : Colors.amber,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                      fixedSize: Size(buttonSize.toDouble(), buttonSize.toDouble())
                    ),
                  )
                );
  }

  Positioned designedDropBox(int mLeft, int mTop, int id) {
    return Positioned(
      left: mLeft.toDouble(),
      top: mTop.toDouble(),
      child: DragTarget<int> (
        builder: (context, List<dynamic> accepted, List<dynamic> rejected) {
          return Container(
            height: 100,
            width: 100,
            color: dropboxColor[id - 1],
            child: Center(
              child: Text(
                id.toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                ),
              )
            ),
          );
        },
        onWillAccept: (data) {
          return data == id;
        },
        onAccept: (data) {
          setState(() {
            pairedList[id - 1] = true;
            if (!pairedList.contains(false)) {
              for (var i = 0; i < widget.buttonNum; i++) {
                pairedList[i] = false;
              }
              completedRound ++;
              completed = true;
              uploadRound();
              progressText = "Round ${completedRound + 1}";
              if (widget.isRandom) {
                reposition();
              }
            }
          });
        },
      )
    );
  }

  Positioned buildDesignedButton(int mLeft, int mTop, int id) {
    return Positioned(
        left: mLeft.toDouble(),
        top: mTop.toDouble(),
        child: !pairedList[id - 1] ? Draggable<int>(
          data: id,
          feedback: draggableButton(id, Colors.amber),
          child: draggableButton(id, Colors.amber),
          childWhenDragging: draggableButton(id, Colors.amberAccent),
        ) : Container()
    );
  }

  ElevatedButton draggableButton(int id, Color c) {
    return ElevatedButton(
          key: Key(id.toString()),
          onPressed: () {},
          child: Text(
            id.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (30)
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary:c,
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
              fixedSize: Size(100, 100)
          ),
        );
  }

  _displayDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<GameModel>(builder: dialogPanel);
      },
    );
  }

  Expanded dialogPanel(BuildContext context, GameModel gameModel, _) {
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
                      uploadRound();
                      if (completed == true) {
                        completeGame();
                      } else {
                        gameModel.fetch();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      completed ? "Finish Exercise" : "Go back to menu",
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
                      uploadRound();
                      if (widget.gameType == true &&
                          widget.gameMode == true && widget.isRound == false) {
                        startTimer();
                      }
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
  }

  void reposition() {
    setState(() {
      if (widget.isRandom == true) {
        this.xList = getX();
        this.yList = getY();
      }
    });
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
    print("buttonSize ${buttonSize}");
  }

  void uploadRound() async {
    endTime = dateFormat.format(DateTime.now());
    db.doc(id).update({
      'repetition': completedRound,
      'endTime': endTime,
      'completed': completed
    })
    .then((value) => print("Game updated"))
    .catchError((error) => print("Failed to update game: ${error}"));
  }

  void uploadButtonList() async {
    endTime = dateFormat.format(DateTime.now());
    db.doc(id).update({
      'buttonList': buttonList,
      'endTime': endTime
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
      buttonSize = widget.buttonSize * 10 + 70;

      gameRule = "Tap the button in number order (from 1)";

      if (widget.gameMode == true) {
        if (widget.round != -1) {
          progressText = "1 of ${widget.round} round";
        } else {
          timeLeft = widget.time;
          gameDuration = Duration(seconds: timeLeft);
          progressText = "${timeLeft}s  Round ${completedRound + 1}";
          startTimer();
        }
      } else {
        progressText = "Round 1";
      }

      for (var i = 0; i < widget.buttonNum; i++) {
        if (i == 0) {
          if (widget.hasIndication == true) {
            highlightList[i] = true;
          } else{
            highlightList[i] = false;
          }
        } else {
          highlightList.add(false);
        }
      }

      for (var i = 0; i < widget.buttonNum; i++) {
        if (i == 0) {
          completeList[i] = false;
        } else {
          completeList.add(false);
        }
      }
    } else {
      gameRule = "Press and drag the number to pair them up";
      progressText = "Round 1";

      for (var i = 0; i < widget.buttonNum; i++) {
        if (i==0) {
          pairedList[i] = false;
        } else {
          pairedList.add(false);
        }
      }
    }

    debugResult();

    this.xList = getX();
    this.yList = getY();

    gameInitiateDatabase();
  }

  void completeGame() async {
    endTime = dateFormat.format(DateTime.now());
    db.doc(id).update({
      'completed': true,
      'endTime': endTime
    })
        .then((value) => print("Game updated"))
        .catchError((error) => print("Failed to update game: ${error}"));

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return GameFinishPage(
            id: this.id,
            isRound: widget.isRound,
            isFree: widget.isFree,
            gameMode: widget.gameMode,
            gameType: widget.gameType,
          );
        })
    );
  }

  void resetStr() {
    for (var i = 0; i < widget.buttonNum; i++) {
      completeList[i] = false;
    }
  }

  List getX() {
    List x_list = [];
    int randomX = 0;
    var generator = new Random();

    var numList = <int>[];

    for (var i = 1; i <= widget.buttonNum; i++) {
      var random = generator.nextInt(5);
      while (numList.contains(random)) {
        random = generator.nextInt(5);
      }
      numList.add(random);

      randomX = random * 160 + 5;
      x_list.add(randomX);
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
      for (var i = 1; i <= widget.buttonNum; i++) {
        var random = generator.nextInt(5);
        while (numList.contains(random)) {
          random = generator.nextInt(5);
        }
        numList.add(random);

        randomY = random * 128 + 30;
        y_List.add(randomY);
      }
    }

    return y_List;
  }
}


