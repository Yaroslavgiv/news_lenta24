import 'package:url_launcher/url_launcher.dart';

Future<void> launchUniversalLink(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    final bool nativeAppLaunch =
        await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    if (!nativeAppLaunch) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
