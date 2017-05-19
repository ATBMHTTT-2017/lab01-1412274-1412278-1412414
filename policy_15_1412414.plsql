------------------------------------------------------------------------Ta�o c�c th�nh ph��n policy. ---------------------------------------------------------------------
-- Quy��n ta�o ra c�c th�nh ph��n cu�a label
GRANT EXECUTE ON SA_COMPONENTS TO lab01;
-- Quy��n ta�oo c�c label
GRANT EXECUTE ON SA_LABEL_ADMIN TO lab01;
-- Quy��n g�n policy cho c�c ba�ng
GRANT EXECUTE ON SA_POLICY_ADMIN TO lab01;
--Quy��n g�n label cho t�i khoa�n
GRANT EXECUTE ON SA_USER_ADMIN TO lab01;
--Chuy��n chu��i th�nh s�� cu�a label
GRANT EXECUTE ON CHAR_TO_LABEL TO lab01;
--Grant quy��n sa_audit_admin
GRANT EXECUTE ON sa_audit_admin TO lab01;
--Grant quy��n LBAC_DBA
GRANT LBAC_DBA TO lab01;
--Grant quy��n sa_sysdba 
GRANT EXECUTE ON sa_sysdba TO lab01;
--Grant quy��n to_lbac_data_label
GRANT EXECUTE ON to_lbac_data_label TO lab01;

--Ta�o policy
EXECUTE SA_SYSDBA.CREATE_POLICY('ACCESS_DUAN', 'OLS_DUAN');

--Grant role ACCESS_DUAN_DBA cho user lab01
GRANT ACCESS_DUAN_DBA TO lab01;

--Ta�o ca�c tha�nh ph��n level cho chi�nh sa�ch ACCESS_DUAN
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 9000, 'BMC', 'Bi� m��t cao');
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 8000, 'BM', 'Bi� m��t');
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 7000, 'GH', 'Gi��i ha�n');
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 6000, 'TT', 'Th�ng th���ng');

--Ta�o compartment
EXEC SA_COMPONENTS.CREATE_COMPARTMENT('ACCESS_DUAN', 3000, 'NS', 'Nh�n s��');
EXEC SA_COMPONENTS.CREATE_COMPARTMENT('ACCESS_DUAN', 2000, 'KT', 'K�� toa�n');
EXEC SA_COMPONENTS.CREATE_COMPARTMENT('ACCESS_DUAN', 1000, 'KH', 'K�� hoa�ch');

--Ta�o group
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 1, 'CT', 'C�ng ty', NULL);
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 4, 'HCM', 'H�� Chi� Minh', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 5, 'HN', 'Ha� N��i', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 3, 'DN', '�a� N��ng', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 6, 'HP', 'Ha�i Pho�ng', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 2, 'CTH', 'C��n Th�', 'CT');

--
CREATE OR REPLACE FUNCTION taoLabelDuAn(phongChuTri  IN  VARCHAR2)
RETURN LBACSYS.LBAC_LABEL AS
  labelDuAn  VARCHAR2(50);
BEGIN
  labelDuAn := 'GH:' || substr(phongChuTri,1, 2) || ':' || substr(phongChuTri, 3);
  RETURN TO_LBAC_DATA_LABEL('ACCESS_DUAN', labelDuAn);
END taoLabelDuAn;

--Ga�n chi�nh sa�ch cho ba�ng duAn
EXEC SA_POLICY_ADMIN.APPLY_TABLE_POLICY('ACCESS_DUAN', 'lab01', 'duAn', 'NO_CONTROL');

--Kh��i ta�o nha�n
UPDATE lab01.duAn
SET OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN','TT');
COMMIT;

--G�� policy
EXEC SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('ACCESS_DUAN','lab01','duAn');

--A�p du�ng la�i policy
begin SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
  POLICY_NAME     => 'ACCESS_DUAN',
  SCHEMA_NAME     => 'lab01',
  TABLE_NAME      => 'duAn',
  TABLE_OPTIONS   => 'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL');
end;

--Ta�o nha�n
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1500, 'GH:NS:HCM');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1400, 'GH:NS:HN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1300, 'GH:NS:DN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1200, 'GH:NS:HP');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1100, 'GH:NS:CTH');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1000, 'GH:KT:HCM');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 900, 'GH:KT:HN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 800, 'GH:KT:DN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 700, 'GH:KT:HP');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 600, 'GH:KT:CTH');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 500, 'GH:KH:HCM');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 400, 'GH:KH:HN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 300, 'GH:KH:DN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 200, 'GH:KH:HP');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 100, 'GH:KH:CTH');

--
grant select, update, insert on lab01.duAn to lbacsys;

--Ga�n nha�n cho ca�c d�� a�n cu�a pho�ng nh�n s��
update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:NS:HCM')
where phongChuTri = 'NSHCM';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:NS:HN')
where phongChuTri = 'NSHN';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:NS:DN')
where phongChuTri = 'NSDN';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:NS:HP')
where phongChuTri = 'NSHP';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:NS:CTH')
where phongChuTri = 'NSCT';

--Ga�n nha�n cho ca�c d�� a�n cu�a pho�ng k�� toa�n
update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KT:HCM')
where phongChuTri = 'KTHCM';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KT:HN')
where phongChuTri = 'KTHN';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KT:HP')
where phongChuTri = 'KTHP';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KT:DN')
where phongChuTri = 'KTDN';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KT:CTH')
where phongChuTri = 'KTCT';

--Ga�n nha�n cho ca�c d�� a�n cu�a pho�ng k�� hoa�ch
update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KH:HCM')
where phongChuTri = 'KHHCM';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KH:HN')
where phongChuTri = 'KHHN';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KH:DN')
where phongChuTri = 'KHDN';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KH:HP')
where phongChuTri = 'KHHP';

update lab01.duAn
set OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN', 'GH:KH:CTH')
where phongChuTri = 'KHCT';

commit;
--Ga�n level cho user tr���ng pho�ng  
EXEC SA_USER_ADMIN.SET_LEVELS ('ACCESS_DUAN', 'NV06', 'BM', 'GH', 'BM', 'BM');
EXEC SA_USER_ADMIN.SET_LEVELS ('ACCESS_DUAN', 'NV10', 'BM', 'GH', 'BM', 'BM');
EXEC SA_USER_ADMIN.SET_LEVELS ('ACCESS_DUAN', 'NV14', 'BM', 'GH', 'BM', 'BM');

--Ga�n compartment cho user tr���ng pho�ng pho�ng nh�n s��
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV06', 'NS', SA_UTL.READ_WRITE, 'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV06', 'KT',SA_UTL.READ_ONLY,  'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV06', 'KH', SA_UTL.READ_ONLY, 'Y', 'Y');

--Ga�n compartment cho user tr���ng pho�ng pho�ng k�� toa�n
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV10', 'NS', SA_UTL.READ_ONLY, 'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV10', 'KT',SA_UTL.READ_WRITE,  'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV10', 'KH', SA_UTL.READ_ONLY, 'Y', 'Y');

--Ga�n compartment cho user tr���ng pho�ng pho�ng k�� hoa�ch
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV14', 'NS', SA_UTL.READ_ONLY, 'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV14', 'KT',SA_UTL.READ_ONLY,  'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV14', 'KH', SA_UTL.READ_WRITE, 'Y', 'Y');

--Ga�n group cho user tr���ng pho�ng pho�ng nh�n s�� chi nha�nh h�� chi� minh
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'HCM', SA_UTL.READ_WRITE,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'HN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'DN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'HP', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'CT', SA_UTL.READ_ONLY,'Y', 'Y');

--Ga�n group cho user tr���ng pho�ng pho�ng k�� toa�n chi nha�nh ha� n��i
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'HCM', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'HN', SA_UTL.READ_WRITE,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'DN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'HP', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'CT', SA_UTL.READ_ONLY,'Y', 'Y');

--Ga�n group cho user tr���ng pho�ng pho�ng k�� hoa�ch chi nha�nh �a� n��ng
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'HCM', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'HN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'DN', SA_UTL.READ_WRITE,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'HP', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'CT', SA_UTL.READ_ONLY,'Y', 'Y');

--Grant quy��n
grant select, update, insert on lab01.duAn to NV06;
grant select, update, insert on lab01.duAn to NV10;
grant select, update, insert on lab01.duAn to NV14;

--Ki��m tra
select SA_SESSION.MIN_LEVEL('ACCESS_DUAN') from dual;
select SA_SESSION.MAX_LEVEL('ACCESS_DUAN') from dual;
select SA_SESSION.COMP_READ('ACCESS_DUAN') from dual;
select SA_SESSION.COMP_WRITE('ACCESS_DUAN') from dual;
select SA_SESSION.GROUP_READ('ACCESS_DUAN') from dual;
select SA_SESSION.GROUP_WRITE('ACCESS_DUAN') from dual;
select SA_SESSION.LABEL('ACCESS_DUAN') from dual;
select SA_SESSION.ROW_LABEL('ACCESS_DUAN') from dual;
select SA_SESSION.SA_USER_NAME('ACCESS_DUAN') from dual;