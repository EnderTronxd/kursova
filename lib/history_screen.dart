import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Історія'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final history = snapshot.data!;
          if (history.isEmpty) {
            return const Center(child: Text('Історія порожня'));
          }
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(
                  item['expression'],
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                subtitle: Text(
                  '= ${item['result']}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                trailing: Text(
                  item['date'].split('T')[0],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
