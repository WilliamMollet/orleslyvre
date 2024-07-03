import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> top5Items = [];

  @override
  void initState() {
    super.initState();
    fetchTop5Items();
  }

  Future<void> fetchTop5Items() async {
    final response = await http.get(Uri.parse('https://api.example.com/top5'));
    if (response.statusCode == 200) {
      setState(() {
        top5Items = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load top 5 items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF806491).withOpacity(0.7), // Couleur avec opacité réduite
              hintText: 'Rechercher...',
              prefixIcon: Icon(Icons.search, color: Colors.white),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            ),
            SizedBox(height: 20),
            Text('Top 5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F70AF))),
            top5Items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: top5Items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(top5Items[index]['title']),
                          subtitle: Text(top5Items[index]['category']),
                        );
                      },
                    ),
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryCard('Books', 'assets/images/Books.png'),
                _buildCategoryCard('Series', 'assets/images/Series.png'),
                _buildCategoryCard('Movies', 'assets/images/Movies.png'),
                _buildCategoryCard('Music', 'assets/images/Musics.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, String imagePath) {
    return Card(
      color: Color(0xFF2F70AF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(imagePath, height: 32, width: 32),
            SizedBox(height: 10),
            Text(category, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
