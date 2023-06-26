create or replace function 
    linkLearnerToSchool (the_learnerId int, the_schoolId int)
    returns boolean as
$$
declare
-- declare a variable to be used in the function
total int;

begin

    -- run a query to check if the learner link to school 
    select into total count(*) from learner_school
        where LOWER(learner_id) = LOWER(the_learnerId);

 

    -- if total is 0 the learner not linked to the school
    if (total = 0) then
        -- then create 
        insert into learner_school (learner_id, school_id) values (the_learnerId, the_schoolId );
        -- and returns true if the created and linked 
        return true;
    else
        -- returns false if not linked
        return false;
    end if;

end;
$$
Language plpgsql;

--
--
--

create or replace function 
    getLearnersCurrentSchool ( the_learner_id int )

    returns table (

    the_learnersCurrentSchool text

    )as 
$$

begin
    return query
    select learner_school.current_school from learner_school
        where learner_school.learner_id = the_learner_id;

end;
$$
Language plpgsql;

select * from getLearnersCurrentSchool(4);

--
--
--

create or replace function 
    getSchoolsForLearner (the_learner_id int )

    returns table (
    the_learnerSchools text
    )as 
  
$$
begin
    return query
  
    select school.name from school
     join learner_school on learner_school.school_id  = school.id 
        where learner_school.learner_id = the_learner_id;

end;
$$
Language plpgsql;

select * from getSchoolsForLearner(5);

--
--
--
