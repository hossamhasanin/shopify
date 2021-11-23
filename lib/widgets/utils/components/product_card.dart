import 'package:favorites/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/product_details/details_screen.dart';

import '../helpers.dart';

class ProductCard extends StatefulWidget {
  ProductCard(
      {required Key key,
      this.width = 140,
      this.aspectRetio = 1.02,
      required this.product,
      this.isPopular = false})
      : super(key: key);

  final double width, aspectRetio;
  Product product;
  final bool isPopular;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(widget.width),
        child: GestureDetector(
          // onTap: () => Navigator.pushNamed(
          //   context,
          //   DetailsScreen.routeName,
          //   arguments: ProductDetailsArguments(product: product),
          // ),
          onTap: () {
            debugPrint("static carts " + Cart.carts.length.toString());
            Get.toNamed(DetailsScreen.routeName,
                arguments: Cart.carts.singleWhere(
                    (cart) => cart.product.id == widget.product.id,
                    orElse: () => Cart(
                        product: widget.product,
                        numOfItem: 1,
                        selectedColor: 0)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: widget.isPopular ? 0 : 1,
                child: AspectRatio(
                  aspectRatio: 1.02,
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Hero(
                      tag: widget.product.id.toString(),
                      child: Image.network(widget.product.images.first),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.title,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${widget.product.price}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        widget.product = widget.product
                            .copy(isFavourite: !widget.product.isFavourite);
                      });

                      favoritesController
                          .toggelFavorite(widget.product)
                          .then((value) {
                        debugPrint("is done liked " + value.toString());
                        setState(() {
                          widget.product = widget.product.copy(
                              isFavourite: value
                                  ? widget.product.isFavourite
                                  : !widget.product.isFavourite);
                        });
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      height: getProportionateScreenWidth(28),
                      width: getProportionateScreenWidth(28),
                      decoration: BoxDecoration(
                        color: widget.product.isFavourite
                            ? kPrimaryColor.withOpacity(0.15)
                            : kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        color: widget.product.isFavourite
                            ? Color(0xFFFF4848)
                            : Color(0xFFDBDEE4),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
