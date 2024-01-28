import 'package:flutter/material.dart';
import 'package:news_app/remote_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/news_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = '--Your news Api Key--';
  late Future<List<NewsArticle>> _futureNews;
  @override
  void initState() {
    super.initState();
    final NewsApi newsApi = NewsApi(apiKey);
    _futureNews = newsApi.getTopHeadlines();
  }

  void launcherUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    launcherUrl(snapshot.data![index].url);
                  },
                  title: Text(snapshot.data![index].title),
                  subtitle: Column(
                    children: [
                      Text(snapshot.data![index].description),
                      const Divider(
                        color: Colors.black,
                      )
                    ],
                  ),
                  leading: Image.network(snapshot.data![index].imageUrl),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No News Available'),
            );
          }
        },
      ),
    );
  }
}
