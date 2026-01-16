import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  // Upload profile image
  Future<String?> uploadProfileImage(File file, String userId) async {
    try {
      final fileName = '${userId}_${_uuid.v4()}';
      final ref =
          _storage.ref().child(AppConstants.profileImagesPath).child(fileName);

      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Upload cover image
  Future<String?> uploadCoverImage(File file, String userId) async {
    try {
      final fileName = '${userId}_cover_${_uuid.v4()}';
      final ref =
          _storage.ref().child(AppConstants.coverImagesPath).child(fileName);

      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading cover image: $e');
      return null;
    }
  }

  // Upload post image
  Future<String?> uploadPostImage(File file, String postId) async {
    try {
      final fileName = '${postId}_${_uuid.v4()}';
      final ref =
          _storage.ref().child(AppConstants.postImagesPath).child(fileName);

      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading post image: $e');
      return null;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> files,
    String folder,
    String prefix,
  ) async {
    final List<String> urls = [];

    for (var file in files) {
      try {
        final fileName = '${prefix}_${_uuid.v4()}';
        final ref = _storage.ref().child(folder).child(fileName);

        final uploadTask = await ref.putFile(file);
        final url = await uploadTask.ref.getDownloadURL();
        urls.add(url);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return urls;
  }

  // Delete file by URL
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  // Get download URL
  Future<String?> getDownloadURL(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  }
}
