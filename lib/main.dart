
import 'package:assignment4/DesignedCustomize.dart';
import 'package:assignment4/HistoryTable.dart';
import 'package:assignment4/PrescribedCustomize.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Game.dart';

const String DATABASE = "gamesFlutter";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return FullScreenText(text: "Wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Assignment App',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            home: const MainPage(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var userNameController = TextEditingController();

  var prescribedTotal = 0;
  var designedTotal = 0;

  var summary = "";

  final ButtonStyle style =
  ElevatedButton.styleFrom(
      primary: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 25),
      textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold));

  @override
  void initState() {
    super.initState();
    setSummary();
    userNameController.addListener(updateUsername);
  }

  void setSummary() async {
    CollectionReference db = FirebaseFirestore.instance.collection("gamesFlutter");

    var gameDoc = await db.get();

    gameDoc.docs.forEach((doc) {
      var game = Game.fromJson(doc.data()! as Map<String, dynamic>, doc.id);

      var repetition = game.repetition;

      if (game.gameType == true) {
        prescribedTotal += repetition;
      } else {
        designedTotal += repetition;
      }
    });

    summary = "You have completed\n ${prescribedTotal} repetitions in Number In Order\n "
        "${designedTotal} repetitions in Matching Numbers";
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();

    var username = prefs.getString("FlutterUsername") ?? "Name";
    userNameController.text = username;
  }

  Future<void> updateUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("FlutterUsername", userNameController.text);
  }

  void customizePrescribed() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return CustomizePrescribed();
        })
    );
  }

  void customizeDesigned() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return CustomizeDesigned();
        })
    );
  }

  void seeHistory() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HistoryPage();
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getName(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return FullScreenText(text: "Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(8.0)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Stroke Rehabilitation Exercise",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          fontStyle: FontStyle.italic,
                          color: Color.alphaBlend(Colors.black, Colors.blue)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Enter your name here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.black54
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 250,
                        child: TextField(
                          controller: userNameController,
                          decoration: const InputDecoration(
                              hintText: "Your Name",
                              labelText: "",
                              border: OutlineInputBorder()
                          ),
                          textAlign: TextAlign.center,
                          maxLength: 24,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding( // Game 1
                    padding: const EdgeInsets.all(36.0),
                    child: Center(
                      child: SizedBox(
                        width: 500,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: customizePrescribed,
                          style: style,
                          child: Text("Number In Order"),
                        ),
                      ),
                    ),
                  ),
                  Padding( // Game 2
                    padding: const EdgeInsets.all(36.0),
                    child: Center(
                      child: SizedBox(
                        width: 500,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: customizeDesigned,
                          style: style,
                          child: Text("Matching Numbers"),
                        ),
                      ),
                    ),
                  ),
                  Padding( // History
                    padding: const EdgeInsets.all(36.0),
                    child: Center(
                      child: SizedBox(
                        width: 500,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: seeHistory,
                          style: style,
                          child: Text("Exercise History"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      summary,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      }
    );
  }
}

class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection:TextDirection.ltr, child: Column(children: [ Expanded(child: Center(child: Text(text))) ]));
  }
}