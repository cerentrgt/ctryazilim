import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/ChatPage/ChatListPage.dart';
import 'package:kapsul_teknoloji/screens/DestekPage/DestekPage.dart';
import 'package:kapsul_teknoloji/screens/Profil/ProfileScreen.dart';
import 'package:kapsul_teknoloji/screens/Project/ProjectList.dart';
import 'package:kapsul_teknoloji/screens/RaporPage/RaporListPage.dart';
import 'package:kapsul_teknoloji/screens/RaporPage/RaporUserList.dart';
import '../../service/UserService.dart';
import '../Advertisement_duyurular/AdvertiList.dart';
import '../DestekPage/DestekListPage.dart';
import '../Mesai/Mesai.dart';
import '../Mesai/MesaiSearch/MesaiSearch.dart';
import '../PermissionPage/PermissionBus/PermissionBusList.dart';
import '../PermissionPage/UserPermission/PermissionList.dart';

class ButtonHomePage extends StatefulWidget {
  const ButtonHomePage({super.key});

  @override
  State<ButtonHomePage> createState() => _ButtonHomePageState();
}

class _ButtonHomePageState extends State<ButtonHomePage> {
  var userMail = FirebaseAuth.instance.currentUser!.email;
  var auth = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  var userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUserList(),
    );
  }

  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('Person')
          .where('uid', isEqualTo: auth!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }

        return buildUserListItem(snapshot);
      },
    );
  }

  ListView buildUserListItem(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data?.docs.length ?? 0,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        DocumentSnapshot data = snapshot.data!.docs[index];
        String fullName = data['name'] + " " + data['surName'];
        String photoUrl = data['image'];
        if (data['department'] == "yönetici") {
          auth!.updateDisplayName(fullName);
          auth!.updatePhotoURL(photoUrl);

          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 248,
                        decoration: BoxDecoration(
                          color: Color(0xff0d0b28),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(83),
                            bottomLeft: Radius.circular(82),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data['image']),
                                radius: 45,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        const ProfileScreen()),
                                  ),
                                );
                              },
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(fullName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white)),
                            ),
                          ],
                        )),
                    const SizedBox(height: 30),
                    Container(
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200),
                              topRight: Radius.circular(200)),
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(left: 24, right: 24),
                          crossAxisCount: 2,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 30,
                          children: [
                            itemDashboard('Chat', "assets/icons/chat_icon.png",
                                ChatListPage()),
                            itemDashboard(
                                'İzin Talepleri',
                                "assets/icons/permission_icon.png",
                                PermissionBusList()),
                            itemDashboard('Raporlar',
                                "assets/icons/rapor_icon.png", RaporUserList()),
                            itemDashboard('Mesai Saatlerim',
                                "assets/icons/mesai_icon.png", Mesai()),
                            itemDashboard(
                                'Mesai Ara',
                                "assets/icons/mesaiSearch_icon.png",
                                MesaiSearch()),
                            itemDashboard('Projeler',
                                "assets/icons/project_icon.png", ProjectList()),
                            itemDashboard('Duyurular',
                                "assets/icons/adverti_icon.png", AdvertiList()),
                            itemDashboard(
                                'Destek-Talep-Şikayet',
                                "assets/icons/destek_icon.png",
                                DestekListPage()),
                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          auth!.updateDisplayName(fullName);
          auth!.updatePhotoURL(photoUrl);
          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 248,
                        decoration: BoxDecoration(
                          color: Color(0xff0d0b28),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(83),
                            bottomLeft: Radius.circular(82),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data['image']),
                                radius: 45,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ProfileScreen())));
                              },
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(fullName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white)),
                            ),
                          ],
                        )),
                    const SizedBox(height: 30),
                    Container(
                      color: Colors.white,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(200),
                                topRight: Radius.circular(200)),
                          ),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: 24, right: 24),
                            crossAxisCount: 2,
                            crossAxisSpacing: 40,
                            mainAxisSpacing: 30,
                            children: [
                              itemDashboard('Chat',
                                  "assets/icons/chat_icon.png", ChatListPage()),
                              itemDashboard(
                                  'Raporlarım',
                                  "assets/icons/rapor_icon.png",
                                  RaporListPage()),
                              itemDashboard('Mesai Saatlerim',
                                  "assets/icons/mesai_icon.png", Mesai()),
                              itemDashboard(
                                  'Mesai Ara',
                                  "assets/icons/mesaiSearch_icon.png",
                                  MesaiSearch()),
                              itemDashboard(
                                  'Projeler',
                                  "assets/icons/project_icon.png",
                                  ProjectList()),
                              itemDashboard(
                                  'Duyurular',
                                  "assets/icons/adverti_icon.png",
                                  AdvertiList()),
                              itemDashboard(
                                  'İzin Taleplerim',
                                  "assets/icons/permission_icon.png",
                                  PermissionList()),
                              itemDashboard('Destek-Talep-Şikayet',
                                  "assets/icons/destek_icon.png", DestekPage()),
                              SizedBox(
                                height: 1,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  itemDashboard(String title, String iconData, Widget onPressed) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              width: 200,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, elevation: 0),
                child: Image.asset(
                  iconData,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => onPressed));
                },
              )),
          const SizedBox(height: 8),
          Expanded(
            child: FittedBox(
              child: TextButton(
                child: Text(title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => onPressed));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
