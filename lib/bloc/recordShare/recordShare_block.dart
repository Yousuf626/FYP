import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_states.dart';
import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
import 'package:aap_dev_project/models/userSharing.dart';
import 'package:bloc/bloc.dart';

class RecordShareBloc extends Bloc<RecordEvent, RecordState> {
  final RecordsSharingRepository recordsRepository;

  RecordShareBloc({required this.recordsRepository}) : super(RecordLoading()) {
    on<FetchRecord>((event, emit) async {
      await _getRecord(emit);
    });
    on<SetRecord>((event, emit) async {
      await _setRecord(emit);
    });
  }

  Future<void> _getRecord(Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      final List<UserSharing> records =
          await recordsRepository.getSharedRecords();
      emit(RecordLoaded(records: records));
    } catch (e) {
      emit(RecordError(errorMsg: e.toString()));
    }
  }

  Future<void> _setRecord(Emitter<RecordState> emit) async {
    emit(RecordSetting());

    try {
      await recordsRepository.removerUserFromShared();
      emit(RecordSetSuccess());
    } catch (e) {
      emit(RecordSetError(errorMsg: e.toString()));
    }
  }
}
