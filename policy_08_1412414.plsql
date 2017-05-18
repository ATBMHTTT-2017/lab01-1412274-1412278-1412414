----------------------------------------Tâìt caÒ nhân viên biÌnh thýõÌng (trýÌ trýõÒng phoÌng, trýõÒng chi nhaình, trýõÒng dýò aìn)--------------------------------------------------
-------------------------------------------chiÒ ðýõòc pheìp xem thông tin nhân viên trong phoÌng cuÒa miÌnh, chiÒ ðýõòc xem------------------------------------------------------
-------------------------------------------lýõng cuÒa baÒn thân (VPD)----------------------------------------------------------------------------------------------------
--GRANT EXEMPT ACCESS POLICY TO lab01
GRANT EXEMPT ACCESS POLICY TO lab01;

--Taòo context nhanVien_ctx
create or replace context nhanVien_ctx  using set_nhanVien_ctx_pkg;

--Taòo package set_nhanVien_ctx_pkg
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
    --TiÌm phoÌng ban nhân viên thuôòc vêÌ
    select maPhong into phongBan from lab01.nhanVien where maNV = sys_context('userenv', 'session_user');
    dbms_session.set_context('nhanVien_ctx', 'phongBan', phongBan);
    --Xem nhân viên coì phaÒi laÌ trýõÒng phoÌng ban hay không
    select 
      case 
        when exists(select maPhong  from lab01.phongBan where truongPhong = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into laTruongPhongBan
    from dual;
    dbms_session.set_context('nhanVien_ctx', 'laTruongPhongBan', laTruongPhongBan);
    dbms_session.set_context('nhanVien_ctx', 'laTruongPhongBan', laTruongPhongBan);
    --Xem nhân viên coì phaÒi laÌ trýõÒng chi nhaình hay không
    select 
      case 
        when exists(select maCN  from lab01.chiNhanh where truongChiNhanh = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into laTruongChiNhanh
    from dual;
    dbms_session.set_context('nhanVien_ctx', 'laTruongChiNhanh', laTruongChiNhanh);
    dbms_session.set_context('nhanVien_ctx', 'laTruongChiNhanh', laTruongChiNhanh);
    --Xem nhân viên coì phaÒi laÌ trýõÒng dýò aìn hay không
    select 
      case  
        when exists(select maDA  from lab01.duAn where truongDA = sys_context('userenv', 'session_user'))
        then 'TRUE'
        else 'FALSE'
      end into laTruongDuAn
    from dual;
    dbms_session.set_context('nhanVien_ctx', 'laTruongDuAn', laTruongDuAn);
    dbms_session.set_context('nhanVien_ctx', 'laTruongDuAn', laTruongDuAn);
    --TrýõÌng hõòp không tiÌm thâìy dýÞ liêòu
    exception
      when no_data_found then null;
  end;
end;

--Taòo logon trigger cho package
create or replace trigger set_nhanVien_ctx_trigger after logon on database
begin
  lab01.set_nhanVien_ctx_pkg.set_thongTinNhanVien;
end;

--Xem nhân viên cuÌng phoÌng ban
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
                                            
--Xem lýõng cuÒa chiình nhân viên ðoì
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

--Grant quyêÌn   
grant select on nhanVien to NV01;
grant select on nhanVien to NV06;
grant select on nhanVien to NV21;
grant select on nhanVien to NV36;