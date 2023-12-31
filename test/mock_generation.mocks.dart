// Mocks generated by Mockito 5.4.2 from annotations
// in timing_app/test/mock_generation.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:timing_app/cached_orders_data_source.dart' as _i4;
import 'package:timing_app/orders_repository.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [OrdersDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockOrdersDataSource extends _i1.Mock implements _i2.OrdersDataSource {
  MockOrdersDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Order>> getOrders() => (super.noSuchMethod(
        Invocation.method(
          #getOrders,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Order>>.value(<_i4.Order>[]),
      ) as _i3.Future<List<_i4.Order>>);
}

/// A class which mocks [CachedOrdersDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockCachedOrdersDataSource extends _i1.Mock
    implements _i4.CachedOrdersDataSource {
  MockCachedOrdersDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Order>?> getOrders() => (super.noSuchMethod(
        Invocation.method(
          #getOrders,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Order>?>.value(),
      ) as _i3.Future<List<_i4.Order>?>);
  @override
  _i3.Future<void> storeOrders(List<_i4.Order>? orders) => (super.noSuchMethod(
        Invocation.method(
          #storeOrders,
          [orders],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
