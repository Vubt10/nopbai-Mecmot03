use QLDA;

-- Chương trình tính diện tích, chu vi hình chữ nhật khi biết chiều dài và chiều rộng.
-- Khai báo biến
DECLARE @ChieuDai FLOAT, @ChieuRong FLOAT, @DienTich FLOAT, @ChuVi FLOAT;

-- Gán giá trị (ví dụ: dài = 10, rộng = 5)
SET @ChieuDai = 10;
SET @ChieuRong = 5;

-- Tính toán
SET @DienTich = @ChieuDai * @ChieuRong;
SET @ChuVi = 2 * (@ChieuDai + @ChieuRong);

-- Xuất kết quả
PRINT N'Chiều dài = ' + CAST(@ChieuDai AS VARCHAR(10));
PRINT N'Chiều rộng = ' + CAST(@ChieuRong AS VARCHAR(10));
PRINT N'Diện tích = ' + CAST(@DienTich AS VARCHAR(10));
PRINT N'Chu vi = ' + CAST(@ChuVi AS VARCHAR(10));


-- 1. Cho biêt nhân viên có lương cao nhất
SELECT *
FROM NHANVIEN
WHERE LUONG = (SELECT MAX(LUONG) FROM NHANVIEN);
-- 2. Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng "Nghiên cứu” (Biến vô hướng và biến bảng)

-- Biến vô hướng
DECLARE @LuongTB FLOAT;

-- Tính lương trung bình của phòng "Nghiên cứu"
SELECT @LuongTB = AVG(LUONG)
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
WHERE PB.TENPHG = N'Nghiên cứu';

-- Liệt kê nhân viên có lương > mức trung bình
SELECT HONV, TENLOT, TENNV, LUONG
FROM NHANVIEN
WHERE LUONG > @LuongTB;

-- Biến bảng
DECLARE @LuongTB TABLE (LuongTB FLOAT);

-- Lưu lương trung bình của phòng "Nghiên cứu"
INSERT INTO @LuongTB
SELECT AVG(LUONG)
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
WHERE PB.TENPHG = N'Nghiên cứu';

-- Liệt kê nhân viên có lương > mức trung bình
SELECT HONV, TENLOT, TENNV, LUONG
FROM NHANVIEN
WHERE LUONG > (SELECT LuongTB FROM @LuongTB);

-- 3. Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.
DECLARE @PhongLuongTB TABLE (
    TENPHG NVARCHAR(50),
    SoNV INT,
    LuongTB DECIMAL(10,2)
);

-- Tính lương TB + số NV theo phòng
INSERT INTO @PhongLuongTB
SELECT PB.TENPHG, COUNT(NV.MANV), AVG(NV.LUONG)
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
GROUP BY PB.TENPHG;

-- Xuất kết quả
SELECT TENPHG, SoNV, LuongTB
FROM @PhongLuongTB
WHERE LuongTB > 30000;

-- 4. Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì
DECLARE @PhongDeAn TABLE (
    TENPHG NVARCHAR(50),
    SoDeAn INT
);

-- Giả sử bảng DEAN có cột MAPHG là phòng chủ trì
INSERT INTO @PhongDeAn
SELECT PB.TENPHG, COUNT(DA.MADA)
FROM PHONGBAN PB
LEFT JOIN DEAN DA ON PB.MAPHG = DA.PHONGCHUTRI
GROUP BY PB.TENPHG;

-- Xuất kết quả
SELECT * FROM @PhongDeAn;

