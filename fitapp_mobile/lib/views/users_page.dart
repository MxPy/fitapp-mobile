// lib/views/users_page.dart
import 'package:fitapp_mobile/controllers/user_controller.dart';
import 'package:fitapp_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserController>(context, listen: false).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Użytkownicy'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<UserController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Błąd ładowania użytkowników',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadUsers(),
                    icon: Icon(Icons.refresh),
                    label: Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            );
          }

          if (controller.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Brak użytkowników',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dodaj pierwszego użytkownika aby rozpocząć',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddUserDialog(context),
                    icon: Icon(Icons.person_add),
                    label: Text('Dodaj użytkownika'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Aktualny użytkownik header
              if (controller.currentUser != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  color: Colors.green.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Aktualny: ${controller.currentUser!.fullName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Lista użytkowników
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    final isCurrentUser = controller.currentUser?.id == user.id;
                    
                    return Card(
                      elevation: isCurrentUser ? 4 : 1,
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      color: isCurrentUser ? Colors.green.withOpacity(0.1) : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCurrentUser ? Colors.green : Colors.blue,
                          child: Text(
                            user.fullName[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user.fullName,
                          style: TextStyle(
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('@${user.username}'),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                _buildInfoChip('${user.age} lat'),
                                SizedBox(width: 8),
                                _buildInfoChip('${user.height}cm'),
                                SizedBox(width: 8),
                                _buildInfoChip('${user.weight}kg'),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Ikona płci
                            Icon(
                              user.sex == 'male' ? Icons.male : Icons.female,
                              color: user.sex == 'male' ? Colors.blue : Colors.pink,
                            ),
                            SizedBox(width: 8),
                            // Przycisk wyboru
                            if (!isCurrentUser)
                              IconButton(
                                onPressed: () {
                                  controller.setCurrentUser(user);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Wybrano użytkownika: ${user.fullName}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                icon: Icon(Icons.person_pin),
                                tooltip: 'Wybierz użytkownika',
                              )
                            else
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                          ],
                        ),
                        onTap: () => _showUserDetailsDialog(context, user),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddUserDialog(context),
        icon: Icon(Icons.person_add),
        label: Text('Dodaj użytkownika'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                user.fullName[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(user.fullName),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nazwa użytkownika', '@${user.username}'),
            _buildDetailRow('Wiek', '${user.age} lat'),
            _buildDetailRow('Wzrost', '${user.height} cm'),
            _buildDetailRow('Waga', '${user.weight} kg'),
            _buildDetailRow('Płeć', user.sex == 'male' ? 'Mężczyzna' : 'Kobieta'),
            SizedBox(height: 16),
            Text(
              'BMI: ${_calculateBMI(user.weight, user.height)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Zamknij'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<UserController>(context, listen: false).setCurrentUser(user);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wybrano użytkownika: ${user.fullName}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Wybierz'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateBMI(int weight, int height) {
    final heightInMeters = height / 100.0;
    final bmi = weight / (heightInMeters * heightInMeters);
    return bmi.toStringAsFixed(1);
  }

  void _showAddUserDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final fullNameController = TextEditingController();
    final usernameController = TextEditingController();
    final ageController = TextEditingController();
    final heightController = TextEditingController();
    final weightController = TextEditingController();
    bool isMale = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Dodaj nowego użytkownika'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Imię i nazwisko *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pole wymagane';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nazwa użytkownika *',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pole wymagane';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      labelText: 'Wiek *',
                      prefixIcon: Icon(Icons.cake),
                      suffixText: 'lat',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pole wymagane';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0 || age > 120) {
                        return 'Wprowadź prawidłowy wiek (1-120)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: heightController,
                    decoration: InputDecoration(
                      labelText: 'Wzrost *',
                      prefixIcon: Icon(Icons.height),
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pole wymagane';
                      }
                      final height = int.tryParse(value);
                      if (height == null || height <= 0 || height > 250) {
                        return 'Wprowadź prawidłowy wzrost (1-250)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: 'Waga *',
                      prefixIcon: Icon(Icons.monitor_weight),
                      suffixText: 'kg',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pole wymagane';
                      }
                      final weight = int.tryParse(value);
                      if (weight == null || weight <= 0 || weight > 500) {
                        return 'Wprowadź prawidłową wagę (1-500)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.wc, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Text('Płeć *'),
                      SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text('Mężczyzna'),
                                value: true,
                                groupValue: isMale,
                                onChanged: (value) {
                                  setState(() => isMale = value!);
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text('Kobieta'),
                                value: false,
                                groupValue: isMale,
                                onChanged: (value) {
                                  setState(() => isMale = value!);
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '* - pola wymagane',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final user = User(
                    id: '',
                    fullName: fullNameController.text.trim(),
                    username: usernameController.text.trim(),
                    age: int.parse(ageController.text),
                    height: int.parse(heightController.text),
                    weight: int.parse(weightController.text),
                    sex: isMale ? 'male' : 'female',
                  );

                  Provider.of<UserController>(context, listen: false).createUser(user);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dodano użytkownika: ${user.fullName}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Dodaj użytkownika'),
            ),
          ],
        ),
      ),
    );
  }
}