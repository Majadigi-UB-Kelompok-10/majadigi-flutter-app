// * Model for SDUI Page List JSON
/* The JSON Format is as below:
 * [
 *    {
 *      "title": "<service>",
 *      "pageLayouts": {
 *        "<page name>": "<page_url.json>",
 *        ...
 *      },
 *      "description": "<desc>"
 *      "images": ["<image.webp>", ...]
 *    },
 *    {
 *      "title": "<service>",
 *      "pageLayouts": {
 *        "<page name>": "<page_url.json>",
 *        ...
 *      },
 *      "description": "<desc>"
 *      "images": ["<image.webp>", ...]
 *    },
 *    ...
 * ]
 */
class PageItem {
  final String title;
  final Map<String, dynamic> pageLayouts;
  final String description;
  final List<dynamic> images;

  PageItem({required this.title, required this.pageLayouts, required this.description, required this.images});

  // A handy factory to convert the JSON map into our Dart object
  factory PageItem.fromJson(Map<String, dynamic> json) {
    return PageItem(
      title: json['title'] as String,
      pageLayouts: json['pageLayouts'] as Map<String, dynamic>,
      description: json['description'] as String,
      images: json['images'] as List<dynamic>,
    );
  }
}