import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Featured')),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 3,
        childAspectRatio: 1.3,
        children: const [
          _FeatureCard(title: 'PharaohSearch', description: 'Private browsing with built-in blocking'),
          _FeatureCard(title: 'Steam', description: 'AAA gaming ready to launch'),
          _FeatureCard(title: 'Discord', description: 'Stay connected with your guild'),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(description),
          ],
        ),
      ),
    );
  }
}
