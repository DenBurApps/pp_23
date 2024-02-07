import 'package:flutter/material.dart';
import 'package:pp_23/presentation/modules/onboarding_view.dart';
import 'package:pp_23/presentation/modules/pages/home/views/single_crypto_view.dart';
import 'package:pp_23/presentation/modules/pages/news/single_news_view.dart';
import 'package:pp_23/presentation/modules/pages/pages_view.dart';
import 'package:pp_23/presentation/modules/privacy_view.dart';
import 'package:pp_23/presentation/modules/splash_view.dart';

part 'route_names.dart';

typedef AppRoute = Widget Function(BuildContext context);

class Routes {
  static Map<String, AppRoute> get(BuildContext context) => {
        RouteNames.splash: (context) => const SplashView(),
        RouteNames.onboarding: (context) => const OnboardingView(),
        RouteNames.privacy: (context) => const PrivacyAgreementView(),
        RouteNames.pages: (context) => const PagesView(),
        RouteNames.singleNews: (context) => SingleNewsView.create(context),
        RouteNames.singleCrypto: (context) => SingleCryptoView.crate(context),
        RouteNames.privacyAgreement:(context) => const  PrivacyAgreementView()
      };
}
