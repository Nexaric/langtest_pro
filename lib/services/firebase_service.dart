import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Save User Details in Firestore (After Signup)
  Future<void> saveUserData(String name, String email) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'purchasedCourses': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Fetch User Data from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return await _firestore.collection('users').doc(user.uid).get();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  // Update User Profile (Name, Email)
  Future<void> updateUserProfile(String name, String email) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await user.updateEmail(email);
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  // Upload Profile Picture to Firebase Storage
  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String filePath = 'profile_pictures/${user.uid}.jpg';
        TaskSnapshot snapshot = await _storage.ref(filePath).putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        await _firestore.collection('users').doc(user.uid).update({
          'profilePicture': downloadUrl,
        });
        return downloadUrl;
      }
    } catch (e) {
      print("Error uploading profile picture: $e");
    }
    return null;
  }

  // Retrieve Profile Picture URL
  Future<String?> getProfilePictureUrl() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await _firestore.collection('users').doc(user.uid).get();
        return userData.data()?['profilePicture'];
      }
    } catch (e) {
      print("Error retrieving profile picture: $e");
    }
    return null;
  }

  // Purchase Course (Save Course ID to Firestore)
  Future<void> purchaseCourse(String courseId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'purchasedCourses': FieldValue.arrayUnion([courseId]),
        });
      }
    } catch (e) {
      print("Error purchasing course: $e");
    }
  }

  // Get User's Purchased Courses
  Future<List<String>> getUserPurchasedCourses() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        return List<String>.from(snapshot.data()?['purchasedCourses'] ?? []);
      }
    } catch (e) {
      print("Error fetching purchased courses: $e");
    }
    return [];
  }
}
