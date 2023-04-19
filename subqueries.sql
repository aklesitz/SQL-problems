-- Subqueries Practice
-- Return Names of students taking Physics and History
select student_name
from students
where student_no in(select student_no
					from student_enrollment
					where course_no in(select course_no
									from courses
									where course_title ilike 'physics'
									or course_title ilike 'us history'))

-- Return name of student taking highest number of courses
select student_name
from students
where student_no in(select student_no
					from(select student_no,
						count(course_no) course_count
						 from student_enrollment
						 group by student_no
						 order by course_count desc
						 limit 1) highest
				  )

select	student_no,
		count(course_no)
from student_enrollment
group by 1
order by 2 desc
limit 1	


-- Find which student is oldest without using LIMIT or ORDER BY	
SELECT *
FROM students
where age = (select max(age) from students)