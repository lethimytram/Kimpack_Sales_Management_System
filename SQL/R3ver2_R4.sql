/*
-------------------------------------------------------------------------------------------------------------
SCRIPT XÂY DỰNG CƠ SỞ DỮ LIỆU KIMPACK (VERION 2) 
-------------------------------------------------------------------------------------------------------------
*/

CREATE DATABASE Kimpack
USE Kimpack

--Tao bang NHA_CUNG_CAP 
CREATE TABLE NHA_CUNG_CAP 
(
	MaNCC INT PRIMARY KEY, 
	TenNCC  NVARCHAR(50)  NOT NULL,
	DiaChiNCC NVARCHAR(50) NOT NULL,
	SoDienThoaiNCC VARCHAR(15) NOT NULL,
	SoTaiKhoanNCC VARCHAR(20) NULL
)

--Tao bang NGUYEN_VAT_LIEU 
CREATE TABLE NGUYEN_VAT_LIEU 
(
	MaNVL INT PRIMARY KEY, 
	TenNVL  NVARCHAR(50)  NOT NULL,
	DonViTinh NVARCHAR(10) NOT NULL,
	DonGia NUMERIC(15,3) NOT NULL
)

--Tao bang CUNG_CAP 
CREATE TABLE CUNG_CAP 
(
	MaCC INT PRIMARY KEY, 
	KyHieuHD CHAR(7) NOT NULL,
	NgayCungCap DATE NOT NULL,
	HinhThucThanhToan CHAR(1) NOT NULL,
	TongTienNVL NUMERIC(15,3),
	MucThueSuatGTGT NUMERIC(15,3),
	TienThueGTGT NUMERIC(15,3),
	TongTienThanhToan NUMERIC(15,3),
	MaNCC INT NOT NULL,
	FOREIGN KEY (MaNCC) REFERENCES NHA_CUNG_CAP (MaNCC) 
)

--Tao bang CUNG_CAP_CHI_TIET
CREATE TABLE CUNG_CAP_CHI_TIET 
(
	MaCC INT NOT NULL,
	MaNVL INT NOT NULL,
	SoLuong NUMERIC(15,3) NOT NULL,
	ThanhTien NUMERIC(15,3),
	PRIMARY KEY (MaCC, MaNVL),
	FOREIGN KEY (MaCC) REFERENCES CUNG_CAP (MaCC),
	FOREIGN KEY (MaNVL) REFERENCES NGUYEN_VAT_LIEU (MaNVL) 
)

--Tao bang KHACH_HANG 
CREATE TABLE KHACH_HANG 
(
	MaKH INT PRIMARY KEY, 
	TenKH  NVARCHAR(100)  NOT NULL,
	DiaChiKH NVARCHAR(100) NOT NULL,
	SoDienThoaiKH VARCHAR(15) NOT NULL,
	SoTaiKhoanKH VARCHAR(20) NULL
)

--Tao bang SAN_PHAM 
CREATE TABLE SAN_PHAM 
(
	MaSP INT PRIMARY KEY, 
	TenSP  NVARCHAR(100)  NOT NULL,
	DonViTinh NVARCHAR(10) NOT NULL,
	DonGia NUMERIC(15,3) NOT NULL
)

--Tao bang DAT 
CREATE TABLE DAT
(
	MaD INT PRIMARY KEY, 
	KyHieuHD CHAR(7) NOT NULL,
	NgayDat DATE NOT NULL,
	HinhThucThanhToan CHAR(1) NOT NULL,
	TongTienSP NUMERIC(15,3),
	MucThueSuatGTGT NUMERIC(15,3)  NOT NULL DEFAULT 0,
	TienThueGTGT NUMERIC(15,3),
	TongTienThanhToan NUMERIC(15,3),
	MaKH INT NOT NULL,
	FOREIGN KEY (MaKH) REFERENCES KHACH_HANG (MaKH) 
)

--Tao bang DAT_CHI_TIET
CREATE TABLE DAT_CHI_TIET 
(
	MaD INT NOT NULL,
	MaSP INT NOT NULL,
	SoLuong INT NOT NULL,
	ThanhTien NUMERIC(15,3),
	PRIMARY KEY (MaD, MaSP),
	FOREIGN KEY (MaD) REFERENCES DAT (MaD),
	FOREIGN KEY (MaSP) REFERENCES SAN_PHAM (MaSP)
)

/*
-------------------------------------------------------------------------------------------------------------
MODULE TẠO DỮ LIỆU DUMP CHO CÁC BẢNG 
-------------------------------------------------------------------------------------------------------------
*/
create or alter proc spThemNHA_CUNG_CAP @ketqua bit out --tao thu tuc spThemNHA_CUNG_CAP
as
begin 
	declare @dem int = 1
	declare @maNCC int 
	declare @tenNCC nvarchar(50) 
	declare @diaChiNCC nvarchar(50)
	declare @soDienThoaiNCC varchar(15)
	declare @soTaiKhoanNCC varchar(20)

	while @dem <= 1000
	begin 
		set @maNCC = @dem
		set @tenNCC = N'Nhà cung cấp ' + cast(@dem as nvarchar(5))
		set @diaChiNCC = N'Địa chỉ ' + cast(@dem as nvarchar(5))
		set @soDienThoaiNCC = '0' + cast((9000000000+@dem) as varchar(15))
		set @soTaiKhoanNCC = cast((1800000000+ @dem) as nvarchar(20))
		insert into NHA_CUNG_CAP(MaNCC, TenNCC, DiaChiNCC, SoDienThoaiNCC, SoTaiKhoanNCC)
		values (@maNCC, @tenNCC, @diaChiNCC, @soDienThoaiNCC, @soTaiKhoanNCC)
		set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Them that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Them thanh cong'
			set @ketqua = 1
		end
	end
end

declare @ketqua bit
exec spThemNHA_CUNG_CAP @ketqua out  --goi thu tuc spThemNHA_CUNG_CAP
select * from NHA_CUNG_CAP --xem du lieu NHA_CUNG_CAP
delete from NHA_CUNG_CAP --xoa 1000 dong

-------------------------------------------------------------------------------------
create or alter proc spthemNGUYEN_VAT_LIEU @ketqua bit out--tao thu tuc spthemNGUYEN_VAT_LIEU
as
begin 
	declare @dem int = 1
	declare @maNVL int 
	declare @tenNVL nvarchar(50) 
	declare @donViTinh nvarchar(10)
	declare @donGia numeric(15,3)
	while @dem <= 1000
	begin 
		set @maNVL = @dem
		set @tenNVL = N'Nguyên vật liệu ' + cast(@dem as nvarchar(5))
		set @donViTinh = 'Kg' 
		SET @donGia =	case
						when @dem <= 900 then ((@dem - 1) / 100 + 1)
						else 1 
						end * 2000.123
		insert into NGUYEN_VAT_LIEU (MaNVL, TenNVL,donvitinh,dongia)
		values (@maNVL, @tenNVL, @donvitinh, @dongia)
		set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Them that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Them thanh cong'
			set @ketqua = 1
		end
	end
end

declare @kq bit
exec spthemNGUYEN_VAT_LIEU @kq out--goi thu tuc spthemNGUYEN_VAT_LIEU
select * from NGUYEN_VAT_LIEU --xem du lieu NGUYEN_VAT_LIEU
delete from NGUYEN_VAT_LIEU --xoa 1000 dong du lieu NGUYEN_VAT_LIEU

-------------------------------------------------------------------------------------
create or alter proc spthemCUNG_CAP @ketqua bit out--tao thu tuc spthemCUNG_CAP
as
begin 
	declare @dem int = 1
    declare @maCC int
    declare @kyHieuHD char(7)
	declare @ngayCungCap date
    declare @hinhThucThanhToan char(1) 
	declare @mucThueSuatGTGT numeric(15,3)
	declare @maNCC int

	declare @ngayBatDau date = '2023-01-01'
	declare @ngayKetThuc date = '2024-10-20'
    while @dem <= 1000 
    begin 
        set @maCC = @dem
		set @kyHieuHD = right('000000000' + cast(@dem as varchar(7)),7)
		set @ngayCungCap = dateadd(day, floor(rand() * datediff(day, @ngayBatDau, @ngayKetThuc)), @ngayBatDau)
		set @mucThueSuatGTGT = 0.080
		set @maNCC = @dem
        set @hinhThucThanhToan = floor(rand(checksum(newid())) * 2)  --0:tien mat / 1: chuyen khoan
        insert into CUNG_CAP(MaCC, KyHieuHD, NgayCungCap, HinhThucThanhToan, MucThueSuatGTGT, MaNCC )
        values (@maCC, @kyHieuHD, @ngayCungCap, @hinhThucThanhToan,@mucThueSuatGTGT, @maNCC)
        set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Them that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Them thanh cong'
			set @ketqua = 1
		end
    end
end

declare @ketqua bit
exec spthemCUNG_CAP @ketqua out --goi thu tuc spthemCUNG_CAP
select * from CUNG_CAP --xem du lieu bang CUNG_CAP
delete from CUNG_CAP --xoa 1000 dong du lieu bang CUNG_CAP
-------------------------------------------------------------------------------------
create or alter proc spthemCUNG_CAP_CHI_TIET @ketqua bit out--tao thu tuc spthemCUNG_CAP_CHI_TIET
as
begin 
        declare @dem int = 1
        declare @soLuong numeric(15,3)
		declare @maCC int
		declare @maNVL int
        while @dem <= 1000 
        begin 
            set @maCC = @dem
			set @maNVL = @dem
			set @soLuong =	case
					when @dem <= 900 then ((@dem - 1) / 100 + 1)
					else 1 
					end * 1.123
            insert into CUNG_CAP_CHI_TIET(MaCC, MaNVL , SoLuong)
            values (@maCC, @maNVL, @soLuong)
			set @dem = @dem + 1
			if @@ROWCOUNT <= 0
			begin 
				print 'Them that bai'
				set @ketqua = 0
				return
			end
			else
			begin 
				print 'Them thanh cong'
				set @ketqua = 1
			end
        end
end

declare @ketqua bit
exec spthemCUNG_CAP_CHI_TIET @ketqua out    --goi thu tuc spthemCUNG_CAP_CHI_TIET
select * from CUNG_CAP_CHI_TIET	  --xem du lieu bang CUNG_CAP_CHI_TIET
delete from CUNG_CAP_CHI_TIET 	 --xoa 1000 dong du lieu bang CUNG_CAP_CHI_TIET

-------------------------------------------------------------------------------------
create or alter proc spupdateCUNG_CAP_CHI_TIET @ketqua bit out-- tạo thủ tục cập nhật thành tiền của bảng CUNG_CAP_CHI_TIET
as
begin 
	declare @dem int = 1
	declare @thanhTien numeric(15,3)
    while @dem <= 1000 
    begin 

		set @thanhTien =	(select SoLuong * NGUYEN_VAT_LIEU.DonGia
							from CUNG_CAP_CHI_TIET join NGUYEN_VAT_LIEU on CUNG_CAP_CHI_TIET.MaNVL = NGUYEN_VAT_LIEU.MaNVL
							where CUNG_CAP_CHI_TIET.MaNVL = @dem
							)
		update CUNG_CAP_CHI_TIET
		set ThanhTien = @thanhTien
		where MaNVL = @dem
		set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Cap nhat that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Cap nhat thanh cong'
			set @ketqua = 1
		end
    end
end

declare @ketqua bit
exec spupdateCUNG_CAP_CHI_TIET @ketqua out
select * from CUNG_CAP_CHI_TIET	

-------------------------------------------------------------------------------------
create or alter proc spupdateCUNG_CAP @ketqua bit out --thủ tục spupdateCUNG_CAP
as
begin 
	declare @dem int = 1
	declare @thanhTien numeric(15,3)
	declare @tongTienNVL numeric(15,3)
	declare @tienThueGTGT numeric(15,3)
	declare @tongTienThanhToan numeric(15,3)
    while @dem <= 1000 
    begin 
		set @tongTienNVL =	(select sum(ThanhTien) from CUNG_CAP join CUNG_CAP_CHI_TIET on CUNG_CAP.MaCC = CUNG_CAP_CHI_TIET.MaCC
							where CUNG_CAP_CHI_TIET.MaCC = @dem
							)
		set @tienThueGTGT = (select MucThueSuatGTGT * @tongTienNVL from CUNG_CAP where MaCC = @dem
							)

		set @tongTienThanhToan = @tongTienNVL - @tienThueGTGT
		update CUNG_CAP
		set TongTienNVL = @tongTienNVL,
			TienThueGTGT = @tienThueGTGT,
			TongTienThanhToan = @tongTienThanhToan
		where MaCC = @dem
		set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Cap nhat that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Cap nhat thanh cong'
			set @ketqua = 1
		end
    end
end

declare @ketqua bit
exec spupdateCUNG_CAP @ketqua out
select * from CUNG_CAP	

-------------------------------------------------------------------------------------
create or alter proc spthemKHACH_HANG @ketqua bit out--tao thu tuc spthemKHACH_HANG
as
begin 
        declare @dem int = 1
        declare @maKH int 
        declare @tenKH nvarchar(100) 
        declare @diaChiKH nvarchar(100)    
        declare @soDienThoaiKH varchar(15)
        declare @taiKhoanKH varchar(20)
        while @dem <= 1000
        begin 
			set @maKH = @dem
			set @tenKH = N'Khách hàng ' + cast(@dem as nvarchar(5))
			set @diaChiKH = N'Địa chỉ khách hàng ' + cast(@dem as nvarchar(5))
			set @soDienThoaiKH = '0' + cast((3000000000+@dem) as varchar(15))
			set @taiKhoanKH = cast((6000000000+ @dem) as varchar(20))
			insert into KHACH_HANg (MaKH, TenKH, DiaChiKH, SoDienThoaiKH, SoTaiKhoanKH)
			values (@maKH, @tenKH, @diaChiKH, @soDienThoaiKH, @taiKhoanKH)
			set @dem = @dem + 1
			if @@ROWCOUNT <= 0
			begin 
				print 'Them that bai'
				set @ketqua = 0
				return
			end
			else
			begin 
				print 'Them thanh cong'
				set @ketqua = 1
			end
        end
end

declare @ketqua bit
exec spthemKHACH_HANG @ketqua out
select * from KHACH_HANG
delete from KHACH_HANG

-------------------------------------------------------------------------------------
create or alter proc spthemSAN_PHAM @ketqua bit out
as
begin
	declare @dem int = 1
	declare @maSP int
    declare @tenSP nvarchar(100)
    declare @donViTinh nvarchar(10)
    declare @donGia numeric(15,3)
    while @dem <= 1000
    begin
        set @maSP = @dem;
        set @tenSP = N'Sản phẩm ' + CAST(@dem as varchar(5))
        set @donViTinh = N'Cái'
		SET @donGia =	case
						when @dem <= 900 then ((@dem - 1) / 100 + 1)
						else 1 
						end * 1000.123

        insert into SAN_PHAM (MaSP, TenSP, DonViTinh, DonGia)
        values (@maSP, @tenSP, @donViTinh, @donGia)
        set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Them that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Them thanh cong'
			set @ketqua = 1
		end
    end
end

declare @ketqua bit
exec spthemSAN_PHAM @ketqua out
select * from SAN_PHAM
delete from SAN_PHAM


-------------------------------------------------------------------------------------
create or alter proc spthemDAT @ketqua bit out
as
begin 
    declare @dem int = 1
    declare @maD int
	declare @ngayDat date
    declare @kyHieuHD char(7)  
    declare @hinhThucThanhToan char(1)
	declare @mucThueSuatGTGT numeric(15,3)
	declare @maKH int 

	declare @ngayBatDau date = '2024-01-01'
	declare @ngayKetThuc date = '2024-10-10'
    while @dem <= 1000
    begin 
        set @maD = @dem
		set @kyHieuHD = right('000000000' + cast(@dem as varchar(7)),7)
		set @ngayDat = dateadd(day, floor(rand() * datediff(day, @ngayBatDau, @ngayKetThuc)), @ngayBatDau)
		set @mucThueSuatGTGT = 0.080
		set @maKH = @dem
        set @hinhThucThanhToan = floor(rand(checksum(newid())) * 2)  --0:tien mat / 1: chuyen khoan
        insert into DAT (MaD, NgayDat, KyHieuHD, HinhThucThanhToan,MucThueSuatGTGT, MaKH)
        values (@maD, @ngayDat, @kyHieuHD, @hinhThucThanhToan, @mucThueSuatGTGT, @maKH)
        set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Them that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Them thanh cong'
			set @ketqua = 1
		end
    end
end


declare @ketqua bit
exec spthemDAT @ketqua out
select * from DAT
delete from DAT

-------------------------------------------------------------------------------------
create or alter proc spthemDAT_CHI_TIET @ketqua bit out
as
begin 
    declare @dem int = 1
    declare @maD int 
    declare @maSP int
    declare @soLuong int 
   
    while @dem <= 1000
    begin 
        set @maD = @dem
		set @maSP = @dem
		set @soLuong = floor(1 + (rand() * 20))
		insert into DAT_CHI_TIET (MaD, MaSP, SoLuong)
		values (@maD, @maSP, @soLuong)
      	set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Them that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Them thanh cong'
			set @ketqua = 1
		end
    end
end

declare @ketqua bit
exec spthemDAT_CHI_TIET @ketqua out
select * from DAT_CHI_TIET

-------------------------------------------------------------------------------------
create or alter proc spupdateDAT_CHI_TIET @ketqua bit out
as
begin 
	declare @dem int = 1
	declare @thanhTien numeric(15,3)
    while @dem <= 1000 
    begin 
		set @thanhTien =	(select SoLuong * SAN_PHAM.DonGia
							from DAT_CHI_TIET join SAN_PHAM on DAT_CHI_TIET.MaSP = SAN_PHAM.MaSP
							where DAT_CHI_TIET.MaSP = @dem
							)
		update DAT_CHI_TIET
		set ThanhTien = @thanhTien
		where MaSP = @dem
		set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Cap nhat that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Cap nhat thanh cong'
			set @ketqua = 1
		end
    end
end

declare @ketqua bit
exec spupdateDAT_CHI_TIET @ketqua out
select * from DAT_CHI_TIET	

-------------------------------------------------------------------------------------
create or alter proc spupdateDAT @ketqua bit out 
as
begin 
	declare @dem int = 1
	declare @tongTienSP numeric(15,3)
	declare @tienThueGTGT numeric(15,3)
	declare @tongTienThanhToan numeric(15,3)
    while @dem <= 1000 
    begin 
		set @tongTienSP =	(select sum(ThanhTien) from DAT join DAT_CHI_TIET on DAT.MaD = DAT_CHI_TIET.MaD
							where DAT_CHI_TIET.MaD = @dem
							)
		set @tienThueGTGT = (select MucThueSuatGTGT * @tongTienSP from DAT where MaD = @dem
							)

		set @tongTienThanhToan = @tongTienSP - @tienThueGTGT
		update DAT
		set TongTienSP = @tongTienSP,
			TienThueGTGT = @tienThueGTGT,
			TongTienThanhToan = @tongTienThanhToan
		where MaD = @dem
		set @dem = @dem + 1
		if @@ROWCOUNT <= 0
		begin 
			print 'Cap nhat that bai'
			set @ketqua = 0
			return
		end
		else
		begin 
			print 'Cap nhat thanh cong'
			set @ketqua = 1
		end
    end
end


declare @ketqua bit
exec spupdateDAT @ketqua out
select * from DAT

--test
select * from NHA_CUNG_CAP
select * from CUNG_CAP
select * from CUNG_CAP_CHI_TIET
select * from NGUYEN_VAT_LIEU
select * from KHACH_HANG
select * from DAT
select * from DAT_CHI_TIET
select * from SAN_PHAM
/*
-------------------------------------------------------------------------------------------------------------
MODULE PHỤC VỤ CÁC THAO TÁC XỬ LÝ DỮ LIỆU
-------------------------------------------------------------------------------------------------------------
*/

/*
1. Thủ tục spthemNhaCungCap
Khi thêm mới bản ghi vào bảng NHA_CUNG_CAP với các thông tin: tên nhà cung cấp, địa chỉ nhà cung cấp, số điện thoại nhà cung cấp, số tài khoản nhà cung cấp. 
Thực hiện:
	a. Kiểm tra số điện thoại có tồn tại trong bảng NHA_CUNG_CAP không. Nếu có, thông báo 'Số điện thoại đã tồn tại' và ngừng xử lý
	b. Kiểm tra số tài khoản có tồn tại trong bảng NHA_CUNG_CAP không. Nếu có, thông báo 'Số tài khoản đã tồn tại' và ngừng xử lý 	
	c. Tính mã nhà cung cấp mới. (mã nhà cung cấp mới = mã nhà cung cấp lớn nhất + 1)
	d. Thêm mới bản ghi vào bảng NHA_CUNG_CAP. 
Nếu thành công trả về 1, thất bại trả về 0

Input: tên nhà cung cấp, địa chỉ nhà cung cấp, số điện thoại nhà cung cấp, số tài khoản nhà cung cấp. 
Ouput: trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1.	Nếu @soDienThoaiNCC nằm trong (các SoDienThoai của nhà cung cấp): print 'Số điện thoại đã tồn tại' + kết thúc --> output = 0 

	2. 	Nếu @soTaiKhoanNCC nằm trong (các SoTaiKhoan của nhà cung cấp): 
			print 'Số tài khoản đã tồn tại' + kết thúc --> output = 0

	3.	mã nhà cung cấp mới = mã nhà cung cấp lớn nhất + 1
				
	4. 	Thêm mới bản ghi vào bảng NHA_CUNG_CAP 		
	5.	Nếu số dòng thay đổi <= 0: print N'Thêm thất bại' --> output = 0
						Ngược lại: print 'Thêm thành công'--> ouput = 1
*/

create or alter proc spthemNhaCungCap 	@tenNCC nvarchar(100),
										@diaChiNCC nvarchar(100),
										@soDienThoaiNCC varchar(15),
										@soTaiKhoanNCC varchar(20),
										@ketQua bit out

as
begin 
	declare @maNCC int
	--a
	if @soDienThoaiNCC in (select SoDienThoaiNCC from NHA_CUNG_CAP) 
	begin 
		print N'Số điện thoại đã tồn tại' 
		set @ketQua = 0
		return
	end

	--b
	if @soTaiKhoanNCC in (select SoTaiKhoanNCC from NHA_CUNG_CAP) 
	begin 
		print N'Số tài khoản đã tồn tại' 
		set @ketQua = 0
		return
	end

	--c
	set @maNCC = (select max(MaNCC) from NHA_CUNG_CAP) + 1 

	--d
	insert into NHA_CUNG_CAP(MaNCC, TenNCC, DiaChiNCC, SoDienThoaiNCC, SoTaiKhoanNCC)
	values (@maNCC, @tenNCC, @diaChiNCC, @soDienThoaiNCC, @soTaiKhoanNCC)
	
	if @@rowcount <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
	begin
		print N'Thêm thành công'
		set @ketQua = 1
	end
end


---test
declare @tenNCC nvarchar(100),
		@diaChiNCC nvarchar(100),
		@soDienThoaiNCC varchar(15),
		@soTaiKhoanNCC varchar(20),
		@ketQua bit 

set @tenNCC = N'Nhà cung cấp b'
set @diaChiNCC = N'Địa chỉ b'
set	@soDienThoaiNCC = '09022000009'
set	@soTaiKhoanNCC = '1800900029'

exec spthemNhaCungCap	@tenNCC,
						@diaChiNCC,
						@soDienThoaiNCC,
						@soTaiKhoanNCC,
						@ketQua out
print @ketQua

select * from NHA_CUNG_CAP
where TenNCC = N'Nhà cung cấp b'

/*
2. Thủ tục  spthemNguyenVatLieu
Khi thêm mới bản ghi vào bảng NGUYEN_VAT_LIEU với các thông tin: tên nguyên vật liệu, đơn vị tính, đơn giá.
Thực hiện:
	a.	Kiểm tra đơn giá có hợp lệ không (đơn giá > 0). Nếu không, thông báo 'Đơn giá không hợp lệ' và ngừng xử lý
	b. 	Tính mã nguyên vật liệu mới (mã nguyên vật liệu mới = max(mã nguyên vật liệu) + 1 )
	c.	Thêm mới bản ghi vào bảng NGUYEN_VAT_LIEU. 
Nếu thành công trả về 1, thất bại trả về 0
	
Input: tên nguyên vật liệu, đơn vị tính, đơn giá
Output: trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1. Nếu đơn giá <= 0: print 'Đơn giá không hợp lệ' + return  --> output = 0
	2. mã nguyên vật liệu mới = max(mã nguyên vật liệu) + 1  
	3. Thêm mới bản ghi vào bảng NGUYEN_VAT_LIEU 	
	4. Nếu số dòng thay đổi sau khi thêm mới <= 0: thông báo Thêm thất bại --> output = 0
										Ngược lại:	thông báo Thêm thành công --> output = 1
*/

create or alter proc spthemNguyenVatLieu	@tenNVL nvarchar(100),
											@donViTinh nvarchar(10),
											@donGia numeric(15,3),
											@ketQua bit out
as
begin
	declare @maNVL int
	--a
	if @donGia <= 0
	begin
		print N'Đơn giá không hợp lệ' 
		return
		set @ketQua = 0
	end
	
	--b
	set @maNVL = (select max(MaNVL) from NGUYEN_VAT_LIEU) + 1 

	--c
	insert into NGUYEN_VAT_LIEU (MaNVL, TenNVL, DonViTinh, DonGia)
	values (@maNVL, @tenNVL, @donViTinh, @donGia)

	if @@rowcount <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
	begin 
		print N'Thêm thành công'
		set @ketQua = 1
	end
end

--test
declare	@tenNVL nvarchar(100),
		@donViTinh nvarchar(10),
		@donGia numeric(15,3),
		@ketQua bit 
set @tenNVL = N'Nguyên vật liệu 10001'
set	@donViTinh = N'Cái'
set	@donGia = 2000.345

exec spthemNguyenVatLieu	@tenNVL ,
							@donViTinh,
							@donGia,
							@ketQua out
print @ketQua

select * from NGUYEN_VAT_LIEU
where	 TenNVL = N'Nguyên vật liệu 10001'


/*
3. Thủ tục spThemCungCap
Khi thêm mới bản ghi vào bảng CUNG_CAP với các thông tin: ngày cung cấp, hình thức thanh toán, mức thuế suất 
Thực hiện các nhiệm vụ:
	a. Kiểm tra ngày cung cấp có hợp lệ không (hợp lệ: ngày cung cấp <= ngày hiện tại). Nếu không, thông báo 'Ngày cung cấp không hợp lệ' và ngừng xử lý
	b. Kiểm tra hình thức thanh toán có hợp lệ không (hợp lệ: thuộc loại tiền mặt (1) hoặc chuyển khoản (0)). Nếu không, thông báo 'Hình thức thanh toán không hợp lệ' và ngừng xử lý
	c. Kiểm tra mức thuế suất có hợp lệ không (hợp lệ: 0 <= mức thuế suất <= 1.000). Nếu không, thông báo 'Mức thuế suất GTGT không hợp lệ' và ngừng xử lý
	d. Kiểm tra mã nhà cung cấp có tồn tại trong bảng NHA_CUNG_CAP không. Nếu không, thông báo 'Mã nhà cung cấp không tồn tại' và ngừng xử lý
	e. Tính mã cung cấp mới. Với mã cung cấp mới = mã cung cấp lớn nhất + 1
	f. Tính ký hiệu hoá đơn mới. Với ký hiệu hoá đơn = ký hiệu hoá đơn lớn nhất + 1
	g. Tính tổng tiền nguyên vật liệu (Tổng tiền nguyên vật liệu = sum (thành tiền) của bảng CUNG_CAP_CHI_TIET)	
	h. Tính tiền thuế giá trị gia tăng (Tiền thuế GTGT = Tổng tiền nguyên vật liệu * Mức thuế suất GTGT)
	i. Tính tổng tiền thanh toán (Tổng tiền thanh toán = tổng tiền nguyên vật liệu + tiền thuế giá trị gia tăng)
	k. Thêm mới bản ghi vào bảng CUNG_CAP. 
Nếu thành công trả về 1, thất bại trả về 0
	
Input: ngày cung cấp, hình thức thanh toán, mức thuế suất 
Output: trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1. Nếu ngày cung cấp > ngày hiện tại: print 'Ngày cung cấp không hợp lệ' + return  --> output = 0
	2. Nếu @hinhThucThanhToan không thuộc tập hợp (1,0): print 'Hình thức thanh toán không hợp lệ' + return  --> output = 0
	3. Nếu @mucThueSuat < 0 hoặc @mucThueSuat > 1.000: print 'Mức thuế suất GTGT không hợp lệ' + return --> output = 0
	4. Nếu @maNCC không nằm trong (các mã nhà cung cấp của nhà cung cấp): print 'Nhà cung cấp không tồn tại' + kết thúc --> output = 0
	5. mã cung cấp mới = mã cung cấp lớn nhất + 1 --> @maCCMax
	6. Lay ký hiệu hoá đơn lớn nhất của bảng CUNG_CAP --> @kyHieuHDMax
	7. Tính @kyHieuHDMax + 1 --> @kyHieuHD
	8. Đảm bảo độ dài ký tự của @kyHieuHD là 7
	9. @tongTienNguyenVatLieu = sum(ThanhTien) của bảng CUNG_CAP_CHI_TIET với điều kiện MaCC = @maCC
	10. @tienThueGTGT = tongTienNguyenVatLieu * mức thuế suất GTGT của bảng CUNG_CAP_CHI_TIET với điều kiện MaCC = @maCC
	11. @tongTienThanhToan = @tongTienNVL + @tienThueGTGT
	12. Thêm mới bản ghi vào bảng CUNG_CAP 	
	13. Nếu số dòng thay đổi <= 0: print N'Thêm thất bại' + return --> Output = 0
						Ngược lại: thông báo Thêm thành công --> Output: 1
*/
create or alter proc spThemCungCap	@ngayCungCap date,
									@hinhThucThanhToan char(1),
									@mucThueSuat numeric(15,3),
									@maNCC int,
									@ketQua bit out
as
begin
	declare @maCC int, 
			@kyHieuHD char(7),
			@tongTienNVL numeric(15,3),
			@tienThueGTGT numeric(15,3),
			@tongTienThanhToan numeric(15,3),
			@kyHieuHDMax char(7),
			@kyHieuHDMoi int

	--a
	/*if @ngayCungCap >= cast(getdate() as date)
	begin
		print N'Ngày cung cấp không hợp lệ'
		set @ketQua = 0
		return
	end*/
	
	--b
	if @hinhThucThanhToan not in ('1','0')
	begin
		print N'Hình thức thanh toán không hợp lệ'
		set @ketQua = 0
		return
	end
	
	--c
	if @mucThueSuat < 0 or @mucThueSuat > 1.000
	begin
		print N'Mức thuế suất GTGT không hợp lệ'
		set @ketQua = 0
		return
	end
	
	--d
	if @maNCC not in (select MaNCC from NHA_CUNG_CAP)
	begin
		print N'Nhà cung cấp không tồn tại'
		set @ketQua = 0
		return
	end

	--e
	set @maCC = (select max(MaCC) from CUNG_CAP) +  1
	
	--f
	set @kyHieuHDMax = (select max(KyHieuHD) from CUNG_CAP)
	set @kyHieuHDMoi = @kyHieuHDMax + 1
	set @kyHieuHD = right ('0000000' + cast(@kyHieuHDMoi as varchar(7)),7)

	--g
	set @tongTienNVL = (select sum(ThanhTien) from CUNG_CAP_CHI_TIET where MaCC = @maCC)

	--h
	set @tienThueGTGT = @tongTienNVL * (select MucThueSuatGTGT from CUNG_CAP where MaCC = @maCC)

	--i
	set @tongTienThanhToan = @tongTienNVL + @tienThueGTGT

	--k
	insert into CUNG_CAP (MaCC, KyHieuHD, NgayCungCap, HinhThucThanhToan, TongTienNVL, MucThueSuatGTGT, TienThueGTGT, TongTienThanhToan, MaNCC)
	values (@maCC, @kyHieuHD, @ngayCungCap, @hinhThucThanhToan, @tongTienNVL, @mucThueSuat, @tienThueGTGT, @tongTienThanhToan ,@maNCC)
	
	if @@ROWCOUNT <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
	end
	else
	begin 
		print N'Thêm thành công'
		set @ketQua = 1
	end
end

--test
declare @ngayCungCap date, 
		@hinhThucThanhToan char(1),
		@mucThueSuat numeric(15,3),
		@maNCC int,
		@ketQua bit 

set @ngayCungCap = '2024-02-22'
set @hinhThucThanhToan = '0'
set	@mucThueSuat = 0.091
set @maNCC = 2

exec spThemCungCap			@ngayCungCap, 
							@hinhThucThanhToan,
							@mucThueSuat,
							@maNCC,
							@ketQua out
							
print @ketQua

go
declare @kq bit 
EXEC spThemCungCap '16-12-2024', '0', 0,9, @kq out  
print @kq

/*
4. Thủ tục  spthemCungCapChiTiet
Khi thêm mới bản ghi vào bảng CUNG_CAP_CHI_TIET với thông tin: mã cung cấp, mã nguyên vật liệu, số lượng
Thực hiện các nhiệm vụ:
	a.	Kiểm tra mã cung cấp có tồn tại trong bảng CUNG_CAP_CHI_TIET không. Nếu có, thông báo 'Mã cung cấp đã tồn tại' và ngừng xử lý
	b.	Kiểm tra mã nguyên vật liệu có tồn tại trong bảng NGUYEN_VAT_LIEU không. Nếu không, thông báo 'Mã nguyên vật liệu không tồn tại' và ngừng xử lý 
	c	Kiểm tra bộ mã nguyên vật liệu và mã cung cấp có tồn tại trong bảng CUNG_CAP_CHI_TIET không. Nếu có, thông báo 'Nguyên liệu đã tồn tại, chỉ được sửa không được thêm mới' và ngừng xử lý 
	d.	Kiểm tra số lượng có hợp lệ không (hợp lệ: số lượng > 0). Nếu không, thông báo 'Số lượng không hợp lệ' và ngừng xử lý
	e	Tính thành tiền (thành tiền = số lượng * đơn giá)
	f. 	Thêm mới bản ghi vào bảng CUNG_CAP_CHI_TIET. 
Nếu thành công trả về 1, thất bại trả về 0

Input: 	@maCC
Output:	Nếu @maCC tồn tại, thông báo 'Mã cung cấp đã tồn tại' + return
Process:
	1. Nếu @maCC nằm trong các mã cung cấp của bảng CUNG_CAP: print 'Mã cung cấp đã tồn tại' + return --> output = 0
	2. Nếu @maNVL không nằm trong các mã cung cấp của bảng NGUYEN_VAT_LIEU: print 'Mã nguyên vật liệu không tồn tại' + return --> output = 0
	3. Nếu @maCC, @maNVL nằm trong các bộ mã khoá của bảng CUNG_CAP_CHI_TIET: print 'Nguyên vật liệu không hợp lệ' + return --> output = 0
	4. Nếu @soLuong <= 0 : print 'Số lượng không hợp lệ' + return  --> output =0
	5. Thành tiền = Số lượng * Đơn giá
	6. 	Thêm mới bản ghi vào bảng CUNG_CAP_CHI_TIET 	
	7. 	Nếu số dòng thay đổi <= 0: thông báo thêm thất bại + kết thúc --> output = 0
						Ngược lại: thông báo thêm thành công --> output = 1
*/

create or alter proc spthemCungCapChiTiet	@maCC int, @maNVL int, @soLuong numeric(15,3), @ketQua bit out
as
begin
	declare @thanhTien numeric

	--a
	if @maCC not in (select MaCC from CUNG_CAP) 
	begin
		print N'Mã cung cấp không tồn tại'
		set @ketQua = 0
		return
	end
	
	--b
	if @maNVL not in (select MaNVL from NGUYEN_VAT_LIEU) 
	begin
		print N'Mã nguyên vật liệu không tồn tại'
		set @ketQua = 0
		return
	end

	--c
    if exists (select 1 from CUNG_CAP_CHI_TIET where MaCC = @maCC and MaNVL = @maNVL)
    begin
        print N'Nguyên vật liệu không hợp lệ'
        set @ketQua = 0
        return
    end
	
	--d
	if @soLuong <= 0
	begin
		print N'Số lượng không hợp lệ'
		set @ketQua = 0
		return
	end

	--e
	set @thanhTien = @soLuong * (Select DonGia from NGUYEN_VAT_LIEU where MaNVL = @maNVL)

	--f
	insert into CUNG_CAP_CHI_TIET (MaCC, MaNVL, SoLuong, ThanhTien)
	values (@maCC, @maNVL, @soLuong, @thanhTien)
	
	if @@ROWCOUNT <= 0 
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
	begin
		print N'Thêm thành công'
		set @ketQua = 1
	end
end

--test
declare @maCC int, @maNVL int, @soLuong numeric(15,3), @ketQua bit 
set @maCC = 1000
set @maNVL = 2
set @soLuong = 5.123

exec spthemCungCapChiTiet @maCC, @maNVL, @soLuong, @ketQua out  
print @ketQua

select * from CUNG_CAP_CHI_TIET
where MaCC = 1000
and	  MaNVL = 2
and	  SoLuong = 5.123
select * from CUNG_CAP_CHI_TIET



/*
5. Trigger tinsertCungCapChiTiet
Khi thêm 1 bản ghi  trong bảng CUNG_CAP_CHI_TIET. 
cập nhật thành tiền của bảng CUNG_CAP_CHI_TIET
cập nhật tổng tiền nguyên vật liệu, tiền thuế giá trị gia tăng, tổng tiền thanh toán trong bảng CUNG_CAP

Process:
    1. Lấy thông tin Mã cung cấp, Mã nguyên vật liệu và Số lượng từ bảng inserted.
    2. Tính thành tiền bằng cách nhân Số lượng với Đơn giá (lấy từ bảng NGUYEN_VAT_LIEU).
    3. Cập nhật cột ThanhTien trong bảng CUNG_CAP_CHI_TIET với giá trị đã tính.
    4. Tính tổng tiền nguyên vật liệu (@tongTienNVL) bằng cách cộng tổng thành tiền trong bảng CUNG_CAP_CHI_TIET với điều kiện MaCC.
    5. Tính tiền thuế GTGT (@tienThueGTGT) bằng cách nhân @tongTienNVL với MucThueSuatGTGT (lấy từ bảng CUNG_CAP).
    6. Tính tổng tiền thanh toán (@tongTienThanhToan) bằng cách cộng @tongTienNVL và @tienThueGTGT.
    7. Cập nhật các cột TongTienNVL, TienThueGTGT, và TongTienThanhToan trong bảng CUNG_CAP với điều kiện MaCC.
*/
create or alter trigger tinsertCungCapChiTiet
on CUNG_CAP_CHI_TIET
after insert
as
begin
    declare @maCC int,
			@maNVL int,
			@soLuong numeric (15,3),
			@tongTienNVL numeric(15,3),
			@tienThueGTGT numeric(15,3),
			@tongTienThanhToan numeric(15,3)


		select @maCC = MaCC,@maNVL = MaNVL, @soLuong = SoLuong from inserted
		update CUNG_CAP_CHI_TIET
		set ThanhTien = @soLuong * (select DonGia from NGUYEN_VAT_LIEU where MaNVL = @maNVL)
		where MaCC = @maCC and MaNVL = @maNVL

		

		set @tongTienNVL = (select sum(ThanhTien) from CUNG_CAP_CHI_TIET where MaCC = @maCC)
		set @tienThueGTGT = @tongTienNVL * (select MucThueSuatGTGT from CUNG_CAP where MaCC = @maCC)
		set @tongTienThanhToan = @tongTienNVL + @tienThueGTGT
		update CUNG_CAP
		set TongTienNVL = @tongTienNVL,
		TienThueGTGT = @tienThueGTGT,
		TongTienThanhToan = @tongTienThanhToan
		where MaCC = @maCC
end

insert into CUNG_CAP_CHI_TIET (MaCC, MaNVL, SoLuong)
values (2, 5, 1.000)

/*
6. Trigger tdeleteCungCapChiTiet
Khi xoá một bản ghi trong bảng CUNG_CAP_CHI_TIET.
cập nhật tổng tiền nguyên vật liệu, tiền thuế giá trị gia tăng, tổng tiền thanh toán trong bảng CUNG_CAP.
Nếu cập nhật thành công: thông báo 'Cập nhật thành công'. Ngược lại: thông báo 'Cập nhật không thành công'

Process:
	1. Lấy thông tin Mã cung cấp và Thành tiền từ bảng deleted.
	2. Cập nhật tổng tiền nguyên vật liệu trong bảng CUNG_CAP bằng cách trừ thành tiền của bản ghi đã xóa.
	3. Tính tiền thuế GTGT bằng cách nhân tổng tiền nguyên vật liệu với MucThueSuatGTGT (lấy từ bảng CUNG_CAP).
	4. Cập nhật tổng tiền thanh toán bằng cách cộng tổng tiền nguyên vật liệu và tiền thuế GTGT.
	5. Cập nhật các cột TongTienNVL, TienThueGTGT, và TongTienThanhToan trong bảng CUNG_CAP với điều kiện MaCC.
   	6. Nếu số dòng cập nhật <= 0:  	print 'Cập nhật không thành công'
                                	Ngược lại:       	print 'Cập nhật thành công'
*/
 
go
create or alter trigger tdeleteCungCapChiTiet
on CUNG_CAP_CHI_TIET
after delete
as
begin
	declare @maCC int,
                  	@maNVL int,
                  	@thanhTien numeric (15,3)
 
   	select @maCC = MaCC,@maNVL = MaNVL, @thanhTien = ThanhTien from deleted
   	update CUNG_CAP
   	set TongTienNVL =  TongTienNVL - @thanhTien,
   	TienThueGTGT = TongTienNVL * (select MucThueSuatGTGT from CUNG_CAP where MaCC = @maCC),
   	TongTienThanhToan = TongTienNVL + TienThueGTGT
   	where MaCC = @maCC
 
   	if @@ROWCOUNT <= 0
   	begin
          	print N'Cập nhật không thành công'
   	end
   	else
          	print N'Cập nhật thành công'
end
 
 
--test
delete from CUNG_CAP_CHI_TIET
where MaCC = 1 and MaNVL = 1
select * from CUNG_CAP
select * from CUNG_CAP_CHI_TIET


/*
7. Thủ tục spupdateSoLuongCCCT
Khi sửa số lượng trong bảng CUNG_CAP_CHI_TIET. Thực hiện:
	a. Cập nhật lại thành tiền trong bảng CUNG_CAP_CHI_TIET
	b. Cập nhật tổng tiền nguyên vật liệu, tiền thuế giá trị gia tăng, tổng tiền thanh toán trong bảng CUNG_CAP
	c. Nếu cập nhật thành công trả về 1, ngược lại trả về 0

Input:số lượng (@soLuong)
Output: kết quả cập nhật thành tiền trong bảng CUNG_CAP_CHI_TIET (0: thất bại | 1: thành công)
Process:
	1. Nếu số lượng = số lượng trong bảng CUNG_CAP_CHI_TIET điều kiện MaCC = @maCC của số lượng sửa and MaNVL = @maNVL của số lượng sửa
			1.1. Đúng: print N'Số lượng không đổi. Nhập lại nếu muốn sửa' --> output = 0
			1.2 Ngược lại:
					1.2.1 gán @donGia = đơn giá của bảng CUNG_CAP_CHI_TIET với MaCC = @maCC của số lượng sửa and MaNVL = @maNVL của số lượng sửa
					1.2.2  @thanhTien = @soLuong * @donGia
					1.2.3. cập nhật số lượng = soLuong, thành tiền = thanhTien của bảng CUNG_CAP_CHI_TIET với điều kiện: MaCC = @maCC and MaNVL = @maNVL
					1.2.4 Nếu số dòng sau cập nhật <= 0: thông báo cập nhật thất bại + kết thúc --> output = 0
					1.2.5 Ngược lại: 
							1.2.5.1 Tính tổng tiền nguyên vật liệu (@tongTienNVL) từ bảng CUNG_CAP_CHI_TIET với điều kiện MaCC = @maCC và MaNVL = @maNVL.
							1.2.5.2 Tính tiền thuế GTGT (@tienThueGTGT) dựa trên tổng tiền nguyên vật liệu nhân với mức thuế suất GTGT trong bảng CUNG_CAP có MaCC = @maCC.
							1.2.5.3 Tính tổng tiền thanh toán (@tongTienThanhToan) bằng cách cộng tổng tiền nguyên vật liệu và tiền thuế GTGT.
							1.2.5.4 Cập nhật TongTienNVL, TienThueGTGT, TongTienThanhToan trong bảng CUNG_CAP với điều kiện MaCC = @maCC.
									1.2.5.4.1  Nếu số dòng sau cập nhật <= 0: thông báo cập nhật thất bại + kết thúc --> output = 0
									1.2.5.4.2 Ngược lại: 
											1.2.5.4.2.1. Nếu số dòng sau cập nhật <= 0
											1.2.5.4.2.2. Nếu @@ROWCOUNT <= 0, thông báo cập nhật thất bại + kết thúc --> output = 0
											1.2.5.4.2.3. Nếu @@ROWCOUNT > 0, thông báo cập nhật thành công  --> output = 1
*/
create or alter proc spupdateSoLuongCCCT 	@soLuong numeric(15,3),
											@maCC int,
											@maNVL int,
											@ketQua bit out
as
begin
	declare @thanhTien numeric(15,3),
			@donGia numeric(15,3),
			@tongTienNVL numeric(15,3),
			@tienThueGTGT numeric(15,3),
			@tongTienThanhToan numeric(15,3)
	--a
	if @soLuong = (select SoLuong from CUNG_CAP_CHI_TIET where MaCC = @maCC and MaNVL = @maNVL)
	begin 
		print N'Số lượng không đổi. Nhập lại nếu muốn sửa'
		set @ketQua = 0
		return
	end
	
	set @donGia = (select DonGia from NGUYEN_VAT_LIEU where MaNVL = @maNVL)
	set @thanhTien = @soLuong * @donGia
	update CUNG_CAP_CHI_TIET
	set SoLuong = @soLuong,
	ThanhTien = @thanhTien
	where MaCC = @maCC and MaNVL = @maNVL
	if @@ROWCOUNT <= 0 
	begin 
		print N'Cập nhật thất bại'
		set @ketQua = 0
		return
	end
	else 
	begin 
		--b
		set @tongTienNVL = (select sum(ThanhTien) from CUNG_CAP_CHI_TIET where MaCC = @maCC and MaNVL = @maNVL)
		set @tienThueGTGT = @tongTienNVL *  (select MucThueSuatGTGT from CUNG_CAP where MaCC = @maCC)
		set @tongTienThanhToan = @tongTienNVL + @tienThueGTGT
	
		update CUNG_CAP
		set TongTienNVL = @tongTienNVL,
		TienThueGTGT = @tienThueGTGT,
		TongTienThanhToan = @tongTienThanhToan
		where MaCC = @maCC

		--c
		if @@ROWCOUNT <= 0 
		begin 
			print N'Cập nhật thất bại'
			set @ketQua = 0
			return
		end
		else 
		begin
			print N'Cập nhật thành công'
			set @ketQua = 1
		end
	end
end

--test
declare	@soLuong numeric(15,3),
		@maCC int,
		@maNVL int,
		@ketQua bit 

set @soLuong = 5
set @maCC = 2
set @maNVL = 2

exec spupdateSoLuongCCCT		@soLuong ,
								@maCC ,
								@maNVL ,
								@ketQua out
print @ketQua
select * from CUNG_CAP_CHI_TIET

/*
8. Hàm dbo.ftraVeDanhSachCCCT
Trả về danh sách cung cấp chi tiết khi tìm kiếm bằng mã cung cấp
Input: mã cung cấp
Output: bảng với các cột:
						[Tên nguyên vật liệu], 
						[Đơn vị tính],
						[Số lượng],
						[Đơn giá] ,
						[Thành tiền] 
Process:
1. Lấy thông tin từ bảng CUNG_CAP_CHI_TIET và NGUYEN_VAT_LIEU dựa trên @maCC.
2. Từ bảng CUNG_CAP_CHI_TIET, lấy cột SoLuong và ThanhTien cho từng nguyên vật liệu có trong mã cung cấp @maCC.
3. Từ bảng NGUYEN_VAT_LIEU, lấy cột TenNVL, DonViTinh, và DonGia tương ứng với mỗi nguyên vật liệu có mã cung cấp @maCC.
4. Trả về danh sách bao gồm các cột [Tên nguyên vật liệu], [Đơn vị tính], [Số lượng], [Đơn giá], và [Thành tiền].

*/

create or alter function dbo.ftraVeDanhSachCCCT (@maCC int)
returns @ketQua table	
( 
[Tên nguyên vật liệu] nvarchar(50),
[Đơn vị tính] nvarchar(10),
[Số lượng] numeric (15,3),
[Đơn giá] numeric (15,3),
[Thành tiền] numeric (15,3)
)
as
begin 
	insert into @ketQua
	select TenNVL as N'Tên nguyên vật liệu',
	NGUYEN_VAT_LIEU.DonViTinh as N'Đơn vị tính',
	SoLuong as N'Số lượng',
	NGUYEN_VAT_LIEU.DonGia as N'Đơn giá',
	ThanhTien as N'Thành tiền'
	from CUNG_CAP_CHI_TIET 
	join NGUYEN_VAT_LIEU on CUNG_CAP_CHI_TIET.MaNVL = NGUYEN_VAT_LIEU.MaNVL
	where CUNG_CAP_CHI_TIET.MaCC = @maCC
	return
end

--test
select * from dbo.ftraVeDanhSachCCCT(10)

/*
9.Hàm dbo.ftraVeDanhSachCC
Trả về danh sách hoá đơn cung cấp khi tìm kiếm bằng tên nhà cung cấp
Input:
	Tên nhà cung cấp (@tenNCC)
Output:
Bảng với các cột:
	[Số]: mã cung cấp từ bảng CUNG_CAP.
	[Ký hiệu hoá đơn]: ký hiệu hoá đơn từ bảng CUNG_CAP.
	[Ngày cung cấp]: ngày cung cấp từ bảng CUNG_CAP.
	[Hình thức thanh toán]: hình thức thanh toán từ bảng CUNG_CAP.
	[Tổng tiền nguyên vật liệu]: tổng tiền nguyên vật liệu từ bảng CUNG_CAP.
	[Mức thuế suất GTGT]: mức thuế suất GTGT từ bảng CUNG_CAP.
	[Tiền thuế suất GTGT]: tiền thuế suất GTGT từ bảng CUNG_CAP.
	[Tổng tiền thanh toán]: tổng tiền thanh toán từ bảng CUNG_CAP.
	[Tên nhà cung cấp]: tên nhà cung cấp từ bảng NHA_CUNG_CAP.
Process:
1. Tìm kiếm các nhà cung cấp trong bảng NHA_CUNG_CAP có tên chứa chuỗi ký tự giống với @tenNCC bằng cách sử dụng mệnh đề LIKE '%@tenNCC%'.
2. Từ bảng CUNG_CAP, lấy các thông tin liên quan đến hoá đơn cung cấp gồm: mã cung cấp (MaCC), ký hiệu hoá đơn (KyHieuHD), ngày cung cấp (NgayCungCap), hình thức thanh toán (HinhThucThanhToan), tổng tiền nguyên vật liệu (TongTienNVL), mức thuế suất GTGT (MucThueSuatGTGT), tiền thuế GTGT (TienThueGTGT), và tổng tiền thanh toán (TongTienThanhToan).
3. Kết hợp thông tin từ bảng CUNG_CAP và bảng NHA_CUNG_CAP dựa trên MaNCC để lấy tên nhà cung cấp (TenNCC).
4. Trả về danh sách gồm các thông tin trên từ bảng CUNG_CAP liên quan đến các nhà cung cấp có tên tương tự với @tenNCC.
*/

create or alter function dbo.ftraVeDanhSachCC (@tenNCC nvarchar(100))
returns @ketQua table	
( 
[Số] int,
[Ký hiệu hoá đơn] char(7),
[Ngày cung cấp] date,
[Hình thức thanh toán] char(1),
[Tổng tiền nguyên vật liệu] numeric(15,3),
[Mức thuế suất GTGT] numeric(15,3),
[Tiền thuế suất GTGT] numeric(15,3),
[Tổng tiền thanh toán] numeric(15,3),
[Tên nhà cung cấp] nvarchar(100)
)
as
begin 
	insert into @ketQua
	select MaCC as N'Số',
	KyHieuHD as N'Ký hiệu hoá đơn',
	NgayCungCap as N'Ngày cung cấp',
	HinhThucThanhToan as N'Hình thức thanh toán',
	TongTienNVL as N'Tổng tiền nguyên vật liệu',
	MucThueSuatGTGT as N'Mức thuế suất GTGT',
	TienThueGTGT as N'Tiền thuế suất GTGT',
	TongTienThanhToan as N'Tổng tiền thanh toán',
	TenNCC as N'Tên nhà cung cấp'
	from NHA_CUNG_CAP
	join CUNG_CAP on NHA_CUNG_CAP.MaNCC = CUNG_CAP.MaNCC
	where TenNCC like  '%' + @tenNCC  + '%'
	return
end

select * from dbo.ftraVeDanhSachCC(N'Nhà cung cấp 20')



/*
10. Thủ tục spthemKhachHang
Khi thêm mới bản ghi vào bảng KHACH_HANG với các thông tin: 
tên khách hàng, địa chỉ khách hàng, số điện thoại khách hàng, số tài khoản khách hàng. 
Thực hiện các nhiệm vụ:
	a. Kiểm tra số điện thoại có tồn tại trong bảng KHACH_HANG không. Nếu có, thông báo 'Số điện thoại đã tồn tại' và ngừng xử lý
	b. Kiểm tra số tài khoản có tồn tại trong bảng KHACH_HANG không. Nếu có, thông báo 'Số tài khoản đã tồn tại' và ngừng xử lý 	
	c. Tính mã khách hàng mới. Với mã khách hàng mới = max(mã khách hàng) + 1
	d. Thêm mới bản ghi vào bảng KHACH_HANG. 
Nếu thành công trả về 1, thất bại trả về 0

Input:tên khách hàng, địa chỉ khách hàng, số điện thoại khách hàng, số tài khoản khách hàng. 
Output: trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1. 	Nếu @soDienThoaiKH nằm trong (các SoDienThoai của khách hàng): 
			print 'Số tài khoản đã tồn tại' + kết thúc  --> output = 0
	1. 	Nếu @soTaiKhoanKH nằm trong (các SoTaiKhoan của khách hàng): 
			print 'Số tài khoản đã tồn tại' + kết thúc --> output = 0
	1.	mã khách hàng mới = max(mã khách hàng) + 1		
	1. 	Thêm mới bản ghi vào bảng KHACH_HANG 	
	2. 	Nếu số dòng thay đổi <= 0: thông báo thêm thất bại + kết thúc --> output = 0
						Ngược lại: thông báo thêm thành công --> output = 1
*/

create or alter proc spthemKhachHang 	@tenKH nvarchar(100),
										@diaChiKH nvarchar(100),
										@soDienThoaiKH varchar(15),
										@soTaiKhoanKH varchar(20),
										@ketQua bit out

as
begin 
	declare @maKH int
	--a
	if @soDienThoaiKH in (select SoDienThoaiKH from KHACH_HANG) 
	begin 
		print N'Số điện thoại đã tồn tại' 
		set @ketQua = 0
		return
	end

	--b
	if @soTaiKhoanKH in (select SoTaiKhoanKH from KHACH_HANG) 
	begin 
		print N'Số tài khoản đã tồn tại' 
		set @ketQua = 0
		return
	end

	--c
	set @maKH = (select max(MaKH) from KHACH_HANG) + 1

	--d
	insert into KHACH_HANG(MaKH, TenKh, DiaChiKH, SoDienThoaiKH, SoTaiKhoanKH)
	values (@maKH, @tenKH, @diaChiKH, @soDienThoaiKH, @soTaiKhoanKH)
	
	if @@rowcount <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
	begin
		print N'Thêm thành công'
		set @ketQua = 1
	end
end


---test
declare @tenKH nvarchar(100),
		@diaChiKH nvarchar(100),
		@soDienThoaiKH varchar(15),
		@soTaiKhoanKH varchar(20),
		@ketQua bit 

set @tenKH = N'khách hàng 1001'
set @diaChiKH = N'Địa chỉ 1001'
set	@soDienThoaiKH = '03000001001'
set	@soTaiKhoanKH = '6000001001'

exec spthemKhachHang	@tenKH,
						@diaChiKH,
						@soDienThoaiKH,
						@soTaiKhoanKH,
						@ketQua out
print @ketQua


/*
11. Thủ tục spthemsanPham
Khi thêm mới bản ghi vào bảng SAN_PHAM với các thông tin: tên sản phẩm, đơn vị tính, đơn giá.
Thực hiện các nhiệm vụ:
	a.	Kiểm tra đơn giá có hợp lệ không (đơn giá > 0). Nếu không, thông báo 'Đơn giá không hợp lệ' và ngừng xử lý
	b. 	Tính mã sản phẩm mới. (mã sản phẩm mới = mã sản phẩm lớn nhất + 1 )
	c.	Thêm mới bản ghi vào bảng SAN_PHAM. 
Nếu thành công trả về 1, thất bại trả về 0
	
Input: tên sản phẩm, đơn vị tính, đơn giá.
Output: trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1.	Nếu đơn giá <= 0: print 'Đơn giá không hợp lệ' + return  --> output = 0
	2.	Tính mã sản phẩm lớn nhất + 1 --> @maSP
	3. 	Thêm mới bản ghi vào bảng SAN_PHAM 	
	4. 	Nếu số dòng thay đổi <= 0: thông báo thêm thất bại + kết thúc --> output = 0
						Ngược lại: thông báo thêm thành công --> output = 1
*/

create or alter proc spthemSanPham	@tenSP nvarchar(100),
									@donViTinh nvarchar(10),
									@donGia numeric(15,3),
									@ketQua bit out
as
begin
	declare @maSP int
	--a
	if @donGia <= 0
	begin
		print N'Đơn giá không hợp lệ' 
		return
		set @ketQua = 0
	end
	
	--b
	set @maSP = (select max(MaSP) from SAN_PHAM) + 1

	--c
	insert into SAN_PHAM (MaSP, TenSP, DonViTinh, DonGia)
	values (@maSP, @tenSP, @donViTinh, @donGia)
	if @@rowcount <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
		set @ketQua = 1
end

--test
declare	@tenSP nvarchar(100),
		@donViTinh nvarchar(10),
		@donGia numeric(15,3),
		@ketQua bit 
set @tenSP = N'sản phẩm 10001'
set	@donViTinh = N'Cái'
set	@donGia = 2000.345

exec spthemSanPham	@tenSP ,
					@donViTinh,
					@donGia,
					@ketQua out
print @ketQua

/*
12. Thủ tục spThemDat
Khi thêm mới bản ghi vào bảng DAT với các thông tin: ngày đặt sản phẩm, hình thức thanh toán, mức thuế suất, mã khách hàng
Thực hiện các nhiệm vụ:
	a. Kiểm tra ngày đặt sản phẩm có hợp lệ không (hợp lệ: ngày đặt sản phẩm <= ngày hiện tại). Nếu không, thông báo 'ngày đặt sản phẩm không hợp lệ' và ngừng xử lý
	b. Kiểm tra hình thức thanh toán có hợp lệ không (hợp lệ: thuộc loại tiền mặt (1) hoặc chuyển khoản (0)). Nếu không, thông báo 'Hình thức thanh toán không hợp lệ' và ngừng xử lý
	c. Kiểm tra mức thuế suất có hợp lệ không (hợp lệ: 0 <= mức thuế suất <= 1.000). Nếu không, thông báo 'Mức thuế suất GTGT không hợp lệ' và ngừng xử lý
	d. Kiểm tra mã khách hàng có tồn tại trong bảng DAT không. Nếu không, thông báo 'mã khách hàng không tồn tại' và ngừng xử lý
	e. Tính mã đặt mới. Với mã đặt mới = mã đặt lớn nhất + 1
	f. Tính ký hiệu hoá đơn mới. Với ký hiệu hoá đơn = ký hiệu hoá đơn lớn nhất + 1
	g. Thêm mới bản ghi vào bảng DAT
Nếu thành công trả về 1, thất bại trả về 0
	
Input:ngày đặt sản phẩm, hình thức thanh toán, mức thuế suất, mã khách hàng
Output:trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1. Nếu ngày đặt sản phẩm > ngày hiện tại: print 'ngày đặt sản phẩm không hợp lệ' + return  --> output = 0
	2. Nếu @hinhThucThanhToan không thuộc tập hợp (1,0): print 'Hình thức thanh toán không hợp lệ' + return --> output = 0
	3. Nếu @mucThueSuat < 0 và @mucThueSuat > 1.000: print 'Mức thuế suất GTGT không hợp lệ' + return --> output = 0
	4. Nếu @maKH không nằm trong (các mã khách hàng của nhà đặt): print 'Khách hàng không tồn tại' + kết thúc  --> output = 0
	5. @maD = max(mã đặt) của bảng DAT + 1
	6. Lay ký hiệu hoá đơn lớn nhất của bảng CUNG_CAP --> @kyHieuHDMax
	7. Tính @kyHieuHDMax + 1 --> @kyHieuHD
	8. Đảm bảo độ dài ký tự của @kyHieuHD là 7
	9. chuyển đổi @kyHieuHD2 đúng 7 ký tự --> @kyHieuHD
	10. Thêm mới bản ghi vào bảng DAT 	
	11. Nếu số dòng thay đổi <= 0: thông báo thêm thất bại + kết thúc --> output = 0
						Ngược lại: thông báo thêm thành công --> output = 1

*/
create or alter proc spThemDat	@ngayDat date,
								@hinhThucThanhToan char(1),
								@mucThueSuat numeric(15,3),
								@maKH int,
								@ketQua bit out
									
as
begin
	declare @maD int, @kyHieuHD char(7), @kyHieuHD2 int

	--a
	/*if @ngayDat >= cast(getdate() as date)
	begin
		print N'ngày đặt sản phẩm không hợp lệ'
		set @ketQua = 0
		return
	end*/
	
	--b
	if @hinhThucThanhToan not in ('1','0')
	begin
		print N'Hình thức thanh toán không hợp lệ'
		set @ketQua = 0
		return
	end
	
	--c
	if @mucThueSuat < 0 or @mucThueSuat > 1.000
	begin
		print N'Mức thuế suất GTGT không hợp lệ'
		set @ketQua = 0
		return
	end
	
	--d
	if @maKH not in (select MaKH from KHACH_HANG)
	begin
		print N'Khách hàng không tồn tại'
		set @ketQua = 0
		return
	end

	--e
	set @maD = (select max(MaD) from DAT) + 1
	
	--f
	set @kyHieuHD2 = (select max(KyHieuHD) from DAT) + 1
	set @kyHieuHD = right ('0000000' + cast(@kyHieuHD2 as varchar(7)),7)

	--g
	insert into DAT (MaD, KyHieuHD, NgayDat, HinhThucThanhToan, MucThueSuatGTGT, MaKH)
	values (@maD, @kyHieuHD, @ngayDat, @hinhThucThanhToan, @mucThueSuat, @maKH)
	
	if @@ROWCOUNT <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
	begin
		print N'Thêm thành công'
		set @ketQua = 1
	end
end

--test
declare @ngayDat date, 
		@hinhThucThanhToan char(1),
		@mucThueSuat numeric(15,3),
		@maKH int,
		@ketQua bit 

set @ngayDat = '2024-02-22'
set @hinhThucThanhToan = '0'
set	@mucThueSuat = 0.095
set @maKH = 2

exec spThemDat				@ngayDat, 
							@hinhThucThanhToan,
							@mucThueSuat,
							@maKH,
							@ketQua out
							
print @ketQua
select * from DAT where NgayDat = '2024-02-22'

/*
13. Thủ tục spthemDatChiTiet
Khi thêm mới bản ghi vào bảng DAT_CHI_TIET với thông tin: mã đặt, mã sản phẩm, số lượng
Thực hiện:
	a.	Kiểm tra mã đặt có tồn tại trong bảng DAT_CHI_TIET không. Nếu có, thông báo 'Mã đặt đã tồn tại' và ngừng xử lý
	b.	Kiểm tra mã sản phẩm có tồn tại trong bảng SAN_PHAM không. Nếu không, thông báo 'Mã sản phẩm không tồn tại' và ngừng xử lý 
	c	Kiểm tra bộ mã sản phẩm và mã đặt có tồn tại trong bảng DAT_CHI_TIET không. Nếu có, thông báo 'Sản phẩm đã tồn tại, chỉ được sửa không được thêm mới' và ngừng xử lý 
	d.	Kiểm tra số lượng có hợp lệ không (hợp lệ: số lượng > 0). Nếu không, thông báo 'Số lượng không hợp lệ' và ngừng xử lý
	e	Tính thành tiền (thành tiền = số lượng * đơn giá)
	f. 	Thêm mới bản ghi vào bảng DAT_CHI_TIET
Nếu thành công trả về 1, thất bại trả về 0

Input:mã đặt, mã sản phẩm, số lượng
Output: trả về kết quả thực hiện (0: insert thất bại | 1: insert thành công)
Process:
	1. Nếu @maD không nằm trong các mã đặt của bảng DAT: print 'Mã đặt không tồn tại' + return --> output = 0
	1. Nếu @maSP không nằm trong các mã đặt của bảng SAN_PHAM: print 'Mã sản phẩm không tồn tại' + return --> output = 0
	1. Nếu @maD, @maSP nằm trong các bộ mã khoá của bảng DAT_CHI_TIET: print 'Sản phẩm không hợp lệ' + return --> output = 0
	1. Nếu @soLuong <= 0 : print 'Số lượng không hợp lệ' + return --> output = 0
	1. Thành tiền = Số lượng * Đơn giá
	1. 	Thêm mới bản ghi vào bảng DAT_CHI_TIET 	
	2. 	Nếu số dòng thay đổi <= 0: thông báo thêm thất bại + kết thúc --> output = 0
						Ngược lại: thông báo thêm thành công--> output = 1

*/

create or alter proc spthemDatChiTiet	@maD int, @maSP int, @soLuong int, @ketQua bit out
as
begin
	declare @thanhTien numeric

	--a
	if @maD not in (select MaD from DAT) 
	begin
		print N'Mã đặt không tồn tại'
		set @ketQua = 0
		return
	end
	
	--b
	if @maSP not in (select MaSP from SAN_PHAM) 
	begin
		print N'Mã sản phẩm không tồn tại'
		set @ketQua = 0
		return
	end

	--c
    if exists (select 1 from DAT_CHI_TIET where MaD = @maD and MaSP = @maSP)
    begin
        print N'sản phẩm đã tồn tại, chỉ được sửa không được thêm mới'
        set @ketQua = 0
        return
    end
	
	--d
	if @soLuong <= 0
	begin
		print N'Số lượng không hợp lệ'
		set @ketQua = 0
		return
	end

	--e
	set @thanhTien = @soLuong * (Select DonGia from SAN_PHAM where MaSP = @maSP)

	--f
	insert into DAT_CHI_TIET (MaD, MaSP, SoLuong, ThanhTien)
	values (@maD, @maSP, @soLuong, @thanhTien)
	
	if @@ROWCOUNT <= 0
	begin
		print N'Thêm thất bại'
		set @ketQua = 0
		return
	end
	else
	begin 
		print N'Thêm thành công'
		set @ketQua = 1
	end
end

--test
declare @maD int, @maSP int, @soLuong int, @ketQua bit 
set @maD = 1
set @maSP = 1000
set @soLuong = 5

exec spthemDatChiTiet @maD, @maSP, @soLuong, @ketQua out  
print @ketQua

select * from DAT_CHI_TIET
where MaD = 1

/*
14. Trigger tinsertDatChiTiet
Khi thêm 1 bản ghi  trong bảng DAT_CHI_TIET. 
cập nhật thành tiền của bảng DAT_CHI_TIET
cập nhật tổng tiền sản phẩm, tiền thuế giá trị gia tăng, tổng tiền thanh toán trong bảng DAT
Process:
	1.Lấy đơn giá của sản phẩm từ bảng SAN_PHAM với MaSP = @maSP.
	2.Tính thành tiền (ThanhTien) = @soLuong * DonGia.
	3.Cập nhật cột ThanhTien trong bảng DAT_CHI_TIET cho bản ghi vừa được thêm với MaD = @maD và MaSP = @maSP.
	4.Tính tổng tiền sản phẩm (@tongTienSP) bằng cách lấy tổng của các cột ThanhTien từ bảng DAT_CHI_TIET với MaD = @maD.
	5.Tính tiền thuế GTGT (@tienThueGTGT) = @tongTienSP * MucThueSuatGTGT từ bảng DAT với MaD = @maD.
	6.Tính tổng tiền thanh toán (@tongTienThanhToan) = @tongTienSP + @tienThueGTGT.
	7.Cập nhật các cột TongTienSP, TienThueGTGT, và TongTienThanhToan trong bảng DAT với MaD = @maD.
	8. Nếu số dòng cập nhật <= 0: thông báo 'Cập nhật không thành công' 
	Ngược lại: thông báo 'Cập nhật thành công'
*/
create or alter trigger tinsertDatChiTiet
on DAT_CHI_TIET
after insert
as
begin
    declare @maD int,
			@maSP int,
			@soLuong numeric (15,3),
			@tongTienSP numeric (15,3),
			@tienThueGTGT numeric (15,3),
			@tongTienThanhToan numeric (15,3)

		select @maD = MaD,@maSP = MaSP, @soLuong = SoLuong from inserted
		update DAT_CHI_TIET
		set ThanhTien = @soLuong * (select DonGia from SAN_PHAM where MaSP = @maSP)
		where MaD = @maD and MaSP = @maSP

		set @tongTienSP = (select sum(ThanhTien) from DAT_CHI_TIET where MaD = @maD)
		set @tienThueGTGT = @tongTienSP * (select MucThueSuatGTGT from DAT where MaD = @maD)
		set @tongTienThanhToan = @tongTienSP + @tienThueGTGT

		update DAT
		set TongTienSP = @tongTienSP,
		TienThueGTGT = @tienThueGTGT,
		TongTienThanhToan = @tongTienThanhToan
		where MaD = @maD

		if @@ROWCOUNT <= 0 
		begin 
			print N'Cập nhật không thành công'
		end
		else 
			print N'Cập nhật thành công'
end

insert into DAT_CHI_TIET (MaD, MaSP, SoLuong)
values (1, 3, 1.000)

	
select * from DAT
where MaD = 1
select * from DAT_CHI_TIET

/*
15.  Trigger tdeleteDatChiTiet
Khi sửa số lượng trong bảng DAT_CHI_TIET. 
cập nhật tổng tiền sản phẩm, tiền thuế giá trị gia tăng, tổng tiền thanh toán trong bảng DAT

Process:
	1. Lấy tổng tiền của sản phẩm bị xóa (@thanhTien) từ bảng deleted.
	2. Giảm tổng tiền sản phẩm (TongTienSP) bằng cách trừ đi @thanhTien.
	3. Tính lại tiền thuế GTGT (TienThueGTGT) dựa trên TongTienSP * MucThueSuatGTGT từ bảng DAT với MaD = @maD.
	4. Tính lại tổng tiền thanh toán (TongTienThanhToan) = TongTienSP + TienThueGTGT.
	5. Cập nhật các cột TongTienSP, TienThueGTGT, và TongTienThanhToan trong bảng DAT với MaD = @maD.
	6. Nếu số dòng cập nhật <= 0: thông báo 'Xoá không thành công' 
		Ngược lại: thông báo 'Xoá thành công'

*/
go
create or alter trigger tdeleteDatChiTiet
on DAT_CHI_TIET
after delete
as
begin
    declare @maD int,
			@maSP int,
			@thanhTien numeric (15,3)

	select @maD = MaD,@maSP = MaSP, @thanhTien = ThanhTien from deleted
	update DAT
	set TongTienSP =  TongTienSP - @thanhTien,
	TienThueGTGT = TongTienSP * (select MucThueSuatGTGT from DAT where @maD = MaD),
	TongTienThanhToan = TongTienSP + TienThueGTGT
	where MaD =@maD 

	if @@ROWCOUNT <= 0 
	begin 
		print N'Xoá không thành công'
	end
	else 
		print N'Xoá thành công'
end

--test
delete from DAT_CHI_TIET
where MaD = 1 and MaSP = 2

/*
16. Thủ tục spupdateSoLuongDCT
Khi sửa số lượng trong bảng DAT_CHI_TIET. Thực hiện:
	a. Cập nhật lại thành tiền trong bảng DAT_CHI_TIET
	b. Cập nhật tổng tiền sản phẩm, tiền thuế giá trị gia tăng, tổng tiền thanh toán trong bảng DAT
	c. Nếu cập nhật thành công trả về 1, ngược lại trả về 0

Input:số lượng (@soLuong)
Output: kết quả cập nhật thành tiền trong bảng DAT_CHI_TIET (0: thất bại | 1: thành công)
Process:
	1. Nếu số lượng = số lượng trong bảng DAT_CHI_TIET điều kiện MaCC = @maCC của số lượng sửa and MaSP = @maSPL của số lượng sửa
			1.1. Đúng: print N'"Số lượng không đổi. Nhập lại nếu muốn sửa" --> output = 0
			1.2 Ngược lại:
					1.2.1 Lấy đơn giá sản phẩm từ bảng SAN_PHAM với MaSP = @maSP.
					1.2.2 Tính thành tiền (@thanhTien) = @soLuong * @donGia.
					1.2.3 Cập nhật cột SoLuong và ThanhTien trong bảng DAT_CHI_TIET với điều kiện MaD = @maD và MaSP = @maSP.
					1.2.4 Nếu số dòng sau cập nhật <= 0: thông báo cập nhật thất bại + kết thúc --> output = 0
					1.2.5 Ngược lại: 
						1.2.5.1.Tính tổng tiền sản phẩm (@tongTienSP) từ bảng DAT_CHI_TIET cho đơn đặt hàng (@maD).
						1.2.5.2. Tính tiền thuế GTGT (@tienThueGTGT) = @tongTienSP * MucThueSuatGTGT từ bảng DAT.
						1.2.5.3. Tính tổng tiền thanh toán (@tongTienThanhToan) = @tongTienSP + @tienThueGTGT.
						1.2.5.4. Cập nhật các cột TongTienSP, TienThueGTGT, và TongTienThanhToan trong bảng DAT với điều kiện MaD = @maD.
									1.2.5.4.1  Nếu số dòng sau cập nhật <= 0: thông báo cập nhật thất bại + kết thúc --> output = 0
									1.2.5.4.2 Ngược lại: 
											1.2.5.4.2.1. Nếu số dòng sau cập nhật <= 0
											1.2.5.4.2.2. Nếu @@ROWCOUNT <= 0, thông báo cập nhật thất bại + kết thúc --> output = 0
											1.2.5.4.2.3. Nếu @@ROWCOUNT > 0, thông báo cập nhật thành công  --> output = 1
*/
create or alter proc spupdateSoLuongDCT 	@soLuong int,
											@maD int,
											@maSP int,
											@ketQua bit out
as
begin
	declare @thanhTien numeric(15,3),
			@donGia numeric(15,3),
			@tongTienSP numeric(15,3),
			@tienThueGTGT numeric(15,3),
			@tongTienThanhToan numeric(15,3)
	--a
	if @soLuong = (select SoLuong from DAT_CHI_TIET where MaD = @maD and MaSP = @maSP)
	begin 
		print N'Số lượng không đổi. Nhập lại nếu muốn sửa'
		set @ketQua = 0
		return
	end
	
	set @donGia = (select DonGia from SAN_PHAM where MaSP = @maSP)
	set @thanhTien = @soLuong * @donGia
	update DAT_CHI_TIET
	set SoLuong = @soLuong,
	ThanhTien = @thanhTien
	where MaD = @maD and MaSP = @maSP
	if @@ROWCOUNT <= 0 
	begin 
		print N'Cập nhật thất bại'
		set @ketQua = 0
		return
	end
	else 
	begin
		set @tongTienSP = (select sum(ThanhTien) from DAT_CHI_TIET where MaD = @maD and MaSP = @maSP)
		set @tienThueGTGT = @tongTienSP *  (select MucThueSuatGTGT from DAT where MaD = @maD)
		set @tongTienThanhToan = @tongTienSP + @tienThueGTGT
	
		update DAT
		set @tongTienSP = @tongTienSP,
		TienThueGTGT = @tienThueGTGT,
		TongTienThanhToan = @tongTienThanhToan
		where MaD = @maD
		if @@ROWCOUNT <= 0 
		begin 
			print N'Cập nhật thất bại'
			set @ketQua = 0
			return
		end
		else 
		begin
			print N'Cập nhật thành công'
			set @ketQua = 1
		end
	end
end

--test
declare	@soLuong int,
		@maD int,
		@maSP int,
		@ketQua bit 

set @soLuong = 5
set @maD = 2
set @maSP = 2

exec spupdateSoLuongDCT	@soLuong,
						@maD ,
						@maSP ,
						@ketQua out 
print @ketQua

select * from DAT_CHI_TIET

/*
17. Hàm dbo.ftraVeDanhSachDCT
Trả về danh sách đặt chi tiết khi tìm kiếm bằng mã đặt
Input:
    Mã đơn đặt hàng (@MaD)
Output:
    Danh sách các sản phẩm trong bảng DAT_CHI_TIET với các cột:
        [Tên sản phẩm],
        [Đơn vị tính],
        [Số lượng],
        [Đơn giá],
        [Thành tiền]
Process:
    1. Thực hiện truy vấn để lấy thông tin các sản phẩm từ bảng DAT_CHI_TIET dựa trên Mã đơn đặt hàng (@MaD).
    2. Kết hợp thông tin từ bảng SAN_PHAM để lấy tên sản phẩm và đơn vị tính.
    3. Chọn các cột: Tên sản phẩm, Đơn vị tính, Số lượng, Đơn giá và Thành tiền.
    4. Trả về kết quả dưới dạng bảng @ketQua.
*/


create or alter function dbo.ftraVeDanhSachDCT (@MaD int)
returns @ketQua table	
( 
[Tên sản phẩm] nvarchar(50),
[Đơn vị tính] nvarchar(10),
[Số lượng] numeric (15,3),
[Đơn giá] numeric (15,3),
[Thành tiền] numeric (15,3)
)
as
begin 
	insert into @ketQua
	select TenSP as N'Tên sản phẩm',
	SAN_PHAM.DonViTinh as N'Đơn vị tính',
	SoLuong as N'Số lượng',
	SAN_PHAM.DonGia as N'Đơn giá',
	ThanhTien as N'Thành tiền'
	from DAT_CHI_TIET 
	join SAN_PHAM on DAT_CHI_TIET.MaSP = SAN_PHAM.MaSP
	where DAT_CHI_TIET.MaD = @maD
	return
end

select * from dbo.ftraVeDanhSachDCT(101)

/*
18. Hàm  dbo.ftraVeDanhSachHDD
Trả về danh sách hoá đơn đặt khi tìm kiếm bằng tên khách hàng
Input:
    Tên khách hàng (@tenKH)
Output:
    Danh sách các hoá đơn trong bảng DAT với các cột:
        [Số],
        [Ký hiệu hoá đơn],
        [Ngày đặt],
        [Hình thức thanh toán],
        [Tổng tiền sản phẩm],
        [Mức thuế suất GTGT],
        [Tiền thuế suất GTGT],
        [Tổng tiền thanh toán],
        [Tên khách hàng]
Process:
    1. Thực hiện truy vấn để lấy thông tin các hoá đơn từ bảng DAT dựa trên tên khách hàng (@tenKH).
    2. Kết hợp thông tin từ bảng KHACH_HANG để lấy tên khách hàng.
    3. Chọn các cột: Số, Ký hiệu hoá đơn, Ngày đặt, Hình thức thanh toán, Tổng tiền sản phẩm, Mức thuế suất GTGT, Tiền thuế suất GTGT, Tổng tiền thanh toán và Tên khách hàng.
    4. Trả về kết quả dưới dạng bảng @ketQua.
*/

create or alter function dbo.ftraVeDanhSachHDD (@tenKH nvarchar(100))
returns @ketQua table	
( 
[Số] int,
[Ký hiệu hoá đơn] char(7),
[Ngày đặt] date,
[Hình thức thanh toán] char(1),
[Tổng tiền sản phẩm] numeric(15,3),
[Mức thuế suất GTGT] numeric(15,3),
[Tiền thuế suất GTGT] numeric(15,3),
[Tổng tiền thanh toán] numeric(15,3),
[Tên khách hàng] nvarchar(100)
)
as
begin 
	insert into @ketQua
	select MaD as N'Số',
	KyHieuHD as N'Ký hiệu hoá đơn',
	NgayDat as N'Ngày đặt',
	HinhThucThanhToan as N'Hình thức thanh toán',
	TongTienSP as N'Tổng tiền sản phẩm',
	MucThueSuatGTGT as N'Mức thuế suất GTGT',
	TienThueGTGT as N'Tiền thuế suất GTGT',
	TongTienThanhToan as N'Tổng tiền thanh toán',
	TenKH as N'Tên khách hàng'
	from KhACH_HANG
	join DAT on KhACH_HANG.MaKH = DAT.MaKH
	where TenKH like  '%' + @tenKH  + '%'
	return
end

select * from dbo.ftraVeDanhSachHDD(N'Khách hàng 20')









