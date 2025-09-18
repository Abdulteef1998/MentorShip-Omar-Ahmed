// Question 4: Widget Controller Design
//
// ORIGINAL PROBLEM CODE:
// abstract class WidgetController {
//   void initState();
//   void dispose();
//   void handleAnimation();
//   void handleNetwork();
// }
// class SimpleButtonController implements WidgetController {
//   @override
//   void initState() => print('Init button');
//   @override
//   void dispose() => print('Dispose button');
//   @override
//   void handleAnimation() => throw UnimplementedError('No animation in simple button');
//   @override
//   void handleNetwork() => throw UnimplementedError('No network in button');
// }

// QUESTION: Main problem and solution (e.g., in a widget controller in a Flutter app)?

// CHOICES:
// A- Violation of the Open-Closed Principle because adding new controller behaviors...
// B- Breach of the Encapsulation principle by not adequately hiding the implementation details...
// C- Violation of the Interface Segregation Principle by forcing implementing classes...
// D- Issue with the Dependency Inversion Principle due to potential tight coupling...

// ANSWER: C

// REASON: This is a clear Interface Segregation Principle (ISP) violation. The ISP states
// that "no client should be forced to depend on methods it does not use." Here, the large
// WidgetController interface forces SimpleButtonController to implement handleAnimation()
// and handleNetwork() methods that it doesn't need, resulting in UnimplementedError exceptions.
// This creates unnecessary dependencies and makes the code fragile - a simple button shouldn't
// have to worry about animation or network methods it will never use.

// FIXED SOLUTION:

// Basic controller interface - only essential methods that ALL controllers need
abstract class BasicController {
  void initState();
  void dispose();
}

// Animation controller interface - only for widgets that need animation
abstract class AnimationController {
  void handleAnimation();
  void pauseAnimation();
  void resumeAnimation();
}

// Network controller interface - only for widgets that need network operations
abstract class NetworkController {
  void handleNetwork();
  void retryNetworkCall();
  void cancelNetworkCall();
}

// State management interface - for widgets with complex state
abstract class StateController {
  void saveState();
  void restoreState();
}

// Simple button only implements what it needs - no exceptions!
class SimpleButtonController implements BasicController {
  @override
  void initState() {
    print('Initializing simple button controller');
  }

  @override
  void dispose() {
    print('Disposing simple button controller');
  }
}

// Text input controller - also simple, only basic functionality
class TextInputController implements BasicController {
  @override
  void initState() {
    print('Initializing text input controller');
  }

  @override
  void dispose() {
    print('Disposing text input controller');
  }
}

// Animated widget controller - implements basic + animation interfaces
class AnimatedWidgetController implements BasicController, AnimationController {
  @override
  void initState() {
    print('Initializing animated widget controller');
  }

  @override
  void dispose() {
    print('Disposing animated widget controller');
  }

  @override
  void handleAnimation() {
    print('Starting smooth animation');
  }

  @override
  void pauseAnimation() {
    print('Pausing animation');
  }

  @override
  void resumeAnimation() {
    print('Resuming animation');
  }
}

// Network widget controller - implements basic + network interfaces
class NetworkWidgetController implements BasicController, NetworkController {
  @override
  void initState() {
    print('Initializing network widget controller');
  }

  @override
  void dispose() {
    print('Disposing network widget controller');
  }

  @override
  void handleNetwork() {
    print('Making API call');
  }

  @override
  void retryNetworkCall() {
    print('Retrying failed API call');
  }

  @override
  void cancelNetworkCall() {
    print('Cancelling API call');
  }
}

// Complex widget controller - implements ALL interfaces it needs
class ComplexWidgetController
    implements
        BasicController,
        AnimationController,
        NetworkController,
        StateController {
  @override
  void initState() {
    print('Initializing complex widget controller');
  }

  @override
  void dispose() {
    print('Disposing complex widget controller');
  }

  @override
  void handleAnimation() {
    print('Handling complex animations');
  }

  @override
  void pauseAnimation() {
    print('Pausing complex animations');
  }

  @override
  void resumeAnimation() {
    print('Resuming complex animations');
  }

  @override
  void handleNetwork() {
    print('Making multiple API calls');
  }

  @override
  void retryNetworkCall() {
    print('Retrying with exponential backoff');
  }

  @override
  void cancelNetworkCall() {
    print('Cancelling all network operations');
  }

  @override
  void saveState() {
    print('Saving widget state to storage');
  }

  @override
  void restoreState() {
    print('Restoring widget state from storage');
  }
}

// Usage examples:
// Simple button - works perfectly, no errors:
// var buttonController = SimpleButtonController();
// buttonController.initState(); 
// buttonController.dispose();
// 
// Animated widget - has animation methods:
// var animatedController = AnimatedWidgetController();
// animatedController.initState();
// animatedController.handleAnimation();
// animatedController.pauseAnimation();
// 
// Network widget - has network methods:
// var networkController = NetworkWidgetController();  
// networkController.initState();
// networkController.handleNetwork();
// networkController.retryNetworkCall();
// 
// Each controller only implements interfaces it actually needs!