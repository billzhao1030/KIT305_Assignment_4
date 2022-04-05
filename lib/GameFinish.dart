import 'package:flutter/material.dart';

class GameFinishPage extends StatefulWidget {
  final bool gameType;
  final bool gameMode;
  final bool isFree;
  final bool isRound;

  final String id;

  const GameFinishPage({
    Key? key,
    required this.gameType,
    required this.gameMode,
    required this.isFree,
    required this.isRound,
    required this.id
  }) : super(key: key);

  @override
  _GameFinishPageState createState() => _GameFinishPageState();
}

class _GameFinishPageState extends State<GameFinishPage> {

  @override
  void initState() {
    super.initState();

    debugResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("finish"),
    );
  }

  void debugResult() {
    print("=====");
    print("gameType ${widget.gameType}");
    print("gameMode ${widget.gameMode}");
    print("isFree ${widget.isFree}");
    print("isRound ${widget.isRound}");

    print("id ${widget.id}");
  }
}
