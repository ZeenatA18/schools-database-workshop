create or replace function 
	add_teacher ( the_name text, the_surname text, the_email text )
	returns boolean as
$$
declare
-- declare a variable to be used in the function
email int;

begin

	-- run a query to check if the email name exists
	select into email count(*) from teacher
		where LOWER(first_name) = LOWER(the_name);

	-- if email is 0 the subject doesn't exist
	if (email = 0) then
		-- then create the teacher
		insert into teacher (first_name, last_name, email) values (the_name, the_surname, the_email);
		-- and returns true if the teacher was created already
		return true;
	else
		-- returns false if the teacher already exists
		return false;
	end if;

end;
$$
Language plpgsql;

select *  from add_teacher('Zeenat','Avontuur','zee@gmail.com'); 
select * from teacher;

--end of the add_teacher function

--start of link_teacher_to_subject function

create or replace function 
	link_teacher_to_subject ( the_teacher_id integer DEFAULT NULL::integer , the_subject_id integer DEFAULT NULL::integer)
	returns boolean as
$$
declare
-- declare a variable to be used in the function
total int;

begin

	-- run a query to check if the subject name exists
	select into total count(*) from teacher_subject
		where (teacher_id, subject_id) = (the_teacher_id , the_subject_id);

	-- if total is 0 the subject doesn't exist
	if (total = null) then
		-- then create the subject
		insert into teacher (teacher_id, subject_id) values (the_teacher_id , the_subject_id);
		-- and returns true if the subject was created already
		return true;
	else                                                                                                                                                                                                                                       
		-- returns false if the subject already exists
		return false;
	end if;

end;
$$
Language plpgsql;

select *  from link_teacher_to_subject(2,1); 
select * from teacher_subject;

--end of link_teacher_to_subject function

--start of find_teachers_for_subject function

create or replace function 
	find_teacher_for_subject ( subject.name text)
	
	returns table (
		the_teacher text
	) as
	
$$
begin
return query

select 
	teacher.*
from teacher
 	join teacher_subject on teacher.id = teacher_subject.teacher_id
	join subject on teacher_subject.subject_id = subject.id
where 
	subject.name = subject.name;
	
end;
$$
Language plpgsql;

-- end of find_teachers_for_subject function

--start of find_teachers_teaching_multiple_subjects function

create or replace function 
	find_teacher_teaching_multiple_subjects ( no_subject int)
	
	returns table (
		the_teacher text
	) as
	
$$
begin
return query

select 
	teacher.first_name from teacher_subject
 	join teacher on teacher.id = teacher_subject.teacher_id
	join subject on subject_id = teacher_subject.subject.id
    group by teacher.first_name
    having count(teacher_subject.subject_id) = no_subject;
	
end;
$$
Language plpgsql;

--end of find_teachers_teaching_multiple_subjects function
