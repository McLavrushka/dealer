import 'package:dio/dio.dart';

import '../../../core/network/api_config.dart';
import '../domain/set_splits_use_case.dart';
import 'bill_repository.dart';
import 'models/add_bill_item_request.dart';
import 'models/bill_dto.dart';
import 'models/bill_item_dto.dart';
import 'models/create_bill_request.dart';
import 'models/patch_bill_item_request.dart';

class BillRepositoryImpl implements BillRepository {
  BillRepositoryImpl(this._dio);

  final Dio _dio;

  static String _bill(String id) => '${ApiConfig.apiV1}/bills/$id';
  static String _item(String billId, String itemId) =>
      '${ApiConfig.apiV1}/bills/$billId/items/$itemId';

  @override
  Future<BillDto> create(CreateBillRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/bills',
      data: request.toJson(),
    );
    return BillDto.fromJson(response.data!);
  }

  @override
  Future<BillDto> get(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(_bill(id));
    return BillDto.fromJson(response.data!);
  }

  @override
  Future<BillDto> patch(String id, {String? title, String? spunWinnerId}) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (spunWinnerId != null) data['spunWinnerId'] = spunWinnerId;
    if (data.isEmpty) {
      return get(id);
    }
    final response = await _dio.patch<Map<String, dynamic>>(
      _bill(id),
      data: data,
    );
    return BillDto.fromJson(response.data!);
  }

  @override
  Future<void> delete(String id) => _dio.delete<void>(_bill(id));

  @override
  Future<BillDto> settle(String id) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '${_bill(id)}/settle',
    );
    return BillDto.fromJson(response.data!);
  }

  @override
  Future<BillItemDto> addItem(String billId, AddBillItemRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_bill(billId)}/items',
      data: request.toJson(),
    );
    return BillItemDto.fromJson(response.data!);
  }

  @override
  Future<BillItemDto> patchItem(
    String billId,
    String itemId,
    PatchBillItemRequest request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      _item(billId, itemId),
      data: {
        'name': ?request.name,
        'price': ?request.price,
        'quantity': ?request.quantity,
      },
    );
    return BillItemDto.fromJson(response.data!);
  }

  @override
  Future<void> deleteItem(String billId, String itemId) =>
      _dio.delete<void>(_item(billId, itemId));

  @override
  Future<void> submitSplits(String billId, List<SplitSubmitRow> splits) async {
    await _dio.post<void>(
      '${_bill(billId)}/splits',
      data: {
        'splits': splits.map((e) => e.toJson()).toList(),
      },
    );
  }
}
