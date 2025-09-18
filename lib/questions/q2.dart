// Question 2: User Model with Firestore
//
// ORIGINAL PROBLEM CODE:
// class UserModel {
//   String name = '';
//   int age = 0;
//   String email = '';
//   void updateUser(String name, int age, String email) {
//     this.name = name;
//     this.age = age;
//     this.email = email;
//   }
//   void saveToFirestore() {
//     print('Saving $name, $age, $email to Firestore');
//   }
// }

// QUESTION: Identify the key violations and fix (e.g., in a user model in a
// Flutter app using Firestore).

// CHOICES:
// A- Issue with the Dependency Inversion Principle due to a hardcoded dependency...
// B- Overreach of the Interface Segregation Principle by including an overly broad set...
// C- Broken Encapsulation principle due to public fields that can be directly modified...
// D- Ignoring the Open-Closed Principle in handling updates, as adding new fields...

// ANSWER: C

// REASON: There are two main problems:
// 1. Broken Encapsulation - All fields (name, age, email) are public, so they can be
//    directly modified without any validation. Someone could set age = -100 or name = ""
//    and break the data integrity.
// 2. Single Responsibility Principle violation - The UserModel class is doing two jobs:
//    managing user data AND handling database operations (saveToFirestore). A model
//    should only handle data, while database operations should be in a separate service.

// FIXED SOLUTION:

// Separate service for database operations - follows Single Responsibility Principle
class FirestoreService {
  void saveUser(String name, int age, String email) {
    print('Saving $name, $age, $email to Firestore');
    // Database logic here
  }

  void updateUser(String userId, Map<String, dynamic> data) {
    print('Updating user $userId with data: $data');
  }

  void deleteUser(String userId) {
    print('Deleting user $userId from Firestore');
  }
}

// User model with proper encapsulation
class UserModel {
  // Private fields - proper encapsulation
  String _name = '';
  int _age = 0;
  String _email = '';

  // Getters for read access
  String get name => _name;
  int get age => _age;
  String get email => _email;

  // Setters with validation - ensures data integrity
  set name(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (value.length < 2) {
      throw ArgumentError('Name must be at least 2 characters');
    }
    _name = value.trim();
  }

  set age(int value) {
    if (value < 0 || value > 150) {
      throw ArgumentError('Age must be between 0 and 150');
    }
    _age = value;
  }

  set email(String value) {
    if (!value.contains('@') || !value.contains('.')) {
      throw ArgumentError('Invalid email format');
    }
    _email = value.toLowerCase().trim();
  }

  // Method to update user with validation
  void updateUser(String name, int age, String email) {
    this.name = name; // Uses setter validation
    this.age = age; // Uses setter validation
    this.email = email; // Uses setter validation
  }

  // Method to get user data as map
  Map<String, dynamic> toMap() {
    return {'name': _name, 'age': _age, 'email': _email};
  }
}

// Controller that combines model and service - follows dependency injection
class UserController {
  final FirestoreService _firestoreService;

  UserController(this._firestoreService);

  void saveUser(UserModel user) {
    _firestoreService.saveUser(user.name, user.age, user.email);
  }

  void createUser(String name, int age, String email) {
    var user = UserModel();
    user.updateUser(name, age, email); // Validation happens here
    saveUser(user);
  }
}

// Usage example:
// var user = UserModel();
// user.updateUser('John Doe', 25, 'john@example.com');
// 
// var firestoreService = FirestoreService();
// var controller = UserController(firestoreService);
// controller.saveUser(user);
// 
// Validation example:
// user.age = -5; // Throws: ArgumentError: Age must be between 0 and 150