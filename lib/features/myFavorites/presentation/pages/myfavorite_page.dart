import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/routing/routes.dart';
import 'package:edu_app/core/widgets/app_empty_view.dart';
import 'package:edu_app/core/widgets/app_error_view.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/features/my_favorites/data/repo/my_favorites_repo.dart';
import 'package:edu_app/features/my_favorites/presentation/cubit/my_favorites_cubit.dart';
import 'package:edu_app/features/my_favorites/presentation/widgets/my_favorite_card.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class MyfavoritePage extends StatelessWidget {
   final int refreshToken;

  const MyfavoritePage({super.key, this.refreshToken = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyFavoritesCubit(myfavoritesRepo: MyFavoritesRepo())
            ..getMyFavorites(),
      child: _MyfavoriteView(refreshToken: refreshToken),
    );
  }
}

class _MyfavoriteView extends StatefulWidget {
  final int refreshToken;

  const _MyfavoriteView({required this.refreshToken});

  @override
  State<_MyfavoriteView> createState() => _MyfavoriteViewState();
}

class _MyfavoriteViewState extends State<_MyfavoriteView> {
  @override
  void didUpdateWidget(covariant _MyfavoriteView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إعادة الجلب عند تغير العدّاد، أي كل مرة تُعرض فيها الصفحة
    if (widget.refreshToken != oldWidget.refreshToken) {
      context.read<MyFavoritesCubit>().getMyFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("المفضلة", style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: BlocConsumer<MyFavoritesCubit, MyFavoritesState>(
        listener: (context, state) {
          if (state is MyFavoritesStateFailure) {
            snackBarMessage(
              context: context,
              text: state.message,
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        },
        builder: (context, state) {
          if (state is MyFavoritesStateLoading) {
            return const AppLoadingView();
          }

          if (state is MyFavoritesStateFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<MyFavoritesCubit>().getMyFavorites(),
            );
          }

          if (state is MyFavoritesStateLoaded) {
            if (state.myFavorites.isEmpty) {
              return const AppEmptyView(message: "لا توجد كورسات في المفضلة");
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: state.myFavorites.length,
              itemBuilder: (BuildContext context, int index) {
                final myFavorite = state.myFavorites[index];
                return CustomMyFavorite(
                  title: myFavorite.title,
                  category: myFavorite.category.isEmpty
                      ? 'دورة'
                      : myFavorite.category,
                  imageUrl: myFavorite.image,
                  rating: myFavorite.rating,
                  price: '${myFavorite.price.toStringAsFixed(2)} EGP',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.courseDetails,
                      arguments: myFavorite,
                    );
                  },
                  onRemoveFavorite: () {
                    context.read<MyFavoritesCubit>().removeFromFavorites(
                      myFavorite.id,
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
