import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class CreateMyDynamicLinksClass {
  static const String kUriPrefix = 'https://muddaapp.page.link';
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future createDynamicLink(bool short, String link) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(kUriPrefix + link),
        uriPrefix: kUriPrefix,
        androidParameters: const AndroidParameters(
            packageName: 'app.mudda', minimumVersion: 0));

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }
    print('dynamic link is $url');
    return url.toString();
  }
}
