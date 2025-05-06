import 'package:com.tara_driver_application/core/storages/remove_storage.dart';
import 'package:com.tara_driver_application/presentation/screens/login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

import '../presentation/widgets/yesno_dialog_widget.dart';

class AlertWidget {
  void logout(BuildContext context) async {
    try {
      showYesNoCustomDialog(context:  context,title: "LOGOUT".tr(),description: "ARE_YOU_LOGOUT".tr(), onYes: () async {
        EasyLoading.show();
        await StorageRemove.removeDriverData();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const LoginPage()));
        EasyLoading.dismiss();
      });
    } catch (e) {
      Logger().e("message: $e");
    }
  }

}