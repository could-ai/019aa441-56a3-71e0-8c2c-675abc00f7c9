import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couldai_user_app/providers/app_state.dart';

class AddEditCustomerDialog extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerDialog({super.key, this.customer});

  @override
  State<AddEditCustomerDialog> createState() => _AddEditCustomerDialogState();
}

class _AddEditCustomerDialogState extends State<AddEditCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _accNumController;
  late TextEditingController _accTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _contactController = TextEditingController(text: widget.customer?.contactInfo);
    _accNumController = TextEditingController(text: widget.customer?.accountNumber);
    _accTypeController = TextEditingController(text: widget.customer?.accountType);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _accNumController.dispose();
    _accTypeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (widget.customer == null) {
        // Add new customer
        context.read<AppState>().addCustomer(
          _nameController.text,
          _contactController.text,
          _accNumController.text,
          _accTypeController.text,
        );
      } else {
        // Update existing customer
        final updatedCustomer = Customer(
          id: widget.customer!.id,
          name: _nameController.text,
          contactInfo: _contactController.text,
          accountNumber: _accNumController.text,
          accountType: _accTypeController.text,
        );
        context.read<AppState>().updateCustomer(updatedCustomer);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact Info'),
               validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact info';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accNumController,
              decoration: const InputDecoration(labelText: 'Account Number'),
               validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an account number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accTypeController,
              decoration: const InputDecoration(labelText: 'Account Type'),
               validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an account type';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _handleSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
