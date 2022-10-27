import 'package:covid_tracker/View/details_screen.dart';
import 'package:covid_tracker/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreens extends StatefulWidget {
  const CountriesListScreens({Key? key}) : super(key: key);

  @override
  State<CountriesListScreens> createState() => _CountriesListScreensState();
}

class _CountriesListScreensState extends State<CountriesListScreens> {

  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices=StatesServices();

    return Scaffold(
     appBar: AppBar(
       elevation: 0,
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
     ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0),
          child: TextFormField(
            onChanged: (value){
              setState(() {

              });
            },
            controller: searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Search with country name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0)
                )
            ),
          ),
          ),
          Expanded(child: FutureBuilder<List<dynamic>>(
            future: statesServices.fetchCountriesList(),
            builder: (context,AsyncSnapshot<List<dynamic>> snapshot){
                if(!snapshot.hasData){
                  return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context,index){
                        return Shimmer.fromColors(
                            baseColor: Colors.grey.shade700,
                            highlightColor: Colors.grey.shade100,
                          child:Column(
                            children: [
                              ListTile(
                                leading: Container(
                                  height: 50,width: 50,color: Colors.white,

                                ),
                                title: Container(
                                    height: 10,width: 89,color: Colors.white,
                                    ),
                                subtitle: Container(
                                    height: 10,width: 89,color: Colors.white,
                                )


                              )

                            ],
                          ) ,
                        );
                      });
                }else{
                       return ListView.builder(
                         itemCount: snapshot.data!.length,
                       itemBuilder: (context,index){
                           String name=snapshot.data![index]['country'];
                           if(searchController.text.isEmpty){
                             return Column(
                               children: [
                                 InkWell(
                                   onTap:(){
                                     Navigator.push(context,
                                         MaterialPageRoute(builder: (context)=>
                                             DetailScreen(
                                               name: snapshot.data![index]['country'],
                                               image: snapshot.data![index]['countryInfo']['flag'],
                                               totalCases: snapshot.data![index]['cases'],
                                               todayRecovered: snapshot.data![index]['recovered'],
                                               totalDeaths: snapshot.data![index]['deaths'],
                                               active: snapshot.data![index]['active'],
                                               test: snapshot.data![index]['tests'],
                                               totalRecovered: snapshot.data![index]['todayRecovered'],
                                               critical: snapshot.data![index]['critical'],
                                             )));
                                   },
                                   child: ListTile(
                                     leading: Image(
                                       height:50,
                                       width: 50,
                                       image: NetworkImage(
                                           snapshot.data![index]['countryInfo']['flag']
                                       ),
                                     ),
                                     title: Text(snapshot.data![index]['country']),
                                     subtitle: Text(snapshot.data![index]['cases'].toString()),


                                   ),
                                 )

                               ],
                             );
                           }else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                             return Column(
                               children: [
                                 InkWell(
                                   onTap:(){
                                     Navigator.push(context,
                                         MaterialPageRoute(builder: (context)=>
                                             DetailScreen(
                                               name: snapshot.data![index]['country'],
                                               image: snapshot.data![index]['countryInfo']['flag'],
                                               totalCases: snapshot.data![index]['cases'],
                                               todayRecovered: snapshot.data![index]['recovered'],
                                               totalDeaths: snapshot.data![index]['deaths'],
                                               active: snapshot.data![index]['active'],
                                               test: snapshot.data![index]['tests'],
                                               totalRecovered: snapshot.data![index]['todayRecovered'],
                                               critical: snapshot.data![index]['critical'],
                                             )));
                                   },
                                   child: ListTile(
                                     leading: Image(
                                       height:50,
                                       width: 50,
                                       image: NetworkImage(
                                           snapshot.data![index]['countryInfo']['flag']
                                       ),
                                     ),
                                     title: Text(snapshot.data![index]['country']),
                                     subtitle: Text(snapshot.data![index]['cases'].toString()),


                                   ),
                                 )

                               ],
                             );
                           }else{
                             return Container();
                           }

                  });
                }
            },
          ))
        ],
      ),
    );
  }
}
