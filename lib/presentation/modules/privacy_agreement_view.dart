import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/presentation/components/app_button.dart';
import 'package:pp_23/routes/routes.dart';
import 'package:pp_23/services/database/database_keys.dart';
import 'package:pp_23/services/database/database_service.dart';
import 'package:pp_23/services/remote_config_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../helpers/dialog_helper.dart';
// #enddocregion platform_imports

void main() => runApp(const MaterialApp(home: PrivacyAgreementView()));

class PrivacyAgreementView extends StatefulWidget {
  const PrivacyAgreementView({super.key});

  @override
  State<PrivacyAgreementView> createState() => _PrivacyAgreementViewState();
}

class _PrivacyAgreementViewState extends State<PrivacyAgreementView> {
  late final WebViewController _controller;
  final _databaseService = GetIt.I<DatabaseService>();
  final _remoteConfig = GetIt.I<RemoteConfigService>();

  var isLoading = true;
  var agreeButton = true;

  String get _cssCode {
    if (Platform.isAndroid) {
      return """
        .docs-ml-promotion { 
          display: none !important; 
        } 
        #docs-ml-header-id {
          display: none !important;
        }
        .app-container { 
          margin: 0 !important; 
        }
      """;
    }
    return ".docs-ml-promotion, #docs-ml-header-id { display: none !important; } .app-container { margin: 0 !important; }";
  }

  String get _jsCode => """
      var style = document.createElement('style');
      style.type = "text/css";
      style.innerHTML = "$_cssCode";
      document.head.appendChild(style);
    """;

  bool _parseShowAgreeButton(String input) =>
      input.contains('showAgreebutton') || input.contains('showAgreeButton');

  @override
  void initState() {
    super.initState();

    final privacyLink = _remoteConfig.getString(ConfigKey.privacyLink);
    setState(() => agreeButton = _parseShowAgreeButton(privacyLink));

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {
            controller.runJavaScript(_jsCode);
            log('Page finished loading: $url');
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            log('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
            if (error.errorCode == -1009) {
              DialogHelper.showNoInternetDialog(context);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('showAgreebutton')) {
              setState(() => agreeButton = true);
            }
            log('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            log('url change to ${change.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse(privacyLink));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          agreeButton ? Theme.of(context).colorScheme.background : Colors.white ,
      body: isLoading
          ?  Center(
              child: CupertinoActivityIndicator(
                radius: 20, 
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          : SafeArea(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (agreeButton)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                                  BoxConstraints constraints) =>
                              SizedBox(
                            width: constraints.maxWidth * 0.9,
                            height: 60,
                            child: AppButton(
                              onPressed: _accept,
                              label: 'Accept app privacy',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  void _accept() {
    _databaseService.put(DatabaseKeys.acceptedPrivacy, true);

    Navigator.of(context).pushReplacementNamed(RouteNames.pages);
  }
}
