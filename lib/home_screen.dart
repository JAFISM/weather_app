import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'constatnts.dart' as k;
import 'dart:convert';

class HomeScren extends StatefulWidget {
  const HomeScren({Key? key}) : super(key: key);

  @override
  State<HomeScren> createState() => _HomeScrenState();
}

class _HomeScrenState extends State<HomeScren> {

  bool isLoaded = false;
  num? temp;
  num? press;
  num? hum;
  num? cover;
  String cityName='';

  TextEditingController cityController =TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0093E9),
                // Color(0xff0093E9),
                Color(0xff80D0C7),
              ]
            )
          ),
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(child:  CircularProgressIndicator(color: Colors.white,)),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.85,
                  height: MediaQuery.of(context).size.height*0.09,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: TextFormField(
                      onFieldSubmitted: (String s){
                        setState(() {
                          cityName=s;
                          getCityWeather(s);
                          isLoaded = false;
                          cityController.clear();
                        });
                      },
                      controller: cityController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search city",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(Icons.pin_drop,size: 35,color: Colors.red,),
                      SizedBox(width: 10,),
                      Expanded(child: Text(cityName,overflow: TextOverflow.clip,style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white.withOpacity(0.7)),maxLines: 2,))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height*0.095,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Image.asset("assets/icons/temperature.png",height: 30,width: 30,)),
                      Expanded(
                        flex: 5,
                          child: Text("Temperature : ${temp?.toInt()}℃",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white70),)),
                    ],
                  )
                ),
                SizedBox(height: 20,),
                Container(
                    height: MediaQuery.of(context).size.height*0.095,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Image.asset("assets/icons/windspeed.png",height: 30,width: 30,)),
                        Expanded(
                            flex: 5,
                            child: Text("Pressure : ${press?.toInt()} hpa",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white70),)),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                    height: MediaQuery.of(context).size.height*0.095,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Image.asset("assets/icons/humidity.png",height: 30,width: 30,)),
                        Expanded(
                            flex: 5,
                            child: Text("Humidity : $hum%",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white70),)),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                    height: MediaQuery.of(context).size.height*0.095,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Image.asset("assets/icons/clouds.png",height: 30,width: 30,)),
                        Expanded(
                            flex: 5,
                            child: Text("Cloud Cover : $cover%",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white70),)),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCurrentLocation() async{
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true
    );
    if(p!=null){
      print('lat:${p.latitude},Long: ${p.longitude}');
      getCurrentCityWeather(p);
    }else{
      print('Data unavailable');
    }
  }

  getCityWeather(String cityName)async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityName&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if(response.statusCode == 200){
      var data = response.body;
      var decodeData = jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded =true;
      });
    }
    else{
      print(response.statusCode);
    }
  }



  getCurrentCityWeather(Position position) async{
    var client = http.Client();
    var uri = '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if(response.statusCode == 200){
      var data = response.body;
      var decodeData = jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded =true;
      });
    }
    else{
      print(response.statusCode);
    }
  }

   updateUI(var  decodeData) {
    setState(() {
      if(decodeData == null){
        temp=0;
        press=0;
        hum=0;
        cover=0;
        cityName='Not Available';
      }else{
        temp=decodeData['main']['temp']-273;
        press=decodeData['main']['pressure'];
        hum=decodeData['main']['humidity'];
        cover=decodeData['clouds']['all'];
        cityName=decodeData['name'];
      }
    });
   }
   @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }
}
