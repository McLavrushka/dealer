import 'models/add_bill_item_request.dart';
import 'models/bill_dto.dart';
import 'models/bill_item_dto.dart';
import 'models/create_bill_request.dart';
import 'models/patch_bill_item_request.dart';

import '../domain/set_splits_use_case.dart';

abstract interface class BillRepository {
  Future<BillDto> create(CreateBillRequest request);
  Future<BillDto> get(String id);
  Future<BillDto> patch(String id, {String? title, String? spunWinnerId});
  Future<void> delete(String id);
  Future<BillDto> settle(String id);

  Future<BillItemDto> addItem(String billId, AddBillItemRequest request);
  Future<BillItemDto> patchItem(
    String billId,
    String itemId,
    PatchBillItemRequest request,
  );
  Future<void> deleteItem(String billId, String itemId);

  Future<void> submitSplits(String billId, List<SplitSubmitRow> splits);
}
