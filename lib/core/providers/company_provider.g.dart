// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companiesHash() => r'f5a6790c70a77251fea18282a67eb3f25be9460b';

/// See also [Companies].
@ProviderFor(Companies)
final companiesProvider =
    AutoDisposeAsyncNotifierProvider<Companies, List<Company>>.internal(
  Companies.new,
  name: r'companiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$companiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Companies = AutoDisposeAsyncNotifier<List<Company>>;
String _$selectedCompanyHash() => r'1756136618175f9eeb84c19e74371c756586ed65';

/// See also [SelectedCompany].
@ProviderFor(SelectedCompany)
final selectedCompanyProvider =
    AutoDisposeNotifierProvider<SelectedCompany, Company?>.internal(
  SelectedCompany.new,
  name: r'selectedCompanyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCompanyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCompany = AutoDisposeNotifier<Company?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
