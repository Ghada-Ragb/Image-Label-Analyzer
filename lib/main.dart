import 'package:flutter/material.dart';
import 'package:processingimage/ProcessingImage.dart';

void main() {
  runApp(const ProcessinImage());
}

class ProcessinImage extends StatelessWidget {
  const ProcessinImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProcessingImageMain(),
    );
  }
}
