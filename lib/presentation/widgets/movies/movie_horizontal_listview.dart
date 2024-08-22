import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        if (widget.loadNextPage == null) return;

        if (scrollController.position.pixels + 200 >=
            scrollController.position.maxScrollExtent) {
          widget.loadNextPage!();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.movies.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      FadeInRight(child: _Slide(movie: widget.movies[index])))),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Imagen
          SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.posterPath,
                    fit: BoxFit.cover,
                    width: 150,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress != null
                            ? Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)))
                            : GestureDetector(
                              onTap: () => context.push('/home/0/movie/${movie.id}'),
                              child: FadeIn(child: child)
                            )),
              )),

          const SizedBox(height: 5),
          //* Title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textTheme.titleSmall,
            ),
          ),

          //* Rating
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.star_half_outlined,
                  color: Colors.yellow.shade800,
                ),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    HumanFormats.number(movie.voteAverage, 2),
                    style: textTheme.bodyMedium!
                        .copyWith(color: Colors.yellow.shade800),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 10,),
                  child: Row(children: [
                    const Icon(Icons.thumb_up_off_alt_rounded, color: Colors.blue, size: 20,),
                    const SizedBox(width: 4,),
                    Text(HumanFormats.number(movie.popularity,3),
                        style: textTheme.bodySmall),
                  ]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: textTheme.titleLarge,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              onPressed: () {},
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}
