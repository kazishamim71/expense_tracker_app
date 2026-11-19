class Expense {
  final int? id;
  final String title;
  final double amount;

  const Expense({this.id, required this.title, required this.amount});

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'amount': amount,
      };

  factory Expense.fromMap(Map<String, Object?> map) => Expense(
        id: map['id'] as int?,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
      );
}
