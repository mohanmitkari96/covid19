
import 'package:covid_tracker/Model/WorldStateModel.dart';
import 'package:covid_tracker/View/coutries_list.dart';
import 'package:covid_tracker/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WordStatesScreen extends StatefulWidget {
  const WordStatesScreen({Key? key}) : super(key: key);

  @override
  State<WordStatesScreen> createState() => _WordStatesScreenState();
}

class _WordStatesScreenState extends State<WordStatesScreen> with TickerProviderStateMixin {

  late final AnimationController _controller=AnimationController(vsync: this,
      duration: const Duration(seconds: 3)
  )..repeat();

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  final colorList=<Color> [
    const Color(0xff5285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246)
  ];


  @override
  Widget build(BuildContext context) {

    StatesServices statesServices=StatesServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*.01,),
                FutureBuilder(
                    future: statesServices.featchWorldStatesRecords(),
                    builder: (context,AsyncSnapshot<WorldStateModel> snapshot){
                  if(!snapshot.hasData){
                    return Expanded(child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                      controller: _controller,
                    ));
                  }else{
                    return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total":double.parse(snapshot.data!.cases.toString()),
                              "Recovered":double.parse(snapshot.data!.recovered.toString()),
                              "Deaths":double.parse(snapshot.data!.deaths.toString())
                            },
                            chartRadius: MediaQuery.of(context).size.width/3.2,
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left
                            ),
                            animationDuration: const Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.06),
                            child: Card(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ReusableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                    ReusableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                    ReusableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                    ReusableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                    ReusableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                                    ReusableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),
                                    ReusableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                                  ],
                                ),
                              )

                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>CountriesListScreens()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:const Color(0xff1aa260),
                              ),
                              child:const Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                          )
                        ],
                      );
                   
                  }
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title,value;

   ReusableRow({Key? key,required this.title,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom:5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(title),
           Text(value)
         ],),
          SizedBox(height: 5,),
          Divider()
        ],
      ),
    );
  }
}
