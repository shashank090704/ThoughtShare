// // lib/screens/chat_list_screen.dart
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../services/chat_service.dart';
// import '../models/chat_model.dart';
// import '../widgets/chat_list_item.dart';
// import '../utils/constants.dart';
// import 'chat_screen.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({Key? key}) : super(key: key);
  
//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   final _authService = AuthService();
//   final _chatService = ChatService();
  
//   void _navigateToChat(ChatModel chat) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => ChatScreen(
//           receiverId: chat.otherUserId,
//           receiverName: chat.otherUsername,
//         ),
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = _authService.currentUser?.uid;
    
//     if (currentUserId == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text('Please log in to view chats'),
//         ),
//       );
//     }
    
//     return Scaffold(
//       backgroundColor: AppConstants.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           'Messages',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppConstants.primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: StreamBuilder<List<ChatModel>>(
//         stream: _chatService.getUserChats(currentUserId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     size: 60,
//                     color: Colors.red[300],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Error loading chats',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     snapshot.error.toString(),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[500],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           final chats = snapshot.data ?? [];
          
//           if (chats.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.chat_bubble_outline,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No conversations yet',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32),
//                     child: Text(
//                       'Start chatting by tapping the chat icon on any post',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[500],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           return ListView.builder(
//             itemCount: chats.length,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               return ChatListItem(
//                 chat: chat,
//                 currentUserId: currentUserId,
//                 onTap: () => _navigateToChat(chat),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// lib/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../models/chat_model.dart';
import '../widgets/chat_list_item.dart';
import '../utils/constants.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final bool showAppBar;
  
  const ChatListScreen({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);
  
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _authService = AuthService();
  final _chatService = ChatService();
  
  void _navigateToChat(ChatModel chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          receiverId: chat.otherUserId,
          receiverName: chat.otherUsername,
        ),
      ),
    );
  }
  
  Widget _buildChatList() {
    final currentUserId = _authService.currentUser?.uid;
    
    if (currentUserId == null) {
      return const Center(
        child: Text('Please log in to view chats'),
      );
    }
    
    return StreamBuilder<List<ChatModel>>(
      stream: _chatService.getUserChats(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading chats',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        
        final chats = snapshot.data ?? [];
        
        if (chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No conversations yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Start chatting by tapping the chat icon on any post',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: chats.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ChatListItem(
              chat: chat,
              currentUserId: currentUserId,
              onTap: () => _navigateToChat(chat),
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // If showAppBar is false, return just the content without Scaffold
    if (!widget.showAppBar) {
      return _buildChatList();
    }
    
    // Otherwise, return full Scaffold with AppBar
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildChatList(),
    );
  }
}