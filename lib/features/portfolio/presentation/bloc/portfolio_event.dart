import 'package:equatable/equatable.dart';
import '../../data/models/portfolio_item.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class PortfolioSubscriptionRequested extends PortfolioEvent {}

class AddHoldingRequested extends PortfolioEvent {
  final PortfolioItem item;
  const AddHoldingRequested(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveHoldingRequested extends PortfolioEvent {
  final String coinId;
  const RemoveHoldingRequested(this.coinId);

  @override
  List<Object> get props => [coinId];
}
