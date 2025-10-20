import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<String> _results = const [];

  Future<void> _runSearch(StoreModel model) async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    final result = await model.search(query);
    setState(() => _results = result);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<StoreModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (_) => _runSearch(model),
              decoration: const InputDecoration(hintText: 'Search packages'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _runSearch(model),
              child: const Text('Search'),
            ),
            if (model.busy) const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final entry = _results[index];
                  return ListTile(
                    title: Text(entry),
                    subtitle: Text(entry.startsWith('apt:')
                        ? 'Install via apt-get'
                        : 'Install via flatpak'),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
