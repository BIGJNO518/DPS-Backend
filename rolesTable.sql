-- Author @Ahsan Beshal

drop table if exists roles;

create table roles (

	rid int primary key,
	roleslist varchar

);

insert into roles(rid, roleslist) values (1, 'Admin');
insert into roles(rid, roleslist) values (2, 'Developer');
insert into roles(rid, roleslist) values (3, 'Employee');
insert into roles(rid, roleslist) values (4, 'Volunteer');

select * from roles;
