import 'package:meta/meta.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterEditState {
  final Newsletter newsletter;
  final NewsletterEditErrorState errorState;

  NewsletterEditState({@required this.newsletter, @required this.errorState});
}

class NewsletterEditErrorState {
  String nameError;
  String urlError;
  String updateStrategyError;
  String updateIntervalError;

  bool get hasError =>
      (nameError?.isNotEmpty ?? false) ||
      (urlError?.isNotEmpty ?? false) ||
      (updateStrategyError?.isNotEmpty ?? false) ||
      (updateIntervalError?.isNotEmpty ?? false);
}

class NewsletterEditFinishedState extends NewsletterEditState {
  NewsletterEditFinishedState({@required Newsletter newsletter, @required NewsletterEditErrorState errorState})
      : super(newsletter: newsletter, errorState: errorState);
}
