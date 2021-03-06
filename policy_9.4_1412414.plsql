-----------------------------------------------------Trưởng phòng được phép đọc dữ liệu dự án của tất cả phòng ban nhưng chỉ được-------------------------------------------
----------------------------------------------------- phép ghi dữ liệu dự án thuộc phòng của mình.--------------------------------------------------------------------
--Gán nhãn cho các dự án của phòng nhân sự
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

--Gán nhãn cho các dự án của phòng kế toán
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

--Gán nhãn cho các dự án của phòng kế hoạch
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
--Gán level cho user trưởng phòng  
EXEC SA_USER_ADMIN.SET_LEVELS ('ACCESS_DUAN', 'NV06', 'BM', 'GH', 'BM', 'BM');
EXEC SA_USER_ADMIN.SET_LEVELS ('ACCESS_DUAN', 'NV10', 'BM', 'GH', 'BM', 'BM');
EXEC SA_USER_ADMIN.SET_LEVELS ('ACCESS_DUAN', 'NV14', 'BM', 'GH', 'BM', 'BM');

--Gán compartment cho user trưởng phòng phòng nhân sự
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV06', 'NS', SA_UTL.READ_WRITE, 'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV06', 'KT',SA_UTL.READ_ONLY,  'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV06', 'KH', SA_UTL.READ_ONLY, 'Y', 'Y');

--Gán compartment cho user trưởng phòng phòng kế toán
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV10', 'NS', SA_UTL.READ_ONLY, 'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV10', 'KT',SA_UTL.READ_WRITE,  'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV10', 'KH', SA_UTL.READ_ONLY, 'Y', 'Y');

--Gán compartment cho user trưởng phòng phòng kế hoạch
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV14', 'NS', SA_UTL.READ_ONLY, 'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV14', 'KT',SA_UTL.READ_ONLY,  'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_COMPARTMENTS('ACCESS_DUAN', 'NV14', 'KH', SA_UTL.READ_WRITE, 'Y', 'Y');

--Gán group cho user trưởng phòng phòng nhân sự chi nhánh hồ chí minh
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'HCM', SA_UTL.READ_WRITE,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'HN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'DN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'HP', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV06', 'CT', SA_UTL.READ_ONLY,'Y', 'Y');

--Gán group cho user trưởng phòng phòng kế toán chi nhánh hà nội
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'HCM', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'HN', SA_UTL.READ_WRITE,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'DN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'HP', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV10', 'CT', SA_UTL.READ_ONLY,'Y', 'Y');

--Gán group cho user trưởng phòng phòng kế hoạch chi nhánh đà nẵng
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'HCM', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'HN', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'DN', SA_UTL.READ_WRITE,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'HP', SA_UTL.READ_ONLY,'Y', 'Y');
EXEC SA_USER_ADMIN.ADD_GROUPS('ACCESS_DUAN', 'NV14', 'CT', SA_UTL.READ_ONLY,'Y', 'Y');

--Grant quyền
grant select, update, insert on lab01.duAn to NV06;
grant select, update, insert on lab01.duAn to NV10;
grant select, update, insert on lab01.duAn to NV14;

--Kiểm tra
select SA_SESSION.MIN_LEVEL('ACCESS_DUAN') from dual;
select SA_SESSION.MAX_LEVEL('ACCESS_DUAN') from dual;
select SA_SESSION.COMP_READ('ACCESS_DUAN') from dual;
select SA_SESSION.COMP_WRITE('ACCESS_DUAN') from dual;
select SA_SESSION.GROUP_READ('ACCESS_DUAN') from dual;
select SA_SESSION.GROUP_WRITE('ACCESS_DUAN') from dual;
select SA_SESSION.LABEL('ACCESS_DUAN') from dual;
select SA_SESSION.ROW_LABEL('ACCESS_DUAN') from dual;
select SA_SESSION.SA_USER_NAME('ACCESS_DUAN') from dual;