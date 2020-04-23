1.Кількість тем може бути в діапазоні від 5 до 10.

CREATE FUNCTION topic_range() RETURNS trigger AS  $topic_range$
	DECLARE 
    count_t integer; 
	BEGIN
		
		Select count(topic) INTO count_t FROM topic;
		New.count= count_t;
		IF (count_t<5 or count_t>10 ) THEN
			RAISE EXCEPTION 'Topic range can be from 5 to 10';
		END IF;
		RETURN NEW;
	END;
$topic_range$ LANGUAGE plpgsql;

CREATE TRIGGER topic_range BEFORE INSERT OR UPDATE or DELETE ON topic
    FOR EACH ROW EXECUTE PROCEDURE topic_range();
	
____________________________________
2.Новинкою може бути тільки книга видана в поточному році.

CREATE FUNCTION new_book() RETURNS trigger AS  $new_book$
	BEGIN
			IF (EXTRACT (YEAR FROM New.book_data)!=EXTRACT(YEAR FROM current_date)) and (New.book_new=true) THEN
				RAISE EXCEPTION 'Новинкою може бути тільки книга видана в поточному році.';
				END IF;	
		RETURN NEW;
	END;
$new_book$ LANGUAGE plpgsql;

CREATE TRIGGER new_book BEFORE INSERT OR UPDATE or DELETE ON book
    FOR EACH ROW EXECUTE PROCEDURE new_book();
------------------------------------------------------------
3.Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 3 00 - 3 0 $.
CREATE FUNCTION pages_price() RETURNS trigger AS  $pages_price$
	BEGIN
			IF (New.book_pages<100)and(New.book_price >money(10)) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 100 не може коштувати більше 10 $';
				END IF;	
			IF (New.book_pages<200)and(New.book_price >money(20)) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 200 не може коштувати більше 20 $';
				END IF;	
			IF (New.book_pages<300)and(New.book_price >money(30)) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 300 не може коштувати більше 30 $';
				END IF;	
				
		RETURN NEW;
	END;
$pages_price$ LANGUAGE plpgsql;

CREATE TRIGGER pages_price BEFORE INSERT OR UPDATE or DELETE ON book
    FOR EACH ROW EXECUTE PROCEDURE pages_price();
---------------------------------------------
4.Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.
CREATE FUNCTION publiching_circulation() RETURNS trigger AS  $publiching_circulation$
	BEGIN
			IF (New.book_publiching like '%%BHV С.-Петербург%%' )and(New.book_circulation<5000) THEN
				RAISE EXCEPTION 'Видавництво "BHV" не випускає книги накладом меншим 5000';
				END IF;	
			IF (New.like '%%DiaSoft%%' )and(New.book_circulation<10000) THEN
				RAISE EXCEPTION 'Видавництво Diasoft не випускає книги накладом меншим 10000';
				END IF;	
			
				
		RETURN NEW;
	END;
$publiching_circulation$ LANGUAGE plpgsql;

CREATE TRIGGER publiching_circulation BEFORE INSERT OR UPDATE or DELETE ON book
    FOR EACH ROW EXECUTE PROCEDURE publiching_circulation();
 ----------------------------------------------------------------
7.Користувач "dbo" не має права змінювати ціну книги.
CREATE FUNCTION db_user() RETURNS trigger AS  $db_user$
  BEGIN
    IF(select current_user='dbo') THEN
      RAISE EXCEPTION 'Користувач "dbo" не має права змінювати ціну книги';
      END IF;
    RETURN NEW;
  END;
$db_user$ LANGUAGE plpgsql;

CREATE TRIGGER db_user_trig
  BEFORE UPDATE of book_price
  ON book
  FOR EACH ROW
  EXECUTE PROCEDURE db_user()
---------------------------------------------
8.Видавництва ДМК і Еком підручники не видають.
CREATE FUNCTION publiching() RETURNS trigger AS  $publiching$
	BEGIN
			IF (New.book_publiching like '%%ДМК%%' )and(New.book_category like'%%підручники%%') THEN
				RAISE EXCEPTION 'Видавництва ДМК і Еком підручники не видають.';
				END IF;	
			IF (New.book_publiching like '%%Еком%%' )and(New.book_category like'%%підручники%%') THEN
				RAISE EXCEPTION 'Видавництва ДМК і Еком підручники не видають.';
				END IF;	
			
				
		RETURN NEW;
	END;
$publiching$ LANGUAGE plpgsql;

CREATE TRIGGER publiching BEFORE INSERT OR UPDATE or DELETE ON book
    FOR EACH ROW EXECUTE PROCEDURE publiching();
	----------------------------------------------------------
	9.Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
	CREATE FUNCTION less_ten_new() RETURNS trigger AS  $less_ten_new$
  BEGIN
    IF ((select count(*) from book where book_new='Yes'and EXTRACT(MONTH from book_date)=EXTRACT(MONTH from current_data))>1 and New.book_new = 'Yes' 
      and EXTRACT(MONTH from New.book_date)=EXTRACT(MONTH from current_date) ) THEN
      RAISE EXCEPTION 'Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року';
      END IF;
    RETURN NEW;
  END;
$less_ten_new$ LANGUAGE plpgsql;

CREATE TRIGGER book__new_trig
  BEFORE INSERT or UPDATE 
  ON book
  FOR EACH ROW
  EXECUTE PROCEDURE less_ten_new()

	-----------------------------------------------------

10.видавництво BHV не випускає книги формату 60х88 / 16.

CREATE FUNCTION publiching_format() RETURNS trigger AS  $publiching_format$
	BEGIN
			IF (New.book_publiching like '%%BHV С.-Петербург%%' )and(New.book_format like'%%60х88 / 16%%') THEN
				RAISE EXCEPTION 'видавництво BHV не випускає книги формату 60х88 / 16.';
				END IF;	
			
				
		RETURN NEW;
	END;
$publiching_format$ LANGUAGE plpgsql;

CREATE TRIGGER publiching_format BEFORE INSERT OR UPDATE or DELETE ON book
    FOR EACH ROW EXECUTE PROCEDURE publiching_format();
	
	
	

select * from pg_trigger;
select * from book

INSERT INTO book VALUES (5127, 20,true,'21321',309,'32',42,'2020-06-15',33,1,1,1);
DROP FUNCTION delete_t() CASCADE
DELETE FROM book 
  WHERE book_id = 5127
  
 

  CREATE FUNCTION delete_t() RETURNS trigger AS  $delete_t$
  	Declare
	i_id integer;
	i_table varchar;
	
	BEGIN
		IF(select current_user!='dbo') THEN
      		RAISE EXCEPTION 'Користувач  не має права на видалення';
      		END IF;
			Select  count(book_id) into i_id from book where  book_id=OLD.book_id;		
			
		RETURN New; 
		
	END;
$delete_t$ LANGUAGE plpgsql;

CREATE TRIGGER delete_t AFTER DELETE ON book
    FOR EACH ROW EXECUTE PROCEDURE delete_t();