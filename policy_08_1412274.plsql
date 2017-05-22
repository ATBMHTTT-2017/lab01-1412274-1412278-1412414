--Trưởng phòng chỉ được phép đọc thông tin chi tiêu của dự án trong phòng ban mình
--quản lý. Với những dự án không thuộc phòng ban của mình, các trưởng phòng được
--phép xem thông tin chi tiêu nhưng không được phép xem số tiền cụ thể (VPD).

--Cho phép role trưởng phòng select trên bảng dự án 
grant select on quanly.ChiTieu to truongPhong;
grant select on quanly.DuAn to truongPhong;

--Cho phép user là quanly ko bị ảnh hưởng bởi chính sách
GRANT EXEMPT ACCESS POLICY TO quanly;

--Tạo context là nhanvien_ctx
create or replace context nhanvien_ctx  using nhanvien_ctx_pkg;

--Tao package là nhanvien_ctx_pkg
create or replace package nhanvien_ctx_pkg 
is
  procedure thongtinnhanvien;
end;

create or replace package body nhanvien_ctx_pkg
is
  procedure thongtinnhanvien
  is
  phongBan varchar2(10);
  latruongphong varchar2(5);
  latruongchinhanh varchar2(5);
  latruongduan varchar2(5);
  begin
    --Tìm phòng ban của nhân viên
    select maPhong into PhongBan from quanly.NhanVien where maNV = sys_context('userenv', 'session_user');
    dbms_session.set_context('nhanvien_ctx', 'phongBan', phongBan);
	--Kiểm tra loại nhân viên đang đăng nhập
    --Xem nhân viên có phải là trưởng phòng
    select 
      case 
        when exists(select maPhong from quanly.PhongBan where truongPhong = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into latruongphong
    from dual;
    dbms_session.set_context('nhanvien_ctx', 'latruongphong', latruongphong);
    dbms_session.set_context('nhanvien_ctx', 'latruongphong', latruongphong);
	
    --Xem nhân viên có phải là trưởng chi nhánh
    select 
      case 
        when exists(select maCN  from quanly.ChiNhanh where truongChiNhanh = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into latruongchinhanh
    from dual;
    dbms_session.set_context('nhanvien_ctx', 'latruongchinhanh', latruongchinhanh);
    dbms_session.set_context('nhanvien_ctx', 'latruongchinhanh', latruongchinhanh);
	
    --Xem nhân viên có phải là trưởng dự án
    select 
      case  
        when exists(select maDA  from quanly.DuAn where truongDA = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into latruongduan
    from dual;
    dbms_session.set_context('nhanvien_ctx', 'latruongduan', latruongduan);
    dbms_session.set_context('nhanvien_ctx', 'latruongduan', latruongduan);
	
    --Trường hợp không phải 3 cái trên
    exception
      when no_data_found then null;
  end;
end; 


create or replace trigger nhanVien_ctx_trigger after logon on database
begin
  quanly.nhanvien_ctx_pkg.thongtinnhanvien;
end;

--Tạo function
create or replace function Xem_thong_tin_chi_tieu(object_schema in varchar2, object_name in varchar2)
return varchar2
as
	username varchar2(10);
	phong varchar2(10);
	temp varchar2(100);
	soluongduan number;
	dem number;
begin
	if sys_context('USERENV', 'ISDBA') = 'TRUE' or sys_context('nhanvien_ctx', 'latruongchinhanh') = 'TRUE' or sys_context('nhanvien_ctx', 'latruongduan') = 'TRUE' then
		return '';
	end if;
	if sys_context('nhanvien_ctx', 'latruongphong') = 'TRUE' then
		username := sys_context('USERENV', 'SESSION_USER');
		
		--Lấy mã phòng của trưởng phòng đang đăng nhập
		select maPhong into phong
		from quanly.PhongBan 
		where truongPhong = username;
		
		--Đém số dự án mà phòng đó chủ trì
		select count(*) into soluongduan from quanly.DuAn where phongChuTri = phong;
		temp :='';
		dem := 0;
		begin
			for da in (select maDA from quanly.DuAn where phongChuTri = phong)
			loop
				dem := dem + 1;
				if dem < soluongduan then
					temp := temp || '''' || da.maDA || '''' || ',';
				end if;
				if dem = soluongduan then
					temp := temp || '''' || da.maDA || '''';
				end if;
			end loop;
		end;
		return 'duAn in (' || temp ||')';
	end if;
	return '1 = 0';
end;

begin dbms_rls.add_policy (object_schema => 'quanly',
							 object_name => 'ChiTieu',
							 policy_name => 'Select_Chi_Tieu',
							 function_schema => 'quanly',
							 policy_function => 'Xem_thong_tin_chi_tieu',
							 statement_types => 'select',
							 sec_relevant_cols=> 'soTien',
							 sec_relevant_cols_opt=>dbms_rls.ALL_ROWS);
end;

begin dbms_rls.drop_policy (object_schema => 'quanly',
                            object_name => 'ChiTieu',
							policy_name => 'Select_Chi_Tieu'); 
end;
							 
							 
