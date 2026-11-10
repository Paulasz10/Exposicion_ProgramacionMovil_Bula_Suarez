import 'package:flutter/material.dart';
import '../../../dose_tracking/presentation/controllers/dose_controller.dart';
import '../../../medications/presentation/controllers/medication_controller.dart';
class StatisticsPage extends StatelessWidget {
  final DoseController doses;
  final MedicationController medications;
  const StatisticsPage({super.key,required this.doses,required this.medications});
  @override Widget build(BuildContext context)=>SafeArea(child:AnimatedBuilder(animation:Listenable.merge([doses,medications]),builder:(context,_){
    final now=DateTime.now();final meds=medications.medications;
    final values=List<int>.generate(7,(i){final day=DateTime(now.year,now.month,now.day).subtract(Duration(days:6-i));return doses.records.where((r)=>r.takenAt.year==day.year&&r.takenAt.month==day.month&&r.takenAt.day==day.day).length;});
    final today=values.last;final total=doses.records.length;final count=meds.length;
    return Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:850),child:ListView(padding:const EdgeInsets.all(24),children:[
      const Text('Estadísticas',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('Seguimiento de las confirmaciones registradas en este navegador.',style:TextStyle(color:Colors.black54)),const SizedBox(height:20),
      Wrap(spacing:12,runSpacing:12,children:[_stat('Hoy','$today',Icons.today),_stat('Historial','$total',Icons.check_circle_outline),_stat('Medicamentos','$count',Icons.medication_outlined)]),
      const SizedBox(height:22),Card(child:Padding(padding:const EdgeInsets.all(22),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Confirmaciones en los últimos 7 días',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const SizedBox(height:24),SizedBox(height:190,child:Row(crossAxisAlignment:CrossAxisAlignment.end,children:List.generate(7,(i){final v=values[i];final maxValue=values.reduce((a,b)=>a>b?a:b);return Expanded(child:Padding(padding:const EdgeInsets.symmetric(horizontal:6),child:Column(mainAxisAlignment:MainAxisAlignment.end,children:[Text('$v',style:const TextStyle(fontSize:12)),const SizedBox(height:5),Container(height:10+140*(maxValue==0?0:v/maxValue),decoration:BoxDecoration(color:i==6?const Color(0xFF087D70):const Color(0xFF82CFC0),borderRadius:BorderRadius.circular(8))),const SizedBox(height:7),Text(['L','M','X','J','V','S','D'][DateTime(now.year,now.month,now.day).subtract(Duration(days:6-i)).weekday-1],style:const TextStyle(fontSize:12))])));}))),
      ]))),const SizedBox(height:15),const Card(child:Padding(padding:EdgeInsets.all(18),child:Row(children:[Icon(Icons.info_outline,color:Color(0xFF087D70)),SizedBox(width:12),Expanded(child:Text('Las gráficas representan confirmaciones manuales de demostración, no adherencia médica verificada.'))]))),
    ])));
  }));
  Widget _stat(String label,String value,IconData icon)=>SizedBox(width:178,height:115,child:Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:const Color(0xFF087D70)),Text(value,style:const TextStyle(fontSize:23,fontWeight:FontWeight.bold)),Text(label,style:const TextStyle(fontSize:12))]))));
}
