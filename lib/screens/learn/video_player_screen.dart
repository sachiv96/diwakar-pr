import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../config/theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String? videoUrl;
  final String title;
  final String? moduleTitle;

  const VideoPlayerScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
    this.videoUrl,
    required this.title,
    this.moduleTitle,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  late TabController _tabController;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _isInitialized = false;
  double _playbackSpeed = 1.0;

  // Notes
  final List<VideoNote> _notes = [];
  final TextEditingController _noteController = TextEditingController();

  // Q&A
  final List<QuestionAnswer> _questions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeVideo();

    // Add sample Q&A
    _questions.addAll([
      QuestionAnswer(
        id: '1',
        question: 'What is the main benefit of this approach?',
        answer: 'The main benefit is improved scalability and maintainability.',
        userName: 'Student A',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  Future<void> _initializeVideo() async {
    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      try {
        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
        _controller!.addListener(_videoListener);
      } catch (e) {
        debugPrint('Error initializing video: $e');
      }
    }
  }

  void _videoListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _tabController.dispose();
    _noteController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  void _addNote() {
    if (_noteController.text.isNotEmpty && _controller != null) {
      setState(() {
        _notes.add(VideoNote(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: _controller!.value.position,
          content: _noteController.text,
          createdAt: DateTime.now(),
        ));
        _noteController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _seekToTimestamp(Duration timestamp) {
    _controller?.seekTo(timestamp);
    _controller?.play();
  }

  Future<void> _markAsComplete() async {
    // In a real app, this would update Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lesson marked as complete! ✓'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return _buildFullScreenPlayer();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player
          _buildVideoPlayer(),

          // Content below video
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Video info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (widget.moduleTitle != null)
                          Text(
                            widget.moduleTitle!,
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondaryLight,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Notes 📝'),
                      Tab(text: 'Resources'),
                      Tab(text: 'Q&A'),
                    ],
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(),
                        _buildNotesTab(),
                        _buildResourcesTab(),
                        _buildQATab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _markAsComplete,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Mark as Complete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            Center(
              child: _controller != null && _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
            if (_showControls) ...[
              // Back button
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                  onPressed: _toggleFullScreen,
                ),
              ),
              // Controls overlay
              _buildVideoControls(isFullScreen: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Container(
        height: 220,
        color: Colors.black,
        child: Stack(
          children: [
            // Video
            Center(
              child: _controller != null && _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : widget.videoUrl != null
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              size: 64,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Video not available',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
            ),
            // Controls overlay
            if (_showControls && _controller != null && _isInitialized)
              _buildVideoControls(isFullScreen: false),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoControls({required bool isFullScreen}) {
    if (_controller == null || !_isInitialized) return const SizedBox();

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    final isPlaying = _controller!.value.isPlaying;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Progress bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isFullScreen ? 32 : 16),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      trackHeight: 3,
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      value: position.inMilliseconds.toDouble(),
                      min: 0,
                      max: duration.inMilliseconds.toDouble(),
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.white.withOpacity(0.3),
                      onChanged: (value) {
                        _controller!
                            .seekTo(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Control buttons
            Padding(
              padding: EdgeInsets.only(
                bottom: isFullScreen ? 32 : 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 32),
                    onPressed: () {
                      // Navigate to previous lesson
                    },
                  ),
                  // Rewind 10s
                  IconButton(
                    icon: const Icon(Icons.replay_10,
                        color: Colors.white, size: 32),
                    onPressed: () {
                      final newPosition =
                          position - const Duration(seconds: 10);
                      _controller!.seekTo(
                        newPosition < Duration.zero
                            ? Duration.zero
                            : newPosition,
                      );
                    },
                  ),
                  // Play/Pause
                  GestureDetector(
                    onTap: () {
                      if (isPlaying) {
                        _controller!.pause();
                      } else {
                        _controller!.play();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  // Forward 10s
                  IconButton(
                    icon: const Icon(Icons.forward_10,
                        color: Colors.white, size: 32),
                    onPressed: () {
                      final newPosition =
                          position + const Duration(seconds: 10);
                      _controller!.seekTo(
                        newPosition > duration ? duration : newPosition,
                      );
                    },
                  ),
                  // Next
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 32),
                    onPressed: () {
                      // Navigate to next lesson
                    },
                  ),
                ],
              ),
            ),
            // Bottom row with extra controls
            if (!isFullScreen)
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Speed button
                    TextButton(
                      onPressed: _showSpeedDialog,
                      child: Text(
                        '${_playbackSpeed}x',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    // Fullscreen button
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: _toggleFullScreen,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Playback Speed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...([0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]).map((speed) {
              return ListTile(
                title: Text('${speed}x'),
                trailing: _playbackSpeed == speed
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() {
                    _playbackSpeed = speed;
                    _controller?.setPlaybackSpeed(speed);
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Playback Speed'),
              trailing: Text('${_playbackSpeed}x'),
              onTap: () {
                Navigator.pop(context);
                _showSpeedDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.high_quality),
              title: const Text('Quality'),
              trailing: const Text('Auto'),
              onTap: () {
                Navigator.pop(context);
                // Show quality options
              },
            ),
            ListTile(
              leading: const Icon(Icons.closed_caption),
              title: const Text('Captions'),
              trailing: const Text('Off'),
              onTap: () {
                Navigator.pop(context);
                // Show caption options
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this lesson',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This lesson covers the key concepts and techniques you need to understand. '
            'Watch the entire video and take notes for better retention.',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Up Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Lesson Title',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '15 min',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        // Add note input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: _controller != null && _isInitialized
                        ? 'Add note at ${_formatDuration(_controller!.value.position)}'
                        : 'Add note...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _addNote,
                icon:
                    Icon(Icons.add_circle, color: AppColors.primary, size: 32),
              ),
            ],
          ),
        ),
        // Notes list
        Expanded(
          child: _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 64,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No notes yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add notes while watching to remember key points',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _seekToTimestamp(note.timestamp),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.push_pin,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDuration(note.timestamp),
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: AppColors.textSecondaryLight,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _notes.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(note.content),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildResourcesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: AppColors.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          const Text(
            'No resources available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Resources for this lesson will appear here',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQATab() {
    return Column(
      children: [
        // Ask question button
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () {
              _showAskQuestionDialog();
            },
            icon: const Icon(Icons.add),
            label: const Text('Ask a Question'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // Q&A list
        Expanded(
          child: _questions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.question_answer_outlined,
                        size: 64,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No questions yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to ask a question!',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final qa = _questions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: Text(
                                  qa.userName[0].toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      qa.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _formatTimeAgo(qa.timestamp),
                                      style: TextStyle(
                                        color: AppColors.textSecondaryLight,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Q: ${qa.question}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (qa.answer != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'A: ${qa.answer}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showAskQuestionDialog() {
    final questionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask a Question'),
        content: TextField(
          controller: questionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Type your question here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionController.text.isNotEmpty) {
                setState(() {
                  _questions.insert(
                      0,
                      QuestionAnswer(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        question: questionController.text,
                        userName: 'You',
                        timestamp: DateTime.now(),
                      ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question submitted!')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class VideoNote {
  final String id;
  final Duration timestamp;
  final String content;
  final DateTime createdAt;

  VideoNote({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.createdAt,
  });
}

class QuestionAnswer {
  final String id;
  final String question;
  final String? answer;
  final String userName;
  final DateTime timestamp;

  QuestionAnswer({
    required this.id,
    required this.question,
    this.answer,
    required this.userName,
    required this.timestamp,
  });
}
