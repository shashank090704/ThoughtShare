// lib/widgets/chat_list_item.dart
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final String currentUserId;
  final VoidCallback onTap;
  
  const ChatListItem({
    Key? key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isUnread = chat.lastSenderId != currentUserId && chat.unreadCount > 0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor,
          radius: 28,
          child: Text(
            chat.otherUsername[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(
          chat.otherUsername,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
            fontSize: 16,
            color: AppConstants.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isUnread ? AppConstants.textPrimary : AppConstants.textSecondary,
              fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppHelpers.formatTimestamp(chat.lastMessageTime),
              style: TextStyle(
                fontSize: 12,
                color: isUnread ? AppConstants.primaryColor : AppConstants.textSecondary,
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isUnread) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount > 9 ? '9+' : chat.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}