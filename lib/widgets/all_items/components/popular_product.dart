import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/cat_items/cat_items_screen.dart';
import 'package:shopify/widgets/utils/components/product_card.dart';
import 'package:shopify/widgets/utils/helpers.dart';
import 'package:models/models.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  List<Product> products;
  PopularProducts({required this.products});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Popular Products",
              press: () {
                Get.toNamed(CatItemsScreen.routeName, arguments: null);
              }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                products.length,
                (index) {
                  print(products[index].title);
                  if (products[index].isPopular)
                    return ProductCard(
                      key: ObjectKey(products[index]),
                      product: products[index],
                      isPopular: true,
                    );

                  return SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
