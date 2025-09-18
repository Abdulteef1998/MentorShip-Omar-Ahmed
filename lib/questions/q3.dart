// Question 3: Widget Safety in Navigation
//
// ORIGINAL PROBLEM CODE:
// class Screen {
//   void navigate() {
//     print('Navigating to screen');
//   }
// }
// class HomeScreen extends Screen {
//   @override
//   void navigate() {
//     print('Navigating to home');
//   }
// }
// class SettingsScreen extends Screen {
//   @override
//   void navigate() {
//     throw Exception('Settings don\'t navigate this way!');
//   }
// }
// class NavigationButton extends StatelessWidget {
//   final Screen screen;
//   NavigationButton(this.screen);
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => screen.navigate(),
//       child: Text('Navigate'),
//     );
//   }
// }

// QUESTION: What is wrong, and the best fix for widget safety (e.g., navigation
// system in a Flutter app)?

// CHOICES:
// A- Missing abstraction layer, resulting in an inflexible design where concrete Screen classes...
// B- Violation of the Liskov Substitution Principle because not all subclasses like SettingsScreen...
// C- Issue with polymorphism in widget handling, as the base class method is overridden...
// D- Breach of the Single Responsibility Principle in the NavigationButton widget...

// ANSWER: B

// REASON: This is a classic Liskov Substitution Principle (LSP) violation. The LSP states
// that objects of a superclass should be replaceable with objects of its subclasses without
// breaking the application. In this case, SettingsScreen extends Screen but throws an
// exception when navigate() is called, instead of navigating like other Screen subclasses.
// This means you cannot safely substitute SettingsScreen for Screen in NavigationButton
// because it will crash the app instead of working normally.

// FIXED SOLUTION:

import 'package:flutter/material.dart';

// Interface for navigable screens only
abstract class Navigable {
  void navigate();
}

// Base screen class - no navigation method here
abstract class Screen {
  final String screenName;
  Screen(this.screenName);

  void onScreenEnter() {
    print('Entering $screenName screen');
  }
}

// Navigable screens implement the Navigable interface
class HomeScreen extends Screen implements Navigable {
  HomeScreen() : super('Home');

  @override
  void navigate() {
    print('Navigating to home screen');
  }
}

class ProfileScreen extends Screen implements Navigable {
  ProfileScreen() : super('Profile');

  @override
  void navigate() {
    print('Navigating to profile screen');
  }
}

class AboutScreen extends Screen implements Navigable {
  AboutScreen() : super('About');

  @override
  void navigate() {
    print('Navigating to about screen');
  }
}

// Non-navigable screens don't implement Navigable
class SettingsScreen extends Screen {
  SettingsScreen() : super('Settings');

  // Settings screen has its own behavior - no navigate method
  void openSettingsDialog() {
    print('Opening settings dialog');
  }

  void showSettingsModal() {
    print('Showing settings modal');
  }
}

class PopupScreen extends Screen {
  PopupScreen() : super('Popup');

  void showPopup() {
    print('Showing popup overlay');
  }
}

// Navigation button only accepts Navigable screens - type safety
class NavigationButton extends StatelessWidget {
  final Navigable navigableScreen;
  final String buttonText;

  NavigationButton(this.navigableScreen, this.buttonText);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navigableScreen.navigate(),
      child: Text(buttonText),
    );
  }
}

// Settings button for non-navigable screens
class SettingsButton extends StatelessWidget {
  final SettingsScreen settingsScreen;

  SettingsButton(this.settingsScreen);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => settingsScreen.openSettingsDialog(),
      child: Text('Open Settings'),
    );
  }
}

// Popup button for popup screens
class PopupButton extends StatelessWidget {
  final PopupScreen popupScreen;

  PopupButton(this.popupScreen);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => popupScreen.showPopup(),
      child: Text('Show Popup'),
    );
  }
}

// Usage examples:
// These work safely - only navigable screens:
// NavigationButton(HomeScreen(), 'Go Home')
// NavigationButton(ProfileScreen(), 'Go to Profile')
// NavigationButton(AboutScreen(), 'Go to About')
// 
// These have their own button types:
// SettingsButton(SettingsScreen())
// PopupButton(PopupScreen())
// 
// This won't compile - SettingsScreen is not Navigable:
// NavigationButton(SettingsScreen(), 'Settings') // Compile Error!