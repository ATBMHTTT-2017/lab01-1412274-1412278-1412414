


-- Gi�m ??c ???c ph�p xem th�ng tin d? �n g?m (m� d? �n, t�n d? �n, kinh ph�, t�n ph�ng ch? tr�, t�n chi nh�nh ch? tr�, t�n tr??ng d? �n v� t?ng chi)

grant  select on  lab01.DUAN to giamDoc;
grant select on lab01.CHINHANH to giamDoc;
grant select on lab01.NHANVIEN to giamDoc;
grant select on lab01.PHONGBAN to giamDoc;

--- g�n role cho nh�n vi�n t? NV51-> NV55 (Gi�m ??c)
grant giamDoc to  NV51;
grant giamDoc to  NV52;
grant giamDoc to  NV53;
grant giamDoc to  NV54;
grant giamDoc to  NV55;

--list to�n b? c�c roles trong DB
SELECT * FROM DBA_ROLES;
--list to�n b? c�c quy?n trong roles gi�m ??c
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'GIAMDOC';
