import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  final String cardName;
  final String username;
  final String cardNumber;

  const CreditCard({
    super.key,
    required this.cardName,
    required this.username,
    required this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 250,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[700],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            cardName,
            style: const TextStyle(color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Number',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                cardNumber,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                username,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
