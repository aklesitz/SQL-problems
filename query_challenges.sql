-- Return students who did not take CS180
SELECT student_no
FROM student_enrollment
WHERE student_no NOT IN (SELECT student_no
					   FROM student_enrollment
					   WHERE course_no ilike 'CS180');
					   
-- Return students who take CS110 or CS107 but not both
SELECT distinct student_no
FROM student_enrollment
WHERE student_no IN (SELECT student_no
						FROM student_enrollment
						WHERE course_no ilike 'CS110'
						OR course_no ilike 'CS107');

						
-- Return students who take CS220 and no other courses
SELECT student_no
FROM student_enrollment
WHERE course_no ilike 'CS220'
AND student_no NOT IN (SELECT student_no
					  FROM student_enrollment
					  WHERE course_no NOT IN('CS220'));

					  
-- Return students who take at most 2 courses, exclude 0 or more than 2
SELECT student_no
FROM (
SELECT student_no,
	count(course_no) as courses
FROM student_enrollment
GROUP BY student_no
	) a
WHERE courses != 0
AND courses <= 2;

-- Return students who are older than at most two students
SELECT s1.*
FROM students s1
WHERE 2 >= (SELECT count(*)
		   FROM students s2
		   WHERE s2.age < s1.age);