import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.shade700),
        ),
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu CEP",
              ),
              initialValue: "",
              onFieldSubmitted: (text) {
                
              },
            ),
          )
        ],
      ),
    );
  }
}
