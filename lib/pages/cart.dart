// pages/cart.dart
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 27, top: 48),
              child: Text(
                'Корзина',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat-Light',
                  letterSpacing: 0.08,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 38),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Column(
                children: [
                  CartItem(
                    title: 'ПЦР-тест на коронавирус',
                    price: 1800,
                    patients: 1,
                  ),
                  SizedBox(height: 16),
                  CartItem(
                    title: 'Клинический анализ крови',
                    price: 690,
                    patients: 2,
                  ),
                  SizedBox(height: 16),
                  CartItem(
                    title: 'Биохимический анализ крови',
                    price: 2440,
                    patients: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(27, 40, 27, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сумма',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat-Light',
                      letterSpacing: 0.08,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '5530 ₽',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat-Light',
                      letterSpacing: 0.08,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 152),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Перейти к оформлению заказа',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A6FEE),
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String title;
  final int price;
  final int patients;

  const CartItem({
    Key? key,
    required this.title,
    required this.price,
    required this.patients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${price * patients} ₽',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$patients пациент${patients > 1 ? 'а' : ''}',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5FA),
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black,
                          ),
                          onPressed: () {}, // Замените на необходимое действие
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 38,
                        color: Color(0xFFE0E0E0), // Разделительная линия
                      ),
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5FA),
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          onPressed: () {}, // Замените на необходимое действие
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
