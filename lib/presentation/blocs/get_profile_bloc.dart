// Define the states

import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/get_profile_api.dart';
import 'package:com.tara_driver_application/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events
abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

// State
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profileData;

  ProfileLoaded(this.profileData);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDriver getProfileDriver = GetProfileDriver();
  bool _profileFetched = false; 

  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      if (_profileFetched) return;

      try {
        emit(ProfileLoading());
        final profileData = await getProfileDriver.getDriverProfileApi();
        _profileFetched = true;
        emit(ProfileLoaded(profileData));

        tlog("Get-Profile $profileData");
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
