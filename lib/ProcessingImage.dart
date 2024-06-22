import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ProcessingImageMain extends StatefulWidget {
  const ProcessingImageMain({super.key});

  @override
  State<ProcessingImageMain> createState() => _ProcessingImageMainState();
}

class _ProcessingImageMainState extends State<ProcessingImageMain> {
  String ImageLabels = ' ';
  File? ImageFile;
  Future _PickImage() async {
    try {
      final imagePicked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicked != null) {
        ImageProcessing(imagePicked);
        setState(() {
          ImageFile = File(imagePicked.path);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //StringBuffer تقوم بدمج اكثر من استرينج في متغير واحد
  // Confidence بنحصل عليها لو ميه في الميه 0.1 علشان اعمل 100 لازم اكتب معادله
  // (confidence * 100).toStringAsFixed(2);

  void ImageProcessing(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    //عاوزه احدد فوق التمنين في الميه هو اللي يظهر اكتب دا  options: ImageLabelerOptions(confidenceThreshold : 0.80);
    ImageLabeler imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer SB = StringBuffer();
    for (ImageLabel imageLabel in labels) {
      String text = imageLabel.label;
      double confidence = imageLabel.confidence;
      SB.write(text);
      SB.write(" : ");
      SB.write((confidence * 100).toStringAsFixed(2));
      SB.write("%\n");
    }
    imageLabeler.close();
    ImageLabels = SB.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 245, 240, 240),
        title: const Center(
          child: Text(
            "Image Label Analyzer",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 101, 85, 103),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                    width: double.infinity,
                    height: 280,
                    color: const Color.fromARGB(255, 207, 207, 207),
                    child: ImageFile == null
                        ? Container()
                        : Image.file(ImageFile!, fit: BoxFit.cover)),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 330,
                  height: 50,
                  color: const Color.fromARGB(255, 177, 153, 194),
                  child: MaterialButton(
                    onPressed: () {
                      _PickImage();
                    },
                    child: const Text(
                      "Pick Image",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  ImageLabels,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 101, 85, 103),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
