
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';
import '../services/api_service.dart';
import '../models/food.dart';
import 'order_confirmation_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Food>> _foodListFuture;

  @override
  void initState() {
    super.initState();
    _foodListFuture = _loadFoods();
  }

  Future<List<Food>> _loadFoods() async {
    final apiResult = await _apiService.getFoodList();
    if (apiResult.success && apiResult.body != null) {
      // Initialize the view model with the food list
      Provider.of<OrderViewModel>(context, listen: false).init(apiResult.body!);
      return apiResult.body!;
    } else {
      // Handle error
      throw Exception('Failed to load food list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴'),
      ),
      body: FutureBuilder<List<Food>>(
        future: _foodListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('메뉴가 없습니다.'));
          }

          return Consumer<OrderViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: viewModel.items.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.items[index];
                        return _buildFoodCell(context, item);
                      },
                    ),
                  ),
                  _buildOrderButton(context, viewModel),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFoodCell(BuildContext context, CartItem item) {
    final viewModel = Provider.of<OrderViewModel>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                item.food.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.remove), onPressed: () => viewModel.decrement(item.food)),
              Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
              IconButton(icon: const Icon(Icons.add), onPressed: () => viewModel.increment(item.food)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderButton(BuildContext context, OrderViewModel viewModel) {
    bool isEnabled = viewModel.totalItems > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: isEnabled ? Theme.of(context).primaryColor : Colors.grey,
        ),
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
                );
              }
            : null,
        child: const Text('주문하기'),
      ),
    );
  }
}
