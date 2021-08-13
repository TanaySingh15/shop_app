// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/providers/orders.dart';
// import '../providers/cart.dart';
// import '../widgets/cart_item.dart' as CI;

// class CartScreen extends StatelessWidget {
//   static const routeName = '/cart-screen';

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cart>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your Cart"),
//       ),
//       body: Column(
//         children: <Widget>[
//           Card(
//             margin: EdgeInsets.all(15),
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Total",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   Spacer(),
//                   Chip(
//                     label: Text(
//                       "\$${cart.totalAmount}",
//                       style: TextStyle(
//                           color: Theme.of(context)
//                               .primaryTextTheme
//                               .headline6
//                               .color),
//                     ),
//                     backgroundColor: Theme.of(context).accentColor,
//                   ),
//                   OrderButton(cart: cart),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Expanded(
//               child: ListView.builder(
//             itemCount: cart.items.length,
//             itemBuilder: (context, index) => CI.CartItem(
//               cart.items.values.toList()[index].id,
//               cart.items.values.toList()[index].price,
//               cart.items.values.toList()[index].quantity,
//               cart.items.values.toList()[index].title,
//               cart.items.keys.toList()[index],
//             ),
//           ))
//         ],
//       ),
//     );
//   }
// }

// class OrderButton extends StatefulWidget {
//   const OrderButton({
//     Key key,
//     @required this.cart,
//   }) : super(key: key);

//   final Cart cart;

//   @override
//   _OrderButtonState createState() => _OrderButtonState();
// }

// class _OrderButtonState extends State<OrderButton> {
//   var _isLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       child: _isLoaded ? CircularProgressIndicator() : Text("Order Now"),
//       onPressed: (widget.cart.totalAmount <= 0 || _isLoaded)
//           ? null
//           : () async {
//               setState(() {
//                 _isLoaded = false;
//               });
//               await Provider.of<Orders>(context, listen: false).addOrder(
//                   widget.cart.items.values.toList(), widget.cart.totalAmount);
//               widget.cart.clear();
//             },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
                cart.items.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
