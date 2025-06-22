import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart' show AppColors;
import '../../core/theme/text_styles.dart';

class DropdownSelection<T> {
  final int? index;
  final T? item;

  DropdownSelection({this.index, this.item});
}

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final int? selectedIndex;
  final String? hintText;
  final double width;
  final double height;
  final double maxHeight;
  final bool isEnable;
  final ValueChanged<DropdownSelection<T>>? onChanged;
  final String Function(T) itemToString;
  final Function(bool)? onTap;

  const SearchableDropdown({
    super.key,
    required this.items,
    this.selectedIndex,
    this.hintText,
    this.width = 200,
    this.height = 48,
    this.maxHeight = 350,
    this.isEnable = true,
    this.onChanged,
    this.onTap,
    required this.itemToString,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  int? _selectedIndex;
  late final TextEditingController textEditingController;
  bool isSearchEmpty = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    textEditingController = TextEditingController();
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
    // Reset _selectedIndex if items change and current index is invalid
    if (!identical(widget.items, oldWidget.items)) {
      if (_selectedIndex != null &&
          (_selectedIndex! < 0 || _selectedIndex! >= widget.items.length)) {
        _selectedIndex = null;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _debounceTimer?.cancel();
    textEditingController.dispose();
  }

  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder textfieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.main,
        width: 0.8,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    T? getSelectedValue() => _selectedIndex != null &&
            _selectedIndex! >= 0 &&
            _selectedIndex! < widget.items.length
        ? widget.items[_selectedIndex!]
        : null;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          widget.hintText ?? "Hint Text",
          style: ThemeConstands.font14Regular.copyWith(color: AppColors.dark2),
        ),

        items: widget.items
            .toSet()
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  widget.itemToString(item),
                  style: ThemeConstands.font16SemiBold.copyWith(
                    color: _selectedIndex == widget.items.indexOf(item)
                        ? AppColors.main
                        : null,
                  ),
                ),
              ),
            )
            .toList(),
        value: getSelectedValue(),
        onChanged: widget.isEnable
            ? (value) {
                final newIndex =
                    value != null ? widget.items.indexOf(value) : null;
                setState(() => _selectedIndex = newIndex);
                widget.onChanged?.call(
                  DropdownSelection(
                    index: newIndex,
                    item: value, // Pass both index and item
                  ),
                );
              }
            : null,
        onMenuStateChange: (isOpen) {
          if (!isOpen) textEditingController.clear();
          widget.onTap?.call(isOpen);
        },
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.only(
            left: 16.0,
            right: _selectedIndex == null ? 16.0 : 0,
          ),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
                color:
                    _selectedIndex == null ? AppColors.dark2 : AppColors.main),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // dropdown decoration
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.maxHeight,
          elevation: 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
          ),
        ),

        // style for item dropdown
        menuItemStyleData: MenuItemStyleData(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          selectedMenuItemBuilder: (context, value) {
            return Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: _selectedIndex != null
                  ? Text(
                      widget.itemToString(widget.items[_selectedIndex!]),
                      style: ThemeConstands.font16SemiBold.copyWith(
                          color: _selectedIndex != null
                              ? Colors.white
                              : AppColors.dark1),
                    )
                  : null,
            );
          },
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: textEditingController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Column(children: [
            Container(
              height: 48,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  hintText: "Search - ស្វែងរក",
                  hintStyle: ThemeConstands.font12Regular,
                  border: textfieldBorder,
                  enabledBorder: textfieldBorder,
                  focusedBorder: textfieldBorder,
                ),
              ),
            ),
          ]),
          searchMatchFn: (item, searchValue) {
            if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 300), () {
              final isEmpty = widget
                  .itemToString(item.value as T)
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());

              setState(() => isSearchEmpty = isEmpty);
            });
            final match = widget
                .itemToString(item.value as T)
                .toLowerCase()
                .contains(searchValue.toLowerCase());

            return match;
          },
        ),

        iconStyleData: IconStyleData(
          icon: _selectedIndex == null
              ? const Icon(
                  Icons.chevron_right,
                  color: AppColors.dark1,
                )
              : IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: 16,
                    color: AppColors.dark1,
                  ),
                  onPressed: () {
                    setState(() => _selectedIndex = null);
                    widget.onChanged?.call(DropdownSelection(
                      index: null,
                      item: null, // Clear selection
                    ));
                  },
                ),
        ),
      ),
    );
  }
}
