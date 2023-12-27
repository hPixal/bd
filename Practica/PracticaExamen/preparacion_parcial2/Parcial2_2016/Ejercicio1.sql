create table authors (
	aud_id varchar(11) not null,
	constraint authors_chk check (aud_id like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),  
	constraint authors_pk primary key (aud_id),
	au_lname varchar(40) not null,
	au_fname varchar(20) not null,
	phone char(12) null,
	city char(20) null,
	state char(2) null,
	zip char(5) null check(zip like '[0-9][0-9][0-9][0-9][0-9]'),
	contract bool not null
);

drop table authors;

-- Sample inserts for authors table
INSERT INTO authors (aud_id, au_lname, au_fname, phone, city, state, zip, contract)
VALUES ('123-456-7890', 'Smith', 'John', '123-456-7890', 'New York', 'NY', '12345', true),
       ('234-567-8901', 'Johnson', 'Sarah', '234-567-8901', 'Los Angeles', 'CA', '54321', false),
       ('345-678-9012', 'Williams', 'Michael', NULL, 'Chicago', 'IL', '67890', true);


create table publishers(
	pub_id char(4),
	constraint publishers_pk primary key(pub_id),
	pub_name varchar(40) not null
);

drop table publishers;

-- Sample inserts for publishers table
INSERT INTO publishers (pub_id, pub_name)
VALUES ('ABC1', 'ABC Publications'),
       ('XYZ1', 'XYZ Books'),
       ('1231', '123 Publishing');


create  table titles(
	title_id varchar(6),
	constraint titles_pk primary key(title_id),
	title varchar(80) not null,
	type varchar(12) not null,
	pub_id char(4) null,
	constraint titles_publishers_k foreign key (pub_id)
	references publishers(pub_id),
	price numeric null,
	advance numeric null,
	royalty integer null,
	notes varchar(255) null,
	pubdate date not null default current_date
);

drop table titles cascade;

-- Sample inserts for titles table
INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, notes, pubdate)
VALUES ('T001', 'Introduction to SQL', 'Educational', 'P001', 29.99, 5000, 10, 'Bestseller', '2023-01-15'),
       ('T002', 'Python Programming', 'Technical', 'P002', 39.99, 7000, 12, 'Advanced Level', '2022-11-30'),
       ('T003', 'The Art of Writing', 'Literary', 'P003', 19.99, 3000, 8, 'Beginners Guide', '2023-03-20');


create table titleauthor (
	au_id varchar(11) references authors(aud_id),
	title_id varchar(6),
	constraint titleauthor_titles_fk foreign key(title_id)
			   references titles(title_id),
	au_ord smallint null,
	royaltyper int null,
	constraint titleauthor_pk primary key(au_id,title_id)
);

drop table titleauthor;

-- Sample inserts for titleauthor table
INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper)
VALUES ('123-456-7890', 'T001', 1, 15),
       ('234-567-8901', 'T002', 2, 18),
       ('345-678-9012', 'T003', NULL, NULL);


create table sales(
	store_id char(4) not null,
	constraint sales_pk primary key(store_id),
	ord_num varchar(20) not null,
	ord_date date not null,
	qty integer not null
);

drop table sales;

-- Sample inserts for sales table
INSERT INTO sales (store_id, ord_num, ord_date, qty)
VALUES ('S001', 'ORD001', '2023-01-05', 100),
       ('S002', 'ORD002', '2023-02-10', 75),
       ('S003', 'ORD003', '2023-03-20', 150);

