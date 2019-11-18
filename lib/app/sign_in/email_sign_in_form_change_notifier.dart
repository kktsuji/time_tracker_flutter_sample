import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'dart:io';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget{
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      builder: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInFormChangeNotifier(model: model),
      ),
//      dispose: (context, bloc) => bloc.dispose(),
    );
  }


  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

//  String get _email => _emailController.text;
//  String get _password => _passwordController.text;
//  EmailSignInFormType _formType = EmailSignInFormType.signIn;
//  bool _submitted = false;
//  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
//    //print('email: ${_emailController.text}, password: ${_passwordController.text}');
//    setState(() {
//      _submitted = true;
//      _isLoading = true;
//    });
    try {
//      final auth = AuthProvider.of(context);
//      final auth = Provider.of<AuthBase>(context);
//      if (_formType == EmailSignInFormType.signIn) {
//        await auth.signInWithEmailAndPassword(_email, _password);
//      } else {
//        await auth.createUserWithEmailAndPassword(_email, _password);
//      }
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      //print(e.toString());
      PlatformExceptionAlertDialog(
        title: 'Sign in faild',
        exception: e,
      ).show(context);
    }
//    } finally {
//      setState(() {
//        _isLoading = false;
//      });
//    }
  }

  void _emailEditingComplete() {
    //print('email editing complete');
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    //    widget.bloc.updateWith(
//      email: '',
//      password: '',
//      formType: model.formType == EmailSignInFormType.signIn
//        ? EmailSignInFormType.register
//          : EmailSignInFormType.signIn,
//      isLoading: false,
//      submitted: false,
//    );
//    setState(() {
//      _submitted = false;
//      _formType = _formType == EmailSignInFormType.signIn ?
//      EmailSignInFormType.register : EmailSignInFormType.signIn;
//    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
//    final primaryText = model.formType == EmailSignInFormType.signIn ?
//    'Sign in' : 'Create an account';
//    final secondaryText = model.formType == EmailSignInFormType.signIn ?
//    'Need an account? Register' : 'Have an account? Sign in';
//
//    bool submitEnable = model.emailValidator.isValid(model.email) &&
//        model.passwordValidator.isValid(model.password) &&
//        !model.isLoading;

    return[
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
//    bool showErrorText = model.submitted && !model.passwordValidator.isValid(model.password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
//      onChanged: (password) => _updateState(),
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
//    bool showErrorText = model.submitted && !model.emailValidator.isValid(model.email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
//      onChanged: (email) => _updateState(),
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
//    return StreamBuilder<EmailSignInModel>(
//      stream: model.modelStream,
//      initialData: EmailSignInModel(),
//      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 横方向にコンテンツを伸ばす
            mainAxisSize: MainAxisSize.min, // 縦のサイズをどうするか指定。min:コンテンツに合わせる
            children: _buildChildren(),
          ),
        );
      }
//    );
//  }
//
//  void _updateState() {
//    //print('email: ${_email}, password: ${_password}');
//    setState(() {});
//  }
}
