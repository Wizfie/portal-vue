-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.31 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db_portal
CREATE DATABASE IF NOT EXISTS `db_portal` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_portal`;

-- Dumping structure for table db_portal.event
CREATE TABLE IF NOT EXISTS `event` (
  `event_id` bigint NOT NULL AUTO_INCREMENT,
  `event_name` varchar(255) DEFAULT NULL,
  `event_year` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `UK_pv13n3n7ggmpvk1rsfqi7r15l` (`event_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.event: ~0 rows (approximately)
DELETE FROM `event`;
INSERT INTO `event` (`event_id`, `event_name`, `event_year`) VALUES
	(5, 'QCC 2024', '2024'),
	(6, 'SS 2024', '2024');

-- Dumping structure for table db_portal.event_stages
CREATE TABLE IF NOT EXISTS `event_stages` (
  `stage_id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `stage_name` varchar(255) DEFAULT NULL,
  `event_id` bigint DEFAULT NULL,
  PRIMARY KEY (`stage_id`),
  KEY `FKhimsa8nrx6duoglusy4v91okx` (`event_id`),
  CONSTRAINT `FKhimsa8nrx6duoglusy4v91okx` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.event_stages: ~0 rows (approximately)
DELETE FROM `event_stages`;
INSERT INTO `event_stages` (`stage_id`, `description`, `stage_name`, `event_id`) VALUES
	(1, 'desc 1', 'Pendaftaran', 5),
	(2, 'desc 2', 'Penilaian', 5),
	(3, 'desc 1', 'Berkas 1', 6),
	(4, 'desc 2', 'Berkas 2', 6);

-- Dumping structure for table db_portal.ms_user
CREATE TABLE IF NOT EXISTS `ms_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `nip` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_g654enkj2gifxv3miea4v46w7` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.ms_user: ~0 rows (approximately)
DELETE FROM `ms_user`;
INSERT INTO `ms_user` (`id`, `email`, `nip`, `password`, `role`, `username`) VALUES
	(1, '', '', '$2a$10$2NzYuYCs/ZCkpIhsdhX8feZK8Dvv7.yzVFplUvin6ac1JEOaj1X2.', 'ADMIN', 'admin');

-- Dumping structure for table db_portal.registration
CREATE TABLE IF NOT EXISTS `registration` (
  `registration_id` bigint NOT NULL AUTO_INCREMENT,
  `registration_status` varchar(255) DEFAULT NULL,
  `event_id` bigint DEFAULT NULL,
  `team_id` bigint DEFAULT NULL,
  PRIMARY KEY (`registration_id`),
  KEY `FKs4x1uat6i8fx26qpdrfwfg3ya` (`event_id`),
  KEY `FKnjhkf57erinxqbgl05cok5ash` (`team_id`),
  CONSTRAINT `FKnjhkf57erinxqbgl05cok5ash` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `FKs4x1uat6i8fx26qpdrfwfg3ya` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.registration: ~4 rows (approximately)
DELETE FROM `registration`;
INSERT INTO `registration` (`registration_id`, `registration_status`, `event_id`, `team_id`) VALUES
	(1, 'Pending', 5, 1),
	(2, 'Pending', 5, 2),
	(3, 'Pending', 6, 3),
	(4, 'Pending', 6, 4);

-- Dumping structure for table db_portal.steps
CREATE TABLE IF NOT EXISTS `steps` (
  `step_id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `step_name` varchar(255) DEFAULT NULL,
  `event_id` bigint DEFAULT NULL,
  PRIMARY KEY (`step_id`),
  KEY `FK87th8mpfbslon2cksj3m1rp14` (`event_id`),
  CONSTRAINT `FK87th8mpfbslon2cksj3m1rp14` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.steps: ~6 rows (approximately)
DELETE FROM `steps`;
INSERT INTO `steps` (`step_id`, `description`, `end_date`, `start_date`, `step_name`, `event_id`) VALUES
	(9, 'desc 1', '2024-03-13', '2024-03-12', 'Pendaftaran', 5),
	(10, 'desc 2', '2024-03-15', '2024-03-14', 'Persiapan', 5),
	(11, 'desc 3', '2024-03-17', '2024-03-16', 'Penilaian', 5),
	(12, 'desc 4', '2024-03-19', '2024-03-18', 'Awarding', 5),
	(13, 'ss 1', '2024-03-13', '2024-03-12', 'Pendaftaran', 6),
	(14, 'ss 2', '2024-03-15', '2024-03-14', 'Awarding', 6);

-- Dumping structure for table db_portal.team
CREATE TABLE IF NOT EXISTS `team` (
  `team_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` date DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.team: ~4 rows (approximately)
DELETE FROM `team`;
INSERT INTO `team` (`team_id`, `created_at`, `description`, `team_name`, `user_id`) VALUES
	(1, '2024-03-12', 'desc 1', 'TEAM 1', '1'),
	(2, '2024-03-12', 'desc 2', 'TEAM 2', '1'),
	(3, '2024-03-12', 'desc 3', 'TEAM 3', '1'),
	(4, '2024-03-12', 'desc 4', 'TEAM 4 ', '1');

-- Dumping structure for table db_portal.team_member
CREATE TABLE IF NOT EXISTS `team_member` (
  `team_member_id` bigint NOT NULL AUTO_INCREMENT,
  `member_name` varchar(255) DEFAULT NULL,
  `member_position` varchar(255) DEFAULT NULL,
  `event_id` bigint DEFAULT NULL,
  `team_id` bigint DEFAULT NULL,
  PRIMARY KEY (`team_member_id`),
  KEY `FK8oldao4i4g9j9hod6hnxmx3n6` (`event_id`),
  KEY `FK9ubp79ei4tv4crd0r9n7u5i6e` (`team_id`),
  CONSTRAINT `FK8oldao4i4g9j9hod6hnxmx3n6` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`),
  CONSTRAINT `FK9ubp79ei4tv4crd0r9n7u5i6e` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.team_member: ~8 rows (approximately)
DELETE FROM `team_member`;
INSERT INTO `team_member` (`team_member_id`, `member_name`, `member_position`, `event_id`, `team_id`) VALUES
	(1, 'BORUTO', 'LEADER', 5, 1),
	(2, 'HIMAWARI', 'MEMBER', 5, 1),
	(3, 'LUFFY', 'KAPTEN', 5, 2),
	(4, 'ZORO', 'MEMBER', 5, 2),
	(5, 'ZILONG', 'LEADER', 6, 3),
	(6, 'NANA', 'MEMBER', 6, 3),
	(7, 'MAMAN', 'KAPTE', 6, 4),
	(8, 'BULE', 'MEMBER', 6, 4);

-- Dumping structure for table db_portal.upload_files
CREATE TABLE IF NOT EXISTS `upload_files` (
  `files_id` bigint NOT NULL AUTO_INCREMENT,
  `approval_status` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_at` datetime(6) DEFAULT NULL,
  `uploaded_by` varchar(255) DEFAULT NULL,
  `stage_id` bigint DEFAULT NULL,
  `registration_id` bigint DEFAULT NULL,
  PRIMARY KEY (`files_id`),
  KEY `FKdfy2kx7eee3at6spb09wlr2ko` (`stage_id`),
  KEY `FK471pc2jimkp6pex7d2bse34h9` (`registration_id`),
  CONSTRAINT `FK471pc2jimkp6pex7d2bse34h9` FOREIGN KEY (`registration_id`) REFERENCES `registration` (`registration_id`),
  CONSTRAINT `FKdfy2kx7eee3at6spb09wlr2ko` FOREIGN KEY (`stage_id`) REFERENCES `event_stages` (`stage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_portal.upload_files: ~2 rows (approximately)
DELETE FROM `upload_files`;
INSERT INTO `upload_files` (`files_id`, `approval_status`, `file_name`, `file_path`, `uploaded_at`, `uploaded_by`, `stage_id`, `registration_id`) VALUES
	(19, 'WAITING', 'Tugas_terstruktur_2_QCC_2024_TEAM_2_2024-03-12_21-30-19.docx', '.\\uploads\\QCC 2024\\TEAM 2\\Tugas_terstruktur_2_QCC_2024_TEAM_2_2024-03-12_21-30-19.docx', '2024-03-12 21:30:19.287435', 'TEAM 2', 1, 2),
	(20, 'WAITING', 'Pertemuan_3_QCC_2024_TEAM_1_2024-03-12_21-49-05.pdf', '.\\uploads\\QCC 2024\\TEAM 1\\Pertemuan_3_QCC_2024_TEAM_1_2024-03-12_21-49-05.pdf', '2024-03-12 21:49:05.619588', 'TEAM 1', 1, 1),
	(21, 'WAITING', 'Pertemuan_1_QCC_2024_TEAM_1_2024-03-12_21-52-37.pdf', '.\\uploads\\QCC 2024\\TEAM 1\\Pertemuan_1_QCC_2024_TEAM_1_2024-03-12_21-52-37.pdf', '2024-03-12 21:52:37.898687', 'TEAM 1', 2, 1),
	(22, 'WAITING', 'Pertemuan_2_1_QCC_2024_TEAM_1_2024-03-12_21-52-37.pdf', '.\\uploads\\QCC 2024\\TEAM 1\\Pertemuan_2_1_QCC_2024_TEAM_1_2024-03-12_21-52-37.pdf', '2024-03-12 21:52:37.917327', 'TEAM 1', 2, 1),
	(23, 'WAITING', 'Tugas_Terstruktur_2_QCC_2024_TEAM_2_2024-03-12_21-53-49.pdf', '.\\uploads\\QCC 2024\\TEAM 2\\Tugas_Terstruktur_2_QCC_2024_TEAM_2_2024-03-12_21-53-49.pdf', '2024-03-12 21:53:49.057275', 'TEAM 2', 2, 2),
	(24, 'WAITING', 'Rangkuman_Module_1_QCC_2024_TEAM_2_2024-03-12_21-53-49.docx', '.\\uploads\\QCC 2024\\TEAM 2\\Rangkuman_Module_1_QCC_2024_TEAM_2_2024-03-12_21-53-49.docx', '2024-03-12 21:53:49.057275', 'TEAM 2', 2, 2),
	(25, 'WAITING', 'Tugas_terstruktur_2_QCC_2024_TEAM_2_2024-03-12_21-53-49.docx', '.\\uploads\\QCC 2024\\TEAM 2\\Tugas_terstruktur_2_QCC_2024_TEAM_2_2024-03-12_21-53-49.docx', '2024-03-12 21:53:49.057275', 'TEAM 2', 2, 2),
	(26, 'WAITING', 'Tugas_terstruktur_2_SS_2024_TEAM_3_2024-03-12_23-27-03.docx', '.\\uploads\\SS 2024\\TEAM 3\\Tugas_terstruktur_2_SS_2024_TEAM_3_2024-03-12_23-27-03.docx', '2024-03-12 23:27:03.470445', 'TEAM 3', 3, 3),
	(27, 'WAITING', 'Pertemuan_2_1_SS_2024_TEAM_3_2024-03-12_23-27-09.pdf', '.\\uploads\\SS 2024\\TEAM 3\\Pertemuan_2_1_SS_2024_TEAM_3_2024-03-12_23-27-09.pdf', '2024-03-12 23:27:09.017794', 'TEAM 3', 4, 3);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
