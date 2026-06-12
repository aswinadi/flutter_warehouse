enum FieldType {
  text,
  number,
  date,
  boolean,
  selectCompany,
  selectTambak,
  selectBlok,
  selectModul,
  selectPond,
  selectCycle,
}

class FieldConfig {
  final String name;
  final String label;
  final FieldType type;
  final bool required;
  final String? placeholder;

  const FieldConfig({
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.placeholder,
  });
}

class ResourceConfig {
  final String title;
  final List<FieldConfig> formFields;
  final List<String> listFields;
  final String path;

  const ResourceConfig({
    required this.title,
    required this.formFields,
    required this.listFields,
    required this.path,
  });
}

final Map<String, ResourceConfig> aquacultureCrudConfigs = {
  'tambaks': ResourceConfig(
    title: 'Tambak',
    path: 'tambaks',
    listFields: ['name', 'company.company_name'],
    formFields: [
      FieldConfig(name: 'company_id', label: 'Perusahaan', type: FieldType.selectCompany, required: true),
      FieldConfig(name: 'name', label: 'Nama Tambak', type: FieldType.text, required: true),
    ],
  ),
  'bloks': ResourceConfig(
    title: 'Blok',
    path: 'bloks',
    listFields: ['name', 'code', 'tambak.name', 'tambak.company.company_name'],
    formFields: [
      FieldConfig(name: 'tambak_id', label: 'Tambak', type: FieldType.selectTambak, required: true),
      FieldConfig(name: 'name', label: 'Nama Blok', type: FieldType.text, required: true),
      FieldConfig(name: 'code', label: 'Kode Blok', type: FieldType.text),
    ],
  ),
  'moduls': ResourceConfig(
    title: 'Modul',
    path: 'moduls',
    listFields: ['name', 'code', 'blok.name', 'blok.tambak.name'],
    formFields: [
      FieldConfig(name: 'blok_id', label: 'Blok', type: FieldType.selectBlok, required: true),
      FieldConfig(name: 'name', label: 'Nama Modul', type: FieldType.text, required: true),
      FieldConfig(name: 'code', label: 'Kode Modul', type: FieldType.text),
      FieldConfig(
        name: 'jumlah_petak',
        label: 'Otomatis Buat Petak (Jumlah)',
        type: FieldType.number,
        placeholder: 'Contoh: 10 (isi 0 jika tidak ingin membuat)',
      ),
    ],
  ),
  'ponds': ResourceConfig(
    title: 'Petak',
    path: 'ponds',
    listFields: ['name', 'code', 'modul.name', 'modul.blok.tambak.name'],
    formFields: [
      FieldConfig(name: 'modul_id', label: 'Modul', type: FieldType.selectModul, required: true),
      FieldConfig(name: 'name', label: 'Nama Petak', type: FieldType.text, required: true),
      FieldConfig(name: 'code', label: 'Kode Petak', type: FieldType.text),
      FieldConfig(name: 'length', label: 'Panjang (m)', type: FieldType.number),
      FieldConfig(name: 'width', label: 'Lebar (m)', type: FieldType.number),
      FieldConfig(name: 'depth', label: 'Kedalaman (m)', type: FieldType.number),
      FieldConfig(name: 'luas', label: 'Luas', type: FieldType.number),
      FieldConfig(name: 'luas_m2', label: 'Luas (m2)', type: FieldType.number),
    ],
  ),
  'cycles': ResourceConfig(
    title: 'Siklus',
    path: 'cycles',
    listFields: ['name', 'stocking_date', 'is_active', 'company.company_name'],
    formFields: [
      FieldConfig(name: 'company_id', label: 'Perusahaan', type: FieldType.selectCompany, required: true),
      FieldConfig(name: 'modul_id', label: 'Modul', type: FieldType.selectModul, required: true),
      FieldConfig(name: 'name', label: 'Nama Siklus', type: FieldType.text, required: true),
      FieldConfig(name: 'stocking_date', label: 'Tanggal Tebar', type: FieldType.date, required: true),
      FieldConfig(name: 'estimated_end_date', label: 'Estimasi Tanggal Selesai', type: FieldType.date),
      FieldConfig(name: 'is_active', label: 'Siklus Aktif', type: FieldType.boolean),
      FieldConfig(name: 'google_sheet_feed_url', label: 'G-Sheet Feed URL', type: FieldType.text),
      FieldConfig(name: 'google_sheet_saprotam_url', label: 'G-Sheet Saprotam URL', type: FieldType.text),
    ],
  ),
  'contracts': ResourceConfig(
    title: 'Kontrak Jual Udang',
    path: 'contracts',
    listFields: ['name', 'contract_number', 'contract_date', 'seller_name', 'buyer_name', 'is_active'],
    formFields: [
      FieldConfig(name: 'company_id', label: 'Perusahaan', type: FieldType.selectCompany, required: true),
      FieldConfig(name: 'name', label: 'Nama Kontrak', type: FieldType.text, required: true),
      FieldConfig(name: 'contract_number', label: 'Nomor Kontrak', type: FieldType.text, required: true),
      FieldConfig(name: 'contract_date', label: 'Tanggal Kontrak', type: FieldType.date, required: true),
      FieldConfig(name: 'seller_name', label: 'Nama Penjual', type: FieldType.text),
      FieldConfig(name: 'buyer_name', label: 'Nama Pembeli', type: FieldType.text),
      FieldConfig(name: 'location', label: 'Lokasi Panen', type: FieldType.text),
      FieldConfig(name: 'harvest_tonnage', label: 'Estimasi Tonase (kg)', type: FieldType.number),
      FieldConfig(name: 'harvest_size_range', label: 'Range Size', type: FieldType.text),
      FieldConfig(name: 'harvest_date', label: 'Tanggal Panen', type: FieldType.date),
      FieldConfig(name: 'sampling_notes', label: 'Catatan Sampling', type: FieldType.text),
      FieldConfig(name: 'moulting_percentage', label: 'Persentase Moulting (%)', type: FieldType.number),
      FieldConfig(name: 'us_percentage', label: 'Persentase US (%)', type: FieldType.number),
      FieldConfig(name: 'payment_terms', label: 'Termin Pembayaran', type: FieldType.text),
      FieldConfig(name: 'bank_info', label: 'Info Rekening Bank', type: FieldType.text),
      FieldConfig(name: 'other_terms', label: 'Ketentuan Lain', type: FieldType.text),
      FieldConfig(name: 'is_active', label: 'Kontrak Aktif', type: FieldType.boolean),
    ],
  ),
  'saprotam-logs': ResourceConfig(
    title: 'Saprotam Log',
    path: 'saprotam-logs',
    listFields: ['product_name', 'amount', 'unit', 'date', 'pond.name', 'cycle.name'],
    formFields: [
      FieldConfig(name: 'pond_id', label: 'Petak / Kolam', type: FieldType.selectPond, required: true),
      FieldConfig(name: 'cycle_id', label: 'Siklus', type: FieldType.selectCycle, required: true),
      FieldConfig(name: 'date', label: 'Tanggal', type: FieldType.date, required: true),
      FieldConfig(name: 'product_name', label: 'Nama Produk Saprotam', type: FieldType.text, required: true),
      FieldConfig(name: 'amount', label: 'Jumlah Penggunaan', type: FieldType.number, required: true),
      FieldConfig(name: 'unit', label: 'Satuan (UOM)', type: FieldType.text),
    ],
  ),
  'cost-centres': ResourceConfig(
    title: 'Cost Centre',
    path: 'cost-centres',
    listFields: ['code', 'name', 'parent_code', 'luas_m2', 'is_active', 'company.company_name'],
    formFields: [
      FieldConfig(name: 'company_id', label: 'Perusahaan', type: FieldType.selectCompany, required: true),
      FieldConfig(name: 'code', label: 'Kode Cost Centre', type: FieldType.text, required: true),
      FieldConfig(name: 'name', label: 'Nama Cost Centre', type: FieldType.text, required: true),
      FieldConfig(name: 'parent_code', label: 'Kode Induk (Parent Code)', type: FieldType.text),
      FieldConfig(name: 'start_date', label: 'Tanggal Mulai', type: FieldType.date),
      FieldConfig(name: 'end_date', label: 'Tanggal Selesai', type: FieldType.date),
      FieldConfig(name: 'luas', label: 'Luas', type: FieldType.number),
      FieldConfig(name: 'luas_m2', label: 'Luas (m2)', type: FieldType.number),
      FieldConfig(name: 'is_active', label: 'Cost Centre Aktif', type: FieldType.boolean),
    ],
  ),
};
