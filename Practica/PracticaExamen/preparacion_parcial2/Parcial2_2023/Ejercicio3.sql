create table titles(
	title_id varchar(6) not null,
	title varchar(80) not null,
	type char(12) not null default 'UNDECIDED',
	pub_id char(4),
	price numeric(10,2),
	advance numeric(10,2),
	royalty int,
	notes varchar(200),
	pubdate date not null default current_date
);

-- Inserting values into the titles table
INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, notes, pubdate)
VALUES
('T0001', 'The Catcher in the Rye', 'Fiction', 'P001', 25.99, 5000.00, 15, 'Classic novel', '1951-07-16'),
('T0002', 'To Kill a Mockingbird', 'Fiction', 'P002', 20.50, 6000.00, 12, 'American literature', '1960-07-11'),
('T0003', '1984', 'Fiction', 'P003', 18.75, 5500.00, 14, 'Dystopian novel', '1949-06-08'),
('T0004', 'The Great Gatsby', 'Fiction', 'P002', 22.95, 7000.00, 10, 'Jazz Age novel', '1925-04-10'),
('T0005', 'Brave New World', 'Fiction', 'P003', 21.25, 6500.00, 13, 'Science fiction', '1932-10-14');

create or replace function get_record(tid varchar(6))
returns titles as $$
declare
	rtn_title titles;
begin 
	select into rtn_title
	* 
	from titles 
	where titles.title_id = tid;
	return rtn_title;
end
$$ language plpgsql;

drop function get_record;

select get_record('T0001');

create  or replace function get_setofdate(startdate date, endate date)
returns setof date as $$
declare
	aux date;
	dates_cursor cursor for select titles.pubdate from titles
	where pubdate <= endate and pubdate >= startdate;
begin
	open dates_cursor;
	loop
		fetch next from dates_cursor into aux;
		exit when not found;
		return next aux;
	end loop;
	close dates_cursor;
	return;
end
$$ language plpgsql;

select get_setofdate('1925-04-10','1950-07-11');


CREATE TYPE libro AS (
    title VARCHAR(50),
    title_id VARCHAR(6),
    pub_id CHAR(4)
);

CREATE OR REPLACE FUNCTION get_setoftype(title_id_param VARCHAR)
RETURNS SETOF libro AS $$
DECLARE
    lib libro;
BEGIN
    FOR lib IN
        SELECT title, title_id, pub_id FROM titles WHERE title_id = title_id_param
    LOOP
        RETURN NEXT lib;
    end loop;

    return;
end;
$$ LANGUAGE plpgsql;

select get_setoftype('T0001');
	
