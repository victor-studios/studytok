import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/env.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// Native Google Sign In
  /// 
  /// This requires configuration of the Web Client ID in the Google Cloud Console
  /// and placing that ID in your Env class.
  Future<AuthResponse> signInWithGoogle() async {
    final webClientId = Env.googleWebClientId;
    final iosClientId = Env.googleIosClientId;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      clientId: iosClientId,
      scopes: [
        'email',
        'profile',
        'openid',
      ],
    );

    // Forces a re-prompt natively if you want to allow picking another Google account
    final googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      throw 'Google Sign In was canceled by the user.';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Failed to retrieve authentication tokens from Google.';
    }

    // Exchange the tokens with Supabase
    return await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    await _supabase.auth.signOut();
  }

  /// Expose auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;
}
