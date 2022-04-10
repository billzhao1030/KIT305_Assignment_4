import 'package:assignment4/Game.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';

class HistoryDetail extends StatefulWidget {
  final String id;
  final int index;
  final bool gameType;
  final String searchTxt;

  const HistoryDetail({
    Key? key,
    required this.id,
    required this.index,
    required this.gameType,
    required this.searchTxt
  }) : super(key: key);

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var games = Provider.of<GameModel>(context, listen: false).subList;
    var game = games[widget.index];
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 24, 0, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Back")
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        onPressed: () => deleteDialog(context),
                      child: Text("Delete")
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        onPressed: (){
                          shareThis(game);
                        },
                        child: Text("Share")
                    ),
                  ),
                ),
              ],
            ),

            FutureBuilder(
              future: downloadImage(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: Image.network(snapshot.data!, fit: BoxFit.cover),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }

                return Container(
                  width: 300,
                  height: 300,
                  child: Text("nope"),
                );
              },
            ),

            widget.gameType == true ? prescribedHistory(game: game, id: widget.id,) : Container(),

          ],
        ),
      ),
    );
  }

  Future<String> downloadImage() async {
    String url = await FirebaseStorage.instance.ref("imageFlutter/${widget.id}.jpg").getDownloadURL();

    return url;
  }

  deleteDialog(BuildContext context) {
    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Consumer<GameModel>(builder: alertDialog);
                        },
                      );
  }

  AlertDialog alertDialog(BuildContext context, GameModel gameModel, _) {
    return AlertDialog(
                        title: const Text('Please Pay Attention'),
                        content: const Text('Are you sure to delete this exercise?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontSize: 22
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              print("delete ${widget.id}");
                              print("remove at ${widget.index}");
                              await gameModel.delete(widget.id);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              //await gameModel.subList.removeAt(widget.index);
                              //gameModel.notifyListeners();
                              await gameModel.fetchDisplay(widget.gameType, widget.searchTxt);
                              //gameModel.fetch();

                              print(gameModel.subList.length);
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                  fontSize: 22
                              ),
                            ),
                          ),
                        ],
                      );
  }

  void shareThis(Game game) async {
      await Share.share(game.toShare());
  }

  void debugResult() {
    print("*****");
    print("ID: ${widget.id}");
    print("Game: ${Provider.of<GameModel>(context, listen: false).subList[widget.index]}");
  }
}

class prescribedHistory extends StatelessWidget {
  const prescribedHistory({
    Key? key,
    required this.game, required this.id,
  }) : super(key: key);

  final Game game;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Total Click: ${game.totalClick}",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Right Click: ${game.rightClick}",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(
            "Button Click List:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36
            ),
          ),
        ),
        SizedBox(
          width: 400,
          height: 360,
          child: ListView.builder(
            itemBuilder: (_, index) {
              var _perClick = game.buttonList[index];

              var time = _perClick.keys.toString().substring(1, 9);
              var buttonLength = _perClick.values.toString().length;

              var button = _perClick.values.toString().substring(1, buttonLength-1);

              return ListTile(
                title: Text(
                  "${time} : button ${button.substring(0, 1)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (button.length == 2) ? Colors.red : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
              );
            },
            itemCount: game.totalClick,
          ),
        )
      ],
    );
  }
}
