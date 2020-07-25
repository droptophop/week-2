use AdventureWorks2017;
go


-- SELECT (select, from, where, group by, having, order by)
select 'hello'; 
select 1 + 1;

select * -- horizontal filter
from Person.Person;

-- collation = character set is case insensitive, accent sensitive
-- A == a, â != a
select firstname, lastname
from Person.Person;

select firstname, lastname
from Person.Person
where firstname = 'john' or lastname = 'john'; -- vertical filter

select firstname, lastname
from Person.Person
where firstname <> 'john' and lastname <> 'john';

select firstname, lastname
from Person.Person
where (firstname >= 'k' and firstname < 'l') or (lastname >= 'k' and lastname < 'l');

select firstname, lastname
from Person.Person
where (firstname like 'k%') or (lastname like 'k%'); -- % wildcard, 0 or more characters

select firstname, lastname
from Person.Person
where (firstname like '%k') or (lastname like '%k%');

select firstname, lastname
from Person.Person
where (firstname like 'k__') or (lastname like '__k'); -- _ wildcard, exactly 1

select firstname, lastname
from Person.Person
where (firstname like '[k,z]%') or (lastname like '[a-d]_k'); -- a_k, b_k, c_k, d_k

select firstname, lastname
from Person.Person
where firstname = 'john'
group by firstname, lastname;

select firstname, lastname, count(*) as count -- aggregate count, average, sum
from Person.Person
where firstname = 'john'
group by firstname, lastname;

select firstname, lastname, count(*) as count
from Person.Person
where firstname = 'john' --vertical filter of records
group by firstname, lastname
having count(*) > 1; --vertical filter of groups

select firstname, lastname, count(*) as count
from Person.Person
where firstname = 'john'
group by firstname, lastname
having count(*) > 1
order by lastname desc, count desc;

select firstname, lastname, count(*) as johns
from Person.Person
where firstname = 'john'
group by firstname, lastname
having count(*) > 1
order by johns desc, lastname desc;

-- ORDER OF EXECUTION
--from
--where
--group by
--having
--select
--order by

-- INSERT
select *
from Person.Address
where AddressLine1 like '123 elm%';

insert into Person.Address(AddressLine2, AddressLine1, City, StateProvinceID, PostalCode, SpatialLocation, rowguid, ModifiedDate)
values
('123 elm street', 'suite 200',	'dallas',	14, 75200, 0xE6100000010C72C2B2242FE04A4016902E7EB1B7F8BF,	'fd069aaa-ad12-4a4c-a548-23b35dfeb242',	'2020-07-22')
,('123 elm street', 'suite 200',	'dallas',	14, 75200, 0xE6100000010C72C2B2242FE04A4016902E7EB1B7F8BF,	'fd069aaa-ad12-4a4c-a548-23b35dfeb242',	'2020-07-22')
,('123 elm street', 'suite 200',	'dallas',	14, 75200, 0xE6100000010C72C2B2242FE04A4016902E7EB1B7F8BF,	'fd069aaa-ad12-4a4c-a548-23b35dfeb242',	'2020-07-22')
,('123 elm street', 'suite 200',	'dallas',	14, 75200, 0xE6100000010C72C2B2242FE04A4016902E7EB1B7F8BF,	'fd069aaa-ad12-4a4c-a548-23b35dfeb242',	'2020-07-22')

-- UPDATE
update pa
set addressline2 = 'suite 200', addressline1 = '123 elm st'
from Person.Address as pa
where AddressLine1 = 'suite 200';

-- DELETE
delete pa
from Person.Address as pa
where AddressLine2 = 'suite 200';
go 

-- VIEW
create view vw_getpersons with schemabinding -- firstname and lastname cannot chnage for the lifetime of this view
as
select firstname, lastname
from Person.Person
go

select * from vw_getpersons; --read-only access to Person.Person
go

alter view vw_getpersons with schemabinding
as
select firstname, middlename, lastname
from Person.Person
go

drop view vw_getpersons;
go

-- FUNCTION
--scalar = return a value

create function fn_getname(@id int)
returns nvarchar(250)
as
begin
  --what is the value of null
  --why is coalesce a solution?
  
  declare @result NVARCHAR(250);
  select @result = firstname + coalesce(' ' + middlename + ' ', ' ') + lastname -- isnull
  from Person.Person
  where businessentityid = @id

  return @result;
end;
go

select dbo.fn_getname(15689) name;
go

--tabular = returns 1 or more records

create function fn_getpeople(@first nvarchar(200))
returns table
as
return
    select firstname, lastname
    from Person.Person
    where firstname = @first
go

select * from dbo.fn_getpeople('Ann');
go

-- STORED PROCEDURE
--stored procedures are cached (unlike functions) making them faster than functions
--allows for retrieving data with certain criteria

create proc sp_insertperson(@first nvarchar(200), @last nvarchar(200))
as
begin
    --validate first, last
    begin tran -- can succeed or fail
        --ACID properties
            --Atomic = a transaction that affects only one record set and should complete
            --Consistent = should be the same record set if repeated with same result
            --Isolation = considers isolation levels, should not have side effects (imagine threads being ran)
            --Durable = should be saved entirely

        if(@first is not null and @last is not null)
        --validate duplicate
        begin
            declare @result int;

            select @result = BusinessEntityID
            from Person.Person
            where firstname = @first and lastname = @last

            if (@result is null)
            --insert
            begin
                insert into Person.Person(firstname, lastname)
                values (@first, @last);
                commit tran;
                --isolation levels determine how a record should be inserted into a table
                    --isolates read sessions from edit/delete sessions
                        --READ UNCOMMITTED = dirty read, any record in the table, complete or not (imagine iMessage bubbles), are known
                        --*READ COMMITTED = clean read, only completed records can be read
                        --*REPEATABLE READ = clean read, only the latest, most recent snapshot of records can be read (imagine having to refresh an email inbox)
                        --SERIALIZABLE = clean read, [REPEATABLE] but dataset is locked from edit/delete (imagine attempting to preorder a release from XStock)
            
            end
            else
            begin
                rollback tran
            end
        end
end;
go

-- JOIN



-- UNION

-- TRIGGER

-- TRANSACTION

-- ORM + Entity Framework Core + Data First Approach
