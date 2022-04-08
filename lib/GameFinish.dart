import 'package:assignment4/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:assignment4/Game.dart';
import 'package:provider/provider.dart';

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
  String summaryTxt = "";
  bool hasPicture = false;
  CollectionReference games = FirebaseFirestore.instance.collection(DATABASE);

  final ButtonStyle btnStyle =
  ElevatedButton.styleFrom(
      primary: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold));

  @override
  void initState() {
    super.initState();

    debugResult();
  }

  Future<void> setSummary() async {
    var gameDoc = await games.doc(widget.id).get();

    var game  = Game.fromJson(gameDoc.data()! as Map<String, dynamic>, gameDoc.id);

    print(game.toDebug());

    summaryTxt = game.toDebug();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: buildFinish);
  }

  Scaffold buildFinish(BuildContext context, GameModel gameModel, _) {
    return Scaffold(
    body: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
            child: summaryTxt == "" ? FutureBuilder(
              future: setSummary(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return FullScreenText(text: "Wrong game!");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return buildText();
                } else {
                  return Center(child: CircularProgressIndicator(),);
                }
              }
            ) : buildText(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 370,
                height: 80,
                child: ElevatedButton(
                  onPressed: (){
                    if (hasPicture == false) {
                      setState(() {
                        hasPicture = true;
                      });
                    } else {
                      gameModel.fetch();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                    style: btnStyle,
                  child: Text(
                    hasPicture ? "Go to menu" : "Take Picture"
                  )
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 370,
                height: 80,
                child: ElevatedButton(
                    onPressed: (){},
                    style: btnStyle,
                    child: Text(
                        "Select Picture"
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }

  Text buildText() {
    return Text(
                    summaryTxt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                    ),
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
