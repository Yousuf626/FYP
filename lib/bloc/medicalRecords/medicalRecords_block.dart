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
      await _getRecord(emit);
    });
  }

  Future<void> _getRecord(Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      final List<UserReport> records = await recordsRepository.getUserRecords();
      emit(RecordLoaded(records: records));
    } catch (e) {
      emit(RecordError(errorMsg: e.toString()));
    }
  }
}
