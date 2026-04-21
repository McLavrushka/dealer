import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'bill_repository.dart';
import 'bill_repository_impl.dart';

part 'bill_providers.g.dart';

@riverpod
BillRepository billRepository(BillRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return BillRepositoryImpl(dio);
}
