import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final bool gameType;
  final bool gameMode;
  final bool isFree;
  final bool isRound;

  final int buttonNum;
  final bool isRandom;
  final bool hasIndication;
  final double buttonSize;

  final double round;
  final double time;

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
  var repetition = 0;

  @override
  void initState() {
    super.initState();

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
}
