part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileCurrencyChanged extends ProfileEvent {
  final String currency;
  const ProfileCurrencyChanged(this.currency);
}

class ProfileNotificationsToggled extends ProfileEvent {
  final bool enabled;
  const ProfileNotificationsToggled(this.enabled);
}

class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}
