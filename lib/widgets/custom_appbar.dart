import 'package:flutter/material.dart';
import 'package:fluttify/providers/shopping_list_provider.dart';
import 'package:fluttify/widgets/user_management_dialog.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({super.key});

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.read<ShoppingListProvider>().listTitle),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${context.watch<ShoppingListProvider>().totalPrice} zł',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => UserManagementDialog(),
          ),
          icon: const Icon(Icons.manage_accounts),
        ),
      ],
    );
  }
}
