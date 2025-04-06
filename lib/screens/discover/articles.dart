import 'package:flutter/material.dart';

// --- Article Model ---
// IMPORTANT: Move this class definition to your model file (e.g., articles.dart)
class Article {
  final String id;
  final String title;
  final String topic;
  final String description; // Keep for list screen
  final IconData? iconData;  // Keep for list screen
  final String content;    // Main content for detail screen
  final String author;    // Keep if needed elsewhere
  final String date;      // Keep if needed elsewhere
  final String? articleUrl; // Optional: URL for the full article

  const Article({
    required this.id,
    required this.title,
    required this.topic,
    required this.description,
    required this.iconData,
    required this.content,
    required this.author,
    required this.date,
    this.articleUrl, // Add optional URL
  });
}

// --- Sample Article Data ---
// IMPORTANT: Move this list to your data file (e.g., articles.dart) and populate it
final List<Article> articles = [
  Article(
    id: '1',
    title: 'Stunting, Wasting and Overweight',
    topic: 'in Children',
    description: 'Understand how stunting, wasting, and overweight impact children\'s lives and what can be done to help.',
    iconData: Icons.sentiment_very_satisfied, // Placeholder icon
    content: 'Detailed content about child malnutrition...',
    author: 'NutrifyZero Edu',
    date: 'Apr 7, 2025', // Example date
  ),
  Article(
    id: '2',
    title: 'Addressing Nutritional Needs',
    topic: 'of your family members',
    description: 'Learn about the nutritional needs of adolescent girls, pregnant and lactating women and older persons.',
    iconData: Icons.family_restroom, // Placeholder icon
    content: 'Detailed content about family nutrition...',
    author: 'Community Health Org',
    date: 'Apr 6, 2025', // Example date
  ),
  Article(
    id: '3',
    title: 'What is Zero Hunger?',
    topic: 'Sustainable Development Goals (SDG)',
    description: 'Learn about the goal to end hunger, achieve food security and improved nutrition and promote sustainable agriculture.',
    iconData: Icons.public, // Placeholder icon (SDG Wheel?)
    content: 'Detailed content about SDG Zero Hunger...',
    author: 'United Nations',
    date: 'Apr 5, 2025', // Example date
  ),
];

