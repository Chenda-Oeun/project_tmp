import 'package:flutter/material.dart';
import 'package:project_tmp/view/widgets/quick_action.dart';
import 'package:project_tmp/view/widgets/section_header.dart';
import 'package:project_tmp/view/widgets/summary_card.dart';
import 'package:project_tmp/view/widgets/transaction_item.dart';

class DashboardTab extends StatelessWidget {
  final VoidCallback? onViewAllTransactions;
  final VoidCallback? onQuickActionClicked;

  const DashboardTab({
    super.key,
    this.onViewAllTransactions,
    this.onQuickActionClicked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top App Bar / Greeting Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      'C',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Chenda Sok',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No new notifications')),
                      );
                    },
                    icon: const Icon(Icons.notifications_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5)
                          : Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2. Summary Cards Grid (2x2)
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.25,
            children: [
              SummaryCard(
                title: 'Total Balance',
                amount: '\$48,590.00',
                percentageChange: '+12.5%',
                isPositive: true,
                icon: Icons.account_balance_wallet_outlined,
                iconColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
              ),
              const SummaryCard(
                title: 'Total Revenue',
                amount: '\$32,450.00',
                percentageChange: '+8.2%',
                isPositive: true,
                icon: Icons.trending_up_rounded,
                iconColor: Colors.green,
                backgroundColor: Color(0xFFE8F5E9),
              ),
              const SummaryCard(
                title: 'Total Expenses',
                amount: '\$14,210.00',
                percentageChange: '-3.1%',
                isPositive: false,
                icon: Icons.trending_down_rounded,
                iconColor: Colors.orange,
                backgroundColor: Color(0xFFFFF3E0),
              ),
              SummaryCard(
                title: 'Transactions',
                amount: '1,284',
                percentageChange: '+24.3%',
                isPositive: true,
                icon: Icons.receipt_long_outlined,
                iconColor: Colors.purple,
                backgroundColor: Colors.purple.withValues(alpha: 0.1),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 3. Quick Actions
          const SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickAction(
                label: 'Add Txn',
                icon: Icons.add_rounded,
                onTap: () =>
                    _showQuickActionMessage(context, 'Add Transaction'),
              ),
              QuickAction(
                label: 'Transfer',
                icon: Icons.swap_horiz_rounded,
                color: Colors.blue,
                onTap: () => _showQuickActionMessage(context, 'Transfer Funds'),
              ),
              QuickAction(
                label: 'Payment',
                icon: Icons.payment_rounded,
                color: Colors.green,
                onTap: () => _showQuickActionMessage(context, 'Make Payment'),
              ),
              QuickAction(
                label: 'Reports',
                icon: Icons.analytics_outlined,
                color: Colors.purple,
                onTap: () => _showQuickActionMessage(context, 'View Analytics'),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 4. Business Performance Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     theme.colorScheme.primary,
              //     theme.colorScheme.primary.withValues(alpha: 0.8),
              //   ],
              // ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Performance Overview',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'This Month',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Revenue vs Expenses',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      '78% Goal Achieved',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.78,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Net profit increased by 14.2% compared to last month.',
                  style: TextStyle(
                    color: Colors.amber ?? Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 5. Recent Transactions
          SectionHeader(
            title: 'Recent Transactions',
            actionText: 'View All',
            onActionPressed: onViewAllTransactions,
          ),
          const SizedBox(height: 14),
          const TransactionItem(
            title: 'Stripe Payout',
            subtitle: 'Client Invoice #1084',
            amount: '1,250.00',
            date: 'Today, 10:42 AM',
            isIncome: true,
            status: 'Completed',
            icon: Icons.arrow_downward_rounded,
          ),
          const TransactionItem(
            title: 'AWS Cloud Hosting',
            subtitle: 'Server Infrastructure',
            amount: '240.00',
            date: 'Yesterday, 4:15 PM',
            isIncome: false,
            status: 'Completed',
            icon: Icons.cloud_outlined,
          ),
          const TransactionItem(
            title: 'Office Rent',
            subtitle: 'Monthly Workspace',
            amount: '1,800.00',
            date: 'May 1, 9:00 AM',
            isIncome: false,
            status: 'Completed',
            icon: Icons.business_rounded,
          ),
          const TransactionItem(
            title: 'Client Consulting',
            subtitle: 'Advisory Session',
            amount: '850.00',
            date: 'Apr 28, 2:30 PM',
            isIncome: true,
            status: 'Completed',
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showQuickActionMessage(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action action triggered'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
