// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  
  // Strings
  static const String appName = 'ThoughtShare';
  static const String loginTitle = 'Welcome Back';
  static const String signupTitle = 'Create Account';
  static const String feedTitle = 'Feed';
  static const String createPostTitle = 'Share Your Thought';
  
  // Sizing
  static const double borderRadius = 12.0;
  static const double cardPadding = 16.0;
  static const double spacing = 16.0;
}