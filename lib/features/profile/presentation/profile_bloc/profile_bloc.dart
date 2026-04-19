import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/profile_repository.dart';
import '../../data/profile_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileCurrencyChanged>(_onCurrencyChanged);
    on<ProfileNotificationsToggled>(_onNotificationsToggled);
    on<ProfileLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _profileRepository.fetchProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onCurrencyChanged(
    ProfileCurrencyChanged event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).profile;
      final updated = current.copyWith(currency: event.currency);
      emit(ProfileLoaded(updated));
      await _profileRepository.updateCurrency(event.currency);
    }
  }

  Future<void> _onNotificationsToggled(
    ProfileNotificationsToggled event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).profile;
      final updated = current.copyWith(notificationsEnabled: event.enabled);
      emit(ProfileLoaded(updated));
      await _profileRepository.updateNotifications(event.enabled);
    }
  }

  Future<void> _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Logout is handled by AuthBloc - we just signal intent
  }
}
