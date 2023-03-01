import 'dart:convert';
import 'package:api7/Model_Api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Partner? data;
  int index = 0;

  @override
  void initState() {
    postApi();
    super.initState();
  }

  Future<Partner?> postApi() async {
    String api = "https://coupinos-app.azurewebsites.net/partners/list";
    Map postBody = {
      "radius": 10,
      "pageSize": 25,
      "page": 0,
      "longitude": "",
      "latitude": ""
    };
    var body = json.encode(postBody);
    var result = await http.post(Uri.parse(api), body: body, headers: {
      'Content-type': 'application/json',
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjMxYWQxNDhlMGEyNjkwMDIzMWJiNTc5IiwiZW1haWwiOiJsZWFybnRlc3Q0MysxQGdtYWlsLmNvbSIsInJvbGUiOlsiUmVndWxhclVzZXIiXSwiZmlyc3ROYW1lIjoiSGFycnkiLCJsYXN0TmFtZSI6IlBvdHRlciIsImlzRGVmYXVsdEltYWdlIjp0cnVlLCJkZWZhdWx0SW1hZ2VQYXRoIjoiL3VzZXIvZGVmYXVsdEltYWdlcy80IiwiaWF0IjoxNjc3NjQ1OTQzLCJleHAiOjE2ODAyMzc5NDN9.MaiFy7_nbQT5TsNG2Kc49fKrAFSpjxzg8fJapffSXoo'
    });
    print(result);
    if (result.statusCode == 200) {
      final response = result.body;
      Map<String, dynamic> temp = jsonDecode(response);
      print(temp);
      final apicall = Partner.fromJson(temp);
      setState(() {
        data = apicall;
      });
      return data;
    } else {
      throw Exception("not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: data != null
            ? Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ListView.builder(
                      itemCount: data!.data!.partners!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                        child: Text(
                                             data!.data!.partners![index].name
                                                    .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20))),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          data!.data!.partners!.isNotEmpty
                                              ? data!.data!.partners![index].companyName
                                                  .toString()
                                              : "Empty",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      const SizedBox(width: 4),
                                      Text(
                                          data!.data!.partners!.isNotEmpty
                                              ? data!
                                                  .data!.partners![index].email
                                                  .toString()
                                              : "Empty",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      Text(
                                          data!.data!.partners!.isNotEmpty
                                              ? data!.data!.partners![index]
                                                  .partnerId
                                                  .toString()
                                              : "Empty",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text(
                                          data!.data!.partners!.isNotEmpty
                                              ? data!.data!.partners![index]
                                                  .statusS
                                                  .toString()
                                              : "Empty",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  )),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
