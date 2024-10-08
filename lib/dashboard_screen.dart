import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:pcnc_task/full_image_screen.dart';
import 'package:pcnc_task/search_sceen.dart';
import 'dart:convert';
import 'category.dart';
import 'product.dart';
import 'categories_screen.dart';
import 'login_screen.dart';
import 'services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  Future<List<Category>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void _logout(BuildContext context) async {
    final success = await AuthService().logout();
    if (success) {
      Get.offAll(() => LoginPage());
    } else {
      print('Logout failed. Please try again.');
    }
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35.45,
                    height: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/image.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'PCNC',
                    style: TextStyle(
                      fontFamily: 'Libre Caslon Text',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF2673B),
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('images/user_profile.jpeg'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80,
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF2673B),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await AuthService().logout();
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              buildSearchBar(),
              SizedBox(height: 20),
              buildCategoriesHeader(context),
              SizedBox(height: 20),
              buildCategoryCircles(),
              SizedBox(height: 20),
              buildProductSection(),
              SizedBox(height: 20),
              buildTrendingProductsSection(),
              SizedBox(height: 20),
              buildMoreProductsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  // Widget to build the search bar
  Widget buildSearchBar() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFBBBBBB)),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Color(0xFFBBBBBB),
          ),
          hintText: 'Search any Product...',
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFBBBBBB),
          ),
        ),
      ),
    );
  }

  // Widget to build the header for categories
  Widget buildCategoriesHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Categories',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllCategoriesScreen(),
              ),
            );
          },
          child: Container(
            width: 57,
            height: 24,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(1, 1),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'See All',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryCircles() {
    return FutureBuilder<List<Category>>(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load categories'));
        } else {
          final categories = snapshot.data!.take(3).toList();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: categories.map((category) {
              return Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(category.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget buildProductSection() {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load products'));
        } else {
          final products = snapshot.data!.take(4).toList();
          return Column(
            children: [
              Container(
                height: 241,
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: buildProductCard(products[0], context)),
                    SizedBox(width: 12),
                    Expanded(child: buildProductCard(products[1], context)),
                  ],
                ),
              ),
              Container(
                height: 241,
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: buildProductCard(products[2], context)),
                    SizedBox(width: 12),
                    Expanded(child: buildProductCard(products[3], context)),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

// Widget to build a single product card
  Widget buildProductCard(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullImageScreen(imageUrl: product.images[0]),
          ),
        );
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Product image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                image: DecorationImage(
                  image: NetworkImage(product.images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 24,
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.bookmark_border,
                              color: Colors.black,
                              size: 24,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the trending products section
  Widget buildTrendingProductsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF2673B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Last Date 29/02/22',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              children: [
                Text(
                  'View all',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMoreProductsSection() {
    return Container(
      width: 458,
      height: 186,
      child: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load products'));
          } else {
            final products = snapshot.data!.take(10).toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return buildProductsection(context, products[index]);
              },
            );
          }
        },
      ),
    );
  }

// Widget to build a single product card for More Products section
  Widget buildProductsection(BuildContext context, Product product) {
    return Container(
      width: 142,
      height: 186,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FullImageScreen(imageUrl: product.images[0]),
                  ),
                );
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(product.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.6,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

// Widget to build the bottom navigation bar
  Widget buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: 465,
      height: 65,
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 10,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.5),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1D000000),
                    blurRadius: 14,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildBottomNavItem(Icons.home, 'Home', Color(0xFFEB3030), true),
              buildBottomNavItem(
                  Icons.favorite, 'Wishlist', Colors.black, false),
              SizedBox(width: 56),
              GestureDetector(
                onTap: () {
                  Get.to(() => SearchScreen());
                },
                child: buildBottomNavItem(
                    Icons.search, 'Search', Colors.black, false),
              ),
              buildBottomNavItem(
                  Icons.settings, 'Settings', Colors.black, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavItem(
      IconData icon, String label, Color color, bool isHome) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: isHome ? Colors.white : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              child: Icon(
                icon,
                color: isHome ? color : Colors.black,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                color: isHome ? color : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
