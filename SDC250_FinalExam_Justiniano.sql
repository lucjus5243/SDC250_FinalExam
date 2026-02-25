-- =========================================================
-- SDC250 Final Exam
-- Lucas Justiniano
-- =========================================================


-- =========================================================
-- Question 1 – Courses cheaper than average (formatted cost)
-- =========================================================
-- Lucas Justiniano
select
    description,
    course_no,
    to_char(cost, '$9,999') as cost
from course
where cost < (select avg(cost) from course)
order by cost desc;


-- =========================================================
-- Question 2 – Courses and their sections
-- =========================================================
-- Lucas Justiniano
select
    c.course_no,
    c.description,
    c.cost,
    s.start_date_time
from course c
join section s
    on s.course_no = c.course_no
order by c.course_no, c.description;


-- =========================================================
-- Question 3 – Zipcodes and instructor count
-- =========================================================
-- Lucas Justiniano
select
    z.zip,
    count(i.instructor_id) as instructor_count
from zipcode z
left join instructor i
    on z.zip = i.zip
group by z.zip
order by z.zip;


-- =========================================================
-- Question 4 – Students living in Brooklyn
-- =========================================================
-- Lucas Justiniano
select
    s.student_id,
    s.first_name,
    s.last_name,
    s.street_address,
    s.state,
    s.zip
from student s
join zipcode z
    on s.zip = z.zip
where upper(z.city) = 'BROOKLYN'
order by s.last_name, s.first_name;


-- =========================================================
-- Question 5 – Instructors and number of sections taught
-- =========================================================
-- Lucas Justiniano
select
    i.first_name,
    i.last_name,
    count(s.section_id) as num_sections
from instructor i
left join section s
    on i.instructor_id = s.instructor_id
group by i.first_name, i.last_name
order by num_sections desc;


-- =========================================================
-- Question 6 – Students in same zipcode as Tom Wojick
-- =========================================================
-- Lucas Justiniano
select
    s.first_name,
    s.last_name,
    s.street_address,
    s.zip
from student s
where s.zip = (
    select zip
    from instructor
    where upper(first_name) = 'TOM'
      and upper(last_name) = 'WOJICK'
);


-- =========================================================
-- Question 7 – Students registered before Vera Wetcel
-- =========================================================
-- Lucas Justiniano
select
    s.student_id,
    s.salutation,
    s.first_name,
    s.last_name
from student s
where s.registration_date < (
    select registration_date
    from student
    where upper(first_name) = 'VERA'
      and upper(last_name) = 'WETCEL'
)
order by s.registration_date;


-- =========================================================
-- Question 8 – Students not enrolled in any classes
-- =========================================================
-- Lucas Justiniano
select
    s.student_id
from student s
where not exists (
    select 1
    from enrollment e
    where e.student_id = s.student_id
)
order by s.student_id;


-- =========================================================
-- Question 9 – Create view all_people_view
-- =========================================================
-- Lucas Justiniano
create or replace view all_people_view as
select
    salutation,
    first_name || ' ' || last_name as full_name,
    street_address,
    zip,
    phone
from student
union
select
    salutation,
    first_name || ' ' || last_name as full_name,
    street_address,
    zip,
    phone
from instructor;


-- =========================================================
-- Question 10 – Student with highest grade
-- =========================================================
-- Lucas Justiniano
select
    s.first_name,
    s.last_name,
    s.student_id
from student s
join enrollment e
    on e.student_id = s.student_id
where e.final_grade = (
    select max(final_grade)
    from enrollment
);


-- =========================================================
-- Question 11 – Courses with more than 5 sections
-- =========================================================
-- Lucas Justiniano
select
    c.course_no,
    c.description,
    count(s.section_id) as num_sections
from course c
join section s
    on s.course_no = c.course_no
group by c.course_no, c.description
having count(s.section_id) > 5
order by num_sections desc;


-- =========================================================
-- Question 12 – Courses and their prerequisites
-- =========================================================
-- Lucas Justiniano
select
    c.course_no,
    c.description,
    c.cost,
    p.course_no as prereq_course_no,
    p.description as prereq_description
from course c
left join course p
    on c.prerequisite = p.course_no
order by c.course_no;


-- =========================================================
-- Question 13 – Course(s) with the most sections
-- =========================================================
-- Lucas Justiniano
select
    c.course_no,
    c.description,
    count(s.section_id) as num_sections
from course c
join section s
    on s.course_no = c.course_no
group by c.course_no, c.description
having count(s.section_id) = (
    select max(section_count)
    from (
        select count(section_id) as section_count
        from section
        group by course_no
    )
)
order by c.course_no;


-- =========================================================
-- Question 14 – Courses where enrollment exceeds capacity
-- =========================================================
-- Lucas Justiniano
select
    c.course_no,
    c.description,
    s.start_date_time,
    s.capacity,
    count(e.student_id) as enrolled_students
from course c
join section s
    on s.course_no = c.course_no
join enrollment e
    on e.section_id = s.section_id
group by
    c.course_no,
    c.description,
    s.start_date_time,
    s.capacity
having count(e.student_id) > s.capacity
order by c.course_no, s.start_date_time;
