
import 'package:flutter/material.dart';

import 'GameController.dart';

class CustomizeDesigned extends StatefulWidget {
  const CustomizeDesigned({Key? key}) : super(key: key);

  @override
  _CustomizeDesignedState createState() => _CustomizeDesignedState();
}

class _CustomizeDesignedState extends State<CustomizeDesigned> {
  int buttonPairNum = 2;
  bool isRandom = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 8),
              child: Center(
                  child: Text(
                    "Customization",
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Text(
                "The number of pairs of buttons each round",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 36, 0, 36),
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RadioListTile(
                          title: const Text(
                            "2 Pair(s)",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          value: 2,
                          groupValue: buttonPairNum,
                          onChanged: (value) {
                            setState(() {
                              this.buttonPairNum = value as int;
                              debugResult();
                            });
                          }
                      ),
                      RadioListTile(
                          title: const Text(
                            "3 Pair(s)",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          value: 3,
                          groupValue: buttonPairNum,
                          onChanged: (value) {
                            setState(() {
                              this.buttonPairNum = value as int;
                              debugResult();
                            });
                          }
                      ),
                      RadioListTile(
                          title: const Text(
                            "4 Pair(s)",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          value: 4,
                          groupValue: buttonPairNum,
                          onChanged: (value) {
                            setState(() {
                              this.buttonPairNum = value as int;
                              debugResult();
                            });
                          }
                      ),
                      RadioListTile(
                          title: const Text(
                            "5 Pair(s)",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          value: 5,
                          groupValue: buttonPairNum,
                          onChanged: (value) {
                            setState(() {
                              this.buttonPairNum = value as int;
                              debugResult();
                            });
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(135, 50, 30, 0),
                    child: Text(
                      "Is random order each round",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                    child: SizedBox(
                        width: 100,
                        child: Switch(
                          value: isRandom,
                          onChanged: (value) {
                            setState(() {
                              isRandom = value;
                              debugResult();
                            });
                          },
                        )
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 200, 50, 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)
                    ),
                    child: Text(
                      "Back",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(376, 200, 0, 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return GamePage(
                              gameType: false,
                              gameMode: false,
                              isFree: true,
                              isRound: false,
                              buttonNum: this.buttonPairNum,
                              isRandom: this.isRandom,
                              hasIndication: true,
                              buttonSize: -1,
                              round: -1,
                              time: -1,
                            );
                          })
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)
                    ),
                    child: Text(
                      "Start",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void debugResult() {
    print("Pairs ${buttonPairNum}");
    print("Is random ${isRandom}");
  }
}
