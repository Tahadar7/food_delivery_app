import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_api/youtube_api.dart';
import '../blocs/VideoPageBloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/universal_variables.dart';
import 'package:food_delivery_app/screens/VideoPlayerPage.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';

class VideoSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoPageBloc(),
      child: VideoSearch(),
    );
  }
}

class VideoSearch extends StatefulWidget {
  @override
  State<VideoSearch> createState() => _VideoSearchState();
}

class _VideoSearchState extends State<VideoSearch> {
  static String key = dotenv.env['YOUTUBE_API_KEY'] ?? '';
  YoutubeAPI youtube = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];
  bool isLoading = true;

  final TextEditingController searchCtrl = TextEditingController();
  late VideoPageBloc videoPageBloc;

  Future<void> callAPI() async {
    setState(() => isLoading = true);

    videoResult = await youtube.search(
      "Food Reviews",
      order: 'relevance',
      videoDuration: 'any',
    );
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    videoPageBloc = Provider.of<VideoPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
        title: Row(
          children: [
            Icon(Icons.play_circle_filled, color: Colors.red, size: 30),
            SizedBox(width: 5),
            Text(
              "FoodTube",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.withValues(alpha: 0.3),
            backgroundImage: const AssetImage("assets/icon.png"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          createSearchBar(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: videoResult.length,
                    itemBuilder: (context, index) =>
                        listItem(videoResult[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(videoId: video.id ?? ""),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              image: DecorationImage(
                image: NetworkImage(video.thumbnail.high.url ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  video.channelTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: searchCtrl,
              onSubmitted: (val) async {
                setState(() => isLoading = true);
                videoResult = await youtube.search(val);
                setState(() => isLoading = false);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search food videos...",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: UniversalVariables.orangeColor),
            onPressed: () async {
              setState(() => isLoading = true);
              videoResult = await youtube.search(searchCtrl.text);
              setState(() => isLoading = false);
            },
          ),
        ],
      ),
    );
  }
}
