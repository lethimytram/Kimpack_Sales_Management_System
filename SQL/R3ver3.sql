-------------------------------------------------------------VERSION 3----------------------------------------------------
/*Thủ tục spsuaKhachHang
Thủ tục sửa thông tin khách hàng
*/
create or alter proc spsuaKhachHang  
    @maKH int,
    @tenKH nvarchar(100),
    @diaChiKH nvarchar(100),
    @soDienThoaiKH varchar(15),
    @soTaiKhoanKH varchar(20),
    @ketQua bit out
as
begin 
    if exists (select 1 from KHACH_HANG where SoDienThoaiKH = @soDienThoaiKH and MaKH <> @maKH) 
    begin 
        print N'Số điện thoại đã tồn tại' 
        set @ketQua = 0
        return
    end

    if exists (select 1 from KHACH_HANG where SoTaiKhoanKH = @soTaiKhoanKH and MaKH <> @maKH) 
    begin 
        print N'Số tài khoản đã tồn tại' 
        set @ketQua = 0
        return
    end

    -- Cập nhật thông tin khách hàng
    update KHACH_HANG
    set 
        TenKh = @tenKH, 
        DiaChiKH = @diaChiKH, 
        SoDienThoaiKH = @soDienThoaiKH, 
        SoTaiKhoanKH = @soTaiKhoanKH
    where MaKH = @maKH
    
    -- Kiểm tra xem có thay đổi dòng nào không
    if @@rowcount <= 0
    begin
        print N'Không tìm thấy khách hàng hoặc cập nhật thất bại'
        set @ketQua = 0
        return
    end
    else
    begin
        print N'Cập nhật thành công'
        set @ketQua = 1
    end
end

/*Thủ tục spsuaNhaCungCap
Thủ tục sửa thông tin nhà cung cấp
*/
select * from NHA_CUNG_CAP
create or alter proc spsuaNhaCungCap
    @maNCC int,
    @tenNCC nvarchar(100),
    @diaChiNCC nvarchar(100),
    @soDienThoaiNCC varchar(15),
    @soTaiKhoanNCC varchar(20),
    @ketQua bit out
as
begin 
    declare @existingPhoneCount int
    declare @existingAccountCount int
    
    -- Kiểm tra số điện thoại có trùng với nhà cung cấp khác không
    set @existingPhoneCount = (select count(*) from NHA_CUNG_CAP where SoDienThoaiNCC = @soDienThoaiNCC and MaNCC <> @maNCC)
    if @existingPhoneCount > 0 
    begin 
        print N'Số điện thoại đã tồn tại' 
        set @ketQua = 0
        return
    end

    -- Kiểm tra số tài khoản có trùng với nhà cung cấp khác không
    set @existingAccountCount = (select count(*) from NHA_CUNG_CAP where SoTaiKhoanNCC = @soTaiKhoanNCC and MaNCC <> @maNCC)
    if @existingAccountCount > 0 
    begin 
        print N'Số tài khoản đã tồn tại' 
        set @ketQua = 0
        return
    end

    -- Kiểm tra xem nhà cung cấp có tồn tại hay không
    if not exists (select 1 from NHA_CUNG_CAP where MaNCC = @maNCC)
    begin
        print N'Nhà cung cấp không tồn tại'
        set @ketQua = 0
        return
    end

    -- Cập nhật thông tin nhà cung cấp
    update NHA_CUNG_CAP
    set 
        TenNCC = @tenNCC, 
        DiaChiNCC = @diaChiNCC, 
        SoDienThoaiNCC = @soDienThoaiNCC, 
        SoTaiKhoanNCC = @soTaiKhoanNCC
    where MaNCC = @maNCC

    -- Kiểm tra kết quả cập nhật
    if @@rowcount <= 0
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

/*
Thủ tục sửa thông tin sản phẩm 

*/
create or alter proc spsuaSanPham
    @maSP int,
    @tenSP nvarchar(100),
    @donViTinh nvarchar(10),
    @donGia numeric(15,3),
    @ketQua bit out
as
begin
    -- Kiểm tra đơn giá hợp lệ
    if @donGia <= 0
    begin
        print N'Đơn giá không hợp lệ'
        set @ketQua = 0
        return
    end

    -- Cập nhật thông tin sản phẩm
    update SAN_PHAM
    set TenSP = @tenSP,
        DonViTinh = @donViTinh,
        DonGia = @donGia
    where MaSP = @maSP

    -- Kiểm tra xem có dòng nào bị thay đổi không
    if @@rowcount <= 0
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

/*
thủ tục sửa thông tin nguyên vật liệu 
*/
create or alter proc spsuaNguyenVatLieu
    @maNVL int,
    @tenNVL nvarchar(100),
    @donViTinh nvarchar(10),
    @donGia numeric(15,3),
    @ketQua bit out
as
begin
    -- Kiểm tra đơn giá hợp lệ
    if @donGia <= 0
    begin
        print N'Đơn giá không hợp lệ'
        set @ketQua = 0
        return
    end

    -- Cập nhật thông tin nguyên vật liệu
    update NGUYEN_VAT_LIEU
    set TenNVL = @tenNVL,
        DonViTinh = @donViTinh,
        DonGia = @donGia
    where MaNVL = @maNVL

    -- Kiểm tra xem có dòng nào bị thay đổi không
    if @@rowcount <= 0
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
/* Thủ tục xoá khách hàng
*/
CREATE OR ALTER PROCEDURE spXoaKhachHang
    @MaKH INT,
    @KetQua BIT OUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Xóa các dòng tham chiếu trong bảng DAT_CHI_TIET
        DELETE FROM DAT_CHI_TIET
        WHERE MaD IN (
            SELECT MaD FROM DAT WHERE MaKH = @MaKH
        );

        -- Xóa các dòng tham chiếu trong bảng DAT
        DELETE FROM DAT WHERE MaKH = @MaKH;

        -- Xóa khách hàng trong bảng KHACH_HANG
        DELETE FROM KHACH_HANG WHERE MaKH = @MaKH;

        -- Kiểm tra xem khách hàng đã được xóa chưa
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT N'Khách hàng đã được xóa thành công.';
            SET @KetQua = 1; -- Thành công
        END
        ELSE
        BEGIN
            PRINT N'Không có khách hàng nào bị xóa.';
            SET @KetQua = 0; -- Thất bại
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
        SET @KetQua = 0; -- Thất bại
    END CATCH
END;

/*
Thủ tục xoá nhà cung cấp
*/
CREATE OR ALTER PROCEDURE spXoaNhaCungCap
    @MaNCC INT,
    @KetQua BIT OUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Xóa các dòng tham chiếu trong bảng DAT_CHI_TIET
        DELETE FROM CUNG_CAP_CHI_TIET
        WHERE MaCC IN (
            SELECT MaCC FROM CUNG_CAP WHERE MaNCC = @MaNCC
        );

        -- Xóa các dòng tham chiếu trong bảng DAT
        DELETE FROM CUNG_CAP WHERE MaNCC = @MaNCC;

        -- Xóa khách hàng trong bảng KHACH_HANG
        DELETE FROM NHA_CUNG_CAP WHERE MaNCC = @MaNCC;

        -- Kiểm tra xem khách hàng đã được xóa chưa
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT N'Nhà cung cấp đã được xóa thành công.';
            SET @KetQua = 1; -- Thành công
        END
        ELSE
        BEGIN
            PRINT N'Không có nhà cung cấp nào bị xóa.';
            SET @KetQua = 0; -- Thất bại
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
        SET @KetQua = 0; -- Thất bại
    END CATCH
END;

/*
Thủ tục xoá sản phẩm
*/
CREATE OR ALTER PROCEDURE spXoaSanPham
    @MaSP INT,
    @KetQua BIT OUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;


        -- Xóa các dòng tham chiếu trong bảng DAT_CHI_TIET
        DELETE FROM DAT_CHI_TIET WHERE MaSP = @MaSP;

        -- Xóa khách hàng trong bảng KHACH_HANG
        DELETE FROM SAN_PHAM WHERE MaSP = @MaSP;

        -- Kiểm tra xem khách hàng đã được xóa chưa
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT N'Sản phẩm đã được xóa thành công.';
            SET @KetQua = 1; -- Thành công
        END
        ELSE
        BEGIN
            PRINT N'Không có sản phẩm nào bị xóa.';
            SET @KetQua = 0; -- Thất bại
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
        SET @KetQua = 0; -- Thất bại
    END CATCH
END;


/*
Thủ tục xoá nguyên vật liệu
*/
CREATE OR ALTER PROCEDURE spXoaNguyenVatLieu
    @MaNVL INT,
    @KetQua BIT OUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;


        -- Xóa các dòng tham chiếu trong bảng DAT_CHI_TIET
        DELETE FROM CUNG_CAP_CHI_TIET WHERE MaNVL = @MaNVL;

        -- Xóa khách hàng trong bảng KHACH_HANG
        DELETE FROM NGUYEN_VAT_LIEU WHERE MaNVL = @MaNVL;

        -- Kiểm tra xem khách hàng đã được xóa chưa
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT N'Nguyên vật liệu đã được xóa thành công.';
            SET @KetQua = 1; -- Thành công
        END
        ELSE
        BEGIN
            PRINT N'Không có nguyên vật liệu nào bị xóa.';
            SET @KetQua = 0; -- Thất bại
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
        SET @KetQua = 0; -- Thất bại
    END CATCH
END;

/*
Thủ tục xoá cung_cap
*/
CREATE OR ALTER PROCEDURE spXoaCungCap
    @MaCC INT,
    @KetQua BIT OUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;


        -- Xóa các dòng tham chiếu trong bảng DAT_CHI_TIET
        DELETE FROM CUNG_CAP_CHI_TIET WHERE MaCC = @MaCC;

        -- Xóa khách hàng trong bảng KHACH_HANG
        DELETE FROM CUNG_CAP WHERE MaCC = @MaCC;

        -- Kiểm tra xem khách hàng đã được xóa chưa
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT N'Hoá đơn mua nguyên vật liệu đã được xóa thành công.';
            SET @KetQua = 1; -- Thành công
        END
        ELSE
        BEGIN
            PRINT N'Không có hoá đơn mua nguyên vật liệu nào bị xóa.';
            SET @KetQua = 0; -- Thất bại
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
        SET @KetQua = 0; -- Thất bại
    END CATCH
END;

-----------------
CREATE OR ALTER PROCEDURE spXoaDatHang
    @MaD INT,          -- Mã đơn đặt hàng cần xóa
    @KetQua BIT OUT    -- Tham số kết quả trả về
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Xóa các dòng trong bảng DAT_CHI_TIET liên quan đến MaD
        DELETE FROM DAT_CHI_TIET
        WHERE MaD = @MaD;

        -- Xóa đơn đặt hàng trong bảng DAT
        DELETE FROM DAT
        WHERE MaD = @MaD;

        -- Kiểm tra xem đơn đặt hàng đã được xóa chưa
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT N'Đơn đặt hàng đã được xóa thành công.';
            SET @KetQua = 1; -- Thành công
        END
        ELSE
        BEGIN
            PRINT N'Không tìm thấy đơn đặt hàng để xóa.';
            SET @KetQua = 0; -- Thất bại
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
        SET @KetQua = 0; -- Thất bại
    END CATCH
END;


-------------------------------
create or alter proc spSuaCungCap
    @maCC int,
    @ngayCungCap date,
    @hinhThucThanhToan char(1),
    @mucThueSuat numeric(15,3),
    @maNCC int,
    @ketQua bit out
as
begin
    declare @kyHieuHD char(7),
            @tongTienNVL numeric(15,3),
            @tienThueGTGT numeric(15,3),
            @tongTienThanhToan numeric(15,3),
            @kyHieuHDMax char(7),
            @kyHieuHDMoi int

    -- Kiểm tra xem bản ghi có tồn tại không
    if not exists (select 1 from CUNG_CAP where MaCC = @maCC)
    begin
        print N'Mã cung cấp không tồn tại'
        set @ketQua = 0
        return
    end

    -- Kiểm tra hình thức thanh toán hợp lệ
    if @hinhThucThanhToan not in ('1','0')
    begin
        print N'Hình thức thanh toán không hợp lệ'
        set @ketQua = 0
        return
    end

    -- Kiểm tra mức thuế suất hợp lệ
    if @mucThueSuat < 0 or @mucThueSuat > 1.000
    begin
        print N'Mức thuế suất GTGT không hợp lệ'
        set @ketQua = 0
        return
    end

    -- Kiểm tra mã nhà cung cấp có tồn tại
    if @maNCC not in (select MaNCC from NHA_CUNG_CAP)
    begin
        print N'Nhà cung cấp không tồn tại'
        set @ketQua = 0
        return
    end

    -- Lấy ký hiệu hoá đơn lớn nhất hiện tại
    set @kyHieuHDMax = (select max(KyHieuHD) from CUNG_CAP)
    set @kyHieuHDMoi = cast(@kyHieuHDMax as int) + 1
    set @kyHieuHD = right ('0000000' + cast(@kyHieuHDMoi as varchar(7)), 7)

    -- Tính tổng tiền nguyên vật liệu
    set @tongTienNVL = (select sum(ThanhTien) from CUNG_CAP join CUNG_CAP_CHI_TIET on CUNG_CAP.MaCC = CUNG_CAP_CHI_TIET.MaCC
						where CUNG_CAP_CHI_TIET.MaCC = @maCC)

    -- Tính tiền thuế giá trị gia tăng
    set @tienThueGTGT = @tongTienNVL * @mucThueSuat

    -- Tính tổng tiền thanh toán
    set @tongTienThanhToan = @tongTienNVL + @tienThueGTGT

    -- Cập nhật thông tin hoá đơn cung cấp
    update CUNG_CAP
    set 
        KyHieuHD = @kyHieuHD,
        NgayCungCap = @ngayCungCap,
        HinhThucThanhToan = @hinhThucThanhToan,
        TongTienNVL = @tongTienNVL,
        MucThueSuatGTGT = @mucThueSuat,
        TienThueGTGT = @tienThueGTGT,
        TongTienThanhToan = @tongTienThanhToan,
        MaNCC = @maNCC
    where MaCC = @maCC

    -- Kiểm tra kết quả của câu lệnh update
    if @@ROWCOUNT <= 0
    begin
        print N'Cập nhật thất bại'
        set @ketQua = 0
    end
    else
    begin
        print N'Cập nhật thành công'
        set @ketQua = 1
    end
end


create or alter proc spsuaCungCapChiTiet
    @maCC int,
    @maNVL int,
    @soLuong numeric(15,3),
    @ketQua bit out
as
begin
    declare @thanhTien numeric
    
    -- Kiểm tra số lượng có hợp lệ không (số lượng > 0)
    if @soLuong <= 0
    begin
        print N'Số lượng không hợp lệ'
        set @ketQua = 0
        return
    end

    -- Tính thành tiền
    set @thanhTien = @soLuong * (Select DonGia from NGUYEN_VAT_LIEU where MaNVL = @maNVL)

    -- Cập nhật thông tin chi tiết cung cấp
    update CUNG_CAP_CHI_TIET
    set SoLuong = @soLuong,
        ThanhTien = @thanhTien
    where MaCC = @maCC and MaNVL = @maNVL

    -- Kiểm tra kết quả cập nhật
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

select * from CUNG_CAP join CUNG_CAP_CHI_TIET on CUNG_CAP.MaCC = CUNG_CAP_CHI_TIET.MaCC where 
