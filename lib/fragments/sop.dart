import 'dart:io';
import 'dart:typed_data';

import 'package:digi_pm_skin/api/webservice.dart';
import 'package:digi_pm_skin/pages/PdfViewer.dart';
import 'package:digi_pm_skin/provider/digiPMProvider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Sop extends StatefulWidget {
  final String videoUrl;
  const Sop({Key key, this.videoUrl}) : super(key: key);

  @override
  _SopState createState() => _SopState();
}

class _SopState extends State<Sop> {
  String path;
  var videoController;
  var chewieController;
  var videoControllerDefault;
  var chewieControllerDefault;

  @override
  void initState() {
    super.initState();
    setState(() {
      videoController = VideoPlayerController.network(widget.videoUrl);
      chewieController = ChewieController(
          videoPlayerController: videoController,
          aspectRatio: 3 / 2,
          autoPlay: false,
          autoInitialize: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.pause();
    videoController.pause();

    chewieController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DigiPMProvider>(builder: (context, digiPM, __) {
      // print(digiPM.selectedTasklist);
      return Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Text(
              "Picture",
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Container(
                height: 400,
                color: Colors.grey,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          height: 400,
                          child: digiPM.selectedTasklist['pict_path'] == null
                              ? Image.network(
                                  "http://159.65.143.55/zara/assets/img/not_found.jpg",
                                  fit: BoxFit.cover)
                              : Image.network(
                                  Api.BASE_URL +
                                      '/' +
                                      digiPM.selectedTasklist['pict_path'],
                                  fit: BoxFit.none),
                        ))
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Text(
              "Procedure",
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Container(
                height: 500,
                color: Colors.grey,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: checkSOPFile(digiPM),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                height: 500,
                                child: determinePDFFile(
                                    digiPM.selectedTasklist['sop_file_path'])))
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Center(
              child: FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfViewerAssignment(
                              pdfPath:
                                  digiPM.selectedTasklist['sop_file_path'])));
                },
                icon: Icon(Icons.insert_drive_file, color: Colors.white),
                label: Text("View PDF"),
                padding:
                    EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Text(
              "Video",
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            setVideo(digiPM),
          ],
        ),
      );
    });
  }

  Future<Uint8List> fetchPost(String path) async {
    if (path == null) {
      final response =
          await http.get('http://www.africau.edu/images/default/sample.pdf');
      final responseJson = response.bodyBytes;

      return responseJson;
    } else {
      final response = await http.get(path);
      final responseJson = response.bodyBytes;

      return responseJson;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();


    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Widget determinePDFFile(url) {
    if (path == null) {
      return FutureBuilder(
        future: loadPdf(url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Text("-");
//              return PdfViewer(
//                filePath: path,
//              );
            } else {
              return Text("Loading...");
            }
          } else {
            return Text("-");
          }
        },
      );
    } else {
      return Text("-");
//      return PdfViewer(
//        filePath: path,
//      );
    }
  }

  Future<bool> loadPdf(url) async {
    await writeCounter(await fetchPost(url));
    var localPath = (await _localFile).path;

    setState(() {
      path = localPath;
    });

    return true;
  }

  Widget checkSOPFile(DigiPMProvider digiPM) {
    if (digiPM.selectedTasklist['sop_file_path'] == null) {
      return Image.network(
          "http://159.65.143.55/zara/assets/img/file-not-found.jpg",
          fit: BoxFit.cover);
    } else {
      return Icon(
        Icons.insert_drive_file,
        color: Colors.white,
        size: 100,
      );
    }
  }

  Widget setVideo(DigiPMProvider digiPM) {
    return Chewie(
      controller: chewieController,
    );
  }
}
