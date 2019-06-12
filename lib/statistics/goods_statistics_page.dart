
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/util/date_utils.dart';
import 'package:flutter_deer/util/utils.dart';
import 'package:flutter_deer/widgets/app_bar.dart';
import 'package:flutter_deer/widgets/my_card.dart';
import 'package:flutter_deer/widgets/pie_chart/pie_chart.dart';
import 'package:flutter_deer/widgets/pie_chart/pie_data.dart';
import 'package:flutter_deer/widgets/selected_text.dart';

class GoodsStatisticsPage extends StatefulWidget {

  @override
  _GoodsStatisticsPageState createState() => _GoodsStatisticsPageState();
}

class _GoodsStatisticsPageState extends State<GoodsStatisticsPage> {

  DateTime initialDay;
  int selectedIndex = 2;
  /// false 待配货 true 已配货
  bool _type = false;
  
  @override
  void initState() {
    super.initState();
    initialDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actionName: _type ? "待配货" : "已配货",
        onPressed: (){
          setState(() {
            _type = !_type;
          });
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Gaps.vGap4,
                Text(_type ? "已配货" : "待配货", style: TextStyles.textBoldDark24),
                Gaps.vGap16,
                Gaps.vGap16,
                Row(
                  children: <Widget>[
                    Gaps.hGap8,
                    _buildSelectedText(initialDay.year.toString(), 0),
                    Gaps.hGap16,
                    Container(width: 0.6, height: 24.0, color: Colours.line),
                    Gaps.hGap16,
                    _buildSelectedText("${initialDay.month.toString()}月", 1),
                    Gaps.hGap16,
                    Container(width: 0.6, height: 24.0, color: Colours.line),
                    Gaps.hGap16,
                    _buildSelectedText(_type ? "${DateUtils.previousWeek(initialDay)} -${DateUtils.apiDayFormat(initialDay)}" : "${initialDay.day.toString()}日", 2),
                  ],
                ),
                Gaps.vGap8,
                _buildChart(),
                Text("热销商品排行", style: TextStyles.textBoldDark18),
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16.0),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemExtent: 76.0,
                  itemBuilder: (context, index) => _buildItem(index),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  _buildChart(){
    return AspectRatio(
      aspectRatio: 1.30,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: PieChart(
          name: _type ? "待配货" : "已配货",
          data: _getRandomData(),
        ),
      ),
    );
  }

  List<PieData> data = [];
  List<PieData> data1 = [];

  // 数据为前十名数据与剩余数量
  _getRandomData(){
    if (data.isEmpty){
      for (int i = 0; i < 9; i++){
        PieData pieData = PieData();
        pieData.name = "商品$i";
        pieData.number = Random.secure().nextInt(1000);
        data.add(pieData);
      }
      for (int i = 0; i < 11; i++){
        PieData pieData = PieData();
        if (i == 10){
          pieData.name = "其他";
          pieData.number = Random.secure().nextInt(1000);
          pieData.color = Color(0xFFCCCCCC);
        }else{
          pieData.name = "商品$i";
          pieData.number = Random.secure().nextInt(1000);
        }
        data1.add(pieData);
      }
    }

    if (_type){
      return data;
    }else{
      return data1;
    }
  }
  
  List<Color> colorList = [
    Color(0xFF7087FA), Color(0xFFA0E65C), Color(0xFF5CE6A1), Color(0xFFA364FA), 
    Color(0xFFDA61F2),Color(0xFFFA64AE), Color(0xFFFA6464)
  ];
  
  _buildItem(int index){
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: MyCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 24.0, 16.0),
          child: Row(
            children: <Widget>[
              index <= 2 ?
                Image.asset(Utils.getImgPath("statistic/${index == 0 ? "champion" : index == 1 ? "runnerup" : "thirdplace"}"), width: 40.0,) :
                Container(
                  alignment: Alignment.center,
                  width: 18.0, height: 18.0, 
                  margin: const EdgeInsets.symmetric(horizontal: 11.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorList[index - 3]
                  ),
                  child: Text("${index + 1}", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                ),
              Gaps.hGap8,
              Container(
                height: 36.0, width: 36.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Color(0xFFF7F8FA), width: 0.6),
                  image: DecorationImage(
                    image: AssetImage(Utils.getImgPath("order/icon_goods"))
                  )
                ),
              ),
              Gaps.hGap16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("那鲁火多饮料", style: TextStyle(color: Colours.text_dark, fontWeight: FontWeight.bold, fontSize: 12.0)),
                  Text("250ml", style: TextStyles.textGray12),
                ],
              ),
              Expanded(child: Gaps.empty),
              Offstage(
                offstage: _type,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("100件", style: TextStyles.textGray12),
                    Text("未支付", style: TextStyles.textGray12),
                  ],
                ),
              ),
              Gaps.hGap16,
              Gaps.hGap4,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: _type ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("400件", style: TextStyles.textGray12),
                  Offstage(offstage: _type, child: Text("已支付", style: TextStyles.textGray12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  _buildSelectedText(String text, int index){
    return SelectedText(
      text,
      fontSize: 16.0,
      selected: _type && selectedIndex == index,
      unSelectedTextColor: Colours.text_normal,
      onTap: (){
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}