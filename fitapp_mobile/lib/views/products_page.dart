import 'package:fitapp_mobile/controllers/product_controller.dart';
import 'package:fitapp_mobile/controllers/user_controller.dart';
import 'package:fitapp_mobile/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductController>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produkty'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Błąd: ${controller.error}'),
                  ElevatedButton(
                    onPressed: () => controller.loadProducts(),
                    child: Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(product.productName),
                  subtitle: Text('${product.kcal} kcal'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('P: ${product.proteins}g'),
                      Text('C: ${product.carbs}g'),
                      Text('F: ${product.fats}g'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Dodaj produkt',
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final gramsController = TextEditingController();
    final kcalController = TextEditingController();
    final proteinsController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dodaj nowy produkt'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nazwa produktu'),
              ),
              TextField(
                controller: gramsController,
                decoration: InputDecoration(labelText: 'Gramy'),
              ),
              TextField(
                controller: kcalController,
                decoration: InputDecoration(labelText: 'Kalorie'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: proteinsController,
                decoration: InputDecoration(labelText: 'Białko (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carbsController,
                decoration: InputDecoration(labelText: 'Węglowodany (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fatsController,
                decoration: InputDecoration(labelText: 'Tłuszcze (g)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              final userController = Provider.of<UserController>(context, listen: false);
              final productController = Provider.of<ProductController>(context, listen: false);

              if (userController.currentUser != null && nameController.text.isNotEmpty) {
                final product = Product(
                  id: '',
                  productName: nameController.text,
                  grams: int.tryParse(gramsController.text) ?? 0,
                  kcal: int.tryParse(kcalController.text) ?? 0,
                  proteins: int.tryParse(proteinsController.text) ?? 0,
                  carbs: int.tryParse(carbsController.text) ?? 0,
                  fats: int.tryParse(fatsController.text) ?? 0,
                );

                productController.createProduct(product, userController.currentUser!.id);
                Navigator.pop(context);
              }
            },
            child: Text('Dodaj'),
          ),
        ],
      ),
    );
  }
}
