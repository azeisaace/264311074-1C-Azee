-- Soal 1

-- Tabel Induk (Tabel Nasabah)
CREATE TABLE tb_Nasabah (
	ID_Nasabah INT primary key auto_increment,
	Nama_Nasabah VARCHAR(100) not null,
	Jenis_Rekening VARCHAR(50),
	Status_Nasabah VARCHAR(20) default 'Aktif'
);

-- Tabel Transaksi
create table tb_Transaksi (
	ID_Transaksi INT primary key not null,
	ID_Pengirim INT not null,
	ID_Penerima INT not null,
	Nominal DECIMAL(15,2) not null, 
	Tanggal_Pengiriman DATETIME default current_timestamp,
	Indikasi VARCHAR(50),
	No_laporan INT null,
  
-- Menghubungkan ID_Pengirim ke tabel nasabah
	foreign key (ID_Pengirim) references 
tb_Nasabah(ID_Nasabah),
  
-- Menghubungkan ID_Penerima ke tabel nasabah
	foreign key (ID_Penerima) references 
tb_Nasabah(ID_Nasabah)
);

-- Tabel Induk (Tabel Laporan)
create table tb_Laporan (
	No_Laporan INT primary key auto_increment,
	Jumlah_Transaksi int not null,
  Total_Nominal decimal(15,2) not null,
  foreign key (No_Laporan) 
  references tb_Nasabah(ID_Nasabah)
);

-- Soal 2

-- isi tabel nasabah
insert into tb_Nasabah (ID_Nasabah, Nama_Nasabah, Jenis_Rekening, Status_Nasabah) values 
(1, 'Andi Pratama', 'Perorangan', 'Aktif'),
(2, 'Budi Santoso', 'Perorangan', 'Aktif'),
(3, 'Citra Mandiri', 'Perusahaaan', 'Aktif'),
);

-- isi tabel transaksi
insert into tb_Transaksi (ID_Transaksi, ID_Pengirim, ID_Penerima, Nominal, Tanggal_Pengiriman, Indikasi, No_laporan) values 
('TRX001', 1001, 1002, 5000000.00, '2026-10-01 08:30:00', 'Transaksi berantai', 1),
('TRX002', 1002, 1003, 2300000.00, '2026-10-02 10:15:45', 'Transaksi berantai', 2),
('TRX003', 1003, 1004, 2000000.00, '2026-10-05 14:00:00', 'Membentuk siklus', 3)
);

-- isi tabel laporan
insert into tb_Laporan (No_Laporan, Tanggal_Pemeriksaan, Status_Laporan) values 
(1, '2026-10-05', 'Sedang diperiksa'),
(2, '2026-10-10', 'Sedang diperiksa'),
(3, '2026-10-05', 'Perlu pemeriksaan lebih lanjut');

-- Perintah read
select * from tb_Nasabah;

-- Perintah Update
update tb_Transaksi
set Indikasi = 'Layering'
where id = 'TRX003';

-- Perintah Delete
delete from tb_Transaksi
where id = 'TRX001';

-- Soal 3
select 
tb_nasabah.Nama_nasabah,
count(tb_Transaksi.ID_transaksi) as Total_Jumlah_Transaksi,
sum(tb_Transaksi.Nominal) as Total_Nominal_Transaksi
from tbttransaksi
join tb_Nasabah on tb_Transaksi.ID_Pengirim = tb_Nasabah.Id_Nasabah
where tb_Transaksi.No_Laporan is not null
group by tb_Nasabah.Nama_Nasabah;
