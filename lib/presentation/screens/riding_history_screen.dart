import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';

class RidingHistoryScreen extends StatefulWidget {
  const RidingHistoryScreen({super.key});

  @override
  State<RidingHistoryScreen> createState() => _RidingHistoryScreenState();
}

class _RidingHistoryScreenState extends State<RidingHistoryScreen> {
  int indexActive = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Text("Riding History",style: ThemeConstands.font22SemiBold.copyWith(color:AppColors.dark1),),
        ),
        const Divider(height: 1,color: AppColors.light1,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      indexActive = 0;
                    });
                  }, 
                  child: Text("Complet",style: ThemeConstands.font16SemiBold.copyWith(color:indexActive== 1?AppColors.dark2: AppColors.red,),),
                ),
                Container(
                  width: 100,
                  height: 4,
                  decoration:BoxDecoration(
                    color: indexActive== 1?Colors.transparent: AppColors.red,
                    borderRadius:const BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3))
                  ),
                )
              ],
            ),
            const SizedBox(width: 22,),
            Column(
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      indexActive = 1;
                    });
                  }, 
                  child: Text("Cancel",style: ThemeConstands.font16SemiBold.copyWith(color:indexActive == 0?AppColors.dark2: AppColors.red,),),
                ),
                Container(
                  width: 100,
                  height: 4,
                  decoration:BoxDecoration(
                    color: indexActive== 0?Colors.transparent: AppColors.red,
                    borderRadius:const BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3))
                  ),
                )
              ],
            ),
          ],
        ),
        const Divider(height: 1,color: AppColors.light1,),
        Expanded(
          child: ListView.builder(
            padding:const EdgeInsets.only(bottom: 30),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                padding:const EdgeInsets.all(18),
                margin: const EdgeInsets.only(left: 18,right: 18,top: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1,color: AppColors.light1),
                ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("In voice ID: #09754",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark2),textAlign: TextAlign.start,),
                                    Text("Completed",style: ThemeConstands.font14SemiBold.copyWith(color:AppColors.success),textAlign: TextAlign.end,),
                                  ],
                                ),
                                Text("Sinat Non",style: ThemeConstands.font20SemiBold.copyWith(color:AppColors.dark1),),
                                Text("Cash payment",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                              ],
                            ),
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
                    )
                  ],
                ),
              );
            },
          )
        )
      ],
    );
  }
}