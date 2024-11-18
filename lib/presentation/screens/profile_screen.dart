import 'package:com.tara_driver_application/core/storages/remove_storage.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/presentation/blocs/get_profile_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/login_page.dart';
import 'package:com.tara_driver_application/presentation/widgets/network_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/repository/language_data.dart';
import 'package:com.tara_driver_application/presentation/screens/payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var option = [
    "Tuk Tuk",
    "Classic Car",
    "SUV Car",
    "Mini Van",
  ];

  var settingAction = [
    Item(
        icon: ImageAssets.icon_contact_setting,
        title: "Payment",
        actionIndex: 0),
    Item(
        icon: ImageAssets.icon_setting_setting,
        title: "Setting 02",
        actionIndex: 1),
    Item(icon: ImageAssets.icon_logout, title: "Logout", actionIndex: 2),
  ];

  List<Lang> langs = allLangs;
  updateLanguageLocal(Locale locale, BuildContext context) {
    context.setLocale(locale);
  }

  int activeOption = 0;

  @override
  void initState() {
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
                "Profile",
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
                            return Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 28),
                                    child: Text("CHOOSE_LANGUADE".tr(),
                                        style: ThemeConstands.font14Regular
                                            .copyWith(
                                          color: AppColors.dark2,
                                        )),
                                  ),
                                  const Divider(
                                    height: 1,
                                    thickness: 0.5,
                                  ),
                                  Container(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(0),
                                        itemCount: langs.length,
                                        itemBuilder: (context, index) {
                                          var lang = langs[index];
                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: translate == lang.sublang
                                                    ? AppColors.error
                                                        .withOpacity(0.2)
                                                    : AppColors.light4,
                                                border: Border(
                                                    bottom: BorderSide(
                                                  color: AppColors.dark2
                                                      .withOpacity(0.1),
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
                                              title: Text(
                                                lang.title,
                                                style: translate ==
                                                        langs[index].sublang
                                                    ? ThemeConstands
                                                        .font16SemiBold
                                                    : ThemeConstands
                                                        .font16SemiBold
                                                        .copyWith(
                                                            color: AppColors
                                                                .dark2),
                                              ),
                                              trailing: translate ==
                                                      langs[index].sublang
                                                  ? const Icon(
                                                      Icons
                                                          .check_circle_outline_sharp,
                                                      color: AppColors.main,
                                                    )
                                                  : const Icon(null),
                                              onTap: () {
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                  updateLanguageLocal(
                                                      Locale(
                                                          langs[index].sublang),
                                                      context);
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            );
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
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                var data = state.profileData.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: NetworkImageWidget(
                                  imageUrl: "${data?.profileImage.toString()}",
                                )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data?.firstName} ${data?.lastName}",
                                    style: ThemeConstands.font22SemiBold
                                        .copyWith(color: AppColors.dark1),
                                  ),
                                  Text(
                                    "See you profile",
                                    style: ThemeConstands.font14Regular
                                        .copyWith(color: AppColors.dark1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      //   alignment: Alignment.centerLeft,
                      //   child: Text("Your Service Provided",style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.dark1),textAlign: TextAlign.left,)
                      // ),
                      // GridView.builder(
                      //   padding: const EdgeInsets.all(0),
                      //   physics:const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisExtent: 45),
                      //   itemCount: option.length,
                      //   itemBuilder: (context, index) {
                      //     return InkWell(
                      //       splashColor: Colors.transparent,
                      //       highlightColor: Colors.transparent,
                      //       onTap: (){
                      //         setState(() {
                      //           activeOption = index;
                      //         });
                      //       },
                      //       child: Row(
                      //         children: [
                      //           Radio(
                      //             fillColor: WidgetStateProperty.resolveWith<Color>(
                      //               (Set<WidgetState> states) {
                      //                 return (activeOption == index)
                      //                     ? AppColors.error
                      //                     : AppColors.dark3;
                      //               }
                      //             ),
                      //             autofocus: false,
                      //             value: index,
                      //             groupValue: activeOption,
                      //             activeColor: AppColors.error,
                      //             onChanged: (value) {
                      //               setState(() {
                      //                 activeOption = index;
                      //               });
                      //             },
                      //           ),
                      //           Text(option[index],style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),textAlign: TextAlign.left,)
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Setting",
                            style: ThemeConstands.font16SemiBold
                                .copyWith(color: AppColors.dark1),
                            textAlign: TextAlign.left,
                          )),

                      Container(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          itemCount: settingAction.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              decoration: const BoxDecoration(
                                color: AppColors.light4,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                elevation: 0,
                                onPressed: () async {
                                  if (settingAction[index].actionIndex == 0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PaymentScreen()));
                                  } else if (settingAction[index].actionIndex ==
                                      2) {
                                    await StorageRemove.removeDriverData()
                                        .then((value) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    });
                                  }
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
                                        style: ThemeConstands.font16SemiBold
                                            .copyWith(color: AppColors.dark1),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    "Coming Soon!",
                    style: ThemeConstands.font28SemiBold,
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

class Item {
  String icon;
  String title;
  int actionIndex;
  Item({required this.icon, required this.title, required this.actionIndex});
}
