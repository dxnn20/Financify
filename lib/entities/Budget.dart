
class Budget{
  String id;
  String name;
  double amount;
  String startDate;
  String endDate;
  String userId;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

   getId() {
     return id;
   }
}