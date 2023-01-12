import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/establishment_detail/cubit/products_list_cubit.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:mikhuy/theme/app_theme.dart';
import 'package:models/models.dart';

class AddToCart extends StatefulWidget {
  const AddToCart(this._product, {super.key});
  final Product _product;

  @override
  State<StatefulWidget> createState() => _AddToCart();
}

class _AddToCart extends State<AddToCart> {
  int _counter = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.grey.shade500,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Agregar al carrito',
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget._product.name,
                  style: Theme.of(context).textTheme.headline1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.grey.shade100,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (canDecreaseQuantity(_counter)) _counter--;
                        });
                      },
                      icon: const Icon(
                        MdiIcons.minus,
                        color: AppColors.acadia,
                      ),
                    ),
                    Text('$_counter'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (canIncreaseQuantity(
                            _counter,
                            widget._product.stock,
                          )) _counter++;
                        });
                      },
                      icon: const Icon(
                        MdiIcons.plus,
                        color: AppColors.acadia,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Bs ${widget._product.price}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                child: ElevatedButton(
                  key: const Key('Cancel_AddProduct_ToCar_flatButton'),
                  onPressed: () => Navigator.of(context).pop(false),
                  style: AppTheme.secondaryButton,
                  child: const Text('CANCELAR'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  key: const Key('AddProduct_ToCar_flatButton'),
                  onPressed: () {
                    context
                        .read<ProductsListCubit>()
                        .addToCart(widget._product, _counter);
                    Navigator.of(context).pop(true);
                  },
                  style: AppTheme.secondaryButton,
                  child: const Text('AGREGAR AL CARRITO'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  bool canDecreaseQuantity(int counter) {
    if (counter != 1 || counter > 1) return true;
    return false;
  }

  bool canIncreaseQuantity(int counter, int stock) {
    return counter < stock;
  }
}
