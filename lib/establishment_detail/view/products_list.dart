import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/establishment_detail/cubit/products_list_cubit.dart';
import 'package:mikhuy/establishment_detail/view/add_product_to_cart.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:models/models.dart';

class ProductsList extends StatelessWidget {
  const ProductsList(this.establishment, {super.key});
  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsListCubit, ProductsListState>(
      builder: (context, state) {
        if (state.productsRequestStatus == RequestStatus.completed) {
          return _ProductsListView(state.products, establishment.id);
        }

        if (state.productsRequestStatus == RequestStatus.failed) {
          return Center(
            child: Column(
              children: [
                const Text('Ups! ha ocurrido un error inesperado :('),
                TextButton(
                  onPressed: () => context
                      .read<ProductsListCubit>()
                      .getProductsByEstablishment(establishment.id),
                  child: const Text('Reintentar'),
                )
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ProductsListView extends StatelessWidget {
  const _ProductsListView(this.products, this.establishmentID);
  final List<Product> products;
  final String establishmentID;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context
          .read<ProductsListCubit>()
          .getProductsByEstablishment(establishmentID),
      child: products.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _ProductsListItem(products[index]),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('No se encontraron resultados'),
                Text('🤦‍♂️'),
              ],
            ),
    );
  }
}

class _ProductsListItem extends StatelessWidget {
  const _ProductsListItem(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: AppColors.acadia.withOpacity(0.4),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 12, right: 2, bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: AppColors.grey.shade50,
                          ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${product.stock.toString()} disponible',
                      style: Theme.of(context).textTheme.overline!.copyWith(
                            color: AppColors.grey.shade50,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bs. ${product.price.toString()}',
                      style: Theme.of(context).textTheme.overline!.copyWith(
                            color: AppColors.grey.shade50,
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext _) {
                            return BlocProvider.value(
                              value: context.read<ProductsListCubit>(),
                              child: AddToCart(product),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        MdiIcons.plus,
                        color: AppColors.grey.shade50,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
