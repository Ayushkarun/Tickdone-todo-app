class Apiservice {
  static const String apiKey = 'AIzaSyAabkwoAsDrqHHjd83GebVChCo4Maqp6aU';
  static const String firestoreBaseUrl =
      'https://firestore.googleapis.com/v1/projects/tickdonetodo/databases/(default)/documents';
  static const String register =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
  static const String login =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
  static const String forgotPassword =
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey';
  static const String googleSignIn =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=$apiKey';
  static const String refreshToken =
      'https://securetoken.googleapis.com/v1/token?key=$apiKey';
  static const String changeEmail =
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey';
}
