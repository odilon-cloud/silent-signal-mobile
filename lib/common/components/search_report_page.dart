import 'package:flutter/material.dart';

class SearchReportPage extends StatefulWidget {
  const SearchReportPage({super.key});

  @override
  State<SearchReportPage> createState() => _SearchReportPageState();
}

class _SearchReportPageState extends State<SearchReportPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allReports = [
    {'title': 'Suspicious Vehicle', 'time': '2 hours ago'},
    {'title': 'Theft at Market', 'time': '1 day ago'},
    {'title': 'Burglary in Town Center', 'time': '3 days ago'},
    {'title': 'Vandalism in Park', 'time': '5 hours ago'},
    {'title': 'Noise Complaint', 'time': 'Just now'},
  ];

  List<Map<String, String>> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    _filteredReports = _allReports;
    _searchController.addListener(_filterReports);
  }

  void _filterReports() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredReports = _allReports.where((report) {
        final title = report['title']!.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredReports.isEmpty
                  ? const Center(child: Text('No reports found.'))
                  : ListView.builder(
                      itemCount: _filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = _filteredReports[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.report),
                            title: Text(report['title']!),
                            subtitle: Text(report['time']!),
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
