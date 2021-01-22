import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:railrecipe_vendor_app/Pages/dashboard.dart';
import 'package:railrecipe_vendor_app/Sidebar/sidebar.dart';
import 'package:railrecipe_vendor_app/const/api.dart';
import 'package:railrecipe_vendor_app/const/variables.dart';


class PreviousOrders extends StatefulWidget {
  @override
  _PreviousOrdersState createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  var res,allData;
  bool load = false;
  List orderHistory = [];

  Future <String> previousOrders() async {
    var data =  await rootBundle.loadString(API.order_history);
    setState(() {
      load = true;
      res = jsonDecode(data);
      allData = res['data'];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    previousOrders();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        return Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>DashBoard()));
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: SideBar(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: Text('Previous Orders',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 5.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body:ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount:allData == null ? 0 : allData.length,
            itemBuilder: (context,index){
              var item = allData[index]['items'];
              var itemQty =0;
              for(int i =0;i<item.length;i++)
              {
                itemQty = itemQty + item[i]['quantity'];
              }
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)
                    )
                ),
                elevation: 8,
                margin: EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20,),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Order #${allData[index]['order_id'].toString()}",
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text('${allData[index]['status'] == 1 ? 'DELIVERED\t' : 'CANCELLED\t'}',
                                style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15.0),),
                              Icon(allData[index]['status'] == 1 ?Icons.check_circle_outline :Icons.cancel_outlined,size: 20,color: allData[index]['status'] == 1 ? Colors.green :Colors.red,),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text("${allData[index]['del_date_time']}",style: TextStyle(fontSize: 15),),
                          SizedBox(height: 10,),
                          Text("${itemQty.toString()} \t Items"),
                        ],
                      ),
                    ),
                    trailing: SizedBox(),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: item == null ? 0 : item.length,
                        itemBuilder: (context,index){
                          return Container(
                              margin: const EdgeInsets.only(left: 10,right: 05,bottom: 10,top: 10),
                              child: Row(
                                children: [
                                  Card(
                                    shape: new RoundedRectangleBorder(
                                        side: BorderSide(color: item[index]['isVeg'] == true ?
                                        Colors.green :Colors.deepOrange),
                                        borderRadius: BorderRadius.circular(0.0)
                                    ),
                                    child: item[index]['isVeg'] == true ?
                                    Icon(Icons.fiber_manual_record,color: Colors.green,size: 12.0,):
                                    Icon(Icons.fiber_manual_record,color: Colors.red,size: 12.0,),
                                  ),
                                  Text('${item[index]['quantity'].toString()} \t X\t '+'${item[index]['item_name']}')
                                ],
                              )
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text("Total",
                              style: Variables.blacktxtStyle,),
                            Spacer(),
                            Text(Currency.rupee +"\t${allData[index]['total'].toString()}",
                            style: Variables.blacktxtStyle,),

                          ],
                        ),
                      ),
                      FlatButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {},
                        icon: Icon(Icons.visibility),
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("View Details"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
      ),
    );
  }
}
