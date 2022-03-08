/*import 'package:dental_rescue/dentist/demo.dart';
import 'package:flutter/material.dart';

class Dentist_Home_Screen extends StatefulWidget {
  @override
  _Dentist_Home_ScreenState createState() => _Dentist_Home_ScreenState();
}

class _Dentist_Home_ScreenState extends State<Dentist_Home_Screen>
    with SingleTickerProviderStateMixin {
   TabController _controller;
List images=['images/pic1.jpg','images/pic2.jpg','images/pic4.png',];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Card(
          child: Container(

            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            // Adobe XD layer: 'Welcome' (text)
                            Text(
                              'Welcome               ',
                              style: TextStyle(
                                fontFamily: 'Noto Sans',
                                fontSize: 12,
                                color: const Color(0xff000000),
                                height: 1.5,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                            // Adobe XD layer: 'Dr. Nguyen' (text)
                            Scrollbar(
                              child: SingleChildScrollView(
                                child: Text(
                                  'Dr. Nguyen',
                                  style: TextStyle(
                                    fontFamily: 'Noto Sans',
                                    fontSize: 20,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('images/Mask Group.png'),
                      )

                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(

                  height: MediaQuery.of(context).size.height*0.5,
                  child:  DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      backgroundColor:  Colors.white,
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        iconTheme: IconThemeData(
                          color: Colors.black,
                        ),
                        toolbarHeight: MediaQuery.of(context).size.height*0.07,
                        bottom:  TabBar(
                          indicatorColor: Color(0xff7672c9),
                          controller: _controller,
                          tabs: [
                            Tab(child: // Adobe XD layer: 'Emergency (6)' (text)
                            Text(
                              'Emergency (6)',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                color: const Color(0xff7672c9),
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                              textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),),
                            Tab(child: // Adobe XD layer: 'Second Opinion' (text)
                            Text(
                              'Second Opinion',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                color: const Color(0xffa6a6a6),
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                              textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),),

                          ],
                        ),
                      ),
                      body:  TabBarView(
                        controller: _controller,
                        children: [
                          ListView.builder(
                              itemCount:3,
                              itemBuilder: (context,index){
                            return Container(
                              height: MediaQuery.of(context).size.height*0.14,
                              child: Row(

                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.1,
                                    width:   MediaQuery.of(context).size.height*0.12,
                                   child: Image.asset(images[index]),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Adobe XD layer: 'Jerome Bell' (text)
                                      Text(
                                        'Jerome Bell',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          color: const Color(0xff232323),
                                          fontWeight: FontWeight.w700,
                                          height: 1.5,
                                        ),
                                        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                                        textAlign: TextAlign.left,
                                      ),

                                      SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                      // Adobe XD layer: 'Photos' (text)
                                      Text(
                                        'Photos',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          color: const Color(0xff8c8c8c),
                                          height: 1.5,
                                        ),
                                        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                          Text(
                                            'Hi doc, please look at to my ...',
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 12,
                                              color: const Color(0xff232323),
                                              fontWeight: FontWeight.w700,
                                              height: 1.5,
                                            ),
                                            textHeightBehavior:
                                            TextHeightBehavior(applyHeightToFirstAscent: false),
                                            textAlign: TextAlign.left,
                                          ),

                                    ],
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                                  Column(
crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Adobe XD layer: '08.00 am' (text)
                                      Text(
                                        '08.00 am',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          color: const Color(0xff8c8c8c),
                                          height: 1.5,
                                        ),
                                        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                                        textAlign: TextAlign.left,
                                      ),
                            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                      Container(

                                          width: MediaQuery.of(context).size.width*0.06,
                                          height: MediaQuery.of(context).size.height*0.07,
                                          decoration: new BoxDecoration(
                                            color: Color(0xff7672c9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(child: Text("2",style: TextStyle(color: Colors.white),))
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                         Center(child: Text("No data"))

                        ],
                      ),
                    ),

                  )
                )




              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/