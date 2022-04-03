
import 'package:assignment4/GameController.dart';
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

  double round = 5;
  double time = -1;
  bool isRound = true;
  bool isFree = false;
  double goal = -1;

  var buttonNum = 3;
  var isRandom = true;
  var hasIndication = true;
  var buttonSize = 3.0;

  List<double> timeList = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0];
  List<double> roundList = [3, 4, 5, 6, 7, 8];
  var buttonNumList = [2, 3, 4, 5];

  List<DropdownMenuItem<double>> _goalDropDownItems = [];
  List<DropdownMenuItem<int>> _buttonNumDropDownItems = [];

  var goalModeBtnColor = Colors.amber;
  var freeModeBtnColor = Colors.amber;
  var roundBtnColor = Colors.amber;
  var timeBtnColor = Colors.amber;

  var sizeHint = "Normal";

  @override
  void initState() {
    super.initState();

    _goalDropDownItems = setGoalDropDownItem();
    _buttonNumDropDownItems = setButtonNumDropDownItem();
    setBtnColor();

    debugResult();
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

  List<DropdownMenuItem<int>> setButtonNumDropDownItem() {
    List<DropdownMenuItem<int>> items = [];
    for (int num in buttonNumList) {
      items.add(new DropdownMenuItem(
          value: num,
          child: new Text(num.toString())
      ));
    }

    buttonNum = items[1].value!;

    return items;
  }

  void setSizeHint() {
    if (buttonSize == 1.0) {
      sizeHint = "Extra Small";
    } else if (buttonSize == 2.0) {
      sizeHint = "Small";
    } else if (buttonSize == 3.0) {
      sizeHint = "Normal";
    } else if (buttonSize == 4.0) {
      sizeHint = "Big";
    } else {
      sizeHint = "Extra Big";
    }
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
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 40),
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
                      padding: EdgeInsets.fromLTRB(100, 8, 40, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (isFree == true) {
                            setState(() {
                              isFree = false;
                              gameMode = true;
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
                            textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                        ),
                        child: Text("Goal-mode")
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: DropdownButton(
                          items: _goalDropDownItems,
                          value: goal,
                          isExpanded: true,
                          itemHeight: 60,
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
                              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
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
                              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
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
                          gameMode = false;
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
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                    child: Text("Free-mode"),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 8),
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
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(85, 15, 40, 0),
                      child: Text(
                        "The number of buttons each round",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 50, 0),
                      child: SizedBox(
                        width: 100,
                        child: DropdownButton(
                            items: _buttonNumDropDownItems,
                            value: buttonNum,
                            isExpanded: true,
                            onChanged: (selectedNum) {
                              setState(() {
                                buttonNum = selectedNum as int;

                                debugResult();
                              });
                            }
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(135, 20, 30, 0),
                      child: Text(
                        "Is random order each round",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(145, 20, 30, 0),
                      child: Text(
                        "Has next button indication",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(55, 20, 50, 0),
                      child: SizedBox(
                          width: 100,
                          child: Switch(
                            value: hasIndication,
                            onChanged: (value) {
                              setState(() {
                                hasIndication = value;
                                debugResult();
                              });
                            },
                          )
                      ),
                    ),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 36, 0, 20),
                child: Center(
                  child: Text(
                    "Select the size of button",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26
                    ),
                  ),
                ),
              ),

              Center(
                child: SizedBox(
                  width: 250,
                  child: Slider(
                    value: buttonSize,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        buttonSize = value;
                        setSizeHint();
                        debugResult();
                      });
                    }
                  ),
                ),
              ),
              Center(
                child: Text(
                  sizeHint,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 32, 50, 24),
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
                    padding: const EdgeInsets.fromLTRB(376, 32, 0, 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return GamePage(
                                gameType: this.gameType,
                                gameMode: this.gameMode,
                                isFree: this.isFree,
                                isRound: this.isRound,
                                buttonNum: this.buttonNum,
                                isRandom: this.isRandom,
                                hasIndication: this.hasIndication,
                                buttonSize: this.buttonSize.toInt(),
                                round: this.round.toInt(),
                                time: (this.time * 60).toInt(),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void debugResult() {
    print("******");
    print("Round ${round}");
    print("Time ${time}");
    print("Is Round ${isRound}");

    print("Goal ${goal}");

    print("Button num ${buttonNum}");
    print("Is random ${isRandom}");
    print("Has indication ${hasIndication}");
    print("Button size ${buttonSize}");

    print("gameType ${gameType}");
    print("gameMode ${gameMode}");
  }
}
