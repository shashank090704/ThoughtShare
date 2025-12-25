// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/user_model.dart';
// import '../utils/constants.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   // Get current user
//   User? get currentUser => _auth.currentUser;
  
//   // Auth state changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
  
//   // Sign up with email and password
//   Future<UserModel?> signUp({
//     required String email,
//     required String password,
//     required String username,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
      
//       // Create user document in Firestore
//       UserModel user = UserModel(
//         uid: credential.user!.uid,
//         email: email,
//         username: username,
//         createdAt: DateTime.now(),
//       );
      
//       await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(user.uid)
//           .set(user.toMap());
      
//       return user;
//     } catch (e) {
//       throw Exception('Sign up failed: ${e.toString()}');
//     }
//   }
  
//   // Sign in with email and password
//   Future<UserModel?> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
      
//       // Get user data from Firestore
//       DocumentSnapshot doc = await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(credential.user!.uid)
//           .get();
      
//       return UserModel.fromMap(doc.data() as Map<String, dynamic>);
//     } catch (e) {
//       throw Exception('Sign in failed: ${e.toString()}');
//     }
//   }
  
//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
  
//   // Get user data by ID
//   Future<UserModel?> getUserById(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(uid)
//           .get();
      
//       if (doc.exists) {
//         return UserModel.fromMap(doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/user_model.dart';
// import '../utils/constants.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   // Get current user
//   User? get currentUser => _auth.currentUser;
  
//   // Auth state changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
  
//   // Sign up with email and password
//   Future<UserModel?> signUp({
//     required String email,
//     required String password,
//     required String username,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
      
//       // Create user document in Firestore
//       UserModel user = UserModel(
//         uid: credential.user!.uid,
//         email: email,
//         username: username,
//         createdAt: DateTime.now(),
//       );
      
//       await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(user.uid)
//           .set(user.toMap());
      
//       return user;
//     } on FirebaseAuthException catch (e) {
//       String message = 'Sign up failed';
//       if (e.code == 'weak-password') {
//         message = 'The password is too weak';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'An account already exists for this email';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid email address';
//       }
//       throw Exception(message);
//     } catch (e) {
//       throw Exception('Sign up failed: ${e.toString()}');
//     }
//   }
  
//   // Sign in with email and password
//   Future<UserModel?> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
      
//       // Get user data from Firestore
//       DocumentSnapshot doc = await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(credential.user!.uid)
//           .get();
      
//       if (doc.exists && doc.data() != null) {
//         return UserModel.fromMap(doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } on FirebaseAuthException catch (e) {
//       String message = 'Sign in failed';
//       if (e.code == 'user-not-found') {
//         message = 'No user found with this email';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid email address';
//       } else if (e.code == 'user-disabled') {
//         message = 'This account has been disabled';
//       }
//       throw Exception(message);
//     } catch (e) {
//       throw Exception('Sign in failed: ${e.toString()}');
//     }
//   }
  
//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
  
//   // Get user data by ID
//   Future<UserModel?> getUserById(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore
//           .collection(AppConstants.usersCollection)
//           .doc(uid)
//           .get();
      
//       if (doc.exists && doc.data() != null) {
//         return UserModel.fromMap(doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Failed to create user');
      }
      
      // Create user model
      UserModel user = UserModel(
        uid: credential.user!.uid,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );
      
      // Save to Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
      
      print('User created successfully: ${user.uid}');
      return user;
      
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String message = 'Sign up failed';
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      throw Exception(message);
    } catch (e) {
      print('Signup error: $e');
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }
  
  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Failed to sign in');
      }
      
      print('Signed in user: ${credential.user!.uid}');
      
      // Get user data from Firestore
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .get();
      
      print('Document exists: ${doc.exists}');
      
      if (!doc.exists) {
        // If document doesn't exist, create it now
        print('Creating user document for existing auth user');
        UserModel user = UserModel(
          uid: credential.user!.uid,
          email: email,
          username: email.split('@')[0], // Use email prefix as username
          createdAt: DateTime.now(),
        );
        
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .set(user.toMap());
        
        return user;
      }
      
      final data = doc.data();
      print('Document data type: ${data.runtimeType}');
      
      if (data == null) {
        throw Exception('User data is null');
      }
      
      return UserModel.fromMap(data as Map<String, dynamic>);
      
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String message = 'Sign in failed';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid email or password';
      }
      throw Exception(message);
    } catch (e) {
      print('Sign in error: $e');
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Get user data by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }
}