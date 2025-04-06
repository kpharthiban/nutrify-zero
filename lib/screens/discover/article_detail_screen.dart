import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Assuming exists
import 'articles.dart'; // Assuming has updated Article model
// Import url_launcher if implementing the button action now
// import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  // --- Function to launch URL --- (Keep commented out for now)
  /*
  Future<void> _launchURL(String? urlString) async {
    if (urlString != null) {
       final Uri url = Uri.parse(urlString);
       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
         // Could not launch URL
         print('Could not launch $url');
         // Optionally show a snackbar to the user
       }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    // Define colors
    const Color primaryBrown = Color(0xFFBCAAA4); // Brownish-gold color
    const Color subtitleColor = Colors.black54;
    const Color bodyTextColor = Colors.black87;
    const Color lightButtonColor = Color(0xFFE0E0E0); // Light grey for button
    const Color darkTextColor = Colors.black54;    // Dark text for button

    return Scaffold(
      appBar: const CustomAppBar(), // Use your custom app bar (shows back button)
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Adjust padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Text(
              article.title, // Main title
              style: const TextStyle(
                fontSize: 28, // Larger title
                fontWeight: FontWeight.bold,
                color: primaryBrown, // Brownish-gold color
                height: 1, // Adjust line height if title wraps
              ),
            ),
            // Optional Topic below title
            if (article.topic.isNotEmpty && article.topic != article.title) ...[
              const SizedBox(height: 8),
              Text(
                article.topic,
                style: const TextStyle(
                  fontSize: 16, // Adjust size
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 24), // Space before content

            // --- Content ---
            Text(
              article.content,
              style: TextStyle(
                fontSize: 15, // Adjust content font size
                color: bodyTextColor,
                height: 1.5, // Line spacing for readability
              ),
            ),
            const SizedBox(height: 32), // Space before button

            // --- Open in Browser Button ---
            // Show button only if URL exists in the article data
            if (article.articleUrl != null && article.articleUrl!.isNotEmpty)
              Center( // Center the button
                child: ElevatedButton(
                  onPressed: () {
                     print('Open in browser tapped. URL: ${article.articleUrl}');
                     // TODO: Uncomment and use _launchURL when ready
                     // _launchURL(article.articleUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightButtonColor,
                    foregroundColor: darkTextColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Pill shape
                    ),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    elevation: 0, // Flat look
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Button size fits content
                    children: const [
                      Text('Open Article in Browser'),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios, size: 12), // Small chevron
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Padding at the bottom
          ],
        ),
      ),
      // No BottomNavBar needed on detail screens typically
    );
  }
}