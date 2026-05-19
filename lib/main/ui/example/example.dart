import 'package:flutter/material.dart';

class OverlappingHeaderPage extends StatelessWidget {
  const OverlappingHeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Matches the card color so it blends seamlessly
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF005bbb), // The blue background
            expandedHeight: 180.0, // How tall the blue background should be initially
            floating: false,
            // Set pinned to false if you want the blue background to disappear completely when scrolling.
            // Set to true if you want a standard sized app bar to remain at the top.
            pinned: false,
            flexibleSpace: const FlexibleSpaceBar(
              // You can add a background image or pattern here if needed
            ),
            // The trick: A PreferredSize widget at the bottom of the App Bar
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Container(
                height: 30.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0), // The rounded corners
                  ),
                ),
              ),
            ),
          ),

          // The scrollable content below the header
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // --- Recreating the UI from your image ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and Title
                      Row(
                        children: [
                          const Icon(Icons.widgets, color: Color(0xFF005bbb), size: 36),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MAJADIGI',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue[800],
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Majapahit Digital',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Language Selector Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.language, size: 16, color: Colors.grey.shade700),
                            const SizedBox(width: 6),
                            Text(
                              'Bahasa Indonesia',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- Dummy content to make the screen scrollable ---
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(Icons.person, color: Colors.grey.shade400),
                        ),
                        title: Text('List Item ${index + 1}'),
                        subtitle: const Text('Scroll up to see the card push the background.'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}