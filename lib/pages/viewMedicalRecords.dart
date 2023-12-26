// ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_block.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_event.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_states.dart';
import 'package:aap_dev_project/core/repository/medicalRecords_repo.dart';
import 'package:aap_dev_project/pages/reportDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottomNavigationBar.dart';
import 'appDrawer.dart';

class ViewRecords extends StatefulWidget {
  const ViewRecords({Key? key}) : super(key: key);

  @override
  _ViewRecordsState createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecords> {
  final MedicalRecordsRepository recordsRepository = MedicalRecordsRepository();
  late MedicalRecordsBloc _recordsBloc;

  @override
  void initState() {
    super.initState();
    _recordsBloc = MedicalRecordsBloc(recordsRepository: recordsRepository);
    _recordsBloc.add(const FetchRecord());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: BlocBuilder(
            bloc: _recordsBloc,
            builder: (_, RecordState state) {
              if (state is RecordEmpty) {
                return const Center(child: Text('Empty state'));
              }
              if (state is RecordLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RecordLoaded) {
                return Column(children: [
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
                    child: const Center(
                      child: Text(
                        'Your Medical Records',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: ListView.builder(
                          itemCount: state.records.length,
                          itemBuilder: (BuildContext context, int index) {
                            final record = state.records[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewReport(
                                          report: state.records[index])),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCCE7E8),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 4),
                                      blurRadius: 1.0,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      record.type,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF01888B),
                                      ),
                                    ),
                                    Text(
                                      record.createdAt.toString(),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFF01888B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  )
                ]);
              }
              if (state is RecordError) {
                return Center(child: Text(state.errorMsg!));
              }
              return const Center(child: Text('Unhandled state'));
            }));
  }

  @override
  void dispose() {
    _recordsBloc.close();
    super.dispose();
  }
}
