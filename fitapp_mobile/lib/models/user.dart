class User {
  final String id;
  final String fullName;
  final String username;
  final int age;
  final int height;
  final int weight;
  final String sex;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
    required this.sex,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      sex: json['sex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'age': age,
      'height': height,
      'weight': weight,
      'sex': sex == 'male' ? true : false,
    };
  }
}