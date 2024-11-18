import 'package:com.tara_driver_application/presentation/blocs/phone_login_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/otp_page.dart';
import 'package:com.tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  bool hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light4,
      body: BlocListener<PhoneLoginBloc, PhoneLoginState>(
        listener: (context, state) {
          if (state is PhoneLoginLoadedState) {
            // if (!hasNavigated) {
            //   hasNavigated = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  phoneNumberModel: state.phoneNumberModel,
                  phoneNumber: controller.text.toString(),
                ),
              ),
            );
            // }
          } else if (state is PhoneLoginFailState) {
            hasNavigated = false;
            showErrorCustomDialog(
              context,
              "Please Try Again",
              "Please make sure you enter the correct phone number",
            );
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<PhoneLoginBloc, PhoneLoginState>(
            builder: (context, state) {
              bool isLoading = state is PhoneLoginLoadingState;
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              alignment: Alignment.centerLeft,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 24,
                              )),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 28,
                                  ),
                                  const Text(
                                    "Login Your Account",
                                    style: ThemeConstands.font20SemiBold,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const Text(
                                    "Please Input your phone number for login into your account",
                                    style: ThemeConstands.font16Regular,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 48,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Phone Number",
                                          style: ThemeConstands.font18Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        TextFormField(
                                          controller: controller,
                                          autofocus: true,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.number,
                                          // onChanged: (value) {},
                                          // validator: (value) {
                                            // Remove any spaces and check if it is exactly 8 digits
                                            // if (value == null ||
                                            //     value.isEmpty) {
                                            //   return 'Please enter your phone number';
                                            // } else if (value.length != 8) {
                                            //   return 'Phone number must be 8 digits';
                                            // }
                                            // return null; // Valid phone number
                                          // },
                                          decoration: InputDecoration(
                                            prefix: Text(
                                              "+855 - ",
                                              style: ThemeConstands
                                                  .font16Regular
                                                  .copyWith(
                                                      color: AppColors.dark3),
                                            ),
                                            filled: true,
                                            fillColor: AppColors.light3,
                                            hintText: 'xxx-xxx-xxx',
                                            hintStyle: ThemeConstands
                                                .font16Regular
                                                .copyWith(
                                                    color: AppColors.dark3),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: AppColors.main),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: AppColors.red),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 38,
                                        ),
                                        FBTNWidget(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<PhoneLoginBloc>()
                                                  .add(PhoneNumLoginEvent(
                                                      phoneNumber: controller
                                                          .value.text));
                                            }
                                          },
                                          color: AppColors.red,
                                          textColor: AppColors.light4,
                                          label: "Next",
                                          enableWidth: true,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading) const LoadingWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
