----------------------------------------T��t ca� nh�n vi�n bi�nh th���ng (tr�� tr���ng pho�ng, tr���ng chi nha�nh, tr���ng d�� a�n)--------------------------------------------------
-------------------------------------------chi� ����c phe�p xem th�ng tin nh�n vi�n trong pho�ng cu�a mi�nh, chi� ����c xem------------------------------------------------------
-------------------------------------------l��ng cu�a ba�n th�n (VPD)----------------------------------------------------------------------------------------------------
--GRANT EXEMPT ACCESS POLICY TO lab01
GRANT EXEMPT ACCESS POLICY TO lab01;

--Ta�o context nhanVien_ctx
create or replace context nhanVien_ctx  using set_nhanVien_ctx_pkg;

--Ta�o package set_nhanVien_ctx_pkg
create or replace package set_nhanVien_ctx_pkg 
is
  procedure set_thongTinNhanVien;
end;

create or replace package body set_nhanVien_ctx_pkg
is
  procedure set_thongTinNhanVien
  is
  phongBan varchar2(10);
  laTruongPhongBan varchar2(5);
  laTruongChiNhanh varchar2(5);
  laTruongDuAn varchar2(5);
  begin
    --Ti�m pho�ng ban nh�n vi�n thu��c v��
    select maPhong into phongBan from lab01.nhanVien where maNV = sys_context('userenv', 'session_user');
    dbms_session.set_context('nhanVien_ctx', 'phongBan', phongBan);
    --Xem nh�n vi�n co� pha�i la� tr���ng pho�ng ban hay kh�ng
    select 
      case 
        when exists(select maPhong  from lab01.phongBan where truongPhong = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into laTruongPhongBan
    from dual;
    dbms_session.set_context('nhanVien_ctx', 'laTruongPhongBan', laTruongPhongBan);
    dbms_session.set_context('nhanVien_ctx', 'laTruongPhongBan', laTruongPhongBan);
    --Xem nh�n vi�n co� pha�i la� tr���ng chi nha�nh hay kh�ng
    select 
      case 
        when exists(select maCN  from lab01.chiNhanh where truongChiNhanh = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into laTruongChiNhanh
    from dual;
    dbms_session.set_context('nhanVien_ctx', 'laTruongChiNhanh', laTruongChiNhanh);
    dbms_session.set_context('nhanVien_ctx', 'laTruongChiNhanh', laTruongChiNhanh);
    --Xem nh�n vi�n co� pha�i la� tr���ng d�� a�n hay kh�ng
    select 
      case  
        when exists(select maDA  from lab01.duAn where truongDA = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into laTruongDuAn
    from dual;
    dbms_session.set_context('nhanVien_ctx', 'laTruongDuAn', laTruongDuAn);
    dbms_session.set_context('nhanVien_ctx', 'laTruongDuAn', laTruongDuAn);
    --Tr���ng h��p kh�ng ti�m th��y d�� li��u
    exception
      when no_data_found then null;
  end;
end;

--Ta�o logon trigger cho package
create or replace trigger set_nhanVien_ctx_trigger after logon on database
begin
  lab01.set_nhanVien_ctx_pkg.set_thongTinNhanVien;
end;

--Xem nh�n vi�n cu�ng pho�ng ban
create or replace function nhanVienThuocCungPhongBan(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  phongBan varchar2(10);
  temp varchar2(100);
begin
  if sys_context('USERENV', 'ISDBA') = 'TRUE' or sys_context('nhanVien_ctx', 'laTruongPhongBan') = 'TRUE' 
  or sys_context('nhanVien_ctx', 'laTruongChiNhanh') = 'TRUE' or sys_context('nhanVien_ctx', 'laTruongDuAn') = 'TRUE' then
    return '';
  else
    phongBan := sys_context('nhanVien_ctx', 'phongBan');
    temp :=  'maPhong = ''' || phongBan || '''';
    return temp;
  end if;
end;

--add policy nhanVienThuocCungPhongBan
begin dbms_rls.add_policy (object_schema => 'lab01',
                                            object_name => 'nhanVien',
                                            policy_name => 'nhanVienThuocCungPhongBan',
                                            function_schema => 'lab01',
                                            policy_function => 'nhanVienThuocCungPhongBan',
                                            statement_types => 'select');
end;

--drop policy nhanVienThuocCungPhongBan
begin dbms_rls.drop_policy (object_schema => 'lab01',
                                            object_name => 'nhanVien',
                                            policy_name => 'nhanVienThuocCungPhongBan'); end;
                                            
--Xem l��ng cu�a chi�nh nh�n vi�n �o�
create or replace function luongNhanVien(object_schema in varchar2, object_name in varchar2)
return varchar2
as
  taiKhoan varchar2(10);
  temp varchar2(100);
begin
  if sys_context('USERENV', 'ISDBA') = 'TRUE' or sys_context('nhanVien_ctx', 'laTruongPhongBan') = 'TRUE' 
  or sys_context('nhanVien_ctx', 'laTruongChiNhanh') = 'TRUE' or sys_context('nhanVien_ctx', 'laTruongDuAn') = 'TRUE' then
    return '';
  else
    taiKhoan := sys_context('USERENV', 'SESSION_USER');
    temp :=  'maNV = ''' || taiKhoan || '''';
    return temp;
  end if;
end;

begin dbms_rls.add_policy (object_schema => 'lab01',
                                            object_name => 'nhanVien',
                                            policy_name => 'luongNhanVien',
                                            function_schema => 'lab01',
                                            policy_function => 'luongNhanVien',
                                            statement_types => 'select',
                                            sec_relevant_cols => 'luong',
                                            sec_relevant_cols_opt => dbms_rls.All_ROWS);
end;

begin dbms_rls.drop_policy (object_schema => 'lab01',
                                            object_name => 'nhanVien',
                                            policy_name => 'luongNhanVien'); end;

--Grant quy��n   
grant select on nhanVien to NV01;
grant select on nhanVien to NV06;
grant select on nhanVien to NV21;
grant select on nhanVien to NV36;