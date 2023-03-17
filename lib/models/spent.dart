class Spent {
  final String id;
  final String description;
  final double amount;
  final String userId;

  Spent({
    required this.id,
    required this.description,
    required this.amount,
    required this.userId,
  });

  factory Spent.fromMap(Map<String, dynamic> map) => Spent(
        id: map['id'],
        description: map['description'],
        amount: double.parse(map['amount']),
        userId: map['userId'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'amount': amount,
        'userId': userId,
      };
}
