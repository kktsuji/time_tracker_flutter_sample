import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
    title: title,
    content: _message(exception),
    defaultActionText: 'OK',
  );

  static String _message(PlatformException exception) {
    if (exception.message == 'FIRFirestoreErrorDomain') {
      if (exception.code == 'Error 7') {
        return 'Midding or infufficient permissions';
      }

    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    ///   • `ERROR_NOT_ALLOWED` - Indicates that email and email sign-in link
    ///      accounts are not enabled. Enable them in the Auth section of the
    ///      Firebase console.
    ///   • `ERROR_DISABLED` - Indicates the user's account is disabled.
    ///   • `ERROR_INVALID` - Indicates the email address is invalid.
    ///   • `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
    'ERROR_WRONG_PASSWORD': 'The password is invalid',
    ///   • `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
    ///   • `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///   • `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///   • `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };
}
