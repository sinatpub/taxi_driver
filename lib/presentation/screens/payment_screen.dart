import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  
  int bankSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light4,
      body: SafeArea(
        bottom: false,
        child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Row(
                 children: [
                   IconButton(
                     onPressed:(){
                       Navigator.of(context).pop();
                     } , 
                     padding:const EdgeInsets.all(0),
                     icon:const Icon(Icons.arrow_back_ios_new_rounded,size: 22,)
                   ),
                   Text("Payment",style: ThemeConstands.font22SemiBold.copyWith(color:AppColors.dark1),),
                 ],
               ),
               MaterialButton(
                 height: 30,
                 minWidth: 30,
                 color: AppColors.dark4,
                 onPressed: (){}, 
                 padding:const EdgeInsets.all(0),
                 shape:RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(6)
                 ),
                 child: const Icon(Icons.rotate_left,size: 22,),
               ),
             ],
           ),
           const Divider(height: 1,color: AppColors.light1,),
           Expanded(
             child: SingleChildScrollView(
               child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                 child: Column(
                   children: [
                     Container(
                       decoration:const BoxDecoration(
                         color: AppColors.light4,
                         borderRadius: BorderRadius.all(Radius.circular(12)),
                         boxShadow: [
                             BoxShadow(
                               color:Color(0xFFDEDADA),
                               spreadRadius: 2,
                               blurRadius: 5,
                               offset: Offset(1, 1),
                             ),
                           ],
                       ),
                       child: Container(
                         margin: const EdgeInsets.symmetric(vertical: 18,horizontal: 18),
                         child: Column(
                           children: [
                             Text("Total commission fee",style: ThemeConstands.font18SemiBold.copyWith(color:AppColors.main),textAlign: TextAlign.center,),
                             const SizedBox(height: 40,),
                             Row(
                               children: [
                                 Expanded(
                                   child: Text("-\$20",style: ThemeConstands.font28SemiBold.copyWith(color:AppColors.main),textAlign: TextAlign.center,)
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                     const SizedBox(height: 28,),
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text("Payment option",style: ThemeConstands.font18SemiBold.copyWith(color:AppColors.main),textAlign: TextAlign.left,)
                      ),
                    const SizedBox(height: 22,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardBank(ImageAssets.date_time,bankSelected == 1?true:false,(){setState(() {bankSelected = 1;});}),
                        cardBank(ImageAssets.date_time,bankSelected == 2?true:false,(){setState(() {bankSelected = 2;});}),
                        cardBank(ImageAssets.date_time,bankSelected == 3?true:false,(){setState(() {bankSelected = 3;});}),
                      ],
                    ),
                    const SizedBox(height: 22,),
                    FBTNWidget(
                      onPressed: (){},
                      color:AppColors.red,
                      textColor: AppColors.light4,
                      label: "Get payment now",
                      enableWidth: true,
                    )
                   ],
                 ),
               ),
             ),
           )
         ]
        ),
      ),
    );
  }
  Widget cardBank (String image,bool ationSelect,VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: AppColors.light4,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ationSelect == true?AppColors.red:AppColors.light3),
          boxShadow: const[
            BoxShadow(
              color:Color(0xFFDEDADA),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,left: 12,right: 12,bottom: 12,
              child: SvgPicture.asset(image)
            ),
            ationSelect == false?const SizedBox():Positioned(
              top: 10,right: 10,
              child: Container(
                padding:const EdgeInsets.all(5),
                decoration:const BoxDecoration(
                  color:AppColors.light4,
                  shape: BoxShape.circle,
                ),
                child:const Icon(Icons.check,size: 22,color: AppColors.red,),
              ),
            )
          ],
        ),
      ),
    );
  }
}