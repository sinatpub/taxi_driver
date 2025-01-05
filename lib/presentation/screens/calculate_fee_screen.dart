import 'package:com.tara_driver_application/data/datasources/confirm_booking_api.dart';
import 'package:com.tara_driver_application/data/models/complete_driver_model.dart';
import 'package:com.tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:com.tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';

import '../../data/models/current_driver_info_model.dart';

class CalculateFeeScreen extends StatefulWidget {
  final String routFrom ; //  "FromHome" or "FromDropBooking"
  final CompleteDriverModel? dataComplete;
  final DataDriverInfo? dataDriverInfo;
  final String startAddress;
  final String endAddress;
  const CalculateFeeScreen({super.key,required this.routFrom,this.dataDriverInfo,this.dataComplete,required this.endAddress,required this.startAddress});

  @override
  State<CalculateFeeScreen> createState() => _CalculateFeeScreenState();
}

class _CalculateFeeScreenState extends State<CalculateFeeScreen> {

 formartDate(String dateTime){
    var newStr = '${dateTime.substring(0,10)} ${dateTime.substring(11,23)}';
    DateTime dt = DateTime.parse(newStr);
    return DateFormat("EEE/d/MMM/yyyy - HH:mma").format(dt);
  }

  bool loadingCompletePay = false;
  
  
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light4,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child: Text("Calculate fee",style: ThemeConstands.font22SemiBold.copyWith(color:AppColors.dark1),),
              ),
              const Divider(height: 1,color: AppColors.light1,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                     widget.routFrom == "FromDropBooking"? bodyRecive(
                        profile: widget.dataComplete!.data!.passenger!.profileImage == null? 'https://via.placeholder.com/150':widget.dataComplete!.data!.passenger!.profileImage.toString(),
                        passagerName: widget.dataComplete!.data!.passenger!.name.toString(),
                        amount: "៛${widget.dataComplete!.data!.payment!.amount.toString()}",
                        createAt: widget.dataComplete!.data!.payment!.createdAt.toString(),
                        distance: widget.dataComplete!.data!.payment!.distance.toString(),
                        duration:  widget.dataComplete!.data!.payment!.duration.toString(),
                      ):
                      bodyRecive(
                        profile: widget.dataDriverInfo!.passenger!.profileImage == null? 'https://via.placeholder.com/150':widget.dataDriverInfo!.passenger!.profileImage.toString(),
                        passagerName: widget.dataDriverInfo!.passenger!.name.toString(),
                        amount: "៛${widget.dataDriverInfo!.payment!.amount.toString()}",
                        createAt: widget.dataDriverInfo!.payment!.createdAt.toString(),
                        distance: widget.dataDriverInfo!.payment!.distance.toString(),
                        duration:  widget.dataDriverInfo!.payment!.duration.toString(),
                      ),
                      const SizedBox(height: 18,),
                        FBTNWidget(
                          loadingBut: loadingCompletePay,
                          onPressed: ()async{
                            setState(() {
                              loadingCompletePay = true;
                            });
                              await BookingApi().completePayment(rideId: widget.routFrom == "FromDropBooking"? widget.dataComplete!.data!.id! :widget.dataDriverInfo!.passenger!.roleId!).then((onValue){
                                if(onValue == true){
                                  Taxi.shared.connectAndEmitEvent(
                                  eventName:"acceptPayment",
                                  data:{
                                      "booking_code": widget.routFrom == "FromDropBooking"?widget.dataComplete!.data!.bookingCode.toString() :  widget.dataDriverInfo!.bookingCode.toString(),
                                      "booking_id": widget.routFrom == "FromDropBooking"?widget.dataComplete!.data!.id.toString() :  widget.dataDriverInfo!.id.toString(),
                                      "passengerId": widget.routFrom == "FromDropBooking"?widget.dataComplete!.data!.passenger!.id.toString() :  widget.dataDriverInfo!.passenger!.id.toString(),
                                    },
                                  );
                                  setState(() {
                                    loadingCompletePay = false;
                                  });
                                  Navigator.pushAndRemoveUntil(context,PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => const NavScreen(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),(route) => false,
                                  );
                                }
                                else{
                                  setState(() {
                                    loadingCompletePay = false;
                                    showErrorCustomDialog(context, "Please Try Again!",
                                      "Please try again. Something went wrong.");
                                  });
                                }
                              });
                          },
                          width: 200,
                          color:AppColors.red,
                          textColor: AppColors.light4,
                          label: "Payment Done",
                          enableWidth: true,
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyRecive({
    required String profile,
    required String passagerName,
    required String createAt,
    required String duration,
    required String distance,
    required String amount,
  }){
    return Container(
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1,color: AppColors.light1),
      ),
      child: Column(
        children: [
          Container(
            padding:const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          NetworkImage(profile),
                      backgroundColor: Colors.transparent,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(passagerName,style: ThemeConstands.font20SemiBold.copyWith(color:AppColors.dark1),),
                            Text("Cash payment",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      child: Column(
                        children: [
                          Text("Payment",style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.red),),
                          Text("Collaction",style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.red),),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                          const SizedBox(width: 8,),
                          Text(distance,style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.dark1),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                          const SizedBox(width: 8,),
                          Text(duration,style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                          const SizedBox(width: 8,),
                          Text(amount,style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 18,),
                const Divider(
                  color: AppColors.light1,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date & Time",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                    const SizedBox(width: 8,),
                    Text(formartDate(createAt),style: ThemeConstands.font14SemiBold.copyWith(color:AppColors.dark1),),
                  ],
                ),
                const SizedBox(height: 18,),
                const Divider(
                  color: AppColors.light1,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 18,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.dark1,),
                        const SizedBox(width: 8,),
                        Expanded(child: Text(widget.startAddress,style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
                      ],
                    ),
                    Container(
                      margin:const EdgeInsets.only(left: 9),
                      alignment: Alignment.centerLeft,
                      child:const DottedLine(
                        alignment: WrapAlignment.start,
                        lineLength: 30,
                        direction: Axis.vertical,
                        lineThickness: 1,
                        dashColor: AppColors.dark1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                        const SizedBox(width: 8,),
                        Expanded(child: Text(widget.endAddress,style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18,),
          Container(
            padding:const EdgeInsets.all(14),
            decoration:const BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12))
            ),
            child: Row(
              children: [
                Expanded(child: Text("Total price:",style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.light4),textAlign: TextAlign.start,)),
                Expanded(child: Text(amount,style: ThemeConstands.font18SemiBold.copyWith(color:AppColors.light4),textAlign: TextAlign.end,)),
              ],
            )
          )
        ],
      ),
    );
  }
}