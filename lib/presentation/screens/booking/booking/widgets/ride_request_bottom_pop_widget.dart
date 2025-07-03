import 'package:tara_driver_application/app/funtion_convert.dart';
import 'package:tara_driver_application/core/resources/asset_resource.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:tara_driver_application/presentation/screens/booking/booking/bloc/booking_bloc.dart';
import 'package:tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:tara_driver_application/presentation/widgets/t_image_widget.dart';
import 'package:tara_driver_application/presentation/widgets/yesno_dialog_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:url_launcher/url_launcher.dart';

class ModelBottomSheetNewRequestWidget extends StatefulWidget {
  final String bookingId;
  final int processType;
  final String profilePassanger;
  final String namePassanger;
  final String phonePassanger;
  final String currentLocationName;
  final String passegerLocationName;
  final String whereToGoLocationName;
  final double distandTotal;
  final String totalFee;
  final VoidCallback onTap;
  const ModelBottomSheetNewRequestWidget({super.key,required this.distandTotal,required this.totalFee,required this.bookingId,required this.namePassanger,required this.phonePassanger,required this.profilePassanger,required this.onTap,required this.processType,required this.currentLocationName,required this.whereToGoLocationName,required this.passegerLocationName});

  @override
  State<ModelBottomSheetNewRequestWidget> createState() => _ModelBottomSheetNewRequestWidgetState();
}

class _ModelBottomSheetNewRequestWidgetState extends State<ModelBottomSheetNewRequestWidget> {

  bool isExpanded = true;

  Future<void> _launchLink(String url) async {
    if (await launchUrl(Uri.parse(url))) {
    }else{
      await launchUrl(Uri.parse(url),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,left: 0,right: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.2)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
          child: Column(
            children: [
              ExpansionTile(
                collapsedBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                shape: const Border(),
                initiallyExpanded: true,
                title: Text(
                  widget.processType == 1?"HAVE_BOOKING".tr(): widget.processType == 2? "GO_TO_PASSENGER".tr(): widget.processType == 3? "PREPAIR_TO_GO".tr():"CARRYING_PASSENGER".tr(),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: AppColors.main,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    isExpanded = expanded;
                  });
                },
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TImageWidget(
                          image: NetworkImage(widget.profilePassanger.toString()),
                          width: 50,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.namePassanger.toString(),style: ThemeConstands.font20SemiBold.copyWith(color:AppColors.dark1),),
                              Text("${"MOBILENUM".tr()} ${widget.phonePassanger}",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          _launchLink("tel:${widget.phonePassanger}");
                        }, 
                        icon: const Icon(Icons.phone_outlined,size: 24,color: AppColors.error,)
                      ),
                    ],
                  ),
                  const SizedBox(height: 6,),
                  const Divider(
                    thickness: 0.5,
                    color: AppColors.light1,
                  ),
                  const SizedBox(height: 6,),
                  Container(
                    padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.light4,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            blurStyle: BlurStyle.normal,
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(5, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(ImageAssets.current_location,width: 22,color: AppColors.dark1,),
                              const SizedBox(width: 8,),
                              Expanded(child: Text(widget.processType == 1? "${"PASSENGER_LOCATION".tr()}: (${widget.passegerLocationName.toString()})":"${widget.processType== 3 || widget.processType == 4? "កន្លែងចាប់ផ្ដើម":"DRIVER_LOCATION".tr()}: (${widget.currentLocationName.toString()})",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
                            ],
                          ),
                          widget.processType != 2 && widget.whereToGoLocationName ==""?const SizedBox(): widget.processType == 1?const SizedBox():Container(
                            margin:const EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child:const DottedLine(
                              alignment: WrapAlignment.start,
                              lineLength: 30,
                              direction: Axis.vertical,
                              lineThickness: 1,
                              dashColor: AppColors.dark1,
                            ),
                          ),
                          widget.processType != 2 && widget.whereToGoLocationName ==""?const SizedBox(): widget.processType == 1?const SizedBox():Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                              const SizedBox(width: 8,),
                              Expanded(child: Text(widget.processType == 2?"${"PASSENGER_LOCATION".tr()}: (${widget.passegerLocationName.toString()})": "${ widget.processType== 3 || widget.processType == 4 && widget.whereToGoLocationName != ""?"កន្លែងដែរត្រូវទៅ".tr():"PASSENGER_LOCATION".tr()}: (${widget.whereToGoLocationName.toString()})",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
                            ],
                          ),
                          const SizedBox(height: 18,),
                          widget.processType == 2 || widget.whereToGoLocationName =="" ||widget.processType == 1 ?const SizedBox():Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(ImageAssets.map_outline,width: 20,color: AppColors.red,),
                              const SizedBox(width: 8,),
                              Expanded(child: Row(
                                children: [
                                  Expanded(child: Text(formatDistanceWithUnits(widget.distandTotal.toString(),context),style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),textAlign: TextAlign.start,)),
                                  Expanded(child: Text("៛${formatToTwoDecimalPlaces(widget.totalFee.toString())}",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),textAlign: TextAlign.end,)),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ),
              const SizedBox(height: 16,),
              widget.processType == 4? 
              Container(
                padding:const EdgeInsets.symmetric(horizontal: 18,),
                child: FBTNWidget(
                  onPressed:widget.onTap,
                  color: AppColors.main,
                  textColor: AppColors.light4,
                  label:"DROP".tr(),
                  enableWidth: true,
                  // enableWidth: false,
                ),
              )
              : Container(
                margin:const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: FBTNWidget(
                        onPressed: () {
                          showYesNoCustomDialog(context:  context,title: "CANCEL_BOOK".tr(),
                            description: "CONTANCT_CELCEL_BOOK".tr(),
                            onYes: () {
                              Taxi.shared.connectAndEmitEvent(
                                eventName: "driverCancelDrive",
                              );
                            BlocProvider.of<BookingBloc>(context).add(
                              CanceBookingEvent(
                                rideId: int.parse(widget.bookingId),
                              ),
                            );
                          });
                        },
                        color: AppColors.dark1,
                        textColor: AppColors.light4,
                        label: "CANCEL".tr(),
                        enableWidth: true,
                      ),
                    ),
                    const SizedBox(width: 18,),
                    Expanded(
                      flex: 2,
                      child: FBTNWidget(
                        onPressed:widget.onTap,
                        color: AppColors.main,
                        textColor: AppColors.light4,
                        label: widget.processType == 1?"ACCEPT".tr(): widget.processType == 2? "ARRIVE".tr():widget.processType == 3?"START_RIDE".tr():"",
                        enableWidth: true,
                        // enableWidth: false,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 14,),
            ],
          ),
        ),
      ),
    );
  }
}