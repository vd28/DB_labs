Select * from book;
1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з`єднання, застосовуючи where.
Select book_name,book_price,publih.publiching From book , publih where book.book_publiching = publih.key
----------------------------------
2.Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з`єднання, застосовуючи inner join.
Select book_name,category.category From book Inner Join category on book.book_category = category.key;
----------------------------------
3.Вивести значення наступних колонок: назва книги, ціна, назва видавництво, формат.
Select book_name,book_price,publih.publiching,book_format From book , publih where book.book_publiching = publih.key
----------------------------------
4.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництво. Фільтр за темами і категоріями.
Select topic.topic,category.category,book_name,publih.publiching From book,topic,category,publih WHERE book.book_topic = topic.key and
book.book_category = category.key and book.book_publiching = publih.key ORDER BY topic.topic,category.category
------------------------------------
5.Вивести книги видавництва 'BHV', видані після 2000 р
Select book_name,book_price,publih.publiching From book , publih where book.book_publiching = publih.key and 
publih.publiching like '%BHV%%' and Extract(Year from book.book_data)>2000
--------------------------------------
6.Вивести загальну кількість сторінок по кожній назві категорії. Фільтр за спаданням кількості сторінок.
Select  sum(book_price),category.category From book,category WHERE book.book_category = category.key Group by category.category
---------------------------------------
7.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
Select avg(book_price::numeric) From book,topic,category WHERE book.book_topic = topic.key and
book.book_category = category.key and topic.topic like '%%Використання ПК%%' and category.category like '%%Linux%%'
---------------------------------------
8.Вивести всі дані універсального відношення. Використовувати внутрішнє з`єднання, застосовуючи where.
Select topic.topic,category.category,publih.publiching From book,topic,category,publih WHERE book.book_topic = topic.key and
book.book_category = category.key and book.book_publiching = publih.key 
---------------------------------------
9.Вивести всі дані універсального відношення. Використовувати внутрішнє з`єднання, застосовуючи inner join.
Select topic.topic,category.category,publih.publiching From book Inner Join topic on book.book_topic = topic.key
Inner Join category on book.book_category = category.key Inner Join publih on book.book_publiching = publih.key
--------------------------------------
10.Вивести всі дані універсального відношення. Використовувати зовнішнє з`єднання, застосовуючи left join / rigth join.
Select topic.topic,category.category,publih.publiching From book LEFT OUTER JOIN topic on book.book_topic = topic.key
LEFT OUTER Join category on book.book_category = category.key LEFT OUTER Join publih on book.book_publiching = publih.key

Select topic.topic,category.category,publih.publiching From book Right OUTER JOIN topic on book.book_topic = topic.key
Right OUTER Join category on book.book_category = category.key Right OUTER Join publih on book.book_publiching = publih.key
--------------------------------------
11.Вивести пари книг, що мають однакову кількість сторінок. Використовувати самооб`єднання і аліаси (self join).
Select a.book_name as Book_name_1 , a.book_pages as Amount_of_pages_1, b.book_name as Book_name_2,
b.book_pages as Amount_of_pages_2 FROM book a ,book b  WHERE   a.book_pages=b.book_pages and a.book_id <> b.book_id
--------------------------------------=
12.Вивести тріади книг, що мають однакову ціну. Використовувати самооб`єднання і аліаси (self join).
Select a.book_name as Book_name_1 , a.book_price as price_1, b.book_name as Book_name_2,
b.book_price as price_2,c.book_name as Book_name_3, c.book_price as price_3 FROM book a ,book b,book c  WHERE   a.book_price=b.book_price and b.book_price =c.book_price 
and a.book_price=c.book_price and a.book_id <> b.book_id and a.book_id <>c.book_id and b.book_id<>c.book_id
-----------------------------------------
13.Вивести всі книги категорії 'C ++'. використовувати підзапити (Subquery) .
SELECT  * FROM book  WHERE book_category in (SELECT key FROM category WHERE category like '%%C ++%%')
---------------------------------
14.Вивести книги видавництва 'BHV', видані після 2000 р Використовувати підзапити (Subquery) .
SELECT  * FROM book  WHERE book_publiching in (SELECT key FROM publih
											 WHERE publiching like '%BHV%%' and Extract(Year from book.book_data)>2000)
------------------------------------------
15.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов`язані підзапити (correlated subquery).
SELECT distinct(publih.publiching) FROM publih  Inner Join book  on  publih.key = book.book_publiching
  WHERE book.book_publiching in (SELECT book_publiching FROM book WHERE book_pages >400);
-------------------------------------------------
16.Вивести список категорій за якими більше 3-х книг. Використовувати пов`язані підзапити (correlated subquery).
SELECT c.category as Категорія,count(*) as Кількість_книг FROM category c Inner Join book b on c.key=b.book_category 
  WHERE (select count(*) FROM  book b WHERE b.book_category=c.key ) >= 3 GROUP BY category;
---------------------------------------------
17.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.
SELECT * FROM book WHERE  EXISTS(SELECT 1 FROM publih WHERE publiching like '%BHV%%' )
---------------------------------------------
18.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва. використовувати not  exists.
SELECT * FROM book WHERE  NOT EXISTS (SELECT 1 FROM publih WHERE book.book_publiching= publih.key 
									  and publiching like '%BHV%%' )
------------------------------------------------
19.Вивести відсортоване загальний список назв тем і категорій. Використовувати union.
select 'book' as type,book_name  from book union select 'topic' as type, topic from topic union select 'category' as type, 
category from category order by book_name
------------------------------------------------
20.Вивести відсортоване в зворотному порядку загальний список  перших слів назв книг (що не повторюються) і категорій. Використовувати union.
SELECT DISTINCT  'book' AS TYPE,substring(book_name from 0 for position(' ' in book_name))  FROM book UNION SELECT 'category' AS TYPE, 
category FROM category 
											 