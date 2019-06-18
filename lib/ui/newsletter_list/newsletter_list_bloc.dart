import 'package:bloc/bloc.dart';
import 'package:newsletter_reader/data/repository/NewsletterRepository.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_event.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_state.dart';

class NewsletterListBloc extends Bloc<NewsletterListEvent, NewsletterListState>{
  NewsletterRepository _repository;

  NewsletterListBloc(this._repository);


  @override
  NewsletterListState get initialState => NewsletterListState.initial();

  @override
  Stream<NewsletterListState> mapEventToState(NewsletterListEvent event) async* {
    if(event is LoadNewsletterListEvent){
      yield new NewsletterListState.loading();

      var newsletters = await _repository.queryNewsletters();

      yield new NewsletterListState.loaded(newsletters);
    }
  }
}