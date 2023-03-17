class LocalUser {
  final String id;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  const LocalUser({
    required this.id,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  factory LocalUser.fromMap(Map<String, dynamic> map) => LocalUser(
        id: map['id'],
        displayName: map['displayName'],
        photoUrl: map['photoUrl'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          int.parse(map['createdAt']),
        ),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'createdAt': createdAt.millisecondsSinceEpoch.toString(),
      };
}
