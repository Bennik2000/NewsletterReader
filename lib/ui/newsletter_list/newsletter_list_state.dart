import 'package:newsletter_reader/data/model/model.dart';

class NewsletterListState {
  bool isLoaded;
  bool isLoading;
  List<Newsletter> newsletters;

  NewsletterListState.initial() {
    isLoading = false;
    isLoaded = false;
    newsletters = new List();
  }

  NewsletterListState.loading(){
    isLoading = true;
    isLoaded = false;
    newsletters = new List();
  }

  NewsletterListState.loaded(this.newsletters){
    isLoaded = true;
    isLoading = false;
  }
}