// ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
import 'package:aap_dev_project/models/report.dart';
import 'package:flutter/material.dart';
import '../navigation/bottomNavigationBar.dart';
import '../navigation/appDrawer.dart';

class ViewReport extends StatefulWidget {
  final UserReport? report;
  const ViewReport({Key? key, this.report}) : super(key: key);

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
                        widget.report!.type,
                        style: const TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 80.0),
              Image.network(
                widget.report!.image,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
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
