-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 23, 2020 at 02:25 PM
-- Server version: 5.5.39
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `peerassess`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `sp_close_asg`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_close_asg`()
    NO SQL
UPDATE
    assignment a,
    assignment_date ad
SET
    a.public = 0
WHERE
        a.id = ad.asg_id 
    and a.public <> 0
    and ad.key='ASG_CLOSE'
    and ad.date_value IS NOT NULL 
    and ad.date_value <= NOW()$$

DROP PROCEDURE IF EXISTS `sp_get_all_peer_feedback`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_peer_feedback`(IN `asg_id` INT, IN `reviewee` VARCHAR(20))
BEGIN
    SELECT aq.id as qid, aq.question_order, aq.question, aq.answer_type, aq.question_section, af.*
      FROM assignment_question aq
      LEFT JOIN assignment_feedback af ON aq.asg_id=af.asg_id and aq.id=af.question_id
     WHERE aq.asg_id = asg_id and af.reviewee=reviewee and af.reviewer != af.reviewee ;
END$$

DROP PROCEDURE IF EXISTS `sp_get_peer_review`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_peer_review`(IN `username` VARCHAR(10), IN `qid` INT)
BEGIN
select asg_id, reviewee, reviewer, total
from sv_assignment_peer_sum
where reviewee = username ; 
END$$

DROP PROCEDURE IF EXISTS `sp_get_question_feedback`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_question_feedback`(IN `asg_id` INT, IN `reviewer` VARCHAR(20), IN `reviewee` VARCHAR(20), IN `qtype` ENUM('SELF','PEER','GROUP'))
BEGIN
    SELECT aq.id as qid, aq.question_order, aq.question, aq.answer_type, aq.question_section, af.*
      FROM assignment_question aq
      LEFT JOIN assignment_feedback af ON aq.asg_id=af.asg_id and aq.id=af.question_id and af.reviewer=reviewer and af.reviewee=reviewee
     WHERE aq.asg_id = asg_id and aq.question_section=qtype ;
END$$

DROP PROCEDURE IF EXISTS `sp_get_student_assignment_list`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_student_assignment_list`(IN `username` VARCHAR(10))
BEGIN
    SELECT a.*,fn_get_unit_code(a.unit_id) as unit
    FROM   assignment a, unit_enrol ue
    WHERE  a.unit_id = ue.unit_id
    AND    ue.user_id = username ;
END$$

DROP PROCEDURE IF EXISTS `sp_release_asg`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_release_asg`()
    NO SQL
UPDATE
    assignment a,
    assignment_date ad
SET
    a.public = 1
WHERE
        a.id = ad.asg_id 
    and a.public <> 1
    and ad.key='ASG_OPEN'
    and ad.date_value IS NOT NULL 
    and ad.date_value <= NOW()$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `fn_get_unit_code`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_get_unit_code`(`unit_id` INT) RETURNS varchar(20) CHARSET utf8
BEGIN
 DECLARE rtnstr VARCHAR(20);
 
  SELECT unit_code 
  INTO   rtnstr
  FROM   unit
  WHERE  id=unit_id;
  
  RETURN rtnstr ;
END$$

DROP FUNCTION IF EXISTS `fn_is_allow_view_assignment`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_is_allow_view_assignment`(`username` VARCHAR(10), `asg_id` INT) RETURNS int(11)
BEGIN
 DECLARE rtn_result INT DEFAULT 0;
 DECLARE temp_val INT DEFAULT 0;
  
  SELECT count(1)
  INTO   temp_val
  FROM   assignment a, unit_enrol ue
  WHERE  a.unit_id = ue.unit_id
  AND    ue.user_id = username
  AND    a.id = asg_id  
  AND    a.public = 1 ;
  
  SET    rtn_result = rtn_result + temp_val;
  
  SELECT count(1)
  INTO   temp_val
  FROM   assignment a, unit_staff us
  WHERE  a.unit_id = us.unit_id
  AND    us.username = username
  AND    a.id = asg_id ;
  
  SET    rtn_result = rtn_result + temp_val;
  
  SELECT count(1)
  INTO   temp_val
  FROM   `user` u
  WHERE  u.username = username
  AND    u.permission_level >= 90;
  
  SET    rtn_result = rtn_result + temp_val;
  
  RETURN rtn_result ;
END$$

DROP FUNCTION IF EXISTS `fn_sem_short_desc`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_sem_short_desc`(`in_sem` VARCHAR(10)) RETURNS varchar(100) CHARSET utf8
BEGIN
 DECLARE rtnstr VARCHAR(100);
 
  SELECT short_description
  INTO   rtnstr
  FROM   semester
  WHERE  sem=in_sem;
  
  RETURN rtnstr ;
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
  `public` int(11) NOT NULL DEFAULT '0' COMMENT '0 - private, 1 - open to public',
  `feedback` int(11) NOT NULL DEFAULT '0' COMMENT '0 - feedback does not release to student; 1- feedback release to student',
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Triggers `assignment`
--
DROP TRIGGER IF EXISTS `tg_after_update_asg`;
DELIMITER //
CREATE TRIGGER `tg_after_update_asg` AFTER UPDATE ON `assignment`
 FOR EACH ROW INSERT INTO assignment_log
SET id             = NEW.id,
    title          = NEW.title,
    type           = NEW.type,
    outcome        = NEW.outcome,
    scenario       = NEW.scenario,
    unit_id        = NEW.unit_id,
    public         = NEW.public,
    feedback       = NEW.feedback,
    create_time    = NEW.create_time,
    last_upd_time  = NEW.last_upd_time,
    action         = 'UPDATE_AFTER',
    action_date    = now()
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_before_update_asg`;
DELIMITER //
CREATE TRIGGER `tg_before_update_asg` BEFORE UPDATE ON `assignment`
 FOR EACH ROW INSERT INTO assignment_log
SET id             = OLD.id,
    title          = OLD.title,
    type           = OLD.type,
    outcome        = OLD.outcome,
    scenario       = OLD.scenario,
    unit_id        = OLD.unit_id,
    public         = OLD.public,
    feedback       = OLD.feedback,
    create_time    = OLD.create_time,
    last_upd_time  = OLD.last_upd_time,
    action         = 'UPDATE_BEFORE',
    action_date    = now()
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_delete_asg`;
DELIMITER //
CREATE TRIGGER `tg_delete_asg` BEFORE DELETE ON `assignment`
 FOR EACH ROW INSERT INTO assignment_log
SET id             = OLD.id,
    title          = OLD.title,
    type           = OLD.type,
    outcome        = OLD.outcome,
    scenario       = OLD.scenario,
    unit_id        = OLD.unit_id,
    public         = OLD.public,
    feedback       = OLD.feedback,
    create_time    = OLD.create_time,
    last_upd_time  = OLD.last_upd_time,
    action         = 'DELETE',
    action_date    = now()
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_insert_asg`;
DELIMITER //
CREATE TRIGGER `tg_insert_asg` AFTER INSERT ON `assignment`
 FOR EACH ROW INSERT INTO assignment_log
SET id             = NEW.id,
    title          = NEW.title,
    type           = NEW.type,
    outcome        = NEW.outcome,
    scenario       = NEW.scenario,
    unit_id        = NEW.unit_id,
    public         = NEW.public,
    feedback       = NEW.feedback,
    create_time    = NEW.create_time,
    last_upd_time  = NEW.last_upd_time,
    action         = 'ADD',
    action_date    = now()
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_date`
--

DROP TABLE IF EXISTS `assignment_date`;
CREATE TABLE IF NOT EXISTS `assignment_date` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `key` varchar(200) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `date_value` datetime DEFAULT NULL,
  `last_upd_by` varchar(50) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_default_feedback`
--

DROP TABLE IF EXISTS `assignment_default_feedback`;
CREATE TABLE IF NOT EXISTS `assignment_default_feedback` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `section` varchar(50) NOT NULL,
  `section_desc` text,
  `threshold` decimal(13,2) NOT NULL DEFAULT '0.00',
  `feedback` text,
  `last_upd_by` varchar(20) NOT NULL,
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
  `reviewer` varchar(20) NOT NULL,
  `reviewee` varchar(20) NOT NULL,
  `feedback` text,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_group_mark`
--

DROP TABLE IF EXISTS `assignment_group_mark`;
CREATE TABLE IF NOT EXISTS `assignment_group_mark` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `score` decimal(10,2) DEFAULT NULL,
  `remark` text,
  `last_upd_by` varchar(10) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_log`
--

DROP TABLE IF EXISTS `assignment_log`;
CREATE TABLE IF NOT EXISTS `assignment_log` (
  `id` int(11) NOT NULL,
  `title` varchar(500) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0 - Indiv, 1 - Group',
  `outcome` mediumtext,
  `scenario` mediumtext,
  `unit_id` int(11) NOT NULL,
  `public` int(11) NOT NULL DEFAULT '0' COMMENT '0 - private, 1 - open to public',
  `feedback` int(11) NOT NULL DEFAULT '0' COMMENT '0 - feedback does not release to student; 1- feedback release to student',
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `assignment_log`
--

INSERT INTO `assignment_log` (`id`, `title`, `type`, `outcome`, `scenario`, `unit_id`, `public`, `feedback`, `create_time`, `last_upd_time`, `action`, `action_date`) VALUES
(4, 'Team work', 1, '', '', 10, 0, 0, '2020-02-25 01:23:28', '2020-02-25 01:23:28', 'DELETE', '2020-02-25 01:52:11');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment_peer_mark`
--

DROP TABLE IF EXISTS `assignment_peer_mark`;
CREATE TABLE IF NOT EXISTS `assignment_peer_mark` (
`id` int(11) NOT NULL,
  `asg_id` int(11) NOT NULL,
  `score` decimal(13,2) DEFAULT NULL,
  `username` varchar(10) NOT NULL,
  `remark` text,
  `last_upd_by` varchar(10) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `semester`
--

DROP TABLE IF EXISTS `semester`;
CREATE TABLE IF NOT EXISTS `semester` (
  `sem` varchar(10) NOT NULL,
  `short_description` varchar(100) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `semester`
--

INSERT INTO `semester` (`sem`, `short_description`, `description`) VALUES
('202001', '2020Sem1', '2020 Semester 1'),
('202002', '2020Sem2', '2020 Semester 2'),
('202101', '2021Sem1', '2021 Semester 1'),
('202102', '2021Sem2', '2021 Semester 2'),
('202201', '2022Sem1', '2022 Semester 1'),
('202202', '2022Sem2', '2022 Semester 2'),
('202301', '2023Sem1', '2023 Semester 1'),
('202302', '2023Sem2', '2023 Semester 2');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

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

-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_peer_stat`
--
DROP VIEW IF EXISTS `sv_assignment_peer_stat`;
CREATE TABLE IF NOT EXISTS `sv_assignment_peer_stat` (
`asg_id` int(11)
,`reviewee` varchar(20)
,`average` double
,`var` double
,`min_score` double
,`max_score` double
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_peer_sum`
--
DROP VIEW IF EXISTS `sv_assignment_peer_sum`;
CREATE TABLE IF NOT EXISTS `sv_assignment_peer_sum` (
`asg_id` int(11)
,`reviewee` varchar(20)
,`reviewer` varchar(20)
,`total` double
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_peer_summary`
--
DROP VIEW IF EXISTS `sv_assignment_peer_summary`;
CREATE TABLE IF NOT EXISTS `sv_assignment_peer_summary` (
`id` int(11)
,`asg_id` int(11)
,`asg_title` varchar(500)
,`sem` varchar(100)
,`sem_key` varchar(10)
,`unit_id` int(11)
,`unit_code` varchar(20)
,`unit_description` varchar(500)
,`username` varchar(20)
,`email` varchar(255)
,`last_name` varchar(255)
,`first_name` varchar(255)
,`sid` varchar(10)
,`topic_id` int(11)
,`topic` varchar(500)
,`topic_desc` mediumtext
,`peer_average` double
,`peer_var` double
,`peer_min_score` double
,`peer_max_score` double
,`group_score_id` int(11)
,`group_score` decimal(10,2)
,`group_remark` text
,`override_score_id` int(11)
,`override_score` decimal(13,2)
,`override_score_remark` text
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_staff`
--
DROP VIEW IF EXISTS `sv_assignment_staff`;
CREATE TABLE IF NOT EXISTS `sv_assignment_staff` (
`id` int(11)
,`asg_id` int(11)
,`title` varchar(500)
,`type` int(11)
,`public` int(11)
,`feedback` int(11)
,`topic_count` bigint(21)
,`student_count` bigint(21)
,`outcome` mediumtext
,`scenario` mediumtext
,`unit_id` int(11)
,`create_time` datetime
,`last_upd_time` datetime
,`unit_code` varchar(20)
,`unit_description` varchar(500)
,`sem` varchar(100)
,`sem_key` varchar(10)
,`username` varchar(20)
,`last_name` varchar(255)
,`first_name` varchar(255)
,`sid` varchar(10)
,`email` varchar(255)
,`permission_level` int(11)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `sv_assignment_student`
--
DROP VIEW IF EXISTS `sv_assignment_student`;
CREATE TABLE IF NOT EXISTS `sv_assignment_student` (
`id` int(11)
,`asg_id` int(11)
,`public` int(11)
,`asg_title` varchar(500)
,`sem` varchar(100)
,`sem_key` varchar(10)
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
-- Stand-in structure for view `sv_group_submission`
--
DROP VIEW IF EXISTS `sv_group_submission`;
CREATE TABLE IF NOT EXISTS `sv_group_submission` (
`topic_id` int(11)
,`topic` varchar(500)
,`topic_desc` mediumtext
,`asg_id` int(11)
,`user_id` varchar(10)
,`submission_id` int(11)
,`filename` varchar(1000)
,`submission_date` datetime
,`score_id` int(11)
,`score` decimal(10,2)
,`remark` text
,`marker` varchar(10)
,`score_create_time` datetime
,`score_last_upd_time` datetime
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
,`sem` varchar(100)
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
,`sem` varchar(100)
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
  `sem` varchar(10) NOT NULL,
  `unit_description` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `unit`
--

INSERT INTO `unit` (`id`, `unit_code`, `sem`, `unit_description`, `create_time`, `last_upd_time`) VALUES
(1, 'KIT001', '202001', 'Programming Preparation', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(2, 'KIT101', '202001', 'Programming Fundamentals', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(3, 'KIT105', '202001', 'ICT Professional Practices', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(4, 'KIT107', '202001', 'Programming', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(5, 'KIT108', '202001', 'Artificial Intelligence', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(6, 'KIT111', '202001', 'Data Networks and Security', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(7, 'KIT202', '202001', 'Secure Web Programming', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(8, 'KIT203', '202001', 'ICT Project Management and Modelling', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(9, 'KIT205', '202001', 'Data Structures and Algorithms', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(10, 'KIT301', '202001', 'ICT Project A', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(11, 'KIT304', '202001', 'Server Administration and Security Assurance', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(12, 'KIT305', '202001', 'Mobile Application Development', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(13, 'KIT317', '202001', 'Sensor Networks and Applications', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(14, 'KIT417', '202001', 'Sensor Networks and Applications', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(15, 'KIT318', '202001', 'Big Data and Cloud Computing', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(16, 'KIT418', '202001', 'Big Data and Cloud Computing', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(17, 'KIT401', '202001', 'ICT Research Methods', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(18, 'KIT701', '202001', 'ICT Research Methods', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(19, 'KIT405', '202001', 'Programming for Intelligent Web Services & Apps', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(20, 'KIT502', '202001', 'Web Development', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(21, 'KIT503', '202001', 'ICT Professional Practices and Project Management', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(22, 'KIT607', '202001', 'Mobile Application Development', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(23, 'KIT707', '202001', 'Knowledge and Information Management', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(24, 'KIT710', '202001', 'eLogistics', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(25, 'KIT711', '202001', 'Network Security Techniques and Technology', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(26, 'KIT713', '202001', 'Multi-perspective ICT Project', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(27, 'KIT714', '202001', 'ICT Research Principles', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(28, 'KIT208', '202001', 'Virtual and Mixed Reality Technology', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(29, 'KIT508', '202001', 'Virtual and Mixed Reality Technology', '2020-02-24 22:45:30', '2020-02-24 22:45:30'),
(30, 'KIT302', '202002', 'ICT Project B', '2020-02-24 22:50:12', '2020-02-24 22:50:12');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `unit_group`
--

DROP TABLE IF EXISTS `unit_group`;
CREATE TABLE IF NOT EXISTS `unit_group` (
`id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `category` varchar(500) NOT NULL,
  `group_id` varchar(500) DEFAULT NULL,
  `group_desc` mediumtext,
  `max` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `unit_group_allocation`
--

DROP TABLE IF EXISTS `unit_group_allocation`;
CREATE TABLE IF NOT EXISTS `unit_group_allocation` (
`id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `unit_staff`
--

DROP TABLE IF EXISTS `unit_staff`;
CREATE TABLE IF NOT EXISTS `unit_staff` (
`id` int(11) NOT NULL,
  `username` varchar(10) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `last_upd_by` varchar(20) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_upd_time` datetime NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `unit_staff`
--

INSERT INTO `unit_staff` (`id`, `username`, `unit_id`, `last_upd_by`, `create_time`, `last_upd_time`) VALUES
(1, 'admin', 1, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(2, 'admin', 2, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(3, 'admin', 3, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(4, 'admin', 4, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(5, 'admin', 5, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(6, 'admin', 6, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(7, 'admin', 7, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(8, 'admin', 8, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(9, 'admin', 9, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(10, 'admin', 10, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(11, 'admin', 11, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(12, 'admin', 12, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(13, 'admin', 13, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(14, 'admin', 14, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(15, 'admin', 15, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(16, 'admin', 16, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(17, 'admin', 17, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(18, 'admin', 18, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(19, 'admin', 19, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(20, 'admin', 20, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(21, 'admin', 21, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(22, 'admin', 22, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(23, 'admin', 23, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(24, 'admin', 24, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(25, 'admin', 25, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(26, 'admin', 26, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(27, 'admin', 27, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(28, 'admin', 28, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(29, 'admin', 29, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47'),
(30, 'admin', 30, 'admin', '2020-02-25 01:53:47', '2020-02-25 01:53:47');

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
('admin', '$1$5ac36b5d$ATVyx7vRGou5dQvPdCyzU1', '$1$5ac36b5dbe8321e5f6896d0e4c402728', 'Admin', 'System', '', 'kaichiu.wong@utas.edu.au', 90, 0, '2019-11-15 22:34:45', 0, '2020-03-24 00:00:43', NULL, NULL, '2020-02-24 18:58:43');

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_peer_stat`
--
DROP TABLE IF EXISTS `sv_assignment_peer_stat`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_peer_stat` AS select `sv_assignment_peer_sum`.`asg_id` AS `asg_id`,`sv_assignment_peer_sum`.`reviewee` AS `reviewee`,avg(`sv_assignment_peer_sum`.`total`) AS `average`,variance(`sv_assignment_peer_sum`.`total`) AS `var`,min(`sv_assignment_peer_sum`.`total`) AS `min_score`,max(`sv_assignment_peer_sum`.`total`) AS `max_score` from `sv_assignment_peer_sum` where (`sv_assignment_peer_sum`.`reviewer` <> `sv_assignment_peer_sum`.`reviewee`) group by `sv_assignment_peer_sum`.`asg_id`,`sv_assignment_peer_sum`.`reviewee` order by `sv_assignment_peer_sum`.`asg_id`,`sv_assignment_peer_sum`.`reviewee`;

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_peer_sum`
--
DROP TABLE IF EXISTS `sv_assignment_peer_sum`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_peer_sum` AS select `assignment_feedback`.`asg_id` AS `asg_id`,`assignment_feedback`.`reviewee` AS `reviewee`,`assignment_feedback`.`reviewer` AS `reviewer`,sum((`assignment_feedback`.`feedback` + 0.0)) AS `total` from `assignment_feedback` where (`assignment_feedback`.`reviewer` <> `assignment_feedback`.`reviewee`) group by `assignment_feedback`.`asg_id`,`assignment_feedback`.`reviewee`,`assignment_feedback`.`reviewer` order by `assignment_feedback`.`asg_id`,`assignment_feedback`.`reviewee`,`assignment_feedback`.`reviewer`;

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_peer_summary`
--
DROP TABLE IF EXISTS `sv_assignment_peer_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_peer_summary` AS select `s`.`id` AS `id`,`s`.`asg_id` AS `asg_id`,`s`.`asg_title` AS `asg_title`,`s`.`sem` AS `sem`,`s`.`sem_key` AS `sem_key`,`s`.`unit_id` AS `unit_id`,`s`.`unit_code` AS `unit_code`,`s`.`unit_description` AS `unit_description`,`s`.`username` AS `username`,`s`.`email` AS `email`,`s`.`last_name` AS `last_name`,`s`.`first_name` AS `first_name`,`s`.`sid` AS `sid`,`t`.`topic_id` AS `topic_id`,`t`.`topic` AS `topic`,`t`.`topic_desc` AS `topic_desc`,`a`.`average` AS `peer_average`,`a`.`var` AS `peer_var`,`a`.`min_score` AS `peer_min_score`,`a`.`max_score` AS `peer_max_score`,`g`.`score_id` AS `group_score_id`,`g`.`score` AS `group_score`,`g`.`remark` AS `group_remark`,`p`.`id` AS `override_score_id`,`p`.`score` AS `override_score`,`p`.`remark` AS `override_score_remark` from (((`sv_assignment_student` `s` left join `sv_assignment_peer_stat` `a` on(((`s`.`asg_id` = `a`.`asg_id`) and (`s`.`username` = `a`.`reviewee`)))) left join `assignment_peer_mark` `p` on(((`s`.`asg_id` = `p`.`asg_id`) and (`p`.`username` = `s`.`username`)))) left join (`sv_assignment_topic_summary` `t` join `sv_group_submission` `g` on(((`t`.`assign_id` = `g`.`asg_id`) and (`t`.`topic_id` = `g`.`topic_id`)))) on(((`s`.`asg_id` = `t`.`assign_id`) and (`s`.`username` = `t`.`user_id`))));

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_staff`
--
DROP TABLE IF EXISTS `sv_assignment_staff`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_staff` AS select `us`.`id` AS `id`,`a`.`id` AS `asg_id`,`a`.`title` AS `title`,`a`.`type` AS `type`,`a`.`public` AS `public`,`a`.`feedback` AS `feedback`,`st`.`topic_count` AS `topic_count`,`au`.`student_count` AS `student_count`,`a`.`outcome` AS `outcome`,`a`.`scenario` AS `scenario`,`a`.`unit_id` AS `unit_id`,`a`.`create_time` AS `create_time`,`a`.`last_upd_time` AS `last_upd_time`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`fn_sem_short_desc`(`un`.`sem`) AS `sem`,`un`.`sem` AS `sem_key`,`u`.`username` AS `username`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid`,`u`.`email` AS `email`,`u`.`permission_level` AS `permission_level` from (((((`assignment` `a` left join `unit_staff` `us` on((`a`.`unit_id` = `us`.`unit_id`))) left join `unit` `un` on((`a`.`unit_id` = `un`.`id`))) left join `user` `u` on((`us`.`username` = `u`.`username`))) left join `sv_assignment_topic_count` `st` on((`a`.`id` = `st`.`id`))) left join `sv_assignment_student_count` `au` on((`a`.`id` = `au`.`id`)));

-- --------------------------------------------------------

--
-- Structure for view `sv_assignment_student`
--
DROP TABLE IF EXISTS `sv_assignment_student`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_assignment_student` AS select distinct `ue`.`id` AS `id`,`a`.`id` AS `asg_id`,`a`.`public` AS `public`,`a`.`title` AS `asg_title`,`fn_sem_short_desc`(`un`.`sem`) AS `sem`,`un`.`sem` AS `sem_key`,`un`.`id` AS `unit_id`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`u`.`username` AS `username`,`u`.`email` AS `email`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid` from (((`assignment` `a` join `unit_enrol` `ue`) join `unit` `un`) join `user` `u`) where ((`a`.`unit_id` = `un`.`id`) and (`un`.`id` = `ue`.`unit_id`) and (`ue`.`user_id` = `u`.`username`));

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
-- Structure for view `sv_group_submission`
--
DROP TABLE IF EXISTS `sv_group_submission`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_group_submission` AS select `t`.`id` AS `topic_id`,`t`.`topic` AS `topic`,`t`.`topic_desc` AS `topic_desc`,`t`.`assign_id` AS `asg_id`,`s`.`user_id` AS `user_id`,`s`.`id` AS `submission_id`,`s`.`filename` AS `filename`,`s`.`submission_date` AS `submission_date`,`agm`.`id` AS `score_id`,`agm`.`score` AS `score`,`agm`.`remark` AS `remark`,`agm`.`last_upd_by` AS `marker`,`agm`.`create_time` AS `score_create_time`,`agm`.`last_upd_time` AS `score_last_upd_time` from ((`assignment_topic` `t` left join `submission` `s` on(((`t`.`id` = `s`.`topic_id`) and (`t`.`assign_id` = `s`.`asg_id`)))) left join `assignment_group_mark` `agm` on(((`t`.`id` = `agm`.`group_id`) and (`t`.`assign_id` = `agm`.`asg_id`))));

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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_unit_staff` AS select `un`.`id` AS `id`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`fn_sem_short_desc`(`un`.`sem`) AS `sem`,`un`.`create_time` AS `create_time`,`un`.`last_upd_time` AS `last_upd_time`,`u`.`username` AS `username`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid`,`u`.`email` AS `email`,`u`.`permission_level` AS `permission_level` from ((`unit` `un` join `unit_staff` `us`) join `user` `u`) where ((`un`.`id` = `us`.`unit_id`) and (`us`.`username` = `u`.`username`));

-- --------------------------------------------------------

--
-- Structure for view `sv_unit_student`
--
DROP TABLE IF EXISTS `sv_unit_student`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sv_unit_student` AS select `u`.`username` AS `username`,`u`.`last_name` AS `last_name`,`u`.`first_name` AS `first_name`,`u`.`id` AS `sid`,`u`.`email` AS `email`,`u`.`permission_level` AS `permission_level`,`un`.`id` AS `id`,`un`.`unit_code` AS `unit_code`,`un`.`unit_description` AS `unit_description`,`fn_sem_short_desc`(`un`.`sem`) AS `sem`,`un`.`create_time` AS `create_time`,`un`.`last_upd_time` AS `last_upd_time` from ((`unit` `un` join `unit_enrol` `ue`) join `user` `u`) where ((`un`.`id` = `ue`.`unit_id`) and (`ue`.`user_id` = `u`.`username`)) order by `u`.`username`,`un`.`unit_code`;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignment`
--
ALTER TABLE `assignment`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assignment_date`
--
ALTER TABLE `assignment_date`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`);

--
-- Indexes for table `assignment_default_feedback`
--
ALTER TABLE `assignment_default_feedback`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`);

--
-- Indexes for table `assignment_feedback`
--
ALTER TABLE `assignment_feedback`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`), ADD KEY `question_id` (`question_id`), ADD KEY `reviewer` (`reviewer`), ADD KEY `reviewee` (`reviewee`);

--
-- Indexes for table `assignment_group_mark`
--
ALTER TABLE `assignment_group_mark`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assignment_mark_criteria`
--
ALTER TABLE `assignment_mark_criteria`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`);

--
-- Indexes for table `assignment_peer_mark`
--
ALTER TABLE `assignment_peer_mark`
 ADD PRIMARY KEY (`id`), ADD KEY `asg_id` (`asg_id`), ADD KEY `username` (`username`);

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
-- Indexes for table `semester`
--
ALTER TABLE `semester`
 ADD PRIMARY KEY (`sem`);

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
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unit_code` (`unit_code`,`sem`), ADD KEY `sem` (`sem`);

--
-- Indexes for table `unit_enrol`
--
ALTER TABLE `unit_enrol`
 ADD PRIMARY KEY (`id`), ADD KEY `user_id` (`user_id`), ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `unit_group`
--
ALTER TABLE `unit_group`
 ADD PRIMARY KEY (`id`), ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `unit_group_allocation`
--
ALTER TABLE `unit_group_allocation`
 ADD PRIMARY KEY (`id`), ADD KEY `unit_id` (`unit_id`), ADD KEY `user_id` (`user_id`), ADD KEY `group_id` (`group_id`);

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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_date`
--
ALTER TABLE `assignment_date`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_default_feedback`
--
ALTER TABLE `assignment_default_feedback`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_feedback`
--
ALTER TABLE `assignment_feedback`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_group_mark`
--
ALTER TABLE `assignment_group_mark`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_mark_criteria`
--
ALTER TABLE `assignment_mark_criteria`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_peer_mark`
--
ALTER TABLE `assignment_peer_mark`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_question`
--
ALTER TABLE `assignment_question`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_topic`
--
ALTER TABLE `assignment_topic`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `assignment_topic_allocation`
--
ALTER TABLE `assignment_topic_allocation`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `submission`
--
ALTER TABLE `submission`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `unit`
--
ALTER TABLE `unit`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=31;
--
-- AUTO_INCREMENT for table `unit_enrol`
--
ALTER TABLE `unit_enrol`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `unit_group`
--
ALTER TABLE `unit_group`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `unit_group_allocation`
--
ALTER TABLE `unit_group_allocation`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `unit_staff`
--
ALTER TABLE `unit_staff`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=31;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignment_date`
--
ALTER TABLE `assignment_date`
ADD CONSTRAINT `asg_id` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`);

--
-- Constraints for table `assignment_default_feedback`
--
ALTER TABLE `assignment_default_feedback`
ADD CONSTRAINT `default_feedback_asgid_fk` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`);

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
-- Constraints for table `assignment_peer_mark`
--
ALTER TABLE `assignment_peer_mark`
ADD CONSTRAINT `asg_mark_id_fk` FOREIGN KEY (`asg_id`) REFERENCES `assignment` (`id`),
ADD CONSTRAINT `asg_peer_mk_user_fk` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

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
-- Constraints for table `unit`
--
ALTER TABLE `unit`
ADD CONSTRAINT `sem_unit_fk` FOREIGN KEY (`sem`) REFERENCES `semester` (`sem`);

--
-- Constraints for table `unit_enrol`
--
ALTER TABLE `unit_enrol`
ADD CONSTRAINT `unit_enrol_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`),
ADD CONSTRAINT `unit_enrol_username` FOREIGN KEY (`user_id`) REFERENCES `user` (`username`);

--
-- Constraints for table `unit_group`
--
ALTER TABLE `unit_group`
ADD CONSTRAINT `fk_unit_group_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`);

--
-- Constraints for table `unit_group_allocation`
--
ALTER TABLE `unit_group_allocation`
ADD CONSTRAINT `fk_unit_group_alloc_group_id` FOREIGN KEY (`group_id`) REFERENCES `unit_group` (`id`),
ADD CONSTRAINT `fk_unit_group_alloc_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`),
ADD CONSTRAINT `fk_unit_group_alloc_username` FOREIGN KEY (`user_id`) REFERENCES `user` (`username`);

--
-- Constraints for table `unit_staff`
--
ALTER TABLE `unit_staff`
ADD CONSTRAINT `unit_staff_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`),
ADD CONSTRAINT `unit_staff_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`);
