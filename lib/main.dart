import 'package:cw2/database/db_functions.dart';
import 'package:flutter/material.dart';
import 'package:cw2/screens/homescreen.dart';

Future<void> main() async {
  /*garantiza que los widgets de Flutter estén listos
  para su uso antes de que la aplicación continúe su ejecución.*/
  WidgetsFlutterBinding.ensureInitialized();
  //Crea DB
  await initializeDatabase();
  await getRoots();
  await gerDateNow();
  await getcategoriesdata();
  await getproductsdata();
  await getAdditionesData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      //Ejecuta la primer pantalla
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreeen(),
      },
    );
  }
}

final ThemeData darkTheme = ThemeData(
  colorSchemeSeed: const Color.fromARGB(255, 255, 230, 0),
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Roboto',

  //Estilos del card
  cardTheme: CardTheme(
    color: const Color.fromARGB(255, 197, 197, 0), // Color de fondo de las Card
    elevation: 2, // Elevación de la sombra
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Bordes redondeados
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.amberAccent),
        backgroundColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 197, 197, 0),
        ),
        foregroundColor: WidgetStatePropertyAll(Colors.black87)),
  ),

  //Estilos Text
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
    ),
  ),
);
