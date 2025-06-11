import 'dart:io';

import 'package:tara_driver_application/core/resources/asset_resource.dart';
import 'package:tara_driver_application/core/utils/phone_formatter.dart';
import 'package:tara_driver_application/presentation/blocs/phone_login_bloc.dart';
import 'package:tara_driver_application/presentation/repository/language_data.dart';
import 'package:tara_driver_application/presentation/screens/otp_page.dart';
import 'package:tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:tara_driver_application/presentation/widgets/shake_widget.dart';
import 'package:tara_driver_application/presentation/widgets/x_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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


  List<Lang> langs = allLangs;
  updateLanguageLocal(Locale locale, BuildContext context) {
    context.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final translate = context.locale.toString();
    return Scaffold(
      backgroundColor: AppColors.light4,
      body: BlocListener<PhoneLoginBloc, PhoneLoginState>(
        listener: (context, state) {
          if (state is PhoneLoginLoadedState) {
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
              "PLEASE_TRY_AGAIN".tr(),
              "CHECK_YOUR_PHONE_NUMBER_ERROR".tr(),
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
              bool? isInvalidPhone;
              bool? isRequired8Digit;
              if (state is PhoneLoginValidationErrorState) {
                // errorMessage = state.errorMessage;
                isInvalidPhone = state.isInvalid;
                isRequired8Digit = state.isRequired8DigitError;
              }
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                alignment: Alignment.centerLeft,
                                onPressed: () {
                                  exit(0);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:(BuildContext context, StateSetter stateSetter) {
                                        return changeLanguage(translate: translate);
                                      });
                                    });
                              },
                              padding: const EdgeInsets.all(0),
                              icon: translate == "km"
                                  ? SvgPicture.asset(
                                      ImageAssets.flag_km,
                                      width: 30,
                                    )
                                  : Image.asset(
                                      ImageAssets.flag_en,
                                      width: 30,
                                    )
                            )
                          ],
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
                                  Text(
                                    "LOGINTITLE".tr(),
                                    style: ThemeConstands.font20SemiBold,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Text(
                                    "LOGINDES".tr(),
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
                                        Text(
                                          "MOBILENUM".tr(),
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
                                              textController: controller,
                                              hintText: "012 345 678",
                                              enable: true,
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
                                                  TextInputAction.send,
                                              errorMessage: isInvalidPhone ==
                                                      true
                                                  ? "CHECK_YOUR_PHONE_NUMBER_ERROR"
                                                      .tr()
                                                  : isRequired8Digit == true
                                                      ? "CHECK_PHONE_NUMBER_DIGIT_ERROR"
                                                          .tr()
                                                      : null,
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
                                          label: "NEXT".tr(),
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
  Widget changeLanguage({required String translate}){
    return Container(
      decoration:const BoxDecoration(
        color:AppColors.light4,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin:const EdgeInsets.only(top: 12),
            height: 4,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.dark4
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, left: 28,right: 28,bottom: 16),
            child: Text("CHOOSE_LANGUADE".tr(),style: ThemeConstands.font18SemiBold.copyWith(color: AppColors.dark2,
            )),
          ),
          const Divider(),
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: langs.length,
              itemBuilder: (context, index) {
                var lang = langs[index];
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:AppColors.light4,
                    border: Border(bottom: BorderSide(color: AppColors.dark2.withOpacity(0.1),width: 1,))
                  ),
                  height: 85,
                  child: ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipOval(
                          child: SvgPicture.asset(
                        lang.image,
                        fit: BoxFit.cover,
                      )),
                    ),
                    title: Text(
                      lang.title,
                      style:ThemeConstands.font18Regular
                    ),
                    trailing: translate == langs[index].sublang
                        ? const Icon(Icons.check_circle_outline_sharp,color: AppColors.main,
                          )
                        : const Icon(null),
                    onTap: () {
                      setState(() {
                        updateLanguageLocal(Locale(langs[index].sublang),context);
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                );
              }),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
