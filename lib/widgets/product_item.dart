import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String title;
  // final String id;

  static const namedRoutes = '/product-detail';

  //ProductItem(this.imageUrl, this.id, this.title);

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context,listen:false);

    //in the above we can use listen=false only when we are using Consumer Widget hence consumer always listens

    //Consumer can allow only a part of widget to rebuild instead of rebuilding all the widget hence saving memory

    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
              // onTap: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (ctx) => ProductDetailScreen(title),
              //     ),
              //   );
              // },
              onTap: () => {
                    Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: product.id,
                    )
                  },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/fonts/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              )),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
                //this accesses the nearest scaffold widget
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added Item to Cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
