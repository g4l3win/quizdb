import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import your home_screen.dart

class ResultsPage extends StatelessWidget {
  final double currentScore;
  final String subject;
  ResultsPage({
    required this.currentScore,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00B1C2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),

            // Congratulation Text
            Text(
              'Congratulation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),

            SizedBox(height: 10),

            // Score
            Text(
              'Total skor kamu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),

            Text(
              '$currentScore',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),


            SizedBox(height: 20), // Spacing between buttons

            // Button untuk kembali ke home
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Navigate to HomeScreen
                );
              },
              icon: Icon(Icons.home, color: Color(0xFFFFD801)),
              label: Text('Home',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B547A), // Button color
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}