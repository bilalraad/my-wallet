import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../Helpers/app_localizations.dart';

class InfoSceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Info')),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SelectableText(
                'Developer: Bilal R. Akobi'
                '\nContact info : bilal52040@gmail.com'
                '\nTask Supervisor: Sherin Ali & Muhammed Essa\n\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const Divider(
                thickness: 2,
              ),
              Image.asset('assets/code_for_iraq.png'),
              const Text(
                'البرمجة من اجل العراق',
                style: TextStyle(
                  fontSize: 23,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'وهي مبادرة إنسانية غير ربحية تهدف الى خدمة المجتمع '
                'عن طريق البرمجة، تعتبر هذه المبادرة مبادرة تعليمية حقيقية ترعى'
                ' المهتمين بتعلم تصميم وبرمجة تطبيقات الهاتف الجوال ومواقع الانترنت'
                ' وبرامج الحاسوب والشبكات والاتصالات ونظم تشغيل الحاسوب باستخدام '
                'التقنيات مفتوحة المصدر كما توفر لهم جميع الدروس التعليمية '
                'الازمة وبشكل مجاني تماما بل الاهم من ذلك تعتمد على مبدا المواطنة'
                'والمشاركة الفاعلة في تأسيس وبناء المجتمع تدعو هذه المبادرة'
                'جميع الطلبة والخريجين والهواة والاساتذة الجامعيين والمهتمين '
                'بمجال البرمجة وتقنيات المعلومات وكذلك الاختصاصات الأخرى السبب '
                'التطوع والمشاركة الفعلية لأجل الاتقاء بواقع البلد, حيث تعتبر فرصة '
                'عظيمة لاكتساب الخبرة والمهارة عن طريق تصميم وتنفيذ برامج وتطبيقات '
                'خدمية من شأنها خدمة المواطن وذلك ضمن مجاميع عمل نشطة وفعالة '
                'يتعاون فيها جميع الافراد كفريق واحد تبادل الآراء والخبرات ويطرح '
                'الافكار ليتم مناقشتها وتطبيقها على أرض الواقع, كما تفتح المجال '
                'لجميع المواطنين العراقيين ومن جميع الاختصاصات الى المشاركة '
                'الفاعلة في هذه المشاريع لرفد الفريق بالخبرات والأفكار والآراء '
                'والمقترحات التي من شأنها خدمة المجتمع بأفضل ما يمكن',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
