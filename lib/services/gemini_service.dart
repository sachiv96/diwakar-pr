import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Replace with your actual Gemini API key
  static const String _apiKey = 'AIzaSyDaXT5n6t0deKjdA6hSdFKascJznkYAe28';

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-001',
      apiKey: _apiKey,
    );
  }

  // Generate quiz questions
  Future<List<Map<String, dynamic>>> generateQuizQuestions({
    required String topic,
    required int numberOfQuestions,
    required String difficulty,
  }) async {
    try {
      final prompt = '''
Generate $numberOfQuestions multiple-choice questions about "$topic" at $difficulty difficulty level.

Return the response in this exact JSON format:
[
  {
    "question": "Question text here?",
    "options": ["Option A", "Option B", "Option C", "Option D"],
    "correctOptionIndex": 0,
    "explanation": "Brief explanation of the correct answer"
  }
]

Make sure:
1. Questions are clear and educational
2. All 4 options are plausible
3. Only one option is correct
4. The correctOptionIndex is 0-3 (index of correct option)
5. Include helpful explanations
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        // Parse JSON response
        final jsonStr = _extractJson(response.text!);
        final List<dynamic> questions = json.decode(jsonStr);
        return questions.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e) {
      print('Error generating quiz questions: $e');
      return [];
    }
  }

  // Get study assistance
  Future<String> getStudyAssistance({
    required String question,
    String? context,
  }) async {
    try {
      final prompt = '''
You are a helpful study assistant for students. Answer the following question clearly and concisely.

${context != null ? 'Context: $context\n' : ''}
Question: $question

Provide a helpful, educational response that:
1. Directly answers the question
2. Includes relevant examples if helpful
3. Is easy to understand
4. Encourages further learning
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Sorry, I could not generate a response.';
    } catch (e) {
      print('Error getting study assistance: $e');
      return 'Sorry, an error occurred. Please try again.';
    }
  }

  // Get course recommendations
  Future<List<String>> getCourseRecommendations({
    required List<String> completedCourses,
    required List<String> interests,
    required String skillLevel,
  }) async {
    try {
      final prompt = '''
Based on the following information, suggest 5 course topics that would be most beneficial:

Completed Courses: ${completedCourses.join(', ')}
Interests: ${interests.join(', ')}
Current Skill Level: $skillLevel

Return only the course names as a JSON array of strings:
["Course 1", "Course 2", "Course 3", "Course 4", "Course 5"]
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        final jsonStr = _extractJson(response.text!);
        final List<dynamic> courses = json.decode(jsonStr);
        return courses.cast<String>();
      }

      return [];
    } catch (e) {
      print('Error getting course recommendations: $e');
      return [];
    }
  }

  // Enhance post content
  Future<String> enhancePostContent(String originalContent) async {
    try {
      final prompt = '''
Improve the following social media post for a student learning platform. Make it more engaging, professional, and impactful while keeping the same message:

Original: $originalContent

Return only the improved text without any explanations.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? originalContent;
    } catch (e) {
      print('Error enhancing post content: $e');
      return originalContent;
    }
  }

  // Get career guidance
  Future<String> getCareerGuidance({
    required String currentSkills,
    required String interests,
    required String careerGoal,
  }) async {
    try {
      final prompt = '''
As a career counselor, provide personalized guidance based on:

Current Skills: $currentSkills
Interests: $interests
Career Goal: $careerGoal

Provide:
1. Analysis of current position
2. Skills gap identification
3. Recommended learning path
4. Actionable next steps
5. Relevant internship types to look for

Keep the response concise and actionable.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Unable to generate career guidance.';
    } catch (e) {
      print('Error getting career guidance: $e');
      return 'Sorry, an error occurred. Please try again.';
    }
  }

  // Get quiz result feedback
  Future<String> getQuizFeedback({
    required String topic,
    required int score,
    required int totalQuestions,
    required List<String> wrongTopics,
  }) async {
    try {
      final percentage = (score / totalQuestions * 100).round();

      final prompt = '''
A student just completed a quiz on "$topic" with the following results:
- Score: $score out of $totalQuestions ($percentage%)
- Topics they struggled with: ${wrongTopics.join(', ')}

Provide:
1. Brief performance feedback (encouraging tone)
2. Key areas to focus on for improvement
3. 2-3 study tips specific to the weak topics

Keep the response concise and motivating.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Great effort! Keep learning and improving.';
    } catch (e) {
      print('Error getting quiz feedback: $e');
      return 'Great effort! Keep practicing to improve your score.';
    }
  }

  // Extract JSON from response text
  String _extractJson(String text) {
    // Try to find JSON array or object in the response
    final arrayMatch = RegExp(r'\[[\s\S]*\]').firstMatch(text);
    if (arrayMatch != null) {
      return arrayMatch.group(0)!;
    }

    final objectMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (objectMatch != null) {
      return objectMatch.group(0)!;
    }

    return text;
  }
}
