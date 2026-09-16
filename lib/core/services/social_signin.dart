import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../constants/app_constants.dart';
import '../network/common_api_class.dart';

class SocialSignIn {
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      debugPrint("FirebaseAuth instance error: $e");
      return null;
    }
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: Platform.isIOS
            ? AppConstants.FIREBASE_GOOGLE_CLIENT_ID_IOS
            : AppConstants.FIREBASE_GOOGLE_CLIENT_ID_ANDROID,
      );
      debugPrint("GoogleSignIn initialized successfully");
    } catch (e) {
      debugPrint("Failed to initialize GoogleSignIn: $e");
    }
  }

  Future<User?> signInWithGoogle() async {
    await SocialSignIn.initializeGoogleSignIn();
    try {
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication auth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      final authInstance = _auth;
      if (authInstance == null) return null;

      final UserCredential userCredential =
          await authInstance.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      return null;
    }
  }

  Future<bool> isUserGoogleSignedIn() async {
    try {
      final account = await _googleSignIn.attemptLightweightAuthentication();
      return account != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth?.signOut();
    } catch (e) {
      debugPrint("Error during Google sign-out: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth?.signOut();
    } catch (e) {
      CommonApiClass().normalPrintJson(e.toString());
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.tokenString);

        final authInstance = _auth;
        if (authInstance == null) return null;
        UserCredential userCredential =
            await authInstance.signInWithCredential(facebookAuthCredential);
        return userCredential.user;
      } else {
        debugPrint("Facebook login failed: ${loginResult.status}");
        return null;
      }
    } catch (e) {
      debugPrint("Error signing in with Facebook: $e");
      return null;
    }
  }

  Future<bool> isUserFacebookSignedIn() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    return accessToken != null;
  }

  Future<void> signOutWithFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      await _auth?.signOut();
      debugPrint('User signed out from Facebook');
    } catch (e) {
      debugPrint('Error signing out from Facebook: $e');
    }
  }

  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final authInstance = _auth;
      if (authInstance == null) return null;

      UserCredential userCredential =
          await authInstance.signInWithCredential(oauthCredential);

      // Apple only provides fullName on the first sign-in.
      // We can update the Firebase user profile if name is available.
      if (appleCredential.givenName != null || appleCredential.familyName != null) {
        String displayName = [appleCredential.givenName, appleCredential.familyName]
            .where((name) => name != null && name.isNotEmpty)
            .join(" ");

        if (displayName.isNotEmpty) {
          await userCredential.user?.updateDisplayName(displayName);
        }
      }

      return userCredential.user;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint("SignInWithApple error → Code: ${e.code}, Message: ${e.message}");
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint("User canceled Apple sign-in");
      }
      return null;
    } catch (e) {
      debugPrint("General error signing in with Apple: $e");
      return null;
    }
  }
}
