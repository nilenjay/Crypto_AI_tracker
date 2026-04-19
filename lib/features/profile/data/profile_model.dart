class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final DateTime memberSince;
  final String memberType;
  final String portfolioValue;
  final int holdingsCount;
  final String pnlTotal;
  final String currency;
  final bool notificationsEnabled;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.memberSince,
    required this.memberType,
    required this.portfolioValue,
    required this.holdingsCount,
    required this.pnlTotal,
    required this.currency,
    required this.notificationsEnabled,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] ?? 'Crypto Trader',
      email: data['email'] ?? '',
      memberSince: (data['memberSince'] as dynamic)?.toDate() ?? DateTime.now(),
      memberType: data['memberType'] ?? 'Premium Member',
      portfolioValue: data['portfolioValue'] ?? '₹0',
      holdingsCount: data['holdingsCount'] ?? 0,
      pnlTotal: data['pnlTotal'] ?? '+0.0%',
      currency: data['currency'] ?? '₹',
      notificationsEnabled: data['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'memberSince': memberSince,
      'memberType': memberType,
      'portfolioValue': portfolioValue,
      'holdingsCount': holdingsCount,
      'pnlTotal': pnlTotal,
      'currency': currency,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    DateTime? memberSince,
    String? memberType,
    String? portfolioValue,
    int? holdingsCount,
    String? pnlTotal,
    String? currency,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      memberSince: memberSince ?? this.memberSince,
      memberType: memberType ?? this.memberType,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      holdingsCount: holdingsCount ?? this.holdingsCount,
      pnlTotal: pnlTotal ?? this.pnlTotal,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
