import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:timing_app/cached_orders_data_source.dart';
import 'package:timing_app/orders_repository.dart';

import 'mock_generation.mocks.dart';

void main() {
  late MockOrdersDataSource ordersDataSource;
  late MockCachedOrdersDataSource cachedOrdersDataSource;

  group('orders repository tests', () {
    setUp(() {
      ordersDataSource = MockOrdersDataSource();
    });

    test('getOrders when cachedordersdatasource is null calls ordersdatasource',
        () async {
      final ordersRepository = OrdersRepository(dataSource: ordersDataSource);
      when(ordersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value([Order()]));

      await ordersRepository.getOrders();

      verify(ordersDataSource.getOrders()).called(1);
    });

    test(
        'getOrders when cachedordersdatasource is null returns orders from ordersdatasource',
        () async {
      final ordersRepository = OrdersRepository(dataSource: ordersDataSource);
      final ordersDataSourceOrders = [Order()];
      when(ordersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(ordersDataSourceOrders));

      final orders = await ordersRepository.getOrders();

      expect(orders, equals(ordersDataSourceOrders));
    });

    test('getOrders calls cachedordersdatasource if it is not null', () async {
      cachedOrdersDataSource = MockCachedOrdersDataSource();
      final ordersRepository = OrdersRepository(
          dataSource: ordersDataSource,
          cacheDataSource: cachedOrdersDataSource);
      when(cachedOrdersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value([Order()]));

      await ordersRepository.getOrders();

      verify(cachedOrdersDataSource.getOrders()).called(1);
    });

    test(
        'getOrders calls ordersdatasource if cachedordersdatasource returns null',
        () async {
      cachedOrdersDataSource = MockCachedOrdersDataSource();
      final ordersRepository = OrdersRepository(
          dataSource: ordersDataSource,
          cacheDataSource: cachedOrdersDataSource);
      when(cachedOrdersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(null));
      final ordersDataSourceOrders = [Order()];
      when(ordersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(ordersDataSourceOrders));
      await ordersRepository.getOrders();
      verify(ordersDataSource.getOrders()).called(1);
    });

    test(
        'getOrders returns ordersdatasource results if cachedordersdatasource returns null',
        () async {
      cachedOrdersDataSource = MockCachedOrdersDataSource();
      final ordersRepository = OrdersRepository(
          dataSource: ordersDataSource,
          cacheDataSource: cachedOrdersDataSource);
      when(cachedOrdersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(null));
      final ordersDataSourceOrders = [Order()];
      when(ordersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(ordersDataSourceOrders));
      final orders = await ordersRepository.getOrders();
      expect(orders, equals(ordersDataSourceOrders));
    });

    test(
        'getOrders calls cachedordersdatasource storeorders if cachedordersdatasource returns null',
        () async {
      cachedOrdersDataSource = MockCachedOrdersDataSource();
      final ordersRepository = OrdersRepository(
          dataSource: ordersDataSource,
          cacheDataSource: cachedOrdersDataSource);
      when(cachedOrdersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(null));

      when(ordersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value([Order()]));

      when(cachedOrdersDataSource.storeOrders(any))
          .thenAnswer((realInvocation) => Future.value());

      final orders = await ordersRepository.getOrders();
      verify(cachedOrdersDataSource.storeOrders(orders)).called(1);
    });

    test(
        'getOrders does not call ordersdatasource if cachedordersdatasource returns data',
        () async {
      cachedOrdersDataSource = MockCachedOrdersDataSource();
      final ordersRepository = OrdersRepository(
          dataSource: ordersDataSource,
          cacheDataSource: cachedOrdersDataSource);
      when(cachedOrdersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value([Order()]));
      final ordersDataSourceOrders = [Order()];
      when(ordersDataSource.getOrders())
          .thenAnswer((realInvocation) => Future.value(ordersDataSourceOrders));
      await ordersRepository.getOrders();
      verifyNever(ordersDataSource.getOrders());
    });

    test('getOrders return cachedordersdatasource data if it is not null',
        () async {
      cachedOrdersDataSource = MockCachedOrdersDataSource();
      final ordersRepository = OrdersRepository(
          dataSource: ordersDataSource,
          cacheDataSource: cachedOrdersDataSource);
      final cachedOrderDataSourceOrders = [Order()];
      when(cachedOrdersDataSource.getOrders()).thenAnswer(
          (realInvocation) => Future.value(cachedOrderDataSourceOrders));

      final orders = await ordersRepository.getOrders();
      expect(orders, equals(cachedOrderDataSourceOrders));
    });
  });
}
