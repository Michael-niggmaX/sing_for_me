import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singforme/main.dart';

void main() {
  // Setup mock SharedPreferences sebelum test
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with LoginScreen when not logged in', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that LoginScreen is shown (find email field)
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Login with valid credentials works', (
    WidgetTester tester,
  ) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify LoginScreen is shown
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Find email and password fields
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;

    // Enter valid credentials
    await tester.enterText(emailField, 'user@example.com');
    await tester.enterText(passwordField, 'password123');

    // Tap Sign In button
    final signInButton = find.text('Sign In');
    await tester.tap(signInButton);
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify we navigated to HomeScreen
    expect(find.text('Lift Your Voices, Sing For Me'), findsOneWidget);
  });

  testWidgets('Login with invalid credentials shows error', (
    WidgetTester tester,
  ) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Find email and password fields
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;

    // Enter invalid credentials
    await tester.enterText(emailField, 'wrong@email.com');
    await tester.enterText(passwordField, 'wrongpassword');

    // Tap Sign In button
    final signInButton = find.text('Sign In');
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify error message appears
    expect(find.text('Invalid email or password'), findsOneWidget);
  });

  testWidgets('Logout from settings works', (WidgetTester tester) async {
    // Setup mock SharedPreferences with logged in state
    SharedPreferences.setMockInitialValues({
      'isLoggedIn': true,
      'userEmail': 'user@example.com',
    });

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify HomeScreen is shown
    expect(find.text('Lift Your Voices, Sing For Me'), findsOneWidget);

    // Navigate to Settings
    final settingsIcon = find.byIcon(Icons.settings);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();

    // Verify Settings is shown
    expect(find.text('Settings'), findsOneWidget);

    // Find and tap Log Out button
    final logoutButton = find.text('Log Out');
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Verify logout confirmation dialog appears
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);

    // Tap Log Out button in dialog
    final confirmLogout = find.text('Log Out').last;
    await tester.tap(confirmLogout);
    await tester.pumpAndSettle();

    // Verify we're back on LoginScreen
    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets('Login screen shows demo account info', (
    WidgetTester tester,
  ) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify demo account info is displayed
    expect(find.text('🔑 Demo Account'), findsOneWidget);
    expect(find.text('Email: user@example.com'), findsOneWidget);
    expect(find.text('Password: password123'), findsOneWidget);
  });

  testWidgets('Password visibility toggle works', (WidgetTester tester) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Find password field
    final passwordField = find.byType(TextField).last;

    // Initially password should be obscured
    expect(passwordField, findsOneWidget);

    // Find visibility icon and tap it
    final visibilityIcon = find.byIcon(Icons.visibility_off);
    expect(visibilityIcon, findsOneWidget);

    await tester.tap(visibilityIcon);
    await tester.pump();

    // Icon should change to visibility
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('Forgot password button shows message', (
    WidgetTester tester,
  ) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Find and tap Forgot Password
    final forgotPassword = find.text('Forgot Password?');
    await tester.tap(forgotPassword);
    await tester.pump();

    // Verify snackbar appears
    expect(find.text('Reset password feature coming soon!'), findsOneWidget);
  });

  testWidgets('Sign up button shows message', (WidgetTester tester) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app
    await tester.pumpWidget(const MyApp());

    // Find and tap Sign Up
    final signUp = find.text('Sign Up');
    await tester.tap(signUp);
    await tester.pump();

    // Verify snackbar appears
    expect(find.text('Sign up feature coming soon!'), findsOneWidget);
  });
}
