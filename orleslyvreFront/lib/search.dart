import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final String categoryId;

  SearchPage({required this.categoryId});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> items = [];
  String selectedCategory = ''; // Catégorie sélectionnée dans le filtre
  int selectedRating = 0; // Note sélectionnée dans le filtre
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems({String? categoryFilter, int? ratingFilter, String? searchQuery}) async {
    String apiUrl = 'https://api.example.com/items?category=${widget.categoryId}';
    if (categoryFilter != null) {
      apiUrl += '&filter_category=$categoryFilter';
    }
    if (ratingFilter != null && ratingFilter > 0) {
      apiUrl += '&filter_rating=$ratingFilter';
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      apiUrl += '&search=$searchQuery';
    }

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items de la catégorie'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // Afficher le popup de filtre
              showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTextController,
                    onChanged: (value) {
                      // Réagir aux changements dans la barre de recherche
                      fetchItems(searchQuery: value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Rechercher...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]['title']),
                  subtitle: Text(items[index]['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrer les résultats'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Catégorie'),
              DropdownButton<String>(
                value: selectedCategory.isNotEmpty ? selectedCategory : null,
                hint: Text('Sélectionner une catégorie'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                    fetchItems(categoryFilter: selectedCategory, ratingFilter: selectedRating);
                  });
                },
                items: <String>['Books', 'Series', 'Movies', 'Music']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text('Note'),
              DropdownButton<int>(
                value: selectedRating > 0 ? selectedRating : null,
                hint: Text('Sélectionner une note'),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedRating = newValue!;
                    fetchItems(categoryFilter: selectedCategory, ratingFilter: selectedRating);
                  });
                },
                items: <int>[1, 2, 3, 4, 5]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Filtrer'),
            ),
          ],
        );
      },
    );
  }
}
