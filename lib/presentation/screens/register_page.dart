import 'dart:io';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/data/models/vehical_model.dart';
import 'package:tara_driver_application/presentation/blocs/register_bloc.dart';
import 'package:tara_driver_application/presentation/blocs/vehical_bloc.dart';
import 'package:tara_driver_application/presentation/screens/drawer_screen.dart';
import 'package:tara_driver_application/presentation/widgets/card_atta_widget.dart';
import 'package:tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:tara_driver_application/presentation/widgets/x_button.dart';
import 'package:tara_driver_application/presentation/widgets/x_dropdown_search.dart';
import 'package:tara_driver_application/presentation/widgets/x_showmodal_bottom.dart';
import 'package:tara_driver_application/taxi_single_ton/taxi.dart';
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
  File? imageVehicle;

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
                  MaterialPageRoute(builder: (context) => DrawerScreen()));
            }
          },
          builder: (context, state) {
            bool isLoading = state is DriverRegisterLoading;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Container(
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
                                  height: 8,
                                ),
                                const Text(
                                  "Please fill out the information below to register for a new account.",
                                  style: ThemeConstands.font16Regular,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            "Full Name - ",
                                            style:
                                                ThemeConstands.font16SemiBold,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "ឈ្មោះពេញ",
                                            style:
                                                ThemeConstands.font16SemiBold,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        controller: controllerName,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.name,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.light3,
                                          hintText:
                                              "Enter Full Name - បញ្ចូលឈ្មោះពេញ",
                                          hintStyle: ThemeConstands
                                              .font16Regular
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
                                      const Row(
                                        children: [
                                          const Text(
                                            "Vehicle Type - ",
                                            style:
                                                ThemeConstands.font16SemiBold,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "ប្រភេទយានយន្ដ",
                                            style:
                                                ThemeConstands.font16SemiBold,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      BlocBuilder<VehicalBloc, VehicalState>(
                                        builder: (context, state) {
                                          if (state is VehicalLoaded) {
                                            return SizedBox(
                                              width: double.infinity,
                                              child: SearchableDropdown<
                                                  SingleVehical>(
                                                items: state.vehicalData.data,
                                                hintText:"Select Service type - ជ្រើសរើសប្រភេទយានយន្ដ",
                                                itemToString: (value) =>
                                                    value.name.toString(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    vehicalId = value.item?.id;
                                                  });
                                                },
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 22,
                                      ),
                                      const Row(
                                        children: [
                                          Text(
                                            "Select Color - ",
                                            style:
                                                ThemeConstands.font16SemiBold,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "ជ្រើសរើសពណ៍",
                                            style:
                                                ThemeConstands.font16SemiBold,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: SearchableDropdown<String>(
                                          items: itemsColor,
                                          hintText:
                                              "Select Vehicle Color - ជ្រើសរើសពណ៍យានយន្ដ",
                                          itemToString: (value) =>
                                              value.toString(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValueColor = value.item;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 22,
                                      ),
                                      const Text(
                                        "Plate Number - ផ្លាកលេខ",
                                        style: ThemeConstands.font16SemiBold,
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        controller: controllerPlate,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.light3,
                                          hintText: 'xxx-xxxx',
                                          hintStyle: ThemeConstands
                                              .font16Regular
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
                                        "Upload Attachment - ឯកសារភ្ជាប់",
                                        style: ThemeConstands.font16SemiBold,
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      // Driver License & ID Card
                                      SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CardUploadAttachment(
                                                  onPressedIcon: () {
                                                    setState(() {
                                                      imageLicense = null;
                                                    });
                                                  },
                                                  title: "Driver License",
                                                  image: imageLicense,
                                                  icon:
                                                      'assets/icon/svg/driver_license_icon.svg',
                                                  onPressed: () {
                                                    showModal(
                                                        selectImageType: 0);
                                                  },
                                                ),
                                                CardUploadAttachment(
                                                  onPressedIcon: () {
                                                    setState(() {
                                                      imageCardID = null;
                                                    });
                                                  },
                                                  title: "ID Card",
                                                  image: imageCardID,
                                                  icon:
                                                      'assets/icon/svg/id_card_icon.svg',
                                                  onPressed: () {
                                                    showModal(
                                                        selectImageType: 1);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Profile & Vehicle Image
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CardUploadAttachment(
                                                  onPressedIcon: () {
                                                    setState(() {
                                                      imageProfile = null;
                                                    });
                                                  },
                                                  title: "Profile",
                                                  image: imageProfile,
                                                  icon:
                                                      "assets/icon/svg/profile_icon.svg",
                                                  onPressed: () {
                                                    showModal(
                                                        selectImageType: 2);
                                                  },
                                                ),
                                                CardUploadAttachment(
                                                  onPressedIcon: () {
                                                    setState(() {
                                                      imageVehicle = null;
                                                    });
                                                  },
                                                  title: "Vehicle Image",
                                                  image: imageVehicle,
                                                  icon:
                                                      "assets/icon/svg/vehicle_icon.svg",
                                                  onPressed: () {
                                                    showModal(
                                                        selectImageType: 3);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 28,
                                      ),
                                      FBTNWidget(
                                        onPressed: controllerName.text == "" && controllerPlate.text == ""
                                            ? null
                                            : () {
                                                FocusScope.of(context).unfocus();
                                                tlog("Register Driver ${controllerName.text.toString()},Vehical ID: $vehicalId, Plate Number ${controllerPlate.text},profile: $imageProfile, cardId: $imageCardID, driver license: $imageLicense");

                                                BlocProvider.of<RegisterBloc>(context).add(
                                                  DriverRegisterEvent(
                                                    vechicleImage: imageVehicle!,
                                                    fullname: controllerName.text.toString(),
                                                    plateNumber: controllerPlate.text.toString(),
                                                    vehicalId: "$vehicalId",
                                                    vehicalColor:selectedValueColor !=null? '$selectedValueColor': "Unknown",
                                                    deviceToken: '9999',
                                                    cardImage: imageCardID!,
                                                    profileImage: imageProfile!,
                                                    driverLicenseImage:imageLicense!,
                                                  ),
                                                );
                                              },
                                        textColor: AppColors.light4,
                                        label: "Create - បង្កើត",
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

  void showModal({required int selectImageType}) async {
    xShowModalBottomSheet(
      initialChildSize: 0.2,
      maxChildSize: 1.0,
      minChildSize: 0.1,
      context: context,
      body: (context, scrollController) {
        return SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              XButton(
                onPress: () {
                  Navigator.pop(context);
                  getMediaFromDevice(selectImageType);
                },
                child: Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.light2,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Gallery\nរូបថត",
                        textAlign: TextAlign.center,
                        style: ThemeConstands.font16SemiBold,
                      ),
                    ],
                  ),
                ),
              ),
              XButton(
                onPress: () {
                  Navigator.pop(context);
                  getImageFromCamera(selectImageType);
                },
                child: Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.light2,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Take a Photo\nថតរូប",
                        textAlign: TextAlign.center,
                        style: ThemeConstands.font16SemiBold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImageFromCamera(int selectImageType) async {
    var imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        if (selectImageType == 0) {
          imageLicense = File(imageFile.path);
        } else if (selectImageType == 1) {
          imageCardID = File(imageFile.path);
        } else if (selectImageType == 2) {
          imageProfile = File(imageFile.path);
        } else {
          imageVehicle = File(imageFile.path);
        }
      });
    }
  }

  Future<void> getMediaFromDevice(int selectImageType) async {
    var imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        if (selectImageType == 0) {
          imageLicense = File(imageFile.path);
        } else if (selectImageType == 1) {
          imageCardID = File(imageFile.path);
        } else if (selectImageType == 2) {
          imageProfile = File(imageFile.path);
        } else {
          imageVehicle = File(imageFile.path);
        }
      });
    }
  }

  final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.dark1));
  final enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.dark1));
  final focusColor = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.main),
  );
  final errorColor = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.red),
  );

  final List<String> itemsColor = [
    'Blue - ខៀវ',
    'Black - ខ្មៅ',
    'Red - ក្រហម',
    'Green - បៃតង',
    'Yellow - លឿង',
    'Grey - ប្រផេះ',
    'Pink - ផ្កាឈូក',
  ];
}
