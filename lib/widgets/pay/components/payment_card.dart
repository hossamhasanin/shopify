import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PaymentCard extends StatelessWidget {
  final PaymentEnum _value;
  final PaymentEnum _groupValue;
  final Function(PaymentEnum) _onChanged;
  PaymentCard(
      {required PaymentEnum value,
      required PaymentEnum groupValue,
      required Function(PaymentEnum) onChanged})
      : this._groupValue = groupValue,
        this._value = value,
        this._onChanged = onChanged;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onChanged(_value);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: _value == _groupValue
                ? Border.all(width: 2.0, color: Colors.orange)
                : null,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: _value == _groupValue
                ? [
                    BoxShadow(
                        color: Colors.orange,
                        blurRadius: 0.2,
                        offset: Offset(0.0, 2.0))
                  ]
                : [BoxShadow(color: Colors.grey, blurRadius: 5.0)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pay when delivered",
              style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
