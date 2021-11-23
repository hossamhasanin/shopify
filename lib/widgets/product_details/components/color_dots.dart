import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/utils/components/rounded_icon_btn.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class ColorDots extends StatelessWidget {
  const ColorDots(
      {required this.product,
      required this.numOfItem,
      required this.addItem,
      required this.removeItem,
      required this.selectedColor,
      required this.selectColor});

  final Product product;
  final int numOfItem;
  final Function() addItem;
  final Function() removeItem;
  final Function(int) selectColor;
  final int selectedColor;

  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        children: [
          ...List.generate(
            product.colors.length,
            (index) => GestureDetector(
              onTap: () => selectColor(product.colors[index]),
              child: ColorDot(
                color: Color(product.colors[index]),
                isSelected: selectedColor == 0 && index == 0
                    ? true
                    : product.colors[index] == selectedColor,
              ),
            ),
          ),
          Spacer(),
          RoundedIconBtn(
            icon: Icons.remove,
            press: removeItem,
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          Text(numOfItem.toString()),
          SizedBox(width: getProportionateScreenWidth(10)),
          RoundedIconBtn(
            icon: Icons.add,
            showShadow: true,
            press: addItem,
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    required this.color,
    this.isSelected = false,
  });

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? kPrimaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
