import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class LandingPage extends StatelessWidget {
//class LandingPage extends StatefulWidget {
//  LandingPage({@required this.auth});
//
//  final AuthBase auth;
//
//  @override
//  _LandingPageState createState() => _LandingPageState();
//}
//
//class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
//    final auth = AuthProvider.of(context);
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
//      stream: widget.auth.onAuthStateChanged,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
//            return SignInPage(
//              //auth: auth, // ああ、なるほどここで渡すから共通のクラスのインスタンスを使えるのか
////              auth: widget.auth, // ああ、なるほどここで渡すから共通のクラスのインスタンスを使えるのか
////              onSignIn: _updateUser, // コンストラクタに関数 _updateUser を渡している
//            );
              return SignInPage.create(context);
          }
          return Provider<Database>(
            builder: (_) => FirestoreDatabase(uid: user.uid),
            child: JobsPage(
              //auth: auth,
//            auth: widget.auth,
//            onSignOut: () => _updateUser(null), // 同じく渡している
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        }
      }
    );

  }
}
