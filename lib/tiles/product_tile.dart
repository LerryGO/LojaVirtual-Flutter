import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      product.images![0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            product.title.toString(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow
                                .ellipsis, //Quando o texto é muito longo é adicionado os  '...'
                          ),
                          Text(
                            "R\$ ${product.price!.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      product.images![0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title.toString(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            //overflow: TextOverflow
                            //    .ellipsis, //Quando o texto é muito longo é adicionado os  '...'
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "R\$ ${product.price!.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
