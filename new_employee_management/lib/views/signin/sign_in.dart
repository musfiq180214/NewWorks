import 'package:employee_management/controllers/loginController.dart';
import 'package:employee_management/data/sharefPref/sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  LoginController controller = Get.put(LoginController());
  final SharedPref sharedPref = SharedPref();
  final signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return controller.loader.value
            ? const Center(
                child: CupertinoActivityIndicator(
                radius: 15,
                color: Colors.black45,
              ))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 100),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/images/misfit_logo.svg',
                          height: 45,
                        )),
                    Container(
                        height: 300,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Image.asset(
                          'assets/images/avatar.gif',
                          fit: BoxFit.fill,
                        )),
                    const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(50, 20, 50, 80),
                      child: const Text(
                        'Please login with your official Email address',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        controller.loader.value = true;
                        controller.loginWithGoogle().then((value) {
                          controller.loader.value = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF221F1F),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              'assets/images/google_icon.svg',
                              height: 28,
                              width: 28,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text(
                              'Login with Misfit Email',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .1),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
      }),
    );
  }
}
