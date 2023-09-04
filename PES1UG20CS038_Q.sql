--
-- Database: `attendance`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePassword` (IN `Username` VARCHAR(20), IN `newPassword` VARCHAR(20), IN `state` VARCHAR(20))   BEGIN
if state = "Student" THEN
update login_student SET Passwd = newPassword where User_name = Username;
ELSEIF state = "Teacher" THEN
update login_teacher SET Passwd = newPassword where User_name = Username;
END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getOldest` (`Class` VARCHAR(20)) RETURNS INT(11)
DETERMINISTIC
NO SQL
BEGIN
  DECLARE age_ INT DEFAULT 0;
  DECLARE s1 CURSOR FOR SELECT Age FROM student WHERE student.Class = Class ORDER BY Age DESC;
  OPEN s1;
  FETCH NEXT FROM s1 INTO age_;
  CLOSE s1;
  RETURN age_;
END$$


CREATE DEFINER=`root`@`localhost` FUNCTION `TotalStudentsInClass` (`Class` VARCHAR(5)) RETURNS INT(11)
READS SQL DATA
BEGIN
  DECLARE count_of_students INT;
  SELECT COUNT(*) INTO count_of_students FROM student WHERE student.class = Class;
  RETURN count_of_students;
END$$


DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `User_name` varchar(20) DEFAULT NULL,
  `passwd` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`User_name`, `passwd`) VALUES
('admin', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `attended`
--

CREATE TABLE `attended` (
  `SRN` varchar(20) DEFAULT NULL,
  `doa` date DEFAULT NULL,
  `course_code` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `attended`
--

INSERT INTO `attended` (`SRN`, `doa`, `course_code`, `status`) VALUES
('022', '2022-11-18', 'CHEM101', 'P'),
('045', '2022-11-18', 'CHEM101', 'P'),
('056', '2022-11-18', 'CHEM101', 'P'),
('PES1UG20CS018', '2022-11-18', 'CHEM101', 'P'),
('PES1UG20CS035', '2022-11-18', 'CHEM101', 'P'),
('011', '2022-11-25', 'DRAW101', 'P'),
('019', '2022-11-25', 'DRAW101', 'P'),
('021', '2022-11-25', 'DRAW101', 'P'),
('803', '2022-11-25', 'DRAW101', 'P'),
('PES1UG20CS025', '2022-11-25', 'DRAW101', 'P'),
('PES1UG20CS038', '2022-11-25', 'DRAW101', 'P');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `course_name` varchar(20) DEFAULT NULL,
  `course_code` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`course_name`, `course_code`) VALUES
('Physics', 'PHY101'),
('Chemisrty', 'CHEM101'),
('Electronics', 'ECE101'),
('Engineering Drawing', 'DRAW101'),
('Mathematics', 'MATH101');

-- --------------------------------------------------------

--
-- Table structure for table `login_student`
--

CREATE TABLE `login_student` (
  `User_name` varchar(20) NOT NULL,
  `Passwd` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login_student`
--

INSERT INTO `login_student` (`User_name`, `Passwd`) VALUES
('PES1UG20CS038', 'Thor'),
('PES1UG20CS025', 'PES1UG20CS025'),
('PES1UG20CS018', 'PES1UG20CS018'),
('PES1UG20CS035', 'PES1UG20CS035'),
('011', '011'),
('016', '016'),
('019', '019'),
('056', '056'),
('803', '803'),
('022', '022'),
('021', '021'),
('045', '045');

-- --------------------------------------------------------

--
-- Table structure for table `login_teacher`
--

CREATE TABLE `login_teacher` (
  `User_name` varchar(20) NOT NULL,
  `Passwd` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login_teacher`
--

INSERT INTO `login_teacher` (`User_name`, `Passwd`) VALUES
('TRN001', 'pass'),
('TRN002', 'pass'),
('TRN003', 'pass'),
('TRN004', 'pass'),
('TRN005', 'PASS'),
('TRN006', 'pass'),
('TRN007', 'pass'),
('TRN008', 'pass'),
('TRN009', 'pass'),
('TRN010', 'pass'),
('TRN011', 'pass'),
('TRN012', 'pass'),
('TRN013', 'TRN013');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `SRN` varchar(20) NOT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `YOS` int(11) DEFAULT NULL,
  `Class` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`SRN`, `Name`, `DOB`, `Age`, `YOS`, `Class`) VALUES
('011', 'Norm', '2002-11-11', 20, 3, '5A'),
('016', 'Doof', '2002-11-12', 20, 3, '5B'),
('019', 'Phineas', '2002-01-01', 20, 3, '5A'),
('021', 'Jerry', '2002-12-21', 19, 3, '5A'),
('022', 'Buford', '2003-01-31', 20, 3, '5B'),
('045', 'Carl', '2001-01-01', 21, 3, '5B'),
('056', 'Ferb', '2001-03-01', 21, 3, '5B'),
('803', 'Saurav', '2001-04-01', 21, 3, '5A'),
('PES1UG20CS018', 'Rokhade', '2002-07-25', 20, 3, '5B'),
('PES1UG20CS025', 'Akarsh', '2001-01-01', 21, 3, '5A'),
('PES1UG20CS035', 'Amogh', '2002-08-19', 20, 3, '5B'),
('PES1UG20CS038', 'Amruth S', '2002-06-04', 20, 3, '5A');

--
-- Triggers `student`
--
DELIMITER $$
CREATE TRIGGER `CalcAge` BEFORE INSERT ON `student` FOR EACH ROW begin
SET new.Age = DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),new.DOB)), '%Y');
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `addUser` AFTER INSERT ON `student` FOR EACH ROW BEGIN
insert into login_student values (new.SRN, new.SRN);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `TRN` varchar(20) NOT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`TRN`, `Name`, `DOB`, `Age`) VALUES
('TRN001', 'Saurav', '1972-01-01', 50),
('TRN002', 'Amit', '1973-08-08', 49),
('TRN003', 'John', '1973-01-08', 49),
('TRN004', 'Don', '1969-08-11', 53),
('TRN005', 'Beckett', '1980-08-08', 42),
('TRN006', 'Strange', '1981-08-08', 41),
('TRN007', 'Rogers', '1957-08-08', 65),
('TRN008', 'Stark', '1965-09-23', 57),
('TRN009', 'Steve', '1967-08-08', 55),
('TRN010', 'Tony', '1962-08-08', 60),
('TRN011', 'Bruce', '1975-08-08', 47),
('TRN012', 'Murphy', '1999-08-08', 23),
('TRN013', 'Mark', '1992-01-01', 30);

--
-- Triggers `teacher`
--
DELIMITER $$
CREATE TRIGGER `CalcAgeforteacher` BEFORE INSERT ON `teacher` FOR EACH ROW BEGIN
	SET new.age = DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),new.DOB)), '%Y');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `addUserTeacher` AFTER INSERT ON `teacher` FOR EACH ROW BEGIN
insert into login_teacher values (new.TRN, new.TRN);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `teaches`
--

CREATE TABLE `teaches` (
  `TRN` varchar(20) DEFAULT NULL,
  `course_code` varchar(20) DEFAULT NULL,
  `class` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `teaches`
--

INSERT INTO `teaches` (`TRN`, `course_code`, `class`) VALUES
('TRN002', 'PHY101', '5A'),
('TRN003', 'PHY101', '5B'),
('TRN004', 'CHEM101', '5A'),
('TRN005', 'CHEM101', '5B'),
('TRN006', 'ECE101', '5A'),
('TRN007', 'ECE101', '5B'),
('TRN001', 'DRAW101', '5A'),
('TRN010', 'DRAW101', '5B'),
('TRN011', 'MATH101', '5A'),
('TRN012', 'MATH101', '5B'),
('TRN012', 'DRAW101', '5B');

-- --------------------------------------------------------

--
-- Table structure for table `timetable`
--

CREATE TABLE `timetable` (
  `Period_one` varchar(20) DEFAULT NULL,
  `Period_two` varchar(20) DEFAULT NULL,
  `Period_three` varchar(20) DEFAULT NULL,
  `Period_four` varchar(20) DEFAULT NULL,
  `Period_five` varchar(20) DEFAULT NULL,
  `dow` varchar(20) DEFAULT NULL,
  `class` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `timetable`
--

INSERT INTO `timetable` (`Period_one`, `Period_two`, `Period_three`, `Period_four`, `Period_five`, `dow`, `class`) VALUES
('DRAW101', 'PHY101', 'CHEM101', 'MATH101', 'ECE101', 'Monday', '5A'),
('PHY101', 'DRAW101', 'CHEM101', 'MATH101', 'ECE101', 'Tuesday', '5A'),
('CHEM101', 'PHY101', 'DRAW101', 'MATH101', 'ECE101', 'Wednesday', '5A'),
('MATH101', 'PHY101', 'DRAW101', 'CHEM101', 'ECE101', 'Thursday', '5A'),
('MATH101', 'PHY101', 'DRAW101', 'ECE101', 'CHEM101', 'Friday', '5A'),
('DRAW101', 'PHY101', 'CHEM101', 'MATH101', 'ECE101', 'Monday', '5B'),
('PHY101', 'DRAW101', 'CHEM101', 'MATH101', 'ECE101', 'Tuesday', '5B'),
('CHEM101', 'PHY101', 'DRAW101', 'MATH101', 'ECE101', 'Wednesday', '5B'),
('MATH101', 'PHY101', 'DRAW101', 'CHEM101', 'ECE101', 'Thursday', '5B'),
('MATH101', 'PHY101', 'DRAW101', 'ECE101', 'CHEM101', 'Friday', '5B');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attended`
--
ALTER TABLE `attended`
  ADD KEY `SRN` (`SRN`);

--
-- Indexes for table `login_student`
--
ALTER TABLE `login_student`
  ADD KEY `User_name` (`User_name`);

--
-- Indexes for table `login_teacher`
--
ALTER TABLE `login_teacher`
  ADD KEY `User_name` (`User_name`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`SRN`);

--
-- Indexes for table `teacher`
--
ALTER TABLE `teacher`
  ADD PRIMARY KEY (`TRN`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attended`
--
ALTER TABLE `attended`
  ADD CONSTRAINT `attended_ibfk_1` FOREIGN KEY (`SRN`) REFERENCES `student` (`SRN`);

--
-- Constraints for table `login_student`
--
ALTER TABLE `login_student`
  ADD CONSTRAINT `login_student_ibfk_1` FOREIGN KEY (`User_name`) REFERENCES `student` (`SRN`),
  ADD CONSTRAINT `login_student_ibfk_2` FOREIGN KEY (`User_name`) REFERENCES `student` (`SRN`);

--
-- Constraints for table `login_teacher`
--
ALTER TABLE `login_teacher`
  ADD CONSTRAINT `login_teacher_ibfk_1` FOREIGN KEY (`User_name`) REFERENCES `teacher` (`TRN`);
COMMIT;
