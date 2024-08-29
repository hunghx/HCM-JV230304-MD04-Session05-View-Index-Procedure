-- index 

explain analyze SELECT * FROM music.users where name like 'Thurman Hoppe';
 -- -> Index range scan on users using index_name over (name = 'Thurman Hoppe'),
 -- with index condition: 
 -- (users.`name` like 'Thurman Hoppe')  (cost=0.71 rows=1) (actual time=0.133..0.136 rows=1 loops=1)
 
 
 -- View - khunng nhìn 
 
 
 -- tạo 1 bảng ảo chỉ chuwaas các user có role là 0
 create view view_user_role_0 
 as select * from users where role =0 ;
 


-- ứng dụng index vào cột name
create index index_name
on users(name);

-- -> Filter: (users.`name` like 'Thurman Hoppe')  (cost=103 rows=111) (actual time=1.34..1.35 rows=1 loops=1)
--    -> Table scan on users  (cost=103 rows=998) (actual time=0.198..1.22 rows=998 loops=1)
 
 
 -- Thủ tục
 
 -- tạo thủ tục lưu trữ chức năng thêm mới danh mục
 
 delimiter // -- cap phat vung nho
 
 create procedure proc_insert_category
 (in name_in varchar(100),in status_in tinyint)
 begin
       insert into category(name, status)  value (name_in, status_in) ;
 end;
 //
 
 -- gọi thủ tục
 call proc_insert_category('phim hanh dong', 1);
 

 -- tham số out : 
 -- láy tổng số danh mục có trong bảng ra
  delimiter // -- cap phat vung nho
 
 create procedure proc_total_category
 (out total int)
 begin
      select count(id) into total from category;
 end;
 //
 
 -- gọi hàm 
 call proc_total_category(@total);
 select @total;
 
 -- kiến thức nâng cao 
 
 
 -- ví dụ : xây dựng thủ tục tính điểm trung bình của 1 sinh viên và 
 -- trả về điểm trung bình
 -- và xếp loại của sinh viên đấy
 
 
  delimiter // -- cap phat vung nho
 
 create procedure proc_tinh_diem_sinh_vien
 (id_in char(3), out dtb double, out xeploai varchar(20))
 -- khai báo biến 
 begin
         --  declare d double; -- khai báo biến sử dụng từ khóa 
--           declare xl varchar(20);
--           set d =7.5; -- thay đổi giá trị  biến
--           -- cú pháp điều kiện 
--           -- if else
--           if(d < 5)  then
--              --   begin -- khối lệnh
--                         set xl = 'yeu';
--               --  end;
--           else if (d<6.5) then
--                 set xl = 'trung binh';
--           else 
--                 set xl = 'giỏi'; 
--           END IF;
--           -- switch case 
--           case when d < 5  then 
--                 set xl = 'yeu';
--                 when d< 6.5 then
--                 set xl = 'trung binh';
--           end;

        -- b1: tính điểm trung bình
        select avg(diem) into dtb from ketqua where masv = id_in;
        
        -- b2 : sử dụng cú pháp swith case để xếp loai
        case when dtb < 5 then 
                        set xeploai = 'Yếu';
                when dtb < 6.5 then
                        set xeploai = 'Trung bình'; 
                when dtb < 8 then
                        set xeploai = 'Khá';
                Else 
                        set xeploai = 'Giỏi';
        end case;
 end;
 //
 
 -- gọi thủ tục
 set @dtb = 10;
 set @xeploai = 'giỏi';
 call proc_tinh_diem_sinh_vien('A02',@dtb,@xeploai);
 
 select @dtb, @xeploai;
 
 
 