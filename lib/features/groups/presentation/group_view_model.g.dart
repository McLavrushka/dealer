// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupViewModelHash() => r'4950200760271ab95fccd3608b29d07b31ede4dd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GroupViewModel
    extends BuildlessAutoDisposeAsyncNotifier<GroupScreenState> {
  late final String groupId;

  FutureOr<GroupScreenState> build(String groupId);
}

/// See also [GroupViewModel].
@ProviderFor(GroupViewModel)
const groupViewModelProvider = GroupViewModelFamily();

/// See also [GroupViewModel].
class GroupViewModelFamily extends Family<AsyncValue<GroupScreenState>> {
  /// See also [GroupViewModel].
  const GroupViewModelFamily();

  /// See also [GroupViewModel].
  GroupViewModelProvider call(String groupId) {
    return GroupViewModelProvider(groupId);
  }

  @override
  GroupViewModelProvider getProviderOverride(
    covariant GroupViewModelProvider provider,
  ) {
    return call(provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupViewModelProvider';
}

/// See also [GroupViewModel].
class GroupViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<GroupViewModel, GroupScreenState> {
  /// See also [GroupViewModel].
  GroupViewModelProvider(String groupId)
    : this._internal(
        () => GroupViewModel()..groupId = groupId,
        from: groupViewModelProvider,
        name: r'groupViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupViewModelHash,
        dependencies: GroupViewModelFamily._dependencies,
        allTransitiveDependencies:
            GroupViewModelFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  GroupViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<GroupScreenState> runNotifierBuild(
    covariant GroupViewModel notifier,
  ) {
    return notifier.build(groupId);
  }

  @override
  Override overrideWith(GroupViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: GroupViewModelProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GroupViewModel, GroupScreenState>
  createElement() {
    return _GroupViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupViewModelProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<GroupScreenState> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          GroupViewModel,
          GroupScreenState
        >
    with GroupViewModelRef {
  _GroupViewModelProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupViewModelProvider).groupId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
