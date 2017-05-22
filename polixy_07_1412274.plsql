--Câu 5: Chỉ trưởng phòng, trưởng chi nhánh được cấp quyền thực thi stored procedure cập nhật thông tin phòng ban của mình (DAC).

--Trưởng phòng ban
--Gán role cho các nhân viên là trưởng phòng
declare
  temp varchar2(500);
begin
for trgphg in (select truongPhong from PhongBan)
loop
  temp := 'grant truongPhong to ' || trgphg.truongPhong;
  execute immediate temp;
end loop;
end;

--Grant quyền cho role trưởng phòng
grant select, update on quanly.PhongBan to truongPhong;

--procedure cập nhật thông tin phòng ban của trưởng phòng
create or replace procedure CAPNHATPHONGBAN_TP (tenphg in varchar2, trgphg in varchar2, ngaync in date, sonhanvien in number)
AS
phong varchar2(10);
begin
  --Lấy mã phòng mà trưởng phòng đó thuộc về
	select maPhong into phong
	from PhongBan where truongPhong = USER;
	
  --Xét điều kiện các thuộc tính
	update PhongBan set tenPhong = tenphg, truongPhong = trgphg, ngayNhanChuc = ngaync, soNhanVien = sonhanvien 
	where maPhong = phong;  
end;

--Gán cho role trưởng phòng thực thi procedure
grant execute on quanly.CAPNHATPHONGBAN_TP to truongPhong;

--Trưởng chi nhánh
--Gán role cho các nhân viên là trưởng chi nhánh
declare
  temp varchar2(500);
begin
for trgcn in (select truongChiNhanh from ChiNhanh)
loop
  temp := 'grant truongChiNhanh to ' || trgcn.truongChiNhanh;
  execute immediate temp;
end loop;
end;

--grant quyền cho role trưởng chi nhánh
grant select, update on quanly.PhongBan to truongChiNhanh;
grant select, update on quanly.ChiNhanh to truongChiNhanh;

--procedure cập nhật thông tin phòng ban của trưởng chi nhánh
create or replace procedure CAPNHATPHONGBAN_TCN (maphg in varchar2, tenphg in varchar2, trgphg in varchar2, ngaync in date, sonhanvien in number)
as
cn1 varchar2(10);
cn2 varchar2(10);
begin
  --Lấy mã chi nhánh của trưởng chi nhánh đó
  select maCN into cn1 
  from ChiNhanh
  where truongChiNhanh = USER;
  
  select chiNhanh into cn2 
  from PhongBan
  where maPhong = maphg;
  
  if cn1 = cn2 then
    update PhongBan set tenPhong = tenphg, truongPhong = trgphg, ngayNhanChuc = ngaync, soNhanVien = sonhanvien 
    where maPhong =  maphg and chiNhanh = cn1;
  else
    return;
  end if;
end;

--Gán cho role trưởng chi nhánh thực thi procedure
grant execute on quanly.CAPNHATPHONGBAN_TCN to truongChiNhanh;



--REVOKE EXECUTE ON CAPNHATPHONGBAN_TP FROM TRUONGPHONG;
--DROP PROCEDURE CAPNHATPHONGBAN_TP;
--REVOKE EXECUTE ON CAPNHATPHONGBAN_TCN FROM TRUONGCHINHANH;
--DROP PROCEDURE CAPNHATPHONGBAN_TCN;

