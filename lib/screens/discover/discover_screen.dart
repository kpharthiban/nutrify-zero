import 'package:flutter/material.dart';

// Import shared widgets (Adjust paths if necessary)
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';

// Import detail screen (Adjust path if necessary)
// import 'article_detail_screen.dart';
import 'articles.dart';

// --- Discover Screen Widget ---
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  // --- Helper to Build Styled Article Cards (Includes Author/Date) ---
  Widget _buildStyledArticleCard(BuildContext context, Article article, Color backgroundColor) {
    const Color lightButtonColor = Color(0xFFE0E0E0); // Light grey for button bg
    const Color darkTextColor = Colors.black54; // Dark grey for button text
    final Color metaColor = Colors.white.withOpacity(0.8); // Meta text color
    const double metaFontSize = 11.0; // Meta font size

    // Common navigation function
    void navigateToDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        ),
      );
    }

    return GestureDetector(
      onTap: navigateToDetail, // Make the whole card tappable
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon on the left
            Icon(article.iconData, size: 36, color: Colors.white),
            const SizedBox(width: 16),
            // Text content and button on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // Optional Topic (if different from title)
                  if (article.topic.isNotEmpty && article.topic != article.title) ...[
                    const SizedBox(height: 2),
                    Text(
                      article.topic,
                       style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    article.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10), // Space before author/date row

                  // --- Author and Date Row ---
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: metaColor),
                      const SizedBox(width: 4),
                      Flexible( // Use Flexible to prevent overflow if author name is long
                        child: Text(
                          article.author,
                          style: TextStyle(fontSize: metaFontSize, color: metaColor),
                          overflow: TextOverflow.ellipsis, // Handle long author names
                        ),
                      ),
                      const SizedBox(width: 12), // Space between author and date
                      Icon(Icons.calendar_today_outlined, size: 13, color: metaColor),
                      const SizedBox(width: 4),
                      Text(
                         article.date,
                         style: TextStyle(fontSize: metaFontSize, color: metaColor),
                      ),
                    ],
                  ),
                  // --- END Author and Date Row ---

                  // const SizedBox(height: 12), // Space before button

                  // Learn More Button (Aligned Right)
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: ElevatedButton(
                  //     onPressed: navigateToDetail, // Navigate on button press too
                  //     style: ElevatedButton.styleFrom(
                  //        backgroundColor: lightButtonColor,
                  //        foregroundColor: darkTextColor,
                  //        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //        shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20.0), // Pill shape
                  //        ),
                  //        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  //        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //        elevation: 0,
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: const [
                  //          Text('Learn more'),
                  //          SizedBox(width: 4),
                  //          Icon(Icons.arrow_forward_ios, size: 10), // Small chevron
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } // --- End of _buildStyledArticleCard ---


  @override
  Widget build(BuildContext context) {
     // Define colors
    const Color primaryGreen = Color(0xFF4CAF50);
    // Brownish color (adjust as needed - Colors.brown[300])
    const Color primaryBrown = Color(0xFFB48B2D);
    const Color footerColor = Color(0xFFE0E0E0); // Light grey for footer
    const Color subtitleColor = Colors.black54;

    // Define alternating background colors for cards
    // Extend this list if you have many articles to ensure variety
    final List<Color> cardColors = [primaryBrown, primaryGreen, primaryBrown, primaryGreen];

    return Scaffold(
      appBar: const CustomAppBar(), // Use your custom app bar
      body: SingleChildScrollView( // Wrap content in SingleChildScrollView
         padding: const EdgeInsets.only(bottom: 20.0), // Add padding at the bottom
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              // --- Header ---
             Padding(
               padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: const [
                   Text(
                     'Discover',
                     style: TextStyle(
                       fontSize: 32,
                       fontWeight: FontWeight.bold,
                       color: primaryGreen, // Green title
                     ),
                   ),
                   SizedBox(height: 4),
                   Text(
                     'about food security, nutrition, malnutrition and more',
                     style: TextStyle(fontSize: 14, color: subtitleColor),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 16), // Space before cards

              // --- Article List ---
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0),
               // Use ListView.builder within Column
               child: ListView.builder(
                 shrinkWrap: true, // Important inside SingleChildScrollView/Column
                 physics: const NeverScrollableScrollPhysics(), // Disable nested scrolling
                 itemCount: articles.length, // Use the length of your articles list
                 itemBuilder: (context, index) {
                   final article = articles[index];
                   // Alternate colors based on index
                   final cardColor = cardColors[index % cardColors.length];
                   // Use the updated helper function
                   return _buildStyledArticleCard(context, article, cardColor);
                 },
               ),
             ),
             const SizedBox(height: 24), // Space before footer

              // --- Footer ---
             Center( // Center the footer container
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                 decoration: BoxDecoration(
                   color: footerColor,
                   borderRadius: BorderRadius.circular(8.0),
                 ),
                 child: const Text(
                   'Additional Resources Coming Soon.',
                   style: TextStyle(fontSize: 13, color: Colors.black54),
                 ),
               ),
             ),
           ],
         ),
       ),
      // Use shared bottom nav bar, set correct index
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
} // --- End of DiscoverScreen ---


// --- Placeholder ArticleDetailScreen (ensure yours exists and is imported) ---
// IMPORTANT: Move this to its own file (e.g., article_detail_screen.dart)
class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Use your custom app bar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
             if (article.topic.isNotEmpty && article.topic != article.title) ...[
               Text(article.topic, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
               const SizedBox(height: 8),
             ],
            Row( // Display author/date here too
                 children: [
                   Icon(Icons.person_outline, size: 14, color: Colors.grey),
                   const SizedBox(width: 4),
                   Text(article.author, style: Theme.of(context).textTheme.bodySmall),
                   const SizedBox(width: 16),
                   Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                   const SizedBox(width: 4),
                   Text(article.date, style: Theme.of(context).textTheme.bodySmall),
                 ],
               ),
            const Divider(height: 32), // Add divider
            // Display full content (ensure your article.content has the text)
            Text(
               article.content,
               style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5), // Add line spacing
            ),
          ],
        ),
      ),
    );
  }
}