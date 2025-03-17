import 'dart:async';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/models/phone_model.dart';
import 'package:com.tara_driver_application/presentation/blocs/otp_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:com.tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/screens/register_page.dart';

class OtpPage extends StatefulWidget {
  final PhoneNumberModel? phoneNumberModel;
  final String? phoneNumber;
  const OtpPage({super.key, this.phoneNumberModel, this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final SmartAuth smartAuth = SmartAuth.instance;
  TextEditingController pinputController = TextEditingController();
  int? resentToken;

  late Timer timer;
  int secondsRemaining = 0;
  bool isResendEnabled = false;

  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    smsRetriever = SmsRetrieverImpl(smartAuth);

    // Initialize countdown timer
    secondsRemaining = widget.phoneNumberModel?.data.seconde ?? 90;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    timer.cancel(); // Cancel timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: ThemeConstands.font22SemiBold,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dark4, width: 2),
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.light4,
      body: SafeArea(
        bottom: false,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: BlocListener<OTPVerifyBloc, OTPState>(
            listener: (context, state) {
              if (state is NewDriverState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ));
              } else if (state is OTPVerifyLoadedState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavScreen(),
                    ));
              } else if (state is OTPVerifyFailState) {
                showErrorCustomDialog(context, "Please Try Again",
                    "Please make sure enter correct OTP");
              }
            },
            child: BlocBuilder<OTPVerifyBloc, OTPState>(
              builder: (context, state) {
                bool isLoading = state is OTPVerifyLoadingState;
                return Stack(
                  children: [
                    Column(
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
                                    "Fill Information",
                                    style: ThemeConstands.font20SemiBold,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const Text(
                                    "We have sent the verification code to your Phone Number",
                                    style: ThemeConstands.font16Regular,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 48,
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Pinput(
                                      length: 6,
                                      autofocus: true,
                                      smsRetriever: smsRetriever,
                                      controller: pinController,
                                      focusNode: focusNode,
                                      defaultPinTheme: defaultPinTheme,
                                      separatorBuilder: (index) =>
                                          const SizedBox(width: 8),
                                      hapticFeedbackType:
                                          HapticFeedbackType.lightImpact,
                                      onChanged: (value) {
                                        debugPrint("---> value ---> $value");
                                      },
                                      onCompleted: (value) async {
                                        context.read<OTPVerifyBloc>().add(
                                              VerifyOTPEvent(
                                                phoneNumber: widget.phoneNumber
                                                    .toString(),
                                                otpCode: value.toString(),
                                              ),
                                            );
                                      },
                                      focusedPinTheme: defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!
                                            .copyWith(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.main, width: 2),
                                        ),
                                      ),
                                      submittedPinTheme:
                                          defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!
                                            .copyWith(
                                          color: AppColors.light4,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.dark4, width: 2),
                                        ),
                                      ),
                                      errorPinTheme:
                                          defaultPinTheme.copyBorderWith(
                                        border: Border.all(
                                            color: Colors.redAccent, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 28,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Didn’t Receive OTP?",
                                        style: ThemeConstands.font16Regular,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          width: 8), // Add some space
                                      Text(
                                        "${secondsRemaining}s", // Display remaining seconds
                                        style: ThemeConstands.font16Regular
                                            .copyWith(
                                          color: AppColors.dark1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16), // Add some space
                                  TextButton(
                                    onPressed: isResendEnabled
                                        ? () {
                                            tlog('Resend Code Pressed!');
                                            // BlocProvider.of<PhoneLoginBloc>(context).add(
                                            //     PhoneNumLoginEvent(
                                            //         phoneNumber:
                                            //             widget.phoneNumber.toString()));
                                          }
                                        : null, // Disable button if countdown is active
                                    child: Text(
                                      "Resend Code",
                                      style: ThemeConstands.font16SemiBold.copyWith(
                                          decoration: TextDecoration.underline,
                                          color: isResendEnabled
                                              ? AppColors.dark1
                                              : AppColors
                                                  .dark4), // Change color based on enabled state
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isLoading) const LoadingWidget(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsRetrieverApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsWithRetrieverApi();

    if (res.hasData) {
      return res.requireData.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
