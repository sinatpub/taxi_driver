import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:tara_driver_application/presentation/repository/language_data.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {

  List<Lang> langs = allLangs;
  updateLanguageLocal(Locale locale, BuildContext context) {
    context.setLocale(locale);
  }
  @override
  Widget build(BuildContext context) {
    final translate = context.locale.toString();
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
                    title:Text(lang.title, style: ThemeConstands.font18Regular),
                    trailing: translate == langs[index].sublang
                        ? const Icon(
                            Icons.check_circle_outline_sharp,
                            color: AppColors.main,
                          )
                        : const Icon(null),
                    onTap: () {
                        updateLanguageLocal(Locale(langs[index].sublang), context);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        setState(() {
                          
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