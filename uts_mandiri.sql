-- SISTEM PEMANTAUAN TRANSAKSI KEUANGAN & DETEKSI MONEY MULE

-- 1. Tabel Master Bank (tabel tambahan)
CREATE TABLE tb_Bank (
    Kode_Bank VARCHAR(10) NOT NULL PRIMARY KEY,
    Nama_Bank VARCHAR(100) NOT NULL,
    Jenis_Layanan VARCHAR(50) NOT NULL
);

-- 2. Tabel Induk Nasabah
CREATE TABLE tb_Nasabah (
    ID_Nasabah VARCHAR(20) NOT NULL PRIMARY KEY,
    Nama_Nasabah VARCHAR(100) NOT NULL,
    Jenis_Rekening VARCHAR(50) NOT NULL,
    Status_Nasabah VARCHAR(20) DEFAULT 'Aktif',
    Waktu_Pembekuan DATETIME DEFAULT NULL,
    Keterangan_Blokir VARCHAR(150) DEFAULT NULL,
    Kode_Bank VARCHAR(10) NOT NULL,
    CONSTRAINT fk_nasabah_bank FOREIGN KEY (Kode_Bank) 
        REFERENCES tb_Bank(Kode_Bank) ON UPDATE CASCADE
);

-- 3. Tabel Subtipe UMKM (Spesialisasi IS-A dari tb_Nasabah)
CREATE TABLE tb_Nasabah_UMKM (
    ID_Nasabah VARCHAR(20) NOT NULL PRIMARY KEY,
    Jenis_Usaha VARCHAR(50),
    Omzet_Tahunan DECIMAL(15,2),
    NIB_IUMK VARCHAR(50),
    Kategori_UMKM VARCHAR(50),
    CONSTRAINT fk_umkm_nasabah FOREIGN KEY (ID_Nasabah) 
        REFERENCES tb_Nasabah(ID_Nasabah) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Tabel Subtipe Perorangan (Spesialisasi IS-A dari tb_Nasabah)
CREATE TABLE tb_Nasabah_Perorangan (
    ID_Nasabah VARCHAR(20) NOT NULL PRIMARY KEY,
    NIK VARCHAR(20),
    Pekerjaan VARCHAR(50),
    CONSTRAINT fk_perorangan_nasabah FOREIGN KEY (ID_Nasabah) 
        REFERENCES tb_Nasabah(ID_Nasabah) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. Tabel Laporan Audit & Rekapitulasi Investigasi
CREATE TABLE tb_Laporan (
    No_Laporan VARCHAR(20) NOT NULL PRIMARY KEY,
    Tanggal_Pemeriksaan DATE NOT NULL,
    Status_Laporan VARCHAR(50) NOT NULL,
    Jumlah_Transaksi INT NOT NULL DEFAULT 0,
    Total_Nominal DECIMAL(15,2) NOT NULL DEFAULT 0.00
);

-- 6. Tabel Transaksi (Role-Playing Foreign Key & Constraint Validasi)
CREATE TABLE tb_Transaksi (
    ID_Transaksi VARCHAR(20) NOT NULL PRIMARY KEY,
    Tanggal_Pengiriman DATE NOT NULL,
    Waktu_Transaksi DATETIME DEFAULT CURRENT_TIMESTAMP,
    Nominal DECIMAL(15,2) NOT NULL CHECK (Nominal > 0),
    Jenis_Transaksi VARCHAR(50) NOT NULL,
    Indikasi VARCHAR(100),
    Durasi_Mengendap_Menit INT DEFAULT 0,
    ID_Pengirim VARCHAR(20) NOT NULL,
    ID_Penerima VARCHAR(20) NOT NULL,
    No_Laporan VARCHAR(20) NULL,
  
    CONSTRAINT fk_transaksi_pengirim FOREIGN KEY (ID_Pengirim) 
        REFERENCES tb_Nasabah(ID_Nasabah) ON UPDATE CASCADE,
    CONSTRAINT fk_transaksi_penerima FOREIGN KEY (ID_Penerima) 
        REFERENCES tb_Nasabah(ID_Nasabah) ON UPDATE CASCADE,
    CONSTRAINT fk_transaksi_laporan FOREIGN KEY (No_Laporan) 
        REFERENCES tb_Laporan(No_Laporan) ON DELETE SET NULL ON UPDATE CASCADE
);
