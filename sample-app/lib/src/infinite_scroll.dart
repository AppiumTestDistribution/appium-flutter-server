import 'package:flutter/material.dart';
import 'package:form_app/src/infinite_scroll/api/item.dart';
import 'package:form_app/src/infinite_scroll/catalog.dart';
import 'package:form_app/src/infinite_scroll/item_tile.dart';
import 'package:provider/provider.dart';

class InfiniteScrollDemo extends StatefulWidget {
  const InfiniteScrollDemo({super.key});

  @override
  State<InfiniteScrollDemo> createState() => _InfiniteScrollDemoState();
}

class _InfiniteScrollDemoState extends State<InfiniteScrollDemo> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Catalog>(
      create: (context) => Catalog(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Infinite List Sample'),
        ),
        body: Selector<Catalog, int?>(
          // Selector is a widget from package:provider. It allows us to listen
          // to only one aspect of a provided value. In this case, we are only
          // listening to the catalog's `itemCount`, because that's all we need
          // at this level.
          selector: (context, catalog) => catalog.itemCount,
          builder: (context, itemCount, child) => ListView.builder(
            // When `itemCount` is null, `ListView` assumes an infinite list.
            // Once we provide a value, it will stop the scrolling beyond
            // the last element.
            itemCount: itemCount,
            padding: const EdgeInsets.symmetric(vertical: 18),
            itemBuilder: (context, index) {
              // Every item of the `ListView` is individually listening
              // to the catalog.
              var catalog = Provider.of<Catalog>(context);

              // Catalog provides a single synchronous method for getting the
              // current data.
              return switch (catalog.getByIndex(index)) {
                Item(isLoading: true) => const LoadingItemTile(),
                var item => ItemTile(item: item)
              };
            },
          ),
        ),
      ),
    );
  }
}
