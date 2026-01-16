import 'dart:io';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';
import 'package:uuid/uuid.dart';

class PostProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final GeminiService _geminiService = GeminiService();
  final Uuid _uuid = const Uuid();

  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void listenToPosts() {
    _firestoreService.getPostsFeed().listen((posts) {
      _posts = posts;
      notifyListeners();
    });
  }

  Future<bool> createPost({
    required String authorId,
    required String authorName,
    String? authorAvatar,
    String? authorTitle,
    required String content,
    List<File>? images,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final postId = _uuid.v4();
      List<String> mediaUrls = [];

      // Upload images if any
      if (images != null && images.isNotEmpty) {
        mediaUrls = await _storageService.uploadMultipleImages(
          images,
          'post_images',
          postId,
        );
      }

      final post = PostModel(
        id: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        authorTitle: authorTitle,
        content: content,
        mediaUrls: mediaUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreService.createPost(post);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      await _firestoreService.toggleLike(postId, userId);

      // Update local state
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final newLikes = List<String>.from(post.likes);
        if (newLikes.contains(userId)) {
          newLikes.remove(userId);
        } else {
          newLikes.add(userId);
        }
        _posts[index] = post.copyWith(likes: newLikes);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.deletePost(postId);
      _posts.removeWhere((p) => p.id == postId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String> enhanceContent(String content) async {
    try {
      _isLoading = true;
      notifyListeners();

      final enhanced = await _geminiService.enhancePostContent(content);

      _isLoading = false;
      notifyListeners();
      return enhanced;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return content;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
