// // lib/screens/feed_screen.dart
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../services/post_service.dart';
// import '../models/post_model.dart';
// import '../widgets/post_card.dart';
// import '../utils/constants.dart';
// import 'create_post_screen.dart';
// import 'chat_screen.dart';
// import 'login_screen.dart';

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({Key? key}) : super(key: key);
  
//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   final _authService = AuthService();
//   final _postService = PostService();
  
//   Future<void> _logout() async {
//     await _authService.signOut();
//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     }
//   }
  
//   void _navigateToCreatePost() async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => const CreatePostScreen()),
//     );
    
//     if (result == true && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Post created successfully!')),
//       );
//     }
//   }
  
//   void _navigateToChat(PostModel post) {
//     final currentUserId = _authService.currentUser?.uid;
    
//     if (currentUserId == post.userId) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("You can't chat with yourself!")),
//       );
//       return;
//     }
    
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => ChatScreen(
//           receiverId: post.userId,
//           receiverName: post.username,
//         ),
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppConstants.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           AppConstants.feedTitle,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppConstants.primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: StreamBuilder<List<PostModel>>(
//         stream: _postService.getPosts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
          
//           final posts = snapshot.data ?? [];
          
//           if (posts.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.post_add,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No posts yet',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Be the first to share a thought!',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           return ListView.builder(
//             itemCount: posts.length,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             itemBuilder: (context, index) {
//               final post = posts[index];
//               return PostCard(
//                 post: post,
//                 onTap: () => _navigateToChat(post),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToCreatePost,
//         backgroundColor: AppConstants.primaryColor,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

// // lib/screens/feed_screen.dart
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../services/post_service.dart';
// import '../models/post_model.dart';
// import '../widgets/post_card.dart';
// import '../utils/constants.dart';
// import 'create_post_screen.dart';
// import 'chat_screen.dart';
// import 'chat_list_screen.dart';
// import 'login_screen.dart';

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({Key? key}) : super(key: key);
  
//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   final _authService = AuthService();
//   final _postService = PostService();
//   int _selectedIndex = 0;
  
//   Future<void> _logout() async {
//     await _authService.signOut();
//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     }
//   }
  
//   void _navigateToCreatePost() async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => const CreatePostScreen()),
//     );
    
//     if (result == true && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Post created successfully!')),
//       );
//     }
//   }
  
//   void _navigateToChat(PostModel post) {
//     final currentUserId = _authService.currentUser?.uid;
    
//     if (currentUserId == post.userId) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("You can't chat with yourself!")),
//       );
//       return;
//     }
    
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => ChatScreen(
//           receiverId: post.userId,
//           receiverName: post.username,
//         ),
//       ),
//     );
//   }
  
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
  
//   Widget _buildFeedContent() {
//     return Column(
//       children: [
//         Expanded(
//           child: StreamBuilder<List<PostModel>>(
//             stream: _postService.getPosts(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
              
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text('Error: ${snapshot.error}'),
//                 );
//               }
              
//               final posts = snapshot.data ?? [];
              
//               if (posts.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.post_add,
//                         size: 80,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No posts yet',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Be the first to share a thought!',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[500],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
              
//               return ListView.builder(
//                 itemCount: posts.length,
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemBuilder: (context, index) {
//                   final post = posts[index];
//                   return PostCard(
//                     post: post,
//                     onTap: () => _navigateToChat(post),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildFeedContent(),
//       const ChatListScreen(),
//     ];
    
//     return Scaffold(
//       backgroundColor: AppConstants.backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           _selectedIndex == 0 ? AppConstants.feedTitle : 'Messages',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppConstants.primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: screens,
//       ),
//       floatingActionButton: _selectedIndex == 0
//           ? FloatingActionButton(
//               onPressed: _navigateToCreatePost,
//               backgroundColor: AppConstants.primaryColor,
//               child: const Icon(Icons.add, color: Colors.white),
//             )
//           : null,
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Feed',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Messages',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppConstants.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         backgroundColor: Colors.white,
//         type: BottomNavigationBarType.fixed,
//         elevation: 8,
//       ),
//     );
//   }
// }

// lib/screens/feed_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';
import '../utils/constants.dart';
import 'create_post_screen.dart';
import 'chat_screen.dart';
import 'chat_list_screen.dart';
import 'login_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);
  
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _authService = AuthService();
  final _postService = PostService();
  int _selectedIndex = 0;
  
  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }
  
  void _navigateToCreatePost() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
    
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );
    }
  }
  
  void _navigateToChat(PostModel post) {
    final currentUserId = _authService.currentUser?.uid;
    
    if (currentUserId == post.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can't chat with yourself!")),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          receiverId: post.userId,
          receiverName: post.username,
        ),
      ),
    );
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  Widget _buildFeedContent() {
    return StreamBuilder<List<PostModel>>(
      stream: _postService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        
        final posts = snapshot.data ?? [];
        
        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.post_add,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to share a thought!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(
              post: post,
              onTap: () => _navigateToChat(post),
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildFeedContent(),
      const ChatListScreen(showAppBar: false), // Pass false to hide AppBar
    ];
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? AppConstants.feedTitle : 'Messages',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _navigateToCreatePost,
              backgroundColor: AppConstants.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}