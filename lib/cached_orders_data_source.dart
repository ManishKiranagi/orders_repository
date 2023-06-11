import 'dart:async';
import 'package:clock/clock.dart';

class CachedOrdersDataSourceInMemory implements CachedOrdersDataSource {
  List<Order>? _cachedOrders;
  DateTime _expirationTime;
  final Duration expirationDuration;

  CachedOrdersDataSourceInMemory(this.expirationDuration)
      : _expirationTime = clock.now().add(expirationDuration);

  @override
  Future<List<Order>?> getOrders() {
    if (clock.now().isAfter(_expirationTime)) {
      // Cache has expired, return null result
      return Future.value(null);
    } else {
      return Future.value(_cachedOrders);
    }
  }

  @override
  Future<void> storeOrders(List<Order> orders) {
    _cachedOrders = orders;
    _expirationTime = clock.now().add(expirationDuration);
    return Future.value();
  }
}

class Order {}

abstract class CachedOrdersDataSource {
  Future<List<Order>?> getOrders();
  Future<void> storeOrders(List<Order> orders);
}
