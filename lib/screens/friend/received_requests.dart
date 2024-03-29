import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/friend_service.dart';

class ReceivedRequests extends StatefulWidget {
  const ReceivedRequests({Key? key}) : super(key: key);
  _ReceivedRequestsState createState() => _ReceivedRequestsState();
}

class _ReceivedRequestsState extends State<ReceivedRequests> {
  List<Map<String, String?>> requests = [];

  String email = "";
  String avatar = "";
  String username = "";
  bool isLoading = true;

  void showSnackBar(bool success, [String message = "Unknown error occurred."]) {
    final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor: (success = true) ? Colors.green[800] : Colors.red[800]);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getFriendRequests() async {
    List response = await FriendService.getReceivedFriendRequests();
    if (response[0] == true) {
      setState(() {
        requests = response[1];
      });
    } else {
      showSnackBar(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> acceptRequest(String username) async {
    List response = await FriendService.acceptFriendRequest(username);
    if (response[0] == true) {
      showSnackBar(response[0], response[1]);
      setState(() {
        List<Map<String, String?>> temp = [];
        requests.forEach((user) {
          if (user["username"] != username) {
            temp.add(
                {"email": user["email"] ?? "", "username": user["username"] ?? "", "avatar": user["avatar"] ?? ""});
          }
        });
        requests = temp;
      });
    } else {
      showSnackBar(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> cancelRequest(String uname) async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await FriendService.deleteFriendRequest(uname, false);
      showSnackBar(response[0], response[1]);
    } catch (id) {
      setState(() {
        isLoading = false;
      });
    }
    getFriendRequests();
  }

  @override
  void initState() {
    super.initState();
    getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      children: (() {
                      if (requests.length == 0) {
                        return [Padding(padding: EdgeInsets.all(20), child: Text("No any friend requests in pending"))];
                      } else {
                        return requests.map((user) {
                          return Container(
                              width: double.maxFinite,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(),
                                  color: Colors.blue[50],
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: [
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: Text(user["username"]?[0].toUpperCase() ?? ""),
                                                foregroundImage: NetworkImage(user["avatar"] ?? "")),
                                            SizedBox(width: 5),
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(user["username"] ?? ""),
                                              Text(user["email"] ?? ""),
                                            ])
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Divider(
                                          height: 10,
                                          thickness: 2,
                                          indent: 0,
                                          endIndent: 0,
                                          color: Colors.grey[400],
                                        ),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                iconSize: 32,
                                                icon: const Icon(Icons.check),
                                                color: Colors.green,
                                                onPressed: () {
                                                  print("accept req");
                                                  acceptRequest(user["username"] ?? "");
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              IconButton(
                                                iconSize: 32,
                                                icon: const Icon(Icons.close),
                                                color: Colors.red,
                                                onPressed: () {
                                                  cancelRequest(user["username"] ?? "");
                                                },
                                              ),
                                            ]),
                                      ]))));
                        }).toList();
                      }
                    }())));
        }));
  }
}
