// Question 1: Extensibility in Multi-Type Content
//
// ORIGINAL PROBLEM CODE:
// class ContentItem {
//   String type; // e.g., "text", "image"
//   String data;
//   ContentItem(this.type, this.data);
//   Widget build(BuildContext context) {
//     if (type == 'text') {
//       return Text(data);
//     } else if (type == 'image') {
//       return Image.network(data);
//     }
//     return Container();
//   }
// }

// QUESTION: What is the primary issue, and how to fix it for extensibility
// (e.g., adding video in a Flutter app for displaying multi-type content)?

// CHOICES:
// A- Encapsulation violation from public fields allowing uncontrolled direct access...
// B- Breach of the Single Responsibility Principle by conflating content representation logic...
// C- Ignoring the Open-Closed Principle and polymorphism through the use of conditional type checks...
// D- Failure of the Liskov Substitution Principle as potential subclasses might not reliably substitute...

// ANSWER: C

// REASON: The main problem is violating the Open-Closed Principle. The code uses
// if-else statements to check content types, which means we must modify the existing
// build() method every time we add a new content type like video. This violates the
// principle that code should be "open for extension but closed for modification".
// To add video support, we'd have to change the existing ContentItem class, which
// risks breaking existing functionality and makes the code hard to maintain.

// FIXED SOLUTION:

import 'package:flutter/material.dart';

// Abstract base class - follows Open-Closed Principle
abstract class ContentItem {
  String data;
  ContentItem(this.data);

  // Abstract method that subclasses must implement
  Widget build(BuildContext context);
}

// Text content implementation
class TextItem extends ContentItem {
  TextItem(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}

// Image content implementation
class ImageItem extends ContentItem {
  ImageItem(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Image.network(data);
  }
}

// Video content implementation - easily added without modifying existing code
class VideoItem extends ContentItem {
  VideoItem(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Video Player: $data'), // Simplified for demo
    );
  }
}

// Audio content - another new type added easily
class AudioItem extends ContentItem {
  AudioItem(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Audio Player: $data'));
  }
}

class ContentDisplay extends StatelessWidget {
  final List<ContentItem> items;
  ContentDisplay(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(children: items.map((item) => item.build(context)).toList());
  }
}

// Usage example:
// ContentDisplay([
//   TextItem("Hello World"),
//   ImageItem("https://example.com/image.jpg"),
//   VideoItem("https://example.com/video.mp4"), // New type added easily
//   AudioItem("https://example.com/song.mp3"),   // Another new type
// ])
