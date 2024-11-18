import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';

class DropdownWidget extends StatelessWidget {
  String? hinText;
  String? selectedValue;
  Function(String?)? onChanged;
  List<DropdownMenuItem<String>>? items;
  DropdownWidget({super.key,required this.hinText,required this.items,required this.onChanged,required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                hinText.toString(),
                style: ThemeConstands.font16Regular.copyWith(color: AppColors.dark3),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items,
        value: selectedValue,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 55,
          padding: const EdgeInsets.only(left: 0, right: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.light3,
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
          ),
          iconSize: 28,
          iconEnabledColor: AppColors.dark3,
          iconDisabledColor: AppColors.dark4,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 1,
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.light3,
          ),
          offset: const Offset(0, -10),
          scrollbarTheme:const ScrollbarThemeData(
            radius:  Radius.circular(10),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}