-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2023-05-08 18:21:42
-- 伺服器版本： 10.4.28-MariaDB
-- PHP 版本： 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `coursesystem`
--

-- --------------------------------------------------------

--
-- 資料表結構 `classroom`
--

CREATE TABLE `classroom` (
  `Section_id` varchar(255) NOT NULL,
  `Building` varchar(255) NOT NULL,
  `Room_num` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `course`
--

CREATE TABLE `course` (
  `Course_id` varchar(255) NOT NULL,
  `Course_name` varchar(255) NOT NULL,
  `Credits` int(11) NOT NULL,
  `Type` varchar(255) NOT NULL,
  `Department_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `course`
--

INSERT INTO `course` (`Course_id`, `Course_name`, `Credits`, `Type`, `Department_name`) VALUES
('IECS203', 'System programming', 3, 'Required', 'IECS'),
('IECS206', 'Unix applications and practices', 15, 'Elective', 'IECS'),
('IECS211', 'Information system analysis & design', 3, 'Elective', 'IECS'),
('IECS214', 'Digital system design lab', 3, 'Elective', 'IECS'),
('IECS225', 'Probability and statistics', 3, 'Required', 'IECS'),
('IECS226', 'E-commerce security', 3, 'Elective', 'IECS'),
('IECS227', 'Multi-media system', 3, 'Elective', 'IECS'),
('IECS241', 'Interconnected networks', 3, 'Elective', 'IECS'),
('IECS253', 'Digital system design', 9, 'Elective', 'IECS'),
('IECS272', 'Web programming', 3, 'Elective', 'IECS'),
('IECS322', 'Database system', 1, 'Required', 'IECS'),
('IECS353', 'Combinational mathematics', 3, 'Elective', 'IECS');

-- --------------------------------------------------------

--
-- 資料表結構 `department`
--

CREATE TABLE `department` (
  `Department_name` varchar(255) NOT NULL,
  `Building` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `department`
--

INSERT INTO `department` (`Department_name`, `Building`) VALUES
('IECS', 'IEB'),
('IECS', 'IEB');

-- --------------------------------------------------------

--
-- 資料表結構 `instructor`
--

CREATE TABLE `instructor` (
  `Instructor_id` varchar(255) NOT NULL,
  `Instructor_name` varchar(255) NOT NULL,
  `Department_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `instructor`
--

INSERT INTO `instructor` (`Instructor_id`, `Instructor_name`, `Department_name`) VALUES
('001', 'A', 'IECS'),
('002', 'B', 'IECS'),
('003', 'C', 'IECS'),
('004', 'D', 'IECS'),
('005', 'E', 'IECS'),
('006', 'F', 'IECS'),
('007', 'G', 'IECS'),
('008', 'H', 'IECS');

-- --------------------------------------------------------

--
-- 資料表結構 `section`
--

CREATE TABLE `section` (
  `Section_id` varchar(255) NOT NULL,
  `Section_name` varchar(255) NOT NULL,
  `Semester` varchar(255) NOT NULL,
  `Year` int(11) NOT NULL,
  `Course_id` varchar(255) NOT NULL,
  `Max_quota` int(11) NOT NULL,
  `Cur_studentnum` int(11) NOT NULL,
  `Instructor_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `section`
--

INSERT INTO `section` (`Section_id`, `Section_name`, `Semester`, `Year`, `Course_id`, `Max_quota`, `Cur_studentnum`, `Instructor_id`) VALUES
('1260', 'System programming', 'Second semester', 2, 'IECS203', 70, 3, '001'),
('1261', 'Database system', 'Second semester', 2, 'IECS322', 71, 3, '002'),
('1262', 'Probability and statistics', 'Second semester', 2, 'IECS225', 70, 3, '003'),
('1263', 'Interconnected networks', 'Second semester', 2, 'IECS241', 72, 0, '008'),
('1267', 'Digital system design', 'Second semester', 2, 'IECS253', 60, 1, '004'),
('1268', 'Digital system design lab', 'Second semester', 2, 'IECS214', 60, 0, '005'),
('1269', 'Unix applications and practices', 'Second semester', 2, 'IECS206', 73, 1, '006'),
('3547', 'Unix applications and practices', 'Second semester', 2, 'IECS206', 72, 1, '007');

-- --------------------------------------------------------

--
-- 資料表結構 `selectdetail`
--

CREATE TABLE `selectdetail` (
  `Student_id` varchar(255) NOT NULL,
  `Section_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `selectdetail`
--

INSERT INTO `selectdetail` (`Student_id`, `Section_id`) VALUES
('D1060300', '1260'),
('D1060300', '1261'),
('D1060300', '1262'),
('D1060300', '1269'),
('D1060417', '1260'),
('D1060417', '1261'),
('D1060417', '1262'),
('D1060417', '1267'),
('D1090398', '1260'),
('D1090398', '1261'),
('D1090398', '1262'),
('D1093098', '3547');

-- --------------------------------------------------------

--
-- 資料表結構 `student`
--

CREATE TABLE `student` (
  `Student_id` varchar(255) NOT NULL,
  `Student_name` varchar(255) DEFAULT NULL,
  `Grade` int(11) NOT NULL,
  `Class_id` varchar(255) NOT NULL,
  `Total_credits` int(11) NOT NULL DEFAULT 0,
  `Department_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `student`
--

INSERT INTO `student` (`Student_id`, `Student_name`, `Grade`, `Class_id`, `Total_credits`, `Department_name`) VALUES
('D1060300', 'Sing-Yu Chen', 2, 'D', 22, 'IECS'),
('D1060417', 'Zong-You Li', 2, 'D', 16, 'IECS'),
('D1093098', 'Yi-Shuo Chen', 2, 'D', 15, 'IECS');

-- --------------------------------------------------------

--
-- 資料表結構 `time`
--

CREATE TABLE `time` (
  `Section_id` varchar(255) NOT NULL,
  `Day` varchar(255) NOT NULL,
  `Time_type` int(11) NOT NULL,
  `Start_time` varchar(255) NOT NULL,
  `End_time` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `time`
--

INSERT INTO `time` (`Section_id`, `Day`, `Time_type`, `Start_time`, `End_time`) VALUES
('1260', '(Mon)03-04(Thu)04', 1, '', ''),
('1261', '(Mon)06(Tue)03-04', 2, '', ''),
('1262', '(Mon)07(Thu)07-08', 3, '', ''),
('1263', '(Mon)02-03(fri)04', 1, '', ''),
('1267', '(Tue)06-07(Wed)02', 4, '', ''),
('1268', '(Wed)03-04', 5, '', ''),
('1269', '(Wed)09-10', 6, '', ''),
('3547', '(Thu)09-10', 7, '', '');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `classroom`
--
ALTER TABLE `classroom`
  ADD PRIMARY KEY (`Section_id`);

--
-- 資料表索引 `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`Course_id`);

--
-- 資料表索引 `instructor`
--
ALTER TABLE `instructor`
  ADD PRIMARY KEY (`Instructor_id`);

--
-- 資料表索引 `section`
--
ALTER TABLE `section`
  ADD PRIMARY KEY (`Section_id`);

--
-- 資料表索引 `selectdetail`
--
ALTER TABLE `selectdetail`
  ADD UNIQUE KEY `Student_id` (`Student_id`,`Section_id`);

--
-- 資料表索引 `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`Student_id`);

--
-- 資料表索引 `time`
--
ALTER TABLE `time`
  ADD PRIMARY KEY (`Section_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
