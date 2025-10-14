-- Bài 1:
-- A. In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của bạn.
CREATE OR ALTER PROCEDURE XinChao
    @Ten NVARCHAR(50)
AS
BEGIN
    PRINT N'Xin chào ' + CAST(@Ten AS NVARCHAR(50));
END;
GO

-- Gọi chạy:
EXEC XinChao N'Nguyễn Thái Giả Hủ';go;

-- B. Tính tổng 2 số
CREATE OR ALTER PROCEDURE TinhTong
    @s1 INT,
    @s2 INT
AS
BEGIN
    DECLARE @tg INT;
    SET @tg = @s1 + @s2;
    PRINT N'Tổng là: ' + CAST(@tg AS NVARCHAR(10));
END;
GO

-- Gọi chạy:
EXEC TinhTong 5, 7;go;

-- C. Tính tổng các số chẵn từ 1 đến @n
CREATE OR ALTER PROCEDURE TongChan
    @n INT
AS
BEGIN
    DECLARE @i INT = 1, @tong INT = 0;

    WHILE @i <= @n
    BEGIN
        IF @i % 2 = 0
            SET @tong = @tong + @i;
        SET @i = @i + 1;
    END

    PRINT N'Tổng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR(10)) + N' là: ' + CAST(@tong AS NVARCHAR(10));
END;
GO

-- Gọi chạy:
EXEC TongChan 20;go;

-- D. Tìm UCLN
CREATE OR ALTER PROCEDURE TimUCLN
    @a INT,
    @b INT
AS
BEGIN
    DECLARE @temp INT;

    -- Đảm bảo a <= b
    IF @a > @b
    BEGIN
        SET @temp = @a;
        SET @a = @b;
        SET @b = @temp;
    END

    -- Dùng vòng lặp để tính UCLN
    WHILE @a <> 0
    BEGIN
        SET @temp = @a;
        SET @a = @b % @a;
        SET @b = @temp;
    END

    PRINT N'Ước chung lớn nhất là: ' + CAST(@b AS NVARCHAR(10));
END;
GO

-- Gọi chạy:
EXEC TimUCLN 12, 20;go

-- Bài 2: Sử dụng QLDA, Viết các Proc:
USE QLDA;GO

-- A. Xuất thông tin nhân viên theo mã
CREATE OR ALTER PROCEDURE XuatThongTinNV
    @MaNV CHAR(9)
AS
BEGIN
    SELECT *
    FROM NHANVIEN
    WHERE MANV = @MaNV;
END;
GO

-- Gọi chạy:
EXEC XuatThongTinNV '001';
GO

-- B. Đếm số lượng nhân viên tham gia đề án theo mã @MaDA
CREATE OR ALTER PROCEDURE DemSoLuongTheoMaDA
    @MaDA INT
AS
BEGIN
    SELECT 
        @MaDA AS MaDeAn,
        COUNT(MANV) AS SoLuongNV
    FROM PHANCONG
    WHERE MADA = @MaDA
    GROUP BY MADA;
END;
GO

-- Gọi chạy:
EXEC DemSoLuongTheoMaDA 10;
GO

-- C. Đếm số lượng nhân viên tham gia đề án theo mã @MaDA và @DDIEM_DA
CREATE OR ALTER PROCEDURE DemSoLuongTheoMaVaDiaDiem
    @MaDA INT,
    @DDIEM_DA NVARCHAR(50)
AS
BEGIN
    SELECT 
        @MaDA AS MaDeAn,
        @DDIEM_DA AS DiaDiem,
        COUNT(PC.MANV) AS SoLuongNV
    FROM PHANCONG PC
    JOIN DEAN DA ON PC.MADA = DA.MADA
    WHERE DA.MADA = @MaDA AND DA.DDIEM_DA = @DDIEM_DA
    GROUP BY DA.MADA, DA.DDIEM_DA;
END;
GO

-- Gọi chạy:
EXEC DemSoLuongTheoMaVaDiaDiem 10, N'Hà Nội'; go

-- D. Liệt kê trưởng phòng là @Trgphg và không có thân nhân
CREATE OR ALTER PROCEDURE NVKhongThanNhanTheoTruongPhong
    @Trphg CHAR(9)
AS
BEGIN
    SELECT NV.MANV, NV.HONV, NV.TENLOT, NV.TENNV, NV.PHG
    FROM NHANVIEN NV
    JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
    WHERE PB.TRPHG = @Trphg
      AND NV.MANV NOT IN (SELECT DISTINCT MA_NVIEN FROM THANNHAN);
END;
GO

-- Gọi chạy:
EXEC NVKhongThanNhanTheoTruongPhong '005';go

-- E. Kiểm tra nhân viên có thuộc phòng ban hay không ?
CREATE OR ALTER PROCEDURE KiemTraNhanVienThuocPhong
    @MaNV CHAR(9),
    @MaPB INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM NHANVIEN
        WHERE MANV = @MaNV AND PHG = @MaPB
    )
        PRINT N'Nhân viên ' + @MaNV + N' thuộc phòng ban ' + CAST(@MaPB AS NVARCHAR(10));
    ELSE
        PRINT N'Nhân viên ' + @MaNV + N' KHÔNG thuộc phòng ban ' + CAST(@MaPB AS NVARCHAR(10));
END;
GO

-- Gọi chạy:
EXEC KiemTraNhanVienThuocPhong '001', 5;go

-- Bài 3:
use QLDA;go
-- A. Thêm phòng ban "CNTT", kiểm tra trùng mã phòng ban
CREATE OR ALTER PROCEDURE ThemPhongBan_CNTT
    @MaPHG INT,
    @TenPHG NVARCHAR(15),
    @TrPHG CHAR(9),
    @NgayNhanChuc DATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE MAPHG = @MaPHG)
        BEGIN
            PRINT N'Thêm thất bại! Mã phòng ban đã tồn tại.';
        END
        ELSE
        BEGIN
            INSERT INTO PHONGBAN (TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
            VALUES (@TenPHG, @MaPHG, @TrPHG, @NgayNhanChuc);

            PRINT N'Thêm dữ liệu thành công!';
        END
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: Thêm dữ liệu thất bại!';
    END CATCH
END;
GO

-- Chạy thử
EXEC ThemPhongBan_CNTT @MaPHG = 10, @TenPHG = N'CNTT', @TrPHG = '005', @NgayNhanChuc = '2020-01-01';

-- B. Cập nhật tên phòng ban "CNTT" thành "IT"
CREATE OR ALTER PROCEDURE CapNhatPhongBan_CNTT_IT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TENPHG = N'CNTT')
    BEGIN
        UPDATE PHONGBAN
        SET TENPHG = N'IT'
        WHERE TENPHG = N'CNTT';
        PRINT N'Đã cập nhật tên phòng ban từ CNTT → IT';
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy phòng ban CNTT để cập nhật.';
    END
END;
GO

-- Chạy thử
EXEC CapNhatPhongBan_CNTT_IT;GO

-- C. Thêm nhân viên mới với các điều kiện phức tạp
CREATE OR ALTER PROCEDURE ThemNhanVien_IT
    @MaNV CHAR(9),
    @HoNV NVARCHAR(15),
    @TenLot NVARCHAR(15),
    @TenNV NVARCHAR(15),
    @Phai NVARCHAR(3),
    @NgaySinh DATE,
    @DiaChi NVARCHAR(50),
    @Luong FLOAT,
    @Phong INT
AS
BEGIN
    DECLARE @Tuoi INT = DATEDIFF(YEAR, @NgaySinh, GETDATE());
    DECLARE @QuanLy CHAR(9);

    -- Kiểm tra phòng ban có phải là IT không
    IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MAPHG = @Phong AND TENPHG = N'IT')
    BEGIN
        PRINT N' Nhân viên phải thuộc phòng IT.';
        RETURN;
    END

    -- Xét điều kiện quản lý theo lương
    IF @Luong < 25000
        SET @QuanLy = '009';
    ELSE
        SET @QuanLy = '005';

    -- Kiểm tra điều kiện độ tuổi theo giới tính
    IF (@Phai = N'Nam' AND (@Tuoi < 18 OR @Tuoi > 65))
    BEGIN
        PRINT N' Nhân viên nam phải trong độ tuổi 18 - 65.';
        RETURN;
    END
    ELSE IF (@Phai = N'Nữ' AND (@Tuoi < 18 OR @Tuoi > 60))
    BEGIN
        PRINT N' Nhân viên nữ phải trong độ tuổi 18 - 60.';
        RETURN;
    END

    -- Nếu hợp lệ thì thêm nhân viên
    BEGIN TRY
        INSERT INTO NHANVIEN (MANV, HONV, TENLOT, TENNV, PHAI, NGSINH, DCHI, LUONG, MA_NQL, PHG)
        VALUES (@MaNV, @HoNV, @TenLot, @TenNV, @Phai, @NgaySinh, @DiaChi, @Luong, @QuanLy, @Phong);
        PRINT N' Thêm nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Thêm nhân viên thất bại!';
    END CATCH
END;
GO

-- 🔹 Chạy thử
EXEC ThemNhanVien_IT 
    @MaNV = '012', 
    @HoNV = N'Lê', 
    @TenLot = N'Văn', 
    @TenNV = N'An', 
    @Phai = N'Nam', 
    @NgaySinh = '1998-03-10', 
    @DiaChi = N'Đà Nẵng', 
    @Luong = 26000, 
    @Phong = 10;


















