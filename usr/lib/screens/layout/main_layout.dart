import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/app_state.dart';
import 'package:couldai_user_app/screens/dashboard/dashboard_screen.dart';
import 'package:couldai_user_app/screens/customers/customer_management_screen.dart';

// Placeholder screens for now
class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Savings Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.savings.length,
        itemBuilder: (context, index) {
          final account = appState.savings[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.savings, color: Colors.green),
              title: Text(account.name),
              subtitle: Text('Goal: \$${account.goalAmount}'),
              trailing: Text('\$${account.balance}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add savings goal
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New Savings Goal'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(decoration: InputDecoration(labelText: 'Goal Name')),
                  SizedBox(height: 16),
                  TextField(decoration: InputDecoration(labelText: 'Target Amount')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Create')),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.loans.length,
        itemBuilder: (context, index) {
          final loan = appState.loans[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.orange),
              title: Text(loan.purpose),
              subtitle: Text('Status: ${loan.status.toUpperCase()}'),
              trailing: Text('\$${loan.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Apply for Loan'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CustomerManagementScreen(),
    const SavingsScreen(),
    const LoansScreen(),
    const Center(child: Text('Transactions History')),
    const Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppState s) => s.currentUser);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 16),
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(user?.name.substring(0, 1) ?? 'U'),
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AppState>().logout();
                    },
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Customers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.savings_outlined),
                selectedIcon: Icon(Icons.savings),
                label: Text('Savings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.request_quote_outlined),
                selectedIcon: Icon(Icons.request_quote),
                label: Text('Loans'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                selectedIcon: Icon(Icons.history),
                label: Text('History'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
