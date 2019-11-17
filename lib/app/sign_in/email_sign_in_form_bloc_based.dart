import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'dart:io';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

class EmailSignInFormBlocBased extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      builder: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }


  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
      await widget.bloc.submit();
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

  void _emailEditingComplete(EmailSignInModel model) {
    //print('email editing complete');
    final newFocus = widget.emailValidator.isValid(model.email)
        ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType(EmailSignInModel model) {
    widget.bloc.updateWith(
      email: '',
      password: '',
      formType: model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isLoading: false,
      submitted: false,
    );
//    setState(() {
//      _submitted = false;
//      _formType = _formType == EmailSignInFormType.signIn ?
//      EmailSignInFormType.register : EmailSignInFormType.signIn;
//    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    final primaryText = model.formType == EmailSignInFormType.signIn ?
    'Sign in' : 'Create an account';
    final secondaryText = model.formType == EmailSignInFormType.signIn ?
    'Need an account? Register' : 'Have an account? Sign in';

    bool submitEnable = widget.emailValidator.isValid(model.email) &&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;

    return[
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !model.isLoading ? () => _toggleFormType(model) : null,
      )
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool showErrorText = model.submitted && !widget.passwordValidator.isValid(model.password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
//      onChanged: (password) => _updateState(),
      onChanged: (password) => widget.bloc.updateWith(password: password),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool showErrorText = model.submitted && !widget.emailValidator.isValid(model.email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
//      onChanged: (email) => _updateState(),
      onChanged: (email) => widget.bloc.updateWith(email: email),
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 横方向にコンテンツを伸ばす
            mainAxisSize: MainAxisSize.min, // 縦のサイズをどうするか指定。min:コンテンツに合わせる
            children: _buildChildren(model),
          ),
        );
      }
    );
  }
//
//  void _updateState() {
//    //print('email: ${_email}, password: ${_password}');
//    setState(() {});
//  }
}
