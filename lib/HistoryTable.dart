
import 'package:assignment4/Game.dart';
import 'package:assignment4/HistoryDetails.dart';
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
  var searchTxtController = TextEditingController();

  void shareAll(GameModel gameModel) async{
    var allTxt = "";
    for (var game in gameModel.subList) {
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
    return ChangeNotifierProvider(
      create: (context) => GameModel(),
      child: Consumer<GameModel>(
          builder: buildHistoryMain
      ),
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
                        gameModel.fetchDisplay(historyType, "");
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
                        gameModel.fetchDisplay(historyType, "");
                      });
                    }
                  },
                  child: Text("Matching numbers")
                ),
              )
            ],
          ),
          SizedBox(
            width: 650,
            height: 80,
            child: Container(
              alignment: AlignmentDirectional.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
                      controller: searchTxtController,
                      decoration: InputDecoration(
                          hintText: "Exercise Date Time",
                          border: OutlineInputBorder()
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 8, 12, 8),
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          gameModel.fetchDisplay(historyType, searchTxtController.text);
                        },
                        child: Text("Search"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          searchTxtController.text = "";
                          gameModel.fetchDisplay(historyType, "");
                        },
                        child: Text("See All"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox(
                  width: 600,
                  height: 600,
                ),
                if (gameModel.loading)
                  Center(child: CircularProgressIndicator(),)
                else
                  SizedBox(
                    width: 600,
                    height: 640,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, index) {
                        var _gameRow  = gameModel.subList[index];
                        return ListTile(
                          title: Text(_gameRow.id),
                          subtitle: Text(_gameRow.startTime),
                          onTap: (){
                            print(_gameRow.righClick);
                            print(_gameRow.totalClick);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return HistoryDetail(
                                    id: _gameRow.id,
                                    index: index,
                                    gameType: _gameRow.gameType
                                  );
                                })
                            );
                          },
                        );
                      },
                      itemCount: gameModel.subList.length,
                    ),
                  ),
              ],
            ),
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
