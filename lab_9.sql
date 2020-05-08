
1.Розробити і перевірити скалярну (scalar) функцію, що повертає загальну вартість книг, виданих в певному році.

CREATE FUNCTION books_price(book,find_date int) RETURNS money AS $$
    SELECT  sum($1.book_price)  AS books_price from book where cast(Extract(Year from book.book_data) as int) = find_date ;
$$ LANGUAGE SQL;

DROP FUNCTION  books_price

SELECT  books_price(book.*,2000) 
    FROM book 
   
-----------------------------------------------   
   2.Розробити і перевірити табличну (inline) функцію, яка повертає список книг, виданих в певному році.
   
   CREATE OR REPLACE FUNCTION information_about_books (find_date date)
      RETURNS TABLE (name varchar, year date) as
	  $BODY$ 
      select cast(book_name as varchar),book_data from book where (Extract(Year from book.book_data) = Extract(Year from find_date) )
   	  $BODY$
		LANGUAGE SQL;
		
		SELECT * from information_about_books('2000.02.23') 
   ---------------------------------------
   3.Розробити і перевірити функцію типу multi - statement, яка буде:
a.приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ';';
b.виділяти з цього рядка назву видавництва;
c.формувати нумерований список назв видавництв
    CREATE OR REPLACE FUNCTION publishing_list (publiching varchar) returns  table(id bigserial , public varchar ) as 
	$BODY$
	begin
    	
		insert into publishing_list	  SELECT regexp_split_to_array(publiching, E '\\ s +')
		return
	end;
$BODY$
	LANGUAGE plpgsql;
	
	select * from publishing_list('BHV , Пітербург')
	--------------------------------------------------
	4.Виконати набір операцій по роботі з SQL курсором:
a.оголосити курсор;
b.використовувати змінну для оголошення курсору;
c.відкрити курсор;
d. переприсвоіти курсор іншій зміннійї;
e.виконати вибірку даних з курсору;
f.закрити курсор.
 .Розробити курсор для виведення списку книг виданих в певному році.

create or replace function cursor_funс(book_year int) 
  returns SETOF varchar as $$
  
  DECLARE 
    book_names text default '';
    rec_book record;
    curs1 CURSOR(book_year int) FOR select book.book_name,book.book_data from book where EXTRACT (YEAR from book.book_data)=book_year;
    
  BEGIN
    OPEN curs1(book_year);
    LOOP
      FETCH curs1 INTO rec_book;
      EXIT WHEN NOT FOUND;
      book_names:=rec_book.book_name||':'||EXTRACT (YEAR from rec_book.book_data);
      return next book_names;
    END LOOP;
    CLOSE curs1;
    
  END;
$$
language plpgsql;

select  cursor_func(2000)