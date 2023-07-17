class Temperature{
  String main="";
  String description="";
  String icon="";
  double temp=0.0;
  int pressure=0;
  int? humidity;
  double tempMin=0.0;
  double tempMax=0.0;

  Temperature(Map<String,dynamic> myMap){
    List<dynamic> weather = myMap["weather"];
    Map weatherMap=weather.first;
    main=weatherMap["main"];
    description=weatherMap["description"];
    icon=weatherMap["icon"];
    Map mainMap=myMap["main"];
    temp=mainMap["temp"];
    pressure=mainMap["pressure"];
    humidity=mainMap["humidity"];
    tempMin=mainMap["temp_min"];
    tempMax=mainMap["temp_max"];
  }
}