import 'package:flutter/material.dart';
import 'package:project_tmp/view/widgets/transaction_item.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allTransactions = [
    {
      'title': 'Stripe Payout',
      'subtitle': 'Client Invoice #1084',
      'amount': '1,250.00',
      'date': 'Today, 10:42 AM',
      'isIncome': true,
      'status': 'Completed',
      'icon': Icons.arrow_downward_rounded,
    },
    {
      'title': 'AWS Cloud Hosting',
      'subtitle': 'Server Infrastructure',
      'amount': '240.00',
      'date': 'Yesterday, 4:15 PM',
      'isIncome': false,
      'status': 'Completed',
      'icon': Icons.cloud_outlined,
    },
    {
      'title': 'Office Rent',
      'subtitle': 'Monthly Workspace',
      'amount': '1,800.00',
      'date': 'May 1, 9:00 AM',
      'isIncome': false,
      'status': 'Completed',
      'icon': Icons.business_rounded,
    },
    {
      'title': 'Client Consulting',
      'subtitle': 'Advisory Session',
      'amount': '850.00',
      'date': 'Apr 28, 2:30 PM',
      'isIncome': true,
      'status': 'Completed',
      'icon': Icons.person_outline_rounded,
    },
    {
      'title': 'Google Workspace',
      'subtitle': 'Team Subscriptions',
      'amount': '72.00',
      'date': 'Apr 25, 8:00 AM',
      'isIncome': false,
      'status': 'Completed',
      'icon': Icons.work_outline_rounded,
    },
    {
      'title': 'Product Sale #94',
      'subtitle': 'E-commerce Store',
      'amount': '340.00',
      'date': 'Apr 24, 11:15 AM',
      'isIncome': true,
      'status': 'Completed',
      'icon': Icons.shopping_cart_outlined,
    },
    {
      'title': 'Internet Bill',
      'subtitle': 'Fiber Connection',
      'amount': '95.00',
      'date': 'Apr 22, 1:00 PM',
      'isIncome': false,
      'status': 'Pending',
      'icon': Icons.wifi_rounded,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredTransactions = _allTransactions.where((tx) {
      final query = _searchController.text.toLowerCase();
      final matchesSearch =
          tx['title'].toString().toLowerCase().contains(query) ||
              tx['subtitle'].toString().toLowerCase().contains(query);

      if (_selectedFilterIndex == 1) {
        return matchesSearch && tx['isIncome'] == true;
      } else if (_selectedFilterIndex == 2) {
        return matchesSearch && tx['isIncome'] == false;
      }
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Transactions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export transactions filter')),
              );
            },
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                    : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('All', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Income', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('Expenses', 2),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Transactions List
            Expanded(
              child: filteredTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions found',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final tx = filteredTransactions[index];
                        return TransactionItem(
                          title: tx['title'],
                          subtitle: tx['subtitle'],
                          amount: tx['amount'],
                          date: tx['date'],
                          isIncome: tx['isIncome'],
                          status: tx['status'],
                          icon: tx['icon'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilterIndex == index;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide.none,
    );
  }
}
