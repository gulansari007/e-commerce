import 'package:e_commerce/provider/cart_provider.dart';
import 'package:e_commerce/provider/home_provider.dart';
import 'package:e_commerce/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cartProvider = CartProvider();
 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommerceProvider()),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(useMaterial3: true));
  }
}
