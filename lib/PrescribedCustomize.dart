
import 'package:flutter/material.dart';

class CustomizePrescribed extends StatefulWidget {
  const CustomizePrescribed({Key? key}) : super(key: key);

  @override
  _CustomizePrescribedState createState() => _CustomizePrescribedState();
}

class _CustomizePrescribedState extends State<CustomizePrescribed> {
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


            ],
          ),
        ),
      ),
    );
  }
}
