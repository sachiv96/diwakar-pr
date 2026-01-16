import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
    required String institution,
  }) async {
    try {
      // Create user with Firebase Auth
      UserCredential? credential;
      try {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // Handle PigeonUserDetails type cast error - auth may still succeed
        print('Auth creation response error: $e');
        // Check if user was actually created
        await Future.delayed(const Duration(milliseconds: 500));
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.email == email) {
          print('✅ User was created despite error');
          // Create user model manually
          final UserModel user = UserModel(
            id: currentUser.uid,
            name: name,
            email: email,
            institution: institution,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          try {
            await _firestore
                .collection(AppConstants.usersCollection)
                .doc(currentUser.uid)
                .set(user.toJson());
            print('✅ User document created in Firestore');
          } catch (firestoreError) {
            print('❌ Firestore error: $firestoreError');
          }

          return user;
        }
        rethrow;
      }

      if (credential.user != null) {
        // Update display name
        try {
          await credential.user!.updateDisplayName(name);
        } catch (e) {
          print('Warning: Could not update display name: $e');
        }

        // Create user document in Firestore
        final UserModel user = UserModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          institution: institution,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        try {
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(credential.user!.uid)
              .set(user.toJson());
          print('✅ User document created in Firestore');
        } catch (firestoreError) {
          print('❌ Firestore error: $firestoreError');
        }

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Signup error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential? credential;
      try {
        credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // Handle PigeonUserDetails type cast error - auth may still succeed
        print('Auth signin response error: $e');
        // Check if user was actually signed in
        await Future.delayed(const Duration(milliseconds: 500));
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.email == email) {
          print('✅ User signed in despite error');
          // Get user document from Firestore
          final doc = await _firestore
              .collection(AppConstants.usersCollection)
              .doc(currentUser.uid)
              .get();

          if (doc.exists) {
            return UserModel.fromJson(doc.data()!);
          }
          // If no Firestore doc, create a basic user model
          return UserModel(
            id: currentUser.uid,
            name: currentUser.displayName ?? 'User',
            email: email,
            institution: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
        rethrow;
      }

      if (credential.user != null) {
        // Get user document from Firestore
        final doc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(credential.user!.uid)
            .get();

        if (doc.exists) {
          return UserModel.fromJson(doc.data()!);
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        // Delete user document from Firestore
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .delete();
        // Delete user from Firebase Auth
        await _auth.currentUser?.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
