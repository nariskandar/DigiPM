import 'package:digi_pm_skin/api/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewerAssignment extends StatefulWidget {
  final pdfPath;

  PdfViewerAssignment({Key key, @required this.pdfPath}) : super(key: key);

  @override
  _PdfViewerAssignmentState createState() => new _PdfViewerAssignmentState();
}

class _PdfViewerAssignmentState extends State<PdfViewerAssignment> {
  var _doc;

  @override
  void initState() {
    super.initState();
    setPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PDF VIEWER'),
        ),
        body: Container(
            child: _doc == null
                ? Center(child: Text("Loading..."))
                : PDFViewer(
                    document: _doc,
                  )));
  }

  void setPdf() async {
    PDFDocument doc =
        await PDFDocument.fromURL(Api.BASE_URL + '/' + widget.pdfPath);
    setState(() {
      _doc = doc;
    });
  }
}
