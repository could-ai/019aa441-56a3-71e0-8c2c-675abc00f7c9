import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/app_state.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currencyFormat = NumberFormat.simpleCurrency();

    double totalSavings = appState.savings.fold(0, (sum, item) => sum + item.balance);
    double totalLoans = appState.loans.fold(0, (sum, item) => sum + (item.status == 'approved' ? item.amount : 0));
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Savings',
                    value: currencyFormat.format(totalSavings),
                    icon: Icons.savings,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: 'Active Loans',
                    value: currencyFormat.format(totalLoans),
                    icon: Icons.monetization_on,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: 'Credit Score',
                    value: '750',
                    icon: Icons.speed,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Transactions Section
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appState.transactions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final transaction = appState.transactions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transaction.type == 'credit' ? Colors.green.shade50 : Colors.red.shade50,
                      child: Icon(
                        transaction.type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward,
                        color: transaction.type == 'credit' ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(transaction.title),
                    subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
                    trailing: Text(
                      '${transaction.type == 'credit' ? '+' : '-'}${currencyFormat.format(transaction.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.type == 'credit' ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+2.5%',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
