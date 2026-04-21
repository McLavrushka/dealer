import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'group_repository.dart';
import 'group_repository_impl.dart';
import 'models/group_dto.dart';

part 'group_providers.g.dart';

@riverpod
GroupRepository groupRepository(GroupRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return GroupRepositoryImpl(dio);
}

@riverpod
Future<GroupDto> groupDetail(GroupDetailRef ref, String groupId) async {
  return ref.watch(groupRepositoryProvider).getById(groupId);
}

