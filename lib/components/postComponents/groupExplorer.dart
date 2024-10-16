import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildCreatePostForm(BuildContext context, Future<void> Function(BuildContext context, bool isStart) selectDate, DateTime? endDate, DateTime? startDate,) {
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _travelersCountController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Destination
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(labelText: 'Destination'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a destination';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(startDate == null
                        ? 'Start Date'
                        : 'Start Date: ${DateFormat('yMMMd').format(startDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    title: Text(endDate == null
                        ? 'End Date'
                        : 'End Date: ${DateFormat('yMMMd').format(endDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _travelersCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Number of Travelers'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of travelers';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Budget (per person)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process the form
                }
              },
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    ),
  );
}
