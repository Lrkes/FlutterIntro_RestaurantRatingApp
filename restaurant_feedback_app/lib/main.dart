import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(QuickBiteApp());
}

class QuickBiteApp extends StatelessWidget {
  const QuickBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickBite Feedback',
      home: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final List<String> _restaurants = ['Taco House', 'Pizza Corner', 'Sushi Zen'];
  String? _selectedRestaurant;
  double _food = 3;
  double _service = 3;
  double _atmosphere = 3;
  final TextEditingController _commentController = TextEditingController();
  String _responseMessage = '';

  Future<void> _submitFeedback() async {
    final uri = Uri.parse('http://127.0.0.1:8000/api/feedback/submit/');
    final body = {
      "restaurant": _selectedRestaurant ?? '',
      "food": _food.round(),
      "service": _service.round(),
      "atmosphere": _atmosphere.round(),
      "comment": _commentController.text,
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = "Feedback submitted!";
        });
      } else {
        setState(() {
          _responseMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "Failed to connect.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuickBite Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Choose a restaurant'),
              value: _selectedRestaurant,
              onChanged: (value) => setState(() => _selectedRestaurant = value),
              items: _restaurants
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
            ),
            SizedBox(height: 16),
            _buildSlider("Food", _food, (val) => setState(() => _food = val)),
            _buildSlider("Service", _service, (val) => setState(() => _service = val)),
            _buildSlider("Atmosphere", _atmosphere, (val) => setState(() => _atmosphere = val)),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Optional comment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
            ),
            SizedBox(height: 10),
            Text(_responseMessage, style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.round()}'),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
