import 'package:Peetie/signup.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent,
        body: Center(
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpHome()));
              },
              child: const Text(
                'HOME PAGE',
                style: TextStyle(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
              ),
            )));
  }
}
