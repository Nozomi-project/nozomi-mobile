import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/home/cubit/establishment_list_cubit.dart';
import 'package:mikhuy/home/view/establishments_list_panel.dart';
import 'package:mikhuy/home/view/establishments_search_bar.dart';
import 'package:mikhuy/home/view/google_maps_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<EstablishmentListCubit>(
          create: (context) => EstablishmentListCubit()
            ..verifyLocationPermission()
            ..getEstablisments(),
          child: const _HomeView(),
        ),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const GoogleMapsBuilder(),
        AnimatedPositioned(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          left:
              context.watch<EstablishmentListCubit>().state.showMapOnFullscreen
                  ? -MediaQuery.of(context).size.width
                  : 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.ease,
          child: Column(
            children: const [
              EstablishmentsSearchBar(),
              Expanded(
                child: EstablishmentsListPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
