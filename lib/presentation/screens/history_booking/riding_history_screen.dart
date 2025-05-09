import 'package:com.tara_driver_application/presentation/screens/history_booking/state/history_book_bloc.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  late HistoryBookBloc historyBookBloc;
  ScrollController scrollController = ScrollController();
  int indexActive = 0;
  formartDate(String dateTime){
    var newStr = '${dateTime.substring(0,10)} ${dateTime.substring(11,23)}';
    DateTime dt = DateTime.parse(newStr);
    return DateFormat("EEE/d/MMM/yyyy - HH:mm").format(dt);
  }
  Future<void> _onRefresh() async {
    if(indexActive == 0){
      historyBookBloc.add(RefreshPaginatedData());
    }
    else{
      historyBookBloc.add(RefreshPaginatedCancelData());
    }
  }
  @override
  void initState() {
    super.initState();
    historyBookBloc = HistoryBookBloc(status: indexActive == 0?4:5);
    historyBookBloc.add(FetchPaginatedData());
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        historyBookBloc.add(FetchPaginatedData());
      }
    });
  }
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
                      historyBookBloc = HistoryBookBloc(status: indexActive == 0?4:5);
                        historyBookBloc.add(FetchPaginatedData());
                        scrollController.addListener(() {
                          if (scrollController.position.pixels ==
                              scrollController.position.maxScrollExtent) {
                            historyBookBloc.add(FetchPaginatedData());
                          }
                        });
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
                      historyBookBloc = HistoryBookBloc(status: indexActive == 0?4:5);
                      historyBookBloc.add(FetchPaginatedData());
                      scrollController.addListener(() {
                        if (scrollController.position.pixels ==
                            scrollController.position.maxScrollExtent) {
                          historyBookBloc.add(FetchPaginatedData());
                        }
                      });
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
          child: BlocBuilder<HistoryBookBloc, HistoryBookState>(
            bloc: historyBookBloc,
            builder: (context, state) {
              if (state is HistoryBookLoading && historyBookBloc.allItems.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HistoryBookError) {
                return Center(child: Text(state.message));
              } else if (state is HistoryBookLoaded) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index < state.items.length) {
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
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage:
                                        NetworkImage(state.items[index].passenger!.profileImage.toString()),
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
                                              Text("In voice ID: #${state.items[index].payment!.invoiceId}",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark2),textAlign: TextAlign.start,),
                                              Text(state.items[index].statusName.toString(),style: ThemeConstands.font14SemiBold.copyWith(color:state.items[index].status==4?AppColors.success:AppColors.dark2),textAlign: TextAlign.end,),
                                            ],
                                          ),
                                          Text(state.items[index].passenger!.name.toString(),style: ThemeConstands.font20SemiBold.copyWith(color:AppColors.dark1),),
                                          Text(state.items[index].payment!.paymentMethod.toString(),style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
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
                                        Text(state.items[index].payment!.distance.toString(),style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.dark1),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                                        const SizedBox(width: 8,),
                                        Text(state.items[index].status == 4?state.items[index].payment!.duration.toString():"------",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
                                        const SizedBox(width: 8,),
                                        Text("៛${state.items[index].payment!.amount.toString()}",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
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
                                  Text(state.items[index].status == 4?"${DateFormat("yyyy-MM-dd h:mm a").format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(state.items[index].startTime))} - ${DateFormat("yyyy-MM-dd h:mm a").format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(state.items[index].endTime))}":"----",style: ThemeConstands.font14SemiBold.copyWith(color:AppColors.dark1),),
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
                                      Expanded(child: Text( state.items[index].status == 4?state.items[index].startAddress.toString():"------",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
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
                                      Expanded(child: Text(state.items[index].status == 4?state.items[index].endAddress.toString():"------",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              }
              return Container();
            },
          ),
         
          // child: ListView.builder(
          //   padding:const EdgeInsets.only(bottom: 30),
          //   itemCount: 4,
          //   itemBuilder: (context, index) {
          //     return Container(
          //       padding:const EdgeInsets.all(18),
          //       margin: const EdgeInsets.only(left: 18,right: 18,top: 18),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(12),
          //         border: Border.all(width: 1,color: AppColors.light1),
          //       ),
          //       child: Column(
          //         children: [
          //           Row(
          //             children: [
          //               const CircleAvatar(
          //                 radius: 30.0,
          //                 backgroundImage:
          //                     NetworkImage('https://via.placeholder.com/150'),
          //                 backgroundColor: Colors.transparent,
          //               ),
          //               Expanded(
          //                 child: Container(
          //                   alignment: Alignment.centerLeft,
          //                   margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Text("In voice ID: #09754",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark2),textAlign: TextAlign.start,),
          //                           Text("Completed",style: ThemeConstands.font14SemiBold.copyWith(color:AppColors.success),textAlign: TextAlign.end,),
          //                         ],
          //                       ),
          //                       Text("Sinat Non",style: ThemeConstands.font20SemiBold.copyWith(color:AppColors.dark1),),
          //                       Text("Cash payment",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const SizedBox(height: 12,),
          //           Row(
          //             children: [
          //               Expanded(
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: [
          //                     SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
          //                     const SizedBox(width: 8,),
          //                     Text("5 Km",style: ThemeConstands.font16SemiBold.copyWith(color:AppColors.dark1),),
          //                   ],
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
          //                     const SizedBox(width: 8,),
          //                     Text("13:00 Mins",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
          //                   ],
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.end,
          //                   children: [
          //                     SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
          //                     const SizedBox(width: 8,),
          //                     Text("\$12.0",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //           const SizedBox(height: 18,),
          //           const Divider(
          //             color: AppColors.light1,
          //             thickness: 1,
          //             height: 1,
          //           ),
          //           const SizedBox(height: 18,),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text("Date & Time",style: ThemeConstands.font14Regular.copyWith(color:AppColors.dark1),),
          //               const SizedBox(width: 8,),
          //               Text("1/Aug/2024 - 12:45PM",style: ThemeConstands.font14SemiBold.copyWith(color:AppColors.dark1),),
          //             ],
          //           ),
          //           const SizedBox(height: 18,),
          //           const Divider(
          //             color: AppColors.light1,
          //             thickness: 1,
          //             height: 1,
          //           ),
          //           const SizedBox(height: 18,),
          //           Column(
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.dark1,),
          //                   const SizedBox(width: 8,),
          //                   Expanded(child: Text("Current location passager stand",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
          //                 ],
          //               ),
          //               Container(
          //                 margin:const EdgeInsets.only(left: 9),
          //                 alignment: Alignment.centerLeft,
          //                 child:const DottedLine(
          //                   alignment: WrapAlignment.start,
          //                   lineLength: 30,
          //                   direction: Axis.vertical,
          //                   lineThickness: 1,
          //                   dashColor: AppColors.dark1,
          //                 ),
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   SvgPicture.asset(ImageAssets.book_outline,width: 20,color: AppColors.red,),
          //                   const SizedBox(width: 8,),
          //                   Expanded(child: Text("1901 Tul Kok",style: ThemeConstands.font16Regular.copyWith(color:AppColors.dark1),)),
          //                 ],
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     );
          //   },
          // )
        
        )
      ],
    );
  }
}