import 'package:clock/clock.dart';

import 'package:test/test.dart';
import 'package:timing_app/cached_orders_data_source.dart';

void main() {
  group('CachedOrdersDataSourceInMemory tests', () {
    late CachedOrdersDataSourceInMemory dataSource;
    setUp(() {
      final expirationTime = DateTime(2023, 6, 9, 12, 0, 0);

      withClock(Clock.fixed(expirationTime), () {
        dataSource = CachedOrdersDataSourceInMemory(Duration(minutes: 5));
      });
    });

    group('getOrders Tests', () {
      test('getOrders when cache null returns null when cache has not expired',
          () async {
        final currentTime = DateTime(2023, 6, 9, 12, 5, 0);
        withClock(Clock.fixed(currentTime), () async {
          dataSource = CachedOrdersDataSourceInMemory(Duration(minutes: 5));
          final result = await dataSource.getOrders();
          expect(result, isNull);
        });
      });

      test('getOrders when cache null returns null when cache has expired',
          () async {
        final currentTime = DateTime(2023, 6, 9, 12, 5, 0, 1);
        withClock(Clock.fixed(currentTime), () async {
          dataSource = CachedOrdersDataSourceInMemory(Duration(minutes: 5));
          final result = await dataSource.getOrders();
          expect(result, isNull);
        });
      });

      test(
          'getOrders when cache has orders returns null when cache has expired',
          () async {
        final ordersStoredTime = DateTime(2023, 6, 9, 12, 0, 0);
        final ordersGetTime = DateTime(2023, 6, 9, 12, 5, 0, 1);
        final orders = [Order()];
        withClock(Clock.fixed(ordersStoredTime), () async {
          await dataSource.storeOrders(orders);
        });
        withClock(Clock.fixed(ordersGetTime), () async {
          final result = await dataSource.getOrders();
          expect(result, isNull);
        });
      });

      test(
          'getOrders when cache has orders returns orders when cache has not expired',
          () async {
        final ordersStoredTime = DateTime(2023, 6, 9, 12, 0, 0);
        final ordersGetTime = DateTime(2023, 6, 9, 12, 5, 0);
        final orders = [Order()];
        withClock(Clock.fixed(ordersStoredTime), () async {
          await dataSource.storeOrders(orders);
        });
        withClock(Clock.fixed(ordersGetTime), () async {
          final result = await dataSource.getOrders();
          expect(result, isNotNull);
        });
      });
    });

    group('storeOrders Tests', () {
      test('storeOrders when cache null stores the orders', () async {
        final ordersStoredTime = DateTime(2023, 6, 9, 12, 0, 0);
        final ordersGetTime = DateTime(2023, 6, 9, 12, 1, 0);
        final orders = [Order()];
        withClock(Clock.fixed(ordersStoredTime), () async {
          await dataSource.storeOrders(orders);
        });
        withClock(Clock.fixed(ordersGetTime), () async {
          final result = await dataSource.getOrders();
          expect(result, equals(orders));
        });
      });

      test('storeOrders when cache has orders stores the new orders', () async {
        final originalOrdersStoredTime = DateTime(2023, 6, 9, 12, 0, 0);
        final originalOrders = [Order()];

        final newOrdersStoredTime = DateTime(2023, 6, 9, 12, 1, 0);
        final newOrders = [Order()];

        final ordersGetTime = DateTime(2023, 6, 9, 12, 2, 0);
        withClock(Clock.fixed(originalOrdersStoredTime), () async {
          await dataSource.storeOrders(originalOrders);
        });

        withClock(Clock.fixed(newOrdersStoredTime), () async {
          await dataSource.storeOrders(newOrders);
        });

        withClock(Clock.fixed(ordersGetTime), () async {
          final result = await dataSource.getOrders();
          expect(result, equals(newOrders));
          expect(result, isNot(equals(originalOrders)));
        });
      });

      test('storeOrders updates the expiration time', () async {
        //From setup we know that the original expiration time is after DateTime(2023, 6, 9, 12, 5, 0);
        //Storing the orders at DateTime(2023, 6, 9, 12, 1, 0 we expect the stored orders to be available after after DateTime(2023, 6, 9, 12, 5, 0)
        //So getting the orders at DateTime(2023, 6, 9, 12, 6, 0) shows that the expiration time has been updated
        final ordersStoredTime = DateTime(2023, 6, 9, 12, 1, 0);
        final ordersGetTime = DateTime(2023, 6, 9, 12, 6, 0);
        final orders = [Order()];
        withClock(Clock.fixed(ordersStoredTime), () async {
          await dataSource.storeOrders(orders);
        });
        withClock(Clock.fixed(ordersGetTime), () async {
          final result = await dataSource.getOrders();
          expect(result, equals(orders));
        });
      });
    });
  });
}
