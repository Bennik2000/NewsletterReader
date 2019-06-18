import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_bloc.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_state.dart';
import 'package:newsletter_reader/ui/widget/MaxSizeIcon.dart';

typedef NewsletterTapCallback = void Function(Newsletter newsletter);

class NewsletterList extends StatelessWidget {
  final NewsletterTapCallback onNewsletterTap;
  final NewsletterTapCallback onLongPress;

  const NewsletterList({Key key, this.onNewsletterTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<NewsletterListBloc>(context),
      builder: (BuildContext context, NewsletterListState state) {
        if (state.isLoading || !state.isLoaded) {
          return buildLoadingIndicator();
        }

        if (state.isLoaded && state.newsletters.isNotEmpty) {
          return buildNewsletterList(state.newsletters);
        }

        if (state.isLoaded && state.newsletters.isEmpty) {
          return buildEmptyState();
        }
      },
    );
  }

  Widget buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget buildNewsletterList(List<Newsletter> newsletters) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _NewsletterCardWidget(
          newsletter: newsletters[index],
          onTap: (newsletter) {
            onNewsletterTap(newsletter);
          },
          onLongPress: onLongPress,
        );
      },
      itemCount: newsletters.length,
    );
  }

  Widget buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(64, 128, 64, 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Hier gibt es leider noch keine Newsletter zu sehen. Füge einen neuen Newsletter mit + hinzu"),
        ],
      ),
    );
  }
}

class _NewsletterCardWidget extends StatelessWidget {
  final Newsletter newsletter;
  final NewsletterTapCallback onTap;
  final NewsletterTapCallback onLongPress;

  const _NewsletterCardWidget({Key key, this.newsletter, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onTap(newsletter);
        },
        onLongPress: () {
          onLongPress(newsletter);
        },
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: MaxSizeIcon(Icons.import_contacts),
                  height: 40,
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          newsletter.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
