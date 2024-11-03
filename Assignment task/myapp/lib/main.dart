import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Assignment work'),
        ),
        body: Container(
          child: Center(
            child: Container(
              width: 500,
              height: 400,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(250),
              ),
              child: Center(
                child: Container(
                  width: 550,
                  height: 400,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(800),
                  ),
                  child: Center(
                    child: Container(
                      width: 600,
                      height: 350,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(500)),
                      child: Container(
                        width: 500,
                        height: 400,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(250),
                        ),
                        child: Container(
                          width: 30,
                          height: 300,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(150),
                          ),
                          child: Container(
                            width: 300,
                            height: 300,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(150),
                            ),
                            child: Container(
                              width: 300,
                              height: 300,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent,
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: Container(
                                width: 300,
                                height: 300,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(150),
                                ),
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
