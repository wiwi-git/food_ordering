
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';
import 'menu_screen.dart';

class OrderCompletionScreen extends StatelessWidget {
  const OrderCompletionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderViewModel>(context, listen: false);
    final cartItems = viewModel.cartItems;
    String summaryText;

    if (cartItems.isEmpty) {
      summaryText = '주문이 완료되었습니다.';
    } else {
      final firstItemName = cartItems.first.food.name;
      final totalCount = viewModel.totalItems;
      summaryText = '$firstItemName 외 ${totalCount -1}가지의 주문이 완료되었습니다.';
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                summaryText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // Reset the order and navigate back to the menu screen
                  viewModel.reset();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('메뉴 화면으로'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
