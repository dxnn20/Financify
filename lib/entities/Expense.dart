
class Expense {
  final String id;
  final String title;
  final double amount;
  final String date;
  final String? description;
  final String? category;
  final String userId;
  final String budgetId;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.description = 'A simple expense',
    this.category = 'Miscellaneous',
    required this.userId,
    required this.budgetId
  });
}