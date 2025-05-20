import 'package:career_app/pages/dashboard_page.dart';
import 'package:career_app/provider/recommendation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue ,
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Colors.black
        )
      ),
      appBarTheme: AppBarTheme(
        color:  Colors.blueAccent
      )),
    
      home: DashboardPage(),
    );
  }
}
