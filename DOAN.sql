USE master;
GO

CREATE DATABASE QLDIEM;
GO

USE QLDIEM;
GO

CREATE PROC TAO_CSDL
AS
BEGIN
    CREATE TABLE MONHOC (
        MAMH nvarchar(50) PRIMARY KEY,
        TENMH nvarchar(30),
        SOTC int
    );

    CREATE TABLE LOP (
        MALOP nvarchar(20) PRIMARY KEY,
        TENLOP nvarchar(50),
        CVHT nvarchar(30)
    );

    CREATE TABLE SINHVIEN (
        MASV nvarchar(50) PRIMARY KEY,
        TENSV nvarchar(30),
        HOLOT nvarchar(20),
        PHAI bit,
        NGAYSINH date,
        DIACHI nvarchar(50),
        DIENTHOAI varchar(30),
        MALOP nvarchar(20),
        matkhau varchar(255),
        CONSTRAINT RB_KN FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
    );

    CREATE TABLE DIEM (
        MASV nvarchar(50),
        MAMH nvarchar(50),
        DIEMCC float,
        DiemTD float,
        DIEMGK float,
        DiemDA float,
        DIEMCK float,
        CONSTRAINT RB_KN_MASV FOREIGN KEY (MASV) REFERENCES SINHVIEN(MASV),
        CONSTRAINT RB_KN_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
    );
END;
GO

CREATE PROCEDURE InsertMONHOC
    @p_mamh nvarchar(50),
    @p_tenmh nvarchar(30),
    @p_sotc int,
    @message nvarchar(255) output
AS
BEGIN
    IF (@p_sotc > 4 OR @p_sotc < 1)
    BEGIN
        SET @message = N'Số tín chỉ của môn học không hợp lệ';
    END
    ELSE
    BEGIN
        INSERT INTO MONHOC (MAMH, TENMH, SOTC)
        VALUES (@p_mamh, @p_tenmh, @p_sotc);
		SET @message = N'Thêm mới thành công';
    END
END;

EXEC InsertMONHOC N'AAA', N'Test thôi', 5;
GO

CREATE PROCEDURE UpdateMONHOC
    @u_mamh nvarchar(50),
    @u_tenmh nvarchar(30),
    @u_sotc int,
	@message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF (@u_sotc > 4 OR @u_sotc < 1)
    BEGIN
        SET @message = N'Số tín chỉ của môn học không hợp lệ';
    END
    ELSE
    BEGIN
        UPDATE MONHOC
        SET TENMH = @u_tenmh, SOTC = @u_sotc
        WHERE MAMH = @u_mamh;
		SET @message = N'Cập nhật thành công'
    END
END;
GO

EXEC UpdateMONHOC N'TORR', N'TOÁN RỜI RẠC', 3;
GO

CREATE PROCEDURE UpdateLOP
    @u_malop nvarchar(20),
    @u_tenlop nvarchar(50),
    @u_cvht nvarchar(30),
	@message NVARCHAR(255) OUTPUT
AS
BEGIN
    UPDATE LOP
    SET TENLOP = @u_tenlop, CVHT = @u_cvht
    WHERE MALOP = @u_malop;
	SET @message = N'Cập nhật thành công!'
END;
GO

EXEC UpdateLOP N'K29CDM', N'CAO ĐẲNG CÔNG NGHỆ PHẦN MỀM', N'PHẠM VĂN ẤT';
GO

CREATE PROCEDURE ChangePassword
    @cp_masv nvarchar(50),
	@cp_matkhau nvarchar(100),
	@matkhau_xacnhan nvarchar(100),
    @message nvarchar(255) OUTPUT,
	@status int OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MASV = @cp_masv)
    BEGIN
		IF @cp_matkhau != @matkhau_xacnhan
		BEGIN
			SET @message = N'Mật khẩu và mật khẩu xác nhận không giống!'
			SET @status = 0
		END
		ELSE
		BEGIN
			UPDATE SINHVIEN
			SET matkhau = @cp_matkhau
			WHERE MASV = @cp_masv;
			SET @message = N'Cập nhật thành công';
			SET @status = 1
		END
    END
    ELSE
    BEGIN
        SET @message = N'Sinh viên không tồn tại';
		SET @status = 0
    END
END;


CREATE PROCEDURE UpdateSINHVIEN
    @u_masv nvarchar(50),
    @u_holot nvarchar(20),
    @u_tensv nvarchar(30),
    @u_phai bit,
    @u_ngaysinh date,
    @u_diachi nvarchar(50),
    @u_dienthoai varchar(30),
    @u_malop nvarchar(20),
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LOP WHERE MALOP = @u_malop)
    BEGIN
        UPDATE SINHVIEN
        SET MALOP = @u_malop, TENSV = @u_tensv, HOLOT = @u_holot, PHAI = @u_phai,
            NGAYSINH = @u_ngaysinh, DIACHI = @u_diachi, DIENTHOAI = @u_dienthoai
        WHERE MASV = @u_masv;
		set @message = N'Cập nhật thành công';
    END
    ELSE
    BEGIN
        set @message = N'Lớp không tồn tại';
        END
END;
GO

EXEC UpdateSINHVIEN N'SV06', N'NGUYỄN VĂN', N'HUY', 1, '1994-05-03', N'HẢI CHÂU - ĐÀ NẴNG', '08949489', 'K19TPM', '03051994';
GO

CREATE PROCEDURE UpdateDIEM
    @u_masv nvarchar(50),
    @u_mamh nvarchar(50),
    @u_diemcc float,
    @u_diemtd float,
    @u_diemgk float,
    @u_diemda float,
    @u_diemck float,
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF ((@u_diemcc < 0 OR @u_diemcc > 10) OR (@u_diemtd < 0 OR @u_diemtd > 10) OR (@u_diemgk < 0 OR @u_diemgk > 10) OR
        (@u_diemda < 0 OR @u_diemda > 10) OR (@u_diemck < 0 OR @u_diemck > 10))
    BEGIN
        SET @message =  N'Điểm không hợp lệ';
    END
    ELSE
    BEGIN
        UPDATE DIEM
        SET DIEMCC = @u_diemcc, DIEMTD = @u_diemtd, DIEMGK = @u_diemgk, DIEMDA = @u_diemda, DIEMCK = @u_diemck
        WHERE MASV = @u_masv AND MAMH = @u_mamh;
		SET @message =  N'Cập nhật thành công';
    END
END;
GO

EXEC UpdateDIEM N'SV06', N'TORR', 10, 10, 10, 0.5, 10;
GO

CREATE PROCEDURE InsertLOP
    @p_malop nvarchar(20),
    @p_tenlop nvarchar(50),
    @p_cvht nvarchar(30),
	@message nvarchar(255) OUTPUT
AS
BEGIN
    INSERT INTO LOP (MALOP, TENLOP, CVHT)
    VALUES (@p_malop, @p_tenlop, @p_cvht);
	SET @message = N'Thêm mới thành công'
END;
GO

CREATE PROCEDURE InsertSinhVien
    @p_masv nvarchar(50),
    @p_tensv nvarchar(30),
    @p_holot nvarchar(20),
    @p_phai bit,
    @p_ngaysinh date,
    @p_diachi nvarchar(50),
    @p_dienthoai varchar(30),
    @p_malop nvarchar(20),
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE @MATKHAU varchar(255)
    SET @MATKHAU = CONVERT(varchar(4), YEAR(@p_ngaysinh)) + RIGHT('0' + CONVERT(varchar(2), MONTH(@p_ngaysinh)), 2) + RIGHT('0'
	+ CONVERT(varchar(2), DAY(@p_ngaysinh)), 2)
    IF EXISTS (SELECT 1 FROM LOP WHERE MALOP = @p_malop)
    BEGIN
        INSERT INTO SINHVIEN (MASV, TENSV, HOLOT, PHAI, NGAYSINH, DIACHI, DIENTHOAI, MALOP, matkhau)
        VALUES (@p_masv, @p_tensv, @p_holot, @p_phai, @p_ngaysinh, @p_diachi, @p_dienthoai, @p_malop, @MATKHAU);
		SET @message = N'Thêm mới thành công'
    END
    ELSE
    BEGIN
        set @message = N'Lớp không tồn tại';
    END
END;
GO

CREATE PROCEDURE InsertDIEM
    @p_masv nvarchar(50),
    @p_mamh nvarchar(50),
    @p_diemcc float,
    @p_diemtd float,
    @p_diemgk float,
    @p_diemda float,
    @p_diemck float,
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
	IF EXISTS(SELECT 1 FROM DIEM WHERE MASV = @p_masv AND MAMH = @p_mamh)
		SET @message = N'Bản ghi điểm đã tồn tại';
	ELSE
	BEGIN
		IF ((@p_diemcc < 0 OR @p_diemcc > 10) OR (@p_diemtd < 0 OR @p_diemtd > 10) OR (@p_diemgk < 0 OR @p_diemgk > 10) OR
			(@p_diemda < 0 OR @p_diemda > 10) OR (@p_diemck < 0 OR @p_diemck > 10))
		BEGIN
			SET @message = N'Điểm không hợp lệ';
		END
		ELSE
		BEGIN
			INSERT INTO DIEM (MASV, MAMH, DIEMCC, DIEMTD, DIEMGK, DIEMDA, DIEMCK)
			VALUES (@p_masv, @p_mamh, @p_diemcc, @p_diemtd, @p_diemgk, @p_diemda, @p_diemck);
			SET @message = N'Thêm mới thành công'
		END
	END
END;
GO

CREATE PROCEDURE authenticate_user
    @masv nvarchar(50),
    @matkhau nvarchar(255),
	@message nvarchar(255) OUTPUT,
	@status bit OUTPUT
AS
BEGIN
	IF EXISTS(SELECT * FROM SINHVIEN WHERE MASV = @masv AND matkhau = @matkhau)
	BEGIN
		SET @message = N'Đăng nhập thành công'
		SET @status = 1
	END
	ELSE
	BEGIN
		SET @message = N'Tài khoản hoặc mật khẩu không chính xác'
		SET @status = 0
	END
END;
GO

CREATE PROCEDURE DeleteSINHVIEN
    @masv nvarchar(50),
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SINHVIEN WHERE MASV = @masv)
    BEGIN
        set @message = N'Sinh viên không tồn tại!';
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM DIEM WHERE MASV = @masv)
        BEGIN
            set @message = N'Sinh viên có liên quan đến bảng DIEM. Cần xóa dữ liệu liên quan trước!';
        END
        ELSE
        BEGIN
            DELETE FROM SINHVIEN WHERE MASV = @masv;
            set @message =  N'Xóa sinh viên thành công!';
        END
    END
END;
GO

EXEC DeleteSINHVIEN N'SV04';
GO

CREATE PROCEDURE DeleteLop
    @MaLop nvarchar(20),
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LOP WHERE MALOP = @MaLop)
    BEGIN
        set @message = N'Lớp học không tồn tại!';
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MALOP = @MaLop)
        BEGIN
            set @message = N'Lớp học có liên quan đến bảng SINHVIEN. Cần xóa dữ liệu liên quan trước!';
        END
        ELSE
        BEGIN
            DELETE FROM LOP WHERE MALOP = @MaLop;
            set @message = N'Xóa lớp học thành công!';
        END
    END
END;
GO

EXEC DeleteLop N'K19QTM';
GO

CREATE PROCEDURE DeleteMonHoc
    @MaMH nvarchar(50),
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM MONHOC WHERE MAMH = @MaMH)
    BEGIN
        set @message = N'Môn học không tồn tại!';
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM DIEM WHERE MAMH = @MaMH)
        BEGIN
            set @message = N'Môn học có liên quan đến bảng DIEM. Cần xóa dữ liệu liên quan trước!';
        END
        ELSE
        BEGIN
            DELETE FROM MONHOC WHERE MAMH = @MaMH;
            set @message = N'Xóa môn học thành công!';
        END
    END
END;
GO

EXEC DeleteMonHoc N'TORR';
GO

CREATE PROCEDURE DeleteDiem
    @MaSV nvarchar(50),
    @MaMH nvarchar(50),
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM DIEM WHERE MASV = @MaSV AND MAMH = @MaMH)
    BEGIN
        set @message = N'Bản ghi điểm không tồn tại!';
    END
    ELSE
    BEGIN
        DELETE FROM DIEM WHERE MASV = @MaSV AND MAMH = @MaMH;
        set @message = N'Xóa bản ghi điểm thành công!';
    END
END;
GO

EXEC DeleteDiem N'SV06', N'TORR';
GO

CREATE PROCEDURE HienThiSinhVienTheoLop
    @p_malop NVARCHAR(20)
AS
BEGIN
    SELECT
        sv.MASV,
        sv.HOLOT,
        sv.TENSV,
		CASE sv.PHAI WHEN 1 THEN N'Nam'
		else N'Nu' END AS GIOITINH,
        DATEDIFF(YEAR, sv.NGAYSINH, GETDATE()) AS TUOI,
        ROUND(d.DIEMCC * 0.1 + d.DiemTD * 0.1 + d.DIEMGK * 0.2 + d.DiemDA * 0.15 + d.DIEMCK * 0.45, 1) AS DTB
    FROM
        SINHVIEN sv, DIEM d
    WHERE
        sv.MASV = d.MASV AND sv.MALOP = @p_malop
	GROUP BY sv.MASV, sv.HOLOT, sv.TENSV, sv.PHAI, sv.NGAYSINH, d.DIEMCC, d.DiemTD, d.DIEMGK, d.DiemDA, d.DIEMCK
END;

EXEC HienThiSinhVienTheoLop @p_malop = 'K19TPM';
go
CREATE PROCEDURE GetTopStudentsByClass
AS
BEGIN
    -- Temporary table to store the average scores
    CREATE TABLE TempAverageScores (
        MASV nvarchar(50),
        MALOP nvarchar(20),
        DTB float
    );

    -- Calculate the average score for each student
    INSERT INTO TempAverageScores (MASV, MALOP, DTB)
    SELECT 
        sv.MASV,
        sv.MALOP,
        ROUND(d.DIEMCC * 0.1 + d.DiemTD * 0.1 + d.DIEMGK * 0.2 + d.DiemDA * 0.15 + d.DIEMCK * 0.45, 1) AS DTB
    FROM SINHVIEN sv, DIEM d
	WHERE sv.MASV = d.MASV 
    GROUP BY sv.MASV, sv.MALOP, d.DIEMCC, d.DiemTD, d.DIEMGK, d.DiemDA, d.DIEMCK;

    -- Select top student for each class
    SELECT 
        sv.MASV,
        sv.TENSV,
        sv.HOLOT,
        sv.MALOP,
        l.TENLOP,
        tas.DTB
    FROM TempAverageScores tas, SINHVIEN sv, LOP l
    WHERE tas.MALOP = l.MALOP AND tas.MASV = sv.MASV AND tas.DTB = (
        SELECT MAX(tas2.DTB)
        FROM TempAverageScores tas2
        WHERE tas2.MALOP = tas.MALOP
    );

    -- Drop the temporary table
    DROP TABLE TempAverageScores;
END;
exec GetTopStudentsByClass
GO

CREATE PROCEDURE HienThiSinhVien
    @ht_masv NVARCHAR(20)
AS
BEGIN
    SELECT
        sv.MASV,
        sv.HOLOT,
        sv.TENSV,
		CASE sv.PHAI WHEN 1 THEN N'Nam'
		else N'Nu' END AS GIOITINH,
        DATEDIFF(YEAR, sv.NGAYSINH, GETDATE()) AS TUOI,
        ROUND(d.DIEMCC * 0.1 + d.DiemTD * 0.1 + d.DIEMGK * 0.2 + d.DiemDA * 0.15 + d.DIEMCK * 0.45, 1) AS DTB
    FROM
        SINHVIEN sv, DIEM d
    WHERE
        sv.MASV = d.MASV AND sv.MASV = @ht_masv
	GROUP BY sv.MASV, sv.HOLOT, sv.TENSV, sv.PHAI, sv.NGAYSINH, d.DIEMCC, d.DiemTD, d.DIEMGK, d.DiemDA, d.DIEMCK
END;

EXEC HienThiSinhVien 'SV02'
GO

CREATE PROCEDURE GetAllMonHoc
AS
BEGIN
    SELECT MAMH, TENMH, SOTC FROM MONHOC;
END;
GO
CREATE PROCEDURE GetAllLop
AS
BEGIN
    SELECT MALOP, TENLOP, CVHT FROM LOP;
END;
GO
CREATE PROCEDURE GetAllSinhVien
AS
BEGIN
    SELECT 
        MASV, 
        TENSV, 
        HOLOT,
		PHAI, 
        NGAYSINH, 
        DIACHI, 
        DIENTHOAI, 
        MALOP, 
        matkhau
    FROM SINHVIEN;
END;
GO
CREATE PROCEDURE GetAllDiem
AS
BEGIN
    SELECT 
        MASV, 
        MAMH, 
        DIEMCC, 
        DiemTD, 
        DIEMGK, 
        DiemDA, 
        DIEMCK
    FROM DIEM;
END;