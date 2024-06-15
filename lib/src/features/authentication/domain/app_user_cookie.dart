import 'package:vanholst/src/features/authentication/domain/app_user.dart';

extension AuthCookie on AppUser {
  String get cookie =>
      'wordpress_sec_$hash=$sec; wordpress_logged_in_$hash=$loggedIn';
}
