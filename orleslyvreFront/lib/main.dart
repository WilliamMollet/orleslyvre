import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:google_fonts/google_fonts.dart';
import 'item.dart'; 
import 'search.dart';
import 'detail.dart';


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
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/items/search?limit=5&orderBy=avg_rating_item'));
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
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              // Action à effectuer pour "Connexion"
              // Exemple: showDialog(...) pour afficher un dialogue de connexion
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF806491),
                      hintText: 'Rechercher...',
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Top 5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F70AF))),
            top5Items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: top5Items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(top5Items[index]['name_item']),
                          subtitle: Text('Categorie: ' + top5Items[index]['cat_item'] + '  |  NOTE: ' + top5Items[index]['avg_rating_item']),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailPage(itemId: top5Items[index]['id_item'].toString())),
                          )
                        );
                      },
                    ),
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryCard('Books', 'assets/images/Books.png', '1'),
                _buildCategoryCard('Series', 'assets/images/Series.png', '2'),
                _buildCategoryCard('Movies', 'assets/images/Movies.png', '3'),
                _buildCategoryCard('Music', 'assets/images/Musics.png', '4'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de saisie d'élément
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemPage()),
                );
              },
              child: Text('Ajouter un élément'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, String imagePath, String categoryId) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers la page de recherche avec l'ID de la catégorie
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage(categoryId: categoryId)),
        );
      },
      child: Card(
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
      ),
    );
  }
}
