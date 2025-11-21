import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Models
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin', 'manager', 'employee'

  User({required this.id, required this.name, required this.email, required this.role});
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'credit', 'debit'
  final String category; // 'savings', 'loan_repayment', 'fee'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });
}

class Loan {
  final String id;
  final double amount;
  final double interestRate;
  final int termMonths;
  final String status; // 'pending', 'approved', 'rejected', 'paid'
  final String purpose;
  final DateTime requestDate;

  Loan({
    required this.id,
    required this.amount,
    required this.interestRate,
    required this.termMonths,
    required this.status,
    required this.purpose,
    required this.requestDate,
  });
}

class SavingsAccount {
  final String id;
  final String name;
  final double balance;
  final double interestRate;
  final double goalAmount;

  SavingsAccount({
    required this.id,
    required this.name,
    required this.balance,
    required this.interestRate,
    required this.goalAmount,
  });
}

// App State Provider
class AppState extends ChangeNotifier {
  User? _currentUser;
  bool get isAuthenticated => _currentUser != null;
  User? get currentUser => _currentUser;

  // Mock Data
  List<Transaction> _transactions = [];
  List<Loan> _loans = [];
  List<SavingsAccount> _savings = [];

  List<Transaction> get transactions => _transactions;
  List<Loan> get loans => _loans;
  List<SavingsAccount> get savings => _savings;

  AppState() {
    _generateMockData();
  }

  void login(String email, String password) {
    // Mock login logic
    String role = 'employee';
    if (email.contains('admin')) role = 'admin';
    if (email.contains('manager')) role = 'manager';

    _currentUser = User(
      id: 'u1',
      name: 'John Doe',
      email: email,
      role: role,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void applyForLoan(double amount, String purpose, int term) {
    final newLoan = Loan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      interestRate: 5.0,
      termMonths: term,
      status: 'pending',
      purpose: purpose,
      requestDate: DateTime.now(),
    );
    _loans.add(newLoan);
    notifyListeners();
  }

  void createSavingsGoal(String name, double target) {
    final newSavings = SavingsAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      balance: 0,
      interestRate: 2.5,
      goalAmount: target,
    );
    _savings.add(newSavings);
    notifyListeners();
  }

  void _generateMockData() {
    _savings = [
      SavingsAccount(id: 's1', name: 'Emergency Fund', balance: 5000, interestRate: 2.5, goalAmount: 10000),
      SavingsAccount(id: 's2', name: 'Vacation', balance: 1200, interestRate: 2.0, goalAmount: 3000),
    ];

    _loans = [
      Loan(id: 'l1', amount: 10000, interestRate: 5.0, termMonths: 24, status: 'approved', purpose: 'Home Renovation', requestDate: DateTime.now().subtract(const Duration(days: 30))),
      Loan(id: 'l2', amount: 5000, interestRate: 5.0, termMonths: 12, status: 'pending', purpose: 'Car Repair', requestDate: DateTime.now().subtract(const Duration(days: 2))),
    ];

    _transactions = [
      Transaction(id: 't1', title: 'Monthly Deposit', amount: 500, date: DateTime.now().subtract(const Duration(days: 1)), type: 'credit', category: 'savings'),
      Transaction(id: 't2', title: 'Loan Repayment', amount: 250, date: DateTime.now().subtract(const Duration(days: 5)), type: 'debit', category: 'loan_repayment'),
      Transaction(id: 't3', title: 'Interest Credited', amount: 12.50, date: DateTime.now().subtract(const Duration(days: 30)), type: 'credit', category: 'savings'),
    ];
  }
}
