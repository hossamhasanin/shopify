import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:pay/controller.dart';
import 'package:shopify/widgets/pay/components/put_address_screen.dart';

class AddressItem extends StatelessWidget {
  final Address _address;
  final Address _groupValue;
  final Function(Address) _setGroupValue;
  final ValueKey key;
  final PayController _controller = Get.find();
  AddressItem(
      {required Address address,
      required Address groupValue,
      required Function(Address) setGroupValue,
      required this.key})
      : this._address = address,
        this._groupValue = groupValue,
        this._setGroupValue = setGroupValue,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio<Address>(
          value: _address,
          groupValue: _groupValue,
          onChanged: (value) {
            if (value != null) {
              debugPrint("address item " + value.toString());
              _setGroupValue(value);
            }
          }),
      title: Text(_address.toString(), style: TextStyle(color: Colors.black)),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            Get.defaultDialog(title: "Modify", content: buildEditPopWindow());
          }),
    );
  }

  Widget buildEditPopWindow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                Get.back();
                Address address = await Get.toNamed(PutAddressScreen.routeName,
                    arguments: _address);
                debugPrint("cur add is " + address.id);
                _controller.updateAddress(address);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Colors.green),
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(
            width: 20.0,
          ),
          ElevatedButton(
              onPressed: () {
                Get.back();

                _controller.deleteAddress(_address);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Colors.red),
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
