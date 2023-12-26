import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_event.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_states.dart';
import 'package:aap_dev_project/core/repository/medicalRecords_repo.dart';
import 'package:aap_dev_project/models/report.dart';
import 'package:bloc/bloc.dart';

class MedicalRecordsBloc extends Bloc<RecordEvent, RecordState> {
  final MedicalRecordsRepository recordsRepository;

  MedicalRecordsBloc({required this.recordsRepository})
      : super(RecordLoading()) {
    on<FetchRecord>((event, emit) async {
      await _getRecord(event.userid, emit);
    });
    on<SetRecord>((event, emit) async {
      await _setRecord(event.report, emit);
    });
  }

  Future<void> _getRecord(String userid, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      final List<UserReport> records =
          await recordsRepository.getUserRecords(userid);
      emit(RecordLoaded(records: records));
    } catch (e) {
      emit(RecordError(errorMsg: e.toString()));
    }
  }

  Future<void> _setRecord(UserReport report, Emitter<RecordState> emit) async {
    emit(RecordSetting());

    try {
      await recordsRepository.uploadUserRecords(report);
      emit(RecordSetSuccess());
    } catch (e) {
      emit(RecordSetError(errorMsg: e.toString()));
    }
  }
}
