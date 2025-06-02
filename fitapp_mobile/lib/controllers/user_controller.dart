import 'package:fitapp_mobile/models/user.dart';
import 'package:fitapp_mobile/services/api_service.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<User> _users = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(User user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newUser = await _apiService.createUser(user);
      _users.add(newUser);
      _currentUser = newUser;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _apiService.getUser(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}