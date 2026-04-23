import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/parse_ocr_use_case.dart';
import '../domain/scan_qr_use_case.dart';

part 'scan_providers.g.dart';

@riverpod
ScanQrUseCase scanQrUseCase(ScanQrUseCaseRef ref) {
  final dio = ref.watch(dioProvider);
  return ScanQrUseCase(dio);
}

@riverpod
ParseOcrUseCase parseOcrUseCase(ParseOcrUseCaseRef ref) {
  return const ParseOcrUseCase();
}
