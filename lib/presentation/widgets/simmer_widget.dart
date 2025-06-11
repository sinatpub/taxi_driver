import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade200,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    width: 150,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade200,
                      child: Container(
                        height: 10,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: Shimmer.fromColors(
                      baseColor: AppColors.light3,
                      highlightColor: AppColors.light1,
                      child: Container(
                        height: 10,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
                    
  }
}

class ShimmerBookStory extends StatelessWidget {
  const ShimmerBookStory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index)  {
        return Container(
          padding:const EdgeInsets.all(18),
          margin: const EdgeInsets.only(left: 18,right: 18,top: 18),
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
              SizedBox(
                height: 140,
                child: Shimmer.fromColors(
                  baseColor: AppColors.light3,
                  highlightColor: AppColors.light1,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
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
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: Shimmer.fromColors(
                      baseColor: AppColors.light3,
                      highlightColor: AppColors.light1,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: Shimmer.fromColors(
                      baseColor: AppColors.light3,
                      highlightColor: AppColors.light1,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18,),
              const Divider(
                color: AppColors.light1,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 18,),
              SizedBox(
                height: 30,
                child: Shimmer.fromColors(
                  baseColor: AppColors.light3,
                  highlightColor: AppColors.light1,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18,),
              SizedBox(
                height: 30,
                child: Shimmer.fromColors(
                  baseColor: AppColors.light3,
                  highlightColor: AppColors.light1,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}