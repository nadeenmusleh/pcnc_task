import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pcnc_task/product.dart';
import 'dart:convert';
import 'category.dart';
import 'full_image_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Future<List<dynamic>>? futureResults;

  @override
  void initState() {
    super.initState();
    futureResults = fetchCombinedResults('');
  }

  Future<List<dynamic>> fetchCombinedResults(String query) async {
    List<dynamic> results = [];

    // Fetch Categories
    final categoriesResponse =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/categories'));
    if (categoriesResponse.statusCode == 200) {
      List jsonResponse = json.decode(categoriesResponse.body);
      List<Category> allCategories =
          jsonResponse.map((category) => Category.fromJson(category)).toList();
      if (query.isNotEmpty) {
        allCategories = allCategories
            .where((category) =>
                category.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      results.addAll(allCategories);
    }
    //fetch prodycts
    final productsResponse =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));
    if (productsResponse.statusCode == 200) {
      List jsonResponse = json.decode(productsResponse.body);
      List<Product> allProducts =
          jsonResponse.map((product) => Product.fromJson(product)).toList();
      if (query.isNotEmpty) {
        allProducts = allProducts
            .where((product) =>
                product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      results.addAll(allProducts);
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFDFDFD),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.08,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Color(0xFF323232)),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontFamily: 'Libre Caslon Text',
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF2673B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Color(0xFFBBBBBB)),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: screenWidth * 0.05,
                      color: Color(0xFFBBBBBB),
                    ),
                    hintText: 'type here to find anything...',
                    hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      futureResults = fetchCombinedResults(value);
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              FutureBuilder<List<dynamic>>(
                future: futureResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load results'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/no_results.png',
                            height: screenHeight * 0.3,
                          ),
                          Text(
                            'Oops!!!\nNo results found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final results = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (screenWidth < 600) ? 2 : 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: results.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (results[index] is Category) {
                          final category = results[index] as Category;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FullImageScreen(imageUrl: category.image),
                                ),
                              );
                            },
                            child: buildCategoryCard(
                                category, screenWidth, screenHeight),
                          );
                        } else if (results[index] is Product) {
                          final product = results[index] as Product;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullImageScreen(
                                      imageUrl: product.images[0]),
                                ),
                              );
                            },
                            child: buildProductCard(
                                product, screenWidth, screenHeight),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryCard(
      Category category, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: DecorationImage(
                image: NetworkImage(category.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              category.name,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(
      Product product, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: DecorationImage(
                image: NetworkImage(
                    product.images.isNotEmpty ? product.images[0] : ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              product.title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
