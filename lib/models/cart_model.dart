import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_products.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  String? couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  bool isLoading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then(
      (doc) {
        cartProduct.cid = doc.id;
      },
    );
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null)
        price += (c.quantity! * (c.productData!.price!));
    }
    return price;
  }

  double getDiscount() {
    notifyListeners();
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //criando referencia do pedido e incluindo ele na coleção de pedidos do firebase
    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser!.uid,
        "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
        "shipPrice": shipPrice,
        "productsPrice": productsPrice,
        "discount": discount,
        "totalPrice": productsPrice + shipPrice - discount,
        "status": 1
      },
    );

    //criando na coleção usuário, a referencia do pedido dele no firebase
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({"orderId": refOrder.id});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    //Apagando a referencia de cada produto no carrinho
    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
