-- data definition language

use master;
go

-- CREATE

create database PizzaStoreDb; -- project
go

create schema Pizza; -- namespace
go

-- constraints = datatype, key, default, check, null, ?
-- number datatypes = tinyint (int8), smallint (int16), int (int32), bigint (int64), numeric, decimal, money
-- text datatypes = text, ntext, varchar (supports ascii, english), nvarchar (supports utf-8, [nearly] all spoken languages)
-- datetime datatypes = date, time, datetime, datetime2
-- boolean datatypes = bit

create table Pizza.Pizza
(
    PizzaId int not null,
    Name nvarchar(250) not null,
    DateModified datetime2(0) not null,
    IsValid bit not null,
    constraint PK_Pizza (PizzaId) primary key
);

create table Pizza.Crust
(
    CrustId int not null,
    Name nvarchar(100) not null,
    Active bit not null
);

create table Pizza.Size
(

);

create table Pizza.Toppings
(

);
-- ALTER



-- DROP



-- TRUNCATE

