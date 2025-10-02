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
