import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_products.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(
              cartProduct.productData!.images![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cartProduct.productData!.title!,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Tamanho: ${cartProduct.size}",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  "R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: cartProduct.quantity! < 1
                          ? null
                          : () {
                              CartModel.of(context).decProduct(cartProduct);
                            },
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      onPressed: () {
                        CartModel.of(context).incProduct(cartProduct);
                      },
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        "Remover",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ))
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(cartProduct.category)
                  .collection("items")
                  .doc(cartProduct.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cartProduct.productData =
                      ProductData.fromDocument(snapshot.data!);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
