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

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('https://api.example.com/items?category=${widget.categoryId}'));
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
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['title']),
            subtitle: Text(items[index]['description']),
          );
        },
      ),
    );
  }
}
