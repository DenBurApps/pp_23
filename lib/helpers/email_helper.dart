import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailHelper {
  static Future<void> launchEmailSubmission({
    required String toEmail,
    required String subject,
    String? body,
    required VoidCallback errorCallback,
    required VoidCallback doneCallback,
  }) async {
    final mailUrl =
        _getEmailUrl(toEmail: toEmail, subject: subject, body: body);
    try {
      await launchUrl(mailUrl);
      doneCallback.call();
    } catch (e) {
      errorCallback.call();
    }
  }

  static Uri _getEmailUrl({
    required String toEmail,
    required String subject,
    String? body,
  }) {
    final url = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: _encodeQueryParameters({
        'subject': subject,
        'body': body ?? '',
      }),
    );

    return url;
  }

  /// Using `queryParameters` above encodes the text incorrectly.
  /// We use `query` and this helper function to encode properly.
  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
