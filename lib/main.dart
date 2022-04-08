
import 'package:assignment4/DesignedCustomize.dart';
import 'package:assignment4/HistoryTable.dart';
import 'package:assignment4/PrescribedCustomize.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';

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
          return ChangeNotifierProvider(
            create: (context) => GameModel(),
            child: MaterialApp(
              title: 'Assignment App',
              theme: ThemeData(
                primarySwatch: Colors.amber,
              ),
              home: const MainPage(),
            ),
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

    userNameController.addListener(updateUsername);
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

  void seeHistory() async {
    // Navigator.push(context, MaterialPageRoute(
    //     builder: (context) {
    //       return HistoryPage();
    //     })
    // );
    await Share.share("jjjj");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel> (
      builder: buildMain,
    );
  }

  Scaffold buildMain(BuildContext context, GameModel gameModel, _) {
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
                  child: FutureBuilder(
                    future: getName(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return FullScreenText(text: "Can't get username");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return nameField();
                      } else {
                        return nameField();
                      }
                    }
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
                if (gameModel.loading) CircularProgressIndicator() else Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "You have completed\n ${gameModel.prescribedTotal} repetitions in Number In Order\n "
                           "${gameModel.designedTotal} repetitions in Matching Numbers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 28,
                    ),
                  )
                ),
              ],
            ),
          ),
        );
  }

  Padding nameField() {
    return Padding(
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