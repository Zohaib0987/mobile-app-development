import 'package:flutter/material.dart';
import 'package:pizzahut/models/pizza.dart';

class EditPizzaDialog extends StatefulWidget {
  final Pizza? pizza;

  const EditPizzaDialog({super.key, this.pizza});

  @override
  State<EditPizzaDialog> createState() => _EditPizzaDialogState();
}

class _EditPizzaDialogState extends State<EditPizzaDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  bool _isVeg = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pizza?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.pizza?.description ?? '');
    _priceController =
        TextEditingController(text: widget.pizza?.price.toString() ?? '');
    _imageUrlController =
        TextEditingController(text: widget.pizza?.imageUrl ?? '');
    _isVeg = widget.pizza?.isVeg ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      return false;
    }
    final price = double.tryParse(_priceController.text);
    return price != null && price > 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pizza == null ? 'Add Pizza' : 'Edit Pizza'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Vegetarian'),
              value: _isVeg,
              onChanged: (value) => setState(() => _isVeg = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _validateInputs()
              ? () {
                  final pizzaData = {
                    'id': widget.pizza?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'price': double.parse(_priceController.text),
                    'imageUrl': _imageUrlController.text,
                    'isVeg': _isVeg,
                  };
                  Navigator.pop(context, pizzaData);
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
