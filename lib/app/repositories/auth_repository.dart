// auth_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of auth state changes exposing our AppUser or null
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, user.uid);
      } else {
        // Create minimal profile if absent
        final profile = AppUser(uid: user.uid, email: user.email ?? '', displayName: user.displayName ?? '');
        await _firestore.collection('users').doc(user.uid).set(profile.toMap());
        return profile;
      }
    });
  }

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = cred.user;
      if (user == null) throw AuthFailure('Failed to create user.');
      // update displayName
      if (displayName != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName);
      }
      // Save profile to Firestore
      final appUser = AppUser(uid: user.uid, email: user.email ?? '', displayName: displayName ?? '');
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseAuthException(e));
    } catch (e) {
      throw AuthFailure('Unknown error during sign up.');
    }
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = cred.user;
      if (user == null) throw AuthFailure('Failed to sign in.');
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, user.uid);
      } else {
        final appUser = AppUser(uid: user.uid, email: user.email ?? '', displayName: user.displayName ?? '');
        await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseAuthException(e));
    } catch (e) {
      throw AuthFailure('Unknown error during sign in.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthFailure('Failed to sign out.');
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseAuthException(e));
    } catch (e) {
      throw AuthFailure('Failed to send password reset email.');
    }
  }
  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email ?? '', displayName: user.displayName ?? '');
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw AuthFailure('No logged in user.');
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapFirebaseAuthException(e));
    } catch (e) {
      throw AuthFailure('Failed to send email verification.');
    }
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return user.emailVerified;
  }

  String _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Check Firebase console.';
      default:
        return e.message ?? 'Authentication error: ${e.code}';
    }
  }
}
