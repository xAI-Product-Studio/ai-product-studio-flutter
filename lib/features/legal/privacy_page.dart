import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
          'Gizlilik Politikası / Privacy Policy',
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
              '1. Veri Sorumlusu',
              '6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) kapsamında, Titlora (AI Product Studio) veri sorumlusu sıfatına sahiptir. Tüm veri işleme süreçleriyle ilgili sorularınız için info@titlora.com adresinden bizimle iletişime geçebilirsiniz.',
            ),
            
            _buildSection(
              '2. Toplanan Kişisel Veriler',
              'Titlora platformunu kullanımınız sırasında tarafımızca işlenen kişisel veriler şunlardır:\n'
              '• Kimlik Bilgileri: Ad, soyad.\n'
              '• İletişim Bilgileri: E-posta adresi.\n'
              '• İşlem Bilgileri: Abonelik detayları ve ödeme işlem kayıtları (kart bilgileri iş ortaklarımız tarafından saklanır).\n'
              '• Kullanım Verileri: IP adresi, cihaz bilgileri, çerez kayıtları ve platform içi aktivite verileri.\n'
              '• İçerik Verileri: Platforma yüklediğiniz ürün görselleri ve girdiğiniz metinsel açıklamalar.',
            ),
            
            _buildSection(
              '3. Verilerin İşlenme Amaçları',
              'Kişisel verileriniz aşağıdaki amaçlarla işlenmektedir:\n'
              '• Hizmet Sunumu: Yapay zeka tabanlı görsel işleme, optimizasyon ve metin üretimi süreçlerinin yürütülmesi.\n'
              '• Abonelik Yönetimi: Ödemelerin alınması, faturalandırma ve abonelik paketlerinin kontrolü.\n'
              '• Müşteri Desteği: Sorun giderme, kullanıcı taleplerinin karşılanması ve iletişim.\n'
              '• Yasal Yükümlülükler: Vergi mevzuatı, 5651 sayılı kanun kapsamındaki yükümlülükler ve adli taleplerin karşılanması.\n'
              '• Güvenlik: Platformun kötüye kullanımının önlenmesi ve siber güvenliğin sağlanması.',
            ),
            
            _buildSection(
              '4. Verilerin İşlenme Hukuki Dayanağı (KVKK Md. 5)',
              'Kişisel verileriniz KVKK Madde 5 uyarınca şu hukuki sebeplere dayanılarak işlenmektedir:\n'
              '• Sözleşmenin İfası: Kullanıcı sözleşmesinin kurulması ve hizmetlerin sunulması için veri işlemenin zorunlu olması.\n'
              '• Meşru Menfaat: Kullanıcıların temel hak ve özgürlüklerine zarar vermemek kaydıyla, platform güvenliği ve optimizasyon gibi meşru menfaatlerimiz için veri işlemenin zorunlu olması.\n'
              '• Açık Rıza: Yeni ürün duyuruları, pazarlama kampanyaları ve bülten gönderimleri için açık rızanızın bulunması.',
            ),
            
            _buildSection(
              '5. Üçüncü Taraflarla Veri Paylaşımı',
              'Verileriniz, yalnızca hizmetin ifası ve yasal gereklilikler kapsamında sınırlı olarak şu iş ortaklarımızla paylaşılmaktadır:\n'
              '• Photoroom API: Görsellerin arka planını temizlemek ve görsel optimizasyonu sağlamak amacıyla.\n'
              '• OpenAI: Yapay zeka destekli ürün açıklamaları ve pazarlama metinleri üretmek amacıyla.\n'
              '• Supabase: Verilerin güvenli şekilde saklanması amacıyla (Frankfurt, AB sunucuları kullanılmaktadır).\n'
              '• İyzico / Papara: Güvenli ödeme altyapısının sağlanması ve ödeme işlemlerinin gerçekleştirilmesi amacıyla.\n'
              '• Vercel: Uygulama hosting hizmetinin sağlanması amacıyla (AB sunucuları kullanılmaktadır).\n'
              '• Resmi Makamlar: Yasal zorunluluk hallerinde veya mahkeme kararı doğrultusunda yetkili kamu kurum ve kuruluşları ile.',
            ),
            
            _buildSection(
              '6. Yurt Dışına Veri Aktarımı',
              'Platform altyapısı olarak kullanılan Supabase ve Vercel sunucuları Avrupa Birliği (Frankfurt) bölgesinde yer almaktadır. Bu aktarımlar, veri güvenliğini en üst düzeyde tutan ve GDPR uyumlu olan altyapı sağlayıcıları üzerinden gerçekleştirilmektedir.',
            ),
            
            _buildSection(
              '7. Veri Saklama Süreleri',
              '• Hesap Verileri: Üyeliğiniz devam ettiği sürece ve üyelik sona erdikten sonra olası hukuki uyuşmazlıklar için 3 yıl süreyle saklanır.\n'
              '• Görseller: Platforma yüklenen ham ve optimize edilmiş görseller, işlem tamamlandıktan veya abonelik sonlandıktan sonra 30 gün içinde kalıcı olarak silinir.\n'
              '• Ödeme Kayıtları: Yasal mevzuat ve vergi kanunları uyarınca 10 yıl süreyle saklanır.\n'
              '• Log Kayıtları: 5651 sayılı kanun ve siber güvenlik gereksinimleri uyarınca 2 yıl süreyle saklanır.',
            ),
            
            _buildSection(
              '8. KVKK Kapsamında Haklarınız (Md. 11)',
              'Kişisel veri sahibi olarak KVKK Madde 11 uyarınca şu haklara sahipsiniz:\n'
              '• Verilerinizin işlenip işlenmediğini öğrenme,\n'
              '• İşlenmişse bilgi talep etme,\n'
              '• İşlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme,\n'
              '• Yurt içinde veya yurt dışında aktarıldığı üçüncü kişileri bilme,\n'
              '• Eksik veya yanlış işlenmişse düzeltilmesini isteme,\n'
              '• KVKK kurallarına uygun olarak silinmesini veya yok edilmesini isteme,\n'
              '• Düzeltme veya silme işlemlerinin verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,\n'
              '• Otomatik sistemlerle analiz edilerek aleyhinize bir sonucun çıkmasına itiraz etme,\n'
              '• Kanuna aykırı işleme sebebiyle zarara uğramanız halinde zararın giderilmesini talep etme.',
            ),
            
            _buildSection(
              '9. Çerez Politikası',
              'Platformumuzda kullanıcı deneyimini iyileştirmek amacıyla çerezler kullanılmaktadır:\n'
              '• Zorunlu Çerezler: Oturum yönetimi ve güvenli giriş işlemlerinin yapılabilmesi için gereklidir.\n'
              '• Analitik Çerezler: Google Analytics gibi araçlarla kullanıcı alışkanlıklarını analiz etmek için kullanılır.\n'
              '• Tercih Çerezleri: Dil seçimi ve kullanıcı tercihlerini hatırlamak amacıyla kullanılır.\n'
              'Tarayıcı ayarlarınız üzerinden çerezleri dilediğiniz zaman devre dışı bırakabilirsiniz.',
            ),
            
            _buildSection(
              '10. Güvenlik Önlemleri',
              'Verilerinizin güvenliğini korumak amacıyla aşağıdaki teknik ve idari tedbirler uygulanmaktadır:\n'
              '• Tüm veri trafiği SSL/TLS şifreleme protokolü ile korunur.\n'
              '• Veritabanı seviyesinde Supabase Satır Düzeyinde Güvenlik (Row Level Security - RLS) uygulanmaktadır.\n'
              '• Düzenli siber güvenlik denetimleri ve sızma testleri gerçekleştirilir.\n'
              '• Çalışanların verilere erişimi rol bazlı yetkilendirme ile sınırlandırılmıştır.',
            ),
            
            _buildSection(
              '11. Veri İhlali Bildirimi',
              'Olası bir siber saldırı veya veri ihlali durumunda, durumun tespit edilmesini takip eden 72 saat içerisinde KVKK Kurumu\'na ve etkilenen kullanıcılara e-posta veya web sitesi duyurusu yoluyla bildirim yapılacaktır.',
            ),
            
            _buildSection(
              '12. Başvuru Yöntemi',
              'KVKK kapsamındaki haklarınızı kullanmak için başvurularınızı info@titlora.com yazılı adresine veya doğrudan KVKK süreçleri için ayrılmış olan KVKKbasvuru@titlora.com adresine güvenli elektronik imza veya kayıtlı e-posta adresiniz üzerinden iletebilirsiniz. Başvurularınız en geç 30 gün içinde ücretsiz olarak sonuçlandırılacaktır.',
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
              '1. Data Controller',
              'Under the Law on the Protection of Personal Data No. 6698 (KVKK) and GDPR, Titlora (AI Product Studio) acts as the Data Controller. For any inquiries regarding our data processing activities, you can contact us at info@titlora.com.',
            ),
            
            _buildSection(
              '2. Personal Data Collected',
              'The following personal data is processed by us during your use of the Titlora platform:\n'
              '• Identity Information: First name, last name.\n'
              '• Contact Information: Email address.\n'
              '• Transaction Information: Subscription details and payment logs (credit card data is securely stored by our payment gateway partners).\n'
              '• Usage Data: IP address, device specifications, cookie records, and platform activity data.\n'
              '• Content Data: Product images uploaded to the platform and text descriptions you input.',
            ),
            
            _buildSection(
              '3. Purposes of Processing Personal Data',
              'Your personal data is processed for the following purposes:\n'
              '• Provision of Services: Running AI-based image background removal, optimization, and text generation processes.\n'
              '• Subscription Management: Processing payments, invoicing, and checking subscription statuses.\n'
              '• Customer Support: Troubleshooting, responding to user requests, and communication.\n'
              '• Legal Obligations: Complying with tax regulations, internet access logs under Law No. 5651, and court orders.\n'
              '• Security: Preventing abuse of the platform and ensuring cyber security.',
            ),
            
            _buildSection(
              '4. Legal Basis for Processing (KVKK Art. 5 / GDPR Art. 6)',
              'Your personal data is processed based on the following legal grounds:\n'
              '• Performance of a Contract: Processing is necessary for the performance of the user agreement and the provision of services.\n'
              '• Legitimate Interest: Processing is necessary for our legitimate interests, such as platform security and performance optimization, provided that it does not override your fundamental rights and freedoms.\n'
              '• Explicit Consent: Obtaining your consent for marketing campaigns, newsletters, and new feature announcements.',
            ),
            
            _buildSection(
              '5. Sharing Data with Third Parties',
              'Your personal data is shared only to the extent necessary and strictly for service delivery or compliance with legal obligations with the following processors:\n'
              '• Photoroom API: To perform background cleanups and image optimizations.\n'
              '• OpenAI: To generate AI-powered product descriptions and marketing texts.\n'
              '• Supabase: For secure data storage (hosted on servers in Frankfurt, EU).\n'
              '• Iyzico / Papara: To provide payment gateway integration and process transaction fees.\n'
              '• Vercel: For application hosting services (hosted on servers in the EU).\n'
              '• Official Authorities: Sharing data with public institutions and judicial bodies if legally required or requested via court order.',
            ),
            
            _buildSection(
              '6. Cross-Border Data Transfer',
              'The Supabase and Vercel servers used as platform infrastructure are located in the European Union (Frankfurt). These transfers are carried out through GDPR-compliant infrastructure providers that enforce industry-standard data security controls.',
            ),
            
            _buildSection(
              '7. Data Retention Periods',
              '• Account Data: Maintained during your active membership and for 3 years after cancellation for potential legal disputes.\n'
              '• Images: Raw and optimized product images uploaded to the platform are permanently deleted within 30 days after the task is processed or after the subscription ends.\n'
              '• Payment Records: Maintained for 10 years in compliance with tax regulations and commercial laws.\n'
              '• Log Records: Maintained for 2 years in accordance with Law No. 5651 and cyber security needs.',
            ),
            
            _buildSection(
              '8. Your Rights Under KVKK (Art. 11) / GDPR',
              'As a data subject, you have the following rights under Article 11 of the KVKK:\n'
              '• To learn whether your personal data is processed,\n'
              '• To request information if your data has been processed,\n'
              '• To learn the purpose of processing and whether data is used appropriately,\n'
              '• To know the third parties in the country or abroad to whom data is transferred,\n'
              '• To request correction of incomplete or inaccurate data,\n'
              '• To request erasure or destruction under the KVKK provisions,\n'
              '• To request notification of corrections or deletions to third parties to whom data was transferred,\n'
              '• To object to decisions based solely on automated profiling,\n'
              '• To claim compensation for damages incurred due to unlawful processing.',
            ),
            
            _buildSection(
              '9. Cookie Policy',
              'We use cookies to improve user experience on our platform:\n'
              '• Strictly Necessary Cookies: Essential for session management and secure logins.\n'
              '• Analytical Cookies: Used to analyze user trends using tools like Google Analytics.\n'
              '• Preference Cookies: Used to remember user settings like preferred language.\n'
              'You can disable cookies at any time via your browser settings.',
            ),
            
            _buildSection(
              '10. Security Measures',
              'We apply the following technical and administrative measures to protect your personal data:\n'
              '• All network traffic is encrypted using SSL/TLS protocols.\n'
              '• Row Level Security (RLS) is active at the database layer on Supabase.\n'
              '• Cyber security audits and penetration testing are performed regularly.\n'
              '• Access to database assets is restricted to authorized employees on a role-based level.',
            ),
            
            _buildSection(
              '11. Data Breach Notification',
              'In the event of a security breach or cyber attack resulting in a data leak, we will notify the Turkish KVKK Board and affected users within 72 hours of detection via email or website announcements.',
            ),
            
            _buildSection(
              '12. Application Method',
              'To exercise your rights under the KVKK, you can submit your requests to info@titlora.com or directly to our dedicated KVKK address: KVKKbasvuru@titlora.com using a secure electronic signature or your registered email address. Your requests will be answered free of charge within 30 days.',
            ),
          ],
        ),
      ),
    );
  }
}
