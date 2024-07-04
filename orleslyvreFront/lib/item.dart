import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String selectedCategory = ''; // Catégorie sélectionnée par défaut
  int selectedCategoryId = 0; // ID de la catégorie sélectionnée
  List<Map<String, dynamic>> categories = []; // Liste des catégories

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final String apiUrl = 'http://localhost:3000/api/categories'; // Remplacez par votre URL API

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories = data.map((category) {
          return {
            'id': category['id_cat'],
            'label': category['label_cat'],
          };
        }).toList();
        if (categories.isNotEmpty) {
          selectedCategory = categories[0]['label'];
          selectedCategoryId = categories[0]['id'];
        }
      });
    } else {
      // Gérer l'erreur
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Impossible de récupérer les catégories.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> addItem() async {
    final String apiUrl = 'http://localhost:3000/api/items'; // Remplacez par votre URL API

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name_item': nameController.text,
        'desc_item': descriptionController.text,
        'id_cat': selectedCategoryId, // Utiliser l'ID de la catégorie sélectionnée
      }),
    );

    if (response.statusCode == 201) {
      // Succès
      Navigator.pop(context); // Retourner à la page précédente
    } else {
      // Échec
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Impossible d\'ajouter l\'élément.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un élément'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory.isNotEmpty ? selectedCategory : null,
              items: categories.map((Map<String, dynamic> category) {
                return DropdownMenuItem<String>(
                  value: category['label'],
                  child: Text(category['label']),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value!;
                  selectedCategoryId = categories.firstWhere((category) => category['label'] == value)['id'];
                });
              },
              decoration: InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addItem(); // Appeler la fonction addItem pour ajouter l'élément
              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
