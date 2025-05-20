import 'package:career_app/provider/recommendation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RecommendationHistoryPage extends StatelessWidget {
  const RecommendationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<RecommendationProvider>().history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? const Center(child: Text('No previous recommendations.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('Attempt ${index + 1}' ,style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    subtitle: Text(entry.join(', ')),
                  ),
                );
              },
            ),
    );
  }
}
