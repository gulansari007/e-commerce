import 'package:e_commerce/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Cart",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.cartItems.isEmpty) {
              return Center(
                child: Text("Your cart is empty"),
              );
            }

            return ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                var item = cartProvider.cartItems[index];
                return CartItemWidget(item: item);
              },
            );
          },
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.cartItems.isEmpty) {
              return SizedBox.shrink();
            }

            double total = cartProvider.cartItems.fold(0.0, (sum, item) {
              return sum + (item.product.price * item.quantity);
            });

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Total: \$${total.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Proceeding to checkout"),
                      ));
                    },
                    child: Text("Checkout"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final item;

  const CartItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: Image.network(
          item.product.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(item.product.title),
        subtitle: Text(
            "\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}"),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle),
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false)
                .removeFromCart(item);
          },
        ),
      ),
    );
  }
}
