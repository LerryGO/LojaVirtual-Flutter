import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_products.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  final ProductData product;
  String? size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title.toString()),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: false,
                  aspectRatio: 1.0,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: product.images!.map((e) {
                  return Image.network(e, fit: BoxFit.cover);
                }).toList()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: product.images!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: 16),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal, //Deixando na horizontal
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    children: product.sizes!.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                                color: s == size
                                    ? primaryColor
                                    : Colors.grey.shade500,
                                width: 3),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: size != null
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              //adicionar ao carrinho
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = size;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;
                              cartProduct.productData = product;
                              CartModel.of(context).addCartItem(cartProduct);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho."
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
