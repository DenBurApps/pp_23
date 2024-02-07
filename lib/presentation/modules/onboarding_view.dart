import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/routes/routes.dart';
import 'package:pp_23/services/database/database_keys.dart';
import 'package:pp_23/services/database/database_service.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _databaseService = GetIt.instance<DatabaseService>();
  var _currentStep = 0;

  final _steps = [
    _OnboardingStep(
      text: 'Real-time crypto-currency price tracking',
      backgorund: Assets.images.onboarding1,
    ),
    _OnboardingStep(
      text: 'Stay updated with the latest crypto news.',
      backgorund: Assets.images.onboarding2,
      textAlign: TextAlign.end,
    ),
    _OnboardingStep(
      alignment: Alignment.bottomLeft,
      text: 'Analyze price trends with easy-to-use charts.',
      backgorund: Assets.images.onboarding3,
    ),
  ];

  _OnboardingStep get _currentOnboarding => _steps[_currentStep];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _databaseService.put(DatabaseKeys.seenOnboarding, true);
  }

  void _skip() => Navigator.of(context).pushReplacementNamed(RouteNames.privacyAgreement);

  void _progress() {
    if (_currentStep == 2) {
      Navigator.of(context).pushReplacementNamed(RouteNames.privacyAgreement);
    } else {
      setState(() => _currentStep++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentStep == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _progress,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: Text(
                        'Get started',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.background,
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  onPressed: _skip,
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _currentStep == 0 ? null : _progress,
        child: Container(
          alignment: _currentOnboarding.alignment,
          padding: EdgeInsets.only(left: 20, right: 20, top: 40),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _currentOnboarding.backgorund.provider(),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Text(
              _currentOnboarding.text,
              textAlign: _currentOnboarding.textAlign,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final Alignment alignment;
  final String text;
  final TextAlign textAlign;
  final AssetGenImage backgorund;

  const _OnboardingStep({
    this.alignment = Alignment.topLeft,
    required this.text,
    required this.backgorund,
    this.textAlign = TextAlign.start,
  });
}
