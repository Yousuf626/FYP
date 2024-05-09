// // ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../models/report.dart';
import '../navigation/bottomNavigationBar.dart';
import '../navigation/appDrawer.dart';
import 'dart:async';


class ViewReport extends StatefulWidget {
   final MedicalRecord  report;
  const ViewReport({Key? key, required this.report}) : super(key: key);

  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> with RouteAware {
  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: BaseMenuBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                    color: Color(0xFF01888B),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        widget.report.filename,
                        style: const TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 80.0),
              
              Image.memory(widget.report.data),
            ],
          ),
          const Positioned(
            top: 60,
            left: 20,
            child: BackButton(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
// import 'dart:html' as html;

// class _ViewReportState extends State<ViewReport> with RouteAware {
//   String? imageUrl;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     createImageUrl(widget.report.image).then((url) {
//       setState(() {
//         imageUrl = url;
//       });
//     }).catchError((e) {
//       setState(() {
//         error = e.toString();
//       });
//     });
//   }

//   Future<String> createImageUrl(html.Blob image) async {
//     final completer = Completer<String>();
//     final reader = html.FileReader();
//     // final blob = html.Blob(image);
//     reader.readAsDataUrl(image);
//     reader.onError.listen((error) => completer.completeError(error));
//     reader.onLoadEnd.listen((e) => completer.complete(reader.result as String));
//     return completer.future;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (error != null) {
//       return Text('Error loading image: $error');
//     } else if (imageUrl != null) {
//       return Image.network(imageUrl!);
//     } else {
//       return CircularProgressIndicator();
//     }
//   }
// }
