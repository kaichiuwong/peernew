-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Dec 16, 2019 at 01:02 PM
-- Server version: 5.5.39
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `pas`
--
CREATE DATABASE IF NOT EXISTS `pas` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `pas`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `sp_get_question_feedback`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_question_feedback`(IN `asg_id` INT, IN `reviewer` VARCHAR(20), IN `reviewee` VARCHAR(20), IN `qtype` ENUM('SELF','PEER','GROUP'))
BEGIN
    SELECT aq.id as qid, aq.question_order, aq.question, aq.answer_type, aq.question_section, af.*
      FROM assignment_question aq
      LEFT JOIN assignment_feedback af ON aq.asg_id=af.asg_id and aq.id=af.question_id and af.reviewer=reviewer and af.reviewee=reviewee
     WHERE aq.asg_id = asg_id and aq.question_section=qtype ;
END$$

DROP PROCEDURE IF EXISTS `sp_get_student_assignment_list`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_student_assignment_list`(
    IN username VARCHAR(10)
)
BEGIN
    SELECT a.*,fn_get_unit_code(a.unit_id) as unit
    FROM   assignment a, unit_enrol ue
    WHERE  a.unit_id = ue.unit_id
    AND    ue.user_id = username ;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `fn_get_unit_code`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_get_unit_code`(
    unit_id INT
) RETURNS varchar(20) CHARSET utf8
    DETERMINISTIC
BEGIN
 DECLARE rtnstr VARCHAR(20);
 
  SELECT unit_code 
  INTO   rtnstr
  FROM   unit
  WHERE  id=unit_id;
  
  RETURN rtnstr ;
END$$

DROP FUNCTION IF EXISTS `fn_is_allow_view_assignment`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_is_allow_view_assignment`(
    username VARCHAR(10),
    asg_id   INT
) RETURNS int(11)
    DETERMINISTIC
BEGIN
 DECLARE rtn_result INT DEFAULT 0;
  
  SELECT count(1)
  INTO   rtn_result
  FROM   assignment a, unit_enrol ue
  WHERE  a.unit_id = ue.unit_id
  AND    ue.user_id = username
  AND    a.id = asg_id  ;
  
  RETURN rtn_result ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment`
--

DROP TABLE IF EXISTS `assignment`;
CREATE TABLE IF NOT EXISTS `assignment` (
`id` int(11) NOT NULL,
  `title` varchar(500) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0 - Indiv, 1 - Group',
  `outcome` mediumtext,
  `scenario` mediumtext,
  `unit_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `assignment`
--

INSERT INTO `assignment` (`id`, `title`, `type`, `outcome`, `scenario`, `unit_id`, `create_time`, `last_upd_time`) VALUES
(1, 'Assignment 1', 1, '<p>Write an essay</p><p>''"''"'''''''''';'';'';'';''''&nbsp;</p>', 'An essay about security', 1, '2019-11-17 22:44:34', '2019-12-10 23:47:08'),
(11, 'Group Assignment', 1, '<p>You <strike>should </strike>be <sup>careful </sup>for <span style="font-size: 24px;"><b>the </b></span><a href="http://www.google.com" target="_blank"><b>following </b></a><sub>matrix</sub></p><table class="table table-bordered"><tbody><tr><td>11</td><td>12</td><td>13</td></tr><tr><td>21</td><td>22</td><td>23</td></tr><tr><td>31</td><td>32</td><td>33</td></tr><tr><td>41</td><td>42</td><td>43</td></tr></tbody></table><p><br></p>', '<h3><b><u><span style="font-family: " times="" new="" roman";"="">Nothing happens <span style="font-size: 36px;">here</span></span></u></b></h3>', 7, '2019-12-07 21:30:49', '2019-12-10 23:11:18'),
(12, 'Design Requirement', 1, '<p><span style="background-color: rgb(255, 255, 0);">This </span>is a <b>test</b></p><p><b><br></b></p><p><b>''";!!''"''''''</b></p>', '<h6><u>This </u>is <b>another </b>test</h6>', 9, '2019-12-08 00:18:03', '2019-12-10 23:46:24'),
(13, 'Design Documentation', 1, '<p>You should be careful for the <a href="http://www.google.com" target="_blank"><b>following </b></a>matrix</p><table class="table table-bordered"><tbody><tr><td>11</td><td>12</td><td>13</td></tr><tr><td>21</td><td>22</td><td>23</td></tr><tr><td>31</td><td>32</td><td>33</td></tr><tr><td>41</td><td>42</td><td>43</td></tr></tbody></table><p><br></p>', '<h3><b><u><span style="font-family: &quot;Times New Roman&quot;;">Nothing happens here</span></u></b></h3>', 9, '2019-12-08 21:36:48', '2019-12-10 22:48:25');

-- --------------------------------------------------------

--
-- Table structure for table `assignment_deadline`
--

DROP TABLE IF EXISTS `assignment_deadline`;
CREATE TABLE IF NOT EXISTS `assignment_deadline` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `deadline_desc` varchar(500) DEFAULT NULL,
  `deadline_time` datetime NOT NULL,
  `last_upd_by` varchar(50) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_feedback`
--

DROP TABLE IF EXISTS `assignment_feedback`;
CREATE TABLE IF NOT EXISTS `assignment_feedback` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `reviewer` varchar(20) CHARACTER SET utf8 NOT NULL,
  `reviewee` varchar(20) CHARACTER SET utf8 NOT NULL,
  `feedback` text CHARACTER SET utf8,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=99 ;

--
-- Dumping data for table `assignment_feedback`
--

INSERT INTO `assignment_feedback` (`id`, `asg_id`, `question_id`, `reviewer`, `reviewee`, `feedback`, `create_time`, `last_upd_time`) VALUES
(1, 11, 11, 'user1', 'user1', '5', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(2, 11, 12, 'user1', 'user1', '9 hours maybe', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(3, 11, 13, 'user1', 'user1', '1000 hours... haha', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(4, 11, 14, 'user1', 'user1', '<script>alert("hello");</script>', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(5, 11, 15, 'user1', 'user1', 'Programming', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(6, 11, 16, 'user1', 'user1', 'Hello world', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(7, 11, 17, 'user1', 'user1', 'I don''t know', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(8, 11, 18, 'user1', 'user1', 'No plan at all', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(9, 11, 19, 'user1', 'user1', 'I want to have a holiday', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(10, 11, 20, 'user1', 'user1', 'No management', '2019-12-15 23:39:00', '2019-12-16 21:57:32'),
(11, 11, 26, 'user1', 'user2', '0', '2019-12-16 01:09:21', '2019-12-16 21:57:37'),
(12, 11, 27, 'user1', 'user2', '0', '2019-12-16 01:09:21', '2019-12-16 21:57:37'),
(13, 11, 28, 'user1', 'user2', '0', '2019-12-16 01:09:21', '2019-12-16 21:57:37'),
(14, 11, 29, 'user1', 'user2', '0', '2019-12-16 01:09:21', '2019-12-16 21:57:37'),
(15, 11, 31, 'user1', 'user2', '0', '2019-12-16 01:09:21', '2019-12-16 21:57:37'),
(16, 11, 30, 'user1', 'user2', '0', '2019-12-16 01:16:40', '2019-12-16 21:57:37'),
(21, 11, 32, 'user1', 'user2', '0', '2019-12-16 01:29:16', '2019-12-16 21:57:37'),
(22, 11, 33, 'user1', 'user2', '0', '2019-12-16 01:29:27', '2019-12-16 21:57:37'),
(23, 11, 35, 'user1', 'user2', '0', '2019-12-16 01:38:34', '2019-12-16 21:57:37'),
(24, 11, 34, 'user1', 'user2', '0', '2019-12-16 01:38:45', '2019-12-16 21:57:37'),
(25, 11, 26, 'user1', 'user3', '3', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(26, 11, 27, 'user1', 'user3', '4', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(27, 11, 28, 'user1', 'user3', '4', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(28, 11, 29, 'user1', 'user3', '4', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(29, 11, 30, 'user1', 'user3', '1', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(30, 11, 31, 'user1', 'user3', '2', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(31, 11, 32, 'user1', 'user3', '3', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(32, 11, 33, 'user1', 'user3', '3', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(33, 11, 34, 'user1', 'user3', '0', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(34, 11, 35, 'user1', 'user3', '4', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(35, 11, 36, 'user1', 'user2', 'Free Rider, i don''t give him a mark.', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(36, 11, 36, 'user1', 'user3', 'Nice teammate', '2019-12-16 02:08:54', '2019-12-16 21:57:37'),
(37, 11, 26, 'user2', 'user1', '3', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(38, 11, 26, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(39, 11, 27, 'user2', 'user1', '3', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(40, 11, 27, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(41, 11, 28, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(42, 11, 28, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(43, 11, 29, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(44, 11, 29, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(45, 11, 30, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(46, 11, 30, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(47, 11, 31, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(48, 11, 31, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(49, 11, 32, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(50, 11, 32, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(51, 11, 33, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(52, 11, 33, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(53, 11, 34, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(54, 11, 34, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(55, 11, 35, 'user2', 'user1', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(56, 11, 35, 'user2', 'user3', '4', '2019-12-16 02:30:08', '2019-12-16 02:30:08'),
(57, 11, 11, 'user2', 'user2', '0', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(58, 11, 12, 'user2', 'user2', '0', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(59, 11, 13, 'user2', 'user2', '0', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(60, 11, 14, 'user2', 'user2', '0', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(61, 11, 15, 'user2', 'user2', 'No', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(62, 11, 16, 'user2', 'user2', 'No', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(63, 11, 17, 'user2', 'user2', 'No', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(64, 11, 18, 'user2', 'user2', 'No', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(65, 11, 19, 'user2', 'user2', 'No', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(66, 11, 20, 'user2', 'user2', 'Not at all.', '2019-12-16 02:30:41', '2019-12-16 02:30:41'),
(67, 11, 11, 'user3', 'user3', '5', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(68, 11, 12, 'user3', 'user3', '4 hours maybe', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(69, 11, 13, 'user3', 'user3', '10 hours', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(70, 11, 14, 'user3', 'user3', '12', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(71, 11, 15, 'user3', 'user3', 'Never', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(72, 11, 16, 'user3', 'user3', 'Always', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(73, 11, 17, 'user3', 'user3', 'I am not sure', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(74, 11, 18, 'user3', 'user3', 'no plan at all', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(75, 11, 19, 'user3', 'user3', 'no improvement', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(76, 11, 20, 'user3', 'user3', 'no plans', '2019-12-16 02:32:52', '2019-12-16 02:34:59'),
(77, 11, 26, 'user3', 'user1', '4', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(78, 11, 26, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(79, 11, 27, 'user3', 'user1', '4', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(80, 11, 27, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(81, 11, 28, 'user3', 'user1', '4', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(82, 11, 28, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(83, 11, 29, 'user3', 'user1', '4', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(84, 11, 29, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(85, 11, 30, 'user3', 'user1', '3', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(86, 11, 30, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(87, 11, 31, 'user3', 'user1', '4', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(88, 11, 31, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(89, 11, 32, 'user3', 'user1', '3', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(90, 11, 32, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(91, 11, 33, 'user3', 'user1', '3', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(92, 11, 33, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(93, 11, 34, 'user3', 'user1', '3', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(94, 11, 34, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(95, 11, 35, 'user3', 'user1', '3', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(96, 11, 35, 'user3', 'user2', '0', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(97, 11, 36, 'user3', 'user1', 'Good teammate', '2019-12-16 02:34:31', '2019-12-16 02:34:58'),
(98, 11, 36, 'user3', 'user2', 'He don''t participated at any activities.', '2019-12-16 02:34:31', '2019-12-16 02:34:58');

-- --------------------------------------------------------

--
-- Table structure for table `assignment_mark_criteria`
--

DROP TABLE IF EXISTS `assignment_mark_criteria`;
CREATE TABLE IF NOT EXISTS `assignment_mark_criteria` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0 - Assignment, 1- feedback',
  `topic` mediumtext,
  `hd` mediumtext,
  `dn` mediumtext,
  `cr` mediumtext,
  `pp` mediumtext,
  `nn` mediumtext,
  `create_date` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `assignment_mark_criteria`
--

INSERT INTO `assignment_mark_criteria` (`id`, `asg_id`, `weight`, `type`, `topic`, `hd`, `dn`, `cr`, `pp`, `nn`, `create_date`, `last_upd_time`) VALUES
(11, 1, 50, 0, 'Design', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed vulputate odio ut enim blandit volutpat maecenas. Tristique risus nec feugiat in fermentum posuere urna. Non consectetur a erat nam at. Arcu cursus euismod quis viverra nibh cras pulvinar mattis. Gravida quis blandit turpis cursus. Vitae tempus quam pellentesque nec nam. Molestie a iaculis at erat pellentesque adipiscing commodo elit at. Vitae ultricies leo integer malesuada nunc. Amet consectetur adipiscing elit ut aliquam purus sit amet luctus. Accumsan in nisl nisi scelerisque eu ultrices vitae auctor eu. Eu mi bibendum neque egestas congue quisque egestas diam in. Ipsum suspendisse ultrices gravida dictum fusce ut placerat. Tellus elementum sagittis vitae et leo duis ut.', 'Proin sed libero enim sed faucibus turpis. Sagittis orci a scelerisque purus semper eget duis. Ac placerat vestibulum lectus mauris ultrices eros in cursus. Faucibus ornare suspendisse sed nisi lacus. Imperdiet nulla malesuada pellentesque elit eget. Vulputate enim nulla aliquet porttitor lacus luctus accumsan tortor posuere. Vel risus commodo viverra maecenas accumsan. Montes nascetur ridiculus mus mauris vitae ultricies leo. Faucibus nisl tincidunt eget nullam non nisi est sit. Volutpat diam ut venenatis tellus in. Ut tristique et egestas quis ipsum suspendisse ultrices. Tincidunt id aliquet risus feugiat in.', 'Id venenatis a condimentum vitae. Massa tempor nec feugiat nisl pretium fusce id velit. Elit ut aliquam purus sit amet luctus. Purus in massa tempor nec feugiat nisl pretium fusce id. Sed risus pretium quam vulputate dignissim suspendisse in. Neque ornare aenean euismod elementum nisi quis eleifend quam. Tellus id interdum velit laoreet. Enim sit amet venenatis urna cursus. Enim blandit volutpat maecenas volutpat blandit aliquam etiam erat. Elit scelerisque mauris pellentesque pulvinar pellentesque habitant. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing vitae. Dui vivamus arcu felis bibendum ut tristique et egestas quis. Nisi est sit amet facilisis magna. Quis hendrerit dolor magna eget est lorem. Velit sed ullamcorper morbi tincidunt.', 'Est placerat in egestas erat imperdiet sed euismod. Pretium fusce id velit ut tortor. Facilisi etiam dignissim diam quis enim lobortis. Imperdiet massa tincidunt nunc pulvinar sapien et ligula ullamcorper malesuada. Et ultrices neque ornare aenean euismod elementum nisi. Lectus nulla at volutpat diam ut venenatis tellus in metus. Enim ut tellus elementum sagittis vitae. Eu scelerisque felis imperdiet proin fermentum leo. Lacus sed turpis tincidunt id aliquet risus feugiat in. Odio morbi quis commodo odio aenean. Sollicitudin nibh sit amet commodo nulla facilisi nullam. Elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus at augue. Nec dui nunc mattis enim ut. Vel orci porta non pulvinar neque laoreet suspendisse interdum consectetur. Egestas congue quisque egestas diam in arcu cursus.', 'Est sit amet facilisis magna. Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. Tellus in metus vulputate eu scelerisque felis imperdiet proin. Quis viverra nibh cras pulvinar mattis. Amet mauris commodo quis imperdiet massa tincidunt nunc. Non tellus orci ac auctor augue mauris augue neque gravida. Nunc scelerisque viverra mauris in aliquam. Nunc vel risus commodo viverra maecenas accumsan. Purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae. Nunc mattis enim ut tellus elementum sagittis vitae et. Facilisi morbi tempus iaculis urna. Rhoncus dolor purus non enim praesent elementum. Fermentum iaculis eu non diam phasellus vestibulum. In fermentum posuere urna nec tincidunt praesent semper feugiat. Mauris pharetra et ultrices neque. Ipsum nunc aliquet bibendum enim facilisis gravida neque convallis.', '2019-12-05 01:20:09', '2019-12-05 01:20:09'),
(12, 1, 30, 0, 'Presentation', 'Adipiscing bibendum est ultricies integer quis auctor elit sed vulputate. Habitant morbi tristique senectus et netus et malesuada fames. Quam quisque id diam vel quam elementum pulvinar etiam. Ut tristique et egestas quis ipsum. Lorem ipsum dolor sit amet consectetur adipiscing elit ut. Consectetur purus ut faucibus pulvinar. Sapien nec sagittis aliquam malesuada bibendum arcu vitae. Phasellus egestas tellus rutrum tellus. A condimentum vitae sapien pellentesque habitant. Ipsum dolor sit amet consectetur adipiscing elit duis. Facilisis volutpat est velit egestas dui. Auctor eu augue ut lectus arcu bibendum at varius vel. Nullam vehicula ipsum a arcu cursus. Mauris sit amet massa vitae tortor condimentum lacinia. Lorem mollis aliquam ut porttitor leo a diam. Tortor condimentum lacinia quis vel.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Iaculis at erat pellentesque adipiscing commodo. Convallis posuere morbi leo urna molestie at. A diam maecenas sed enim ut sem viverra aliquet. Cras ornare arcu dui vivamus arcu felis bibendum ut tristique. Ac turpis egestas integer eget aliquet nibh praesent tristique magna. Ultricies mi eget mauris pharetra et. Facilisis leo vel fringilla est ullamcorper eget nulla facilisi etiam. Sagittis id consectetur purus ut faucibus pulvinar elementum. Sit amet mauris commodo quis imperdiet massa tincidunt nunc. Sed risus pretium quam vulputate dignissim suspendisse. Facilisis gravida neque convallis a cras semper. Amet consectetur adipiscing elit pellentesque habitant morbi tristique. Ac ut consequat semper viverra nam libero justo. Vitae congue eu consequat ac felis donec et odio. Porttitor rhoncus dolor purus non enim praesent elementum.', 'Lacus luctus accumsan tortor posuere ac. Leo integer malesuada nunc vel risus commodo viverra maecenas accumsan. Enim neque volutpat ac tincidunt vitae semper quis lectus. Vulputate ut pharetra sit amet aliquam id diam maecenas ultricies. Tristique senectus et netus et malesuada fames ac turpis. Suscipit adipiscing bibendum est ultricies integer quis auctor elit sed. Habitant morbi tristique senectus et. Leo in vitae turpis massa sed elementum tempus egestas. Sed adipiscing diam donec adipiscing tristique risus. Tellus in hac habitasse platea. Pharetra magna ac placerat vestibulum. Praesent semper feugiat nibh sed pulvinar proin gravida. Ullamcorper eget nulla facilisi etiam. Malesuada bibendum arcu vitae elementum curabitur vitae. Tincidunt nunc pulvinar sapien et ligula. Mauris augue neque gravida in fermentum et. Lorem ipsum dolor sit amet.', 'Morbi leo urna molestie at elementum eu facilisis sed. Semper viverra nam libero justo. Massa tincidunt nunc pulvinar sapien et ligula ullamcorper malesuada proin. Est placerat in egestas erat imperdiet sed. Semper quis lectus nulla at. Mauris vitae ultricies leo integer malesuada nunc. Tellus rutrum tellus pellentesque eu tincidunt. Vitae elementum curabitur vitae nunc sed velit dignissim sodales ut. Dis parturient montes nascetur ridiculus mus mauris. Ut ornare lectus sit amet est placerat in.', 'Enim nunc faucibus a pellentesque sit. In est ante in nibh mauris. Est placerat in egestas erat imperdiet sed. Facilisis magna etiam tempor orci eu. Nam aliquam sem et tortor consequat id porta nibh venenatis. Viverra tellus in hac habitasse platea. Egestas fringilla phasellus faucibus scelerisque. Libero justo laoreet sit amet cursus sit amet. Mi eget mauris pharetra et ultrices neque ornare. Neque gravida in fermentum et sollicitudin ac orci phasellus egestas. Ut porttitor leo a diam sollicitudin. Turpis egestas pretium aenean pharetra magna. Neque egestas congue quisque egestas diam in arcu. Augue ut lectus arcu bibendum at varius. Ridiculus mus mauris vitae ultricies.', '2019-12-05 01:21:02', '2019-12-05 01:21:02'),
(13, 1, 100, 1, 'Quality Feedback', 'Vitae semper quis lectus nulla at. Aliquet bibendum enim facilisis gravida neque. Amet consectetur adipiscing elit duis tristique sollicitudin nibh. Sociis natoque penatibus et magnis dis. Tempor orci eu lobortis elementum nibh tellus molestie nunc non. Penatibus et magnis dis parturient montes nascetur ridiculus. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. Id venenatis a condimentum vitae sapien pellentesque habitant morbi tristique. Ipsum faucibus vitae aliquet nec. Lacus suspendisse faucibus interdum posuere lorem ipsum dolor sit. A condimentum vitae sapien pellentesque habitant. Mi sit amet mauris commodo. Gravida arcu ac tortor dignissim convallis aenean. Pellentesque elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus at. Turpis egestas pretium aenean pharetra magna ac. A cras semper auctor neque vitae tempus quam. Imperdiet sed euismod nisi porta lorem mollis aliquam. Quisque egestas diam in arcu cursus euismod quis viverra. Tortor at auctor urna nunc id cursus metus aliquam.', 'In est ante in nibh mauris cursus mattis molestie a. Posuere lorem ipsum dolor sit. In hac habitasse platea dictumst vestibulum. Arcu risus quis varius quam. Mauris ultrices eros in cursus turpis massa tincidunt dui ut. Mauris cursus mattis molestie a iaculis at erat pellentesque adipiscing. A arcu cursus vitae congue. Lobortis scelerisque fermentum dui faucibus in ornare. In iaculis nunc sed augue lacus viverra. At lectus urna duis convallis convallis tellus. Maecenas ultricies mi eget mauris pharetra et ultrices neque. Tortor aliquam nulla facilisi cras fermentum odio eu. Ut aliquam purus sit amet luctus. Blandit libero volutpat sed cras ornare arcu. Aliquet porttitor lacus luctus accumsan tortor. Ultrices in iaculis nunc sed augue. Eget arcu dictum varius duis at. Augue ut lectus arcu bibendum at varius vel. Ultrices vitae auctor eu augue ut lectus arcu.', 'Magna fringilla urna porttitor rhoncus dolor purus non enim praesent. Quis ipsum suspendisse ultrices gravida dictum fusce ut placerat orci. Eget arcu dictum varius duis at consectetur lorem. Adipiscing commodo elit at imperdiet. Neque egestas congue quisque egestas diam in arcu cursus. Massa enim nec dui nunc mattis enim ut. Pellentesque adipiscing commodo elit at imperdiet. Netus et malesuada fames ac. Blandit cursus risus at ultrices mi tempus imperdiet. Faucibus vitae aliquet nec ullamcorper. Varius quam quisque id diam vel quam. Quam id leo in vitae turpis massa sed elementum.', 'Mattis pellentesque id nibh tortor. Quisque sagittis purus sit amet volutpat consequat mauris. Dapibus ultrices in iaculis nunc sed augue lacus viverra vitae. In mollis nunc sed id semper risus in hendrerit. Imperdiet massa tincidunt nunc pulvinar sapien et ligula ullamcorper. Mattis pellentesque id nibh tortor id aliquet lectus proin nibh. Netus et malesuada fames ac turpis egestas maecenas. Tempus imperdiet nulla malesuada pellentesque elit eget gravida cum. Risus sed vulputate odio ut enim blandit. Nullam non nisi est sit amet facilisis magna etiam. Purus semper eget duis at tellus. Et netus et malesuada fames ac turpis. Facilisis mauris sit amet massa vitae. Ut pharetra sit amet aliquam id diam maecenas ultricies mi. Porta lorem mollis aliquam ut porttitor. Massa vitae tortor condimentum lacinia quis vel eros. Ullamcorper sit amet risus nullam eget.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Platea dictumst quisque sagittis purus sit amet volutpat consequat mauris. Quis enim lobortis scelerisque fermentum dui faucibus in ornare. Ipsum a arcu cursus vitae. Aliquam ultrices sagittis orci a scelerisque purus semper eget. Elementum facilisis leo vel fringilla est ullamcorper. At imperdiet dui accumsan sit amet nulla facilisi morbi tempus. Ut consequat semper viverra nam libero justo. Semper feugiat nibh sed pulvinar proin. Porttitor massa id neque aliquam vestibulum morbi blandit. Magna ac placerat vestibulum lectus mauris ultrices eros. Morbi tincidunt ornare massa eget egestas purus viverra. Adipiscing bibendum est ultricies integer quis auctor. Facilisis mauris sit amet massa vitae tortor condimentum lacinia.', '2019-12-05 01:24:13', '2019-12-05 01:24:13');

-- --------------------------------------------------------

--
-- Table structure for table `assignment_question`
--

DROP TABLE IF EXISTS `assignment_question`;
CREATE TABLE IF NOT EXISTS `assignment_question` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `question_order` int(11) NOT NULL DEFAULT '0',
  `question` mediumtext,
  `answer_type` enum('TEXT','SCALE','SCORE','GRADE') NOT NULL DEFAULT 'TEXT',
  `question_section` enum('SELF','PEER','GROUP') NOT NULL DEFAULT 'SELF',
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=37 ;

--
-- Dumping data for table `assignment_question`
--

INSERT INTO `assignment_question` (`id`, `asg_id`, `question_order`, `question`, `answer_type`, `question_section`, `create_time`, `last_upd_time`) VALUES
(1, 12, 1, 'How much time did you spend on the User Mapping assignment tasks? (hours)', 'TEXT', 'SELF', '2019-12-08 22:00:48', '2019-12-08 22:00:48'),
(2, 12, 2, 'How much time did you spend on the Technical Development tasks? (hours)', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(3, 12, 3, 'How much time did you spend on the Testing tasks? (hours)', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(4, 12, 4, 'How much time did you spend on the Documentation tasks? (hours)', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(5, 12, 5, 'What tasks did you TAKE A LEADING ROLE ON that contributed to the completion of the assignment task? (Please fully describe your contribution)', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(6, 12, 6, 'What other tasks did you CONTRIBUTE to that helped towards the completion of the assignment task? (Please fully describe your contribution to each task) ', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(7, 12, 7, 'Refer to your goals for improvement as described in your last self-review.  Describe the activities you have undertaken to improve in this area.', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(8, 12, 8, 'What are your plans for project-related self-improvement during the next agile phase?  Describe the activities you will undertake to improve in this area.', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(9, 12, 9, 'Refer to your goals for improvement as described in your last self-review.  Describe the activities you have undertaken to improve in this area.', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(10, 12, 10, 'What are your plans for project-related self-improvement during the next agile phase?  Describe the activities you will undertake to improve in this area.', 'TEXT', 'SELF', '2019-12-08 22:09:29', '2019-12-08 22:09:29'),
(11, 11, 1, 'How much time did you spend on the User Mapping assignment tasks? (hours)', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(12, 11, 2, 'How much time did you spend on the Technical Development tasks? (hours)', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(13, 11, 3, 'How much time did you spend on the Testing tasks? (hours)', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(14, 11, 4, 'How much time did you spend on the Documentation tasks? (hours)', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(15, 11, 5, 'What tasks did you TAKE A LEADING ROLE ON that contributed to the completion of the assignment task? (Please fully describe your contribution)', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(16, 11, 6, 'What other tasks did you CONTRIBUTE to that helped towards the completion of the assignment task? (Please fully describe your contribution to each task) ', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(17, 11, 7, 'Refer to your goals for improvement as described in your last self-review.  Describe the activities you have undertaken to improve in this area.', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(18, 11, 8, 'What are your plans for project-related self-improvement during the next agile phase?  Describe the activities you will undertake to improve in this area.', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(19, 11, 9, 'Refer to your goals for improvement as described in your last self-review.  Describe the activities you have undertaken to improve in this area.', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(20, 11, 10, 'What are your plans for project-related self-improvement during the next agile phase?  Describe the activities you will undertake to improve in this area.', 'TEXT', 'SELF', '2019-12-13 16:25:13', '2019-12-13 16:25:13'),
(26, 11, 1, 'Attended scheduled meetings', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:36:38'),
(27, 11, 2, 'Arrived on time, ready to work', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:36:51'),
(28, 11, 3, 'Contributed at the meetings', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:37:01'),
(29, 11, 4, 'Initiated ideas', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:37:10'),
(30, 11, 5, 'Carried his/her share of the workload', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:37:20'),
(31, 11, 6, 'Timeliness of work products (met deadlines)', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:37:30'),
(32, 11, 7, 'Positive working attitude', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:37:40'),
(33, 11, 8, 'Organised', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:37:50'),
(34, 11, 9, 'Prepared and helped make decisions', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:38:01'),
(35, 11, 10, 'Submitting  individual contributions of sufficient quality to be used by the team', 'SCALE', 'PEER', '2019-12-13 16:27:52', '2019-12-13 16:38:12'),
(36, 11, 11, 'Justification', 'TEXT', 'PEER', '2019-12-14 01:09:15', '2019-12-14 01:09:15');

-- --------------------------------------------------------

--
-- Table structure for table `assignment_topic`
--

DROP TABLE IF EXISTS `assignment_topic`;
CREATE TABLE IF NOT EXISTS `assignment_topic` (
`id` int(11) NOT NULL,
  `assign_id` int(11) NOT NULL,
  `topic` varchar(500) DEFAULT NULL,
  `topic_desc` mediumtext,
  `max` int(11) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=664 ;

--
-- Dumping data for table `assignment_topic`
--

INSERT INTO `assignment_topic` (`id`, `assign_id`, `topic`, `topic_desc`, `max`, `create_time`, `last_upd_time`) VALUES
(1, 1, 'PGP', 'Hello world', 90, '2019-11-18 00:00:00', '2019-11-18 00:00:00'),
(2, 1, 'Blockchain', 'Another Topic', 90, '2019-11-18 02:45:38', '2019-11-18 02:45:38'),
(5, 1, '2FA Authentication', 'This is a test <span>hello</span>', 1, '2019-11-18 17:33:27', '2019-11-18 17:33:27'),
(73, 11, 'Group 002', 'Group 002', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(74, 11, 'Group 003', 'Group 003', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(75, 11, 'Group 004', 'Group 004', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(76, 11, 'Group 005', 'Group 005', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(77, 11, 'Group 006', 'Group 006', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(78, 11, 'Group 007', 'Group 007', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(79, 11, 'Group 008', 'Group 008', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(80, 11, 'Group 009', 'Group 009', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(81, 11, 'Group 010', 'Group 010', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(82, 11, 'Group 011', 'Group 011', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(83, 11, 'Group 012', 'Group 012', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(84, 11, 'Group 013', 'Group 013', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(85, 11, 'Group 014', 'Group 014', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(86, 11, 'Group 015', 'Group 015', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(87, 11, 'Group 016', 'Group 016', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(88, 11, 'Group 017', 'Group 017', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(89, 11, 'Group 018', 'Group 018', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(90, 11, 'Group 019', 'Group 019', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(91, 11, 'Group 020', 'Group 020', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(92, 11, 'Group 021', 'Group 021', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(93, 11, 'Group 022', 'Group 022', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(94, 11, 'Group 023', 'Group 023', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(95, 11, 'Group 024', 'Group 024', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(96, 11, 'Group 025', 'Group 025', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(97, 11, 'Group 026', 'Group 026', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(98, 11, 'Group 027', 'Group 027', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(99, 11, 'Group 028', 'Group 028', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(100, 11, 'Group 029', 'Group 029', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(101, 11, 'Group 030', 'Group 030', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(102, 11, 'Group 031', '', 3, '2019-12-07 21:30:49', '2019-12-07 22:22:38'),
(103, 11, 'Group 032', 'Group 032', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(104, 11, 'Group 033', 'Group 033', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(105, 11, 'Group 034', 'Group 034', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(106, 11, 'Group 035', 'Group 035', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(107, 11, 'Group 036', 'Group 036', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(108, 11, 'Group 037', 'Group 037', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(109, 11, 'Group 038', 'Group 038', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(110, 11, 'Group 039', 'Group 039', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(111, 11, 'Group 040', 'Group 040', 3, '2019-12-07 21:30:49', '2019-12-07 21:30:49'),
(113, 11, 'Group 001', 'Group 001', 4, '2019-12-07 21:52:37', '2019-12-07 21:54:53'),
(264, 12, 'Group 001', 'Group 001', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(265, 12, 'Group 002', 'Group 002', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(266, 12, 'Group 003', 'Group 003', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(267, 12, 'Group 004', 'Group 004', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(268, 12, 'Group 005', 'Group 005', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(269, 12, 'Group 006', 'Group 006', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(270, 12, 'Group 007', 'Group 007', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(271, 12, 'Group 008', 'Group 008', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(272, 12, 'Group 009', 'Group 009', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(273, 12, 'Group 010', 'Group 010', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(274, 12, 'Group 011', 'Group 011', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(275, 12, 'Group 012', 'Group 012', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(276, 12, 'Group 013', 'Group 013', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(277, 12, 'Group 014', 'Group 014', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(278, 12, 'Group 015', 'Group 015', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(279, 12, 'Group 016', 'Group 016', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(280, 12, 'Group 017', 'Group 017', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(281, 12, 'Group 018', 'Group 018', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(282, 12, 'Group 019', 'Group 019', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(283, 12, 'Group 020', 'Group 020', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(284, 12, 'Group 021', 'Group 021', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(285, 12, 'Group 022', 'Group 022', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(286, 12, 'Group 023', 'Group 023', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(287, 12, 'Group 024', 'Group 024', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(288, 12, 'Group 025', 'Group 025', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(289, 12, 'Group 026', 'Group 026', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(290, 12, 'Group 027', 'Group 027', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(291, 12, 'Group 028', 'Group 028', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(292, 12, 'Group 029', 'Group 029', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(293, 12, 'Group 030', 'Group 030', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(294, 12, 'Group 031', 'Group 031', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(295, 12, 'Group 032', 'Group 032', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(296, 12, 'Group 033', 'Group 033', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(297, 12, 'Group 034', 'Group 034', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(298, 12, 'Group 035', 'Group 035', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(299, 12, 'Group 036', 'Group 036', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(300, 12, 'Group 037', 'Group 037', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(301, 12, 'Group 038', 'Group 038', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(302, 12, 'Group 039', 'Group 039', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(303, 12, 'Group 040', 'Group 040', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(304, 12, 'Group 041', 'Group 041', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(305, 12, 'Group 042', 'Group 042', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(306, 12, 'Group 043', 'Group 043', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(307, 12, 'Group 044', 'Group 044', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(308, 12, 'Group 045', 'Group 045', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(309, 12, 'Group 046', 'Group 046', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(310, 12, 'Group 047', 'Group 047', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(311, 12, 'Group 048', 'Group 048', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(312, 12, 'Group 049', 'Group 049', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(313, 12, 'Group 050', 'Group 050', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(314, 12, 'Group 051', 'Group 051', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(315, 12, 'Group 052', 'Group 052', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(316, 12, 'Group 053', 'Group 053', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(317, 12, 'Group 054', 'Group 054', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(318, 12, 'Group 055', 'Group 055', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(319, 12, 'Group 056', 'Group 056', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(320, 12, 'Group 057', 'Group 057', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(321, 12, 'Group 058', 'Group 058', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(322, 12, 'Group 059', 'Group 059', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(323, 12, 'Group 060', 'Group 060', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(324, 12, 'Group 061', 'Group 061', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(325, 12, 'Group 062', 'Group 062', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(326, 12, 'Group 063', 'Group 063', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(327, 12, 'Group 064', 'Group 064', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(328, 12, 'Group 065', 'Group 065', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(329, 12, 'Group 066', 'Group 066', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(330, 12, 'Group 067', 'Group 067', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(331, 12, 'Group 068', 'Group 068', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(332, 12, 'Group 069', 'Group 069', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(333, 12, 'Group 070', 'Group 070', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(334, 12, 'Group 071', 'Group 071', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(335, 12, 'Group 072', 'Group 072', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(336, 12, 'Group 073', 'Group 073', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(337, 12, 'Group 074', 'Group 074', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(338, 12, 'Group 075', 'Group 075', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(339, 12, 'Group 076', 'Group 076', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(340, 12, 'Group 077', 'Group 077', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(341, 12, 'Group 078', 'Group 078', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(342, 12, 'Group 079', 'Group 079', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(343, 12, 'Group 080', 'Group 080', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(344, 12, 'Group 081', 'Group 081', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(345, 12, 'Group 082', 'Group 082', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(346, 12, 'Group 083', 'Group 083', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(347, 12, 'Group 084', 'Group 084', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(348, 12, 'Group 085', 'Group 085', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(349, 12, 'Group 086', 'Group 086', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(350, 12, 'Group 087', 'Group 087', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(351, 12, 'Group 088', 'Group 088', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(352, 12, 'Group 089', 'Group 089', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(353, 12, 'Group 090', 'Group 090', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(354, 12, 'Group 091', 'Group 091', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(355, 12, 'Group 092', 'Group 092', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(356, 12, 'Group 093', 'Group 093', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(357, 12, 'Group 094', 'Group 094', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(358, 12, 'Group 095', 'Group 095', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(359, 12, 'Group 096', 'Group 096', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(360, 12, 'Group 097', 'Group 097', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(361, 12, 'Group 098', 'Group 098', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(362, 12, 'Group 099', 'Group 099', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(363, 12, 'Group 100', 'Group 100', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(364, 12, 'Group 101', 'Group 101', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(365, 12, 'Group 102', 'Group 102', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(366, 12, 'Group 103', 'Group 103', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(367, 12, 'Group 104', 'Group 104', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(368, 12, 'Group 105', 'Group 105', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(369, 12, 'Group 106', 'Group 106', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(370, 12, 'Group 107', 'Group 107', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(371, 12, 'Group 108', 'Group 108', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(372, 12, 'Group 109', 'Group 109', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(373, 12, 'Group 110', 'Group 110', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(374, 12, 'Group 111', 'Group 111', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(375, 12, 'Group 112', 'Group 112', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(376, 12, 'Group 113', 'Group 113', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(377, 12, 'Group 114', 'Group 114', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(378, 12, 'Group 115', 'Group 115', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(379, 12, 'Group 116', 'Group 116', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(380, 12, 'Group 117', 'Group 117', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(381, 12, 'Group 118', 'Group 118', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(382, 12, 'Group 119', 'Group 119', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(383, 12, 'Group 120', 'Group 120', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(384, 12, 'Group 121', 'Group 121', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(385, 12, 'Group 122', 'Group 122', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(386, 12, 'Group 123', 'Group 123', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(387, 12, 'Group 124', 'Group 124', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(388, 12, 'Group 125', 'Group 125', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(389, 12, 'Group 126', 'Group 126', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(390, 12, 'Group 127', 'Group 127', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(391, 12, 'Group 128', 'Group 128', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(392, 12, 'Group 129', 'Group 129', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(393, 12, 'Group 130', 'Group 130', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(394, 12, 'Group 131', 'Group 131', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(395, 12, 'Group 132', 'Group 132', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(396, 12, 'Group 133', 'Group 133', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(397, 12, 'Group 134', 'Group 134', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(398, 12, 'Group 135', 'Group 135', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(399, 12, 'Group 136', 'Group 136', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(400, 12, 'Group 137', 'Group 137', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(401, 12, 'Group 138', 'Group 138', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(402, 12, 'Group 139', 'Group 139', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(403, 12, 'Group 140', 'Group 140', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(404, 12, 'Group 141', 'Group 141', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(405, 12, 'Group 142', 'Group 142', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(406, 12, 'Group 143', 'Group 143', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(407, 12, 'Group 144', 'Group 144', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(408, 12, 'Group 145', 'Group 145', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(409, 12, 'Group 146', 'Group 146', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(410, 12, 'Group 147', 'Group 147', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(411, 12, 'Group 148', 'Group 148', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(412, 12, 'Group 149', 'Group 149', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(413, 12, 'Group 150', 'Group 150', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(414, 12, 'Group 151', 'Group 151', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(415, 12, 'Group 152', 'Group 152', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(416, 12, 'Group 153', 'Group 153', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(417, 12, 'Group 154', 'Group 154', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(418, 12, 'Group 155', 'Group 155', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(419, 12, 'Group 156', 'Group 156', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(420, 12, 'Group 157', 'Group 157', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(421, 12, 'Group 158', 'Group 158', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(422, 12, 'Group 159', 'Group 159', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(423, 12, 'Group 160', 'Group 160', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(424, 12, 'Group 161', 'Group 161', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(425, 12, 'Group 162', 'Group 162', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(426, 12, 'Group 163', 'Group 163', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(427, 12, 'Group 164', 'Group 164', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(428, 12, 'Group 165', 'Group 165', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(429, 12, 'Group 166', 'Group 166', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(430, 12, 'Group 167', 'Group 167', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(431, 12, 'Group 168', 'Group 168', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(432, 12, 'Group 169', 'Group 169', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(433, 12, 'Group 170', 'Group 170', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(434, 12, 'Group 171', 'Group 171', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(435, 12, 'Group 172', 'Group 172', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(436, 12, 'Group 173', 'Group 173', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(437, 12, 'Group 174', 'Group 174', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(438, 12, 'Group 175', 'Group 175', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(439, 12, 'Group 176', 'Group 176', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(440, 12, 'Group 177', 'Group 177', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(441, 12, 'Group 178', 'Group 178', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(442, 12, 'Group 179', 'Group 179', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(443, 12, 'Group 180', 'Group 180', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(444, 12, 'Group 181', 'Group 181', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(445, 12, 'Group 182', 'Group 182', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(446, 12, 'Group 183', 'Group 183', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(447, 12, 'Group 184', 'Group 184', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(448, 12, 'Group 185', 'Group 185', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(449, 12, 'Group 186', 'Group 186', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(450, 12, 'Group 187', 'Group 187', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(451, 12, 'Group 188', 'Group 188', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(452, 12, 'Group 189', 'Group 189', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(453, 12, 'Group 190', 'Group 190', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(454, 12, 'Group 191', 'Group 191', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(455, 12, 'Group 192', 'Group 192', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(456, 12, 'Group 193', 'Group 193', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(457, 12, 'Group 194', 'Group 194', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(458, 12, 'Group 195', 'Group 195', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(459, 12, 'Group 196', 'Group 196', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(460, 12, 'Group 197', 'Group 197', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(461, 12, 'Group 198', 'Group 198', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(462, 12, 'Group 199', 'Group 199', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(463, 12, 'Group 200', 'Group 200', 3, '2019-12-08 00:18:03', '2019-12-08 00:18:03'),
(464, 13, 'Group 001', 'Group 001', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(465, 13, 'Group 002', 'Group 002', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(466, 13, 'Group 003', 'Group 003', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(467, 13, 'Group 004', 'Group 004', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(468, 13, 'Group 005', 'Group 005', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(469, 13, 'Group 006', 'Group 006', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(470, 13, 'Group 007', 'Group 007', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(471, 13, 'Group 008', 'Group 008', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(472, 13, 'Group 009', 'Group 009', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(473, 13, 'Group 010', 'Group 010', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(474, 13, 'Group 011', 'Group 011', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(475, 13, 'Group 012', 'Group 012', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(476, 13, 'Group 013', 'Group 013', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(477, 13, 'Group 014', 'Group 014', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(478, 13, 'Group 015', 'Group 015', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(479, 13, 'Group 016', 'Group 016', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(480, 13, 'Group 017', 'Group 017', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(481, 13, 'Group 018', 'Group 018', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(482, 13, 'Group 019', 'Group 019', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(483, 13, 'Group 020', 'Group 020', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(484, 13, 'Group 021', 'Group 021', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(485, 13, 'Group 022', 'Group 022', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(486, 13, 'Group 023', 'Group 023', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(487, 13, 'Group 024', 'Group 024', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(488, 13, 'Group 025', 'Group 025', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(489, 13, 'Group 026', 'Group 026', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(490, 13, 'Group 027', 'Group 027', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(491, 13, 'Group 028', 'Group 028', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(492, 13, 'Group 029', 'Group 029', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(493, 13, 'Group 030', 'Group 030', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(494, 13, 'Group 031', 'Group 031', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(495, 13, 'Group 032', 'Group 032', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(496, 13, 'Group 033', 'Group 033', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(497, 13, 'Group 034', 'Group 034', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(498, 13, 'Group 035', 'Group 035', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(499, 13, 'Group 036', 'Group 036', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(500, 13, 'Group 037', 'Group 037', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(501, 13, 'Group 038', 'Group 038', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(502, 13, 'Group 039', 'Group 039', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(503, 13, 'Group 040', 'Group 040', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(504, 13, 'Group 041', 'Group 041', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(505, 13, 'Group 042', 'Group 042', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(506, 13, 'Group 043', 'Group 043', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(507, 13, 'Group 044', 'Group 044', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(508, 13, 'Group 045', 'Group 045', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(509, 13, 'Group 046', 'Group 046', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(510, 13, 'Group 047', 'Group 047', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(511, 13, 'Group 048', 'Group 048', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(512, 13, 'Group 049', 'Group 049', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(513, 13, 'Group 050', 'Group 050', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(514, 13, 'Group 051', 'Group 051', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(515, 13, 'Group 052', 'Group 052', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(516, 13, 'Group 053', 'Group 053', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(517, 13, 'Group 054', 'Group 054', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(518, 13, 'Group 055', 'Group 055', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(519, 13, 'Group 056', 'Group 056', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(520, 13, 'Group 057', 'Group 057', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(521, 13, 'Group 058', 'Group 058', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(522, 13, 'Group 059', 'Group 059', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(523, 13, 'Group 060', 'Group 060', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(524, 13, 'Group 061', 'Group 061', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(525, 13, 'Group 062', 'Group 062', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(526, 13, 'Group 063', 'Group 063', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(527, 13, 'Group 064', 'Group 064', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(528, 13, 'Group 065', 'Group 065', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(529, 13, 'Group 066', 'Group 066', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(530, 13, 'Group 067', 'Group 067', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(531, 13, 'Group 068', 'Group 068', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(532, 13, 'Group 069', 'Group 069', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(533, 13, 'Group 070', 'Group 070', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(534, 13, 'Group 071', 'Group 071', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(535, 13, 'Group 072', 'Group 072', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(536, 13, 'Group 073', 'Group 073', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(537, 13, 'Group 074', 'Group 074', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(538, 13, 'Group 075', 'Group 075', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(539, 13, 'Group 076', 'Group 076', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(540, 13, 'Group 077', 'Group 077', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(541, 13, 'Group 078', 'Group 078', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(542, 13, 'Group 079', 'Group 079', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(543, 13, 'Group 080', 'Group 080', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(544, 13, 'Group 081', 'Group 081', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(545, 13, 'Group 082', 'Group 082', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(546, 13, 'Group 083', 'Group 083', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(547, 13, 'Group 084', 'Group 084', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(548, 13, 'Group 085', 'Group 085', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(549, 13, 'Group 086', 'Group 086', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(550, 13, 'Group 087', 'Group 087', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(551, 13, 'Group 088', 'Group 088', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(552, 13, 'Group 089', 'Group 089', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(553, 13, 'Group 090', 'Group 090', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(554, 13, 'Group 091', 'Group 091', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(555, 13, 'Group 092', 'Group 092', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(556, 13, 'Group 093', 'Group 093', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(557, 13, 'Group 094', 'Group 094', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(558, 13, 'Group 095', 'Group 095', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(559, 13, 'Group 096', 'Group 096', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(560, 13, 'Group 097', 'Group 097', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(561, 13, 'Group 098', 'Group 098', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(562, 13, 'Group 099', 'Group 099', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(563, 13, 'Group 100', 'Group 100', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(564, 13, 'Group 101', 'Group 101', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(565, 13, 'Group 102', 'Group 102', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(566, 13, 'Group 103', 'Group 103', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(567, 13, 'Group 104', 'Group 104', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(568, 13, 'Group 105', 'Group 105', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(569, 13, 'Group 106', 'Group 106', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(570, 13, 'Group 107', 'Group 107', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(571, 13, 'Group 108', 'Group 108', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(572, 13, 'Group 109', 'Group 109', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(573, 13, 'Group 110', 'Group 110', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(574, 13, 'Group 111', 'Group 111', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(575, 13, 'Group 112', 'Group 112', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(576, 13, 'Group 113', 'Group 113', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(577, 13, 'Group 114', 'Group 114', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(578, 13, 'Group 115', 'Group 115', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(579, 13, 'Group 116', 'Group 116', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(580, 13, 'Group 117', 'Group 117', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(581, 13, 'Group 118', 'Group 118', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(582, 13, 'Group 119', 'Group 119', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(583, 13, 'Group 120', 'Group 120', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(584, 13, 'Group 121', 'Group 121', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(585, 13, 'Group 122', 'Group 122', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(586, 13, 'Group 123', 'Group 123', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(587, 13, 'Group 124', 'Group 124', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(588, 13, 'Group 125', 'Group 125', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(589, 13, 'Group 126', 'Group 126', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(590, 13, 'Group 127', 'Group 127', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(591, 13, 'Group 128', 'Group 128', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(592, 13, 'Group 129', 'Group 129', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(593, 13, 'Group 130', 'Group 130', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(594, 13, 'Group 131', 'Group 131', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(595, 13, 'Group 132', 'Group 132', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(596, 13, 'Group 133', 'Group 133', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(597, 13, 'Group 134', 'Group 134', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(598, 13, 'Group 135', 'Group 135', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(599, 13, 'Group 136', 'Group 136', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(600, 13, 'Group 137', 'Group 137', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(601, 13, 'Group 138', 'Group 138', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(602, 13, 'Group 139', 'Group 139', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(603, 13, 'Group 140', 'Group 140', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(604, 13, 'Group 141', 'Group 141', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(605, 13, 'Group 142', 'Group 142', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(606, 13, 'Group 143', 'Group 143', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(607, 13, 'Group 144', 'Group 144', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(608, 13, 'Group 145', 'Group 145', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(609, 13, 'Group 146', 'Group 146', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(610, 13, 'Group 147', 'Group 147', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(611, 13, 'Group 148', 'Group 148', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(612, 13, 'Group 149', 'Group 149', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(613, 13, 'Group 150', 'Group 150', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(614, 13, 'Group 151', 'Group 151', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(615, 13, 'Group 152', 'Group 152', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(616, 13, 'Group 153', 'Group 153', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(617, 13, 'Group 154', 'Group 154', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(618, 13, 'Group 155', 'Group 155', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(619, 13, 'Group 156', 'Group 156', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(620, 13, 'Group 157', 'Group 157', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(621, 13, 'Group 158', 'Group 158', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(622, 13, 'Group 159', 'Group 159', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(623, 13, 'Group 160', 'Group 160', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(624, 13, 'Group 161', 'Group 161', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(625, 13, 'Group 162', 'Group 162', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(626, 13, 'Group 163', 'Group 163', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(627, 13, 'Group 164', 'Group 164', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(628, 13, 'Group 165', 'Group 165', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(629, 13, 'Group 166', 'Group 166', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(630, 13, 'Group 167', 'Group 167', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(631, 13, 'Group 168', 'Group 168', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(632, 13, 'Group 169', 'Group 169', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(633, 13, 'Group 170', 'Group 170', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(634, 13, 'Group 171', 'Group 171', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(635, 13, 'Group 172', 'Group 172', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(636, 13, 'Group 173', 'Group 173', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(637, 13, 'Group 174', 'Group 174', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(638, 13, 'Group 175', 'Group 175', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(639, 13, 'Group 176', 'Group 176', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(640, 13, 'Group 177', 'Group 177', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(641, 13, 'Group 178', 'Group 178', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(642, 13, 'Group 179', 'Group 179', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(643, 13, 'Group 180', 'Group 180', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(644, 13, 'Group 181', 'Group 181', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(645, 13, 'Group 182', 'Group 182', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(646, 13, 'Group 183', 'Group 183', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(647, 13, 'Group 184', 'Group 184', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(648, 13, 'Group 185', 'Group 185', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(649, 13, 'Group 186', 'Group 186', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(650, 13, 'Group 187', 'Group 187', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(651, 13, 'Group 188', 'Group 188', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(652, 13, 'Group 189', 'Group 189', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(653, 13, 'Group 190', 'Group 190', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(654, 13, 'Group 191', 'Group 191', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(655, 13, 'Group 192', 'Group 192', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(656, 13, 'Group 193', 'Group 193', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(657, 13, 'Group 194', 'Group 194', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(658, 13, 'Group 195', 'Group 195', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(659, 13, 'Group 196', 'Group 196', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(660, 13, 'Group 197', 'Group 197', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(661, 13, 'Group 198', 'Group 198', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(662, 13, 'Group 199', 'Group 199', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48'),
(663, 13, 'Group 200', 'Group 200', 3, '2019-12-08 21:36:48', '2019-12-08 21:36:48');

-- --------------------------------------------------------

--
-- Table structure for table `assignment_topic_allocation`
--

DROP TABLE IF EXISTS `assignment_topic_allocation`;
CREATE TABLE IF NOT EXISTS `assignment_topic_allocation` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=267 ;

--
-- Dumping data for table `assignment_topic_allocation`
--

INSERT INTO `assignment_topic_allocation` (`id`, `asg_id`, `user_id`, `topic_id`, `create_time`, `last_upd_time`) VALUES
(1, 12, 'user9', 327, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(2, 12, 'user11', 438, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(3, 12, 'user15', 378, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(4, 12, 'user17', 427, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(5, 12, 'user20', 396, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(6, 12, 'user21', 377, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(7, 12, 'user22', 407, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(8, 12, 'user24', 264, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(9, 12, 'user25', 340, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(10, 12, 'user26', 269, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(11, 12, 'user30', 418, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(12, 12, 'user32', 414, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(13, 12, 'user35', 355, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(14, 12, 'user36', 346, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(15, 12, 'user38', 377, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(16, 12, 'user39', 268, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(17, 12, 'user41', 357, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(18, 12, 'user42', 371, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(19, 12, 'user43', 399, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(20, 12, 'user46', 407, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(21, 12, 'user51', 392, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(22, 12, 'user56', 437, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(23, 12, 'user61', 400, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(24, 12, 'user63', 289, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(25, 12, 'user64', 344, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(26, 12, 'user65', 272, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(27, 12, 'user69', 316, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(28, 12, 'user80', 401, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(29, 12, 'user88', 350, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(30, 12, 'user90', 434, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(31, 12, 'user91', 317, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(32, 12, 'user92', 344, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(33, 12, 'user93', 444, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(34, 12, 'user95', 453, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(35, 12, 'user97', 318, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(36, 12, 'user100', 364, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(37, 12, 'user105', 427, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(38, 12, 'user106', 409, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(39, 12, 'user107', 390, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(40, 12, 'user108', 380, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(41, 12, 'user111', 269, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(42, 12, 'user113', 283, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(43, 12, 'user115', 409, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(44, 12, 'user118', 345, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(45, 12, 'user119', 357, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(46, 12, 'user125', 404, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(47, 12, 'user134', 318, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(48, 12, 'user137', 403, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(49, 12, 'user138', 293, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(50, 12, 'user140', 283, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(51, 12, 'user144', 306, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(52, 12, 'user145', 274, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(53, 12, 'user149', 449, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(54, 12, 'user151', 268, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(55, 12, 'user152', 394, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(56, 12, 'user153', 452, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(57, 12, 'user155', 335, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(58, 12, 'user157', 293, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(59, 12, 'user160', 280, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(60, 12, 'user165', 308, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(61, 12, 'user166', 361, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(62, 12, 'user171', 330, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(63, 12, 'user173', 306, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(64, 12, 'user177', 332, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(65, 12, 'user178', 416, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(66, 12, 'user179', 393, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(67, 12, 'user185', 296, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(68, 12, 'user188', 333, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(69, 12, 'user189', 418, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(70, 12, 'user194', 454, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(71, 12, 'user195', 270, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(72, 12, 'user196', 288, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(73, 12, 'user197', 448, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(74, 12, 'user199', 342, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(75, 12, 'user200', 434, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(76, 12, 'user205', 395, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(77, 12, 'user206', 459, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(78, 12, 'user209', 454, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(79, 12, 'user211', 444, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(80, 12, 'user213', 413, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(81, 12, 'user215', 327, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(82, 12, 'user216', 266, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(83, 12, 'user217', 361, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(84, 12, 'user220', 457, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(85, 12, 'user224', 436, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(86, 12, 'user225', 440, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(87, 12, 'user226', 378, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(88, 12, 'user228', 391, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(89, 12, 'user229', 454, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(90, 12, 'user232', 394, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(91, 12, 'user234', 396, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(92, 12, 'user235', 297, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(93, 12, 'user237', 379, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(94, 12, 'user238', 383, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(95, 12, 'user240', 390, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(96, 12, 'user241', 371, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(97, 12, 'user243', 458, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(98, 12, 'user245', 349, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(99, 12, 'user246', 342, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(100, 12, 'user247', 346, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(101, 12, 'user251', 387, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(102, 12, 'user253', 349, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(103, 12, 'user255', 353, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(104, 12, 'user259', 331, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(105, 12, 'user265', 456, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(106, 12, 'user267', 406, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(107, 12, 'user268', 439, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(108, 12, 'user269', 328, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(109, 12, 'user270', 328, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(110, 12, 'user273', 463, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(111, 12, 'user276', 407, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(112, 12, 'user278', 438, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(113, 12, 'user279', 453, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(114, 12, 'user280', 444, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(115, 12, 'user282', 347, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(116, 12, 'user285', 296, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(117, 12, 'user289', 329, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(118, 12, 'user293', 293, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(119, 12, 'user294', 346, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(120, 12, 'user297', 341, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(121, 12, 'user298', 331, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(122, 12, 'user299', 408, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(123, 12, 'user302', 453, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(124, 12, 'user303', 348, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(125, 12, 'user305', 377, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(126, 12, 'user308', 266, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(127, 12, 'user310', 281, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(128, 12, 'user314', 305, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(129, 12, 'user316', 278, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(130, 12, 'user318', 288, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(131, 12, 'user320', 332, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(132, 12, 'user322', 383, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(133, 12, 'user324', 384, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(134, 12, 'user326', 290, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(135, 12, 'user330', 268, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(136, 12, 'user334', 393, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(137, 12, 'user339', 270, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(138, 12, 'user340', 317, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(139, 12, 'user341', 317, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(140, 12, 'user344', 355, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(141, 12, 'user347', 332, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(142, 12, 'user348', 273, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(143, 12, 'user349', 430, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(144, 12, 'user350', 409, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(145, 12, 'user354', 420, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(146, 12, 'user355', 308, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(147, 12, 'user356', 266, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(148, 12, 'user361', 386, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(149, 12, 'user363', 463, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(150, 12, 'user364', 388, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(151, 12, 'user365', 290, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(152, 12, 'user366', 413, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(153, 12, 'user368', 430, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(154, 12, 'user371', 404, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(155, 12, 'user379', 352, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(156, 12, 'user380', 280, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(157, 12, 'user385', 282, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(158, 12, 'user386', 329, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(159, 12, 'user392', 403, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(160, 12, 'user393', 391, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(161, 12, 'user394', 316, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(162, 12, 'user396', 414, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(163, 12, 'user399', 434, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(164, 12, 'user401', 274, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(165, 12, 'user402', 408, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(166, 12, 'user403', 439, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(167, 12, 'user409', 396, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(168, 12, 'user410', 457, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(169, 12, 'user412', 364, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(170, 12, 'user413', 439, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(171, 12, 'user416', 307, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(172, 12, 'user417', 380, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(173, 12, 'user418', 459, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(174, 12, 'user419', 328, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(175, 12, 'user420', 416, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(176, 12, 'user421', 437, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(177, 12, 'user429', 329, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(178, 12, 'user432', 331, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(179, 12, 'user435', 425, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(180, 12, 'user436', 350, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(181, 12, 'user437', 426, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(182, 12, 'user439', 386, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(183, 12, 'user441', 355, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(184, 12, 'user442', 416, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(185, 12, 'user443', 388, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(186, 12, 'user446', 426, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(187, 12, 'user447', 272, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(188, 12, 'user449', 345, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(189, 12, 'user452', 425, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(190, 12, 'user453', 404, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(191, 12, 'user454', 378, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(192, 12, 'user457', 342, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(193, 12, 'user458', 272, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(194, 12, 'user460', 305, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(195, 12, 'user461', 406, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(196, 12, 'user462', 457, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(197, 12, 'user465', 381, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(198, 12, 'user466', 451, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(199, 12, 'user468', 307, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(200, 12, 'user469', 285, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(201, 12, 'user471', 380, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(202, 12, 'user478', 280, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(203, 12, 'user481', 318, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(204, 12, 'user482', 361, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(205, 12, 'user485', 285, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(206, 12, 'user486', 381, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(207, 12, 'user487', 364, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(208, 12, 'user489', 264, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(209, 12, 'user490', 265, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(210, 12, 'user491', 335, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(211, 12, 'user492', 325, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(212, 12, 'user493', 451, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(213, 12, 'user495', 458, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(214, 12, 'user496', 401, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(215, 12, 'user497', 306, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(216, 12, 'user498', 368, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(217, 12, 'user501', 368, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(218, 12, 'user505', 282, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(219, 12, 'user507', 265, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(220, 12, 'user514', 353, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(221, 12, 'user515', 286, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(222, 12, 'user516', 456, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(223, 12, 'user519', 452, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(224, 12, 'user523', 420, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(225, 12, 'user525', 282, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(226, 12, 'user526', 399, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(227, 12, 'user529', 347, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(228, 12, 'user530', 438, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(229, 12, 'user536', 341, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(230, 12, 'user541', 274, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(231, 12, 'user542', 327, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(232, 12, 'user543', 395, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(233, 12, 'user544', 393, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(234, 12, 'user545', 330, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(235, 12, 'user547', 400, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(236, 12, 'user549', 383, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(237, 12, 'user550', 381, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(238, 12, 'user551', 436, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(239, 12, 'user552', 305, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(240, 12, 'user556', 275, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(241, 12, 'user563', 350, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(242, 12, 'user564', 449, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(243, 12, 'user569', 287, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(244, 12, 'user571', 330, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(245, 12, 'user572', 414, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(246, 12, 'user574', 427, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(247, 12, 'user576', 440, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(248, 12, 'user579', 458, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(249, 12, 'user582', 433, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(250, 12, 'user584', 357, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(251, 12, 'user587', 401, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(252, 12, 'user590', 301, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(253, 12, 'user594', 291, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(254, 12, 'user596', 347, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(255, 12, 'user597', 448, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(256, 12, 'user599', 281, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(257, 12, 'user600', 436, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(258, 12, 'user601', 264, '2019-12-08 15:58:03', '2019-12-08 15:58:03'),
(262, 1, 'user1', 5, '2019-12-12 18:01:58', '2019-12-12 18:01:58'),
(264, 11, 'user1', 73, '2019-12-13 17:50:43', '2019-12-13 17:50:43'),
(265, 11, 'user2', 73, '2019-12-14 00:20:21', '2019-12-14 00:20:21'),
(266, 11, 'user3', 73, '2019-12-14 00:20:33', '2019-12-14 00:20:33');

-- --------------------------------------------------------

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
CREATE TABLE IF NOT EXISTS `submission` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `filename` varchar(1000) NOT NULL,
  `submission_date` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `submission`
--

INSERT INTO `submission` (`id`, `asg_id`, `topic_id`, `user_id`, `filename`, `submission_date`) VALUES
(1, 11, 94, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/f4b9ec30ad9f68f89b29639786cb62ef/c96b4b75787a2cb4d32c4ef7a5a621db.pdf', '2019-12-13 17:18:52'),
(4, 11, 73, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/d2ddea18f00665ce8623e36bd4e3c7c5/7b0a03486e7a22394400de4623a38960.pdf', '2019-12-16 21:54:55');

--
-- Triggers `submission`
--
DROP TRIGGER IF EXISTS `tg_delete_submission`;
DELIMITER //
CREATE TRIGGER `tg_delete_submission` BEFORE DELETE ON `submission`
 FOR EACH ROW INSERT INTO submission_log
SET id             = OLD.id,
    asg_id         = OLD.asg_id,
    topic_id       = OLD.topic_id,
    user_id        = OLD.user_id,
    filename       = OLD.filename,
    submission_date= OLD.submission_date,
    action         = 'DELETE',
    action_date    = now()
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_insert_submission`;
DELIMITER //
CREATE TRIGGER `tg_insert_submission` AFTER INSERT ON `submission`
 FOR EACH ROW INSERT INTO submission_log
SET id             = NEW.id,
    asg_id         = NEW.asg_id,
    topic_id       = NEW.topic_id,
    user_id        = NEW.user_id,
    filename       = NEW.filename,
    submission_date= NEW.submission_date,
    action         = 'ADD',
    action_date    = now()
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `submission_log`
--

DROP TABLE IF EXISTS `submission_log`;
CREATE TABLE IF NOT EXISTS `submission_log` (
  `id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `filename` varchar(1000) NOT NULL,
  `submission_date` datetime NOT NULL,
  `action` varchar(10) NOT NULL,
  `action_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `submission_log`
--

INSERT INTO `submission_log` (`id`, `asg_id`, `topic_id`, `user_id`, `filename`, `submission_date`, `action`, `action_date`) VALUES
(1, 11, 94, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/f4b9ec30ad9f68f89b29639786cb62ef/c96b4b75787a2cb4d32c4ef7a5a621db.pdf', '2019-12-13 17:18:52', 'ADD', '2019-12-13 17:18:52'),
(2, 11, 73, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/d2ddea18f00665ce8623e36bd4e3c7c5/1302a34ea05326a86f8652f9d2a99f96.pdf', '2019-12-16 02:20:32', 'ADD', '2019-12-16 02:20:32'),
(2, 11, 73, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/d2ddea18f00665ce8623e36bd4e3c7c5/1302a34ea05326a86f8652f9d2a99f96.pdf', '2019-12-16 02:20:32', 'DELETE', '2019-12-16 02:20:41'),
(3, 11, 73, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/d2ddea18f00665ce8623e36bd4e3c7c5/1be06deb42d30a574f12c26f91987f8f.pdf', '2019-12-16 02:20:41', 'ADD', '2019-12-16 02:20:41'),
(3, 11, 73, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/d2ddea18f00665ce8623e36bd4e3c7c5/1be06deb42d30a574f12c26f91987f8f.pdf', '2019-12-16 02:20:41', 'DELETE', '2019-12-16 21:54:55'),
(4, 11, 73, 'user1', './uploads/6512bd43d9caa6e02c990b0a82652dca/d2ddea18f00665ce8623e36bd4e3c7c5/7b0a03486e7a22394400de4623a38960.pdf', '2019-12-16 21:54:55', 'ADD', '2019-12-16 21:54:55');

-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignemnt_student`
--
DROP VIEW IF EXISTS `sv_assignemnt_student`;
CREATE TABLE IF NOT EXISTS `sv_assignemnt_student` (
`id` int(11)
,`asg_id` int(11)
,`asg_title` varchar(500)
,`unit_id` int(11)
,`unit_code` varchar(20)
,`unit_description` varchar(500)
,`username` varchar(20)
,`email` varchar(255)
,`last_name` varchar(255)
,`first_name` varchar(255)
,`sid` varchar(10)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_staff`
--
DROP VIEW IF EXISTS `sv_assignment_staff`;
CREATE TABLE IF NOT EXISTS `sv_assignment_staff` (
`id` int(11)
,`title` varchar(500)
,`type` int(11)
,`topic_count` bigint(21)
,`student_count` bigint(21)
,`outcome` mediumtext
,`scenario` mediumtext
,`unit_id` int(11)
,`create_time` datetime
,`last_upd_time` datetime
,`unit_code` varchar(20)
,`unit_description` varchar(500)
,`username` varchar(20)
,`last_name` varchar(255)
,`first_name` varchar(255)
,`sid` varchar(10)
,`email` varchar(255)
,`permission_level` int(11)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_student_count`
--
DROP VIEW IF EXISTS `sv_assignment_student_count`;
CREATE TABLE IF NOT EXISTS `sv_assignment_student_count` (
`id` int(11)
,`student_count` bigint(21)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_topic_count`
--
DROP VIEW IF EXISTS `sv_assignment_topic_count`;
CREATE TABLE IF NOT EXISTS `sv_assignment_topic_count` (
`id` int(11)
,`topic_count` bigint(21)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_topic_member`
--
DROP VIEW IF EXISTS `sv_assignment_topic_member`;
CREATE TABLE IF NOT EXISTS `sv_assignment_topic_member` (
`id` int(11)
,`asg_id` int(11)
,`user_id` varchar(20)
,`topic_id` int(11)
,`create_time` datetime
,`last_upd_time` datetime
,`first_name` varchar(255)
,`last_name` varchar(255)
,`sid` varchar(10)
,`email` varchar(255)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_topic_summary`
--
DROP VIEW IF EXISTS `sv_assignment_topic_summary`;
CREATE TABLE IF NOT EXISTS `sv_assignment_topic_summary` (
`id` int(11)
,`user_id` varchar(20)
,`topic_id` int(11)
,`assign_id` int(11)
,`topic` varchar(500)
,`topic_desc` mediumtext
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_topic_stat`
--
DROP VIEW IF EXISTS `sv_topic_stat`;
CREATE TABLE IF NOT EXISTS `sv_topic_stat` (
`id` int(11)
,`cnt` bigint(21)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_unit_staff`
--
DROP VIEW IF EXISTS `sv_unit_staff`;
CREATE TABLE IF NOT EXISTS `sv_unit_staff` (
`id` int(11)
,`unit_code` varchar(20)
,`unit_description` varchar(500)
,`create_time` datetime
,`last_upd_time` datetime
,`username` varchar(20)
,`last_name` varchar(255)
,`first_name` varchar(255)
,`sid` varchar(10)
,`email` varchar(255)
,`permission_level` int(11)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_unit_student`
--
DROP VIEW IF EXISTS `sv_unit_student`;
CREATE TABLE IF NOT EXISTS `sv_unit_student` (
`username` varchar(20)
,`last_name` varchar(255)
,`first_name` varchar(255)
,`sid` varchar(10)
,`email` varchar(255)
,`permission_level` int(11)
,`id` int(11)
,`unit_code` varchar(20)
,`unit_description` varchar(500)
,`create_time` datetime
,`last_upd_time` datetime
);
-- --------------------------------------------------------

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
CREATE TABLE IF NOT EXISTS `unit` (
`id` int(11) NOT NULL,
  `unit_code` varchar(20) NOT NULL,
  `unit_description` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `unit`
--

INSERT INTO `unit` (`id`, `unit_code`, `unit_description`, `create_time`, `last_upd_time`) VALUES
(1, 'KIT711', 'Network Security Techniques and Technology', '2019-11-17 22:41:43', '2019-11-17 22:41:43'),
(4, 'KIT111', 'Data Networks and Security', '2019-11-17 23:28:58', '2019-11-17 23:28:58'),
(5, 'KIT501', 'ICT Systems Administration Fundamentals', '2019-11-17 23:28:58', '2019-11-17 23:28:58'),
(6, 'KIT201', 'Data Networks and Security', '2019-11-17 23:29:51', '2019-11-17 23:29:51'),
(7, 'KIT301', 'ICT Project A', '2019-12-05 15:34:57', '2019-12-05 15:34:57'),
(8, 'KIT302', 'ICT Project B', '2019-12-05 15:35:05', '2019-12-05 15:35:05'),
(9, 'KIT503', 'ICT Professional Practices and Project Management', '2019-12-05 15:35:46', '2019-12-05 15:35:46');

-- --------------------------------------------------------

--
-- Table structure for table `unit_enrol`
--

DROP TABLE IF EXISTS `unit_enrol`;
CREATE TABLE IF NOT EXISTS `unit_enrol` (
`id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `enable` int(11) NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=750 ;

--
-- Dumping data for table `unit_enrol`
--

INSERT INTO `unit_enrol` (`id`, `user_id`, `unit_id`, `enable`, `create_time`, `last_upd_time`) VALUES
(1, 'user1', 1, 1, '2019-11-18 22:04:56', '2019-11-19 01:54:58'),
(2, 'user1', 7, 1, '2019-11-18 22:05:37', '2019-11-19 01:55:24'),
(3, 'user2', 7, 1, '2019-11-18 22:12:33', '2019-11-18 22:12:33'),
(4, 'user3', 7, 1, '2019-11-18 22:12:33', '2019-11-18 22:12:33'),
(5, 'user2', 6, 1, '2019-11-19 00:02:45', '2019-11-19 00:02:45'),
(6, 'user4', 9, 1, '2019-12-08 00:29:23', '2019-12-08 00:29:23'),
(7, 'user5', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(8, 'user6', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(9, 'user7', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(10, 'user8', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(11, 'user9', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(12, 'user10', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(13, 'user11', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(14, 'user12', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(15, 'user13', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(16, 'user14', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(17, 'user15', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(18, 'user16', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(19, 'user17', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(20, 'user18', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(21, 'user19', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(22, 'user20', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(23, 'user21', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(24, 'user22', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(25, 'user23', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(26, 'user24', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(27, 'user25', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(28, 'user26', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(29, 'user27', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(30, 'user28', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(31, 'user29', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(32, 'user30', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(33, 'user31', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(34, 'user32', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(35, 'user33', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(36, 'user34', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(37, 'user35', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(38, 'user36', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(39, 'user37', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(40, 'user38', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(41, 'user39', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(42, 'user40', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(43, 'user41', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(44, 'user42', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(45, 'user43', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(46, 'user44', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(47, 'user45', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(48, 'user46', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(49, 'user47', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(50, 'user48', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(51, 'user49', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(52, 'user50', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(53, 'user51', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(54, 'user52', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(55, 'user53', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(56, 'user54', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(57, 'user55', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(58, 'user56', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(59, 'user57', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(60, 'user58', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(61, 'user59', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(62, 'user60', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(63, 'user61', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(64, 'user62', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(65, 'user63', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(66, 'user64', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(67, 'user65', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(68, 'user66', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(69, 'user67', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(70, 'user68', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(71, 'user69', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(72, 'user70', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(73, 'user71', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(74, 'user72', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(75, 'user73', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(76, 'user74', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(77, 'user75', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(78, 'user76', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(79, 'user77', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(80, 'user78', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(81, 'user79', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(82, 'user80', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(83, 'user81', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(84, 'user82', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(85, 'user83', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(86, 'user84', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(87, 'user85', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(88, 'user86', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(89, 'user87', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(90, 'user88', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(91, 'user89', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(92, 'user90', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(93, 'user91', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(94, 'user92', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(95, 'user93', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(96, 'user94', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(97, 'user95', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(98, 'user96', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(99, 'user97', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(100, 'user98', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(101, 'user99', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(102, 'user100', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(103, 'user101', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(104, 'user102', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(105, 'user103', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(106, 'user104', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(107, 'user105', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(108, 'user106', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(109, 'user107', 9, 1, '2019-12-08 00:30:40', '2019-12-08 00:30:40'),
(110, 'user108', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(111, 'user109', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(112, 'user110', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(113, 'user111', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(114, 'user112', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(115, 'user113', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(116, 'user114', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(117, 'user115', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(118, 'user116', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(119, 'user117', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(120, 'user118', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(121, 'user119', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(122, 'user120', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(123, 'user121', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(124, 'user122', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(125, 'user123', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(126, 'user124', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(127, 'user125', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(128, 'user126', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(129, 'user127', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(130, 'user128', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(131, 'user129', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(132, 'user130', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(133, 'user131', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(134, 'user132', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(135, 'user133', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(136, 'user134', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(137, 'user135', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(138, 'user136', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(139, 'user137', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(140, 'user138', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(141, 'user139', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(142, 'user140', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(143, 'user141', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(144, 'user142', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(145, 'user143', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(146, 'user144', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(147, 'user145', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(148, 'user146', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(149, 'user147', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(150, 'user148', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(151, 'user149', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(152, 'user150', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(153, 'user151', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(154, 'user152', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(155, 'user153', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(156, 'user154', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(157, 'user155', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(158, 'user156', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(159, 'user157', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(160, 'user158', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(161, 'user159', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(162, 'user160', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(163, 'user161', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(164, 'user162', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(165, 'user163', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(166, 'user164', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(167, 'user165', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(168, 'user166', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(169, 'user167', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(170, 'user168', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(171, 'user169', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(172, 'user170', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(173, 'user171', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(174, 'user172', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(175, 'user173', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(176, 'user174', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(177, 'user175', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(178, 'user176', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(179, 'user177', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(180, 'user178', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(181, 'user179', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(182, 'user180', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(183, 'user181', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(184, 'user182', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(185, 'user183', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(186, 'user184', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(187, 'user185', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(188, 'user186', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(189, 'user187', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(190, 'user188', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(191, 'user189', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(192, 'user190', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(193, 'user191', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(194, 'user192', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(195, 'user193', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(196, 'user194', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(197, 'user195', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(198, 'user196', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(199, 'user197', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(200, 'user198', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(201, 'user199', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(202, 'user200', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(203, 'user201', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(204, 'user202', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(205, 'user203', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(206, 'user204', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(207, 'user205', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(208, 'user206', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(209, 'user207', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(210, 'user208', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(211, 'user209', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(212, 'user210', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(213, 'user211', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(214, 'user212', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(215, 'user213', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(216, 'user214', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(217, 'user215', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(218, 'user216', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(219, 'user217', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(220, 'user218', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(221, 'user219', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(222, 'user220', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(223, 'user221', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(224, 'user222', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(225, 'user223', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(226, 'user224', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(227, 'user225', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(228, 'user226', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(229, 'user227', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(230, 'user228', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(231, 'user229', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(232, 'user230', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(233, 'user231', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(234, 'user232', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(235, 'user233', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(236, 'user234', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(237, 'user235', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(238, 'user236', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(239, 'user237', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(240, 'user238', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(241, 'user239', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(242, 'user240', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(243, 'user241', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(244, 'user242', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(245, 'user243', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(246, 'user244', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(247, 'user245', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(248, 'user246', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(249, 'user247', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(250, 'user248', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(251, 'user249', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(252, 'user250', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(253, 'user251', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(254, 'user252', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(255, 'user253', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(256, 'user254', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(257, 'user255', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(258, 'user256', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(259, 'user257', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(260, 'user258', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(261, 'user259', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(262, 'user260', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(263, 'user261', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(264, 'user262', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(265, 'user263', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(266, 'user264', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(267, 'user265', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(268, 'user266', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(269, 'user267', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(270, 'user268', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(271, 'user269', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(272, 'user270', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(273, 'user271', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(274, 'user272', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(275, 'user273', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(276, 'user274', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(277, 'user275', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(278, 'user276', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(279, 'user277', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(280, 'user278', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(281, 'user279', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(282, 'user280', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(283, 'user281', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(284, 'user282', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(285, 'user283', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(286, 'user284', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(287, 'user285', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(288, 'user286', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(289, 'user287', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(290, 'user288', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(291, 'user289', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(292, 'user290', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(293, 'user291', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(294, 'user292', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(295, 'user293', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(296, 'user294', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(297, 'user295', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(298, 'user296', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(299, 'user297', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(300, 'user298', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(301, 'user299', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(302, 'user300', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(303, 'user301', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(304, 'user302', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(305, 'user303', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(306, 'user304', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(307, 'user305', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(308, 'user306', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(309, 'user307', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(310, 'user308', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(311, 'user309', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(312, 'user310', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(313, 'user311', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(314, 'user312', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(315, 'user313', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(316, 'user314', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(317, 'user315', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(318, 'user316', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(319, 'user317', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(320, 'user318', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(321, 'user319', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(322, 'user320', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(323, 'user321', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(324, 'user322', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(325, 'user323', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(326, 'user324', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(327, 'user325', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(328, 'user326', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(329, 'user327', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(330, 'user328', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(331, 'user329', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(332, 'user330', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(333, 'user331', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(334, 'user332', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(335, 'user333', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(336, 'user334', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(337, 'user335', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(338, 'user336', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(339, 'user337', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(340, 'user338', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(341, 'user339', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(342, 'user340', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(343, 'user341', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(344, 'user342', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(345, 'user343', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(346, 'user344', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(347, 'user345', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(348, 'user346', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(349, 'user347', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(350, 'user348', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(351, 'user349', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(352, 'user350', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(353, 'user351', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(354, 'user352', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(355, 'user353', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(356, 'user354', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(357, 'user355', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(358, 'user356', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(359, 'user357', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(360, 'user358', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(361, 'user359', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(362, 'user360', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(363, 'user361', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(364, 'user362', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(365, 'user363', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(366, 'user364', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(367, 'user365', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(368, 'user366', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(369, 'user367', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(370, 'user368', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(371, 'user369', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(372, 'user370', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(373, 'user371', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(374, 'user372', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(375, 'user373', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(376, 'user374', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(377, 'user375', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(378, 'user376', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(379, 'user377', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(380, 'user378', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(381, 'user379', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(382, 'user380', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(383, 'user381', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(384, 'user382', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(385, 'user383', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(386, 'user384', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(387, 'user385', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(388, 'user386', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(389, 'user387', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(390, 'user388', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(391, 'user389', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(392, 'user390', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(393, 'user391', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(394, 'user392', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(395, 'user393', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(396, 'user394', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(397, 'user395', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(398, 'user396', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(399, 'user397', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(400, 'user398', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(401, 'user399', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(402, 'user400', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(403, 'user401', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(404, 'user402', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(405, 'user403', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(406, 'user404', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(407, 'user405', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(408, 'user406', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(409, 'user407', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(410, 'user408', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(411, 'user409', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(412, 'user410', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(413, 'user411', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(414, 'user412', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(415, 'user413', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(416, 'user414', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(417, 'user415', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(418, 'user416', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(419, 'user417', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(420, 'user418', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(421, 'user419', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(422, 'user420', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(423, 'user421', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(424, 'user422', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(425, 'user423', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(426, 'user424', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(427, 'user425', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(428, 'user426', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(429, 'user427', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(430, 'user428', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(431, 'user429', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(432, 'user430', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(433, 'user431', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(434, 'user432', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(435, 'user433', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(436, 'user434', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(437, 'user435', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(438, 'user436', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(439, 'user437', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(440, 'user438', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(441, 'user439', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(442, 'user440', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(443, 'user441', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(444, 'user442', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(445, 'user443', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(446, 'user444', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(447, 'user445', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(448, 'user446', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(449, 'user447', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(450, 'user448', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(451, 'user449', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(452, 'user450', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(453, 'user451', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(454, 'user452', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(455, 'user453', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(456, 'user454', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(457, 'user455', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(458, 'user456', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(459, 'user457', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(460, 'user458', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(461, 'user459', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(462, 'user460', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(463, 'user461', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(464, 'user462', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(465, 'user463', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(466, 'user464', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(467, 'user465', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(468, 'user466', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(469, 'user467', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(470, 'user468', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(471, 'user469', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(472, 'user470', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(473, 'user471', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(474, 'user472', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(475, 'user473', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(476, 'user474', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(477, 'user475', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(478, 'user476', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(479, 'user477', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(480, 'user478', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(481, 'user479', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(482, 'user480', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(483, 'user481', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(484, 'user482', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(485, 'user483', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(486, 'user484', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(487, 'user485', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(488, 'user486', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(489, 'user487', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(490, 'user488', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(491, 'user489', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(492, 'user490', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(493, 'user491', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(494, 'user492', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(495, 'user493', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(496, 'user494', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(497, 'user495', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(498, 'user496', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(499, 'user497', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(500, 'user498', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(501, 'user499', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(502, 'user500', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(503, 'user501', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(504, 'user502', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(505, 'user503', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(506, 'user504', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(507, 'user505', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(508, 'user506', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(509, 'user507', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(510, 'user508', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(511, 'user509', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(512, 'user510', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(513, 'user511', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(514, 'user512', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(515, 'user513', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(516, 'user514', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(517, 'user515', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(518, 'user516', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(519, 'user517', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(520, 'user518', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(521, 'user519', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(522, 'user520', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(523, 'user521', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(524, 'user522', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(525, 'user523', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(526, 'user524', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(527, 'user525', 9, 1, '2019-12-08 00:30:41', '2019-12-08 00:30:41'),
(528, 'user526', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(529, 'user527', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(530, 'user528', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(531, 'user529', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(532, 'user530', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(533, 'user531', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(534, 'user532', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(535, 'user533', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(536, 'user534', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(537, 'user535', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(538, 'user536', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(539, 'user537', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(540, 'user538', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(541, 'user539', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(542, 'user540', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(543, 'user541', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(544, 'user542', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(545, 'user543', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(546, 'user544', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(547, 'user545', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(548, 'user546', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(549, 'user547', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(550, 'user548', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(551, 'user549', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(552, 'user550', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(553, 'user551', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(554, 'user552', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(555, 'user553', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(556, 'user554', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(557, 'user555', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(558, 'user556', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(559, 'user557', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(560, 'user558', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(561, 'user559', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(562, 'user560', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(563, 'user561', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(564, 'user562', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(565, 'user563', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(566, 'user564', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(567, 'user565', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(568, 'user566', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(569, 'user567', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(570, 'user568', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(571, 'user569', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(572, 'user570', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(573, 'user571', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(574, 'user572', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(575, 'user573', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(576, 'user574', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(577, 'user575', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(578, 'user576', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(579, 'user577', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(580, 'user578', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(581, 'user579', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(582, 'user580', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(583, 'user581', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(584, 'user582', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(585, 'user583', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(586, 'user584', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(587, 'user585', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(588, 'user586', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(589, 'user587', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(590, 'user588', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(591, 'user589', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(592, 'user590', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(593, 'user591', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(594, 'user592', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(595, 'user593', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(596, 'user594', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(597, 'user595', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(598, 'user596', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(599, 'user597', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(600, 'user598', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(601, 'user599', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(602, 'user600', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(603, 'user601', 9, 1, '2019-12-08 00:30:42', '2019-12-08 00:30:42'),
(604, 'user5', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(605, 'user6', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(606, 'user7', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(607, 'user8', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(608, 'user9', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(609, 'user10', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(610, 'user11', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(611, 'user12', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(612, 'user13', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(613, 'user14', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(614, 'user15', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(615, 'user16', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(616, 'user17', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(617, 'user18', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(618, 'user19', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(619, 'user20', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(620, 'user21', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(621, 'user22', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(622, 'user23', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(623, 'user24', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(624, 'user25', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(625, 'user26', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(626, 'user27', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(627, 'user28', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(628, 'user29', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(629, 'user30', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(630, 'user31', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(631, 'user32', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(632, 'user33', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(633, 'user34', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(634, 'user35', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(635, 'user36', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(636, 'user37', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(637, 'user38', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(638, 'user39', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(639, 'user40', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(640, 'user41', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(641, 'user42', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(642, 'user43', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(643, 'user44', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(644, 'user45', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(645, 'user46', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(646, 'user47', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(647, 'user48', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(648, 'user49', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(649, 'user50', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(650, 'user51', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(651, 'user52', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(652, 'user53', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(653, 'user54', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(654, 'user55', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(655, 'user56', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(656, 'user57', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(657, 'user58', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(658, 'user59', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(659, 'user60', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(660, 'user61', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(661, 'user62', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(662, 'user63', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(663, 'user64', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(664, 'user65', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(665, 'user66', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(666, 'user67', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(667, 'user68', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(668, 'user69', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(669, 'user70', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(670, 'user71', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(671, 'user72', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(672, 'user73', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(673, 'user74', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(674, 'user75', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(675, 'user76', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(676, 'user77', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(677, 'user78', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(678, 'user79', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(679, 'user80', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(680, 'user81', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(681, 'user82', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(682, 'user83', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(683, 'user84', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(684, 'user85', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(685, 'user86', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(686, 'user87', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(687, 'user88', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(688, 'user89', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(689, 'user90', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(690, 'user91', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(691, 'user92', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(692, 'user93', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(693, 'user94', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(694, 'user95', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(695, 'user96', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(696, 'user97', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(697, 'user98', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(698, 'user99', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(699, 'user100', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(700, 'user101', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(701, 'user102', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(702, 'user103', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(703, 'user104', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(704, 'user105', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(705, 'user106', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(706, 'user107', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(707, 'user108', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(708, 'user109', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(709, 'user110', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(710, 'user111', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(711, 'user112', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(712, 'user113', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(713, 'user114', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(714, 'user115', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(715, 'user116', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(716, 'user117', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(717, 'user118', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(718, 'user119', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(719, 'user120', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(720, 'user121', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(721, 'user122', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(722, 'user123', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(723, 'user124', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(724, 'user125', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(725, 'user126', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(726, 'user127', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(727, 'user128', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(728, 'user129', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(729, 'user130', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(730, 'user131', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(731, 'user132', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(732, 'user133', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(733, 'user134', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(734, 'user135', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(735, 'user136', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(736, 'user137', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(737, 'user138', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(738, 'user139', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28');
INSERT INTO `unit_enrol` (`id`, `user_id`, `unit_id`, `enable`, `create_time`, `last_upd_time`) VALUES
(739, 'user140', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(740, 'user141', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(741, 'user142', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(742, 'user143', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(743, 'user144', 7, 1, '2019-12-09 01:10:28', '2019-12-09 01:10:28'),
(744, 'user145', 7, 1, '2019-12-09 01:10:29', '2019-12-09 01:10:29'),
(745, 'user146', 7, 1, '2019-12-09 01:10:29', '2019-12-09 01:10:29'),
(746, 'user147', 7, 1, '2019-12-09 01:10:29', '2019-12-09 01:10:29'),
(747, 'user148', 7, 1, '2019-12-09 01:10:29', '2019-12-09 01:10:29'),
(748, 'user149', 7, 1, '2019-12-09 01:10:29', '2019-12-09 01:10:29'),
(749, 'user150', 7, 1, '2019-12-09 01:10:29', '2019-12-09 01:10:29');

-- --------------------------------------------------------

--
-- Table structure for table `unit_staff`
--

DROP TABLE IF EXISTS `unit_staff`;
CREATE TABLE IF NOT EXISTS `unit_staff` (
`id` int(11) NOT NULL,
  `username` varchar(10) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `unit_staff`
--

INSERT INTO `unit_staff` (`id`, `username`, `unit_id`, `create_time`, `last_upd_time`) VALUES
(1, 'staff1', 1, '2019-11-19 00:43:23', '2019-11-19 00:43:23'),
(2, 'staff1', 5, '2019-11-19 00:43:23', '2019-11-19 00:43:23'),
(3, 'staff2', 4, '2019-11-19 00:43:46', '2019-11-19 00:43:46'),
(4, 'staff2', 6, '2019-11-19 00:43:46', '2019-11-19 00:43:46');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(500) NOT NULL,
  `salt` varchar(255) NOT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `id` varchar(10) NOT NULL,
  `email` varchar(255) NOT NULL,
  `permission_level` int(11) NOT NULL DEFAULT '10',
  `locked` int(11) NOT NULL DEFAULT '0' COMMENT '0 - unlocked otherwise - locked',
  `create_time` datetime NOT NULL,
  `login_fail_cnt` int(11) NOT NULL DEFAULT '0',
  `last_login_time` datetime DEFAULT NULL,
  `reset_token` varchar(500) DEFAULT NULL,
  `reset_time` datetime DEFAULT NULL,
  `last_upd_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `salt`, `last_name`, `first_name`, `id`, `email`, `permission_level`, `locked`, `create_time`, `login_fail_cnt`, `last_login_time`, `reset_token`, `reset_time`, `last_upd_time`) VALUES
('admin', '$1$5ac36b5d$ATVyx7vRGou5dQvPdCyzU1', '$1$5ac36b5dbe8321e5f6896d0e4c402728', 'Admin', 'System', '00000000', 'chiu.97.hk@gmail.com', 90, 0, '2019-11-15 22:34:45', 0, '2019-12-16 22:24:49', NULL, NULL, '2019-12-01 00:17:48'),
('staff1', '$1$346d40d8$806o0kWTuSUlndg8x0jZ81', '$1$346d40d85be1653b1b20eee806c93967', 'Account 1', 'Staff', '03007563', 'kaichiu.wong@utas.edu.au', 30, 0, '2019-11-15 22:34:45', 0, '2019-11-26 23:10:21', NULL, NULL, '2019-11-18 01:20:02'),
('staff2', '$1$9a121110$nYumg2W2TIJBS4FyX.I111', '$1$9a121110f95b57330d829119e6b09fef', 'Account 2', 'Staff', '000000', 'teacher@aaa.com', 30, 1, '2019-11-19 00:41:38', 0, '2019-11-20 02:58:19', NULL, NULL, '2019-11-19 00:41:38'),
('staff3', '$1$f14a37c0$xSu42pAzI3/.rsvzJL05L0', '$1$f14a37c00eae2ddf8f1303f98008e11f', 'Account 3', 'Staff', '32434', 'sdffe@srewrwe.com', 30, 1, '2019-12-02 02:11:50', 0, NULL, NULL, NULL, NULL),
('staff4', '$1$2bb3309b$uhfCK4zeU7Wm.5kZrcijT/', '$1$2bb3309b3a3f88a9b0bd5b219401a379', 'Account 4', 'Staff', '1432542', 'sdsfejoi@sdofreoi.com', 30, 1, '2019-12-02 02:13:52', 0, NULL, NULL, NULL, NULL),
('user1', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'Account 1', 'Student', '492085', 'kcwong3@utas.edu.au', 10, 0, '2019-11-15 22:34:45', 0, '2019-12-16 20:58:57', NULL, NULL, '2019-11-18 01:22:08'),
('user10', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 10', 'Student', '169146', 'user10@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user100', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 100', 'Student', '899188', 'user100@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user101', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 101', 'Student', '810995', 'user101@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user102', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 102', 'Student', '454765', 'user102@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user103', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 103', 'Student', '109577', 'user103@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user104', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 104', 'Student', '525554', 'user104@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user105', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 105', 'Student', '839001', 'user105@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user106', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 106', 'Student', '746875', 'user106@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user107', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 107', 'Student', '428761', 'user107@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user108', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 108', 'Student', '217271', 'user108@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user109', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 109', 'Student', '213531', 'user109@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user11', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 11', 'Student', '145658', 'user11@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user110', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 110', 'Student', '563386', 'user110@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user111', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 111', 'Student', '940143', 'user111@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user112', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 112', 'Student', '762292', 'user112@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user113', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 113', 'Student', '709342', 'user113@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user114', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 114', 'Student', '897168', 'user114@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user115', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 115', 'Student', '593413', 'user115@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user116', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 116', 'Student', '386787', 'user116@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user117', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 117', 'Student', '797770', 'user117@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user118', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 118', 'Student', '804393', 'user118@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user119', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 119', 'Student', '458593', 'user119@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user12', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 12', 'Student', '398739', 'user12@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user120', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 120', 'Student', '723194', 'user120@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user121', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 121', 'Student', '442305', 'user121@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user122', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 122', 'Student', '920520', 'user122@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user123', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 123', 'Student', '733191', 'user123@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user124', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 124', 'Student', '963934', 'user124@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user125', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 125', 'Student', '683169', 'user125@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user126', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 126', 'Student', '953359', 'user126@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user127', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 127', 'Student', '515846', 'user127@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user128', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 128', 'Student', '962164', 'user128@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user129', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 129', 'Student', '904336', 'user129@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user13', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 13', 'Student', '459627', 'user13@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user130', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 130', 'Student', '222506', 'user130@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user131', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 131', 'Student', '230486', 'user131@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user132', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 132', 'Student', '773379', 'user132@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user133', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 133', 'Student', '346637', 'user133@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user134', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 134', 'Student', '594813', 'user134@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user135', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 135', 'Student', '133429', 'user135@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user136', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 136', 'Student', '104999', 'user136@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user137', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 137', 'Student', '471149', 'user137@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user138', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 138', 'Student', '685977', 'user138@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user139', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 139', 'Student', '964285', 'user139@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user14', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 14', 'Student', '128224', 'user14@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user140', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 140', 'Student', '778850', 'user140@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user141', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 141', 'Student', '393114', 'user141@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user142', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 142', 'Student', '419517', 'user142@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user143', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 143', 'Student', '959431', 'user143@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user144', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 144', 'Student', '867666', 'user144@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user145', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 145', 'Student', '604786', 'user145@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user146', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 146', 'Student', '436528', 'user146@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user147', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 147', 'Student', '596907', 'user147@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user148', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 148', 'Student', '213726', 'user148@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user149', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 149', 'Student', '245991', 'user149@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user15', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 15', 'Student', '828885', 'user15@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user150', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 150', 'Student', '782630', 'user150@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user151', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 151', 'Student', '867100', 'user151@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user152', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 152', 'Student', '102812', 'user152@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user153', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 153', 'Student', '839619', 'user153@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user154', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 154', 'Student', '205116', 'user154@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user155', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 155', 'Student', '807379', 'user155@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user156', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 156', 'Student', '691311', 'user156@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user157', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 157', 'Student', '498532', 'user157@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user158', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 158', 'Student', '913641', 'user158@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user159', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 159', 'Student', '178589', 'user159@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user16', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 16', 'Student', '568740', 'user16@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user160', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 160', 'Student', '632411', 'user160@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user161', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 161', 'Student', '201359', 'user161@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user162', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 162', 'Student', '778239', 'user162@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user163', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 163', 'Student', '934004', 'user163@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user164', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 164', 'Student', '631297', 'user164@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user165', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 165', 'Student', '215261', 'user165@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user166', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 166', 'Student', '688584', 'user166@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user167', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 167', 'Student', '806805', 'user167@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user168', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 168', 'Student', '342007', 'user168@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user169', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 169', 'Student', '119823', 'user169@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user17', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 17', 'Student', '841651', 'user17@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user170', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 170', 'Student', '765714', 'user170@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user171', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 171', 'Student', '964346', 'user171@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user172', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 172', 'Student', '705278', 'user172@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user173', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 173', 'Student', '589165', 'user173@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user174', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 174', 'Student', '916146', 'user174@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user175', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 175', 'Student', '161752', 'user175@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user176', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 176', 'Student', '326573', 'user176@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user177', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 177', 'Student', '850657', 'user177@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user178', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 178', 'Student', '681915', 'user178@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user179', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 179', 'Student', '929202', 'user179@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user18', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 18', 'Student', '775777', 'user18@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user180', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 180', 'Student', '667238', 'user180@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user181', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 181', 'Student', '250436', 'user181@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user182', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 182', 'Student', '758040', 'user182@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user183', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 183', 'Student', '698719', 'user183@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user184', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 184', 'Student', '804355', 'user184@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user185', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 185', 'Student', '859164', 'user185@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user186', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 186', 'Student', '290985', 'user186@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user187', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 187', 'Student', '161528', 'user187@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user188', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 188', 'Student', '326777', 'user188@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user189', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 189', 'Student', '462156', 'user189@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user19', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 19', 'Student', '408525', 'user19@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user190', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 190', 'Student', '657987', 'user190@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user191', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 191', 'Student', '656722', 'user191@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user192', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 192', 'Student', '248648', 'user192@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user193', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 193', 'Student', '651608', 'user193@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user194', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 194', 'Student', '270885', 'user194@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user195', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 195', 'Student', '155588', 'user195@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user196', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 196', 'Student', '345279', 'user196@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user197', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 197', 'Student', '281371', 'user197@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user198', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 198', 'Student', '636178', 'user198@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user199', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 199', 'Student', '772320', 'user199@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user2', '$1$0110f9d0$e7cdlWJmv.Psg8NoUmuDc1', '$1$0110f9d01bee0c30e7e11e7653b64f56', 'Account 2', 'Student', '432992', 'empty@empty.com', 10, 0, '2019-11-18 01:06:33', 0, '2019-12-16 02:29:13', NULL, NULL, '2019-11-19 00:17:03'),
('user20', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 20', 'Student', '885180', 'user20@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user200', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 200', 'Student', '666493', 'user200@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user201', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 201', 'Student', '811069', 'user201@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user202', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 202', 'Student', '387986', 'user202@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user203', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 203', 'Student', '571023', 'user203@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user204', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 204', 'Student', '507460', 'user204@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user205', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 205', 'Student', '410450', 'user205@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user206', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 206', 'Student', '611120', 'user206@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user207', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 207', 'Student', '281117', 'user207@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user208', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 208', 'Student', '890218', 'user208@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user209', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 209', 'Student', '668014', 'user209@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user21', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 21', 'Student', '990224', 'user21@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user210', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 210', 'Student', '440737', 'user210@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user211', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 211', 'Student', '388692', 'user211@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user212', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 212', 'Student', '799911', 'user212@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user213', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 213', 'Student', '976204', 'user213@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user214', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 214', 'Student', '155769', 'user214@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user215', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 215', 'Student', '441180', 'user215@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user216', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 216', 'Student', '688905', 'user216@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user217', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 217', 'Student', '909958', 'user217@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user218', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 218', 'Student', '299515', 'user218@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user219', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 219', 'Student', '843496', 'user219@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user22', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 22', 'Student', '132769', 'user22@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user220', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 220', 'Student', '861821', 'user220@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user221', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 221', 'Student', '192273', 'user221@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user222', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 222', 'Student', '311787', 'user222@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user223', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 223', 'Student', '690270', 'user223@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user224', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 224', 'Student', '573155', 'user224@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user225', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 225', 'Student', '126487', 'user225@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user226', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 226', 'Student', '907407', 'user226@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user227', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 227', 'Student', '307303', 'user227@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user228', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 228', 'Student', '268414', 'user228@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user229', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 229', 'Student', '803166', 'user229@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user23', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 23', 'Student', '334590', 'user23@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user230', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 230', 'Student', '220070', 'user230@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user231', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 231', 'Student', '563024', 'user231@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user232', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 232', 'Student', '967501', 'user232@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user233', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 233', 'Student', '594145', 'user233@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user234', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 234', 'Student', '663198', 'user234@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user235', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 235', 'Student', '649729', 'user235@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user236', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 236', 'Student', '891679', 'user236@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user237', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 237', 'Student', '946937', 'user237@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user238', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 238', 'Student', '696229', 'user238@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user239', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 239', 'Student', '540017', 'user239@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user24', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 24', 'Student', '360501', 'user24@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user240', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 240', 'Student', '673865', 'user240@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user241', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 241', 'Student', '890024', 'user241@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user242', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 242', 'Student', '830193', 'user242@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user243', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 243', 'Student', '465894', 'user243@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user244', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 244', 'Student', '355737', 'user244@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user245', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 245', 'Student', '190085', 'user245@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user246', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 246', 'Student', '136913', 'user246@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user247', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 247', 'Student', '557213', 'user247@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user248', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 248', 'Student', '741313', 'user248@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user249', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 249', 'Student', '451372', 'user249@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user25', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 25', 'Student', '348826', 'user25@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user250', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 250', 'Student', '124050', 'user250@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user251', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 251', 'Student', '844613', 'user251@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user252', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 252', 'Student', '743196', 'user252@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user253', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 253', 'Student', '791287', 'user253@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user254', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 254', 'Student', '871699', 'user254@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user255', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 255', 'Student', '955218', 'user255@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user256', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 256', 'Student', '394813', 'user256@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user257', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 257', 'Student', '107231', 'user257@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user258', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 258', 'Student', '756186', 'user258@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user259', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 259', 'Student', '249236', 'user259@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user26', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 26', 'Student', '529539', 'user26@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user260', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 260', 'Student', '978776', 'user260@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user261', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 261', 'Student', '486864', 'user261@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user262', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 262', 'Student', '552434', 'user262@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user263', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 263', 'Student', '368070', 'user263@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user264', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 264', 'Student', '650886', 'user264@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user265', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 265', 'Student', '907101', 'user265@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user266', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 266', 'Student', '142236', 'user266@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user267', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 267', 'Student', '875080', 'user267@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user268', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 268', 'Student', '484203', 'user268@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user269', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 269', 'Student', '483422', 'user269@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user27', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 27', 'Student', '609674', 'user27@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user270', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 270', 'Student', '836213', 'user270@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user271', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 271', 'Student', '524464', 'user271@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user272', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 272', 'Student', '190859', 'user272@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user273', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 273', 'Student', '269934', 'user273@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user274', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 274', 'Student', '199121', 'user274@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user275', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 275', 'Student', '202210', 'user275@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user276', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 276', 'Student', '748966', 'user276@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user277', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 277', 'Student', '814544', 'user277@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user278', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 278', 'Student', '352700', 'user278@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user279', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 279', 'Student', '273567', 'user279@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user28', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 28', 'Student', '104735', 'user28@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user280', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 280', 'Student', '870698', 'user280@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user281', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 281', 'Student', '807457', 'user281@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user282', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 282', 'Student', '255574', 'user282@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user283', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 283', 'Student', '362826', 'user283@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user284', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 284', 'Student', '571187', 'user284@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user285', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 285', 'Student', '436114', 'user285@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user286', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 286', 'Student', '211354', 'user286@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user287', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 287', 'Student', '314783', 'user287@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user288', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 288', 'Student', '724043', 'user288@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user289', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 289', 'Student', '600545', 'user289@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user29', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 29', 'Student', '939427', 'user29@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user290', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 290', 'Student', '402411', 'user290@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user291', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 291', 'Student', '885523', 'user291@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user292', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 292', 'Student', '108415', 'user292@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user293', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 293', 'Student', '521698', 'user293@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user294', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 294', 'Student', '882514', 'user294@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user295', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 295', 'Student', '153969', 'user295@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user296', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 296', 'Student', '311384', 'user296@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user297', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 297', 'Student', '749364', 'user297@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user298', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 298', 'Student', '906206', 'user298@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user299', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 299', 'Student', '647160', 'user299@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user3', '$1$4b385781$PO.BeSuXiWmS36bOu7sRK0', '$1$4b38578106353e38c43cff55a99d5a5f', 'Account 3', 'Student', '212321', 'a@a.com', 10, 0, '2019-11-18 00:58:38', 0, '2019-12-16 02:31:52', NULL, NULL, '2019-11-19 00:17:22'),
('user30', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 30', 'Student', '623531', 'user30@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user300', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 300', 'Student', '574940', 'user300@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user301', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 301', 'Student', '330458', 'user301@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user302', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 302', 'Student', '468183', 'user302@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00');
INSERT INTO `user` (`username`, `password`, `salt`, `last_name`, `first_name`, `id`, `email`, `permission_level`, `locked`, `create_time`, `login_fail_cnt`, `last_login_time`, `reset_token`, `reset_time`, `last_upd_time`) VALUES
('user303', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 303', 'Student', '240405', 'user303@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user304', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 304', 'Student', '446527', 'user304@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user305', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 305', 'Student', '532724', 'user305@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user306', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 306', 'Student', '893889', 'user306@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user307', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 307', 'Student', '402519', 'user307@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user308', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 308', 'Student', '708750', 'user308@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user309', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 309', 'Student', '631775', 'user309@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user31', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 31', 'Student', '794422', 'user31@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user310', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 310', 'Student', '479528', 'user310@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user311', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 311', 'Student', '126789', 'user311@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user312', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 312', 'Student', '974105', 'user312@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user313', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 313', 'Student', '929184', 'user313@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user314', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 314', 'Student', '902207', 'user314@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user315', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 315', 'Student', '838738', 'user315@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user316', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 316', 'Student', '951743', 'user316@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user317', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 317', 'Student', '812756', 'user317@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user318', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 318', 'Student', '925131', 'user318@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user319', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 319', 'Student', '691574', 'user319@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user32', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 32', 'Student', '137790', 'user32@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user320', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 320', 'Student', '384249', 'user320@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user321', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 321', 'Student', '101986', 'user321@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user322', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 322', 'Student', '510765', 'user322@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user323', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 323', 'Student', '808897', 'user323@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user324', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 324', 'Student', '594512', 'user324@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user325', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 325', 'Student', '974366', 'user325@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user326', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 326', 'Student', '171096', 'user326@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user327', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 327', 'Student', '571693', 'user327@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user328', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 328', 'Student', '149929', 'user328@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user329', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 329', 'Student', '430721', 'user329@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user33', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 33', 'Student', '885939', 'user33@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user330', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 330', 'Student', '477116', 'user330@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user331', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 331', 'Student', '558854', 'user331@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user332', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 332', 'Student', '551713', 'user332@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user333', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 333', 'Student', '812814', 'user333@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user334', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 334', 'Student', '109006', 'user334@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user335', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 335', 'Student', '358367', 'user335@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user336', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 336', 'Student', '553555', 'user336@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user337', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 337', 'Student', '695174', 'user337@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user338', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 338', 'Student', '609804', 'user338@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user339', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 339', 'Student', '280687', 'user339@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user34', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 34', 'Student', '255647', 'user34@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user340', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 340', 'Student', '187262', 'user340@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user341', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 341', 'Student', '663205', 'user341@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user342', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 342', 'Student', '353929', 'user342@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user343', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 343', 'Student', '138975', 'user343@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user344', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 344', 'Student', '852199', 'user344@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user345', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 345', 'Student', '652707', 'user345@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user346', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 346', 'Student', '462923', 'user346@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user347', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 347', 'Student', '157077', 'user347@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user348', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 348', 'Student', '114334', 'user348@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user349', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 349', 'Student', '290338', 'user349@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user35', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 35', 'Student', '899118', 'user35@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user350', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 350', 'Student', '469603', 'user350@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user351', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 351', 'Student', '206009', 'user351@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user352', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 352', 'Student', '314033', 'user352@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user353', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 353', 'Student', '534247', 'user353@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user354', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 354', 'Student', '585432', 'user354@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user355', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 355', 'Student', '502580', 'user355@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user356', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 356', 'Student', '635827', 'user356@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user357', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 357', 'Student', '903295', 'user357@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user358', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 358', 'Student', '768229', 'user358@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user359', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 359', 'Student', '178691', 'user359@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user36', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 36', 'Student', '350492', 'user36@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user360', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 360', 'Student', '249606', 'user360@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user361', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 361', 'Student', '292208', 'user361@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user362', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 362', 'Student', '949459', 'user362@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user363', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 363', 'Student', '900187', 'user363@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user364', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 364', 'Student', '484262', 'user364@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user365', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 365', 'Student', '656382', 'user365@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user366', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 366', 'Student', '411139', 'user366@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user367', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 367', 'Student', '587477', 'user367@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user368', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 368', 'Student', '633844', 'user368@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user369', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 369', 'Student', '836867', 'user369@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user37', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 37', 'Student', '893179', 'user37@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user370', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 370', 'Student', '123277', 'user370@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user371', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 371', 'Student', '919439', 'user371@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user372', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 372', 'Student', '838891', 'user372@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user373', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 373', 'Student', '509598', 'user373@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user374', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 374', 'Student', '684818', 'user374@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user375', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 375', 'Student', '264356', 'user375@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user376', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 376', 'Student', '320839', 'user376@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user377', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 377', 'Student', '309817', 'user377@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user378', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 378', 'Student', '197296', 'user378@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user379', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 379', 'Student', '618290', 'user379@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user38', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 38', 'Student', '701291', 'user38@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user380', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 380', 'Student', '716532', 'user380@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user381', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 381', 'Student', '728090', 'user381@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user382', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 382', 'Student', '573441', 'user382@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user383', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 383', 'Student', '606485', 'user383@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user384', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 384', 'Student', '452317', 'user384@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user385', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 385', 'Student', '642738', 'user385@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user386', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 386', 'Student', '104611', 'user386@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user387', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 387', 'Student', '851126', 'user387@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user388', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 388', 'Student', '298068', 'user388@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user389', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 389', 'Student', '228514', 'user389@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user39', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 39', 'Student', '411431', 'user39@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user390', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 390', 'Student', '459540', 'user390@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user391', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 391', 'Student', '114312', 'user391@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user392', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 392', 'Student', '809781', 'user392@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user393', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 393', 'Student', '241973', 'user393@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user394', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 394', 'Student', '187116', 'user394@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user395', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 395', 'Student', '134725', 'user395@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user396', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 396', 'Student', '122569', 'user396@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user397', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 397', 'Student', '216657', 'user397@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user398', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 398', 'Student', '727307', 'user398@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user399', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 399', 'Student', '232537', 'user399@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user4', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 4', 'Student', '123456', 'user4@abc.com', 10, 1, '2019-12-08 00:24:57', 0, NULL, NULL, NULL, '2019-12-08 00:24:57'),
('user40', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 40', 'Student', '578555', 'user40@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user400', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 400', 'Student', '666069', 'user400@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user401', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 401', 'Student', '799158', 'user401@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user402', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 402', 'Student', '591368', 'user402@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user403', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 403', 'Student', '525387', 'user403@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user404', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 404', 'Student', '484032', 'user404@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user405', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 405', 'Student', '113283', 'user405@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user406', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 406', 'Student', '382030', 'user406@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user407', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 407', 'Student', '768637', 'user407@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user408', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 408', 'Student', '976211', 'user408@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user409', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 409', 'Student', '693256', 'user409@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user41', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 41', 'Student', '779837', 'user41@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user410', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 410', 'Student', '159477', 'user410@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user411', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 411', 'Student', '568206', 'user411@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user412', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 412', 'Student', '633047', 'user412@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user413', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 413', 'Student', '383760', 'user413@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user414', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 414', 'Student', '529314', 'user414@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user415', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 415', 'Student', '789974', 'user415@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user416', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 416', 'Student', '876607', 'user416@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user417', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 417', 'Student', '524776', 'user417@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user418', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 418', 'Student', '748830', 'user418@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user419', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 419', 'Student', '305933', 'user419@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user42', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 42', 'Student', '292812', 'user42@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user420', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 420', 'Student', '218274', 'user420@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user421', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 421', 'Student', '746198', 'user421@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user422', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 422', 'Student', '463970', 'user422@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user423', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 423', 'Student', '423961', 'user423@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user424', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 424', 'Student', '440456', 'user424@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user425', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 425', 'Student', '318462', 'user425@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user426', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 426', 'Student', '185517', 'user426@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user427', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 427', 'Student', '618282', 'user427@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user428', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 428', 'Student', '627965', 'user428@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user429', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 429', 'Student', '664062', 'user429@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user43', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 43', 'Student', '866575', 'user43@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user430', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 430', 'Student', '814188', 'user430@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user431', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 431', 'Student', '184059', 'user431@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user432', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 432', 'Student', '305836', 'user432@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user433', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 433', 'Student', '634898', 'user433@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user434', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 434', 'Student', '622485', 'user434@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user435', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 435', 'Student', '231871', 'user435@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user436', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 436', 'Student', '439241', 'user436@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user437', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 437', 'Student', '604197', 'user437@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user438', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 438', 'Student', '767990', 'user438@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user439', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 439', 'Student', '959456', 'user439@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user44', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 44', 'Student', '613311', 'user44@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user440', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 440', 'Student', '765064', 'user440@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user441', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 441', 'Student', '734632', 'user441@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user442', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 442', 'Student', '295583', 'user442@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user443', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 443', 'Student', '155928', 'user443@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user444', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 444', 'Student', '611782', 'user444@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user445', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 445', 'Student', '671975', 'user445@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user446', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 446', 'Student', '420982', 'user446@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user447', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 447', 'Student', '258210', 'user447@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user448', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 448', 'Student', '922006', 'user448@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user449', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 449', 'Student', '325751', 'user449@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user45', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 45', 'Student', '982497', 'user45@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user450', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 450', 'Student', '154308', 'user450@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user451', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 451', 'Student', '928694', 'user451@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user452', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 452', 'Student', '170103', 'user452@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user453', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 453', 'Student', '943682', 'user453@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user454', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 454', 'Student', '877791', 'user454@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user455', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 455', 'Student', '714804', 'user455@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user456', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 456', 'Student', '770995', 'user456@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user457', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 457', 'Student', '736056', 'user457@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user458', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 458', 'Student', '209165', 'user458@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user459', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 459', 'Student', '868626', 'user459@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user46', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 46', 'Student', '452459', 'user46@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user460', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 460', 'Student', '525732', 'user460@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user461', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 461', 'Student', '850915', 'user461@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user462', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 462', 'Student', '248212', 'user462@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user463', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 463', 'Student', '638842', 'user463@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user464', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 464', 'Student', '261832', 'user464@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user465', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 465', 'Student', '104387', 'user465@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user466', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 466', 'Student', '666291', 'user466@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user467', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 467', 'Student', '951679', 'user467@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user468', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 468', 'Student', '632581', 'user468@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user469', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 469', 'Student', '544268', 'user469@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user47', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 47', 'Student', '995596', 'user47@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user470', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 470', 'Student', '147960', 'user470@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user471', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 471', 'Student', '321046', 'user471@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user472', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 472', 'Student', '757519', 'user472@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user473', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 473', 'Student', '517075', 'user473@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user474', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 474', 'Student', '437411', 'user474@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user475', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 475', 'Student', '262257', 'user475@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user476', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 476', 'Student', '101570', 'user476@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user477', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 477', 'Student', '130851', 'user477@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user478', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 478', 'Student', '518168', 'user478@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user479', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 479', 'Student', '527165', 'user479@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user48', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 48', 'Student', '850430', 'user48@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user480', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 480', 'Student', '604419', 'user480@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user481', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 481', 'Student', '221167', 'user481@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user482', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 482', 'Student', '311826', 'user482@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user483', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 483', 'Student', '361230', 'user483@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user484', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 484', 'Student', '100256', 'user484@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user485', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 485', 'Student', '341679', 'user485@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user486', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 486', 'Student', '453791', 'user486@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user487', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 487', 'Student', '971034', 'user487@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user488', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 488', 'Student', '150040', 'user488@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user489', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 489', 'Student', '948822', 'user489@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user49', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 49', 'Student', '360729', 'user49@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user490', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 490', 'Student', '936433', 'user490@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user491', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 491', 'Student', '971461', 'user491@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user492', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 492', 'Student', '868611', 'user492@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user493', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 493', 'Student', '544683', 'user493@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user494', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 494', 'Student', '682037', 'user494@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user495', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 495', 'Student', '521186', 'user495@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user496', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 496', 'Student', '377646', 'user496@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user497', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 497', 'Student', '205119', 'user497@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user498', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 498', 'Student', '990772', 'user498@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user499', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 499', 'Student', '845329', 'user499@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user5', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 5', 'Student', '608771', 'user5@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user50', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 50', 'Student', '522635', 'user50@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user500', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 500', 'Student', '436603', 'user500@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user501', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 501', 'Student', '891702', 'user501@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user502', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 502', 'Student', '308439', 'user502@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user503', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 503', 'Student', '448767', 'user503@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user504', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 504', 'Student', '384854', 'user504@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user505', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 505', 'Student', '469998', 'user505@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user506', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 506', 'Student', '147799', 'user506@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user507', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 507', 'Student', '133769', 'user507@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user508', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 508', 'Student', '804850', 'user508@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user509', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 509', 'Student', '920932', 'user509@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user51', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 51', 'Student', '821986', 'user51@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user510', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 510', 'Student', '984107', 'user510@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user511', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 511', 'Student', '870423', 'user511@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01');
INSERT INTO `user` (`username`, `password`, `salt`, `last_name`, `first_name`, `id`, `email`, `permission_level`, `locked`, `create_time`, `login_fail_cnt`, `last_login_time`, `reset_token`, `reset_time`, `last_upd_time`) VALUES
('user512', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 512', 'Student', '859822', 'user512@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user513', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 513', 'Student', '816845', 'user513@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user514', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 514', 'Student', '353906', 'user514@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user515', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 515', 'Student', '403470', 'user515@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user516', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 516', 'Student', '327467', 'user516@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user517', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 517', 'Student', '199350', 'user517@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user518', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 518', 'Student', '131384', 'user518@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user519', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 519', 'Student', '646664', 'user519@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user52', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 52', 'Student', '503579', 'user52@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user520', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 520', 'Student', '813307', 'user520@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user521', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 521', 'Student', '928374', 'user521@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user522', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 522', 'Student', '358419', 'user522@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user523', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 523', 'Student', '868939', 'user523@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user524', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 524', 'Student', '539643', 'user524@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user525', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 525', 'Student', '119348', 'user525@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user526', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 526', 'Student', '761939', 'user526@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user527', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 527', 'Student', '310107', 'user527@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user528', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 528', 'Student', '640422', 'user528@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user529', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 529', 'Student', '493578', 'user529@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user53', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 53', 'Student', '775988', 'user53@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user530', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 530', 'Student', '862627', 'user530@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user531', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 531', 'Student', '648308', 'user531@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user532', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 532', 'Student', '635209', 'user532@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user533', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 533', 'Student', '455789', 'user533@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user534', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 534', 'Student', '729760', 'user534@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user535', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 535', 'Student', '167863', 'user535@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user536', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 536', 'Student', '526064', 'user536@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user537', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 537', 'Student', '331360', 'user537@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user538', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 538', 'Student', '985285', 'user538@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user539', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 539', 'Student', '798799', 'user539@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user54', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 54', 'Student', '563451', 'user54@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user540', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 540', 'Student', '555758', 'user540@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user541', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 541', 'Student', '502827', 'user541@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user542', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 542', 'Student', '971393', 'user542@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user543', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 543', 'Student', '924209', 'user543@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user544', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 544', 'Student', '924612', 'user544@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user545', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 545', 'Student', '266209', 'user545@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user546', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 546', 'Student', '803204', 'user546@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user547', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 547', 'Student', '129378', 'user547@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user548', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 548', 'Student', '810096', 'user548@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user549', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 549', 'Student', '677821', 'user549@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user55', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 55', 'Student', '961002', 'user55@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user550', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 550', 'Student', '766426', 'user550@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user551', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 551', 'Student', '567570', 'user551@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user552', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 552', 'Student', '339611', 'user552@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user553', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 553', 'Student', '397399', 'user553@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user554', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 554', 'Student', '186541', 'user554@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user555', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 555', 'Student', '715733', 'user555@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user556', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 556', 'Student', '450374', 'user556@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user557', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 557', 'Student', '261079', 'user557@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user558', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 558', 'Student', '170436', 'user558@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user559', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 559', 'Student', '993109', 'user559@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user56', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 56', 'Student', '669118', 'user56@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user560', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 560', 'Student', '715460', 'user560@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user561', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 561', 'Student', '520600', 'user561@abc.com', 10, 1, '2019-12-08 00:28:01', 0, NULL, NULL, NULL, '2019-12-08 00:28:01'),
('user562', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 562', 'Student', '487829', 'user562@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user563', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 563', 'Student', '360362', 'user563@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user564', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 564', 'Student', '274075', 'user564@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user565', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 565', 'Student', '401077', 'user565@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user566', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 566', 'Student', '373202', 'user566@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user567', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 567', 'Student', '279598', 'user567@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user568', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 568', 'Student', '435372', 'user568@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user569', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 569', 'Student', '319826', 'user569@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user57', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 57', 'Student', '561558', 'user57@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user570', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 570', 'Student', '451057', 'user570@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user571', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 571', 'Student', '739926', 'user571@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user572', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 572', 'Student', '736077', 'user572@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user573', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 573', 'Student', '171674', 'user573@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user574', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 574', 'Student', '402131', 'user574@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user575', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 575', 'Student', '638023', 'user575@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user576', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 576', 'Student', '301821', 'user576@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user577', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 577', 'Student', '566758', 'user577@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user578', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 578', 'Student', '395683', 'user578@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user579', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 579', 'Student', '428052', 'user579@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user58', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 58', 'Student', '749630', 'user58@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user580', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 580', 'Student', '233648', 'user580@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user581', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 581', 'Student', '404190', 'user581@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user582', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 582', 'Student', '223579', 'user582@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user583', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 583', 'Student', '594611', 'user583@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user584', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 584', 'Student', '865682', 'user584@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user585', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 585', 'Student', '309442', 'user585@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user586', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 586', 'Student', '508312', 'user586@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user587', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 587', 'Student', '921605', 'user587@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user588', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 588', 'Student', '902130', 'user588@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user589', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 589', 'Student', '237883', 'user589@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user59', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 59', 'Student', '186853', 'user59@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user590', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 590', 'Student', '531278', 'user590@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user591', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 591', 'Student', '243843', 'user591@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user592', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 592', 'Student', '651925', 'user592@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user593', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 593', 'Student', '946672', 'user593@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user594', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 594', 'Student', '772472', 'user594@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user595', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 595', 'Student', '717919', 'user595@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user596', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 596', 'Student', '911265', 'user596@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user597', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 597', 'Student', '328134', 'user597@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user598', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 598', 'Student', '669807', 'user598@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user599', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 599', 'Student', '923634', 'user599@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user6', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 6', 'Student', '586473', 'user6@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user60', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 60', 'Student', '378604', 'user60@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user600', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 600', 'Student', '531365', 'user600@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user601', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 601', 'Student', '161756', 'user601@abc.com', 10, 1, '2019-12-08 00:28:02', 0, NULL, NULL, NULL, '2019-12-08 00:28:02'),
('user61', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 61', 'Student', '868283', 'user61@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user62', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 62', 'Student', '196294', 'user62@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user63', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 63', 'Student', '615913', 'user63@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user64', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 64', 'Student', '258748', 'user64@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user65', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 65', 'Student', '815096', 'user65@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user66', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 66', 'Student', '943156', 'user66@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user67', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 67', 'Student', '857318', 'user67@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user68', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 68', 'Student', '732773', 'user68@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user69', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 69', 'Student', '945311', 'user69@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user7', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 7', 'Student', '562722', 'user7@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user70', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 70', 'Student', '786713', 'user70@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user71', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 71', 'Student', '647697', 'user71@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user72', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 72', 'Student', '821766', 'user72@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user73', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 73', 'Student', '123925', 'user73@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user74', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 74', 'Student', '823677', 'user74@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user75', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 75', 'Student', '373063', 'user75@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user76', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 76', 'Student', '397210', 'user76@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user77', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 77', 'Student', '295923', 'user77@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user78', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 78', 'Student', '832130', 'user78@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user79', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 79', 'Student', '568901', 'user79@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user8', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 8', 'Student', '569150', 'user8@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user80', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 80', 'Student', '787125', 'user80@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user81', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 81', 'Student', '553631', 'user81@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user82', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 82', 'Student', '617669', 'user82@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user83', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 83', 'Student', '905911', 'user83@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user84', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 84', 'Student', '966293', 'user84@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user85', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 85', 'Student', '185875', 'user85@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user86', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 86', 'Student', '852259', 'user86@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user87', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 87', 'Student', '475579', 'user87@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user88', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 88', 'Student', '359309', 'user88@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user89', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 89', 'Student', '123604', 'user89@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user9', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 9', 'Student', '290104', 'user9@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user90', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 90', 'Student', '956482', 'user90@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user91', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 91', 'Student', '455040', 'user91@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user92', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 92', 'Student', '675126', 'user92@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user93', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 93', 'Student', '882043', 'user93@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user94', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 94', 'Student', '196186', 'user94@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user95', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 95', 'Student', '229437', 'user95@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user96', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 96', 'Student', '419011', 'user96@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user97', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 97', 'Student', '520481', 'user97@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user98', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 98', 'Student', '952935', 'user98@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00'),
('user99', '$1$df0a73e8$WyrXqMoF/1JoBjlBjxWFm.', '$1$df0a73e89e983b8795dc92c444966339', 'User 99', 'Student', '565447', 'user99@abc.com', 10, 1, '2019-12-08 00:28:00', 0, NULL, NULL, NULL, '2019-12-08 00:28:00');

-- --------------------------------------------------------

--
-- Structure for view `sv_assignemnt_student`
--
DROP TABLE IF EXISTS `sv_assignemnt_student`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignemnt_student` AS select distinct `ue`.`id` AS `id`,`a`.`id` AS `asg_id`,`a`.`title` AS `asg_title`,`un`.`id` AS `unit_id`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`u`.`username` AS `username`,`u`.`email` AS `email`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid` from (((`assignment` `a` join `unit_enrol` `ue`) join `unit` `un`) join `user` `u`) where ((`a`.`unit_id` = `un`.`id`) and (`un`.`id` = `ue`.`unit_id`) and (`ue`.`user_id` = `u`.`username`));

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_staff`
--
DROP TABLE IF EXISTS `sv_assignment_staff`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_staff` AS select `a`.`id` AS `id`,`a`.`title` AS `title`,`a`.`type` AS `type`,`st`.`topic_count` AS `topic_count`,`au`.`student_count` AS `student_count`,`a`.`outcome` AS `outcome`,`a`.`scenario` AS `scenario`,`a`.`unit_id` AS `unit_id`,`a`.`create_time` AS `create_time`,`a`.`last_upd_time` AS `last_upd_time`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`u`.`username` AS `username`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid`,`u`.`email` AS `email`,`u`.`permission_level` AS `permission_level` from (((((`assignment` `a` left join `unit_staff` `us` on((`a`.`unit_id` = `us`.`unit_id`))) left join `unit` `un` on((`a`.`unit_id` = `un`.`id`))) left join `user` `u` on((`us`.`username` = `u`.`username`))) left join `sv_assignment_topic_count` `st` on((`a`.`id` = `st`.`id`))) left join `sv_assignment_student_count` `au` on((`a`.`id` = `au`.`id`)));

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_student_count`
--
DROP TABLE IF EXISTS `sv_assignment_student_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_student_count` AS select `a`.`id` AS `id`,count(`ue`.`user_id`) AS `student_count` from (`assignment` `a` left join `unit_enrol` `ue` on((`a`.`unit_id` = `ue`.`unit_id`))) group by `a`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_topic_count`
--
DROP TABLE IF EXISTS `sv_assignment_topic_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_topic_count` AS select `a`.`id` AS `id`,count(`t`.`id`) AS `topic_count` from (`assignment` `a` left join `assignment_topic` `t` on((`a`.`id` = `t`.`assign_id`))) group by `a`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_topic_member`
--
DROP TABLE IF EXISTS `sv_assignment_topic_member`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_topic_member` AS select `ata`.`id` AS `id`,`ata`.`asg_id` AS `asg_id`,`ata`.`user_id` AS `user_id`,`ata`.`topic_id` AS `topic_id`,`ata`.`create_time` AS `create_time`,`ata`.`last_upd_time` AS `last_upd_time`,`u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`u`.`id` AS `sid`,`u`.`email` AS `email` from (`assignment_topic_allocation` `ata` join `user` `u`) where (`ata`.`user_id` = `u`.`username`);

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_topic_summary`
--
DROP TABLE IF EXISTS `sv_assignment_topic_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_topic_summary` AS select `ata`.`id` AS `id`,`ata`.`user_id` AS `user_id`,`ata`.`topic_id` AS `topic_id`,`t`.`assign_id` AS `assign_id`,`t`.`topic` AS `topic`,`t`.`topic_desc` AS `topic_desc` from (`assignment_topic_allocation` `ata` join `assignment_topic` `t`) where (`t`.`id` = `ata`.`topic_id`);

-- --------------------------------------------------------

--
-- Structure for view `sv_topic_stat`
--
DROP TABLE IF EXISTS `sv_topic_stat`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_topic_stat` AS select `a`.`id` AS `id`,count(`ata`.`topic_id`) AS `cnt` from (`assignment_topic` `a` left join `assignment_topic_allocation` `ata` on((`a`.`id` = `ata`.`topic_id`))) group by `a`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `sv_unit_staff`
--
DROP TABLE IF EXISTS `sv_unit_staff`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_unit_staff` AS select `un`.`id` AS `id`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`un`.`create_time` AS `create_time`,`un`.`last_upd_time` AS `last_upd_time`,`u`.`username` AS `username`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid`,`u`.`email` AS `email`,`u`.`permission_level` AS `permission_level` from ((`unit` `un` join `unit_staff` `us`) join `user` `u`) where ((`un`.`id` = `us`.`unit_id`) and (`us`.`username` = `u`.`username`));

-- --------------------------------------------------------

--
-- Structure for view `sv_unit_student`
--
DROP TABLE IF EXISTS `sv_unit_student`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_unit_student` AS select `u`.`username` AS `username`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid`,`u`.`email` AS `email`,`u`.`permission_level` AS `permission_level`,`un`.`id` AS `id`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`un`.`create_time` AS `create_time`,`un`.`last_upd_time` AS `last_upd_time` from ((`unit` `un` join `unit_enrol` `ue`) join `user` `u`) where ((`un`.`id` = `ue`.`unit_id`) and (`ue`.`user_id` = `u`.`username`)) order by `u`.`username`,`un`.`unit_code`;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignment`
--
ALTER TABLE `assignment`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assignment_deadline`
--
ALTER TABLE `assignment_deadline`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`);

--
-- Indexes for table `assignment_feedback`
--
ALTER TABLE `assignment_feedback`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`), ADD KEY `question_id` (`question_id`), ADD KEY `reviewer` (`reviewer`), ADD KEY `reviewee` (`reviewee`);

--
-- Indexes for table `assignment_mark_criteria`
--
ALTER TABLE `assignment_mark_criteria`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`);

--
-- Indexes for table `assignment_question`
--
ALTER TABLE `assignment_question`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`);

--
-- Indexes for table `assignment_topic`
--
ALTER TABLE `assignment_topic`
 ADD PRIMARY KEY (`id`), ADD KEY `assign_id` (`assign_id`);

--
-- Indexes for table `assignment_topic_allocation`
--
ALTER TABLE `assignment_topic_allocation`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`), ADD KEY `user_id` (`user_id`), ADD KEY `topic_id` (`topic_id`);

--
-- Indexes for table `submission`
--
ALTER TABLE `submission`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`), ADD KEY `user_id` (`user_id`), ADD KEY `topic_id` (`topic_id`);

--
-- Indexes for table `submission_log`
--
ALTER TABLE `submission_log`
 ADD KEY `asg_id` (`asg_id`,`user_id`);

--
-- Indexes for table `unit`
--
ALTER TABLE `unit`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `unit_enrol`
--
ALTER TABLE `unit_enrol`
 ADD PRIMARY KEY (`id`), ADD KEY `user_id` (`user_id`), ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `unit_staff`
--
ALTER TABLE `unit_staff`
 ADD PRIMARY KEY (`id`), ADD KEY `username` (`username`), ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
 ADD PRIMARY KEY (`username`), ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignment`
--
ALTER TABLE `assignment`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `assignment_deadline`
--
ALTER TABLE `assignment_deadline`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_feedback`
--
ALTER TABLE `assignment_feedback`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=99;
--
-- AUTO_INCREMENT for table `assignment_mark_criteria`
--
ALTER TABLE `assignment_mark_criteria`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `assignment_question`
--
ALTER TABLE `assignment_question`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=37;
--
-- AUTO_INCREMENT for table `assignment_topic`
--
ALTER TABLE `assignment_topic`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=664;
--
-- AUTO_INCREMENT for table `assignment_topic_allocation`
--
ALTER TABLE `assignment_topic_allocation`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=267;
--
-- AUTO_INCREMENT for table `submission`
--
ALTER TABLE `submission`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `unit`
--
ALTER TABLE `unit`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `unit_enrol`
--
ALTER TABLE `unit_enrol`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=750;
--
-- AUTO_INCREMENT for table `unit_staff`
--
ALTER TABLE `unit_staff`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignment_deadline`
--
ALTER TABLE `assignment_deadline`
ADD CONSTRAINT `asg_id` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`);

--
-- Constraints for table `assignment_feedback`
--
ALTER TABLE `assignment_feedback`
ADD CONSTRAINT `feedback_asg_id_fk` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`),
ADD CONSTRAINT `feedback_question_id_fk` FOREIGN KEY (`question_id`) REFERENCES `assignment_question` (`id`),
ADD CONSTRAINT `feedback_reviewee_fk` FOREIGN KEY (`reviewee`) REFERENCES `user` (`username`),
ADD CONSTRAINT `feedback_reviewer_fk` FOREIGN KEY (`reviewer`) REFERENCES `user` (`username`);

--
-- Constraints for table `assignment_mark_criteria`
--
ALTER TABLE `assignment_mark_criteria`
ADD CONSTRAINT `asg_id_mark` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`);

--
-- Constraints for table `assignment_question`
--
ALTER TABLE `assignment_question`
ADD CONSTRAINT `asg_id_question` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`);

--
-- Constraints for table `assignment_topic`
--
ALTER TABLE `assignment_topic`
ADD CONSTRAINT `asg_id_topic` FOREIGN KEY (`assign_id`) REFERENCES `assignment` (`id`);

--
-- Constraints for table `assignment_topic_allocation`
--
ALTER TABLE `assignment_topic_allocation`
ADD CONSTRAINT `asg_id_topic_allocation` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`),
ADD CONSTRAINT `topic_id_topic_allocation` FOREIGN KEY (`topic_id`) REFERENCES `assignment_topic` (`id`),
ADD CONSTRAINT `username_topic_allocation` FOREIGN KEY (`user_id`) REFERENCES `user` (`username`);

--
-- Constraints for table `submission`
--
ALTER TABLE `submission`
ADD CONSTRAINT `asg_id_submission` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`),
ADD CONSTRAINT `assg_id_topic_id_submission` FOREIGN KEY (`topic_id`) REFERENCES `assignment_topic` (`id`),
ADD CONSTRAINT `username_submission` FOREIGN KEY (`user_id`) REFERENCES `user` (`username`);

--
-- Constraints for table `unit_enrol`
--
ALTER TABLE `unit_enrol`
ADD CONSTRAINT `unit_enrol_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`),
ADD CONSTRAINT `unit_enrol_username` FOREIGN KEY (`user_id`) REFERENCES `user` (`username`);

--
-- Constraints for table `unit_staff`
--
ALTER TABLE `unit_staff`
ADD CONSTRAINT `unit_staff_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`),
ADD CONSTRAINT `unit_staff_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`);
