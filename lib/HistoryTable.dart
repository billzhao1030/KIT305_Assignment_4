
import 'package:assignment4/Game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      primary: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 25),
      textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold));

  bool historyType = true;

  void shareAll(GameModel gameModel) async{
    var allTxt = "";
    for (var game in gameModel.gameList) {
      allTxt += "${game.toShare()}\n";
    }

    await Share.share(allTxt);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
        builder: buildHistoryMain
    );
  }

  Scaffold buildHistoryMain(BuildContext context, GameModel gameModel, _) {
    return Scaffold(
    body: Center(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: (historyType == true) ? Colors.deepOrange : Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  onPressed: (){
                    if (historyType == false) {
                      setState(() {
                        historyType = true;
                      });
                    }
                  },
                  child: Text("Number in order")
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: (historyType == false) ? Colors.deepOrange : Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  onPressed: (){
                    if (historyType == true) {
                      setState(() {
                        historyType = false;
                      });
                    }
                  },
                  child: Text("Matching numbers")
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 128, 8),
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Back")
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(128, 8, 8, 8),
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      onPressed: (){
                        shareAll(gameModel);
                      },
                      child: Text("Share All")
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
  }
}
