import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/portfolio_item.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PortfolioRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  CollectionReference get _holdingsRef =>
      _firestore.collection('users').doc(_uid).collection('holdings');

  Stream<List<PortfolioItem>> getPortfolioStream() {
    if (_uid.isEmpty) return Stream.value([]);
    
    return _holdingsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PortfolioItem.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addOrUpdateHolding(PortfolioItem item) async {
    if (_uid.isEmpty) throw Exception('User not authenticated');

    final doc = await _holdingsRef.doc(item.coinId).get();
    
    if (doc.exists) {
      // If already exists, update the amount and recalculate avg buy price
      final existingData = doc.data() as Map<String, dynamic>;
      final double existingAmount = (existingData['amount'] ?? 0.0).toDouble();
      final double existingBuyPrice = (existingData['buyPrice'] ?? 0.0).toDouble();
      
      final double newTotalAmount = existingAmount + item.amount;
      // Recalculate average price: (oldAmount*oldPrice + newAmount*newPrice) / totalAmount
      final double newAvgPrice = ((existingAmount * existingBuyPrice) + (item.amount * item.buyPrice)) / newTotalAmount;
      
      await _holdingsRef.doc(item.coinId).update({
        'amount': newTotalAmount,
        'buyPrice': newAvgPrice,
        'buyDate': Timestamp.now(), // Update to last purchase date
      });
    } else {
      // New holding
      await _holdingsRef.doc(item.coinId).set(item.toMap());
    }
  }

  Future<void> removeHolding(String coinId) async {
    if (_uid.isEmpty) return;
    await _holdingsRef.doc(coinId).delete();
  }
}
