import 'package:pizzahut/models/pizza.dart';

final List<Pizza> samplePizzas = [
  Pizza(
    id: '1',
    name: 'Margherita',
    description:
        'Classic tomato sauce with fresh mozzarella, basil, and extra virgin olive oil',
    price: 12.99,
    imageUrl: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca',
    isVeg: true,
    isSpicy: false,
    isAvailable: true,
    sizes: ['Small', 'Medium', 'Large'],
    crusts: ['Thin', 'Regular', 'Thick'],
    toppings: [
      'Extra Cheese',
      'Fresh Basil',
      'Cherry Tomatoes',
      'Garlic',
      'Oregano',
    ],
  ),
  Pizza(
    id: '2',
    name: 'Pepperoni Supreme',
    description:
        'Double pepperoni, mozzarella cheese, and our signature tomato sauce',
    price: 14.99,
    imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e',
    isVeg: false,
    isSpicy: true,
    isAvailable: true,
    sizes: ['Small', 'Medium', 'Large'],
    crusts: ['Thin', 'Regular', 'Thick', 'Stuffed'],
    toppings: [
      'Extra Cheese',
      'Extra Pepperoni',
      'Mushrooms',
      'Onions',
      'Bell Peppers',
    ],
  ),
  Pizza(
    id: '3',
    name: 'Veggie Paradise',
    description:
        'Fresh vegetables including mushrooms, onions, bell peppers, olives, and corn',
    price: 13.99,
    imageUrl: 'https://images.unsplash.com/photo-1571066811602-716837d681de',
    isVeg: true,
    isSpicy: false,
    isAvailable: true,
    sizes: ['Small', 'Medium', 'Large'],
    crusts: ['Thin', 'Regular', 'Thick'],
    toppings: [
      'Extra Cheese',
      'Mushrooms',
      'Onions',
      'Bell Peppers',
      'Black Olives',
      'Corn',
      'Jalapenos',
    ],
  ),
  Pizza(
    id: '4',
    name: 'BBQ Chicken',
    description:
        'Grilled chicken, BBQ sauce, red onions, and cilantro on a mozzarella base',
    price: 15.99,
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
    isVeg: false,
    isSpicy: false,
    isAvailable: true,
    sizes: ['Small', 'Medium', 'Large'],
    crusts: ['Thin', 'Regular', 'Thick'],
    toppings: [
      'Extra Cheese',
      'Extra Chicken',
      'Red Onions',
      'Bell Peppers',
      'Extra BBQ Sauce',
    ],
  ),
  Pizza(
    id: '5',
    name: 'Mexican Green Wave',
    description:
        'A spicy mix of green peppers, jalapeños, and red paprika with Mexican herbs',
    price: 14.99,
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
    isVeg: true,
    isSpicy: true,
    isAvailable: true,
    sizes: ['Small', 'Medium', 'Large'],
    crusts: ['Thin', 'Regular', 'Thick'],
    toppings: [
      'Extra Cheese',
      'Extra Jalapeños',
      'Red Paprika',
      'Onions',
      'Mexican Herbs',
    ],
  ),
  Pizza(
    id: '6',
    name: 'Meat Lovers',
    description:
        'Loaded with pepperoni, sausage, meatballs, bacon, and ground beef',
    price: 16.99,
    imageUrl: 'https://images.unsplash.com/photo-1590947132387-155cc02f3212',
    isVeg: false,
    isSpicy: false,
    isAvailable: true,
    sizes: ['Small', 'Medium', 'Large'],
    crusts: ['Regular', 'Thick', 'Stuffed'],
    toppings: [
      'Extra Cheese',
      'Extra Pepperoni',
      'Extra Sausage',
      'Extra Bacon',
      'Extra Beef',
    ],
  ),
];
