// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billViewModelHash() => r'47b43e58620decf38939c2e7f66d47206ec6029a';

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

abstract class _$BillViewModel
    extends BuildlessAutoDisposeAsyncNotifier<BillDto> {
  late final String billId;

  FutureOr<BillDto> build(String billId);
}

/// See also [BillViewModel].
@ProviderFor(BillViewModel)
const billViewModelProvider = BillViewModelFamily();

/// See also [BillViewModel].
class BillViewModelFamily extends Family<AsyncValue<BillDto>> {
  /// See also [BillViewModel].
  const BillViewModelFamily();

  /// See also [BillViewModel].
  BillViewModelProvider call(String billId) {
    return BillViewModelProvider(billId);
  }

  @override
  BillViewModelProvider getProviderOverride(
    covariant BillViewModelProvider provider,
  ) {
    return call(provider.billId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billViewModelProvider';
}

/// See also [BillViewModel].
class BillViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BillViewModel, BillDto> {
  /// See also [BillViewModel].
  BillViewModelProvider(String billId)
    : this._internal(
        () => BillViewModel()..billId = billId,
        from: billViewModelProvider,
        name: r'billViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billViewModelHash,
        dependencies: BillViewModelFamily._dependencies,
        allTransitiveDependencies:
            BillViewModelFamily._allTransitiveDependencies,
        billId: billId,
      );

  BillViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billId,
  }) : super.internal();

  final String billId;

  @override
  FutureOr<BillDto> runNotifierBuild(covariant BillViewModel notifier) {
    return notifier.build(billId);
  }

  @override
  Override overrideWith(BillViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: BillViewModelProvider._internal(
        () => create()..billId = billId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billId: billId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BillViewModel, BillDto>
  createElement() {
    return _BillViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillViewModelProvider && other.billId == billId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillViewModelRef on AutoDisposeAsyncNotifierProviderRef<BillDto> {
  /// The parameter `billId` of this provider.
  String get billId;
}

class _BillViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BillViewModel, BillDto>
    with BillViewModelRef {
  _BillViewModelProviderElement(super.provider);

  @override
  String get billId => (origin as BillViewModelProvider).billId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
