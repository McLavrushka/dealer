import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/bill_providers.dart';
import '../data/models/add_bill_item_request.dart';
import '../data/models/bill_dto.dart';
import '../data/models/patch_bill_item_request.dart';
import '../domain/set_splits_use_case.dart';

part 'bill_view_model.g.dart';

@riverpod
class BillViewModel extends _$BillViewModel {
  @override
  Future<BillDto> build(String billId) async {
    final repo = ref.watch(billRepositoryProvider);
    return repo.get(billId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(billId));
  }

  Future<void> addItem(AddBillItemRequest request) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(billRepositoryProvider);
      await repo.addItem(billId, request);
      return repo.get(billId);
    });
  }

  Future<void> updateItem(
    String itemId,
    PatchBillItemRequest request,
  ) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(billRepositoryProvider);
      await repo.patchItem(billId, itemId, request);
      return repo.get(billId);
    });
  }

  Future<void> deleteItem(String itemId) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(billRepositoryProvider);
      await repo.deleteItem(billId, itemId);
      return repo.get(billId);
    });
  }

  Future<void> submitSplits(List<SplitSubmitRow> rows) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(billRepositoryProvider);
      await repo.submitSplits(billId, rows);
      return repo.get(billId);
    });
  }

  Future<void> settle() async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(billRepositoryProvider);
      return repo.settle(billId);
    });
  }

  Future<void> setRouletteWinner(String userId) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(billRepositoryProvider);
      final cached = state.valueOrNull;
      if (cached?.spunWinnerId == userId) {
        return cached!;
      }
      if (cached?.spunWinnerId != null) {
        return repo.get(billId);
      }

      try {
        await repo.patch(billId, spunWinnerId: userId);
      } on DioException catch (e) {
        // Server often returns 409 when the winner is already persisted (retry,
        // double submit, or another client). Recover from GET instead of failing UI.
        if (e.response?.statusCode == 409) {
          final bill = await repo.get(billId);
          if (bill.spunWinnerId != null) {
            return bill;
          }
        }
        rethrow;
      }
      return repo.get(billId);
    });
  }
}
