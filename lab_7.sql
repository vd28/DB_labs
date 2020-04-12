1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
create function get_N_P_PU_f()
	returns table (book_name text,book_price money,book_publiching text,book_format text )
as
$$
Select cast(book_name as text),cast(book_price as money),cast(publih.publiching as text),cast(book_format as text) 
From book , publih 
where book.book_publiching = publih.key
$$
language sql;

select *
from get_N_P_PU_f();

-----------------------------------
2.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
create function get_T_C_N_Pu()
	returns table (topic text,category text,publiching text,format text )
as
$$
Select cast(topic.topic as text),cast(category.category as text),cast(book_name as text),cast(publih.publiching as text) 
From book,topic,category,publih 
WHERE book.book_topic = topic.key 
and
book.book_category = category.key 
and book.book_publiching = publih.key 
ORDER BY topic.topic,category.category
$$
language sql;

Select * from get_T_C_N_Pu()
--------------------------------------
3.Вивести книги видавництва 'BHV', видані після 2000 р
create function get_BHV_publiching_after_2000()
	returns table (name text,price money,publiching text)
as
$$
Select cast(book_name as text),cast(book_price as money),cast(publih.publiching as text) 
From book , publih 
where book.book_publiching = publih.key 
and 
publih.publiching like '%BHV%%' and Extract(Year from book.book_data)>2000
$$
language sql;

Select * from get_BHV_publiching_after_2000()
----------------------------------------
4.Вивести загальну кількість сторінок по кожній назві категорії. 
create function get_page_count_by_category()
	returns table (page_count integer,category text)
as
$$
Select cast(sum(book_pages) as integer),cast(category.category as text) 
From book,category 
WHERE book.book_category = category.key 
Group by category.category 
$$
language sql;

Select * from get_page_count_by_category()
----------------------------------------
5.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
create function get_avg_price_by_topic_and_category()
	returns table (avg_price numeric)
as
$$
Select cast(avg(book_price::numeric) as numeric)
From book,topic,category 
WHERE book.book_topic = topic.key 
and book.book_category = category.key 
and topic.topic like '%%Використання ПК%%' and category.category like '%%Linux%%'
$$
language sql;

Select * from get_avg_price_by_topic_and_category()
-----------------------------------
6.Вивести всі дані універсального відносини.
create function get_universaly_attitude()
	returns table (topic text, category text, publiching text)
as
$$
Select cast(topic.topic as text),cast (category.category as text),cast(publih.publiching as text) 
From book,topic,category,publih 
WHERE book.book_topic = topic.key 
and book.book_category = category.key 
and book.book_publiching = publih.key 
$$
language sql;


Select * from get_universaly_attitude()

-------------------------------------------
7.Вивести пари книг, що мають однакову кількість сторінок.
create function get_book_with_same_page_count()
	returns table (B_N_1 text, A_P_1 text, B_N_2 text,A_P_2 text)
as
$$
Select cast(a.book_name as text)  , cast( a.book_pages as text),
cast(b.book_name as text) , cast( b.book_pages as text)
FROM book a ,book b  
WHERE   a.book_pages=b.book_pages and a.book_id <> b.book_id
$$
language sql;


Select * from get_book_with_same_page_count()

--------------------------------------------
8.Вивести тріади книг, що мають однакову ціну.
create function get_book_3_with_same_price()
	returns table (B_N_1 text, A_P_1 money, B_N_2 text,A_P_2 money, B_N_3 text, A_P_3 money)
as
$$
Select cast(a.book_name as text)  ,cast(a.book_price as money) , cast(b.book_name as text) ,
cast(b.book_price as money) ,cast(c.book_name as text) , cast(c.book_price as money) 
FROM book a ,book b,book c  
WHERE   a.book_price=b.book_price and b.book_price =c.book_price 
and a.book_price=c.book_price and a.book_id <> b.book_id and a.book_id <>c.book_id and b.book_id<>c.book_id
$$
language sql;

Select * from  get_book_3_with_same_price()

----------------------------------------------
9.Вивести всі книги категорії 'C ++'.
create function get_C_books()
	returns setof book
as
$$
SELECT  * FROM book  WHERE book_category in (SELECT key FROM category WHERE category like '%%C ++%%')
$$
language sql;

Select * from get_C_books()
--------------------------------
10.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
create function get_P_page_must_then_400()
	returns table (publiching text)
as
$$

SELECT distinct(cast(publih.publiching as text))  
FROM publih  Inner Join book  on  publih.key = book.book_publiching
WHERE book.book_publiching in (SELECT book_publiching FROM book WHERE book_pages >400);
$$
language sql;

Select * from get_P_page_must_then_400()
-------------------------------------
11.Вивести список категорій за якими більше 3-х книг.

create function get_category_where_book_must_then_3()
	returns table (category text,book_count int)
as
$$
SELECT cast(c.category as text) ,cast(count(*) as int)  
FROM category c Inner Join book b on c.key=b.book_category 
WHERE (select count(*) FROM  book b WHERE b.book_category=c.key ) >= 3 GROUP BY category;
$$
language sql;

Select * from get_category_where_book_must_then_3()
------------------------------------------
12.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.
create function get_book_BHV_publiching()
	returns setof book
as
$$
SELECT * FROM book WHERE  EXISTS(SELECT 1 FROM publih WHERE publiching like '%BHV%%' )
$$
language sql;

Select * from get_book_BHV_publiching()

-----------------------------------------------
13.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.
create function get_book_NOT_BHV_publiching()
	returns setof book
as
$$
SELECT * FROM book WHERE  NOT EXISTS (SELECT 1 FROM publih WHERE book.book_publiching= publih.key 
									  and publiching like '%BHV%%' )
$$
language sql;

Select * from get_book_NOT_BHV_publiching()
-----------------------------------------------
14.Вивести відсортоване загальний список назв тем і категорій.
create function get_all_topic_category()
	returns table (type text,name text)
as
$$
select cast('book' as text) ,cast(book_name as text) 
from book union select cast('topic' as text), cast(topic as text)
from topic union select cast('category' as text), cast(category as text)
from category order by book_name
$$
language sql;

Select * from get_all_topic_category()
-----------------------------------------------------
15.Вивести в зворотному порядку загальний список неповторяющихся перших слів назв книг і категорій.
create function get_all_list_first_word()
	returns table (type text,name text)
as
$$
SELECT DISTINCT  cast('book' AS text),cast(substring(book_name from 0 for position(' ' in book_name)) as text) 
FROM book UNION SELECT 'category' AS TYPE, 
cast(substring(category from 0 for position(' ' in category)) as text)  FROM category 
$$
language sql;

Select * from  get_all_list_first_word()










