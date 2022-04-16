
import 'package:assignment4/Game.dart';
import 'package:assignment4/HistoryDetails.dart';
import 'package:flutter/cupertino.dart';
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
    return Consumer<GameModel>(
        builder: buildHistoryMain
    );
  }

  Scaffold buildHistoryMain(BuildContext context, GameModel gameModel, _) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
                      onPressed: () async {
                        if (historyType == false) {
                          setState(() {
                            historyType = true;
                            searchTxtController.text = "";
                          });
  
                          await gameModel.fetchDisplay(historyType, "");
                          print("display item: ${gameModel.subList.length}");
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
                      onPressed: ()  async {
                        if (historyType == true) {
                          setState(() {
                            historyType = false;
                            searchTxtController.text = "";
                          });
                          await gameModel.fetchDisplay(historyType, "");
                          print("display item: ${gameModel.subList.length}");
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
                            onPressed: () async {
                              await gameModel.fetchDisplay(historyType, searchTxtController.text);
  
                              print("display item: ${gameModel.subList.length}");
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
                            onPressed: () async {
                              searchTxtController.text = "";
                              await gameModel.fetchDisplay(historyType, "");
  
                              print("display item: ${gameModel.subList.length}");
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
                      height: 640,
                    ),
                    if (gameModel.loading)
                      Center(child: CircularProgressIndicator(),)
                    else
                      gameModel.subList.isEmpty ? Center(child: Text("No Item!", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        fontStyle: FontStyle.italic
                      ),)) : listBox(gameModel, context),
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
                          onPressed: () async{
                            Navigator.pop(context);
                            await gameModel.fetch();
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
      ),
    );
  }

  SizedBox listBox(GameModel gameModel, BuildContext context) {
    return SizedBox(
                  width: 600,
                  height: 640,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      var _gameRow  = gameModel.subList[index];

                      return ListTile(
                        leading: SizedBox(
                          width: 30,
                          height: 30,
                          child: Container(
                            color: (_gameRow.gameType) ? ((_gameRow.gameMode) ? Colors.lightGreen : Colors.purpleAccent) : Colors.purpleAccent,
                          ),
                        ),
                        title: Text(
                          "${index+1}. ${(_gameRow.gameMode) ? "Goal Mode" : "Free Mode"}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(
                          "Start at: ${_gameRow.startTime}\nEnd at: ${_gameRow.endTime}\n" +
                          "Repetition: ${_gameRow.repetition}   Completed: ${_gameRow.completed ? "Yes":"No"}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.black54,
                          size: 36,
                        ),
                        onTap: (){
                          print(_gameRow.id);
                          print(index);
                          print(gameModel.subList.length);


                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return HistoryDetail(
                                  id: _gameRow.id,
                                  index: index,
                                  gameType: _gameRow.gameType,
                                  searchTxt: searchTxtController.text,
                                );
                              })
                          );
                        },
                      );
                    },
                    itemCount: gameModel.subList.length,
                  ),
                );
  }
}
