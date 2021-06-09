import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FlutterFFmpeg _ffMpeg = FlutterFFmpeg();
  var myDir = Directory('/data/user/0/com.example.audioimage/cache/');
  var _controller;
  var imagePath;
  var audioPath;
  var image;
  var audio;

  final picker = ImagePicker();

  Future getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'WAV', 'mp4'],
    );
    setState(() {
      if (result != null) {
        audioPath = result.files.single.path;
        audio = File((result.files.single.path).toString());
        print(result.files.single.path);
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
        image = File(pickedFile.path);
        print(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  merge() {
    final outputFile = myDir.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.mp4';
    _ffMpeg
        .execute("-i $imagePath -i $audioPath -c copy $outputFile")
        .then((return_code) => print("Return code $return_code"));
    print(outputFile);
    setState(() {
      _controller = VideoPlayerController.asset(outputFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller != null
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            // image != null
            //     ? ClipRRect(
            //         borderRadius: BorderRadius.circular(15),
            //         child: Image.file(
            //           image,
            //         ),
            //       )
            //     : Container(
            //         decoration: BoxDecoration(
            //             color: Colors.grey,
            //             borderRadius: BorderRadius.circular(20)),
            //         child: Center(
            //           child: Text(
            //             'Select the image',
            //             style: TextStyle(
            //                 fontSize: 30, fontWeight: FontWeight.w300),
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //       ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    getAudio();
                  },
                  child: Text(
                    'Audio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 20,
                ),
                FlatButton(
                  onPressed: () {
                    _bottomSheet(context);
                  },
                  child: Text(
                    'Image',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            FlatButton(
              onPressed: () {
                merge();
              },
              child: Text(
                'Merge',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                      width: MediaQuery.of(context).size.width * .9,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          getImageCamera();
                          print(image);
                        },
                        child: Text(
                          'Take a Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                      width: MediaQuery.of(context).size.width * .9,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          getImageGallery();
                        },
                        child: Text(
                          'Choose from Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ]),
                ));
          });
        });
  }
}
