-- data definition language

use master;
go

-- CREATE

create database PizzaStoreDb; -- project
go

create schema Pizza; -- namespace
go

    -- constraints = datatype, key, default, check, null, computed
    -- number datatypes = tinyint (int8), smallint (int16), int (int32), bigint (int64), numeric, decimal, money
    -- text datatypes = text, ntext, varchar (supports ascii, english), nvarchar (supports utf-8, [nearly] all spoken languages)
    -- datetime datatypes = date, time, datetime, datetime2
    -- boolean datatypes = bit

create table Pizza.Pizza
(
    PizzaId int not null primary key, -- Identity (seed, step)
    CrustId int null foreign key references Pizza.Crust(CrustId), -- least likely to be used for referencing key
    [Name] nvarchar(250) not null, -- '[]' serve as escape sequence in SQL 
    DateModified datetime2(0) not null,
    Active bit not null default 1
    constraint SizeId foreign key references Pizza.Size(SizeId) -- more likely to be used for referencing key
);

create table Pizza.Crust
(
    CrustId int not null,
    [Name] nvarchar(100) not null,
    Active bit not null
    constraint CrustId primary key,
    constraint Active default 1
);

create table Pizza.Size
(
    SizeId int not null,
    [Name] nvarchar(100) not null,
    Active bit not null
);

create table Pizza.Toppings
(
    ToppingId int not null,
    [Name] nvarchar(100) not null,
    Active bit not null
);

create table Pizza.PizzaTopping
(
    PizzaToppingId int not null,
    PizzaId int not null,
    ToppingId int not null,
    Active bit not null
);
go

-- ALTER

alter table Pizza.Size
    add constraint PK_Size_SizeId SizeId primary key

alter table Pizza.Topping
    add constraint PK_Topping_TopppingId ToppingId primary key

alter table Pizza.PizzaTopping
    add constraint PK_PizzaToppping_PizzaToppingId PizzaToppingId primary key

alter table Pizza.PizzaTopping
    add constraint FK_PizzaToppping_PizzaId PizzaId foreign key references Pizza.Pizza(PizzaId)

alter table Pizza.PizzaTopping
    add constraint FK_PizzaToppping_ToppingId ToppingId foreign key references Pizza.Topping(ToppingaId)
go

-- DROP
    -- replication = Having mutliple copies of db (promotes optimal performance)
    -- backup = cold storage
        -- backups are categorized as full (backup at intervals regardless of whether a change has occurred), 
        -- differential (backup data that has changed since the last backup [record with structure/table]), 
        -- or incremental (backup any full table that has changed since last backup [structure/table])
    -- failover = hot storage
        -- rerouting traffic and data from a non-working server to the next working server
        -- w/replication, its simply retrieving the latest backup
        -- w/o replication, 

drop table Pizza.Pizza; -- tables are typically archived rather than dropped
drop schema Pizza; -- schema are typically archived rather than dropped
drop database PizzaStoreDb; -- occurs in development

-- TRUNCATE
    -- comparable to empyting recycle bin/trash
    -- deletes current structure and its data, and recreates the structure w/o data
    
truncate table Pizza.Pizza;
truncate schema Pizza;
truncate database PizzaStoreDb;




