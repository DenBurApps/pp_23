import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/helpers/dialog_helper.dart';
import 'package:pp_23/helpers/email_helper.dart';
import 'package:pp_23/helpers/enums.dart';
import 'package:pp_23/helpers/text_helper.dart';
import 'package:pp_23/presentation/components/app_button.dart';
import 'package:pp_23/theme/default_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  void _switchTheme() {
    final currentId = ThemeProvider.themeOf(context).id;
    String? oppositeId;
    if (currentId == DefaultTheme.dark.id) {
      oppositeId = DefaultTheme.light.id;
    } else {
      oppositeId = DefaultTheme.dark.id;
    }
    ThemeProvider.controllerOf(context).setTheme(oppositeId);
  }

  void _showContactUsDialog() {
    Navigator.of(context).pop();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const _ContactUsPopUp(),
    );
  }

  Future<void> _rate() async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
  }

  void _showAgreementPopUp(AgreementType agreementType) {
    Navigator.of(context).pop();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _AgreementPopUp(agreementType: agreementType),
    );
  }

  Future<void> _showVersionDialog() async =>
      await DialogHelper.showAppVersionDialog(context);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 30,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 9),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  GestureDetector(
                    child: Assets.icons.close.svg(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    onTap: Navigator.of(context).pop,
                  )
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Appearence',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              SizedBox(height: 18),
              _SettingButtonsCard(
                buttons: [
                  _SettingsButton(
                    tile: _SettingsTile(
                      label: 'Light Theme',
                      icon: Assets.icons.theme,
                    ),
                    suffix: CupertinoSwitch(
                      value: ThemeProvider.themeOf(context).id ==
                          DefaultTheme.light.id,
                      onChanged: (_) => _switchTheme(),
                    ),
                    onPressed: _switchTheme,
                  ),
                  SizedBox(height: 10),
                  _SettingsButton(
                    tile: _SettingsTile(
                      label: 'Contact us',
                      icon: Assets.icons.contactUs,
                    ),
                    onPressed: _showContactUsDialog,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About the program',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              SizedBox(height: 18),
              _SettingButtonsCard(
                buttons: [
                  _SettingsButton(
                    tile: _SettingsTile(
                      label: 'Version',
                      icon: Assets.icons.version,
                    ),
                    onPressed: _showVersionDialog,
                  ),
                  SizedBox(height: 10),
                  _SettingsButton(
                    tile: _SettingsTile(
                      label: 'Privacy Policy',
                      icon: Assets.icons.privacy,
                    ),
                    onPressed: () => _showAgreementPopUp(AgreementType.privacy),
                  ),
                  SizedBox(height: 10),
                  _SettingsButton(
                    tile: _SettingsTile(
                      label: 'Terms of use',
                      icon: Assets.icons.terms,
                    ),
                    onPressed: () => _showAgreementPopUp(AgreementType.terms),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rate',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              SizedBox(height: 18),
              _SettingButtonsCard(
                buttons: [
                  _SettingsButton(
                    tile: _SettingsTile(
                      label: 'Rate us',
                      icon: Assets.icons.theme,
                    ),
                    onPressed: _rate,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingButtonsCard extends StatelessWidget {
  final List<Widget> buttons;
  const _SettingButtonsCard({required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: buttons,
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final _SettingsTile tile;
  final VoidCallback onPressed;
  final Widget? suffix;
  const _SettingsButton({
    required this.tile,
    required this.onPressed,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          tile.icon.svg(),
          SizedBox(width: 36),
          Text(
            tile.label,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          Spacer(),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

class _SettingsTile {
  final String label;
  final SvgGenImage icon;

  const _SettingsTile({
    required this.label,
    required this.icon,
  });
}

class _ContactUsPopUp extends StatefulWidget {
  const _ContactUsPopUp({super.key});

  @override
  State<_ContactUsPopUp> createState() => _ContactUsPopUpState();
}

class _ContactUsPopUpState extends State<_ContactUsPopUp> {
  final _messageContoller = TextEditingController();

  var _isButtonEnabled = false;

  void _onChanged(String value) =>
      setState(() => _isButtonEnabled = _messageContoller.text.isNotEmpty);

  void _send() => EmailHelper.launchEmailSubmission(
        toEmail: 'toEmail',
        subject: 'Connect with support',
        body: _messageContoller.text,
        errorCallback: () {},
        doneCallback: () => setState(
          () {
            _messageContoller.clear();
            _isButtonEnabled = false;
          },
        ),
      );

  @override
  void dispose() {
    _messageContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 30,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 9),
                  Text(
                    'Contact developers',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  GestureDetector(
                    child: Assets.icons.close.svg(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    onTap: Navigator.of(context).pop,
                  )
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 45,
                child: CupertinoTextField(
                  autofocus: true,
                  onChanged: _onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  controller: _messageContoller,
                  placeholder: 'Say something',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                    ),
                  ),
                  placeholderStyle: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: AppButton(
                  isActive: _isButtonEnabled,
                  onPressed: _send,
                  label: "Send",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AgreementPopUp extends StatelessWidget {
  final AgreementType agreementType;
  const _AgreementPopUp({required this.agreementType});

  String get _title => agreementType == AgreementType.privacy
      ? 'Privacy Policy'
      : 'Terms of use';

  String get _body => agreementType == AgreementType.privacy
      ? TextHelper.privacy
      : TextHelper.terms;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 30,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 9),
                Text(
                  _title,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                GestureDetector(
                  child: Assets.icons.close.svg(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  onTap: Navigator.of(context).pop,
                )
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: MarkdownBody(
                  data: _body,
                  onTapLink: (text, href, title) =>
                      EmailHelper.launchEmailSubmission(
                    toEmail: text,
                    subject: 'Connect with support',
                    errorCallback: () {},
                    doneCallback: () {},
                  ),
                  styleSheet: MarkdownStyleSheet.fromTheme(
                    ThemeProvider.themeOf(context).data,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
