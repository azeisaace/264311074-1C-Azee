-- =========================================================================
-- SISTEM PEMANTAUAN TRANSAKSI KEUANGAN & DETEKSI MONEY MULE (JOKI REKENING)
-- =========================================================================

-- 1. Tabel Induk Nasabah
CREATE TABLE tb_Nasabah (
    ID_Nasabah VARCHAR(20) NOT NULL PRIMARY KEY,
    Nama_Nasabah VARCHAR(100) NOT NULL,
    Jenis_Rekening VARCHAR(50) NOT NULL,
    Status_Nasabah VARCHAR(20) DEFAULT 'Aktif',
    Waktu_Pembekuan DATETIME DEFAULT NULL,
    Keterangan_Blokir VARCHAR(150) DEFAULT NULL
);

-- 2. Tabel Subtipe UMKM (Spesialisasi IS-A dari tb_Nasabah)
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

-- 3. Tabel Laporan Audit & Pemeriksaan
CREATE TABLE tb_Laporan (
    No_Laporan VARCHAR(20) NOT NULL PRIMARY KEY,
    Tanggal_Pemeriksaan DATE NOT NULL,
    Status_Laporan VARCHAR(50) NOT NULL
);

-- 4. Tabel Transaksi (Dilengkapi Role-Playing Foreign Key & Constraint Validasi)
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
  
    -- Menghubungkan ID_Pengirim ke tabel nasabah
    CONSTRAINT fk_transaksi_pengirim FOREIGN KEY (ID_Pengirim) 
        REFERENCES tb_Nasabah(ID_Nasabah)
        ON UPDATE CASCADE,
  
    -- Menghubungkan ID_Penerima ke tabel nasabah
    CONSTRAINT fk_transaksi_penerima FOREIGN KEY (ID_Penerima) 
        REFERENCES tb_Nasabah(ID_Nasabah)
        ON UPDATE CASCADE,
    
    -- Menghubungkan No_Laporan ke tabel laporan
    CONSTRAINT fk_transaksi_laporan FOREIGN KEY (No_Laporan) 
        REFERENCES tb_Laporan(No_Laporan) 
        ON DELETE SET NULL ON UPDATE CASCADE
);
