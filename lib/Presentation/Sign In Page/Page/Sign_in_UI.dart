import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Common/Widgets/label_Text_Without_Asterisk.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Common/Widgets/text_editor.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Presentation/Dashboard%20Page/Page/dashboard_UI.dart';

import '../../../Common/Bloc/bottom_navigation_with_swipe_cubit.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Data/Repositories/sign_in_repositories_impl.dart';
import '../Bloc/sign_in_bloc.dart';
import '../Widgets/finger_scan_overlay.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailcontroller = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool isChecked = false;
  bool _isEmployeeID = false;

  Widget _buildIcon() {
    return _isObscured
        ? Image.asset(
            AppImages.ObscuredIcon,
            height: 24,
            width: 24,
          )
        : Image.asset(
            AppImages.ObscuredNotIcon,
            height: 24,
            width: 24,
          );
  }

  @override
  void initState() {
    super.initState();

    // Check if token exists for auto login
    checkandauthenticate();
  }

  Future<void> checkandauthenticate() async {
    // First, check the token from the repository
    final repository = SigninRepositoryImpl();

    // Get token from the repository
    String? token = await repository.getToken();

    if (token != null && token.isNotEmpty) {
      print("Token: $token");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      // If no token, check if "Remember Me" is checked in SharedPreferences
      isChecked = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('rememberMe') == 'true');

      print("Remember Me: $isChecked");

      if (isChecked == true) {
        setState(() {
          isChecked == true;
        });
        // If "Remember Me" is checked, retrieve saved email and password
        String? savedEmail = await SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('savedEmail'));
        String? savedPassword = await SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('savedPassword'));

        // Populate the email and password fields if available
        if (savedEmail != null && savedPassword != null) {
          _emailcontroller.text = savedEmail;
          _passwordController.text = savedPassword;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InternetConnectionChecker(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInFailure) {
              // Handle failure (e.g., show a snackbar)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              print('Sign In Error: ${state.error}');
            } else if (state is SignInSuccess) {
              // Handle success (e.g., navigate to Dashboard)
              Navigator.pushReplacementNamed(context, '/Home');
            }
          },
          builder: (context, state) {
            if (state is SignInLoading) {
              // Show loading spinner when the state is loading
              return Center(child: OverlayLoader());
            }
            return Container(
              padding: EdgeInsets.only(
                top: screenWidth * 0.2,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSignInText(),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  LabeledTextWithoutAsterisk(text: 'Email'),
                  SizedBox(
                    height: 5,
                  ),
                  IDTextEditor(),
                  SizedBox(
                    height: 20,
                  ),
                  LabeledTextWithoutAsterisk(text: 'Password'),
                  SizedBox(
                    height: 5,
                  ),
                  PasswordTextEditor(),
                  SizedBox(
                    height: 10,
                  ),
                  RememberMeAndForgotPassword(),
                  SizedBox(
                    height: 40,
                  ),
                  SignInandFingerScanButtons(context),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  ORDivider(),
                  SizedBox(
                    height: 30,
                  ),
                  IDSwitchButton(context),
                  SizedBox(
                    height: 20,
                  ),
                  FooterButton()
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

  ElevatedButton IDSwitchButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          /*backgroundColor: AppColors.lightBackground,
          disabledBackgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.lightBackground,
          disabledForegroundColor: AppColors.lightBackground,*/
          //splashFactory: NoSplash.splashFactory,
          // Disable the splash effect
          /*  splashColor: MaterialStateProperty.all(Colors.transparent),  // Remove splash color
                    highlightColor: MaterialStateProperty.all(Colors.transparent),  // Remove highlight color*/
          fixedSize: Size(MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.06),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(
                color: AppColors.primary,
                width: 2,
              )),
        ),
        onPressed: () {
          setState(() {
            _isEmployeeID = !_isEmployeeID;
          });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.EmployeeIDIcon,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                _isEmployeeID
                    ? 'Sign In with Email ID'
                    : 'Sign In with Employee ID',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ));
  }

  Row FooterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Center align the row
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            'Contact with HR',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Row ORDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.textGrey,
            height: 1,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.textGrey,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Row SignInandFingerScanButtons(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              fixedSize: Size(MediaQuery.of(context).size.width * 0.57,
                  MediaQuery.of(context).size.height * 0.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () {
              print('Email: ${_emailcontroller.text}');
              print('Password: ${_passwordController.text}');
              print('RememberMe: $isChecked');
              // Trigger the sign-in event
              BlocProvider.of<SignInBloc>(context).add(
                PerformSignInEvent(
                  username: _emailcontroller.text,
                  password: _passwordController.text,
                  rememberMe: isChecked,
                ),
              );
              /* Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );*/
            },
            child: Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            )),
        Spacer(),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              fixedSize: Size(MediaQuery.of(context).size.width * 0.2,
                  MediaQuery.of(context).size.height * 0.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const FingerScanOverlay(),
              );
            },
            child: Image.asset(AppImages.FingerPrintIcon))
      ],
    );
  }

  TextEditor IDTextEditor() {
    return TextEditor(
        controller: _emailcontroller,
        hintText: _isEmployeeID ? 'My ID' : 'My Email',
        prefixIcon: Image.asset(
          AppImages.EmailIcon,
          height: 5,
          width: 5,
        ));
  }

  TextEditor PasswordTextEditor() {
    return TextEditor(
      obscureText: _isObscured,
      controller: _passwordController,
      hintText: 'My Password',
      prefixIcon: Image.asset(
        AppImages.PasswordIcon,
        height: 5,
        width: 5,
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
        child: _buildIcon(),
      ),
    );
  }

  Row RememberMeAndForgotPassword() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked; // Toggle the value
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isChecked ? AppColors.primary : AppColors.textGrey,
                  width: 2),
              borderRadius: BorderRadius.circular(5.0),
              /*   color: isChecked
                            ? AppColors.primary
                            : AppColors.lightBackground,*/
            ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    color: AppColors.textGrey,
                    size: 16,
                  )
                : null,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        const Text(
          'Remember Me',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey, // Customize text color
          ),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            print("Forgot Password tapped");
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: AppColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto'),
          ),
        )
      ],
    );
  }

  Widget buildSignInText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            'Sign in to my Account',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    );
  }
}
