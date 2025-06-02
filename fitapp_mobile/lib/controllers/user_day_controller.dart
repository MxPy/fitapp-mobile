import 'package:fitapp_mobile/models/user_day.dart';
import 'package:fitapp_mobile/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDayController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  UserDay? _currentUserDay;
  bool _isLoading = false;
  String? _error;

  UserDay? get currentUserDay => _currentUserDay;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserDay(String userId, [DateTime? date]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      _currentUserDay = await _apiService.getUserDay(userId, dateStr);
      
      // Jeśli nie ma danych na dzisiaj, stwórz nowy rekord
      if (_currentUserDay == null) {
        final newUserDay = UserDay(
          id: '',
          userId: userId,
          userDate: dateStr,
          dailyKcal: 0,
          dailyProteins: 0,
          dailyCarbs: 0,
          dailyFats: 0,
        );
        _currentUserDay = await _apiService.createUserDay(newUserDay);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNutrition(int kcal, int proteins, int carbs, int fats) async {
    if (_currentUserDay == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUserDay = UserDay(
        id: _currentUserDay!.id,
        userId: _currentUserDay!.userId,
        userDate: _currentUserDay!.userDate,
        dailyKcal: _currentUserDay!.dailyKcal + kcal,
        dailyProteins: _currentUserDay!.dailyProteins + proteins,
        dailyCarbs: _currentUserDay!.dailyCarbs + carbs,
        dailyFats: _currentUserDay!.dailyFats + fats,
      );

      await _apiService.updateUserDay(_currentUserDay!.id, updatedUserDay);
      _currentUserDay = updatedUserDay;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}