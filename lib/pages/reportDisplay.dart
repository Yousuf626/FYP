// ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
import 'package:aap_dev_project/models/report.dart';
import 'package:flutter/material.dart';
import 'bottomNavigationBar.dart';
import 'appDrawer.dart';

class ViewReport extends StatefulWidget {
  final UserReport? report;
  const ViewReport({Key? key, this.report}) : super(key: key);

  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              color: Color(0xFF01888B),
            ),
            child: Center(
              child: Text(
                widget.report!.type,
                style: const TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          Image.network(
            widget.report!.image,
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ]));
  }
}
