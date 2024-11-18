import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';

class CalculateFeeScreen extends StatefulWidget {
  const CalculateFeeScreen({super.key});

  @override
  State<CalculateFeeScreen> createState() => _CalculateFeeScreenState();
}

class _CalculateFeeScreenState extends State<CalculateFeeScreen> {
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
                      Container(
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
                                      const CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage:
                                            NetworkImage('https://via.placeholder.com/150'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Sinat Non",style: ThemeConstands.font20SemiBold.copyWith(color:AppColors.dark1),),
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
                                            Text("5 Km",style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.dark1),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                                            const SizedBox(width: 8,),
                                            Text("13:00 Mins",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                                            const SizedBox(width: 8,),
                                            Text("\$12.0",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
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
                                      Text("1/Aug/2024 - 12:45PM",style: ThemeConstands.font14SemiBold.copyWith(color:AppColors.dark1),),
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
                                          Expanded(child: Text("Current location passager stand",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
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
                                          Expanded(child: Text("1901 Tul Kok",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
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
                                  Expanded(child: Text("\$12.0",style: ThemeConstands.font18SemiBold.copyWith(color:AppColors.light4),textAlign: TextAlign.end,)),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 18,),
                        FBTNWidget(
                          onPressed: (){},
                          color:AppColors.dark2,
                          textColor: AppColors.light4,
                          label: "Back to home",
                          enableWidth: false,
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
}