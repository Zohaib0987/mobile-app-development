import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizzahut/models/pizza.dart';
import 'package:pizzahut/providers/pizza_provider.dart';

class ManagePizzasScreen extends StatefulWidget {
  const ManagePizzasScreen({super.key});

  @override
  State<ManagePizzasScreen> createState() => _ManagePizzasScreenState();
}

class _ManagePizzasScreenState extends State<ManagePizzasScreen> {
  Pizza? _selectedPizza;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  bool _isVeg = false;
  bool _isSpicy = false;
  bool _isAvailable = true;
  List<String> _sizes = ['Small', 'Medium', 'Large'];
  List<String> _crusts = ['Thin', 'Thick'];
  List<String> _toppings = [
    'Extra Cheese',
    'Mushrooms',
    'Onions',
    'Black Olives'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imageUrlController = TextEditingController();
    _isVeg = false;
    _isSpicy = false;
    _isAvailable = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageUrlController.clear();
    setState(() {
      _isVeg = false;
      _isSpicy = false;
      _isAvailable = true;
      _selectedPizza = null;
    });
  }

  void _selectPizza(Pizza pizza) {
    setState(() {
      _selectedPizza = pizza;
      _nameController.text = pizza.name;
      _descriptionController.text = pizza.description;
      _priceController.text = pizza.price.toString();
      _imageUrlController.text = pizza.imageUrl;
      _isVeg = pizza.isVeg;
      _isSpicy = pizza.isSpicy;
      _isAvailable = pizza.isAvailable;
      _sizes = pizza.sizes;
      _crusts = pizza.crusts;
      _toppings = pizza.toppings;
    });
  }

  Future<void> _savePizza() async {
    if (!_formKey.currentState!.validate()) return;

    final pizzaProvider = Provider.of<PizzaProvider>(context, listen: false);
    final pizza = Pizza(
      id: _selectedPizza?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
      isVeg: _isVeg,
      isSpicy: _isSpicy,
      isAvailable: _isAvailable,
      sizes: _sizes,
      crusts: _crusts,
      toppings: _toppings,
    );

    if (_selectedPizza != null) {
      await pizzaProvider.updatePizza(pizza);
    } else {
      await pizzaProvider.addPizza(pizza);
    }

    _clearForm();
  }

  Future<void> _deletePizza(Pizza pizza) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pizza'),
        content: Text('Are you sure you want to delete ${pizza.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    await Provider.of<PizzaProvider>(context, listen: false)
        .deletePizza(pizza.id);

    if (_selectedPizza?.id == pizza.id) {
      _clearForm();
    }
  }

  Widget _buildPizzaForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedPizza == null ? 'Add New Pizza' : 'Edit Pizza',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an image URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Vegetarian'),
                  value: _isVeg,
                  onChanged: (value) {
                    setState(() => _isVeg = value ?? false);
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Spicy'),
                  value: _isSpicy,
                  onChanged: (value) {
                    setState(() => _isSpicy = value ?? false);
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Available'),
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() => _isAvailable = value ?? true);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _savePizza,
                child:
                    Text(_selectedPizza == null ? 'Add Pizza' : 'Update Pizza'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return Consumer<PizzaProvider>(
      builder: (context, pizzaProvider, _) {
        Widget buildPizzasList() {
          return Card(
            child: ListView.builder(
              itemCount: pizzaProvider.pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzaProvider.pizzas[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pizza.imageUrl),
                  ),
                  title: Text(pizza.name),
                  subtitle: Text(
                    '\$${pizza.price.toStringAsFixed(2)}\n'
                    '${pizza.isVeg ? '🥬 ' : ''}'
                    '${pizza.isSpicy ? '🌶️ ' : ''}'
                    '${!pizza.isAvailable ? '(Unavailable)' : ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deletePizza(pizza),
                  ),
                  selected: _selectedPizza?.id == pizza.id,
                  onTap: () => _selectPizza(pizza),
                );
              },
            ),
          );
        }

        if (!isDesktop) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Pizzas List'),
                    Tab(text: 'Pizza Form'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  buildPizzasList(),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildPizzaForm(),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: buildPizzasList(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildPizzaForm(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
