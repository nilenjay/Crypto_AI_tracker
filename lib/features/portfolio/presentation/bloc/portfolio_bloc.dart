import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/data/market_api_service.dart';
import '../../data/models/portfolio_item.dart';
import '../../data/repositories/portfolio_repository.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository _portfolioRepository;
  final MarketApiService _marketApiService;
  StreamSubscription? _portfolioSubscription;

  PortfolioBloc({
    required PortfolioRepository portfolioRepository,
    required MarketApiService marketApiService,
  })  : _portfolioRepository = portfolioRepository,
        _marketApiService = marketApiService,
        super(const PortfolioState()) {
    on<PortfolioSubscriptionRequested>(_onSubscriptionRequested);
    on<AddHoldingRequested>(_onAddHolding);
    on<RemoveHoldingRequested>(_onRemoveHolding);
    on<_InternalUpdateItems>(_onInternalUpdate);
    on<_InternalErrorOccurred>(_onInternalError);
  }

  Future<void> _onSubscriptionRequested(
    PortfolioSubscriptionRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));

    await _portfolioSubscription?.cancel();
    _portfolioSubscription = _portfolioRepository.getPortfolioStream().listen(
      (items) async {
        print('Portfolio updated: ${items.length} items found');
        // When items update, fetch current prices for each
        final Map<String, double> prices = {};
        for (final item in items) {
          try {
            final coinPrice = await _marketApiService.getCoinPrice(item.coinId);
            prices[item.coinId] = coinPrice.priceUsd;
          } catch (e) {
             print('Error fetching price for ${item.coinId}: $e');
          }
        }
        
        if (!isClosed) {
          add(_InternalUpdateItems(items, prices));
        }
      },
      onError: (error) {
        print('Portfolio Stream Error: $error');
        if (!isClosed) {
           add(_InternalErrorOccurred(error.toString()));
        }
      },
    );
  }

  void _onInternalError(_InternalErrorOccurred event, Emitter<PortfolioState> emit) {
    emit(state.copyWith(status: PortfolioStatus.error, errorMessage: event.error));
  }

  // Internal event to update state from stream listener
  void _onInternalUpdate(_InternalUpdateItems event, Emitter<PortfolioState> emit) {
    emit(state.copyWith(
      status: PortfolioStatus.success,
      items: event.items,
      currentPrices: event.prices,
    ));
  }

  Future<void> _onAddHolding(AddHoldingRequested event, Emitter<PortfolioState> emit) async {
    try {
      print('Adding holding: ${event.item.coinId}');
      await _portfolioRepository.addOrUpdateHolding(event.item);
    } catch (e) {
      print('Add holding error: $e');
      emit(state.copyWith(status: PortfolioStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onRemoveHolding(RemoveHoldingRequested event, Emitter<PortfolioState> emit) async {
    try {
      print('Removing holding: ${event.coinId}');
      await _portfolioRepository.removeHolding(event.coinId);
    } catch (e) {
      print('Remove holding error: $e');
      emit(state.copyWith(status: PortfolioStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _portfolioSubscription?.cancel();
    return super.close();
  }
}

// Internal helper events
class _InternalUpdateItems extends PortfolioEvent {
  final List<PortfolioItem> items;
  final Map<String, double> prices;
  _InternalUpdateItems(this.items, this.prices);

  @override
  List<Object> get props => [items, prices];
}

class _InternalErrorOccurred extends PortfolioEvent {
  final String error;
  _InternalErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}
