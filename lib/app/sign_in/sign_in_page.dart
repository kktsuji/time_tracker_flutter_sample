import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatelessWidget {
//  SignInPage({@required this.auth});
//  SignInPage({@required this.auth, @required this.onSignIn});  // コンストラクタで onSingIn を要求
//  final Function(User) onSignIn;  // 内容は定義してないから、コンストラクタに関数を渡す
//  final AuthBase auth;

  const SignInPage({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          builder: (_) => SignInManager(auth: auth, isLoading: isLoading),
//      dispose: (context, bloc) => bloc.dispose(),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

//  @override
//  _SignInPageState createState() => _SignInPageState();
//}
//
//class _SignInPageState extends State<SignInPage> {
//
////  bool _isLoading = false;

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
//    final bloc = Provider.of<SignInBloc>(context);
    try {
//        bloc.setIsLoading(true);
//      setState(()  => _isLoading = true);
//      final auth = AuthProvider.of(context);
//      final auth = Provider.of<AuthBase>(context);
//      await auth.signInAnonymously();
      await manager.signInAnonymously();
//      User user = await auth.signInAnonymously();
//      onSignIn(user);
//      //print('${authResult.user.uid}');
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BU_USER') {
        _showSignInError(context, e);
      }
    }
//    } finally {
////      setState(()  => _isLoading = false);
//      bloc.setIsLoading(false);
//    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
//    final bloc = Provider.of<SignInBloc>(context);
    try {
//      bloc.setIsLoading(true);
//      setState(()  => _isLoading = true);
//      final auth = AuthProvider.of(context);
//      final auth = Provider.of<AuthBase>(context);
//      await auth.signInWithGoogle();
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BU_USER') {
        _showSignInError(context, e);
      }
    }
//    } finally {
////      setState(()  => _isLoading = false);
//      bloc.setIsLoading(false);
//    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
//    final bloc = Provider.of<SignInBloc>(context);
    try {
//      bloc.setIsLoading(true);
//      setState(()  => _isLoading = true);
//      final auth = AuthProvider.of(context);
//      final auth = Provider.of<AuthBase>(context);
//      await auth.signInWithFacebook();
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BU_USER') {
        _showSignInError(context, e);
      }
    }
//    } finally {
////      setState(()  => _isLoading = false);
//      bloc.setIsLoading(false);
//    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    final bloc = Provider.of<SignInBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
//      body: _buildContent(context),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
