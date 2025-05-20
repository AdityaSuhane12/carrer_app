import 'package:career_app/data/questions.dart';
import 'package:career_app/pages/result_page.dart';
import 'package:career_app/services/api_services.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  late List<String?> selectedAnswers;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<String?>.filled(questions.length, null);
  }

  void nextPage() {
    if (selectedAnswers[currentIndex] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an option")));
      return;
    }
    if (currentIndex < questions.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      submitAnswers();
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void submitAnswers() async {
    if (selectedAnswers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please answer all questions")),
      );
      return;
    }

    try {
      final careers = await ApiService.getCareerRecommendations(
        selectedAnswers,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(apiResults: careers),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get recommendations")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = questions.length;
    final progress = (currentIndex + 1) / total;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4E8DF5),
        title: const Text("Career Quiz", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (currentIndex == 0) {
              Navigator.pop(context); // Back to dashboard
            } else {
              previousPage(); // Back to previous quiz question
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white38,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => currentIndex = index),
        itemCount: questions.length,
        itemBuilder: (context, idx) {
          final question = questions[idx];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Question ${idx + 1} of $total",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      question['question'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ...question['options'].map<Widget>((option) {
                  final isSelected = selectedAnswers[idx] == option;
                  return Card(
                    color: isSelected ? const Color(0xFFCCE0FF) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile<String>(
                      value: option,
                      groupValue: selectedAnswers[idx],
                      title: Text(option),
                      onChanged: (val) {
                        setState(() {
                          selectedAnswers[idx] = val;
                        });
                      },
                    ),
                  );
                }).toList(),
                const Spacer(),
                ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E8DF5),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    idx == total - 1 ? "Submit" : "Next",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
