import 'package:timing_app/cached_orders_data_source.dart';

class OrdersRepository {
  final OrdersDataSource dataSource;
  final CachedOrdersDataSource? cacheDataSource;

  OrdersRepository({required this.dataSource, this.cacheDataSource});

  Future<List<Order>> getOrders() async {
    final List<Order> orders;
    if (cacheDataSource == null) {
      orders = await dataSource.getOrders();
    } else {
      final cachedOrders = await cacheDataSource!.getOrders();
      if (cachedOrders == null) {
        orders = await dataSource.getOrders();
        await cacheDataSource!.storeOrders(orders);
      } else {
        orders = cachedOrders;
      }
    }
    return orders;
  }

  /*Future<List<Order>> getOrders() async {
    if (cacheDataSource == null) {
      return await dataSource.getOrders();
    } else {
      final cachedResults = await cacheDataSource!.getOrders();
      if (cachedResults == null) {
        return await dataSource.getOrders();
      } else {
        return cachedResults;
      }
    }
  }*/
}

abstract class OrdersDataSource {
  Future<List<Order>> getOrders();
}
