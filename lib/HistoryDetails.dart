import 'package:assignment4/Game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';

class HistoryDetail extends StatefulWidget {
  final String id;
  final int index;
  final bool gameType;

  const HistoryDetail({
    Key? key,
    required this.id,
    required this.index,
    required this.gameType
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
    var game = Provider.of<GameModel>(context, listen: false).subList[widget.index];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Back")
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text("Delete")
                ),
                ElevatedButton(
                    onPressed: (){
                      shareThis(game);
                    },
                    child: Text("Share")
                ),
              ],
            ),
            // ListView.builder(
            //   itemBuilder: (_, index) {
            //     return ListTile(
            //
            //     );
            //   },
            //   itemCount: game.buttonList.length,
            // )
          ],
        ),
      ),
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
