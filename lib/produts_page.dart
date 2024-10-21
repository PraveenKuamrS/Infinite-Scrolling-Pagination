import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scrolling_pagination/models/product_model.dart';

class PrductsPage extends StatefulWidget {
  const PrductsPage({super.key});

  @override
  State<PrductsPage> createState() => _PrductsPageState();
}

class _PrductsPageState extends State<PrductsPage> {
  List Products = [];
  final Dio dio = Dio();
  int totalProduts = 1000;
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
    scrollController.addListener(loadMore);
  }

  @override
  void dispose() {
    scrollController
        .dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          itemCount: Products.length,
          itemBuilder: (context, index) {
            final product = Products[index];
            return Column(
              children: [
                ListTile(
                  title: Text(
                    product.title!,
                  ),
                  subtitle: Text(
                    product.price!.toString(),
                  ),
                  leading: Text(
                    product.id!.toString(),
                  ),
                  trailing: Image.network(product.thumbnail!),
                ),
                if (index == Products.length - 1 && isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: SpinKitFadingCircle(
                      color: Color.fromARGB(255, 218, 88, 88),
                      size: 50,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    ));
  }

  void loadMore() {
    print(scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        Products.length < totalProduts);
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        Products.length < totalProduts) {
      print('API HIT AGAIN');
      setState(() {
        isLoading = true;
      });
      getProducts();
    }
  }

  Future<void> getProducts() async {
    // if (isLoading) return; // Prevent multiple simultaneous API calls

    setState(() {
      isLoading = true;
    });

    try {
      final response = await dio.get(
          'https://dummyjson.com/products?limit=15&skip=${Products.length}&select=title,price,thumbnail');

      if (response.data['products'] != null) {
        final List data = response.data['products'];
        final List<Product> newProducts =
            data.map((p) => Product.fromJson(p)).toList();

        setState(() {
          totalProduts = response.data['total'];
          Products.addAll(newProducts);
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
