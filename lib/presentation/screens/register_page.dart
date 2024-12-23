import 'dart:io';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/presentation/blocs/register_bloc.dart';
import 'package:com.tara_driver_application/presentation/blocs/vehical_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:com.tara_driver_application/presentation/widgets/card_atta_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/dropdown_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPlate = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? imageProfile;
  File? imageCardID;
  File? imageLicense;

  String? selectedValueService;
  int? vehicalId;
  String? selectedValueColor;

  @override
  void initState() {
    BlocProvider.of<VehicalBloc>(context).add(GetAllVehicalEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light4,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is DriverRegisterFail) {
              showErrorCustomDialog(context, "Something went wrong!",
                  "All of the fields are require");
            } else if (state is DriverRegisterLoaded) {
              Taxi.shared.checkDriverAvailability();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const NavScreen()));
            }
          },
          builder: (context, state) {
            bool isLoading = state is DriverRegisterLoading;
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
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 18,
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
                                "Please fill out the information below to register for a new account.",
                                style: ThemeConstands.font16Regular,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 48,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Full Name",
                                      style: ThemeConstands.font18Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: controllerName,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.light3,
                                        hintText: "Full Name",
                                        hintStyle: ThemeConstands.font16Regular
                                            .copyWith(color: AppColors.dark3),
                                        border: border,
                                        enabledBorder: enableBorder,
                                        focusedBorder: focusColor,
                                        errorBorder: errorColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Service type",
                                      style: ThemeConstands.font18Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    BlocBuilder<VehicalBloc, VehicalState>(
                                      builder: (context, state) {
                                        if (state is VehicalLoaded) {
                                          var vehicalTypeData =
                                              state.vehicalData.data;
                                          return DropdownWidget(
                                            hinText: "Select Service type",
                                            selectedValue: selectedValueService,
                                            onChanged: (String? value) {
                                              var vehicalItem =
                                                  vehicalTypeData.firstWhere(
                                                (item) =>
                                                    item.id.toString() == value,
                                              );

                                              setState(() {
                                                selectedValueService = value;
                                                vehicalId = vehicalItem.id;
                                              });
                                              tlog(
                                                  "Vehical Selection ID $vehicalId");
                                            },
                                            items: vehicalTypeData
                                                .map((vehical) =>
                                                    DropdownMenuItem<String>(
                                                      value:
                                                          vehical.id.toString(),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              vehical.name,
                                                              style: ThemeConstands
                                                                  .font16SemiBold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Select color",
                                      style: ThemeConstands.font18Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    DropdownWidget(
                                      hinText: "Select color",
                                      selectedValue: selectedValueColor,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedValueColor = value;
                                        });
                                      },
                                      items: itemsColor
                                          .map((String color) =>
                                              DropdownMenuItem<String>(
                                                value: color,
                                                alignment: Alignment.center,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        color,
                                                        style: ThemeConstands
                                                            .font16SemiBold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Plate Number",
                                      style: ThemeConstands.font18Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: controllerPlate,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.light3,
                                        hintText: 'XXX-XXXX',
                                        hintStyle: ThemeConstands.font16Regular
                                            .copyWith(color: AppColors.dark3),
                                        border: border,
                                        enabledBorder: enableBorder,
                                        focusedBorder: focusColor,
                                        errorBorder: errorColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Upload Attachment",
                                      style: ThemeConstands.font18Regular,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 0,
                                        ),
                                        Expanded(
                                            child: CardUploadAttachment(
                                          onPressedIcon: () {
                                            setState(() {
                                              imageProfile = null;
                                            });
                                          },
                                          title: "Profile",
                                          image: imageProfile,
                                          icon: ImageAssets.book_outline,
                                          onPressed: () {
                                            getMediaFromDevice(0);
                                          },
                                        )),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: CardUploadAttachment(
                                          onPressedIcon: () {
                                            setState(() {
                                              imageCardID = null;
                                            });
                                          },
                                          title: "Card ID",
                                          image: imageCardID,
                                          icon: ImageAssets.book_outline,
                                          onPressed: () {
                                            getMediaFromDevice(1);
                                          },
                                        )),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: CardUploadAttachment(
                                          onPressedIcon: () {
                                            setState(() {
                                              imageLicense = null;
                                            });
                                          },
                                          title: "Driver License",
                                          image: imageLicense,
                                          icon: ImageAssets.book_outline,
                                          onPressed: () {
                                            getMediaFromDevice(2);
                                          },
                                        )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 38,
                                    ),
                                    FBTNWidget(
                                      onPressed: controllerName.text == "" &&
                                              controllerPlate.text == ""
                                          ? null
                                          : () {
                                              FocusScope.of(context).unfocus();
                                              tlog(
                                                  "Register Driver ${controllerName.text.toString()},Vehical ID: $vehicalId, Plate Number ${controllerPlate.text},profile: $imageProfile, cardId: $imageCardID, driver license: $imageLicense");

                                              BlocProvider.of<RegisterBloc>(
                                                      context)
                                                  .add(
                                                DriverRegisterEvent(
                                                  fullname: controllerName.text
                                                      .toString(),
                                                  plateNumber: controllerPlate
                                                      .text
                                                      .toString(),
                                                  vehicalId: "$vehicalId",
                                                  vehicalColor: 'White',
                                                  deviceToken: '9999',
                                                  cardImage: imageCardID!,
                                                  profileImage: imageProfile!,
                                                  driverLicenseImage:
                                                      imageLicense!,
                                                ),
                                              );
                                            },
                                      color: AppColors.red,
                                      textColor: AppColors.light4,
                                      label: "Create ",
                                      enableWidth: true,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const Positioned(
                    child: LoadingWidget(),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> getImageFromCamera(int selectImageType) async {
    var imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        if (selectImageType == 0) {
          imageProfile = File(imageFile.path);
        } else if (selectImageType == 1) {
          imageCardID = File(imageFile.path);
        } else {
          imageLicense = File(imageFile.path);
        }
      });
    }
  }

  Future<void> getMediaFromDevice(int selectImageType) async {
    var imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        if (selectImageType == 0) {
          imageProfile = File(imageFile.path);
        } else if (selectImageType == 1) {
          imageCardID = File(imageFile.path);
        } else {
          imageLicense = File(imageFile.path);
        }
      });
    }
  }

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  );
  final enableBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  );
  final focusColor = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.main),
  );
  final errorColor = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.red),
  );

  final List<String> itemsColor = [
    'Blue',
    'Black',
    'Red',
    'Green',
    'Yellow',
    'Grey',
    'Pink',
  ];

  final List<String> itemsService = [
    'Rickshaw',
    'SUV Car',
    'Mini Van',
    'Classic',
  ];
}
