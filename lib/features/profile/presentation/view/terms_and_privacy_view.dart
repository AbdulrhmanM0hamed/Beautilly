import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';

class TermsAndPrivacyView extends StatelessWidget {
  static const String routeName = '/terms-and-privacy';

  const TermsAndPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'الشروط والأحكام',
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                padding: const EdgeInsets.all(4),
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                ),
                tabs: const [
                  Tab(text: 'الشروط والأحكام'),
                  Tab(text: 'سياسة الخصوصية'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTermsContent(),
                  _buildPrivacyContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'المقدمة',
            content:
                'مرحبًا بك في دلالك. باستخدامك لهذا الموقع، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي من هذه الشروط، يرجى التوقف عن استخدام خدماتنا.',
            icon: Icons.info_outline,
          ),
          _buildSection(
            title: 'إنشاء الحسابات',
            content:
                'لاستخدام بعض الميزات، مثل الحجز أو التقييم، قد تحتاج إلى إنشاء حساب. يجب عليك تقديم معلومات دقيقة ومحدثة، كما أنك مسؤول عن سرية بيانات تسجيل الدخول وأي نشاط يحدث عبر حسابك.',
            icon: Icons.person_outline,
          ),
          _buildSection(
            title: 'الاستخدام المقبول',
            content:
                '''يُحظر إساءة استخدام خدمات دلالك بأي شكل من الأشكال، بما في ذلك (ولكن لا يقتصر على):
            
• الوصول غير المصرح به إلى البيانات أو النظام.
• إرسال رسائل غير مرغوب فيها أو محاولات الاحتيال.
• انتهاك أي قوانين محلية أو دولية أثناء استخدام الموقع.''',
            icon: Icons.security,
          ),
          _buildSection(
            title: 'المحتوى والملكية الفكرية',
            content:
                'جميع المحتويات المتاحة على دلالك (النصوص، الصور، التصاميم، العلامات التجارية) محمية بموجب قوانين الملكية الفكرية. لا يجوز لك إعادة إنتاج أو توزيع أو استخدام أي محتوى دون إذن مسبق.',
            icon: Icons.copyright,
          ),
          _buildSection(
            title: 'المدفوعات والاسترداد',
            content:
                'قد تتطلب بعض الخدمات على دلالك دفع رسوم محددة. جميع المدفوعات نهائية وغير قابلة للاسترداد، إلا إذا تم توضيح ذلك صراحةً في سياسة الاسترداد الخاصة بنا.',
            icon: Icons.payment,
          ),
          _buildSection(
            title: 'سياسة الخصوصية',
            content:
                'نلتزم بحماية خصوصية مستخدمينا. تخضع جميع البيانات الشخصية لسياسة الخصوصية الخاصة بنا، والتي توضح كيفية جمع البيانات واستخدامها وحمايتها.',
            icon: Icons.privacy_tip,
          ),
          _buildSection(
            title: 'التعديلات على الشروط',
            content:
                'يحق لـدلالك تعديل هذه الشروط في أي وقت. سيتم نشر التعديلات على هذه الصفحة، ويعتبر استمرارك في استخدام الموقع بعد التعديلات موافقة ضمنية عليها.',
            icon: Icons.update,
          ),
          _buildSection(
            title: 'القانون الحاكم',
            content:
                'تخضع هذه الشروط لقوانين الدولة التي يتم تشغيل الموقع فيها، وأي نزاعات يتم حلها وفقًا لذلك.',
            icon: Icons.gavel,
          ),
          _buildSection(
            title: 'التواصل',
            content: '''لأي استفسارات أو ملاحظات، يمكنك التواصل معنا عبر:

• البريد الإلكتروني: support@dallik.com
• العنوان: المملكة العربية السعودية
• رقم الهاتف: +966536448254
''',
            icon: Icons.contact_support,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'المقدمة',
            content:
                'مرحبًا بك في دلالك. نحن ملتزمون بحماية خصوصيتك. توضح سياسة الخصوصية هذه كيفية جمعنا واستخدامنا وحماية معلوماتك عند استخدام خدماتنا.',
            icon: Icons.privacy_tip_outlined,
          ),
          _buildSection(
            title: 'المعلومات التي نجمعها',
            content: '''نقوم بجمع نوعين من المعلومات:

1. المعلومات الشخصية:
• الاسم الكامل
• البريد الإلكتروني
• رقم الهاتف
• العنوان

2. بيانات الاستخدام:
• الصفحات التي تزورها
• وقت وتاريخ الزيارات
• معلومات الجهاز المستخدم
• سجل التفاعلات''',
            icon: Icons.data_usage,
          ),
          _buildSection(
            title: 'كيفية استخدام معلوماتك',
            content: '''نستخدم معلوماتك للأغراض التالية:
• إدارة حسابك الشخصي
• تسهيل عمليات الحجز والدفع
• تحسين خدماتنا وتجربة المستخدم
• التواصل معك بخصوص الحجوزات والعروض
• تحليل أداء التطبيق وتحسينه''',
            icon: Icons.security,
          ),
          // ... باقي الأقسام
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
            ),
          ),
        ],
      ),
    );
  }
}
