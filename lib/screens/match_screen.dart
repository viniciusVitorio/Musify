import 'package:flutter/material.dart';

class MatchScreen extends StatelessWidget {
  final String profileName1;
  final String profileName2;

  const MatchScreen({Key? key, required this.profileName1, required this.profileName2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parabéns! É um Match!"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              '$profileName1 e $profileName2 curtiram um ao outro!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text("Voltar para o Swipe"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
