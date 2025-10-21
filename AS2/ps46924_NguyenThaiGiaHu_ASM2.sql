-- =====================================
-- Y1: TẠO CƠ SỞ DỮ LIỆU
-- =====================================

-- Tạo CSDL
CREATE DATABASE QLNHATRO_PS46924;

USE QLNHATRO_PS46924;

-- TẠO BẢNG
-- Bảng LOAINHA
CREATE TABLE LOAINHA (
    MaLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(500) NULL
);

-- Bảng NGUOIDUNG
CREATE TABLE NGUOIDUNG (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    TenNguoiDung NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) NOT NULL CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    DienThoai VARCHAR(15) NOT NULL CHECK (DienThoai LIKE '[0-9]%'),
    SoNha NVARCHAR(50) NULL,
    TenDuong NVARCHAR(200) NULL,
    TenPhuong NVARCHAR(100) NULL,
    Quan NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NULL CHECK (Email LIKE '%@%.%'),
    NgayDangKy DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1
);

-- Bảng NHATRO
CREATE TABLE NHATRO (
    MaNhaTro INT IDENTITY(1,1) PRIMARY KEY,
    MaLoai INT NOT NULL,
    DienTich DECIMAL(6,2) NOT NULL CHECK (DienTich > 0),
    GiaPhong DECIMAL(12,2) NOT NULL CHECK (GiaPhong >= 0),
    SoNha NVARCHAR(50) NULL,
    TenDuong NVARCHAR(200) NULL,
    TenPhuong NVARCHAR(100) NULL,
    Quan NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(1000) NULL,
    NgayDangTin DATETIME NOT NULL DEFAULT GETDATE(),
    MaNguoiLienHe INT NOT NULL,
    TrangThai BIT DEFAULT 1,
    SoLuotXem INT DEFAULT 0,
    CONSTRAINT FK_NhaTro_LoaiNha FOREIGN KEY (MaLoai) REFERENCES LOAINHA(MaLoai),
    CONSTRAINT FK_NhaTro_NguoiDung FOREIGN KEY (MaNguoiLienHe) REFERENCES NGUOIDUNG(MaNguoiDung)
);

-- Bảng DANHGIA
CREATE TABLE DANHGIA (
    MaDanhGia INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDanhGia INT NOT NULL,
    MaNhaTro INT NOT NULL,
    LoaiDanhGia BIT NOT NULL, -- 1: LIKE, 0: DISLIKE
    NoiDung NVARCHAR(1000) NULL,
    NgayDanhGia DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_DanhGia_NguoiDung FOREIGN KEY (MaNguoiDanhGia) REFERENCES NGUOIDUNG(MaNguoiDung),
    CONSTRAINT FK_DanhGia_NhaTro FOREIGN KEY (MaNhaTro) REFERENCES NHATRO(MaNhaTro),
    CONSTRAINT UQ_DanhGia UNIQUE (MaNguoiDanhGia, MaNhaTro)
);

-- =====================================
-- Y2: THÊM DỮ LIỆU MẪU VÀO CÁC BẢNG
-- =====================================

-- NHẬP DỮ LIỆU BẢNG LOAINHA (Tối thiểu 3 bản ghi)
INSERT INTO LOAINHA (TenLoai, MoTa) VALUES
(N'Căn hộ chung cư', N'Căn hộ trong khu chung cư cao tầng, có đầy đủ tiện nghi'),
(N'Nhà riêng', N'Nhà nguyên căn cho thuê, có sân vườn riêng'),
(N'Phòng trọ khép kín', N'Phòng trọ có toilet riêng, khép kín'),
(N'Phòng trọ chung', N'Phòng trọ dùng chung nhà vệ sinh'),
(N'Studio', N'Căn hộ mini 1 phòng có gác lửng');

-- NHẬP DỮ LIỆU BẢNG NGUOIDUNG (Tối thiểu 10 bản ghi)
INSERT INTO NGUOIDUNG (TenNguoiDung, GioiTinh, DienThoai, SoNha, TenDuong, TenPhuong, Quan, Email) VALUES
(N'Nguyễn Văn Thắng', N'Nam', '0912345678', N'25', N'Láng Hạ', N'Thành Công', N'Quận Đống Đa', 'thang.nv@gmail.com'),
(N'Trần Thị Lan', N'Nữ', '0987654321', N'102', N'Giải Phóng', N'Đồng Tâm', N'Quận Hai Bà Trưng', 'lan.tt@yahoo.com'),
(N'Lê Hoàng Minh', N'Nam', '0909123456', N'48', N'Xuân Thủy', N'Dịch Vọng Hậu', N'Quận Cầu Giấy', 'minh.lh@outlook.com'),
(N'Phạm Thị Hoa', N'Nữ', '0938765432', N'15', N'Nguyễn Trãi', N'Thanh Xuân Trung', N'Quận Thanh Xuân', 'hoa.pt@gmail.com'),
(N'Hoàng Văn Tuấn', N'Nam', '0945678901', N'88', N'Láng', N'Láng Thượng', N'Quận Đống Đa', 'tuan.hv@hotmail.com'),
(N'Đỗ Thị Mai', N'Nữ', '0923456789', N'56', N'Trần Duy Hưng', N'Trung Hòa', N'Quận Cầu Giấy', 'mai.dt@gmail.com'),
(N'Vũ Quốc Anh', N'Nam', '0978123456', N'33', N'Tô Hiệu', N'Nghĩa Đô', N'Quận Cầu Giấy', 'anh.vq@yahoo.com'),
(N'Bùi Thị Thảo', N'Nữ', '0911222333', N'72', N'Phạm Văn Đồng', N'Mai Dịch', N'Quận Bắc Từ Liêm', 'thao.bt@gmail.com'),
(N'Ngô Minh Tuấn', N'Nam', '0988777666', N'19', N'Hoàng Quốc Việt', N'Nghĩa Tân', N'Quận Cầu Giấy', 'tuan.nm@outlook.com'),
(N'Đinh Thị Thu', N'Nữ', '0934567890', N'41', N'Nguyễn Xiển', N'Thanh Trì', N'Quận Hoàng Mai', 'thu.dt@gmail.com'),
(N'Trương Văn Hùng', N'Nam', '0969888777', N'65', N'Tôn Thất Tùng', N'Khương Thượng', N'Quận Đống Đa', 'hung.tv@yahoo.com'),
(N'Phan Thị Linh', N'Nữ', '0918765432', N'28', N'Lê Văn Lương', N'Nhân Chính', N'Quận Thanh Xuân', 'linh.pt@gmail.com');

-- NHẬP DỮ LIỆU BẢNG NHATRO (Tối thiểu 10 bản ghi)
INSERT INTO NHATRO (MaLoai, DienTich, GiaPhong, SoNha, TenDuong, TenPhuong, Quan, MoTa, NgayDangTin, MaNguoiLienHe, SoLuotXem) VALUES
(3, 25.5, 3500000, N'15', N'Nguyễn Khang', N'Yên Hòa', N'Quận Cầu Giấy', N'Phòng khép kín, có cửa sổ thoáng mát, gần trường ĐH Quốc Gia', '2025-09-15', 1, 45),
(1, 65.0, 8000000, N'88', N'Hoàng Quốc Việt', N'Nghĩa Tân', N'Quận Cầu Giấy', N'Căn hộ 2PN, full nội thất, view hồ Tây đẹp', '2025-09-20', 3, 78),
(2, 80.0, 12000000, N'42', N'Láng Hạ', N'Thành Công', N'Quận Đống Đa', N'Nhà riêng 3 tầng, có sân để xe rộng rãi', '2025-09-25', 2, 56),
(3, 20.0, 2800000, N'106', N'Giải Phóng', N'Đồng Tâm', N'Quận Hai Bà Trưng', N'Phòng trọ sinh viên, gần ĐH Bách Khoa, có máy lạnh', '2025-09-28', 4, 92),
(5, 30.0, 4500000, N'25', N'Trần Duy Hưng', N'Trung Hòa', N'Quận Cầu Giấy', N'Studio có gác lửng, đầy đủ nội thất hiện đại', '2025-10-01', 6, 64),
(4, 18.0, 2200000, N'78', N'Tôn Thất Tùng', N'Khương Thượng', N'Quận Đống Đa', N'Phòng trọ giá rẻ, gần bệnh viện Bạch Mai', '2025-08-10', 5, 34),
(3, 28.0, 3800000, N'52', N'Nguyễn Trãi', N'Thanh Xuân Nam', N'Quận Thanh Xuân', N'Phòng khép kín, ban công thoáng, gần BigC', '2025-08-18', 7, 48),
(1, 55.0, 7500000, N'19', N'Phạm Văn Đồng', N'Mai Dịch', N'Quận Bắc Từ Liêm', N'Chung cư 2PN, nội thất cơ bản, giá tốt', '2025-08-25', 8, 71),
(2, 100.0, 15000000, N'33', N'Hoàng Đạo Thúy', N'Nhân Chính', N'Quận Thanh Xuân', N'Nhà 4 tầng, mới xây, full nội thất cao cấp', '2025-09-05', 9, 29),
(3, 22.0, 3200000, N'67', N'Nguyễn Xiển', N'Thanh Trì', N'Quận Hoàng Mai', N'Phòng khép kín có gác xép, thích hợp cho 2 người', '2025-09-10', 10, 53),
(5, 35.0, 5000000, N'41', N'Lê Văn Lương', N'Mỹ Đình', N'Quận Bắc Từ Liêm', N'Studio cao cấp, view đẹp, gần Keangnam', '2025-09-18', 11, 87),
(4, 16.0, 2000000, N'95', N'Giải Phóng', N'Hoàng Liệt', N'Quận Hoàng Mai', N'Phòng trọ sinh viên giá rẻ, chung vệ sinh', '2025-08-05', 12, 41);

-- NHẬP DỮ LIỆU BẢNG DANHGIA (Tối thiểu 10 bản ghi)
INSERT INTO DANHGIA (MaNguoiDanhGia, MaNhaTro, LoaiDanhGia, NoiDung, NgayDanhGia) VALUES
(2, 1, 1, N'Phòng đẹp, sạch sẽ, chủ nhà thân thiện. Rất hài lòng!', '2025-09-16'),
(4, 1, 1, N'Vị trí thuận tiện, gần trường, đi lại dễ dàng', '2025-09-17'),
(5, 2, 1, N'Căn hộ view đẹp, thoáng mát, đầy đủ tiện nghi', '2025-09-21'),
(6, 2, 0, N'Giá hơi cao so với mặt bằng chung', '2025-09-22'),
(7, 3, 1, N'Nhà rộng rãi, có chỗ để xe thoải mái', '2025-09-26'),
(8, 4, 1, N'Phòng sạch, giá phải chăng cho sinh viên', '2025-09-29'),
(9, 4, 1, N'Gần trường, thuận tiện đi học', '2025-09-30'),
(10, 5, 1, N'Studio xinh xắn, nội thất đẹp', '2025-10-02'),
(11, 6, 0, N'Phòng hơi nhỏ, cách âm không tốt', '2025-08-12'),
(12, 7, 1, N'Phòng tốt, chủ nhà dễ tính', '2025-08-20'),
(1, 8, 1, N'Chung cư an ninh tốt, có thang máy', '2025-08-26'),
(3, 9, 1, N'Nhà đẹp, mới xây, rất hài lòng', '2025-09-06'),
(4, 10, 1, N'Phòng khá, giá hợp lý', '2025-09-11'),
(5, 11, 1, N'Studio sang trọng, view thành phố đẹp', '2025-09-19'),
(6, 12, 0, N'Vệ sinh chung không được sạch sẽ lắm', '2025-08-07'),
(1, 2, 1, N'Chủ nhà nhiệt tình, hỗ trợ tốt', '2025-09-23'),
(2, 3, 0, N'Xa trung tâm một chút', '2025-09-27'),
(3, 5, 1, N'Tiện nghi đầy đủ, rất đáng sống', '2025-10-02'),
(4, 7, 1, N'Gần siêu thị, đi chợ thuận tiện', '2025-08-21'),
(5, 8, 1, N'Giá tốt, phù hợp sinh viên', '2025-08-27');

-- =====================================
-- Y3: CHỨC NĂNG THÊM THÔNG TIN VÀO CÁC BẢNG
-- =====================================

-- 3.1. Tạo ba Stored Procedure để chèn dữ liệu vào các bảng

-- =====================================
-- SP 1: Stored Procedure chèn dữ liệu vào bảng NGUOIDUNG
-- =====================================
CREATE PROCEDURE SP_ThemNguoiDung
    @TenNguoiDung NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @DienThoai VARCHAR(15),
    @SoNha NVARCHAR(50) = NULL,
    @TenDuong NVARCHAR(200) = NULL,
    @TenPhuong NVARCHAR(100) = NULL,
    @Quan NVARCHAR(100),
    @Email VARCHAR(100) = NULL,
    @NgayDangKy DATETIME = NULL,
    @TrangThai BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra các tham số bắt buộc (NOT NULL)
    IF @TenNguoiDung IS NULL OR @TenNguoiDung = ''
    BEGIN
        PRINT N'Lỗi: Tên người dùng không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @GioiTinh IS NULL OR @GioiTinh = ''
    BEGIN
        PRINT N'Lỗi: Giới tính không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @DienThoai IS NULL OR @DienThoai = ''
    BEGIN
        PRINT N'Lỗi: Điện thoại không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @Quan IS NULL OR @Quan = ''
    BEGIN
        PRINT N'Lỗi: Quận không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    -- Kiểm tra ràng buộc giới tính
    IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
    BEGIN
        PRINT N'Lỗi: Giới tính phải là Nam, Nữ hoặc Khác. Vui lòng nhập đúng định dạng!';
        RETURN;
    END
    
    -- Kiểm tra định dạng điện thoại
    IF @DienThoai NOT LIKE '[0-9]%'
    BEGIN
        PRINT N'Lỗi: Điện thoại phải bắt đầu bằng số. Vui lòng nhập đúng định dạng!';
        RETURN;
    END
    
    -- Kiểm tra định dạng email nếu có
    IF @Email IS NOT NULL AND @Email NOT LIKE '%@%.%'
    BEGIN
        PRINT N'Lỗi: Email không đúng định dạng. Vui lòng nhập đúng định dạng email!';
        RETURN;
    END
    
    -- Thiết lập ngày đăng ký nếu không được truyền
    IF @NgayDangKy IS NULL
        SET @NgayDangKy = GETDATE();
    
    -- Thực hiện chèn dữ liệu
    BEGIN TRY
        INSERT INTO NGUOIDUNG (TenNguoiDung, GioiTinh, DienThoai, SoNha, TenDuong, TenPhuong, Quan, Email, NgayDangKy, TrangThai)
        VALUES (@TenNguoiDung, @GioiTinh, @DienThoai, @SoNha, @TenDuong, @TenPhuong, @Quan, @Email, @NgayDangKy, @TrangThai);
        
        PRINT N'Thành công: Đã thêm người dùng mới với ID = ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: Không thể thêm người dùng. ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- =====================================
-- SP 2: Stored Procedure chèn dữ liệu vào bảng NHATRO
-- =====================================
CREATE PROCEDURE SP_ThemNhaTro
    @MaLoai INT,
    @DienTich DECIMAL(6,2),
    @GiaPhong DECIMAL(12,2),
    @SoNha NVARCHAR(50) = NULL,
    @TenDuong NVARCHAR(200) = NULL,
    @TenPhuong NVARCHAR(100) = NULL,
    @Quan NVARCHAR(100),
    @MoTa NVARCHAR(1000) = NULL,
    @NgayDangTin DATETIME = NULL,
    @MaNguoiLienHe INT,
    @TrangThai BIT = 1,
    @SoLuotXem INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra các tham số bắt buộc (NOT NULL)
    IF @MaLoai IS NULL
    BEGIN
        PRINT N'Lỗi: Mã loại nhà không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @DienTich IS NULL
    BEGIN
        PRINT N'Lỗi: Diện tích không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @GiaPhong IS NULL
    BEGIN
        PRINT N'Lỗi: Giá phòng không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @Quan IS NULL OR @Quan = ''
    BEGIN
        PRINT N'Lỗi: Quận không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @MaNguoiLienHe IS NULL
    BEGIN
        PRINT N'Lỗi: Mã người liên hệ không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    -- Kiểm tra ràng buộc CHECK
    IF @DienTich <= 0
    BEGIN
        PRINT N'Lỗi: Diện tích phải lớn hơn 0. Vui lòng nhập đúng giá trị!';
        RETURN;
    END
    
    IF @GiaPhong < 0
    BEGIN
        PRINT N'Lỗi: Giá phòng phải lớn hơn hoặc bằng 0. Vui lòng nhập đúng giá trị!';
        RETURN;
    END
    
    -- Kiểm tra tồn tại của MaLoai trong bảng LOAINHA
    IF NOT EXISTS (SELECT 1 FROM LOAINHA WHERE MaLoai = @MaLoai)
    BEGIN
        PRINT N'Lỗi: Mã loại nhà không tồn tại. Vui lòng kiểm tra lại!';
        RETURN;
    END
    
    -- Kiểm tra tồn tại của MaNguoiLienHe trong bảng NGUOIDUNG
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaNguoiDung = @MaNguoiLienHe)
    BEGIN
        PRINT N'Lỗi: Mã người liên hệ không tồn tại. Vui lòng kiểm tra lại!';
        RETURN;
    END
    
    -- Thiết lập ngày đăng tin nếu không được truyền
    IF @NgayDangTin IS NULL
        SET @NgayDangTin = GETDATE();
    
    -- Thực hiện chèn dữ liệu
    BEGIN TRY
        INSERT INTO NHATRO (MaLoai, DienTich, GiaPhong, SoNha, TenDuong, TenPhuong, Quan, MoTa, NgayDangTin, MaNguoiLienHe, TrangThai, SoLuotXem)
        VALUES (@MaLoai, @DienTich, @GiaPhong, @SoNha, @TenDuong, @TenPhuong, @Quan, @MoTa, @NgayDangTin, @MaNguoiLienHe, @TrangThai, @SoLuotXem);
        
        PRINT N'Thành công: Đã thêm nhà trọ mới với ID = ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: Không thể thêm nhà trọ. ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- =====================================
-- SP 3: Stored Procedure chèn dữ liệu vào bảng DANHGIA
-- =====================================
CREATE PROCEDURE SP_ThemDanhGia
    @MaNguoiDanhGia INT,
    @MaNhaTro INT,
    @LoaiDanhGia BIT,
    @NoiDung NVARCHAR(1000) = NULL,
    @NgayDanhGia DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra các tham số bắt buộc (NOT NULL)
    IF @MaNguoiDanhGia IS NULL
    BEGIN
        PRINT N'Lỗi: Mã người đánh giá không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @MaNhaTro IS NULL
    BEGIN
        PRINT N'Lỗi: Mã nhà trọ không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    IF @LoaiDanhGia IS NULL
    BEGIN
        PRINT N'Lỗi: Loại đánh giá không được để trống. Vui lòng nhập đầy đủ thông tin!';
        RETURN;
    END
    
    -- Kiểm tra tồn tại của MaNguoiDanhGia trong bảng NGUOIDUNG
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaNguoiDung = @MaNguoiDanhGia)
    BEGIN
        PRINT N'Lỗi: Mã người đánh giá không tồn tại. Vui lòng kiểm tra lại!';
        RETURN;
    END
    
    -- Kiểm tra tồn tại của MaNhaTro trong bảng NHATRO
    IF NOT EXISTS (SELECT 1 FROM NHATRO WHERE MaNhaTro = @MaNhaTro)
    BEGIN
        PRINT N'Lỗi: Mã nhà trọ không tồn tại. Vui lòng kiểm tra lại!';
        RETURN;
    END
    
    -- Kiểm tra ràng buộc UNIQUE (một người chỉ đánh giá một nhà trọ một lần)
    IF EXISTS (SELECT 1 FROM DANHGIA WHERE MaNguoiDanhGia = @MaNguoiDanhGia AND MaNhaTro = @MaNhaTro)
    BEGIN
        PRINT N'Lỗi: Người dùng đã đánh giá nhà trọ này rồi. Mỗi người chỉ được đánh giá một lần!';
        RETURN;
    END
    
    -- Thiết lập ngày đánh giá nếu không được truyền
    IF @NgayDanhGia IS NULL
        SET @NgayDanhGia = GETDATE();
    
    -- Thực hiện chèn dữ liệu
    BEGIN TRY
        INSERT INTO DANHGIA (MaNguoiDanhGia, MaNhaTro, LoaiDanhGia, NoiDung, NgayDanhGia)
        VALUES (@MaNguoiDanhGia, @MaNhaTro, @LoaiDanhGia, @NoiDung, @NgayDanhGia);
        
        PRINT N'Thành công: Đã thêm đánh giá mới với ID = ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: Không thể thêm đánh giá. ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- =====================================
-- KIỂM THỬ CÁC STORED PROCEDURE
-- =====================================

PRINT N'========================================';
PRINT N'KIỂM THỬ SP_ThemNguoiDung';
PRINT N'========================================';

-- Test 1: Gọi thành công SP_ThemNguoiDung
PRINT N'Test 1: Thêm người dùng thành công';
EXEC SP_ThemNguoiDung 
    @TenNguoiDung = N'Lê Thị Hương', 
    @GioiTinh = N'Nữ', 
    @DienThoai = '0901234567', 
    @SoNha = N'123', 
    @TenDuong = N'Phố Huế', 
    @TenPhuong = N'Phương Liên', 
    @Quan = N'Quận Đống Đa', 
    @Email = 'huong.lt@gmail.com';

-- Test 2: Gọi lỗi SP_ThemNguoiDung (thiếu tên người dùng)
PRINT N'';
PRINT N'Test 2: Lỗi - thiếu tên người dùng';
EXEC SP_ThemNguoiDung 
    @TenNguoiDung = NULL, 
    @GioiTinh = N'Nam', 
    @DienThoai = '0987654321', 
    @Quan = N'Quận Cầu Giấy';

PRINT N'';
PRINT N'========================================';
PRINT N'KIỂM THỬ SP_ThemNhaTro';
PRINT N'========================================';

-- Test 3: Gọi thành công SP_ThemNhaTro
PRINT N'Test 3: Thêm nhà trọ thành công';
EXEC SP_ThemNhaTro 
    @MaLoai = 3, 
    @DienTich = 30.5, 
    @GiaPhong = 4000000, 
    @SoNha = N'456', 
    @TenDuong = N'Hoàng Cầu', 
    @TenPhuong = N'Ô Chợ Dừa', 
    @Quan = N'Quận Đống Đa', 
    @MoTa = N'Phòng trọ mới, sạch sẽ, có ban công', 
    @MaNguoiLienHe = 1;

-- Test 4: Gọi lỗi SP_ThemNhaTro (diện tích <= 0)
PRINT N'';
PRINT N'Test 4: Lỗi - diện tích không hợp lệ';
EXEC SP_ThemNhaTro 
    @MaLoai = 1, 
    @DienTich = -5, 
    @GiaPhong = 5000000, 
    @Quan = N'Quận Hoàn Kiếm', 
    @MaNguoiLienHe = 2;

PRINT N'';
PRINT N'========================================';
PRINT N'KIỂM THỬ SP_ThemDanhGia';
PRINT N'========================================';

-- Test 5: Gọi thành công SP_ThemDanhGia
PRINT N'Test 5: Thêm đánh giá thành công';
EXEC SP_ThemDanhGia 
    @MaNguoiDanhGia = 1, 
    @MaNhaTro = 5, 
    @LoaiDanhGia = 1, 
    @NoiDung = N'Nhà trọ rất tốt, chủ nhà thân thiện';

-- Test 6: Gọi lỗi SP_ThemDanhGia (đánh giá trùng lặp)
PRINT N'';
PRINT N'Test 6: Lỗi - người dùng đã đánh giá nhà trọ này';
EXEC SP_ThemDanhGia 
    @MaNguoiDanhGia = 2, 
    @MaNhaTro = 1, 
    @LoaiDanhGia = 0, 
    @NoiDung = N'Đánh giá thứ hai cho cùng nhà trọ';

PRINT N'';
PRINT N'========================================';
PRINT N'KẾT THÚC KIỂM THỬ Y3';
PRINT N'========================================';

-- =====================================
-- 3.2. TRUY VẤN THÔNG TIN
-- =====================================

-- =====================================
-- 3.2a. SP tìm kiếm phòng trọ với định dạng output theo yêu cầu
-- =====================================
CREATE PROCEDURE SP_TimKiemPhongTro
    @Quan NVARCHAR(100) = NULL,
    @DienTichMin DECIMAL(6,2) = NULL,
    @DienTichMax DECIMAL(6,2) = NULL,
    @NgayDangTinTu DATETIME = NULL,
    @NgayDangTinDen DATETIME = NULL,
    @GiaMin DECIMAL(12,2) = NULL,
    @GiaMax DECIMAL(12,2) = NULL,
    @MaLoai INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        -- Cột 1: Địa chỉ phòng trọ
        N'Cho thuê phòng trọ tại ' + 
        ISNULL(NT.SoNha + N', ', N'') + 
        ISNULL(NT.TenDuong + N', ', N'') + 
        ISNULL(NT.TenPhuong + N', ', N'') + 
        NT.Quan AS [Địa chỉ],
        
        -- Cột 2: Diện tích theo định dạng Việt Nam
        FORMAT(NT.DienTich, 'N1', 'vi-VN') + N' m2' AS [Diện tích],
        
        -- Cột 3: Giá phòng theo định dạng Việt Nam
        FORMAT(NT.GiaPhong, 'N0', 'vi-VN') AS [Giá phòng],
        
        -- Cột 4: Mô tả
        NT.MoTa AS [Mô tả],
        
        -- Cột 5: Ngày đăng tin định dạng dd-MM-yyyy
        FORMAT(NT.NgayDangTin, 'dd-MM-yyyy', 'vi-VN') AS [Ngày đăng tin],
        
        -- Cột 6: Tên người liên hệ theo giới tính
        CASE 
            WHEN ND.GioiTinh = N'Nam' THEN N'A. ' + ND.TenNguoiDung
            WHEN ND.GioiTinh = N'Nữ' THEN N'C. ' + ND.TenNguoiDung
            ELSE ND.TenNguoiDung
        END AS [Người liên hệ],
        
        -- Cột 7: Số điện thoại
        ND.DienThoai AS [Điện thoại],
        
        -- Cột 8: Địa chỉ người liên hệ
        ISNULL(ND.SoNha + N', ', N'') + 
        ISNULL(ND.TenDuong + N', ', N'') + 
        ISNULL(ND.TenPhuong + N', ', N'') + 
        ND.Quan AS [Địa chỉ liên hệ]
        
    FROM NHATRO NT
    INNER JOIN NGUOIDUNG ND ON NT.MaNguoiLienHe = ND.MaNguoiDung
    INNER JOIN LOAINHA LN ON NT.MaLoai = LN.MaLoai
    WHERE NT.TrangThai = 1
        AND (@Quan IS NULL OR NT.Quan LIKE N'%' + @Quan + N'%')
        AND (@DienTichMin IS NULL OR NT.DienTich >= @DienTichMin)
        AND (@DienTichMax IS NULL OR NT.DienTich <= @DienTichMax)
        AND (@NgayDangTinTu IS NULL OR NT.NgayDangTin >= @NgayDangTinTu)
        AND (@NgayDangTinDen IS NULL OR NT.NgayDangTin <= @NgayDangTinDen)
        AND (@GiaMin IS NULL OR NT.GiaPhong >= @GiaMin)
        AND (@GiaMax IS NULL OR NT.GiaPhong <= @GiaMax)
        AND (@MaLoai IS NULL OR NT.MaLoai = @MaLoai)
    ORDER BY NT.NgayDangTin DESC;
END;
GO

-- =====================================
-- 3.2b. Function tìm mã người dùng theo tất cả cột của bảng NGUOIDUNG
-- =====================================
CREATE FUNCTION FN_TimMaNguoiDung(
    @TenNguoiDung NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @DienThoai VARCHAR(15),
    @SoNha NVARCHAR(50),
    @TenDuong NVARCHAR(200),
    @TenPhuong NVARCHAR(100),
    @Quan NVARCHAR(100),
    @Email VARCHAR(100),
    @NgayDangKy DATETIME,
    @TrangThai BIT
)
RETURNS INT
AS
BEGIN
    DECLARE @MaNguoiDung INT;
    
    SELECT @MaNguoiDung = MaNguoiDung
    FROM NGUOIDUNG
    WHERE TenNguoiDung = @TenNguoiDung
        AND GioiTinh = @GioiTinh
        AND DienThoai = @DienThoai
        AND (SoNha = @SoNha OR (SoNha IS NULL AND @SoNha IS NULL))
        AND (TenDuong = @TenDuong OR (TenDuong IS NULL AND @TenDuong IS NULL))
        AND (TenPhuong = @TenPhuong OR (TenPhuong IS NULL AND @TenPhuong IS NULL))
        AND Quan = @Quan
        AND (Email = @Email OR (Email IS NULL AND @Email IS NULL))
        AND CAST(NgayDangKy AS DATE) = CAST(@NgayDangKy AS DATE)
        AND TrangThai = @TrangThai;
    
    RETURN ISNULL(@MaNguoiDung, -1);
END;
GO

-- =====================================
-- 3.2c. Function đếm tổng số LIKE và DISLIKE của nhà trọ
-- =====================================
CREATE FUNCTION FN_DemDanhGiaNhaTro(@MaNhaTro INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @SoLike INT, @SoDislike INT, @KetQua NVARCHAR(100);
    
    SELECT 
        @SoLike = SUM(CASE WHEN LoaiDanhGia = 1 THEN 1 ELSE 0 END),
        @SoDislike = SUM(CASE WHEN LoaiDanhGia = 0 THEN 1 ELSE 0 END)
    FROM DANHGIA
    WHERE MaNhaTro = @MaNhaTro;
    
    SET @SoLike = ISNULL(@SoLike, 0);
    SET @SoDislike = ISNULL(@SoDislike, 0);
    
    SET @KetQua = N'LIKE: ' + CAST(@SoLike AS NVARCHAR(10)) + N', DISLIKE: ' + CAST(@SoDislike AS NVARCHAR(10));
    
    RETURN @KetQua;
END;
GO

-- =====================================
-- 3.2d. View TOP 10 nhà trọ có nhiều LIKE nhất
-- =====================================
CREATE VIEW VW_Top10NhaTroYeuThich AS
SELECT TOP 10
    NT.DienTich,
    NT.GiaPhong AS [Giá],
    NT.MoTa AS [Mô tả],
    NT.NgayDangTin AS [Ngày đăng tin],
    ND.TenNguoiDung AS [Tên người liên hệ],
    ISNULL(ND.SoNha + N', ', N'') + 
    ISNULL(ND.TenDuong + N', ', N'') + 
    ISNULL(ND.TenPhuong + N', ', N'') + 
    ND.Quan AS [Địa chỉ],
    ND.DienThoai AS [Điện thoại],
    ND.Email
FROM NHATRO NT
INNER JOIN NGUOIDUNG ND ON NT.MaNguoiLienHe = ND.MaNguoiDung
LEFT JOIN (
    SELECT 
        MaNhaTro,
        SUM(CASE WHEN LoaiDanhGia = 1 THEN 1 ELSE 0 END) AS SoLike
    FROM DANHGIA
    GROUP BY MaNhaTro
) DG ON NT.MaNhaTro = DG.MaNhaTro
WHERE NT.TrangThai = 1
ORDER BY ISNULL(DG.SoLike, 0) DESC, NT.NgayDangTin DESC;
GO

-- =====================================
-- 3.2e. SP lấy thông tin đánh giá của nhà trọ
-- =====================================
CREATE PROCEDURE SP_LayDanhGiaNhaTro
    @MaNhaTro INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra nhà trọ có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM NHATRO WHERE MaNhaTro = @MaNhaTro)
    BEGIN
        PRINT N'Lỗi: Mã nhà trọ không tồn tại!';
        RETURN;
    END
    
    SELECT 
        DG.MaNhaTro AS [Mã nhà trọ],
        ND.TenNguoiDung AS [Tên người đánh giá],
        CASE 
            WHEN DG.LoaiDanhGia = 1 THEN N'LIKE'
            ELSE N'DISLIKE'
        END AS [Trạng thái],
        DG.NoiDung AS [Nội dung đánh giá]
    FROM DANHGIA DG
    INNER JOIN NGUOIDUNG ND ON DG.MaNguoiDanhGia = ND.MaNguoiDung
    WHERE DG.MaNhaTro = @MaNhaTro
    ORDER BY DG.NgayDanhGia DESC;
    
    -- Thống kê tổng quan
    DECLARE @TongLike INT, @TongDislike INT;
    SELECT 
        @TongLike = SUM(CASE WHEN LoaiDanhGia = 1 THEN 1 ELSE 0 END),
        @TongDislike = SUM(CASE WHEN LoaiDanhGia = 0 THEN 1 ELSE 0 END)
    FROM DANHGIA
    WHERE MaNhaTro = @MaNhaTro;
    
    PRINT N'Tổng kết: ' + CAST(ISNULL(@TongLike, 0) AS NVARCHAR(10)) + N' LIKE, ' + CAST(ISNULL(@TongDislike, 0) AS NVARCHAR(10)) + N' DISLIKE';
END;
GO

-- =====================================
-- KIỂM THỬ CÁC CHỨC NĂNG 3.2
-- =====================================

PRINT N'';
PRINT N'========================================';
PRINT N'KIỂM THỬ 3.2 - TRUY VẤN THÔNG TIN';
PRINT N'========================================';

-- Test 3.2a: SP tìm kiếm phòng trọ
PRINT N'';
PRINT N'Test 3.2a.1: Tìm kiếm phòng trọ theo quận Cầu Giấy, giá 3-5 triệu';
EXEC SP_TimKiemPhongTro 
    @Quan = N'Cầu Giấy', 
    @GiaMin = 3000000, 
    @GiaMax = 5000000;

PRINT N'';
PRINT N'Test 3.2a.2: Tìm kiếm tất cả phòng trọ loại Studio (MaLoai = 5)';
EXEC SP_TimKiemPhongTro @MaLoai = 5;

-- Test 3.2b: Function tìm mã người dùng
PRINT N'';
PRINT N'Test 3.2b: Tìm mã người dùng Nguyễn Văn Thắng';
DECLARE @MaNguoiDung INT;
SET @MaNguoiDung = dbo.FN_TimMaNguoiDung(
    N'Nguyễn Văn Thắng', N'Nam', '0912345678', N'25', 
    N'Láng Hạ', N'Thành Công', N'Quận Đống Đa', 
    'thang.nv@gmail.com', '2025-10-21', 1
);
PRINT N'Mã người dùng tìm được: ' + CAST(@MaNguoiDung AS NVARCHAR(10));

-- Test 3.2c: Function đếm đánh giá
PRINT N'';
PRINT N'Test 3.2c: Đếm đánh giá cho nhà trọ ID = 1';
PRINT N'Kết quả: ' + dbo.FN_DemDanhGiaNhaTro(1);

-- Test 3.2d: View TOP 10 nhà trọ yêu thích
PRINT N'';
PRINT N'Test 3.2d: Xem TOP 10 nhà trọ được yêu thích nhất';
SELECT * FROM VW_Top10NhaTroYeuThich;

-- Test 3.2e: SP lấy đánh giá nhà trọ
PRINT N'';
PRINT N'Test 3.2e: Lấy tất cả đánh giá của nhà trọ ID = 1';
EXEC SP_LayDanhGiaNhaTro @MaNhaTro = 1;

PRINT N'';
PRINT N'========================================';
PRINT N'KẾT THÚC KIỂM THỬ 3.2';
PRINT N'========================================';

-- =====================================
-- 3.3. XÓA THÔNG TIN
-- =====================================

-- =====================================
-- 3.3.1. SP xóa nhà trọ có số DISLIKE vượt quá ngưỡng cho phép
-- =====================================
CREATE PROCEDURE SP_XoaNhaTroTheoDislike
    @NgungDislike INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra tham số đầu vào
    IF @NgungDislike IS NULL OR @NgungDislike < 0
    BEGIN
        PRINT N'Lỗi: Ngưỡng DISLIKE phải là số nguyên dương!';
        RETURN;
    END
    
    -- Khai báo biến để lưu thông tin
    DECLARE @SoNhaTroXoa INT = 0;
    DECLARE @SoDanhGiaXoa INT = 0;
    DECLARE @DanhSachNhaTroXoa TABLE (MaNhaTro INT, SoDislike INT);
    
    -- Tìm danh sách nhà trọ cần xóa
    INSERT INTO @DanhSachNhaTroXoa (MaNhaTro, SoDislike)
    SELECT 
        NT.MaNhaTro,
        ISNULL(SUM(CASE WHEN DG.LoaiDanhGia = 0 THEN 1 ELSE 0 END), 0) AS SoDislike
    FROM NHATRO NT
    LEFT JOIN DANHGIA DG ON NT.MaNhaTro = DG.MaNhaTro
    GROUP BY NT.MaNhaTro
    HAVING ISNULL(SUM(CASE WHEN DG.LoaiDanhGia = 0 THEN 1 ELSE 0 END), 0) > @NgungDislike;
    
    -- Kiểm tra có nhà trọ nào cần xóa không
    SELECT @SoNhaTroXoa = COUNT(*) FROM @DanhSachNhaTroXoa;
    
    IF @SoNhaTroXoa = 0
    BEGIN
        PRINT N'Thông báo: Không có nhà trọ nào có số DISLIKE vượt quá ' + CAST(@NgungDislike AS NVARCHAR(10));
        RETURN;
    END
    
    -- Hiển thị danh sách nhà trọ sẽ bị xóa
    PRINT N'Danh sách ' + CAST(@SoNhaTroXoa AS NVARCHAR(10)) + N' nhà trọ sẽ bị xóa:';
    DECLARE @MaNhaTro INT, @SoDislike INT;
    DECLARE cur_NhaTroXoa CURSOR FOR SELECT MaNhaTro, SoDislike FROM @DanhSachNhaTroXoa;
    OPEN cur_NhaTroXoa;
    FETCH NEXT FROM cur_NhaTroXoa INTO @MaNhaTro, @SoDislike;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT N'- Nhà trọ ID: ' + CAST(@MaNhaTro AS NVARCHAR(10)) + N', DISLIKE: ' + CAST(@SoDislike AS NVARCHAR(10));
        FETCH NEXT FROM cur_NhaTroXoa INTO @MaNhaTro, @SoDislike;
    END
    CLOSE cur_NhaTroXoa;
    DEALLOCATE cur_NhaTroXoa;
    
    -- Bắt đầu giao dịch
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Đếm số đánh giá sẽ bị xóa
        SELECT @SoDanhGiaXoa = COUNT(*)
        FROM DANHGIA DG
        INNER JOIN @DanhSachNhaTroXoa DS ON DG.MaNhaTro = DS.MaNhaTro;
        
        -- Xóa đánh giá trước (do ràng buộc khóa ngoại)
        DELETE DG
        FROM DANHGIA DG
        INNER JOIN @DanhSachNhaTroXoa DS ON DG.MaNhaTro = DS.MaNhaTro;
        
        -- Xóa nhà trọ
        DELETE NT
        FROM NHATRO NT
        INNER JOIN @DanhSachNhaTroXoa DS ON NT.MaNhaTro = DS.MaNhaTro;
        
        -- Commit giao dịch
        COMMIT TRANSACTION;
        
        -- Thông báo kết quả
        PRINT N'Thành công: Đã xóa ' + CAST(@SoNhaTroXoa AS NVARCHAR(10)) + N' nhà trọ và ' + CAST(@SoDanhGiaXoa AS NVARCHAR(10)) + N' đánh giá tương ứng.';
        
    END TRY
    BEGIN CATCH
        -- Rollback giao dịch nếu có lỗi
        ROLLBACK TRANSACTION;
        
        PRINT N'Lỗi: Không thể xóa dữ liệu. ' + ERROR_MESSAGE();
        PRINT N'Tất cả thao tác đã được hoàn tác để đảm bảo tính toàn vẹn dữ liệu.';
    END CATCH
END;
GO

-- =====================================
-- 3.3.2. SP xóa nhà trọ theo khoảng thời gian đăng tin
-- =====================================
CREATE PROCEDURE SP_XoaNhaTroTheoNgayDang
    @NgayBatDau DATETIME,
    @NgayKetThuc DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra tham số đầu vào
    IF @NgayBatDau IS NULL OR @NgayKetThuc IS NULL
    BEGIN
        PRINT N'Lỗi: Ngày bắt đầu và ngày kết thúc không được để trống!';
        RETURN;
    END
    
    IF @NgayBatDau > @NgayKetThuc
    BEGIN
        PRINT N'Lỗi: Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc!';
        RETURN;
    END
    
    -- Khai báo biến để lưu thông tin
    DECLARE @SoNhaTroXoa INT = 0;
    DECLARE @SoDanhGiaXoa INT = 0;
    DECLARE @DanhSachNhaTroXoa TABLE (
        MaNhaTro INT, 
        NgayDangTin DATETIME,
        DiaChi NVARCHAR(500)
    );
    
    -- Tìm danh sách nhà trọ cần xóa theo khoảng thời gian
    INSERT INTO @DanhSachNhaTroXoa (MaNhaTro, NgayDangTin, DiaChi)
    SELECT 
        NT.MaNhaTro,
        NT.NgayDangTin,
        ISNULL(NT.SoNha + N', ', N'') + 
        ISNULL(NT.TenDuong + N', ', N'') + 
        ISNULL(NT.TenPhuong + N', ', N'') + 
        NT.Quan AS DiaChi
    FROM NHATRO NT
    WHERE NT.NgayDangTin >= @NgayBatDau 
        AND NT.NgayDangTin <= @NgayKetThuc;
    
    -- Kiểm tra có nhà trọ nào cần xóa không
    SELECT @SoNhaTroXoa = COUNT(*) FROM @DanhSachNhaTroXoa;
    
    IF @SoNhaTroXoa = 0
    BEGIN
        PRINT N'Thông báo: Không có nhà trọ nào được đăng trong khoảng thời gian từ ' + 
              FORMAT(@NgayBatDau, 'dd-MM-yyyy', 'vi-VN') + N' đến ' + 
              FORMAT(@NgayKetThuc, 'dd-MM-yyyy', 'vi-VN');
        RETURN;
    END
    
    -- Hiển thị danh sách nhà trọ sẽ bị xóa
    PRINT N'Danh sách ' + CAST(@SoNhaTroXoa AS NVARCHAR(10)) + N' nhà trọ sẽ bị xóa (đăng từ ' +
          FORMAT(@NgayBatDau, 'dd-MM-yyyy', 'vi-VN') + N' đến ' + 
          FORMAT(@NgayKetThuc, 'dd-MM-yyyy', 'vi-VN') + N'):';
          
    DECLARE @MaNhaTro INT, @NgayDangTin DATETIME, @DiaChi NVARCHAR(500);
    DECLARE cur_NhaTroXoa CURSOR FOR SELECT MaNhaTro, NgayDangTin, DiaChi FROM @DanhSachNhaTroXoa;
    OPEN cur_NhaTroXoa;
    FETCH NEXT FROM cur_NhaTroXoa INTO @MaNhaTro, @NgayDangTin, @DiaChi;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT N'- ID: ' + CAST(@MaNhaTro AS NVARCHAR(10)) + 
              N', Ngày đăng: ' + FORMAT(@NgayDangTin, 'dd-MM-yyyy', 'vi-VN') + 
              N', Địa chỉ: ' + @DiaChi;
        FETCH NEXT FROM cur_NhaTroXoa INTO @MaNhaTro, @NgayDangTin, @DiaChi;
    END
    CLOSE cur_NhaTroXoa;
    DEALLOCATE cur_NhaTroXoa;
    
    -- Bắt đầu giao dịch
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Đếm số đánh giá sẽ bị xóa
        SELECT @SoDanhGiaXoa = COUNT(*)
        FROM DANHGIA DG
        INNER JOIN @DanhSachNhaTroXoa DS ON DG.MaNhaTro = DS.MaNhaTro;
        
        -- Xóa đánh giá trước (do ràng buộc khóa ngoại)
        DELETE DG
        FROM DANHGIA DG
        INNER JOIN @DanhSachNhaTroXoa DS ON DG.MaNhaTro = DS.MaNhaTro;
        
        -- Xóa nhà trọ
        DELETE NT
        FROM NHATRO NT
        INNER JOIN @DanhSachNhaTroXoa DS ON NT.MaNhaTro = DS.MaNhaTro;
        
        -- Commit giao dịch
        COMMIT TRANSACTION;
        
        -- Thông báo kết quả
        PRINT N'Thành công: Đã xóa ' + CAST(@SoNhaTroXoa AS NVARCHAR(10)) + N' nhà trọ và ' + 
              CAST(@SoDanhGiaXoa AS NVARCHAR(10)) + N' đánh giá tương ứng.';
        
    END TRY
    BEGIN CATCH
        -- Rollback giao dịch nếu có lỗi
        ROLLBACK TRANSACTION;
        
        PRINT N'Lỗi: Không thể xóa dữ liệu. ' + ERROR_MESSAGE();
        PRINT N'Tất cả thao tác đã được hoàn tác để đảm bảo tính toàn vẹn dữ liệu.';
    END CATCH
END;
GO

-- =====================================
-- KIỂM THỬ CÁC CHỨC NĂNG 3.3
-- =====================================

PRINT N'';
PRINT N'========================================';
PRINT N'KIỂM THỬ 3.3 - XÓA THÔNG TIN';
PRINT N'========================================';

-- Kiểm tra dữ liệu trước khi test
PRINT N'';
PRINT N'THỐNG KÊ DỮ LIỆU TRƯỚC KHI KIỂM THỬ:';
PRINT N'- Tổng số nhà trọ: ' + CAST((SELECT COUNT(*) FROM NHATRO) AS NVARCHAR(10));
PRINT N'- Tổng số đánh giá: ' + CAST((SELECT COUNT(*) FROM DANHGIA) AS NVARCHAR(10));

-- Hiển thị thống kê DISLIKE cho từng nhà trọ
PRINT N'';
PRINT N'THỐNG KÊ DISLIKE THEO NHÀ TRỌ:';
SELECT 
    NT.MaNhaTro,
    ISNULL(SUM(CASE WHEN DG.LoaiDanhGia = 0 THEN 1 ELSE 0 END), 0) AS SoDislike,
    ISNULL(SUM(CASE WHEN DG.LoaiDanhGia = 1 THEN 1 ELSE 0 END), 0) AS SoLike
FROM NHATRO NT
LEFT JOIN DANHGIA DG ON NT.MaNhaTro = DG.MaNhaTro
GROUP BY NT.MaNhaTro
ORDER BY NT.MaNhaTro;

-- Test 3.3.1: SP xóa nhà trọ theo DISLIKE
PRINT N'';
PRINT N'Test 3.3.1: Xóa nhà trọ có số DISLIKE > 1';
EXEC SP_XoaNhaTroTheoDislike @NgungDislike = 1;

-- Test với ngưỡng cao hơn để không xóa gì
PRINT N'';
PRINT N'Test 3.3.1b: Thử xóa nhà trọ có DISLIKE > 10 (không có)';
EXEC SP_XoaNhaTroTheoDislike @NgungDislike = 10;

-- Test 3.3.2: SP xóa nhà trọ theo ngày đăng
PRINT N'';
PRINT N'Test 3.3.2: Xóa nhà trọ đăng từ 01-08-2025 đến 31-08-2025';
EXEC SP_XoaNhaTroTheoNgayDang 
    @NgayBatDau = '2025-08-01', 
    @NgayKetThuc = '2025-08-31';

-- Test với khoảng ngày không có dữ liệu
PRINT N'';
PRINT N'Test 3.3.2b: Thử xóa nhà trọ đăng từ 01-01-2024 đến 31-01-2024 (không có)';
EXEC SP_XoaNhaTroTheoNgayDang 
    @NgayBatDau = '2024-01-01', 
    @NgayKetThuc = '2024-01-31';

-- Kiểm tra dữ liệu sau khi test
PRINT N'';
PRINT N'THỐNG KÊ DỮ LIỆU SAU KHI KIỂM THỬ:';
PRINT N'- Tổng số nhà trọ: ' + CAST((SELECT COUNT(*) FROM NHATRO) AS NVARCHAR(10));
PRINT N'- Tổng số đánh giá: ' + CAST((SELECT COUNT(*) FROM DANHGIA) AS NVARCHAR(10));

-- Test lỗi tham số
PRINT N'';
PRINT N'Test lỗi: Gọi SP với tham số NULL hoặc không hợp lệ';
EXEC SP_XoaNhaTroTheoDislike @NgungDislike = NULL;
EXEC SP_XoaNhaTroTheoNgayDang @NgayBatDau = '2025-12-01', @NgayKetThuc = '2025-11-01';

PRINT N'';
PRINT N'========================================';
PRINT N'KẾT THÚC KIỂM THỬ 3.3';
PRINT N'========================================';

-- =====================================
-- Y4: YÊU CẦU QUẢN TRỊ CSDL
-- =====================================

-- Note: Các lệnh quản trị CSDL cần chạy với quyền sysadmin hoặc securityadmin
-- Đảm bảo bạn đã kết nối SQL Server với tài khoản có quyền cao

-- =====================================
-- Y4.1. TẠO NGƯỜI DÙNG QUẢN TRỊ CSDL
-- =====================================

-- Tạo Login cho quản trị viên CSDL
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'admin_nhatro_ps46924')
BEGIN
    CREATE LOGIN admin_nhatro_ps46924 
    WITH PASSWORD = 'Admin@123456',
         DEFAULT_DATABASE = QLNHATRO_PS46924,
         CHECK_EXPIRATION = OFF,
         CHECK_POLICY = ON;
    PRINT N'✓ Đã tạo Login: admin_nhatro_ps46924';
END
ELSE
    PRINT N'! Login admin_nhatro_ps46924 đã tồn tại';

-- Chuyển sang database QLNHATRO_PS46924 để tạo user
USE QLNHATRO_PS46924;

-- Tạo User trong database và gán quyền db_owner (toàn quyền trên database này)
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'admin_nhatro_ps46924')
BEGIN
    CREATE USER admin_nhatro_ps46924 FOR LOGIN admin_nhatro_ps46924;
    ALTER ROLE db_owner ADD MEMBER admin_nhatro_ps46924;
    PRINT N'✓ Đã tạo User admin_nhatro_ps46924 với quyền db_owner';
END
ELSE
    PRINT N'! User admin_nhatro_ps46924 đã tồn tại';

-- Giới hạn quyền chỉ trên database QLNHATRO_PS46924 (không cho phép truy cập database khác)
-- Note: db_owner đã bao gồm toàn bộ quyền trên database này

-- =====================================
-- Y4.2. TẠO NGƯỜI DÙNG THÔNG THƯỜNG
-- =====================================

-- Tạo Login cho người dùng thông thường
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'user_nhatro_ps46924')
BEGIN
    CREATE LOGIN user_nhatro_ps46924 
    WITH PASSWORD = 'User@123456',
         DEFAULT_DATABASE = QLNHATRO_PS46924,
         CHECK_EXPIRATION = OFF,
         CHECK_POLICY = ON;
    PRINT N'✓ Đã tạo Login: user_nhatro_ps46924';
END
ELSE
    PRINT N'! Login user_nhatro_ps46924 đã tồn tại';

-- Tạo User trong database
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_nhatro_ps46924')
BEGIN
    CREATE USER user_nhatro_ps46924 FOR LOGIN user_nhatro_ps46924;
    PRINT N'✓ Đã tạo User: user_nhatro_ps46924';
END
ELSE
    PRINT N'! User user_nhatro_ps46924 đã tồn tại';

-- Phân quyền cho người dùng thông thường
-- 1. Quyền trên các bảng (SELECT, INSERT, UPDATE, DELETE)
GRANT SELECT, INSERT, UPDATE, DELETE ON LOAINHA TO user_nhatro_ps46924;
GRANT SELECT, INSERT, UPDATE, DELETE ON NGUOIDUNG TO user_nhatro_ps46924;
GRANT SELECT, INSERT, UPDATE, DELETE ON NHATRO TO user_nhatro_ps46924;
GRANT SELECT, INSERT, UPDATE, DELETE ON DANHGIA TO user_nhatro_ps46924;
PRINT N'✓ Đã cấp quyền SELECT, INSERT, UPDATE, DELETE trên tất cả bảng';

-- 2. Quyền thực thi các Stored Procedures
GRANT EXECUTE ON SP_ThemNguoiDung TO user_nhatro_ps46924;
GRANT EXECUTE ON SP_ThemNhaTro TO user_nhatro_ps46924;
GRANT EXECUTE ON SP_ThemDanhGia TO user_nhatro_ps46924;
GRANT EXECUTE ON SP_TimKiemPhongTro TO user_nhatro_ps46924;
GRANT EXECUTE ON SP_LayDanhGiaNhaTro TO user_nhatro_ps46924;
GRANT EXECUTE ON SP_XoaNhaTroTheoDislike TO user_nhatro_ps46924;
GRANT EXECUTE ON SP_XoaNhaTroTheoNgayDang TO user_nhatro_ps46924;
PRINT N'✓ Đã cấp quyền EXECUTE trên tất cả Stored Procedures';

-- 3. Quyền sử dụng các Functions (Functions tự động có quyền SELECT)
-- Note: Trong SQL Server, quyền SELECT trên database đã bao gồm quyền sử dụng scalar functions

-- 4. Quyền truy cập View
GRANT SELECT ON VW_Top10NhaTroYeuThich TO user_nhatro_ps46924;
PRINT N'✓ Đã cấp quyền SELECT trên View VW_Top10NhaTroYeuThich';

-- =====================================
-- Y4.3. TẠO BẢN SAO CSDL (BACKUP)
-- =====================================

-- Note: Script backup này cần chạy với tài khoản admin_nhatro_ps46924 
-- hoặc tài khoản có quyền db_owner trên database

-- Tạo thư mục backup nếu chưa có (cần quyền hệ thống)
-- EXEC xp_cmdshell 'mkdir C:\Backup_QLNHATRO', NO_OUTPUT;

-- Script backup database
DECLARE @BackupPath NVARCHAR(500);
DECLARE @BackupName NVARCHAR(200);
DECLARE @BackupDate NVARCHAR(20);

-- Tạo tên file backup với timestamp
SET @BackupDate = FORMAT(GETDATE(), 'yyyyMMdd_HHmmss');
SET @BackupName = 'QLNHATRO_PS46924_Backup_' + @BackupDate + '.bak';
SET @BackupPath = 'C:\Backup_QLNHATRO\' + @BackupName;

-- Lệnh backup (uncomment để chạy thực tế)
/*
BACKUP DATABASE QLNHATRO_PS46924 
TO DISK = @BackupPath
WITH 
    FORMAT,
    COMPRESSION,
    CHECKSUM,
    DESCRIPTION = N'Full backup của QLNHATRO_PS46924 database',
    NAME = N'QLNHATRO_PS46924-Full Database Backup',
    STATS = 10;

PRINT N'✓ Đã tạo backup database: ' + @BackupPath;
*/

-- Script backup đơn giản hơn (để demo)
PRINT N'📋 SCRIPT BACKUP DATABASE:';
PRINT N'-- Tạo thư mục backup';
PRINT N'EXEC xp_cmdshell ''mkdir C:\Backup_QLNHATRO'';';
PRINT N'';
PRINT N'-- Backup database';
PRINT N'BACKUP DATABASE QLNHATRO_PS46924';
PRINT N'TO DISK = ''C:\Backup_QLNHATRO\QLNHATRO_PS46924_' + FORMAT(GETDATE(), 'yyyyMMdd') + '.bak''';
PRINT N'WITH FORMAT, COMPRESSION, CHECKSUM;';
PRINT N'';
PRINT N'💡 Lưu ý: Chạy script trên với tài khoản admin_nhatro_ps46924';

-- =====================================
-- Y4.4. KIỂM TRA QUYỀN VÀ THÔNG TIN NGƯỜI DÙNG
-- =====================================

PRINT N'';
PRINT N'========================================';
PRINT N'THÔNG TIN NGƯỜI DÙNG ĐÃ TẠO';
PRINT N'========================================';

-- Hiển thị thông tin Logins
PRINT N'📋 DANH SÁCH LOGINS:';
SELECT 
    name AS [Tên Login],
    type_desc AS [Loại],
    is_disabled AS [Bị vô hiệu hóa],
    default_database_name AS [Database mặc định],
    create_date AS [Ngày tạo]
FROM sys.server_principals 
WHERE name IN ('admin_nhatro_ps46924', 'user_nhatro_ps46924')
ORDER BY name;

-- Hiển thị thông tin Users trong database
PRINT N'';
PRINT N'📋 DANH SÁCH USERS TRONG DATABASE:';
SELECT 
    name AS [Tên User],
    type_desc AS [Loại],
    create_date AS [Ngày tạo],
    modify_date AS [Ngày sửa đổi]
FROM sys.database_principals 
WHERE name IN ('admin_nhatro_ps46924', 'user_nhatro_ps46924')
ORDER BY name;

-- Hiển thị quyền của users
PRINT N'';
PRINT N'📋 QUYỀN CỦA CÁC USER:';
SELECT 
    dp.name AS [User],
    r.name AS [Role/Permission],
    dp.type_desc AS [Loại]
FROM sys.database_role_members rm
INNER JOIN sys.database_principals dp ON rm.member_principal_id = dp.principal_id
INNER JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
WHERE dp.name IN ('admin_nhatro_ps46924', 'user_nhatro_ps46924')

UNION ALL

SELECT 
    dp.name AS [User],
    p.permission_name + ' ON ' + s.name AS [Role/Permission],
    'EXPLICIT PERMISSION' AS [Loại]
FROM sys.database_permissions p
INNER JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
LEFT JOIN sys.objects o ON p.major_id = o.object_id
LEFT JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE dp.name IN ('admin_nhatro_ps46924', 'user_nhatro_ps46924')
    AND p.state = 'G' -- GRANT
ORDER BY [User], [Role/Permission];

-- =====================================
-- Y4.5. HƯỚNG DẪN SỬ DỤNG
-- =====================================

PRINT N'';
PRINT N'========================================';
PRINT N'HƯỚNG DẪN SỬ DỤNG';
PRINT N'========================================';

PRINT N'';
PRINT N'🔐 THÔNG TIN ĐĂNG NHẬP:';
PRINT N'';
PRINT N'1️⃣ QUẢN TRỊ VIÊN DATABASE:';
PRINT N'   - Login: admin_nhatro_ps46924';
PRINT N'   - Password: Admin@123456';
PRINT N'   - Quyền: Toàn quyền trên database QLNHATRO_PS46924';
PRINT N'   - Vai trò: db_owner';
PRINT N'';
PRINT N'2️⃣ NGƯỜI DÙNG THÔNG THƯỜNG:';
PRINT N'   - Login: user_nhatro_ps46924';
PRINT N'   - Password: User@123456';
PRINT N'   - Quyền: SELECT, INSERT, UPDATE, DELETE trên tất cả bảng';
PRINT N'   - Quyền: EXECUTE trên tất cả SP và Functions';
PRINT N'';
PRINT N'📝 CÁCH KẾT NỐI:';
PRINT N'   1. Mở SQL Server Management Studio';
PRINT N'   2. Server name: localhost (hoặc tên server của bạn)';
PRINT N'   3. Authentication: SQL Server Authentication';
PRINT N'   4. Nhập Login và Password tương ứng';
PRINT N'   5. Database sẽ tự động chuyển đến QLNHATRO_PS46924';
PRINT N'';
PRINT N'💾 TẠO BACKUP:';
PRINT N'   - Đăng nhập bằng tài khoản admin_nhatro_ps46924';
PRINT N'   - Chạy script backup ở phần Y4.3';
PRINT N'   - File backup sẽ được lưu tại C:\Backup_QLNHATRO\';

PRINT N'';
PRINT N'========================================';
PRINT N'KẾT THÚC Y4 - QUẢN TRỊ CSDL';
PRINT N'========================================';
