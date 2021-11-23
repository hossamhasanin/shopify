import 'package:cat_items/datasource.dart';
import 'package:cat_items/repository.dart';
import 'package:flutter/material.dart';
import 'package:models/product.dart';

class RepositoryImpl implements CatItemsRepo {
  final CatItemsDatasource _networkDatasource;
  final CatItemsDatasource _cashDataSource;

  const RepositoryImpl(
      {required CatItemsDatasource networkDatasource,
      required CatItemsDatasource cashDataSource})
      : this._networkDatasource = networkDatasource,
        this._cashDataSource = cashDataSource;

  @override
  Future<List<Product>> getCatItems(String catId, String lastId) async {
    try {
      var items = await _networkDatasource.getItems(catId, lastId);
      await _cashDataSource.cashItems(items);
      debugPrint("repo num items " + items.length.toString());
      return items;
    } catch (e) {
      return _cashDataSource.getItems(catId, lastId);
    }
  }
}
