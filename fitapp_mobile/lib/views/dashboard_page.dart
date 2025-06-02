import 'package:fitapp_mobile/controllers/user_controller.dart';
import 'package:fitapp_mobile/controllers/user_day_controller.dart';
import 'package:fitapp_mobile/views/users_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitapp_mobile/controllers/product_controller.dart'; // Import product controller
import 'package:fitapp_mobile/models/product.dart'; // Import product model

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userController = Provider.of<UserController>(context, listen: false);
      final userDayController = Provider.of<UserDayController>(context, listen: false);

      if (userController.currentUser != null) {
        userDayController.loadUserDay(userController.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Dzisiaj'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer2<UserController, UserDayController>(
        builder: (context, userController, userDayController, child) {
          if (userController.currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Wybierz lub utwórz użytkownika'),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UsersPage()),
                    ),
                    child: const Text('Przejdź do użytkowników'),
                  ),
                ],
              ),
            );
          }

          if (userDayController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final userDay = userDayController.currentUserDay;
          if (userDay == null) {
            return const Center(child: Text('Brak danych na dziś'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Witaj, ${userController.currentUser!.fullName}!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Data: ${userDay.userDate}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dzisiejsze składniki odżywcze:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildNutritionCard('Kalorie', '${userDay.dailyKcal}', 'kcal', Colors.red),
                      _buildNutritionCard('Białko', '${userDay.dailyProteins}', 'g', Colors.blue),
                      _buildNutritionCard('Węglowodany', '${userDay.dailyCarbs}', 'g', Colors.orange),
                      _buildNutritionCard('Tłuszcze', '${userDay.dailyFats}', 'g', Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNutritionOptionsDialog(context), // Zmieniona nazwa, aby pokazać opcje
        child: const Icon(Icons.add),
        tooltip: 'Dodaj składniki',
      ),
    );
  }

  Widget _buildNutritionCard(String title, String value, String unit, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nowa metoda do wyświetlania opcji dodawania składników
  void _showAddNutritionOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dodaj składniki odżywcze'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Dodaj nowy produkt (ręcznie)'),
              onTap: () {
                Navigator.pop(context); // Zamknij obecny dialog
                _showAddNutritionDialog(context); // Otwórz dialog ręcznego dodawania
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Wybierz z listy produktów'),
              onTap: () {
                Navigator.pop(context); // Zamknij obecny dialog
                _showAddProductFromListDialog(context); // Otwórz dialog wyboru z listy
              },
            ),
          ],
        ),
      ),
    );
  }


  void _showAddNutritionDialog(BuildContext context, {Product? productToEdit}) {
    final nameController = TextEditingController(text: productToEdit?.productName);
    final gramsController = TextEditingController(text: productToEdit?.grams?.toString() ?? '');
    final kcalController = TextEditingController(text: productToEdit?.kcal.toString() ?? '');
    final proteinsController = TextEditingController(text: productToEdit?.proteins.toString() ?? '');
    final carbsController = TextEditingController(text: productToEdit?.carbs.toString() ?? '');
    final fatsController = TextEditingController(text: productToEdit?.fats.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(productToEdit == null ? 'Dodaj nowy produkt/składniki' : 'Edytuj produkt'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nazwa produktu (opcjonalnie)'),
              ),
              TextField(
                controller: gramsController,
                decoration: const InputDecoration(labelText: 'Gramy'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: kcalController,
                decoration: const InputDecoration(labelText: 'Kalorie'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: proteinsController,
                decoration: const InputDecoration(labelText: 'Białko (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carbsController,
                decoration: const InputDecoration(labelText: 'Węglowodany (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fatsController,
                decoration: const InputDecoration(labelText: 'Tłuszcze (g)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              final userDayController = Provider.of<UserDayController>(context, listen: false);
              final productController = Provider.of<ProductController>(context, listen: false);
              final userController = Provider.of<UserController>(context, listen: false);

              final int grams = int.tryParse(gramsController.text) ?? 0;
              final int kcal = int.tryParse(kcalController.text) ?? 0;
              final int proteins = int.tryParse(proteinsController.text) ?? 0;
              final int carbs = int.tryParse(carbsController.text) ?? 0;
              final int fats = int.tryParse(fatsController.text) ?? 0;
              final String productName = nameController.text.trim();

              // Aktualizuj UserDay
              userDayController.updateNutrition((kcal * 100 / grams).toInt(), (proteins * 100 / grams).toInt(), (carbs * 100 / grams).toInt(), (fats * 100 / grams).toInt());

              // Jeśli podano nazwę produktu i jest zalogowany użytkownik, dodaj/zaktualizuj produkt
              if (userController.currentUser != null && productName.isNotEmpty) {
                final product = Product(
                  id: productToEdit?.id ?? '',
                  productName: productName,
                  grams: grams,
                  kcal: kcal,
                  proteins: proteins,
                  carbs: carbs,
                  fats: fats,
                );
                if (productToEdit == null) {
                  productController.createProduct(product, userController.currentUser!.id);
                } else {
                  // productController.updateProduct(product); // jeśli masz zaimplementowaną aktualizację
                }
              }

              Navigator.pop(context);
            },
            child: const Text('Dodaj/Zapisz'),
          ),
        ],
      ),
    );
  }


  void _showAddProductFromListDialog(BuildContext context) {
    final productController = Provider.of<ProductController>(context, listen: false);
    final userDayController = Provider.of<UserDayController>(context, listen: false);
    final userController = Provider.of<UserController>(context, listen: false);

    if (productController.products.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Brak produktów'),
          content: const Text('Nie masz jeszcze żadnych zapisanych produktów. Dodaj je najpierw w zakładce "Produkty".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wybierz produkt z listy'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return ListTile(
                title: Text(product.productName),
                subtitle: Text('${product.kcal} kcal, P:${product.proteins}g, C:${product.carbs}g, F:${product.fats}g'),
                onTap: () {
                  Navigator.pop(context); // Zamknij listę produktów

                  // Po zamknięciu pierwszego dialogu pokaż drugi dialog do wpisania gramów
                  final gramsController = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Podaj ilość w gramach'),
                      content: TextField(
                        controller: gramsController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Gramatura (g)',
                          hintText: 'np. 150',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Anuluj
                          child: const Text('Anuluj'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final input = gramsController.text.trim();
                            final grams = double.tryParse(input);

                            if (grams == null || grams <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Podaj poprawną wartość gramów')),
                              );
                              return;
                            }

                            // Wylicz proporcjonalne wartości
                            final kcal = product.kcal * grams / 100.0;
                            final proteins = product.proteins * grams / 100.0;
                            final carbs = product.carbs * grams / 100.0;
                            final fats = product.fats * grams / 100.0;

                            // Aktualizuj dzienny bilans
                            userDayController.updateNutrition(kcal.toInt(), proteins.toInt(), carbs.toInt(), fats.toInt());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Dodano $grams g produktu ${product.productName} do bilansu!')),
                            );

                            Navigator.pop(context); // Zamknij dialog z gramaturą
                          },
                          child: const Text('Dodaj'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
        ],
      ),
    );
  }
}