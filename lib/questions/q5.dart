// Question 5: Notification Service Design
//
// ORIGINAL PROBLEM CODE:
// class LocalNotificationService {
//   void send(String message) {
//     print('Sending local notification: $message');
//   }
// }
// class AppNotifier {
//   final LocalNotificationService service = LocalNotificationService();
//   void notifyUser(String message) {
//     service.send(message);
//   }
// }

// QUESTION: Core issue and refactor (e.g., in a notification service in a Flutter app)?

// CHOICES:
// A- Mixed responsibilities violating the Single Responsibility Principle, as the AppNotifier class...
// B- Violation of the Liskov Substitution Principle because a subclassed notification service...
// C- Violation of the Dependency Inversion Principle by directly depending on and instantiating...
// D- Missing polymorphism, as there is no overriding mechanism for different notification types...

// ANSWER: C

// REASON: This violates the Dependency Inversion Principle (DIP). The DIP states that:
// 1. High-level modules should not depend on low-level modules. Both should depend on abstractions.
// 2. Abstractions should not depend on details. Details should depend on abstractions.
//
// In the original code, AppNotifier (high-level) directly creates and depends on
// LocalNotificationService (low-level concrete class). This creates tight coupling that makes
// it impossible to:
// - Switch to different notification services (push, email, SMS)
// - Test AppNotifier with mock services
// - Change notification behavior without modifying AppNotifier

// FIXED SOLUTION:

// Abstract interface - both high and low level modules depend on this
abstract class Notifier {
  void send(String message);
}

// Different notification implementations - all depend on the abstraction
class LocalNotificationService implements Notifier {
  @override
  void send(String message) {
    print('📱 Local notification: $message');
    // Local notification implementation
  }
}

class PushNotificationService implements Notifier {
  @override
  void send(String message) {
    print('🔔 Push notification: $message');
    // Firebase/APNs push notification implementation
  }
}

class EmailNotificationService implements Notifier {
  @override
  void send(String message) {
    print('📧 Email notification: $message');
    // SMTP email implementation
  }
}

class SmsNotificationService implements Notifier {
  @override
  void send(String message) {
    print('📱 SMS notification: $message');
    // SMS gateway implementation
  }
}

class SlackNotificationService implements Notifier {
  @override
  void send(String message) {
    print('💬 Slack notification: $message');
    // Slack API implementation
  }
}

// AppNotifier now depends on abstraction, not concrete implementation
class AppNotifier {
  final Notifier _notificationService; // Depends on abstraction

  // Dependency is injected - follows Dependency Inversion Principle
  AppNotifier(this._notificationService);

  void notifyUser(String message) {
    _notificationService.send(message);
  }

  void notifyWithPriority(String message, String priority) {
    final priorityMessage = '[$priority] $message';
    _notificationService.send(priorityMessage);
  }

  void notifyMultiple(List<String> messages) {
    for (String message in messages) {
      _notificationService.send(message);
    }
  }
}

// Factory for creating different notification services
class NotificationFactory {
  static Notifier createLocalService() => LocalNotificationService();
  static Notifier createPushService() => PushNotificationService();
  static Notifier createEmailService() => EmailNotificationService();
  static Notifier createSmsService() => SmsNotificationService();
  static Notifier createSlackService() => SlackNotificationService();

  // Can easily create composite services
  static Notifier createCompositeService(List<Notifier> services) {
    return CompositeNotificationService(services);
  }
}

// Composite pattern - can send to multiple services at once
class CompositeNotificationService implements Notifier {
  final List<Notifier> _services;

  CompositeNotificationService(this._services);

  @override
  void send(String message) {
    for (Notifier service in _services) {
      service.send(message);
    }
  }
}

// Mock service for testing - easily injectable
class MockNotificationService implements Notifier {
  List<String> sentMessages = [];

  @override
  void send(String message) {
    sentMessages.add(message);
    print('🧪 Mock sent: $message');
  }

  void clearMessages() {
    sentMessages.clear();
  }

  bool wasMessageSent(String message) {
    return sentMessages.contains(message);
  }
}

// Usage examples showing flexibility:
// 
// Local notifications:
// var localNotifier = AppNotifier(NotificationFactory.createLocalService());
// localNotifier.notifyUser('Welcome to the app!');
// 
// Push notifications:  
// var pushNotifier = AppNotifier(NotificationFactory.createPushService());
// pushNotifier.notifyWithPriority('Server maintenance', 'HIGH');
// 
// Multiple services at once:
// var compositeNotifier = AppNotifier(NotificationFactory.createCompositeService([
//   NotificationFactory.createLocalService(),
//   NotificationFactory.createEmailService(),
//   NotificationFactory.createSlackService(),
// ]));
// compositeNotifier.notifyUser('System alert - sent to all channels!');
// 
// Easy testing with mocks:
// var mockService = MockNotificationService();
// var testNotifier = AppNotifier(mockService);
// testNotifier.notifyUser('test message');
// print('Message sent: ${mockService.wasMessageSent('test message')}'); // true