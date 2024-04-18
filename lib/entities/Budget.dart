
class Budget{
  String id;
  String name;
  double amount;
  String? currency;
  String startDate;
  String endDate;
  String userId;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    this.currency = 'dollar',
    required this.startDate,
    required this.endDate,
    required this.userId,
  });
}