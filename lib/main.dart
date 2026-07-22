import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/users_provider.dart';
import 'providers/companies_provider.dart';
import 'providers/shifts_provider.dart';
import 'providers/treasury_provider.dart';
import 'providers/expenses_provider.dart';
import 'providers/claims_provider.dart';
import 'providers/collections_provider.dart';
import 'providers/day_closing_provider.dart';

import 'screens/login_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DrGeorgePharmacyApp());
}

class DrGeorgePharmacyApp extends StatelessWidget {
  const DrGeorgePharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ترتيب الإنشاء مهم: TreasuryProvider يُستخدم داخل ShiftsProvider/ExpensesProvider/CollectionsProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => CompaniesProvider()),
        ChangeNotifierProvider(create: (_) => TreasuryProvider()),
        ChangeNotifierProxyProvider<TreasuryProvider, ShiftsProvider>(
          create: (ctx) => ShiftsProvider(ctx.read<TreasuryProvider>()),
          update: (ctx, treasury, previous) => previous ?? ShiftsProvider(treasury),
        ),
        ChangeNotifierProxyProvider<TreasuryProvider, ExpensesProvider>(
          create: (ctx) => ExpensesProvider(ctx.read<TreasuryProvider>()),
          update: (ctx, treasury, previous) => previous ?? ExpensesProvider(treasury),
        ),
        ChangeNotifierProxyProvider<TreasuryProvider, CollectionsProvider>(
          create: (ctx) => CollectionsProvider(ctx.read<TreasuryProvider>()),
          update: (ctx, treasury, previous) => previous ?? CollectionsProvider(treasury),
        ),
        ChangeNotifierProvider(create: (_) => ClaimsProvider()),
        ChangeNotifierProvider(create: (_) => DayClosingProvider()),
      ],
      child: MaterialApp(
        title: 'صيدلية د/ جورج مجدي',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // فرض اتجاه الكتابة من اليمين لليسار في كل شاشات التطبيق
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
