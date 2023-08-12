import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/home/cubit/establishment_list_cubit.dart';
import 'package:mikhuy/home/view/establishments_list.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EstablishmentsListPanel extends StatelessWidget {
  const EstablishmentsListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      color: Colors.transparent,
      minHeight: MediaQuery.of(context).size.height * 0.25,
      maxHeight: MediaQuery.of(context).size.height,
      parallaxEnabled: true,
      panel: const DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: AppColors.white,
        ),
        child: _PanelContent(),
      ),
    );
  }
}

class _PanelContent extends StatelessWidget {
  const _PanelContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Align(
          child: Container(
            width: 52,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.grey.shade500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Establecimientos cercanos',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppColors.grey.shade900),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.blueMalibu.shade100,
          ),
          child: Row(
            children: [
              Icon(
                MdiIcons.information,
                size: 16,
                color: AppColors.acadia,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Sólo se listan establecimientos con productos disponibles',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: AppColors.grey.shade900),
                ),
              ),
            ],
          ),
        ),
        BlocProvider<EstablishmentListCubit>.value(
          value: context.read<EstablishmentListCubit>(),
          child: const EstablishmentsList(),
        ),
      ],
    );
  }
}
