import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final String itemId;

  DetailPage({required this.itemId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> item = [];

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  Future<void> fetchItem() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/item/${widget.itemId}'));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        item = data.map((item) {
          return {
            'name_item': item['name_item'],
            'desc_item': item['desc_item'],
            'cat_item': item['cat_item'],
            'avg_rating_item': item['avg_rating_item'],
            'createdAt': item['createdAt'],
            'ratings': item['ratings'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item[0]['name_item'] ?? 'Détail'),
      ),
      body: item.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item[0]['desc_item'] ?? ''),
                        SizedBox(height: 8.0),
                        Text('Categorie: ' + (item[0]['cat_item'] ?? '')),
                        SizedBox(height: 8.0),
                        Text('Note Moyenne: ' + (item[0]['avg_rating_item'] ?? '')),
                        SizedBox(height: 8.0),
                        Text('Créé le: ' + (item[0]['createdAt'] ?? '')),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final review = item[0]['ratings'][index];
                      return ListTile(
                        title: Text(review['name_rating']),
                        subtitle: Text(review['comment_rating'] ?? ''),
                        trailing: Text(review['val_rating'].toString()),
                      );
                    },
                    childCount: item[0]['ratings'] != null ? item[0]['ratings'].length : 0,
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
