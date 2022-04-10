import 'package:assignment4/main.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:assignment4/Game.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

class GameFinishPage extends StatefulWidget {
  final bool gameType;
  final bool gameMode;
  final bool isFree;
  final bool isRound;
  final bool completed;

  final String id;

  const GameFinishPage({
    Key? key,
    required this.gameType,
    required this.gameMode,
    required this.isFree,
    required this.isRound,
    required this.id,
    required this.completed
  }) : super(key: key);

  @override
  _GameFinishPageState createState() => _GameFinishPageState();
}

class _GameFinishPageState extends State<GameFinishPage> {
  String summaryTxt = "";
  bool hasPicture = false;
  CollectionReference games = FirebaseFirestore.instance.collection(DATABASE);

  String gamePicture = "";

  final ButtonStyle btnStyle =
  ElevatedButton.styleFrom(
      primary: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold));

  @override
  void initState() {
    super.initState();

    debugResult();
  }

  Future<void> setSummary() async {
    var gameDoc = await games.doc(widget.id).get();

    var game  = Game.fromJson(gameDoc.data()! as Map<String, dynamic>, gameDoc.id);

    summaryTxt = game.toSummary(widget.isRound, widget.isFree, widget.completed);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: buildFinish);
  }

  Scaffold buildFinish(BuildContext context, GameModel gameModel, _) {
    return Scaffold(
    body: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
            child: summaryTxt == "" ? FutureBuilder(
              future: setSummary(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return FullScreenText(text: "Wrong game!");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return buildText();
                } else {
                  return Center(child: CircularProgressIndicator(),);
                }
              }
            ) : buildText(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 370,
                height: 80,
                child: ElevatedButton(
                  onPressed: () async {
                    takePicture();
                  },
                    style: btnStyle,
                  child: Text(
                    "Take Picture"
                  )
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 370,
                height: 80,
                child: ElevatedButton(
                    onPressed: () async {
                      getFromGallery();
                    },
                    style: btnStyle,
                    child: Text(
                        "Select Picture"
                    )
                ),
              ),
            ),
          ),
          !hasPicture ? Container() : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 370,
                height: 80,
                child: ElevatedButton(
                    onPressed: () async {
                      await gameModel.fetch();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: btnStyle,
                    child: Text(
                        "Go to Menu"
                    )
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: gamePicture.isEmpty ? Container() : Image.file(File(gamePicture)),
            ),
          )
        ],
      ),
    ),
  );
  }

  Text buildText() {
    return Text(
                    summaryTxt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                    ),
                  );
  }

  void takePicture() async {
    final camera = await availableCameras();

    final firstCamera = camera.first;
    var image = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: firstCamera))
    );
    if (image == null) return;

    setState(() {
      gamePicture = image;
      hasPicture = true;
    });

    await uploadImage(image);
  }

  void getFromGallery() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (image == null) return;

    setState(() {
      this.gamePicture = image.path;
      hasPicture = true;
    });

    await uploadImage(image.path);
  }

  uploadImage(String imagePath) async {
    try {
      await FirebaseStorage.instance.ref('imageFlutter/${widget.id}.jpg').putFile(File(imagePath));
    } on FirebaseException catch(e) {
      print(e);
    }
  }

  void debugResult() {
    print("=====");
    print("gameType ${widget.gameType}");
    print("gameMode ${widget.gameMode}");
    print("isFree ${widget.isFree}");
    print("isRound ${widget.isRound}");

    print("id ${widget.id}");
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            Navigator.pop(context, image.path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

