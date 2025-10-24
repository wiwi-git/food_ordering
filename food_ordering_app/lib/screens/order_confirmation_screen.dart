
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';
import 'order_completion_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 확인'),
      ),
      body: Consumer<OrderViewModel>(
        builder: (context, viewModel, child) {
          final cartItems = viewModel.cartItems;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _buildCartItemTile(context, item, viewModel);
                  },
                ),
              ),
              _buildTotalPrice(context, viewModel),
              _buildConfirmButton(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemTile(BuildContext context, CartItem item, OrderViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          item.food.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
        ),
        title: Text(item.food.name),
        subtitle: Text('${item.food.price}원'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.remove), onPressed: () => viewModel.decrement(item.food)),
            Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
            IconButton(icon: const Icon(Icons.add), onPressed: () => viewModel.increment(item.food)),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPrice(BuildContext context, OrderViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('총액', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('${viewModel.totalPrice.toStringAsFixed(0)}원', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, OrderViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await viewModel.placeOrder();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OrderCompletionScreen()),
            (Route<dynamic> route) => false,
          );
        },
        child: viewModel.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('주문 완료하기'),
      ),
    );
  }
}
