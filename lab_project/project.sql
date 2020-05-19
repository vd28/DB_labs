53.	БД по студенческому общежитию (корпус – комнаты – проживающие – оплаты за проживание). 
-----------------------------------------------------------
Create TABLE hostle_wing(
wing_number integer primary key not NULL
)

Create Table hostle_room(
wing_number integer not NULL,
room_number integer primary key not NULL,
count_of_people integer not NULL,
foreign key(wing_number) REFERENCES hostle_wing (wing_number)
)

CREATE TABLE people(
room_number integer not NULL,
name varchar not NULL,
people_id integer primary key not NULL,
foreign key(room_number) REFERENCES hostle_room (room_number)
)

CREATE TABLE payment(
people_id integer primary key not NULL,
to_pay money Default 0,
foreign key(people_id) REFERENCES people (people_id)
)

----------------------------
функция вывода количества человек на крыле\/
----------------------------
Create OR REPLACE FUNCTION people_count_in_wing(wing_id integer) RETURNS table(count_p integer )
    AS $body$ 
		Select cast(count(*) as integer) 
		from hostle_room, people where people.room_number = hostle_room.room_number and hostle_room.wing_number = wing_id 
	$body$
    LANGUAGE SQL;
Select * from people_count_in_wing(1);
---------------------------
функция вывода количества проживающих\/
---------------------------
Create OR REPLACE FUNCTION people_count_in_hostel() RETURNS table(count_p integer )
    AS $body$ 
		Select cast(count(*) as integer) 
		from hostle_room, people where people.room_number = hostle_room.room_number
	$body$
    LANGUAGE SQL;
Select * from people_count_in_hostel();
----------------------------
Функция вывода информации о определенном человеке, поиск по имени\/
----------------------------
Create OR REPLACE FUNCTION info_about_people(name_p varchar) RETURNS table(wing integer, room integer, name varchar, id integer, pay money)
    AS $$ Select wing_number,hostle_room.room_number,people.name,people.people_id,payment.to_pay 
		from hostle_room, people,payment where people.room_number = hostle_room.room_number
		and payment.people_id=people.people_id and people.name like name_p $$
    LANGUAGE SQL;
Select * from info_about_people('Ніконов В.В.');
-----------------------------
функция вывода данных о всех проживающих \/
-----------------------------
Create OR REPLACE FUNCTION info_about_all_people() RETURNS table(wing integer, room integer, name varchar, id integer, pay money)
    AS $$ Select wing_number,hostle_room.room_number,people.name,people.people_id,payment.to_pay 
		from hostle_room, people,payment where people.room_number = hostle_room.room_number
		and payment.people_id=people.people_id $$
    LANGUAGE SQL;
Select * from info_about_all_people();
----------------------------
Функция вывода данных по задолжености\/
----------------------------
Create OR REPLACE FUNCTION debtors() RETURNS table(wing integer, room integer, name varchar, id integer, pay money)
    AS $$ Select wing_number,hostle_room.room_number,people.name,people.people_id,payment.to_pay 
		from hostle_room, people,payment where people.room_number = hostle_room.room_number
		and payment.people_id=people.people_id and payment.to_pay>money(0)$$
    LANGUAGE SQL;
	
Select * from debtors()
------------------------------
Тригер на переполненую комнату\/
------------------------------
CREATE FUNCTION people_count() RETURNS trigger AS  $people_count$
	DECLARE 
    count_p integer;
	roominess integer;
	BEGIN
		
		Select count(people_id) INTO count_p FROM people where(room_number=New.room_number);
		Select count_of_people INTO roominess FROM hostle_room where(room_number= New.room_number);
		IF (count_p=roominess ) THEN
			RAISE EXCEPTION 'Комната заполнена';
		END IF;
		RETURN NEW;
	END;
$people_count$ LANGUAGE plpgsql;

CREATE TRIGGER people_count BEFORE INSERT OR UPDATE ON people
    FOR EACH ROW EXECUTE PROCEDURE people_count();