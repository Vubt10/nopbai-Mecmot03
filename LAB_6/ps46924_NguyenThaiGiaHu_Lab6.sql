-- Bài 1:
USE QLDA;
GO
-- A. Lương phải > 15000 khi thêm nhân viên
CREATE OR ALTER TRIGGER trg_NhanVien_LuongLonHon15000
ON NHANVIEN
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE LUONG <= 15000)
    BEGIN
        RAISERROR(N'Lỗi: Lương phải > 15000', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO NHANVIEN(MANV, HONV, TENLOT, TENNV, PHAI, LUONG, NGSINH, DCHI)
VALUES ('012', N'Nguyễn', N'Văn', N'An', N'Nam', 10000, '1990-01-01', N'Hà Nội');
GO

-- B. Tuổi phải trong khoảng 18 - 65
CREATE OR ALTER TRIGGER trg_NhanVien_TuoiHopLe
ON NHANVIEN
FOR INSERT
AS
BEGIN
    DECLARE @InvalidCount INT;

    SELECT @InvalidCount = COUNT(*)
    FROM inserted
    WHERE DATEDIFF(YEAR, NGSINH, GETDATE()) NOT BETWEEN 18 AND 65;

    IF @InvalidCount > 0
    BEGIN
        RAISERROR(N'Lỗi: Tuổi nhân viên phải từ 18 đến 65!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO NHANVIEN(MANV, HONV, TENLOT, TENNV, PHAI, NGSINH, DCHI, LUONG, PHG, MA_NQL)
VALUES ('013', N'Lê', N'Thị', N'Hoa', N'Nữ', '2010-05-10', N'Hải Phòng', 20000, 5, '005');
GO

-- C. Không cho cập nhật nhân viên ở TpHCM
CREATE OR ALTER TRIGGER trg_KhongCapNhat_TPHCM
ON NHANVIEN
FOR UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE DCHI LIKE N'%TP HCM%')
    BEGIN
        RAISERROR(N'Không được phép cập nhật nhân viên ở TP HCM!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

UPDATE NHANVIEN SET LUONG = 60000 WHERE DCHI LIKE N'%TP HCM%';GO

-- Bài 2:
-- A. Hiển thị tổng số nhân viên Nam/Nữ sau khi thêm mới nhân viên
CREATE OR ALTER TRIGGER trg_ThongKeGioiTinh_AfterInsert
ON NHANVIEN
AFTER INSERT
AS
BEGIN
    DECLARE @TongNam INT, @TongNu INT;

    SELECT 
        @TongNam = COUNT(*) 
        FROM NHANVIEN 
        WHERE PHAI = N'Nam';

    SELECT 
        @TongNu = COUNT(*) 
        FROM NHANVIEN 
        WHERE PHAI = N'Nữ';

    PRINT N'==> Sau khi thêm mới nhân viên:';
    PRINT N'Tổng số nhân viên Nam: ' + CAST(@TongNam AS NVARCHAR(10));
    PRINT N'Tổng số nhân viên Nữ: ' + CAST(@TongNu AS NVARCHAR(10));
END;
GO

INSERT INTO NHANVIEN(MANV, HONV, TENNV, PHAI, LUONG, NGSINH, DCHI)
VALUES ('015', N'Nguyễn', N'Hà', N'Nữ', 20000, '1999-10-10', N'Hà Nội');GO

-- B. Hiển thị tổng số nhân viên Nam/Nữ sau khi cập nhật giới tính
CREATE OR ALTER TRIGGER trg_ThongKeGioiTinh_AfterUpdate
ON NHANVIEN
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra xem có cập nhật cột giới tính hay không
    IF UPDATE(PHAI)
    BEGIN
        DECLARE @TongNam INT, @TongNu INT;

        SELECT 
            @TongNam = COUNT(*) 
            FROM NHANVIEN 
            WHERE PHAI = N'Nam';

        SELECT 
            @TongNu = COUNT(*) 
            FROM NHANVIEN 
            WHERE PHAI = N'Nữ';

        PRINT N'==> Sau khi cập nhật giới tính nhân viên:';
        PRINT N'Tổng số nhân viên Nam: ' + CAST(@TongNam AS NVARCHAR(10));
        PRINT N'Tổng số nhân viên Nữ: ' + CAST(@TongNu AS NVARCHAR(10));
    END
END;
GO

UPDATE NHANVIEN SET PHAI = N'Nam' WHERE MANV = '015';GO

-- C. Hiển thị tổng số đề án mỗi nhân viên đã làm sau khi xóa đề án
CREATE OR ALTER TRIGGER trg_ThongKeDeAn_AfterDelete
ON DEAN
AFTER DELETE
AS
BEGIN
    PRINT N'==> Sau khi xóa đề án:';

    SELECT 
        pc.MA_NVIEN AS MaNhanVien,
        COUNT(DISTINCT pc.MADA) AS TongSoDeAn
    FROM PHANCONG pc
    GROUP BY pc.MA_NVIEN;
END;
GO

DELETE FROM DEAN WHERE MADA = 'DA05';GO

-- Bài 3: Viết các trigger INSTEAD OF
-- A. Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân viên trong bảng nhân viên
CREATE OR ALTER TRIGGER trg_XoaNhanVien_XoaThanNhan
ON NHANVIEN
INSTEAD OF DELETE
AS
BEGIN
    -- Xóa thân nhân của nhân viên bị xóa
    DELETE FROM THANNHAN
    WHERE MA_NVIEN IN (SELECT MANV FROM deleted);

    -- Sau đó xóa nhân viên
    DELETE FROM NHANVIEN
    WHERE MANV IN (SELECT MANV FROM deleted);

    PRINT N'Đã xóa nhân viên và các thân nhân liên quan.';
END;
GO

DELETE FROM NHANVIEN WHERE MANV = '009';go

-- B. Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA là 1.
CREATE OR ALTER TRIGGER trg_ThemNhanVien_PhanCong
ON NHANVIEN
INSTEAD OF INSERT
AS
BEGIN
    -- B1: Chèn nhân viên mới vào bảng NHANVIEN
    INSERT INTO NHANVIEN (MANV, HONV, TENLOT, TENNV, PHAI, NGSINH, DCHI, LUONG, PHG, MA_NQL)
    SELECT MANV, HONV, TENLOT, TENNV, PHAI, NGSINH, DCHI, LUONG, PHG, MA_NQL
    FROM inserted;

    -- B2: Phân công nhân viên mới vào đề án có MADA = 1
    INSERT INTO PHANCONG (MA_NVIEN, MADA, THOIGIAN)
    SELECT MANV, 1, 10.0   -- giả sử 10 giờ/tuần ban đầu
    FROM inserted;

    PRINT N'Đã thêm nhân viên và tự động phân công vào đề án MADA = 1.';
END;
GO

INSERT INTO NHANVIEN (MANV, HONV, TENLOT, TENNV, PHAI, NGSINH, DCHI, LUONG, PHG, MA_NQL)
VALUES ('015', N'Phạm', N'Thanh', N'Long', N'Nam', '1992-04-01', N'Đà Nẵng', 28000, 5, '005');
