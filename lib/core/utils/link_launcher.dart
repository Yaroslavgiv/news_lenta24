import 'package:url_launcher/url_launcher.dart';

Future<void> launchUniversalLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return;
  }

  if (await canLaunchUrl(uri)) {
    final openedNative = await launchUrl(
      uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!openedNative) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
