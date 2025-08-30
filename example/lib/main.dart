import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart' hide State;
import 'screens/paystack_demo_screen.dart';
import 'screens/flutterwave_demo_screen.dart';
import 'screens/monnify_demo_screen.dart';
import 'screens/opay_demo_screen.dart';
import 'screens/transactpay_demo_screen.dart';
import 'screens/google_pay_demo_screen.dart';
import 'screens/apple_pay_demo_screen.dart';
import 'screens/paypal_demo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Fintech SDK Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<ProviderCategory> _categories = [
    ProviderCategory(
      title: 'Nigerian Providers',
      icon: Icons.location_on,
      providers: [
        ProviderDemo(
          name: 'Paystack',
          description: 'Payments, Transfers, Subscriptions',
          features: ['Card Payments', 'Bank Transfers', 'Subscriptions', 'Customer Management'],
          color: const Color(0xFF0FA958),
          icon: Icons.payment,
          screen: const PaystackDemoScreen(),
          isPopular: true,
        ),
        ProviderDemo(
          name: 'Flutterwave',
          description: 'Charges, Virtual Accounts, Transfers',
          features: ['Multi-channel Payments', 'Virtual Accounts', 'International Cards', 'Mobile Money'],
          color: const Color(0xFFF5A623),
          icon: Icons.credit_card,
          screen: const FlutterwaveDemoScreen(),
          isPopular: true,
        ),
        ProviderDemo(
          name: 'Monnify',
          description: 'Reserved Accounts, Bulk Transfers',
          features: ['Reserved Accounts', 'Bulk Transfers', 'Transaction Splitting', 'Webhooks'],
          color: const Color(0xFF1E88E5),
          icon: Icons.account_balance,
          screen: const MonnifyDemoScreen(),
        ),
        ProviderDemo(
          name: 'Opay',
          description: 'Payment Channels, Recurring Payments',
          features: ['Multiple Channels', 'USSD Payments', 'Recurring Billing', 'Real-time Status'],
          color: const Color(0xFF00C853),
          icon: Icons.mobile_friendly,
          screen: const OpayDemoScreen(),
        ),
        ProviderDemo(
          name: 'TransactPay',
          description: 'European BIN Sponsorship & Encrypted Payments',
          features: ['RSA Encryption', 'European BIN', 'Modular Services', 'Secure Processing'],
          color: const Color(0xFF6A1B9A),
          icon: Icons.security,
          screen: const TransactPayDemoScreen(),
        ),
      ],
    ),
    ProviderCategory(
      title: 'International',
      icon: Icons.public,
      providers: [
        ProviderDemo(
          name: 'PayPal',
          description: 'Global Payment Processing',
          features: ['Worldwide Coverage', 'Buyer Protection', 'Multiple Currencies', 'Express Checkout'],
          color: const Color(0xFF0070BA),
          icon: Icons.account_balance_wallet,
          screen: const PayPalDemoScreen(),
          isPopular: true,
        ),
        ProviderDemo(
          name: 'Google Pay',
          description: 'Android Payment Integration',
          features: ['Android Devices', 'Tokenized Payments', 'Biometric Auth', 'Global Coverage'],
          color: const Color(0xFF4285F4),
          icon: Icons.android,
          screen: const GooglePayDemoScreen(),
          isNew: true,
        ),
        ProviderDemo(
          name: 'Apple Pay',
          description: 'iOS Payment Integration',
          features: ['iOS Devices', 'Touch/Face ID', 'Secure Element', 'Premium UX'],
          color: const Color(0xFF000000),
          icon: Icons.apple,
          screen: const ApplePayDemoScreen(),
          isNew: true,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeroSection(theme),
                _buildTabSection(theme),
                _buildProvidersGrid(theme),
                _buildFeaturesSection(theme),
                _buildFooter(theme),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(theme),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'All Fintech SDK',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Colors.white70,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showAboutDialog(context),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'The Most Comprehensive\nFintech SDK for Flutter',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Integrate payments, banking, and financial services with a single, unified interface. Production-ready with enterprise security.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildStatsRow(theme),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('6+', 'Providers', theme),
        _buildStatItem('50+', 'Features', theme),
        _buildStatItem('99.9%', 'Uptime', theme),
        _buildStatItem('24/7', 'Support', theme),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBar(
        controller: _tabController,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabs: _categories.map((category) => Tab(
          icon: Icon(category.icon),
          text: category.title,
        )).toList(),
      ),
    );
  }

  Widget _buildProvidersGrid(ThemeData theme) {
    final category = _categories[_selectedIndex];
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: category.providers.length,
            itemBuilder: (context, index) {
              final provider = category.providers[index];
              return _buildProviderCard(provider, theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProviderDemo provider, ThemeData theme) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => provider.screen),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: provider.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      provider.icon,
                      color: provider.color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  if (provider.isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Popular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (provider.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                provider.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: provider.features.take(2).map((feature) => 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      feature,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose All Fintech SDK?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildFeaturesList(theme),
        ],
      ),
    );
  }

  List<Widget> _buildFeaturesList(ThemeData theme) {
    final features = [
      ('🎯', 'One SDK, Multiple Providers', 'Integrate all Nigerian fintech APIs with a single interface'),
      ('🔒', 'Enterprise Security', 'OAuth 2.0, signature verification, webhook handling'),
      ('🎨', 'Beautiful UI Components', 'Material Design 3 payment sheets and forms'),
      ('⚡', 'Production Ready', 'Offline support, error handling, circuit breaker patterns'),
      ('📱', 'Type Safe', 'Complete Dart models with null safety'),
      ('🔄', 'Dual Architecture', 'Data-only operations OR UI-enabled components'),
    ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feature.$1, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.$2,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  feature.$3,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Ready to integrate?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a provider above to see live demos',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Built with ❤️ for the Nigerian fintech ecosystem',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        _tabController.animateTo(index);
      },
      items: _categories.map((category) => BottomNavigationBarItem(
        icon: Icon(category.icon),
        label: category.title,
      )).toList(),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Fintech SDK'),
        content: const Text(
          'Version 1.2.0\n\n'
          'The most comprehensive Flutter SDK for Nigerian fintech APIs. '
          'Integrate payments, banking, and financial services with enterprise security.\n\n'
          'Built by Chidiebere Edeh',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class ProviderCategory {
  final String title;
  final IconData icon;
  final List<ProviderDemo> providers;

  const ProviderCategory({
    required this.title,
    required this.icon,
    required this.providers,
  });
}

class ProviderDemo {
  final String name;
  final String description;
  final List<String> features;
  final Color color;
  final IconData icon;
  final Widget screen;
  final bool isPopular;
  final bool isNew;

  const ProviderDemo({
    required this.name,
    required this.description,
    required this.features,
    required this.color,
    required this.icon,
    required this.screen,
    this.isPopular = false,
    this.isNew = false,
  });
}