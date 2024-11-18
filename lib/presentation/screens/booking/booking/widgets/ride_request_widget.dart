// import 'package:com.tara_driver_application/core/theme/colors.dart';
// import 'package:com.tara_driver_application/core/theme/text_styles.dart';
// import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class RideRequestWidget extends StatelessWidget {
//   const RideRequestWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return    Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 2.2,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.withOpacity(.2)),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(28),
//                       topRight: Radius.circular(28),
//                     ),
//                     color: Colors.white,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Text(
//                               "Ride Request",
//                               style: AppTextStyles.body
//                                   .copyWith(fontWeight: FontWeight.w700),
//                             ),
//                           ),
//                           const Divider(
//                             thickness: .1,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Row(
//                               children: [
//                                 const CircleAvatar(
//                                   radius: 24,
//                                 ),
//                                 const SizedBox(
//                                   width: 18,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Passenger",
//                                       style: AppTextStyles.body.copyWith(
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     const SizedBox(
//                                       height: 4,
//                                     ),
//                                     Text(
//                                       "Cash Payment",
//                                       style: AppTextStyles.bodyDark.copyWith(
//                                           color: Colors.grey,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(
//                             thickness: .1,
//                           ),
//                           Card(
//                             color: Colors.white,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Left column with icons
//                                   SizedBox(
//                                     width: 30,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         // Icon(Icons.location_city, size: 18),
//                                         SvgPicture.asset(
//                                             "assets/icon/svg/current_location.svg",
//                                             width: 32,
//                                             height: 32,
//                                             fit: BoxFit.cover),
//                                         const SizedBox(
//                                             height:
//                                                 40), // Spacer alternative to creatNe space between icons
//                                         SvgPicture.asset(
//                                             "assets/icon/svg/bxs_map.svg",
//                                             width: 32,
//                                             height: 32,
//                                             fit: BoxFit.cover),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 18),

//                                   // Right column with location texts
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // Top location text
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Current Location Passenger",
//                                               style: AppTextStyles.bodyDark
//                                                   .copyWith(
//                                                 color: AppColors.dark3,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             Text(
//                                               "${widget.lat} - ${widget.lng}",
//                                               style: AppTextStyles.bodyDark
//                                                   .copyWith(
//                                                 color: AppColors.dark1,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                               maxLines: 3,
//                                             ),
//                                           ],
//                                         ),
//                                         // Bottom destination text
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Destination Location",
//                                               style: AppTextStyles.bodyDark
//                                                   .copyWith(
//                                                 color: AppColors.dark3,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             Text(
//                                               "${widget.desLat} - ${widget.desLng}",
//                                               style: AppTextStyles.bodyDark
//                                                   .copyWith(
//                                                 color: AppColors.dark1,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 FBTNWidget(
//                                   onPressed: () {
//                                     BlocProvider.of<BookingBloc>(context).add(
//                                       CanceBookingEvent(
//                                           rideId: int.parse(widget.bookingId)),
//                                     );
//                                   },
//                                   color: AppColors.dark1,
//                                   textColor: AppColors.light4,
//                                   label: "Cancel",
//                                   enableWidth: false,
//                                 ),
//                                 const Spacer(),
//                                 isConfirmBooking == false
//                                     ? Expanded(
//                                         child: FBTNWidget(
//                                           onPressed: () {
//                                             _turnRight();
//                                             BlocProvider.of<BookingBloc>(
//                                                     context)
//                                                 .add(
//                                               ConfirmBookingEvent(
//                                                 rideId:
//                                                     int.parse(widget.bookingId),
//                                                 driverId: AppConstant.driverId,
//                                                 bookingCode: widget.bookingId,
//                                                 passengerId: widget.passengerId,
//                                                 currentLat: widget.lat,
//                                                 currentLng: widget.lng,
//                                                 destinationLng: widget.desLat,
//                                                 destinationLat: widget.desLng,
//                                               ),
//                                             );
//                                           },
//                                           color: AppColors.main,
//                                           textColor: AppColors.light4,
//                                           label: "Accept",
//                                           enableWidth: false,
//                                         ),
//                                       )
//                                     : Expanded(
//                                         child: FBTNWidget(
//                                           onPressed: () {},
//                                           color: AppColors.main,
//                                           textColor: AppColors.light4,
//                                           label: "Arrived Passenger",
//                                           enableWidth: true,
//                                           width: 400,
//                                         ),
//                                       ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
           
//   }
// }