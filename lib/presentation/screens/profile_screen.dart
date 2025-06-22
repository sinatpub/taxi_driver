import 'package:tara_driver_application/app/alert_widget.dart';
import 'package:tara_driver_application/presentation/blocs/get_profile_bloc.dart';
import 'package:tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:tara_driver_application/presentation/widgets/simmer_widget.dart';
import 'package:tara_driver_application/presentation/widgets/t_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_driver_application/core/resources/asset_resource.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:tara_driver_application/presentation/repository/language_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var settingAction = [
    Item(
        icon: ImageAssets.icon_contact_setting,
        title: "TERMCONDITION".tr(),
        actionIndex: 0),
    Item(
        icon: ImageAssets.icon_setting_setting,
        title: "CONTACTUS".tr(),
        actionIndex: 1),
    Item(icon: ImageAssets.icon_logout, title: "LOGOUT".tr(), actionIndex: 2),
  ];

  List<Lang> langs = allLangs;
  updateLanguageLocal(Locale locale, BuildContext context) {
    context.setLocale(locale);
  }

  @override
  void initState() {
    setState(() {
      BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translate = context.locale.toString();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MORE".tr(),
                style: ThemeConstands.font22SemiBold
                    .copyWith(color: AppColors.dark1),
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
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter stateSetter) {
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
                        ))
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: AppColors.light1,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const ShimmerProfile();
                    } else if (state is ProfileLoaded) {
                      var data = state.profileData.data;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TImageWidget(
                                image:
                                    NetworkImage(data!.profileImage.toString()),
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name.toString(),
                                    style: ThemeConstands.font22SemiBold
                                        .copyWith(color: AppColors.dark1),
                                  ),
                                  Text(
                                    data.phone.toString(),
                                    style: ThemeConstands.font14Regular
                                        .copyWith(color: AppColors.dark1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const ShimmerProfile();
                    }
                  },
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SETTING".tr(),
                      style: ThemeConstands.font18SemiBold
                          .copyWith(color: AppColors.dark1),
                      textAlign: TextAlign.left,
                    )),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemCount: settingAction.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.light4,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFEDEBEB),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: MaterialButton(
                        height: 50,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        elevation: 0,
                        onPressed: () async {
                          if (settingAction[index].actionIndex == 0) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const PaymentScreen()));
                          } else if (settingAction[index].actionIndex == 2) {
                            AlertWidget().logout(context);
                          } else {}
                        },
                        child: Container(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                settingAction[index].icon,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                settingAction[index].title,
                                style: ThemeConstands.font16Regular
                                    .copyWith(color: AppColors.dark1),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget changeLanguage({required String translate}) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.light4,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 4,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: AppColors.dark4),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 16, left: 28, right: 28, bottom: 16),
            child: Text("CHOOSE_LANGUADE".tr(),
                style: ThemeConstands.font18SemiBold.copyWith(
                  color: AppColors.dark2,
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
                      color: AppColors.light4,
                      border: Border(
                          bottom: BorderSide(
                        color: AppColors.dark2.withOpacity(0.1),
                        width: 1,
                      ))),
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
                    title:
                        Text(lang.title, style: ThemeConstands.font18Regular),
                    trailing: translate == langs[index].sublang
                        ? const Icon(
                            Icons.check_circle_outline_sharp,
                            color: AppColors.main,
                          )
                        : const Icon(null),
                    onTap: () {
                      setState(() {
                        // Navigator.of(context).pop();
                        updateLanguageLocal(
                            Locale(langs[index].sublang), context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                NavScreen(
                              selectedIndex: 2,
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                          (route) => false,
                        );
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

class Item {
  String icon;
  String title;
  int actionIndex;
  Item({required this.icon, required this.title, required this.actionIndex});
}
