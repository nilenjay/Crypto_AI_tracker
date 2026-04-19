import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;
  User? get currentUser => _auth.currentUser;

  Future<UserProfile> fetchProfile() async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');

    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists && doc.data() != null) {
      return UserProfile.fromFirestore(doc.data()!, uid);
    } else {
      // First time user – create a profile document from FirebaseAuth data
      final user = _auth.currentUser!;
      final newProfile = UserProfile(
        uid: uid,
        displayName: user.displayName ?? 'Crypto Trader',
        email: user.email ?? '',
        memberSince: user.metadata.creationTime ?? DateTime.now(),
        memberType: 'Premium Member',
        portfolioValue: '₹0',
        holdingsCount: 0,
        pnlTotal: '+0.0%',
        currency: '₹',
        notificationsEnabled: true,
      );
      await _firestore.collection('users').doc(uid).set(newProfile.toFirestore());
      return newProfile;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(uid).update(profile.toFirestore());
  }

  Future<void> updateCurrency(String currency) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(uid).update({'currency': currency});
  }

  Future<void> updateNotifications(bool enabled) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(uid).update({'notificationsEnabled': enabled});
  }
}
