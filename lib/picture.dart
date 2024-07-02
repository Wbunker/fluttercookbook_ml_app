import 'package:firebase_ml/ml.dart';
import 'package:firebase_ml/result_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';

class PictureScreen extends StatelessWidget {
  final XFile? picture;
  const PictureScreen(this.picture, {super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(picture!.path),
          SizedBox(
            height: deviceHeight / 1.5,
            child: Image.file(File(picture!.path)),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final image = File(picture!.path);
                  MLHelper helper = MLHelper();
                  helper.textFromImage(image).then((result) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(result),
                      ),
                    );
                  });
                },
                child: const Text('Text Recognition'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
