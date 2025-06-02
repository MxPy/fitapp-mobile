class UserDay {
  final String id;
  final String userId;
  final String userDate;
  final int dailyKcal;
  final int dailyProteins;
  final int dailyCarbs;
  final int dailyFats;

  UserDay({
    required this.id,
    required this.userId,
    required this.userDate,
    required this.dailyKcal,
    required this.dailyProteins,
    required this.dailyCarbs,
    required this.dailyFats,
  });

  factory UserDay.fromJson(Map<String, dynamic> json) {
    return UserDay(
      id: json['id'],
      userId: json['user_id'],
      userDate: json['user_date'],
      dailyKcal: json['daily_kcal'],
      dailyProteins: json['daily_proteins'],
      dailyCarbs: json['daily_carbs'],
      dailyFats: json['daily_fats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_date': userDate,
      'daily_kcal': dailyKcal,
      'daily_proteins': dailyProteins,
      'daily_carbs': dailyCarbs,
      'daily_fats': dailyFats,
    };
  }
}