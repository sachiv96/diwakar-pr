import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_avatar.dart';

/// Friend status enum
enum FriendStatus { friend, pending, requested, none }

/// Friend Model
class FriendModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String institution;
  final int points;
  final int rank;
  final FriendStatus status;
  final bool isOnline;
  final DateTime? lastSeen;
  final int mutualFriends;

  const FriendModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.institution,
    required this.points,
    required this.rank,
    this.status = FriendStatus.friend,
    this.isOnline = false,
    this.lastSeen,
    this.mutualFriends = 0,
  });
}

/// Friends List Screen
class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data
  final List<FriendModel> _friends = [
    FriendModel(
      id: '1',
      name: 'Priya Sharma',
      avatarUrl: '',
      institution: 'Delhi Public School',
      points: 12500,
      rank: 45,
      isOnline: true,
      mutualFriends: 12,
    ),
    FriendModel(
      id: '2',
      name: 'Rahul Verma',
      avatarUrl: '',
      institution: 'Kendriya Vidyalaya',
      points: 10800,
      rank: 89,
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      mutualFriends: 8,
    ),
    FriendModel(
      id: '3',
      name: 'Ananya Patel',
      avatarUrl: '',
      institution: 'Ryan International',
      points: 15200,
      rank: 23,
      isOnline: true,
      mutualFriends: 15,
    ),
    FriendModel(
      id: '4',
      name: 'Vikram Singh',
      avatarUrl: '',
      institution: 'St. Xavier\'s',
      points: 9500,
      rank: 120,
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(days: 1)),
      mutualFriends: 5,
    ),
    FriendModel(
      id: '5',
      name: 'Neha Gupta',
      avatarUrl: '',
      institution: 'Army Public School',
      points: 11000,
      rank: 78,
      isOnline: true,
      mutualFriends: 10,
    ),
  ];

  final List<FriendModel> _pendingRequests = [
    FriendModel(
      id: '6',
      name: 'Arjun Reddy',
      avatarUrl: '',
      institution: 'Narayana School',
      points: 8500,
      rank: 150,
      status: FriendStatus.pending,
      mutualFriends: 3,
    ),
    FriendModel(
      id: '7',
      name: 'Kavya Menon',
      avatarUrl: '',
      institution: 'DAV School',
      points: 7800,
      rank: 180,
      status: FriendStatus.pending,
      mutualFriends: 6,
    ),
  ];

  final List<FriendModel> _suggestions = [
    FriendModel(
      id: '8',
      name: 'Aditya Kumar',
      avatarUrl: '',
      institution: 'Delhi Public School',
      points: 9200,
      rank: 110,
      status: FriendStatus.none,
      mutualFriends: 8,
    ),
    FriendModel(
      id: '9',
      name: 'Sneha Joshi',
      avatarUrl: '',
      institution: 'Modern School',
      points: 10200,
      rank: 95,
      status: FriendStatus.none,
      mutualFriends: 11,
    ),
    FriendModel(
      id: '10',
      name: 'Ravi Krishnan',
      avatarUrl: '',
      institution: 'Vidya Mandir',
      points: 8900,
      rank: 125,
      status: FriendStatus.none,
      mutualFriends: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<FriendModel> get _filteredFriends {
    if (_searchQuery.isEmpty) return _friends;
    return _friends
        .where((f) =>
            f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            f.institution.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Friends'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => _showAddFriendDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          _buildStatsHeader(),

          // Search Bar
          _buildSearchBar(),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Friends (${_friends.length})'),
                Tab(text: 'Requests (${_pendingRequests.length})'),
                const Tab(text: 'Suggestions'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildRequestsList(),
                _buildSuggestionsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final onlineFriends = _friends.where((f) => f.isOnline).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${_friends.length}', 'Friends'),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem('$onlineFriends', 'Online'),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem('${_pendingRequests.length}', 'Requests'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search friends...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList() {
    final friends = _filteredFriends;

    if (friends.isEmpty) {
      return _buildEmptyState(
        Icons.people_outline,
        _searchQuery.isEmpty ? 'No friends yet' : 'No friends found',
        _searchQuery.isEmpty
            ? 'Start connecting with other learners!'
            : 'Try a different search term',
      );
    }

    // Sort: Online first, then by rank
    friends.sort((a, b) {
      if (a.isOnline && !b.isOnline) return -1;
      if (!a.isOnline && b.isOnline) return 1;
      return a.rank.compareTo(b.rank);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return _buildFriendCard(friends[index]);
      },
    );
  }

  Widget _buildFriendCard(FriendModel friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showFriendOptions(friend),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CustomAvatar(
                      imageUrl: friend.avatarUrl,
                      name: friend.name,
                      size: 56,
                    ),
                    if (friend.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              friend.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#${friend.rank}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        friend.institution,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            size: 14,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${friend.points} XP',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            friend.isOnline
                                ? 'Online'
                                : _getLastSeenText(friend.lastSeen),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  friend.isOnline ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                IconButton(
                  icon: const Icon(Icons.message_outlined),
                  color: AppColors.primary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chat feature coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    if (_pendingRequests.isEmpty) {
      return _buildEmptyState(
        Icons.person_add_outlined,
        'No pending requests',
        'Friend requests will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(_pendingRequests[index]);
      },
    );
  }

  Widget _buildRequestCard(FriendModel request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CustomAvatar(
                  imageUrl: request.avatarUrl,
                  name: request.name,
                  size: 56,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.institution,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${request.mutualFriends} mutual friends',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _declineRequest(request),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptRequest(request),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section: Based on mutual friends
        const Text(
          'People you may know',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ..._suggestions.map((suggestion) {
          return _buildSuggestionCard(suggestion);
        }),

        const SizedBox(height: 24),

        // Find by username/email
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.search,
                size: 48,
                color: AppColors.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'Find Friends',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Search by username or invite from contacts',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showAddFriendDialog(),
                      icon: const Icon(Icons.person_search, size: 18),
                      label: const Text('Find'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showInviteDialog(),
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Invite'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(FriendModel suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CustomAvatar(
              imageUrl: suggestion.avatarUrl,
              name: suggestion.name,
              size: 56,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestion.institution,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${suggestion.mutualFriends} mutual friends',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _sendFriendRequest(suggestion),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getLastSeenText(DateTime? lastSeen) {
    if (lastSeen == null) return 'Offline';
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _showFriendOptions(FriendModel friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Friend info
            Row(
              children: [
                CustomAvatar(
                  imageUrl: friend.avatarUrl,
                  name: friend.name,
                  size: 60,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        friend.institution,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Options
            _buildOptionTile(
              Icons.person_outline,
              'View Profile',
              () {
                Navigator.pop(context);
                // Navigate to profile
              },
            ),
            _buildOptionTile(
              Icons.message_outlined,
              'Send Message',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat feature coming soon!')),
                );
              },
            ),
            _buildOptionTile(
              Icons.notifications_outlined,
              'Mute Notifications',
              () {
                Navigator.pop(context);
              },
            ),
            _buildOptionTile(
              Icons.block,
              'Block User',
              () {
                Navigator.pop(context);
                _showBlockConfirmation(friend);
              },
              isDestructive: true,
            ),
            _buildOptionTile(
              Icons.person_remove_outlined,
              'Remove Friend',
              () {
                Navigator.pop(context);
                _showRemoveFriendConfirmation(friend);
              },
              isDestructive: true,
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Friend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter username or email',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friend request sent!')),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Invite Friends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInviteOption(
                  Icons.share,
                  'Share Link',
                  Colors.blue,
                ),
                _buildInviteOption(
                  Icons.message,
                  'WhatsApp',
                  Colors.green,
                ),
                _buildInviteOption(
                  Icons.mail,
                  'Email',
                  Colors.red,
                ),
                _buildInviteOption(
                  Icons.copy,
                  'Copy',
                  Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label sharing coming soon!')),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _acceptRequest(FriendModel request) {
    setState(() {
      _pendingRequests.remove(request);
      _friends.add(FriendModel(
        id: request.id,
        name: request.name,
        avatarUrl: request.avatarUrl,
        institution: request.institution,
        points: request.points,
        rank: request.rank,
        status: FriendStatus.friend,
        mutualFriends: request.mutualFriends,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You are now friends with ${request.name}!')),
    );
  }

  void _declineRequest(FriendModel request) {
    setState(() {
      _pendingRequests.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request declined')),
    );
  }

  void _sendFriendRequest(FriendModel suggestion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent to ${suggestion.name}')),
    );
  }

  void _showBlockConfirmation(FriendModel friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${friend.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _friends.removeWhere((f) => f.id == friend.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${friend.name} has been blocked')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showRemoveFriendConfirmation(FriendModel friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text('Remove ${friend.name} from your friends list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _friends.removeWhere((f) => f.id == friend.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${friend.name} removed from friends')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
