// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  
  const PostCard({
    Key? key,
    required this.post,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.cardPadding,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppConstants.primaryColor,
                    child: Text(
                      post.username[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        Text(
                          AppHelpers.formatTimestamp(post.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Post content
              Text(
                post.content,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppConstants.textPrimary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}