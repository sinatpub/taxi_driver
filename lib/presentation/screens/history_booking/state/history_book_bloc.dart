import 'package:bloc/bloc.dart';
import 'package:com.tara_driver_application/data/datasources/get_booking_history.dart';
import 'package:com.tara_driver_application/data/models/history_driver_info_model.dart';
import 'package:meta/meta.dart';

class HistoryBookBloc extends Bloc<HistoryBookEvent, HistoryBookState> {
  int currentPage = 1;
  int status = 4;
  int totalPages = 1;
  bool isFetching = false;
  List<DataHistory> allItems = [];
  HistoryBookBloc({required this.status}) : super(HistoryBookInitial()) {
    on<FetchPaginatedData>(_onFetchData);
    on<RefreshPaginatedData>(_onRefreshData);
    on<RefreshPaginatedCancelData>(_onRefreshCencelData);
  }
  Future<void> _onFetchData(
      FetchPaginatedData event, Emitter<HistoryBookState> emit) async {
    if (isFetching) return;
    isFetching = true;

    if (state is HistoryBookInitial) {
      emit(HistoryBookLoading());
    }

    try {
      final newItems = await GetBopkingHistory.getHistoryBookApi(page: "$currentPage",status: "$status");
      if (newItems.data!.isEmpty) {
        emit(HistoryBookLoaded(items: allItems, hasReachedMax: true));
      } else {
        currentPage++;
        totalPages = newItems.total!;
        allItems.addAll(newItems.data!);
        emit(HistoryBookLoaded(items: allItems, hasReachedMax: false));
      }
    } catch (e) {
      emit(HistoryBookError("Failed to load data"));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onRefreshData(
      RefreshPaginatedData event, Emitter<HistoryBookState> emit) async {
    isFetching = true;
    currentPage = 1;
    allItems.clear();

    try {
      final response = await GetBopkingHistory.getHistoryBookApi(page: "$currentPage",status: "4");
      currentPage++;
      totalPages = response.total!;
      allItems.addAll(response.data!);

      emit(HistoryBookLoaded(items: allItems, hasReachedMax: currentPage > totalPages));
    } catch (e) {
      emit(HistoryBookError("Failed to refresh data"));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onRefreshCencelData(
      RefreshPaginatedCancelData event, Emitter<HistoryBookState> emit) async {
    isFetching = true;
    currentPage = 1;
    allItems.clear();

    try {
      final response = await GetBopkingHistory.getHistoryBookApi(page: "$currentPage",status: "5");
      currentPage++;
      totalPages = response.total!;
      allItems.addAll(response.data!);

      emit(HistoryBookLoaded(items: allItems, hasReachedMax: currentPage > totalPages));
    } catch (e) {
      emit(HistoryBookError("Failed to refresh data"));
    } finally {
      isFetching = false;
    }
  }
}



// =========  state =======================

@immutable
sealed class HistoryBookState {}

final class HistoryBookInitial extends HistoryBookState {}

class HistoryBookLoading extends HistoryBookState {}

class HistoryBookLoaded extends HistoryBookState {
  final List<DataHistory> items;
  final bool hasReachedMax;

  HistoryBookLoaded({required this.items, required this.hasReachedMax});
}

class HistoryBookError extends HistoryBookState {
  final String message;
  HistoryBookError(this.message);
}


//============== Event =====================


@immutable
sealed class HistoryBookEvent {}

class FetchPaginatedData extends HistoryBookEvent {}
class RefreshPaginatedData extends HistoryBookEvent {}
class RefreshPaginatedCancelData extends HistoryBookEvent {}