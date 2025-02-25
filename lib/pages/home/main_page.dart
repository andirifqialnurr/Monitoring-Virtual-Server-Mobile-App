import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/page_provider.dart';
import 'package:shoes_app/theme/const.dart';

import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget cardButton() {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/host');
        },
        backgroundColor: secondaryColor,
        shape: const CircleBorder(),
        child: Image.asset(
          'assets/bottom_bar_icon/Host Icon.png',
          width: 20,
        ),
      );
    }

    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ProfilePage();
        default:
          return const HomePage();
      }
    }

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: BottomAppBar(
          height: 60,
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: BottomNavigationBar(
              elevation: 0,
              currentIndex: pageProvider.currentIndex,
              backgroundColor: Colors.transparent, // Pastikan transparan
              selectedFontSize: 0, // Hilangkan teks default
              unselectedFontSize: 0, // Hilangkan teks default
              onTap: (value) {
                pageProvider.currentIndex = value;
              },
              type: BottomNavigationBarType.fixed,  
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Image.asset(
                      'assets/bottom_bar_icon/Home.png',
                      width: 20,
                      height: 20,
                      color: pageProvider.currentIndex == 0
                          ? primaryColor
                          : secondaryBottomBarColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      'assets/bottom_bar_icon/Profile.png',
                      width: 20,
                      height: 20,
                      color: pageProvider.currentIndex == 1
                          ? primaryColor
                          : secondaryBottomBarColor,
                    ),
                  ),
                  label: '',
                ),
              ]),
        ),
      );
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: pageProvider.currentIndex == 0 ? bg1Color : bg3Color,
      floatingActionButton: cardButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
