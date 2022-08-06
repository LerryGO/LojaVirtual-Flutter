
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 211, 118, 130),
              Color.fromARGB(255, 253, 181, 168)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        );

    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            //Criando a Appbar flutuante
            SliverAppBar(
              floating: true,
              snap: true, //ativando para desaparecer quando deslizar
              backgroundColor: Colors.transparent,
              elevation:
                  0, //Se colocar elevacao acima de 0, criará uma sombra nas laterais
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('home')
                  .orderBy('pos')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else {
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data!.docs.map(
                      (doc) {
                      
                      return StaggeredTile.count(
                        doc["x"].toInt(), doc["y"].toDouble()
                      
                        );
                      },
                    ).toList(),
                    children: snapshot.data!.docs.map(
                      (doc) {
                        return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: doc.get("image"),
                          fit: BoxFit.cover,
                        );
                      },
                    ).toList(),
                  );
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
