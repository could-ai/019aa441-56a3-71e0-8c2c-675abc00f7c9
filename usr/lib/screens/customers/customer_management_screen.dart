import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/app_state.dart';
import 'package:couldai_user_app/screens/customers/add_edit_customer_dialog.dart';

class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Customer? customer}) {
    showDialog(
      context: context,
      builder: (context) => AddEditCustomerDialog(customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final customers = appState.customers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(customer.name.substring(0, 1)),
              ),
              title: Text(customer.name),
              subtitle: Text('Acc: ${customer.accountNumber} (${customer.accountType})'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showAddEditDialog(context, customer: customer),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete ${customer.name}?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  context.read<AppState>().deleteCustomer(customer.id);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
