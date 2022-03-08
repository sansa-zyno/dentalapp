import 'package:flutter/material.dart';

class About_Screen extends StatelessWidget {
  static const routename = "About_Screen";
  const About_Screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Dr. Nguyen",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ListView(
            children: [
              SizedBox(height: 15),
              Text(
                'Dr. Nguyen is part of the Central Ohio tradition of great dental care and comfort. He has dedicated his professional career to providing you with the best that dentistry has to offer. He is continually educating himself and his staff on the newest dental techniques and approaches in order to provide you with state-of-the-art, comfortable, personalized, and antiseptic dental care.',
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                  'Dr. Nguyen believes that with his outstanding education and training, he has formed the foundation which enables him to treat all your dental needs with confidence and trust, providing the best care possible. He received his Doctor of Dental Surgery Degree (D.D.S.) from the Ohio State University in 2000.'),
              SizedBox(
                height: 8,
              ),
              Text(
                  'In addition, Dr. Nguyen has completed many hours of advanced post-graduate training, allowing him to stay up-to-date with the latest training and techniques. At his office, he can provide you with the most technologically advanced treatment available today.'),
              SizedBox(
                height: 8,
              ),
              Text(
                  'With the Dental Rescue App, Dr Nguyen believes that everyone, no matter what economic and environmental situation they are in, needs dental advice and assistance when a dental emergency arises.  Dr Nguyen will evaluate, advise, and, if needed, prescribe medication for a dental emergency.'),
              SizedBox(
                height: 15,
              ),
              /*RichText(
              text: TextSpan(
            text: 'Contact us: ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: 'my.qabila.2020@gmail.com',
                  style: TextStyle(
                      color: Color(0xFF166138), fontWeight: FontWeight.bold)),
            ],
          )),*/
            ],
          ),
        ),
      ),
    );
  }
}
