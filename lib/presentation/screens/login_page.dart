import 'package:com.tara_driver_application/core/utils/phone_formatter.dart';
import 'package:com.tara_driver_application/presentation/blocs/phone_login_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/otp_page.dart';
import 'package:com.tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/shake_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/x_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
              String? errorMessage;
              if (state is PhoneLoginValidationErrorState) {
                errorMessage = state.errorMessage;
              }

              Logger().e("isLoading $isLoading");

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
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 68,
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
                                    "Enter your number to access your account.",
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
                                          "Mobile Number",
                                          style: ThemeConstands.font16Regular,
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),

                                        ShakeWidget(
                                          key: context
                                              .read<PhoneLoginBloc>()
                                              .phoneShake,
                                          shakeCount: 3,
                                          shakeOffset: 10,
                                          shakeDuration:
                                              const Duration(milliseconds: 500),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: XTextField(
                                              textController:
                                                  controller, // logic.phoneTextController,
                                              hintText:
                                                  "e.g. 012 345 678", // AppLocale.enterPhoneNumber.tr,
                                              enable:
                                                  true, //!logic.state.isLoading.value,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    12),
                                                CardNumberInputFormatter(),
                                              ],
                                              prefixIcon: Icon(
                                                CupertinoIcons.phone_fill,
                                                color: Colors.grey.shade600,
                                                size: 24.0,
                                              ),
                                              hasShadow: false,
                                              borderColor: AppColors.dark4,
                                              maxLength: 25,
                                              onChanged: (value) {},
                                              // logic.state.phoneNumber.value = value,
                                              onFieldSubmitted: (value) {
                                                context
                                                    .read<PhoneLoginBloc>()
                                                    .add(
                                                      PhoneNumValidateEvent(
                                                          phoneNumber: value),
                                                    );
                                              },
                                              // logic.loginPhoneNumber(),
                                              keyboardType: TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.done,
                                              errorMessage: errorMessage,
                                              //  logic
                                              //         .state.errorMessage.value!.isEmpty
                                              //     ? null
                                              //     : logic.state.isInvalid.value
                                              //         ? AppLocale.loginPhoneInvalid.tr
                                              //         : logic.state.isErrorLogin.value
                                              //             ? AppLocale.loginErrorMessage.tr
                                              //             : ""
                                            ),
                                          ),
                                        ),

                                        // TextFormField(
                                        //   controller: controller,
                                        //   autofocus: true,
                                        //   textAlign: TextAlign.start,
                                        //   keyboardType: TextInputType.number,
                                        //   // onChanged: (value) {},
                                        //   // validator: (value) {
                                        //   // Remove any spaces and check if it is exactly 8 digits
                                        //   // if (value == null ||
                                        //   //     value.isEmpty) {
                                        //   //   return 'Please enter your phone number';
                                        //   // } else if (value.length != 8) {
                                        //   //   return 'Phone number must be 8 digits';
                                        //   // }
                                        //   // return null; // Valid phone number
                                        //   // },
                                        //   decoration: InputDecoration(
                                        //     prefix: Text(
                                        //       "+855 - ",
                                        //       style: ThemeConstands
                                        //           .font16Regular
                                        //           .copyWith(
                                        //               color: AppColors.dark3),
                                        //     ),
                                        //     filled: true,
                                        //     fillColor: AppColors.light3,
                                        //     hintText: 'xxx-xxx-xxx',
                                        //     hintStyle: ThemeConstands
                                        //         .font16Regular
                                        //         .copyWith(
                                        //             color: AppColors.dark3),
                                        //     border: OutlineInputBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(12),
                                        //     ),
                                        //     enabledBorder: OutlineInputBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(12),
                                        //       borderSide: BorderSide.none,
                                        //     ),
                                        //     focusedBorder: OutlineInputBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(10),
                                        //       borderSide: const BorderSide(
                                        //           color: AppColors.main),
                                        //     ),
                                        //     errorBorder: OutlineInputBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(10),
                                        //       borderSide: const BorderSide(
                                        //           color: AppColors.red),
                                        //     ),
                                        //   ),
                                        // ),

                                        const SizedBox(
                                          height: 18,
                                        ),
                                        FBTNWidget(
                                          onPressed: () async {
                                            context.read<PhoneLoginBloc>().add(
                                                  PhoneNumLoginEvent(
                                                    phoneNumber:
                                                        controller.value.text,
                                                  ),
                                                );
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
