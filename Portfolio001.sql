--Total Keluarga per Kabupaten/Kota
SELECT kabupaten_kota, SUM(jumlah) AS TotalKepalaKeluarga
FROM Portfolio001..JenisKelamin_KepalaKeluarga
GROUP BY kabupaten_kota

--Kepala keluarga tidak bersekolah VS tidak bersekolah
SELECT jen.kabupaten_kota, pen.pendidikan, SUM(pen.jumlah) AS Total_TidakSekolah, SUM(jen.jumlah) Total_Keluarga, ROUND(((SUM(jen.jumlah)/SUM(pen.jumlah))*100),2) Persentase
FROM Portfolio001..JenisKelamin_KepalaKeluarga jen
JOIN Portfolio001..Pendidikan pen
	ON jen.kabupaten_kota = pen.nama_kabupaten AND jen.pendidikan = pen.pendidikan
WHERE pen.pendidikan = 'Tidak/Belum Sekolah'
GROUP BY jen.kabupaten_kota, pen.pendidikan

--Kelurahan dengan tingkat tidak/belum sekolah tertinggi
SELECT nama_kabupaten, nama_kelurahan, MAX(jumlah) Jumlah_Tertinggi, ROUND(((MAX(jumlah)*100)/9986828),2) Persentase
FROM Portfolio001..Pendidikan
WHERE pendidikan = 'Tidak/Belum Sekolah'
GROUP BY nama_kabupaten, nama_kelurahan
ORDER BY 3 DESC
--Jumlah tidak/belum sekolah
SELECT SUM(jumlah)
FROM Portfolio001..Pendidikan

--Pendidikan Kepala keluarga
SELECT kabupaten_kota, pendidikan, SUM(jumlah) TotalKeluarga, ROUND((SUM(jumlah)*100/3614985),3) Persentase
FROM Portfolio001..JenisKelamin_KepalaKeluarga 
GROUP BY kabupaten_kota, pendidikan
ORDER BY 1, 3 DESC
--Jumlah Kepala Keluarga
SELECT SUM(jumlah) AS TotalKepalaKeluarga
FROM Portfolio001..JenisKelamin_KepalaKeluarga

--Menggunakan CTE
WITH PendidikanKK (Kota, Pendidikan, Total, Total_KepalaKeluarga, Persentase)
AS
(
SELECT jen.kabupaten_kota, pen.pendidikan, SUM(pen.jumlah) AS Total, SUM(jen.jumlah) Total_KepalaKeluarga, ROUND(((SUM(jen.jumlah)/SUM(pen.jumlah))*100),2) Persentase
FROM Portfolio001..JenisKelamin_KepalaKeluarga jen
JOIN Portfolio001..Pendidikan pen
	ON jen.kabupaten_kota = pen.nama_kabupaten AND jen.pendidikan = pen.pendidikan
GROUP BY jen.kabupaten_kota, pen.pendidikan
)
SELECT *
FROM PendidikanKK
WHERE Pendidikan = 'Tidak/Belum Sekolah'

--Menggunakan Temp Table
DROP TABLE IF EXISTS #PendidikanKepalaKeluarga
CREATE TABLE #PendidikanKepalaKeluarga
(
Kota nvarchar(255), 
Pendidikan nvarchar(255),
Total numeric, 
Total_KepalaKeluarga numeric, 
Persentase numeric
)
INSERT INTO #PendidikanKepalaKeluarga
	SELECT jen.kabupaten_kota, pen.pendidikan, SUM(pen.jumlah) AS Total, SUM(jen.jumlah) Total_KepalaKeluarga, ROUND(((SUM(jen.jumlah)/SUM(pen.jumlah))*100),2) Persentase
	FROM Portfolio001..JenisKelamin_KepalaKeluarga jen
	JOIN Portfolio001..Pendidikan pen
		ON jen.kabupaten_kota = pen.nama_kabupaten AND jen.pendidikan = pen.pendidikan
	GROUP BY jen.kabupaten_kota, pen.pendidikan
SELECT *
FROM #PendidikanKepalaKeluarga
WHERE Pendidikan = 'Tidak/Belum Sekolah'
--Persentase dari Tidak/Belum Sekolah yang merupakan Kepala Keluarga