import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
//  final StreamController<bool> _isLoadingController = StreamController<bool>();
//  Stream<bool> get isLoadingStream => _isLoadingController.stream;
//
//  void dispose() {
//    _isLoadingController.close();
//  }
//
//  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try{
//      _setIsLoading(true);
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
//      _setIsLoading(false);
      isLoading.value = false;
      rethrow;
    }
    // AndroidでAnonymousログインしたときにエラーになることがある
    // どうも、disposeでストリームが終わったのにfalseを入れようとしてるらしい
    // LandingPageでここへはsnapshotを渡しているので、処理が終了したらsnapshotは消える
    // つまり、成功してたらstateをfalseへ戻す必要はないので、errorのときだけfalseを入れる
//    } finally {
//      _setIsLoading(false);
//    }
  }
  
  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle()  async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook()  async => await _signIn(auth.signInWithFacebook);
}