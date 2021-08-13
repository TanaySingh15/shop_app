import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'product_item.dart';
import 'package:provider/provider.dart';

//import '../screens/products_overview_screen.dart';
class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
            // products[index].imageUrl,
            // products[index].id,
            // products[index].title,
            ),
      ),
      itemCount: products.length,
    );
  }
}
