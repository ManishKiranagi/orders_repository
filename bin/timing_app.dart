import 'package:timing_app/cached_orders_data_source.dart';

void main(List<String> arguments) async {
  CachedOrdersDataSourceInMemory memoryDataSource =
      CachedOrdersDataSourceInMemory(Duration(seconds: 3));

  memoryDataSource.storeOrders([Order(), Order()]);

  await Future.delayed(Duration(seconds: 2));
  final orders = await memoryDataSource.getOrders();
  print(orders);
}
