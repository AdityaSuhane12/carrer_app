import 'package:career_app/data/recommendation_data.dart';
import 'package:career_app/pages/dashboard_page.dart';
import 'package:career_app/provider/recommendation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  final List<String> apiResults;

  const ResultPage({super.key, required this.apiResults});

  @override
  Widget build(BuildContext context) {
    // Match the careers from the API with local career data
    final matchedCareers =
        careerRecommendations
            .where((career) => apiResults.contains(career['title']))
            .toList();
      context.read<RecommendationProvider>().addRecommendation(apiResults);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Recommendations'),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                matchedCareers.isEmpty
                    ? const Center(child: Text("No matching careers found."))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: matchedCareers.length,
                      itemBuilder: (context, index) {
                        final career = matchedCareers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (career['imageUrl'] != null &&
                                  career['imageUrl']!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    career['imageUrl']!,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      career['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      career['description'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              child: const Text(
                "Go to Dashboard",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
