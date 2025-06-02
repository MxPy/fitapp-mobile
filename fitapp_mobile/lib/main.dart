import 'package:fitapp_mobile/controllers/product_controller.dart';
import 'package:fitapp_mobile/controllers/user_controller.dart';
import 'package:fitapp_mobile/controllers/user_day_controller.dart';
import 'package:fitapp_mobile/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => UserDayController()),
      ],
      child: MaterialApp(
        title: 'FitApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}