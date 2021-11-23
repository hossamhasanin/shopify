import 'package:models/models.dart';

abstract class PayDatasource {
  Future<List<Address>> getAddresses();
  Future addAddress(Address address);
  Future deleteAddress(Address address);
  Future upadateAddress(Address address);

  Future addOrder(Order order, List<Code> codes);
}
