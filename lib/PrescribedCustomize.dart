
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomizePrescribed extends StatefulWidget {
  const CustomizePrescribed({Key? key}) : super(key: key);

  @override
  _CustomizePrescribedState createState() => _CustomizePrescribedState();
}

class _CustomizePrescribedState extends State<CustomizePrescribed> {
  var gameType = true;
  var gameMode = true;

  double round = -1;
  double time = -1;
  bool isRound = true;
  bool isFree = false;
  double goal = -1;

  var isRandom = true;
  var hasIndication = true;

  var buttonSize = 2;
  List<double> timeList = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0];
  List<double> roundList = [3, 4, 5, 6, 7, 8];
  var buttonNumList = [2, 3, 4, 5];

  List<DropdownMenuItem<double>> _goalDropDownItems = [];

  var goalModeBtnColor = Colors.amber;
  var freeModeBtnColor = Colors.amber;
  var roundBtnColor = Colors.amber;
  var timeBtnColor = Colors.amber;

  ButtonStyle? btnStyle =
  ElevatedButton.styleFrom(
      primary: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

  @override
  void initState() {
    super.initState();

    _goalDropDownItems = setGoalDropDownItem();
    setBtnColor();
  }

  List<DropdownMenuItem<double>> setGoalDropDownItem() {
    List<DropdownMenuItem<double>> items = [];
    if (isFree == false) {
      List<double> goalList = roundList.cast<double>();

      if (isRound == false) {
        goalList = timeList;
      }

      for (double goal in goalList) {
        items.add(new DropdownMenuItem(
            value: goal,
            child: new Text(goal.toString())
        ));
      }

      goal = items[2].value!;
    }

    return items;
  }

  void setBtnColor() {
    if (isFree == false) {
      goalModeBtnColor = Colors.deepOrange;
      freeModeBtnColor = Colors.amber;

      if (isRound == true) {
        roundBtnColor = Colors.deepOrange;
        timeBtnColor = Colors.amber;
      } else {
        roundBtnColor = Colors.amber;
        timeBtnColor = Colors.deepOrange;
      }
    } else {
      goalModeBtnColor = Colors.amber;
      freeModeBtnColor = Colors.deepOrange;

      roundBtnColor = Colors.grey;
      timeBtnColor = Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Choose the game mode",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      fontStyle: FontStyle.italic,
                      color: Color.alphaBlend(Colors.black, Colors.blue)
                  ),
                ),
              ),

              Center(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(130, 8, 40, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (isFree == true) {
                            setState(() {
                              isFree = false;
                              _goalDropDownItems = setGoalDropDownItem();

                              if (isRound == true) {
                                round = goal;
                                time = -1;
                              } else {
                                time = goal;
                                round = -1;
                              }
                              setBtnColor();

                              debugResult();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: goalModeBtnColor,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        child: Text("Goal-mode")
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButton(
                          items: _goalDropDownItems,
                          value: goal,
                          onChanged: (selectedGoal) {
                            setState(() {
                              if (isRound == true) {
                                round = selectedGoal as double;
                                goal = round;
                                debugResult();
                              } else {
                                time = selectedGoal as double;
                                goal = time;
                                debugResult();
                              }
                            });
                          }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (isFree == false) {
                              if (isRound == false) {
                                setState(() {
                                  isRound = true;
                                  _goalDropDownItems = setGoalDropDownItem();

                                  round = goal;
                                  time = -1;

                                  setBtnColor();
                                  debugResult();
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: roundBtnColor,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                          child: Text("Rounds")
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (isFree == false) {
                              if (isRound == true) {
                                setState(() {
                                  isRound = false;
                                  _goalDropDownItems = setGoalDropDownItem();

                                  time = goal;
                                  round = -1;

                                  setBtnColor();
                                  debugResult();
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: timeBtnColor,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                          child: Text("Minutes")
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isFree == false) {
                        setState(() {
                          isFree = true;
                          round = -1;
                          time = -1;

                          setBtnColor();
                          _goalDropDownItems = setGoalDropDownItem();

                          debugResult();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: freeModeBtnColor,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    child: Text("Free-mode"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void debugResult() {
    print("Round ${round}");
    print("Time ${time}");
    print("Is Round ${isRound}");

    print("Goal ${goal}");

    //print("GoalList ${_goalDropDownItems}");
  }
}
