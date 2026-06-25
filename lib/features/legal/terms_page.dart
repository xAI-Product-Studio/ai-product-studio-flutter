import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1B4B),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 2, width: 40, color: const Color(0xFF7C3AED)),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B6880),
            height: 1.7,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1E1B4B)),
        title: const Text(
          'Kullanım Koşulları / Terms of Service',
          style: TextStyle(
            color: Color(0xFF1E1B4B),
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TÜRKÇE BÖLÜM ---
            const Text(
              'TÜRKÇE / TURKISH',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF7C3AED),
                fontFamily: 'Inter',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Son Güncelleme: Haziran 2026',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B6880),
                fontFamily: 'Inter',
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Hizmet Tanımı',
              'Titlora (AI Product Studio), e-ticaret satıcıları ve işletmeler için yapay zeka tabanlı ürün görseli arka plan temizleme, görsel iyileştirme, görsel oluşturma ve yapay zeka destekli ürün açıklamaları ile pazarlama metinleri üretme hizmetleri sunan bir yazılım (SaaS) platformudur.',
            ),
            
            _buildSection(
              '2. Kullanıcı Hesapları ve Üyelik',
              'Platforma üye olurken doğru, güncel ve eksiksiz bilgi sağlamanız zorunludur. Hesabınızın güvenliğini ve şifrenizin gizliliğini korumak sizin sorumluluğunuzdadır. Hesabınız üzerinden gerçekleştirilen tüm faaliyetler doğrudan tarafınıza aittir.',
            ),
            
            _buildSection(
              '3. Abonelik ve Ödeme Koşulları',
              '• Abonelik Modeli: Hizmetlerimiz aylık veya yıllık abonelik planları dahilinde otomatik yenileme esasıyla sunulur.\n'
              '• İptal Politikası: Aboneliğinizi bir sonraki yenileme tarihinden en az 30 gün önce iptal etmeniz gerekmektedir. İptal talebinizden sonraki ilk fatura döneminde aboneliğiniz sonlandırılır.\n'
              '• Para İade Garantisi: Satın alım tarihinden itibaren ilk 30 gün içinde, hizmet kalitesinden memnun kalmamanız durumunda koşulsuz para iade garantisinden yararlanabilirsiniz.\n'
              '• Fiyat Değişiklikleri: Abonelik ücretlerindeki değişiklikler, yürürlüğe girmesinden en az 30 gün önce kullanıcılara e-posta veya platform içi bildirim yoluyla haber verilir.',
            ),
            
            _buildSection(
              '4. Kredi Sistemi',
              '• Tüketim Esası: Platform içindeki görsel işleme veya metin üretimi işlemleri kredi bazlıdır. 1 kredi, 1 ürün işleme hakkına (görsel optimizasyonu veya metin üretimi) karşılık gelir.\n'
              '• Devir Kuralları: Aylık paket kapsamında verilen ve ilgili fatura dönemi içerisinde kullanılmayan krediler bir sonraki aya devretmez, dönem sonunda silinir.\n'
              '• İptal Durumu: Abonelik iptali veya hesap sonlandırılması durumunda hesapta kalan mevcut krediler iade edilmez ve nakde çevrilemez.',
            ),
            
            _buildSection(
              '5. Kabul Edilebilir Kullanım',
              'Platformu kullanırken aşağıdaki kurallara uymayı kabul edersiniz:\n'
              '• Yasak İçerikler: Yasa dışı, müstehcen, tehditkar, hakaret içerikli, nefret söylemi barındıran veya genel ahlaka aykırı görseller ve metinler yüklenemez.\n'
              '• Fikri Mülkiyet İhlali Yasağı: Hak sahibi olmadığınız veya telif hakkı, marka gibi hakları ihlal eden hiçbir materyal işlenemez.\n'
              '• API Kötüye Kullanımı: Platform API\'lerini ve altyapısını aşırı yükleyecek, tersine mühendislik veya veri kazıma (scraping) yapacak eylemlerde bulunmak yasaktır.\n'
              '• Ticari Yeniden Satış: Hizmetlerin ve platform özelliklerinin doğrudan ticari amaçlarla üçüncü kişilere rakip olacak şekilde yeniden satılması yasaktır.',
            ),
            
            _buildSection(
              '6. Fikri Mülkiyet',
              '• Kullanıcı İçerikleri: Kullanıcı tarafından yüklenen ürün görsellerinin ve girdilerin tüm fikri mülkiyet ve mülkiyet hakları tamamen kullanıcının kendisine aittir.\n'
              '• Platform Hakları: Titlora platformu, kaynak kodları, tasarım ögeleri, tescilli algoritmaları ve yapay zeka modelleri üzerindeki tüm fikri mülkiyet hakları Titlora\'ya aittir.\n'
              '• Marka Kullanımı: Titlora markası, logosu ve görselleri önceden yazılı izin alınmaksızın ticari amaçlarla kullanılamaz.',
            ),
            
            _buildSection(
              '7. Hizmet Kesintileri ve Garanti',
              '• Olduğu Gibi Esası: Titlora, hizmetleri "olduğu gibi" ve "kullanılabilir olduğu sürece" sunar. Hizmetin kesintisiz, hatasız veya tamamen kusursuz olacağı garanti edilmez.\n'
              '• Uptime Hedefi: Platform, yıllık bazda %99 uptime (çalışma süresi) oranına ulaşmayı hedefler, ancak bu oran hukuki veya teknik bir garanti niteliği taşımaz.\n'
              '• Planlı Bakım: Sistemin iyileştirilmesi amacıyla yapılacak planlı bakımlardan önce kullanıcılara platform veya e-posta üzerinden bilgilendirme yapılır.',
            ),
            
            _buildSection(
              '8. Sorumluluk Sınırlaması',
              '• Dolaylı Zararlar: Titlora, platformun kullanımından veya kullanılamamasından doğan veri kaybı, kâr kaybı veya herhangi bir dolaylı/tesadüfi zarardan sorumlu tutulamaz.\n'
              '• Sorumluluk Limiti: Titlora\'nın kullanıcıya karşı doğabilecek toplam hukuki sorumluluğu, ilgili uyuşmazlığa konu olan kullanıcının son 3 aylık abonelik bedeli ile sınırlıdır.\n'
              '• Pazar Yeri Politikaları: Amazon, Trendyol, Hepsiburada gibi pazar yerlerinin görsel ve içerik standartlarında yapacağı değişikliklerden veya bu değişikliklerin hesaplarınıza etkilerinden Titlora sorumlu değildir.',
            ),
            
            _buildSection(
              '9. Hesap Askıya Alma ve Sonlandırma',
              '• İhlal Durumu: Kullanım Koşulları\'nın ihlal edilmesi durumunda, Titlora kullanıcının hesabını önceden bildirimde bulunmaksızın geçici veya kalıcı olarak askıya alma veya kapatma hakkını saklı tutar.\n'
              '• Kullanıcı Talebi: Kullanıcı, platform ayarları üzerinden veya destek ekibi ile iletişime geçerek hesabını dilediği zaman tamamen silebilir.\n'
              '• Veri Silme Süreci: Hesabın kapatılmasının ardından kullanıcı verileri 30 gün içerisinde sistemlerimizden kalıcı olarak silinir.',
            ),
            
            _buildSection(
              '10. Uyuşmazlık Çözümü',
              '• Uygulanacak Hukuk: Bu Kullanım Koşulları ve platform kullanımıyla ilgili tüm uyuşmazlıklarda Türkiye Cumhuriyeti hukuku geçerlidir.\n'
              '• Yetkili Mahkemeler: Olası uyuşmazlıkların çözümünde İstanbul (Çağlayan) Mahkemeleri ve İcra Daireleri yetkilidir.\n'
              '• Arabuluculuk: Taraflar, herhangi bir dava açmadan önce uyuşmazlığı dostane yollarla çözmek için öncelikle arabuluculuk sürecini denemeyi kabul ederler.',
            ),
            
            _buildSection(
              '11. Değişiklikler',
              'Titlora, bu Kullanım Koşulları\'nı zaman zaman güncelleme hakkına sahiptir. Koşullarda yapılacak önemli değişiklikler yürürlüğe girmeden en az 30 gün önce kullanıcılara e-posta veya sistem içi bildirim yoluyla bildirilecektir.',
            ),
            
            _buildSection(
              '12. İletişim',
              'Kullanım koşullarıyla ilgili her türlü soru, öneri veya destek talepleriniz için bizimle info@titlora.com e-posta adresi üzerinden iletişime geçebilirsiniz.',
            ),
            
            const Divider(color: Color(0xFFE5E3F0), height: 64, thickness: 1.5),
            
            // --- ENGLISH SECTION ---
            const Text(
              'ENGLISH / ENGLISH',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF7C3AED),
                fontFamily: 'Inter',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last Updated: June 2026',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B6880),
                fontFamily: 'Inter',
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Description of Service',
              'Titlora (AI Product Studio) is a Software-as-a-Service (SaaS) platform that provides AI-powered product image background removal, image enhancement, image generation, and AI-assisted product description and marketing copy generation services for e-commerce sellers and businesses.',
            ),
            
            _buildSection(
              '2. User Accounts and Membership',
              'You must provide accurate, current, and complete information when registering. You are responsible for maintaining the security of your account and the confidentiality of your password. You are directly responsible for all activities that occur under your account.',
            ),
            
            _buildSection(
              '3. Subscription and Payment Terms',
              '• Subscription Model: Our services are provided on a recurring subscription basis, billed monthly or annually, with automatic renewals.\n'
              '• Cancellation Policy: You must cancel your subscription at least 30 days before the next renewal date. Your subscription will end at the end of the billing cycle following your cancellation request.\n'
              '• Money-Back Guarantee: We offer a no-questions-asked 30-day money-back guarantee from the initial purchase date if you are not satisfied with our services.\n'
              '• Price Changes: Any changes to subscription fees will be notified to users at least 30 days in advance via email or in-app notifications.',
            ),
            
            _buildSection(
              '4. Credit System',
              '• Consumption Rules: Image processing and text generation tasks within the platform consume credits. 1 credit corresponds to 1 product processing task (image optimization or text generation).\n'
              '• Roll-Over Rules: Credits provided within the monthly subscription plans that are not used in the respective billing cycle do not roll over to the next month and expire at the end of the period.\n'
              '• Cancellation Policy: Remaining credits are non-refundable and cannot be converted into cash in case of subscription cancellation or account termination.',
            ),
            
            _buildSection(
              '5. Acceptable Use',
              'By using the platform, you agree to comply with the following rules:\n'
              '• Prohibited Content: You may not upload or generate illegal, obscene, threatening, abusive, hateful, or morally offensive images or texts.\n'
              '• No Intellectual Property Infringement: You may not process materials for which you do not hold rights or that violate copyrights, trademarks, or other intellectual property rights.\n'
              '• API Abuse: Overloading, reverse engineering, scraping, or exploiting the platform API and infrastructure is strictly prohibited.\n'
              '• Commercial Resale: Reselling the platform services or features directly to third parties in a way that competes with Titlora is prohibited.',
            ),
            
            _buildSection(
              '6. Intellectual Property',
              '• User Content: All intellectual property rights and ownership of product images and inputs uploaded by the user belong entirely to the user.\n'
              '• Platform Rights: All intellectual property rights in and to the Titlora platform, its source code, design elements, proprietary algorithms, and AI models belong to Titlora.\n'
              '• Brand Usage: The Titlora trademark, logo, and visual assets may not be used for commercial purposes without prior written permission.',
            ),
            
            _buildSection(
              '7. Service Interruptions and Warranty',
              '• As-Is Basis: Titlora provides services "as is" and "as available". We do not warrant that the service will be uninterrupted, error-free, or entirely flawless.\n'
              '• Uptime Goal: The platform aims for a 99% uptime on an annual basis, but this is a target and does not constitute a legal or technical guarantee.\n'
              '• Planned Maintenance: Users will be notified in advance via the platform or email about scheduled maintenance work aimed at system improvements.',
            ),
            
            _buildSection(
              '8. Limitation of Liability',
              '• Indirect Damages: Titlora shall not be liable for any indirect, incidental, or consequential damages, including loss of profit or data loss, arising from the use or inability to use the platform.\n'
              '• Liability Limit: Titlora\'s total liability to the user for any claims arising under these terms is limited to the subscription fees paid by the user in the 3 months preceding the dispute.\n'
              '• Marketplace Policies: Titlora is not responsible for policy changes, visual standards, or product guidelines updated by marketplaces (e.g. Amazon, Trendyol, Hepsiburada) or their impacts on your accounts.',
            ),
            
            _buildSection(
              '9. Account Suspension and Termination',
              '• Violation: In the event of a breach of these Terms of Service, Titlora reserves the right to temporarily or permanently suspend or terminate your account without prior notice.\n'
              '• User Deletion: Users can delete their accounts at any time through their settings or by contacting customer support.\n'
              '• Data Erasure: Following account deletion, all user data will be permanently deleted from our servers within 30 days.',
            ),
            
            _buildSection(
              '10. Dispute Resolution',
              '• Governing Law: These Terms of Service and all disputes arising out of the use of the platform shall be governed by the laws of the Republic of Turkey.\n'
              '• Jurisdiction: The Courts and Execution Offices of Istanbul (Caglayan) shall have exclusive jurisdiction over any disputes.\n'
              '• Mediation: Before initiating any lawsuit, both parties agree to first attempt to resolve the dispute amicably through mediation.',
            ),
            
            _buildSection(
              '11. Changes to Terms',
              'Titlora reserves the right to update these Terms of Service from time to time. Major changes will be notified to users at least 30 days before they take effect via email or in-app notification.',
            ),
            
            _buildSection(
              '12. Contact',
              'For any questions, suggestions, or support requests regarding our Terms of Service, please contact us at info@titlora.com.',
            ),
          ],
        ),
      ),
    );
  }
}
