// ignore_for_file: avoid_print

import 'package:film_rater/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => FilmProvider(),
    ),
  ], child: const FilmRater()));
}

class FilmRater extends StatefulWidget {
  const FilmRater({super.key});

  @override
  State<FilmRater> createState() => _FilmRaterState();
}

class _FilmRaterState extends State<FilmRater> {
  final formKey = GlobalKey<FormState>();
  var searchData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<FilmProvider>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 8,
          centerTitle: true,
          title: const Text(
            "Film Rater",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: SizedBox(
                height: screenHeight * 0.09,
                child: SearchBar(
                  controller: searchData,
                  hintText: "search a movie",
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        String searchContent = searchData.text.trim();
                        print("button clicked:value=>$searchContent");
                        provider.getFilms(searchContent);
                      },
                      child: const Icon(Icons.search),

                      
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            Expanded(
              child: Consumer<FilmProvider>(builder: (context, data, _) {
                return Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: screenHeight * 0.6,
                      child: ListView(
                          children: data.searchFilms.isNotEmpty
                              ? List.generate(data.searchFilms.length, (index) {
                                  return Column(
                                    children: [
                                      Image(
                                          image: NetworkImage(
                                              data.searchFilms[index].Poster)),
                                      Text(data.searchFilms[index].Title),
                                      Text(data.searchFilms[index].Type),
                                      Text(data.searchFilms[index].Year),
                                      Text(data.searchFilms[index].imdbID)
                                    ],
                                  );
                                })
                              : [
                                  const Text(
                                    "No data",
                                    textAlign: TextAlign.center,
                                  )
                                ]),
                    )
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

// Future<List<Film>> getFilms(String film) async{
//   final response = await http
//   .get(Uri.parse("http://www.omdbapi.com/?s=$film&apikey=6636da1b"));
//   print("response: ${response.statusCode}");
//   List<dynamic> filmList = jsonDecode(response.body)["search"];
//   List<Film> tempFilms=[];
//   for( var filmMap in filmList){
//     Film film=Film.fromMap(filmMap);
//     tempFilms.add(film);
//   }
//   return tempFilms;
// }


