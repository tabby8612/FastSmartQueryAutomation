-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               PostgreSQL 18.6 on x86_64-windows, compiled by msvc-19.44.35228, 64-bit
-- Server OS:                    
-- HeidiSQL Version:             12.20.0.7320
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES  */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table public.alembic_version
CREATE TABLE IF NOT EXISTS "alembic_version" (
	"version_num" VARCHAR(32) NOT NULL,
	PRIMARY KEY ("version_num")
);

-- Dumping data for table public.alembic_version: 1 rows
DELETE FROM "alembic_version";
INSERT INTO "alembic_version" ("version_num") VALUES
	('423dcafd0b3d');

-- Dumping structure for table public.announcements
CREATE TABLE IF NOT EXISTS "announcements" (
	"id" SERIAL NOT NULL,
	"creator_id" INTEGER NOT NULL,
	"title" VARCHAR(255) NOT NULL,
	"body" TEXT NOT NULL,
	"channel" VARCHAR(255) NOT NULL DEFAULT 'email',
	"audience_type" VARCHAR(255) NOT NULL DEFAULT 'all',
	"department_id" INTEGER NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	CONSTRAINT "announcements_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "announcements_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.announcements: 8 rows
DELETE FROM "announcements";
INSERT INTO "announcements" ("id", "creator_id", "title", "body", "channel", "audience_type", "department_id", "created_at", "updated_at") VALUES
	(1, 1, 'Midterm Schedule Released', 'The midterm schedule...', 'email', 'all', NULL, '2026-09-29 20:55:34.077034+05', '2026-09-29 20:55:34.077034+05'),
	(2, 1, 'hello', 'hello', 'email', 'all', NULL, '2026-09-30 10:58:54.530598+05', '2026-09-30 10:58:54.530598+05'),
	(3, 1, 'This is announcement test for information technology department', 'This is announcement test for information technology department', 'email', 'department', 6, '2026-09-30 12:23:44.113811+05', '2026-09-30 12:23:44.113811+05'),
	(4, 1, 'University Hoilday', 'Tomorrow is University Hoilday', 'email', 'all', NULL, '2026-09-30 13:01:47.464023+05', '2026-09-30 13:01:47.464023+05'),
	(5, 1, 'Scheduled System Maintenance Notice', 'Virtual University of Pakistan will be conducting scheduled maintenance activities to ensure the smooth and reliable operation of its online services.

During the maintenance period, all public-facing and internal portals, websites, and online services of the University will remain temporarily unavailable.


Maintenance Schedule

Start: Friday, 6 November 2026 – 11:30 PM

End: Sunday, 8 November 2026 – 11:59 PM

 

The University regrets any inconvenience this temporary service interruption may cause and appreciates the patience, understanding, and cooperation of all students, faculty members, staff, and other stakeholders.

All services will be restored upon successful completion of the maintenance activities.

 

Thank you for your cooperation.

', 'email', 'all', NULL, '2026-11-13 09:51:17.494949+05', '2026-11-13 09:51:17.494949+05'),
	(6, 1, '', 'Virtual University of Pakistan will be conducting scheduled maintenance activities to ensure the smooth and reliable operation of its online services.

During the maintenance period, all public-facing and internal portals, websites, and online services of the University will remain temporarily unavailable.', 'email', 'all', NULL, '2026-11-13 09:53:57.722415+05', '2026-11-13 09:53:57.722415+05'),
	(7, 1, 'Issuance of Semester Voucher for Fall, 2026', 'Students are informed that Semester Voucher for Fall''2026 has been issued with due date November 05, 2026. Students may convert full semester voucher into installments through their LMS login, procedure is as under:

o    Log on to your VULMS.

o    Go to “Account book”.

o    Click on "Convert to Installments" option against full semester voucher and make installments, as admissible.

In case of any query, students may contact us by using the “Help” link available at VU website and VULMS.', 'email', 'department', 7, '2026-11-14 20:59:13.795287+05', '2026-11-14 20:59:13.795287+05'),
	(8, 1, 'NOTICE - EXTENSION OF COURSE SELECTION DEADLINE FALL 2026 SEMESTER', '<p style="text-align: left;">Dear Students,</p><p style="text-align: left;"></p><p style="text-align: left;">This is to inform you that the deadline for course selection (Add/Drop/Replace) for the Fall 2026 semester has been extended till <strong>Tuesday, October 27, 2026.</strong>&nbsp;This is the&nbsp;final intimation and opportunity&nbsp;for students who have not yet completed their course selection/enrollment due to any reason.</p>', 'email', 'department', 7, '2026-11-14 21:09:14.104684+05', '2026-11-14 21:09:14.104684+05');

-- Dumping structure for table public.attachments
CREATE TABLE IF NOT EXISTS "attachments" (
	"id" SERIAL NOT NULL,
	"ticket_id" INTEGER NULL DEFAULT NULL,
	"original_filename" VARCHAR(255) NOT NULL,
	"stored_filename" VARCHAR(255) NOT NULL,
	"file_path" VARCHAR(500) NOT NULL,
	"file_type" VARCHAR(255) NOT NULL,
	"file_size" BIGINT NOT NULL,
	"uploaded_by" INTEGER NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	CONSTRAINT "attachments_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "tickets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "attachments_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.attachments: 5 rows
DELETE FROM "attachments";
INSERT INTO "attachments" ("id", "ticket_id", "original_filename", "stored_filename", "file_path", "file_type", "file_size", "uploaded_by", "created_at", "updated_at") VALUES
	(1, 330, 'Tabish_Developer_Dubai_CV.pdf', 'ticket_attachments/afc4ac30f085472abe83bf47a5af57c5.pdf', 'uploads\ticket_attachments\afc4ac30f085472abe83bf47a5af57c5.pdf', 'application/pdf', 45583, 2, '2026-11-07 15:07:16.28398+05', '2026-11-07 15:07:16.28398+05'),
	(2, 331, 'Tabish_Developer_Dubai_CV.pdf', 'ticket_attachments/0d7c1d11d55e4bd2ab908193c8164ef5.pdf', 'uploads\ticket_attachments\0d7c1d11d55e4bd2ab908193c8164ef5.pdf', 'application/pdf', 45583, 2, '2026-11-07 15:10:38.639016+05', '2026-11-07 15:10:38.639016+05'),
	(3, 331, 'tabish_photo.jpg', 'ticket_attachments/b938d376711f4821a393d04d6f96d3f6.jpg', 'uploads\ticket_attachments\b938d376711f4821a393d04d6f96d3f6.jpg', 'image/jpeg', 183392, 2, '2026-11-07 15:10:38.639016+05', '2026-11-07 15:10:38.639016+05'),
	(4, 333, 'Tabish_Developer_Dubai_CV.pdf', 'ticket_attachments/6eedc53766224569a7661a2e92866c30.pdf', 'uploads\ticket_attachments\6eedc53766224569a7661a2e92866c30.pdf', 'application/pdf', 45583, 2, '2026-11-07 19:31:53.920319+05', '2026-11-07 19:31:53.920319+05'),
	(5, 348, 'Tabish_Developer_Dubai_CV.pdf', 'ticket_attachments/cadf3d6ce3f34ce795f3236e48d683b0.pdf', 'uploads\ticket_attachments\cadf3d6ce3f34ce795f3236e48d683b0.pdf', 'application/pdf', 45583, 19, '2026-11-12 14:10:47.221046+05', '2026-11-12 14:10:47.221046+05');

-- Dumping structure for table public.audit_logs
CREATE TABLE IF NOT EXISTS "audit_logs" (
	"id" SERIAL NOT NULL,
	"actor_id" INTEGER NULL DEFAULT NULL,
	"actor_name" VARCHAR(255) NULL DEFAULT NULL,
	"actor_role" VARCHAR(100) NULL DEFAULT NULL,
	"action" VARCHAR(100) NOT NULL,
	"entity_type" VARCHAR(100) NOT NULL,
	"entity_id" VARCHAR(100) NULL DEFAULT NULL,
	"description" TEXT NOT NULL,
	"old_values" JSONB NULL DEFAULT NULL,
	"new_values" JSONB NULL DEFAULT NULL,
	"metadata_" JSONB NULL DEFAULT NULL,
	"status" VARCHAR(10) NOT NULL,
	"request_id" VARCHAR(100) NULL DEFAULT NULL,
	"ip_address" VARCHAR(45) NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	CONSTRAINT "audit_logs_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.audit_logs: 539 rows
DELETE FROM "audit_logs";
INSERT INTO "audit_logs" ("id", "actor_id", "actor_name", "actor_role", "action", "entity_type", "entity_id", "description", "old_values", "new_values", "metadata_", "status", "request_id", "ip_address", "created_at", "updated_at") VALUES
	(1, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-24 19:46:14.8801+05', '2026-10-24 19:46:14.8801+05'),
	(2, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-24 19:46:34.783411+05', '2026-10-24 19:46:34.783411+05'),
	(3, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-24 20:00:17.903492+05', '2026-10-24 20:00:17.903492+05'),
	(4, 2, NULL, NULL, 'ticket.created', 'ticket', '77', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-24 20:05:43.186576+05', '2026-10-24 20:05:43.186576+05'),
	(5, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-24 20:08:43.503279+05', '2026-10-24 20:08:43.503279+05'),
	(6, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 11:54:08.364472+05', '2026-10-25 11:54:08.364472+05'),
	(7, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 12:01:57.103266+05', '2026-10-25 12:01:57.103266+05'),
	(8, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 12:37:36.399128+05', '2026-10-25 12:37:36.399128+05'),
	(9, 1, NULL, NULL, 'reply.created', 'ticket', NULL, 'Ticket report has been exported', 'null', 'null', 'null', 'success', NULL, '127.0.0.1', '2026-10-25 12:38:08.788484+05', '2026-10-25 12:38:08.788484+05'),
	(10, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 12:39:00.571163+05', '2026-10-25 12:39:00.571163+05'),
	(11, 1, NULL, NULL, 'reply.created', 'ticket', NULL, 'Ticket report has been exported', 'null', 'null', 'null', 'success', NULL, '127.0.0.1', '2026-10-25 12:39:00.859875+05', '2026-10-25 12:39:00.859875+05'),
	(12, 1, NULL, NULL, 'reply.created', 'ticket', NULL, 'Ticket report has been exported', 'null', 'null', 'null', 'success', NULL, '127.0.0.1', '2026-10-25 12:39:01.791422+05', '2026-10-25 12:39:01.791422+05'),
	(13, NULL, NULL, NULL, 'email.processed', 'ticket', '138', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 12:40:22.289245+05', '2026-10-25 12:40:22.289245+05'),
	(14, NULL, NULL, NULL, 'ticket.escalated', 'ticket', '70', 'ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 13:25:26.937641+05', '2026-10-25 13:25:26.937641+05'),
	(15, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 13:34:03.062546+05', '2026-10-25 13:34:03.062546+05'),
	(21, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 14:10:50.142086+05', '2026-10-25 14:10:50.142086+05'),
	(24, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 14:15:27.008934+05', '2026-10-25 14:15:27.008934+05'),
	(25, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 15:39:18.096777+05', '2026-10-25 15:39:18.096777+05'),
	(28, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-25 16:20:46.283429+05', '2026-10-25 16:20:46.283429+05'),
	(34, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 07:56:04.644958+05', '2026-10-26 07:56:04.644958+05'),
	(35, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 08:06:48.434026+05', '2026-10-26 08:06:48.434026+05'),
	(40, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 08:37:26.268831+05', '2026-10-26 08:37:26.268831+05'),
	(43, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 09:12:09.522013+05', '2026-10-26 09:12:09.522013+05'),
	(46, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 09:36:28.064005+05', '2026-10-26 09:36:28.064005+05'),
	(47, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 09:44:10.597855+05', '2026-10-26 09:44:10.597855+05'),
	(50, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 18:55:09.052996+05', '2026-10-26 18:55:09.052996+05'),
	(53, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 19:14:13.926975+05', '2026-10-26 19:14:13.926975+05'),
	(54, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 19:14:32.682298+05', '2026-10-26 19:14:32.682298+05'),
	(55, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 19:40:10.835524+05', '2026-10-26 19:40:10.835524+05'),
	(56, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-10-26 20:22:06.29259+05', '2026-10-26 20:22:06.29259+05'),
	(59, NULL, NULL, NULL, 'email.processed', 'ticket', '139', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:22:16.902332+05', '2026-11-03 15:22:16.902332+05'),
	(60, NULL, NULL, NULL, 'email.processed', 'ticket', '140', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:23:39.474443+05', '2026-11-03 15:23:39.474443+05'),
	(61, NULL, NULL, NULL, 'email.processed', 'ticket', '141', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:28:02.688923+05', '2026-11-03 15:28:02.688923+05'),
	(62, NULL, NULL, NULL, 'email.processed', 'ticket', '142', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:31:02.917103+05', '2026-11-03 15:31:02.917103+05'),
	(63, NULL, NULL, NULL, 'email.processed', 'ticket', '143', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:38:20.821948+05', '2026-11-03 15:38:20.821948+05'),
	(64, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:51:13.891329+05', '2026-11-03 15:51:13.891329+05'),
	(65, NULL, NULL, NULL, 'email.processed', 'ticket', '144', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:52:16.625167+05', '2026-11-03 15:52:16.625167+05'),
	(66, NULL, NULL, NULL, 'email.processed', 'ticket', '145', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 15:59:55.055045+05', '2026-11-03 15:59:55.055045+05'),
	(67, NULL, NULL, NULL, 'email.processed', 'ticket', '146', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:05:33.690219+05', '2026-11-03 16:05:33.690219+05'),
	(68, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:15:55.767756+05', '2026-11-03 16:15:55.767756+05'),
	(69, NULL, NULL, NULL, 'email.processed', 'ticket', '147', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:20:02.628191+05', '2026-11-03 16:20:02.628191+05'),
	(70, NULL, NULL, NULL, 'email.processed', 'ticket', '148', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:23:02.563494+05', '2026-11-03 16:23:02.563494+05'),
	(71, NULL, NULL, NULL, 'email.processed', 'ticket', '149', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:33:53.185426+05', '2026-11-03 16:33:53.185426+05'),
	(72, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:34:38.755136+05', '2026-11-03 16:34:38.755136+05'),
	(73, NULL, NULL, NULL, 'email.processed', 'ticket', '150', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:36:53.041271+05', '2026-11-03 16:36:53.041271+05'),
	(74, NULL, NULL, NULL, 'email.processed', 'ticket', '151', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:42:02.059272+05', '2026-11-03 16:42:02.059272+05'),
	(75, NULL, NULL, NULL, 'email.processed', 'ticket', '152', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:52:20.084025+05', '2026-11-03 16:52:20.084025+05'),
	(76, NULL, NULL, NULL, 'email.processed', 'ticket', '153', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:56:51.004064+05', '2026-11-03 16:56:51.004064+05'),
	(77, NULL, NULL, NULL, 'email.processed', 'ticket', '154', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 16:59:50.949731+05', '2026-11-03 16:59:50.949731+05'),
	(78, NULL, NULL, NULL, 'email.processed', 'ticket', '155', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:02:50.843946+05', '2026-11-03 17:02:50.843946+05'),
	(79, NULL, NULL, NULL, 'email.processed', 'ticket', '156', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:05:50.92944+05', '2026-11-03 17:05:50.92944+05'),
	(80, NULL, NULL, NULL, 'email.processed', 'ticket', '157', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:08:50.802322+05', '2026-11-03 17:08:50.802322+05'),
	(81, NULL, NULL, NULL, 'email.processed', 'ticket', '158', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:11:51.268473+05', '2026-11-03 17:11:51.268473+05'),
	(82, NULL, NULL, NULL, 'email.processed', 'ticket', '159', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:14:51.326756+05', '2026-11-03 17:14:51.326756+05'),
	(83, NULL, NULL, NULL, 'email.processed', 'ticket', '160', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:17:51.431813+05', '2026-11-03 17:17:51.431813+05'),
	(84, NULL, NULL, NULL, 'email.processed', 'ticket', '161', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:20:50.846143+05', '2026-11-03 17:20:50.846143+05'),
	(85, NULL, NULL, NULL, 'email.processed', 'ticket', '162', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:23:50.801629+05', '2026-11-03 17:23:50.801629+05'),
	(86, NULL, NULL, NULL, 'email.processed', 'ticket', '163', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:26:50.974558+05', '2026-11-03 17:26:50.974558+05'),
	(87, NULL, NULL, NULL, 'email.processed', 'ticket', '164', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:29:50.821273+05', '2026-11-03 17:29:50.821273+05'),
	(88, NULL, NULL, NULL, 'email.processed', 'ticket', '165', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:32:51.111009+05', '2026-11-03 17:32:51.111009+05'),
	(89, NULL, NULL, NULL, 'email.processed', 'ticket', '166', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:35:50.802417+05', '2026-11-03 17:35:50.802417+05'),
	(90, NULL, NULL, NULL, 'email.processed', 'ticket', '167', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:38:50.924213+05', '2026-11-03 17:38:50.924213+05'),
	(91, NULL, NULL, NULL, 'email.processed', 'ticket', '168', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:41:50.924266+05', '2026-11-03 17:41:50.924266+05'),
	(92, NULL, NULL, NULL, 'email.processed', 'ticket', '169', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:44:50.793726+05', '2026-11-03 17:44:50.793726+05'),
	(93, NULL, NULL, NULL, 'email.processed', 'ticket', '170', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:47:50.793455+05', '2026-11-03 17:47:50.793455+05'),
	(94, NULL, NULL, NULL, 'email.processed', 'ticket', '171', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:50:50.948418+05', '2026-11-03 17:50:50.948418+05'),
	(95, NULL, NULL, NULL, 'email.processed', 'ticket', '172', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:53:50.969009+05', '2026-11-03 17:53:50.969009+05'),
	(96, NULL, NULL, NULL, 'email.processed', 'ticket', '173', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:56:50.90706+05', '2026-11-03 17:56:50.90706+05'),
	(97, NULL, NULL, NULL, 'email.processed', 'ticket', '174', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 17:59:50.880132+05', '2026-11-03 17:59:50.880132+05'),
	(98, NULL, NULL, NULL, 'email.processed', 'ticket', '175', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:02:50.941786+05', '2026-11-03 18:02:50.941786+05'),
	(99, NULL, NULL, NULL, 'email.processed', 'ticket', '176', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:08:51.055449+05', '2026-11-03 18:08:51.055449+05'),
	(100, NULL, NULL, NULL, 'email.processed', 'ticket', '177', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:11:50.925757+05', '2026-11-03 18:11:50.925757+05'),
	(101, NULL, NULL, NULL, 'email.processed', 'ticket', '178', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:14:51.641002+05', '2026-11-03 18:14:51.641002+05'),
	(102, NULL, NULL, NULL, 'email.processed', 'ticket', '179', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:17:51.023242+05', '2026-11-03 18:17:51.023242+05'),
	(103, NULL, NULL, NULL, 'email.processed', 'ticket', '180', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:20:50.993411+05', '2026-11-03 18:20:50.993411+05'),
	(104, NULL, NULL, NULL, 'email.processed', 'ticket', '181', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:23:51.033417+05', '2026-11-03 18:23:51.033417+05'),
	(105, NULL, NULL, NULL, 'email.processed', 'ticket', '182', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:26:51.31707+05', '2026-11-03 18:26:51.31707+05'),
	(106, NULL, NULL, NULL, 'email.processed', 'ticket', '183', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:29:50.929492+05', '2026-11-03 18:29:50.929492+05'),
	(107, NULL, NULL, NULL, 'email.processed', 'ticket', '184', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:32:50.983508+05', '2026-11-03 18:32:50.983508+05'),
	(108, NULL, NULL, NULL, 'email.processed', 'ticket', '185', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:35:51.278457+05', '2026-11-03 18:35:51.278457+05'),
	(109, NULL, NULL, NULL, 'email.processed', 'ticket', '186', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:38:51.144592+05', '2026-11-03 18:38:51.144592+05'),
	(110, NULL, NULL, NULL, 'email.processed', 'ticket', '187', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:41:50.914021+05', '2026-11-03 18:41:50.914021+05'),
	(111, NULL, NULL, NULL, 'email.processed', 'ticket', '188', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:44:50.925816+05', '2026-11-03 18:44:50.925816+05'),
	(112, NULL, NULL, NULL, 'email.processed', 'ticket', '189', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:47:50.869345+05', '2026-11-03 18:47:50.869345+05'),
	(113, NULL, NULL, NULL, 'email.processed', 'ticket', '190', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:50:51.034844+05', '2026-11-03 18:50:51.034844+05'),
	(114, NULL, NULL, NULL, 'email.processed', 'ticket', '191', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:53:51.105739+05', '2026-11-03 18:53:51.105739+05'),
	(115, NULL, NULL, NULL, 'email.processed', 'ticket', '192', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:56:51.347236+05', '2026-11-03 18:56:51.347236+05'),
	(116, NULL, NULL, NULL, 'email.processed', 'ticket', '193', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 18:59:50.856081+05', '2026-11-03 18:59:50.856081+05'),
	(117, NULL, NULL, NULL, 'email.processed', 'ticket', '194', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:02:51.088647+05', '2026-11-03 19:02:51.088647+05'),
	(118, NULL, NULL, NULL, 'email.processed', 'ticket', '195', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:05:50.962606+05', '2026-11-03 19:05:50.962606+05'),
	(119, NULL, NULL, NULL, 'email.processed', 'ticket', '196', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:08:50.791356+05', '2026-11-03 19:08:50.791356+05'),
	(120, NULL, NULL, NULL, 'email.processed', 'ticket', '197', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:11:51.581516+05', '2026-11-03 19:11:51.581516+05'),
	(121, NULL, NULL, NULL, 'email.processed', 'ticket', '198', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:14:51.55404+05', '2026-11-03 19:14:51.55404+05'),
	(122, NULL, NULL, NULL, 'email.processed', 'ticket', '199', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:17:51.169628+05', '2026-11-03 19:17:51.169628+05'),
	(123, NULL, NULL, NULL, 'email.processed', 'ticket', '200', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:20:51.186391+05', '2026-11-03 19:20:51.186391+05'),
	(124, NULL, NULL, NULL, 'email.processed', 'ticket', '201', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:23:50.964098+05', '2026-11-03 19:23:50.964098+05'),
	(125, NULL, NULL, NULL, 'email.processed', 'ticket', '202', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:26:50.881532+05', '2026-11-03 19:26:50.881532+05'),
	(126, NULL, NULL, NULL, 'email.processed', 'ticket', '203', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:29:50.924971+05', '2026-11-03 19:29:50.924971+05'),
	(127, NULL, NULL, NULL, 'email.processed', 'ticket', '204', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:32:50.96379+05', '2026-11-03 19:32:50.96379+05'),
	(128, NULL, NULL, NULL, 'email.processed', 'ticket', '205', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:35:51.314911+05', '2026-11-03 19:35:51.314911+05'),
	(129, NULL, NULL, NULL, 'email.processed', 'ticket', '206', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:38:50.95671+05', '2026-11-03 19:38:50.95671+05'),
	(130, NULL, NULL, NULL, 'email.processed', 'ticket', '207', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:41:50.876254+05', '2026-11-03 19:41:50.876254+05'),
	(131, NULL, NULL, NULL, 'email.processed', 'ticket', '208', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:44:50.842906+05', '2026-11-03 19:44:50.842906+05'),
	(132, NULL, NULL, NULL, 'email.processed', 'ticket', '209', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:47:51.154225+05', '2026-11-03 19:47:51.154225+05'),
	(133, NULL, NULL, NULL, 'email.processed', 'ticket', '210', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:50:50.920594+05', '2026-11-03 19:50:50.920594+05'),
	(134, NULL, NULL, NULL, 'email.processed', 'ticket', '211', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:53:50.804076+05', '2026-11-03 19:53:50.804076+05'),
	(135, NULL, NULL, NULL, 'email.processed', 'ticket', '212', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:56:51.033905+05', '2026-11-03 19:56:51.033905+05'),
	(136, NULL, NULL, NULL, 'email.processed', 'ticket', '213', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 19:59:50.885298+05', '2026-11-03 19:59:50.885298+05'),
	(137, NULL, NULL, NULL, 'email.processed', 'ticket', '214', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 20:02:51.404815+05', '2026-11-03 20:02:51.404815+05'),
	(138, NULL, NULL, NULL, 'email.processed', 'ticket', '215', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 20:05:50.974109+05', '2026-11-03 20:05:50.974109+05'),
	(139, NULL, NULL, NULL, 'email.processed', 'ticket', '216', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 20:08:51.357321+05', '2026-11-03 20:08:51.357321+05'),
	(140, NULL, NULL, NULL, 'email.processed', 'ticket', '217', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 20:20:52.105482+05', '2026-11-03 20:20:52.105482+05'),
	(141, NULL, NULL, NULL, 'email.processed', 'ticket', '218', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 20:23:51.628439+05', '2026-11-03 20:23:51.628439+05'),
	(142, NULL, NULL, NULL, 'email.processed', 'ticket', '219', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 20:26:51.423078+05', '2026-11-03 20:26:51.423078+05'),
	(143, NULL, NULL, NULL, 'email.processed', 'ticket', '220', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 21:56:53.818419+05', '2026-11-03 21:56:53.818419+05'),
	(144, NULL, NULL, NULL, 'email.processed', 'ticket', '221', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 21:59:51.362901+05', '2026-11-03 21:59:51.362901+05'),
	(145, NULL, NULL, NULL, 'email.processed', 'ticket', '222', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:02:50.854032+05', '2026-11-03 22:02:50.854032+05'),
	(146, NULL, NULL, NULL, 'email.processed', 'ticket', '223', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:05:50.987387+05', '2026-11-03 22:05:50.987387+05'),
	(147, NULL, NULL, NULL, 'email.processed', 'ticket', '224', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:08:50.931663+05', '2026-11-03 22:08:50.931663+05'),
	(148, NULL, NULL, NULL, 'email.processed', 'ticket', '225', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:11:51.006356+05', '2026-11-03 22:11:51.006356+05'),
	(149, NULL, NULL, NULL, 'email.processed', 'ticket', '226', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:14:52.170405+05', '2026-11-03 22:14:52.170405+05'),
	(150, NULL, NULL, NULL, 'email.processed', 'ticket', '227', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:17:52.701388+05', '2026-11-03 22:17:52.701388+05'),
	(151, NULL, NULL, NULL, 'email.processed', 'ticket', '228', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:20:51.880037+05', '2026-11-03 22:20:51.880037+05'),
	(152, NULL, NULL, NULL, 'email.processed', 'ticket', '229', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:23:51.219677+05', '2026-11-03 22:23:51.219677+05'),
	(153, NULL, NULL, NULL, 'email.processed', 'ticket', '230', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:26:50.967366+05', '2026-11-03 22:26:50.967366+05'),
	(154, NULL, NULL, NULL, 'email.processed', 'ticket', '231', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:29:50.97432+05', '2026-11-03 22:29:50.97432+05'),
	(155, NULL, NULL, NULL, 'email.processed', 'ticket', '232', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:32:51.001871+05', '2026-11-03 22:32:51.001871+05'),
	(156, NULL, NULL, NULL, 'email.processed', 'ticket', '233', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:35:51.089314+05', '2026-11-03 22:35:51.089314+05'),
	(157, NULL, NULL, NULL, 'email.processed', 'ticket', '234', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:38:50.774331+05', '2026-11-03 22:38:50.774331+05'),
	(158, NULL, NULL, NULL, 'email.processed', 'ticket', '235', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:41:50.812113+05', '2026-11-03 22:41:50.812113+05'),
	(159, NULL, NULL, NULL, 'email.processed', 'ticket', '236', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:44:51.286708+05', '2026-11-03 22:44:51.286708+05'),
	(160, NULL, NULL, NULL, 'email.processed', 'ticket', '237', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:47:52.168908+05', '2026-11-03 22:47:52.168908+05'),
	(161, NULL, NULL, NULL, 'email.processed', 'ticket', '238', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:50:50.813985+05', '2026-11-03 22:50:50.813985+05'),
	(162, NULL, NULL, NULL, 'email.processed', 'ticket', '239', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:53:52.047453+05', '2026-11-03 22:53:52.047453+05'),
	(163, NULL, NULL, NULL, 'email.processed', 'ticket', '240', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:56:51.294908+05', '2026-11-03 22:56:51.294908+05'),
	(164, NULL, NULL, NULL, 'email.processed', 'ticket', '241', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 22:59:50.986217+05', '2026-11-03 22:59:50.986217+05'),
	(165, NULL, NULL, NULL, 'email.processed', 'ticket', '242', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 23:02:51.208562+05', '2026-11-03 23:02:51.208562+05'),
	(166, NULL, NULL, NULL, 'email.processed', 'ticket', '243', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 23:05:51.057891+05', '2026-11-03 23:05:51.057891+05'),
	(167, NULL, NULL, NULL, 'email.processed', 'ticket', '244', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 23:08:51.049671+05', '2026-11-03 23:08:51.049671+05'),
	(168, NULL, NULL, NULL, 'email.processed', 'ticket', '245', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-03 23:11:51.387291+05', '2026-11-03 23:11:51.387291+05'),
	(169, NULL, NULL, NULL, 'email.processed', 'ticket', '246', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 08:29:41.530856+05', '2026-11-04 08:29:41.530856+05'),
	(170, NULL, NULL, NULL, 'email.processed', 'ticket', '247', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:39:54.707343+05', '2026-11-04 10:39:54.707343+05'),
	(171, NULL, NULL, NULL, 'email.processed', 'ticket', '248', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:42:54.125104+05', '2026-11-04 10:42:54.125104+05'),
	(172, NULL, NULL, NULL, 'email.processed', 'ticket', '249', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:45:54.090891+05', '2026-11-04 10:45:54.090891+05'),
	(173, NULL, NULL, NULL, 'email.processed', 'ticket', '250', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:48:53.990394+05', '2026-11-04 10:48:53.990394+05'),
	(174, NULL, NULL, NULL, 'email.processed', 'ticket', '251', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:51:53.855315+05', '2026-11-04 10:51:53.855315+05'),
	(175, NULL, NULL, NULL, 'email.processed', 'ticket', '252', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:54:53.790529+05', '2026-11-04 10:54:53.790529+05'),
	(176, NULL, NULL, NULL, 'email.processed', 'ticket', '253', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 10:57:54.280796+05', '2026-11-04 10:57:54.280796+05'),
	(177, NULL, NULL, NULL, 'email.processed', 'ticket', '254', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:00:53.856604+05', '2026-11-04 11:00:53.856604+05'),
	(178, NULL, NULL, NULL, 'email.processed', 'ticket', '255', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:03:53.906271+05', '2026-11-04 11:03:53.906271+05'),
	(179, NULL, NULL, NULL, 'email.processed', 'ticket', '256', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:06:54.077166+05', '2026-11-04 11:06:54.077166+05'),
	(180, NULL, NULL, NULL, 'email.processed', 'ticket', '257', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:09:54.045764+05', '2026-11-04 11:09:54.045764+05'),
	(181, NULL, NULL, NULL, 'email.processed', 'ticket', '258', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:12:54.024802+05', '2026-11-04 11:12:54.024802+05'),
	(182, NULL, NULL, NULL, 'email.processed', 'ticket', '259', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:15:54.389908+05', '2026-11-04 11:15:54.389908+05'),
	(183, NULL, NULL, NULL, 'email.processed', 'ticket', '260', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:18:53.998435+05', '2026-11-04 11:18:53.998435+05'),
	(184, NULL, NULL, NULL, 'email.processed', 'ticket', '261', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:21:54.137062+05', '2026-11-04 11:21:54.137062+05'),
	(185, NULL, NULL, NULL, 'email.processed', 'ticket', '262', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:24:54.102053+05', '2026-11-04 11:24:54.102053+05'),
	(186, NULL, NULL, NULL, 'email.processed', 'ticket', '263', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:30:54.048077+05', '2026-11-04 11:30:54.048077+05'),
	(187, NULL, NULL, NULL, 'email.processed', 'ticket', '264', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:33:53.979886+05', '2026-11-04 11:33:53.979886+05'),
	(188, NULL, NULL, NULL, 'email.processed', 'ticket', '265', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:36:54.892762+05', '2026-11-04 11:36:54.892762+05'),
	(189, NULL, NULL, NULL, 'email.processed', 'ticket', '266', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:39:53.841755+05', '2026-11-04 11:39:53.841755+05'),
	(190, NULL, NULL, NULL, 'email.processed', 'ticket', '267', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:42:54.068783+05', '2026-11-04 11:42:54.068783+05'),
	(191, NULL, NULL, NULL, 'email.processed', 'ticket', '268', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:45:54.245321+05', '2026-11-04 11:45:54.245321+05'),
	(192, NULL, NULL, NULL, 'email.processed', 'ticket', '269', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:48:54.227864+05', '2026-11-04 11:48:54.227864+05'),
	(193, NULL, NULL, NULL, 'email.processed', 'ticket', '270', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:51:54.102014+05', '2026-11-04 11:51:54.102014+05'),
	(194, NULL, NULL, NULL, 'email.processed', 'ticket', '271', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 11:56:08.965925+05', '2026-11-04 11:56:08.965925+05'),
	(195, NULL, NULL, NULL, 'email.processed', 'ticket', '272', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:08:05.072204+05', '2026-11-04 12:08:05.072204+05'),
	(196, NULL, NULL, NULL, 'email.processed', 'ticket', '273', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:11:05.13994+05', '2026-11-04 12:11:05.13994+05'),
	(197, NULL, NULL, NULL, 'email.processed', 'ticket', '274', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:14:05.103352+05', '2026-11-04 12:14:05.103352+05'),
	(198, NULL, NULL, NULL, 'email.processed', 'ticket', '275', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:17:09.855358+05', '2026-11-04 12:17:09.855358+05'),
	(199, NULL, NULL, NULL, 'email.processed', 'ticket', '276', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:23:03.649059+05', '2026-11-04 12:23:03.649059+05'),
	(200, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:25:35.959818+05', '2026-11-04 12:25:35.959818+05'),
	(201, NULL, NULL, NULL, 'email.processed', 'ticket', '277', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:26:03.711644+05', '2026-11-04 12:26:03.711644+05'),
	(202, NULL, NULL, NULL, 'email.processed', 'ticket', '278', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:56:58.661354+05', '2026-11-04 12:56:58.661354+05'),
	(203, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:59:48.94775+05', '2026-11-04 12:59:48.94775+05'),
	(204, NULL, NULL, NULL, 'email.processed', 'ticket', '279', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 12:59:58.372624+05', '2026-11-04 12:59:58.372624+05'),
	(205, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:00:11.789977+05', '2026-11-04 13:00:11.789977+05'),
	(206, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:04:34.781796+05', '2026-11-04 13:04:34.781796+05'),
	(207, NULL, NULL, NULL, 'email.processed', 'ticket', '280', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:07:23.846594+05', '2026-11-04 13:07:23.846594+05'),
	(208, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:12:18.593253+05', '2026-11-04 13:12:18.593253+05'),
	(209, NULL, NULL, NULL, 'email.processed', 'ticket', '281', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:14:06.334808+05', '2026-11-04 13:14:06.334808+05'),
	(210, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:16:33.331215+05', '2026-11-04 13:16:33.331215+05'),
	(211, NULL, NULL, NULL, 'email.processed', 'ticket', '282', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:19:25.080099+05', '2026-11-04 13:19:25.080099+05'),
	(212, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:24:04.182257+05', '2026-11-04 13:24:04.182257+05'),
	(213, NULL, NULL, NULL, 'email.processed', 'ticket', '283', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:28:52.71623+05', '2026-11-04 13:28:52.71623+05'),
	(214, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:30:10.687758+05', '2026-11-04 13:30:10.687758+05'),
	(215, NULL, NULL, NULL, 'email.processed', 'ticket', '284', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:34:23.336454+05', '2026-11-04 13:34:23.336454+05'),
	(216, NULL, NULL, NULL, 'email.processed', 'ticket', '285', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:37:23.441771+05', '2026-11-04 13:37:23.441771+05'),
	(217, NULL, NULL, NULL, 'email.processed', 'ticket', '286', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:40:23.416808+05', '2026-11-04 13:40:23.416808+05'),
	(218, NULL, NULL, NULL, 'email.processed', 'ticket', '287', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:43:23.340301+05', '2026-11-04 13:43:23.340301+05'),
	(219, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:44:28.885447+05', '2026-11-04 13:44:28.885447+05'),
	(220, NULL, NULL, NULL, 'email.processed', 'ticket', '288', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:46:23.393226+05', '2026-11-04 13:46:23.393226+05'),
	(221, NULL, NULL, NULL, 'email.processed', 'ticket', '289', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:49:23.060799+05', '2026-11-04 13:49:23.060799+05'),
	(222, NULL, NULL, NULL, 'email.processed', 'ticket', '290', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:52:58.424785+05', '2026-11-04 13:52:58.424785+05'),
	(223, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:53:43.268255+05', '2026-11-04 13:53:43.268255+05'),
	(224, NULL, NULL, NULL, 'email.processed', 'ticket', '291', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:55:58.318435+05', '2026-11-04 13:55:58.318435+05'),
	(225, NULL, NULL, NULL, 'email.processed', 'ticket', '292', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 13:58:58.432947+05', '2026-11-04 13:58:58.432947+05'),
	(226, NULL, NULL, NULL, 'email.processed', 'ticket', '293', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:06:45.260666+05', '2026-11-04 14:06:45.260666+05'),
	(227, NULL, NULL, NULL, 'email.processed', 'ticket', '294', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:15:19.444863+05', '2026-11-04 14:15:19.444863+05'),
	(228, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:17:34.953376+05', '2026-11-04 14:17:34.953376+05'),
	(229, NULL, NULL, NULL, 'email.processed', 'ticket', '295', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:20:26.727869+05', '2026-11-04 14:20:26.727869+05'),
	(230, NULL, NULL, NULL, 'email.processed', 'ticket', '296', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:23:26.834181+05', '2026-11-04 14:23:26.834181+05'),
	(231, NULL, NULL, NULL, 'email.processed', 'ticket', '297', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:26:26.755987+05', '2026-11-04 14:26:26.755987+05'),
	(232, NULL, NULL, NULL, 'email.processed', 'ticket', '298', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:29:26.768834+05', '2026-11-04 14:29:26.768834+05'),
	(233, NULL, NULL, NULL, 'email.processed', 'ticket', '299', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:32:26.711664+05', '2026-11-04 14:32:26.711664+05'),
	(234, NULL, NULL, NULL, 'email.processed', 'ticket', '300', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:35:26.970875+05', '2026-11-04 14:35:26.970875+05'),
	(235, NULL, NULL, NULL, 'email.processed', 'ticket', '301', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:38:27.213987+05', '2026-11-04 14:38:27.213987+05'),
	(236, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:41:18.635484+05', '2026-11-04 14:41:18.635484+05'),
	(237, NULL, NULL, NULL, 'email.processed', 'ticket', '302', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:41:26.809374+05', '2026-11-04 14:41:26.809374+05'),
	(238, NULL, NULL, NULL, 'email.processed', 'ticket', '303', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:44:26.881903+05', '2026-11-04 14:44:26.881903+05'),
	(239, NULL, NULL, NULL, 'email.processed', 'ticket', '304', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:47:26.830577+05', '2026-11-04 14:47:26.830577+05'),
	(240, NULL, NULL, NULL, 'email.processed', 'ticket', '305', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:50:27.26238+05', '2026-11-04 14:50:27.26238+05'),
	(241, NULL, NULL, NULL, 'email.processed', 'ticket', '306', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:53:26.956945+05', '2026-11-04 14:53:26.956945+05'),
	(242, NULL, NULL, NULL, 'email.processed', 'ticket', '307', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:56:26.876666+05', '2026-11-04 14:56:26.876666+05'),
	(243, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:57:45.167191+05', '2026-11-04 14:57:45.167191+05'),
	(244, NULL, NULL, NULL, 'email.processed', 'ticket', '308', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 14:59:26.791883+05', '2026-11-04 14:59:26.791883+05'),
	(245, NULL, NULL, NULL, 'email.processed', 'ticket', '309', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:05:15.57909+05', '2026-11-04 15:05:15.57909+05'),
	(246, NULL, NULL, NULL, 'email.processed', 'ticket', '310', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:08:15.470728+05', '2026-11-04 15:08:15.470728+05'),
	(247, NULL, NULL, NULL, 'email.processed', 'ticket', '311', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:11:15.446923+05', '2026-11-04 15:11:15.446923+05'),
	(248, NULL, NULL, NULL, 'email.processed', 'ticket', '312', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:14:15.301391+05', '2026-11-04 15:14:15.301391+05'),
	(249, NULL, NULL, NULL, 'email.processed', 'ticket', '313', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:17:15.518504+05', '2026-11-04 15:17:15.518504+05'),
	(250, NULL, NULL, NULL, 'email.processed', 'ticket', '314', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:20:15.326818+05', '2026-11-04 15:20:15.326818+05'),
	(251, NULL, NULL, NULL, 'email.processed', 'ticket', '315', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:23:15.479058+05', '2026-11-04 15:23:15.479058+05'),
	(252, NULL, NULL, NULL, 'email.processed', 'ticket', '316', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:26:15.304009+05', '2026-11-04 15:26:15.304009+05'),
	(253, NULL, NULL, NULL, 'email.processed', 'ticket', '317', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:29:15.264515+05', '2026-11-04 15:29:15.264515+05'),
	(254, NULL, NULL, NULL, 'email.processed', 'ticket', '318', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:32:15.328644+05', '2026-11-04 15:32:15.328644+05'),
	(255, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:33:24.412222+05', '2026-11-04 15:33:24.412222+05'),
	(256, NULL, NULL, NULL, 'email.processed', 'ticket', '319', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:35:15.296327+05', '2026-11-04 15:35:15.296327+05'),
	(257, NULL, NULL, NULL, 'email.processed', 'ticket', '320', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 15:40:18.084897+05', '2026-11-04 15:40:18.084897+05'),
	(258, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 16:02:23.713523+05', '2026-11-04 16:02:23.713523+05'),
	(259, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 16:36:05.246152+05', '2026-11-04 16:36:05.246152+05'),
	(260, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 16:48:21.276927+05', '2026-11-04 16:48:21.276927+05'),
	(261, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 18:39:19.749416+05', '2026-11-04 18:39:19.749416+05'),
	(262, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 19:10:29.765918+05', '2026-11-04 19:10:29.765918+05'),
	(263, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 19:16:56.784272+05', '2026-11-04 19:16:56.784272+05'),
	(264, 2, 'Student User Updated', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 19:47:16.663279+05', '2026-11-04 19:47:16.663279+05'),
	(265, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 20:02:43.275016+05', '2026-11-04 20:02:43.275016+05'),
	(266, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-04 20:17:43.989127+05', '2026-11-04 20:17:43.989127+05'),
	(267, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 08:43:59.573156+05', '2026-11-05 08:43:59.573156+05'),
	(268, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 09:00:58.537854+05', '2026-11-05 09:00:58.537854+05'),
	(269, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 09:35:03.08732+05', '2026-11-05 09:35:03.08732+05'),
	(270, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 09:46:52.232456+05', '2026-11-05 09:46:52.232456+05'),
	(271, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 09:53:48.319234+05', '2026-11-05 09:53:48.319234+05'),
	(272, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 14:48:32.185301+05', '2026-11-05 14:48:32.185301+05'),
	(273, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 15:38:20.481363+05', '2026-11-05 15:38:20.481363+05'),
	(274, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 16:15:43.914772+05', '2026-11-05 16:15:43.914772+05'),
	(275, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 16:36:24.95781+05', '2026-11-05 16:36:24.95781+05'),
	(276, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 16:44:18.214595+05', '2026-11-05 16:44:18.214595+05'),
	(277, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:28:07.748555+05', '2026-11-05 17:28:07.748555+05'),
	(278, 2, NULL, NULL, 'reply.created', 'reply', '27', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:35:27.098443+05', '2026-11-05 17:35:27.098443+05'),
	(279, 2, NULL, NULL, 'reply.created', 'reply', '27', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:35:27.154428+05', '2026-11-05 17:35:27.154428+05'),
	(280, 2, NULL, NULL, 'reply.created', 'reply', '28', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:43:42.32202+05', '2026-11-05 17:43:42.32202+05'),
	(281, 2, NULL, NULL, 'reply.created', 'reply', '28', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:43:42.358383+05', '2026-11-05 17:43:42.358383+05'),
	(282, 2, NULL, NULL, 'reply.created', 'reply', '29', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:45:20.711721+05', '2026-11-05 17:45:20.711721+05'),
	(283, 2, NULL, NULL, 'reply.created', 'reply', '29', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 17:45:20.73393+05', '2026-11-05 17:45:20.73393+05'),
	(284, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:01:26.858319+05', '2026-11-05 18:01:26.858319+05'),
	(285, 2, NULL, NULL, 'ticket.created', 'ticket', NULL, 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:16:51.921315+05', '2026-11-05 18:16:51.921315+05'),
	(286, 2, NULL, NULL, 'ticket.created', 'ticket', '321', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:20:10.631088+05', '2026-11-05 18:20:10.631088+05'),
	(287, 2, NULL, NULL, 'reply.created', 'reply', '30', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:26:08.551309+05', '2026-11-05 18:26:08.551309+05'),
	(288, 2, NULL, NULL, 'reply.created', 'reply', '30', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:26:08.585247+05', '2026-11-05 18:26:08.585247+05'),
	(289, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:27:17.111519+05', '2026-11-05 18:27:17.111519+05'),
	(290, 22, NULL, NULL, 'reply.created', 'reply', '31', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:32:07.04957+05', '2026-11-05 18:32:07.04957+05'),
	(291, 22, NULL, NULL, 'reply.created', 'reply', '31', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:32:07.093835+05', '2026-11-05 18:32:07.093835+05'),
	(292, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '321', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "closed"}', 'null', 'success', NULL, NULL, '2026-11-05 18:32:28.200617+05', '2026-11-05 18:32:28.200617+05'),
	(293, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 18:33:20.629573+05', '2026-11-05 18:33:20.629573+05'),
	(294, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:06:18.00176+05', '2026-11-05 19:06:18.00176+05'),
	(295, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:06:37.082703+05', '2026-11-05 19:06:37.082703+05'),
	(296, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:08:11.542106+05', '2026-11-05 19:08:11.542106+05'),
	(297, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:16:01.551487+05', '2026-11-05 19:16:01.551487+05'),
	(298, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:18:00.503172+05', '2026-11-05 19:18:00.503172+05'),
	(299, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:18:59.687688+05', '2026-11-05 19:18:59.687688+05'),
	(300, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:29:45.910044+05', '2026-11-05 19:29:45.910044+05'),
	(301, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:31:29.305683+05', '2026-11-05 19:31:29.305683+05'),
	(302, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:43:34.383806+05', '2026-11-05 19:43:34.383806+05'),
	(303, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:47:49.979632+05', '2026-11-05 19:47:49.979632+05'),
	(304, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '321', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "resolved"}', 'null', 'success', NULL, NULL, '2026-11-05 19:48:44.514894+05', '2026-11-05 19:48:44.514894+05'),
	(305, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '321', 'ticket status has been changed', '{"priority": "resolved"}', '{"priority": "closed"}', 'null', 'success', NULL, NULL, '2026-11-05 19:48:59.704841+05', '2026-11-05 19:48:59.704841+05'),
	(306, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:49:46.063221+05', '2026-11-05 19:49:46.063221+05'),
	(307, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:51:58.049342+05', '2026-11-05 19:51:58.049342+05'),
	(308, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '17', 'ticket status has been changed', '{"priority": "open"}', '{"priority": "pending"}', 'null', 'success', NULL, NULL, '2026-11-05 19:52:33.930867+05', '2026-11-05 19:52:33.930867+05'),
	(309, 19, NULL, NULL, 'reply.created', 'reply', '32', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:55:19.006007+05', '2026-11-05 19:55:19.006007+05'),
	(310, 19, NULL, NULL, 'reply.created', 'reply', '32', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:55:19.037991+05', '2026-11-05 19:55:19.037991+05'),
	(311, 22, NULL, NULL, 'reply.created', 'reply', '33', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:57:05.928955+05', '2026-11-05 19:57:05.928955+05'),
	(312, 22, NULL, NULL, 'reply.created', 'reply', '33', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 19:57:05.948202+05', '2026-11-05 19:57:05.948202+05'),
	(313, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '17', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "closed"}', 'null', 'success', NULL, NULL, '2026-11-05 19:57:23.303109+05', '2026-11-05 19:57:23.303109+05'),
	(314, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '17', 'ticket status has been changed', '{"priority": "closed"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-05 19:57:56.835675+05', '2026-11-05 19:57:56.835675+05'),
	(315, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 20:07:33.529635+05', '2026-11-05 20:07:33.529635+05'),
	(316, 2, NULL, NULL, 'reply.created', 'reply', '34', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 20:08:08.437756+05', '2026-11-05 20:08:08.437756+05'),
	(317, 2, NULL, NULL, 'reply.created', 'reply', '34', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 20:08:08.473622+05', '2026-11-05 20:08:08.473622+05'),
	(318, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-05 20:22:43.256401+05', '2026-11-05 20:22:43.256401+05'),
	(319, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-06 13:49:32.110621+05', '2026-11-06 13:49:32.110621+05'),
	(320, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 13:56:10.553036+05', '2026-11-07 13:56:10.553036+05'),
	(321, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 14:01:36.830976+05', '2026-11-07 14:01:36.830976+05'),
	(322, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 14:16:24.397222+05', '2026-11-07 14:16:24.397222+05'),
	(323, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 14:47:05.655729+05', '2026-11-07 14:47:05.655729+05'),
	(324, 2, NULL, NULL, 'ticket.created', 'ticket', '322', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 14:47:09.00851+05', '2026-11-07 14:47:09.00851+05'),
	(325, 2, NULL, NULL, 'ticket.created', 'ticket', '330', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 15:07:16.28398+05', '2026-11-07 15:07:16.28398+05'),
	(326, 2, NULL, NULL, 'ticket.created', 'ticket', '331', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 15:10:38.639016+05', '2026-11-07 15:10:38.639016+05'),
	(327, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 16:16:37.564296+05', '2026-11-07 16:16:37.564296+05'),
	(328, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 16:41:48.5141+05', '2026-11-07 16:41:48.5141+05'),
	(329, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 16:42:27.80658+05', '2026-11-07 16:42:27.80658+05'),
	(330, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 18:30:56.89783+05', '2026-11-07 18:30:56.89783+05'),
	(331, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 19:19:13.413183+05', '2026-11-07 19:19:13.413183+05'),
	(332, 2, NULL, NULL, 'ticket.created', 'ticket', '332', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 19:29:18.211395+05', '2026-11-07 19:29:18.211395+05'),
	(333, 2, NULL, NULL, 'ticket.created', 'ticket', '333', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 19:31:53.920319+05', '2026-11-07 19:31:53.920319+05'),
	(334, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 19:33:49.917494+05', '2026-11-07 19:33:49.917494+05'),
	(335, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 19:46:12.75275+05', '2026-11-07 19:46:12.75275+05'),
	(336, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 19:56:08.845185+05', '2026-11-07 19:56:08.845185+05'),
	(337, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:00:35.484996+05', '2026-11-07 20:00:35.484996+05'),
	(338, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:18:22.168831+05', '2026-11-07 20:18:22.168831+05'),
	(339, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:23:09.523691+05', '2026-11-07 20:23:09.523691+05'),
	(340, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:34:54.407839+05', '2026-11-07 20:34:54.407839+05'),
	(341, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:34:59.375673+05', '2026-11-07 20:34:59.375673+05'),
	(342, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:35:07.749684+05', '2026-11-07 20:35:07.749684+05'),
	(343, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 20:36:47.747434+05', '2026-11-07 20:36:47.747434+05'),
	(344, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-07 21:15:11.770521+05', '2026-11-07 21:15:11.770521+05'),
	(345, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 08:05:14.260677+05', '2026-11-09 08:05:14.260677+05'),
	(346, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 08:48:52.673807+05', '2026-11-09 08:48:52.673807+05'),
	(347, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 09:53:03.571965+05', '2026-11-09 09:53:03.571965+05'),
	(348, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 10:29:50.606602+05', '2026-11-09 10:29:50.606602+05'),
	(349, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 12:58:01.110838+05', '2026-11-09 12:58:01.110838+05'),
	(350, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 13:14:47.757984+05', '2026-11-09 13:14:47.757984+05'),
	(351, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 13:16:28.323857+05', '2026-11-09 13:16:28.323857+05'),
	(352, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 13:40:25.983684+05', '2026-11-09 13:40:25.983684+05'),
	(353, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 20:29:20.493087+05', '2026-11-09 20:29:20.493087+05'),
	(354, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 21:00:36.533324+05', '2026-11-09 21:00:36.533324+05'),
	(355, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-09 21:37:16.666001+05', '2026-11-09 21:37:16.666001+05'),
	(356, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 10:08:18.063176+05', '2026-11-10 10:08:18.063176+05'),
	(357, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 10:46:31.282209+05', '2026-11-10 10:46:31.282209+05'),
	(358, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 11:19:59.297046+05', '2026-11-10 11:19:59.297046+05'),
	(359, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 11:51:57.183727+05', '2026-11-10 11:51:57.183727+05'),
	(360, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 14:07:37.803998+05', '2026-11-10 14:07:37.803998+05'),
	(361, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 14:11:44.973717+05', '2026-11-10 14:11:44.973717+05'),
	(362, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 14:26:52.359037+05', '2026-11-10 14:26:52.359037+05'),
	(363, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 14:58:24.539197+05', '2026-11-10 14:58:24.539197+05'),
	(364, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 15:11:46.222956+05', '2026-11-10 15:11:46.222956+05'),
	(365, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 15:13:26.642309+05', '2026-11-10 15:13:26.642309+05'),
	(366, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-10 16:01:49.324167+05', '2026-11-10 16:01:49.324167+05'),
	(373, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 12:36:16.66927+05', '2026-11-12 12:36:16.66927+05'),
	(374, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 12:48:32.510305+05', '2026-11-12 12:48:32.510305+05'),
	(375, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 12:52:43.228958+05', '2026-11-12 12:52:43.228958+05'),
	(376, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 12:53:38.247473+05', '2026-11-12 12:53:38.247473+05'),
	(377, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 12:55:23.305655+05', '2026-11-12 12:55:23.305655+05'),
	(378, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 12:58:37.866486+05', '2026-11-12 12:58:37.866486+05'),
	(379, 19, NULL, NULL, 'ticket.created', 'ticket', '334', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:16:13.002353+05', '2026-11-12 13:16:13.002353+05'),
	(380, 19, NULL, NULL, 'ticket.created', 'ticket', '335', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:19:51.359092+05', '2026-11-12 13:19:51.359092+05'),
	(381, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:29:16.076278+05', '2026-11-12 13:29:16.076278+05'),
	(382, 19, NULL, NULL, 'ticket.created', 'ticket', '336', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:29:59.916178+05', '2026-11-12 13:29:59.916178+05'),
	(383, 19, NULL, NULL, 'ticket.created', 'ticket', '337', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:33:04.06163+05', '2026-11-12 13:33:04.06163+05'),
	(384, 19, NULL, NULL, 'ticket.created', 'ticket', '338', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:37:06.162779+05', '2026-11-12 13:37:06.162779+05'),
	(385, 19, NULL, NULL, 'ticket.created', 'ticket', '339', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:42:51.248692+05', '2026-11-12 13:42:51.248692+05'),
	(386, 19, NULL, NULL, 'ticket.created', 'ticket', '340', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:45:55.865638+05', '2026-11-12 13:45:55.865638+05'),
	(387, 19, NULL, NULL, 'ticket.created', 'ticket', '341', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:48:48.376659+05', '2026-11-12 13:48:48.376659+05'),
	(388, 19, NULL, NULL, 'ticket.created', 'ticket', '342', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:50:40.959993+05', '2026-11-12 13:50:40.959993+05'),
	(389, 19, NULL, NULL, 'ticket.created', 'ticket', '343', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:51:44.54795+05', '2026-11-12 13:51:44.54795+05'),
	(390, 19, NULL, NULL, 'ticket.created', 'ticket', '344', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:52:28.111994+05', '2026-11-12 13:52:28.111994+05'),
	(391, 19, NULL, NULL, 'ticket.created', 'ticket', '345', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:53:11.394977+05', '2026-11-12 13:53:11.394977+05'),
	(392, 19, NULL, NULL, 'ticket.created', 'ticket', '346', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 13:54:16.900187+05', '2026-11-12 13:54:16.900187+05'),
	(393, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 14:02:15.721735+05', '2026-11-12 14:02:15.721735+05'),
	(394, 19, NULL, NULL, 'ticket.created', 'ticket', '347', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 14:03:19.030507+05', '2026-11-12 14:03:19.030507+05'),
	(395, 19, NULL, NULL, 'ticket.created', 'ticket', '348', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 14:10:47.221046+05', '2026-11-12 14:10:47.221046+05'),
	(396, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 14:25:37.684566+05', '2026-11-12 14:25:37.684566+05'),
	(397, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 14:41:19.944933+05', '2026-11-12 14:41:19.944933+05'),
	(398, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 14:49:19.374025+05', '2026-11-12 14:49:19.374025+05'),
	(399, 3, NULL, NULL, 'instructor.leave_changed', 'user', '3', 'Instructor changed leave status', '{"on_leave": "On Leave"}', '{"on_leave": "Not On Leave"}', 'null', 'success', NULL, NULL, '2026-11-12 14:53:16.267314+05', '2026-11-12 14:53:16.267314+05'),
	(400, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '67', 'ticket status has been changed', '{"priority": "in_progress"}', '{"priority": "resolved"}', 'null', 'success', NULL, NULL, '2026-11-12 14:56:39.670544+05', '2026-11-12 14:56:39.670544+05'),
	(401, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '19', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-12 15:04:21.491492+05', '2026-11-12 15:04:21.491492+05'),
	(402, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '19', 'ticket status has been changed', '{"priority": "in_progress"}', '{"priority": "assigned"}', 'null', 'success', NULL, NULL, '2026-11-12 15:04:36.994335+05', '2026-11-12 15:04:36.994335+05'),
	(403, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 15:14:57.037218+05', '2026-11-12 15:14:57.037218+05'),
	(404, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 15:17:17.167244+05', '2026-11-12 15:17:17.167244+05'),
	(405, 22, NULL, NULL, 'reply.created', 'reply', '35', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 15:18:36.767019+05', '2026-11-12 15:18:36.767019+05'),
	(406, 22, NULL, NULL, 'reply.created', 'reply', '35', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 15:18:36.813418+05', '2026-11-12 15:18:36.813418+05'),
	(407, 2, 'Student User Updated 2', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 15:50:33.426953+05', '2026-11-12 15:50:33.426953+05'),
	(408, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 17:05:19.859117+05', '2026-11-12 17:05:19.859117+05'),
	(409, 366, 'Finance Officer', NULL, 'auth.login', 'user', '366', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 17:42:39.937286+05', '2026-11-12 17:42:39.937286+05'),
	(410, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 17:46:27.538016+05', '2026-11-12 17:46:27.538016+05'),
	(411, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '336', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-12 18:15:39.868059+05', '2026-11-12 18:15:39.868059+05'),
	(412, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '336', 'ticket status has been changed', '{"priority": "in_progress"}', '{"priority": "resolved"}', 'null', 'success', NULL, NULL, '2026-11-12 18:16:16.100486+05', '2026-11-12 18:16:16.100486+05'),
	(413, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:18:31.109525+05', '2026-11-12 18:18:31.109525+05'),
	(414, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:28:34.075746+05', '2026-11-12 18:28:34.075746+05'),
	(415, 22, NULL, NULL, 'reply.created', 'reply', '36', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:35:02.718721+05', '2026-11-12 18:35:02.718721+05'),
	(416, 22, NULL, NULL, 'reply.created', 'reply', '36', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:35:02.771877+05', '2026-11-12 18:35:02.771877+05'),
	(417, 22, NULL, NULL, 'reply.created', 'reply', '37', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:42:04.37688+05', '2026-11-12 18:42:04.37688+05'),
	(418, 22, NULL, NULL, 'reply.created', 'reply', '37', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:42:04.424574+05', '2026-11-12 18:42:04.424574+05'),
	(419, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:48:22.891781+05', '2026-11-12 18:48:22.891781+05'),
	(420, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 18:50:00.477244+05', '2026-11-12 18:50:00.477244+05'),
	(421, 22, NULL, NULL, 'instructor.leave_changed', 'user', '22', 'Instructor changed leave status', '{"on_leave": "Not On Leave"}', '{"on_leave": "On Leave"}', 'null', 'success', NULL, NULL, '2026-11-12 18:56:12.882979+05', '2026-11-12 18:56:12.882979+05'),
	(422, 22, NULL, NULL, 'instructor.leave_changed', 'user', '22', 'Instructor changed leave status', '{"on_leave": "On Leave"}', '{"on_leave": "Not On Leave"}', 'null', 'success', NULL, NULL, '2026-11-12 18:56:42.963277+05', '2026-11-12 18:56:42.963277+05'),
	(423, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:06:40.960329+05', '2026-11-12 19:06:40.960329+05'),
	(424, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:37:28.347813+05', '2026-11-12 19:37:28.347813+05'),
	(425, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:38:22.347268+05', '2026-11-12 19:38:22.347268+05'),
	(426, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:38:56.060555+05', '2026-11-12 19:38:56.060555+05'),
	(427, 4, 'HOD User', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:40:32.574717+05', '2026-11-12 19:40:32.574717+05'),
	(428, 4, 'HOD User', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:45:12.109702+05', '2026-11-12 19:45:12.109702+05'),
	(429, 4, 'HOD User', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:50:23.068521+05', '2026-11-12 19:50:23.068521+05'),
	(430, 4, 'HOD User', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 19:53:06.224542+05', '2026-11-12 19:53:06.224542+05'),
	(431, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '28', 'HOD changed priority of the ticket', '{"priority": "high"}', '{"priority": "high"}', 'null', 'success', NULL, NULL, '2026-11-12 20:21:10.658845+05', '2026-11-12 20:21:10.658845+05'),
	(432, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 20:24:10.678123+05', '2026-11-12 20:24:10.678123+05'),
	(433, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '28', 'HOD changed priority of the ticket', '{"priority": "medium"}', '{"priority": "medium"}', 'null', 'success', NULL, NULL, '2026-11-12 20:25:04.656684+05', '2026-11-12 20:25:04.656684+05'),
	(434, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 20:26:16.874874+05', '2026-11-12 20:26:16.874874+05'),
	(435, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '28', 'HOD changed priority of the ticket', '{"priority": "string"}', '{"priority": "string"}', 'null', 'success', NULL, NULL, '2026-11-12 20:30:56.389794+05', '2026-11-12 20:30:56.389794+05'),
	(436, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 20:44:40.910306+05', '2026-11-12 20:44:40.910306+05'),
	(437, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 20:46:11.611311+05', '2026-11-12 20:46:11.611311+05'),
	(438, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-12 20:46:42.374945+05', '2026-11-12 20:46:42.374945+05'),
	(439, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 07:48:01.840713+05', '2026-11-13 07:48:01.840713+05'),
	(442, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 07:49:48.006063+05', '2026-11-13 07:49:48.006063+05'),
	(443, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 07:50:16.469796+05', '2026-11-13 07:50:16.469796+05'),
	(448, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 07:51:32.577721+05', '2026-11-13 07:51:32.577721+05'),
	(457, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 08:32:14.853906+05', '2026-11-13 08:32:14.853906+05'),
	(460, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:03:44.539845+05', '2026-11-13 09:03:44.539845+05'),
	(463, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:42:04.004558+05', '2026-11-13 09:42:04.004558+05'),
	(466, 1, NULL, NULL, 'announcement.created', 'announcement', '5', 'New announcement has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:51:17.524736+05', '2026-11-13 09:51:17.524736+05'),
	(467, 1, NULL, NULL, 'announcement.created', 'announcement', '6', 'New announcement has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:53:57.733387+05', '2026-11-13 09:53:57.733387+05'),
	(468, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:58:04.03517+05', '2026-11-13 09:58:04.03517+05'),
	(471, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:58:32.710649+05', '2026-11-13 09:58:32.710649+05'),
	(472, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 09:59:46.932257+05', '2026-11-13 09:59:46.932257+05'),
	(473, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 10:00:56.301117+05', '2026-11-13 10:00:56.301117+05'),
	(485, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 12:07:01.5313+05', '2026-11-13 12:07:01.5313+05'),
	(488, NULL, 'Virtual University', 'student', 'auth.oauth2.login', 'user', '290', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 12:23:36.382607+05', '2026-11-13 12:23:36.382607+05'),
	(489, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 13:08:05.64952+05', '2026-11-13 13:08:05.64952+05'),
	(490, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 13:37:42.937471+05', '2026-11-13 13:37:42.937471+05'),
	(491, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 14:05:55.69545+05', '2026-11-13 14:05:55.69545+05'),
	(492, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 14:24:21.611372+05', '2026-11-13 14:24:21.611372+05'),
	(493, 2, NULL, NULL, 'ticket.created', 'ticket', '349', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 14:34:14.287163+05', '2026-11-13 14:34:14.287163+05'),
	(494, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 14:37:38.568672+05', '2026-11-13 14:37:38.568672+05'),
	(495, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 15:12:14.901362+05', '2026-11-13 15:12:14.901362+05'),
	(496, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 15:27:44.007389+05', '2026-11-13 15:27:44.007389+05'),
	(497, 2, NULL, NULL, 'ticket.created', 'ticket', '350', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 15:31:25.937972+05', '2026-11-13 15:31:25.937972+05'),
	(498, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 15:42:44.696027+05', '2026-11-13 15:42:44.696027+05'),
	(499, 2, NULL, NULL, 'ticket.created', 'ticket', '351', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 15:48:39.362191+05', '2026-11-13 15:48:39.362191+05'),
	(500, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:20:55.174062+05', '2026-11-13 16:20:55.174062+05'),
	(501, NULL, NULL, NULL, 'email.processed', 'ticket', '352', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:22:57.143514+05', '2026-11-13 16:22:57.143514+05'),
	(502, NULL, NULL, NULL, 'ticket.escalated', 'ticket', '333', 'ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(503, NULL, NULL, NULL, 'ticket.escalated', 'ticket', '334', 'ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(504, NULL, NULL, NULL, 'ticket.escalated', 'ticket', '339', 'ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(505, NULL, NULL, NULL, 'ticket.escalated', 'ticket', '342', 'ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(506, NULL, NULL, NULL, 'ticket.escalated', 'ticket', '345', 'ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(507, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:44:44.358658+05', '2026-11-13 16:44:44.358658+05'),
	(508, 19, NULL, NULL, 'ticket.created', 'ticket', '353', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:45:18.855292+05', '2026-11-13 16:45:18.855292+05'),
	(509, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:46:43.535411+05', '2026-11-13 16:46:43.535411+05'),
	(510, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '353', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-13 16:57:16.256174+05', '2026-11-13 16:57:16.256174+05'),
	(511, 3, NULL, NULL, 'reply.created', 'reply', '38', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:57:54.82377+05', '2026-11-13 16:57:54.82377+05'),
	(512, 3, NULL, NULL, 'reply.created', 'reply', '38', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 16:57:54.865412+05', '2026-11-13 16:57:54.865412+05'),
	(513, NULL, NULL, NULL, 'email.processed', 'ticket', '354', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 17:22:50.317407+05', '2026-11-13 17:22:50.317407+05'),
	(514, 2, 'Student User', 'student', 'auth.login', 'user', '2', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 18:41:47.284195+05', '2026-11-13 18:41:47.284195+05'),
	(515, NULL, NULL, NULL, 'email.processed', 'ticket', '355', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 19:00:25.016004+05', '2026-11-13 19:00:25.016004+05'),
	(516, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 19:06:53.865421+05', '2026-11-13 19:06:53.865421+05'),
	(517, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 19:38:22.060801+05', '2026-11-13 19:38:22.060801+05'),
	(518, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '354', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-13 19:58:57.733331+05', '2026-11-13 19:58:57.733331+05'),
	(519, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 20:00:16.173194+05', '2026-11-13 20:00:16.173194+05'),
	(520, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 20:09:15.748853+05', '2026-11-13 20:09:15.748853+05'),
	(521, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 20:17:02.618943+05', '2026-11-13 20:17:02.618943+05'),
	(522, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 20:18:08.519736+05', '2026-11-13 20:18:08.519736+05'),
	(523, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '354', 'ticket status has been changed', '{"priority": "in_progress"}', '{"priority": "assigned"}', 'null', 'success', NULL, NULL, '2026-11-13 20:22:20.802705+05', '2026-11-13 20:22:20.802705+05'),
	(524, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '354', 'ticket status has been changed', '{"priority": "assigned"}', '{"priority": "escalated"}', 'null', 'success', NULL, NULL, '2026-11-13 20:22:33.975674+05', '2026-11-13 20:22:33.975674+05'),
	(525, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '354', 'ticket status has been changed', '{"priority": "escalated"}', '{"priority": "resolved"}', 'null', 'success', NULL, NULL, '2026-11-13 20:22:40.523063+05', '2026-11-13 20:22:40.523063+05'),
	(526, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 20:52:27.912444+05', '2026-11-13 20:52:27.912444+05'),
	(527, 3, NULL, NULL, 'reply.created', 'reply', '39', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 21:02:42.414102+05', '2026-11-13 21:02:42.414102+05'),
	(528, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 21:22:41.247372+05', '2026-11-13 21:22:41.247372+05'),
	(529, 3, NULL, NULL, 'reply.created', 'reply', '40', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 21:23:31.336858+05', '2026-11-13 21:23:31.336858+05'),
	(530, 3, NULL, NULL, 'reply.created', 'reply', '41', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 21:26:30.122553+05', '2026-11-13 21:26:30.122553+05'),
	(531, 3, NULL, NULL, 'reply.created', 'reply', '42', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-13 21:27:52.013362+05', '2026-11-13 21:27:52.013362+05'),
	(532, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 07:56:04.58024+05', '2026-11-14 07:56:04.58024+05'),
	(533, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 07:57:56.71098+05', '2026-11-14 07:57:56.71098+05'),
	(534, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 08:06:32.336247+05', '2026-11-14 08:06:32.336247+05'),
	(535, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 08:33:27.38569+05', '2026-11-14 08:33:27.38569+05'),
	(536, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 08:35:31.95003+05', '2026-11-14 08:35:31.95003+05'),
	(537, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 09:00:39.517492+05', '2026-11-14 09:00:39.517492+05'),
	(538, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 09:13:59.108717+05', '2026-11-14 09:13:59.108717+05'),
	(539, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '2', 'HOD changed priority of the ticket', '{"priority": "low"}', '{"priority": "low"}', 'null', 'success', NULL, NULL, '2026-11-14 09:14:33.407722+05', '2026-11-14 09:14:33.407722+05'),
	(540, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '2', 'HOD changed priority of the ticket', '{"priority": "medium"}', '{"priority": "medium"}', 'null', 'success', NULL, NULL, '2026-11-14 09:15:18.514232+05', '2026-11-14 09:15:18.514232+05'),
	(541, 4, NULL, NULL, 'ticket.assigned', 'ticket', '2', 'HOD take charge of the ticket', '{"assigned_id": "2"}', '{"assigned_id": "4"}', 'null', 'success', NULL, NULL, '2026-11-14 09:18:27.000885+05', '2026-11-14 09:18:27.000885+05'),
	(542, 4, NULL, NULL, 'ticket.assigned', 'ticket', '2', 'HOD take charge of the ticket', '{"assigned_id": "2"}', '{"assigned_id": "3"}', 'null', 'success', NULL, NULL, '2026-11-14 09:19:58.097021+05', '2026-11-14 09:19:58.097021+05'),
	(543, 4, NULL, NULL, 'ticket.assigned', 'ticket', '2', 'HOD take charge of the ticket', '{"assigned_id": "2"}', '{"assigned_id": "4"}', 'null', 'success', NULL, NULL, '2026-11-14 09:21:30.240293+05', '2026-11-14 09:21:30.240293+05'),
	(544, 4, NULL, NULL, 'ticket.status_changed', 'ticket', '2', 'ticket status has been changed', '{"priority": "escalated"}', '{"priority": "closed"}', 'null', 'success', NULL, NULL, '2026-11-14 09:21:35.602688+05', '2026-11-14 09:21:35.602688+05'),
	(545, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '5', 'HOD changed priority of the ticket', '{"priority": "medium"}', '{"priority": "medium"}', 'null', 'success', NULL, NULL, '2026-11-14 09:22:28.114619+05', '2026-11-14 09:22:28.114619+05'),
	(546, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 09:28:41.58902+05', '2026-11-14 09:28:41.58902+05'),
	(547, 4, NULL, NULL, 'ticket.assigned', 'ticket', '18', 'HOD take charge of the ticket', '{"assigned_id": "18"}', '{"assigned_id": "4"}', 'null', 'success', NULL, NULL, '2026-11-14 09:33:19.367286+05', '2026-11-14 09:33:19.367286+05'),
	(548, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '18', 'HOD changed priority of the ticket', '{"priority": "medium"}', '{"priority": "medium"}', 'null', 'success', NULL, NULL, '2026-11-14 09:33:26.847504+05', '2026-11-14 09:33:26.847504+05'),
	(549, 4, NULL, NULL, 'ticket.status_changed', 'ticket', '18', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "closed"}', 'null', 'success', NULL, NULL, '2026-11-14 09:33:33.815605+05', '2026-11-14 09:33:33.815605+05'),
	(550, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '28', 'HOD changed priority of the ticket', '{"priority": "low"}', '{"priority": "low"}', 'null', 'success', NULL, NULL, '2026-11-14 09:37:14.632655+05', '2026-11-14 09:37:14.632655+05'),
	(551, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 09:40:35.654539+05', '2026-11-14 09:40:35.654539+05'),
	(556, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 10:15:11.773421+05', '2026-11-14 10:15:11.773421+05'),
	(559, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 10:52:42.903364+05', '2026-11-14 10:52:42.903364+05'),
	(562, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 17:53:24.771425+05', '2026-11-14 17:53:24.771425+05'),
	(567, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 19:10:23.944118+05', '2026-11-14 19:10:23.944118+05'),
	(568, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 19:13:32.690594+05', '2026-11-14 19:13:32.690594+05'),
	(569, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 19:47:06.210656+05', '2026-11-14 19:47:06.210656+05'),
	(570, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 19:48:03.970472+05', '2026-11-14 19:48:03.970472+05'),
	(573, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 20:26:33.400915+05', '2026-11-14 20:26:33.400915+05'),
	(576, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 20:56:04.285706+05', '2026-11-14 20:56:04.285706+05'),
	(577, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 20:57:26.773726+05', '2026-11-14 20:57:26.773726+05'),
	(580, 1, NULL, NULL, 'announcement.created', 'announcement', '7', 'New announcement has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 20:59:13.803542+05', '2026-11-14 20:59:13.803542+05'),
	(581, 1, NULL, NULL, 'announcement.created', 'announcement', '8', 'New announcement has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-14 21:09:14.127324+05', '2026-11-14 21:09:14.127324+05'),
	(582, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 15:09:07.793448+05', '2026-11-15 15:09:07.793448+05'),
	(585, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 15:16:58.758626+05', '2026-11-15 15:16:58.758626+05'),
	(590, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 16:06:14.222659+05', '2026-11-15 16:06:14.222659+05'),
	(614, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 16:36:49.702297+05', '2026-11-15 16:36:49.702297+05'),
	(638, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 17:53:09.491143+05', '2026-11-15 17:53:09.491143+05'),
	(641, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 18:18:59.370616+05', '2026-11-15 18:18:59.370616+05'),
	(646, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 18:21:26.369338+05', '2026-11-15 18:21:26.369338+05'),
	(647, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-15 18:52:49.595077+05', '2026-11-15 18:52:49.595077+05'),
	(648, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 18:23:03.645923+05', '2026-11-16 18:23:03.645923+05'),
	(649, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 18:25:32.782823+05', '2026-11-16 18:25:32.782823+05'),
	(652, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 19:14:32.378549+05', '2026-11-16 19:14:32.378549+05'),
	(655, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 19:45:01.121463+05', '2026-11-16 19:45:01.121463+05'),
	(656, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 20:13:18.82809+05', '2026-11-16 20:13:18.82809+05'),
	(657, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 20:15:47.915464+05', '2026-11-16 20:15:47.915464+05'),
	(660, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 21:16:18.653708+05', '2026-11-16 21:16:18.653708+05'),
	(663, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 22:06:03.027219+05', '2026-11-16 22:06:03.027219+05'),
	(666, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 22:08:05.559438+05', '2026-11-16 22:08:05.559438+05'),
	(670, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 22:30:38.324362+05', '2026-11-16 22:30:38.324362+05'),
	(671, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-16 23:01:09.213683+05', '2026-11-16 23:01:09.213683+05'),
	(672, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 06:24:52.208792+05', '2026-11-17 06:24:52.208792+05'),
	(673, 1, NULL, NULL, 'admin.created', 'user', '292', 'new admin has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 06:35:05.084316+05', '2026-11-17 06:35:05.084316+05'),
	(674, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 06:54:30.060405+05', '2026-11-17 06:54:30.060405+05'),
	(675, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 07:26:04.253028+05', '2026-11-17 07:26:04.253028+05'),
	(676, 1, NULL, NULL, 'admin.created', 'user', '293', 'new admin has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 07:27:28.323644+05', '2026-11-17 07:27:28.323644+05'),
	(677, 1, NULL, NULL, 'admin.created', 'user', '294', 'new admin has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 07:34:48.975666+05', '2026-11-17 07:34:48.975666+05'),
	(678, 1, NULL, NULL, 'admin.created', 'user', '295', 'new admin has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 07:35:48.444034+05', '2026-11-17 07:35:48.444034+05'),
	(679, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 07:47:59.371839+05', '2026-11-17 07:47:59.371839+05'),
	(680, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 07:56:50.634185+05', '2026-11-17 07:56:50.634185+05'),
	(681, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 08:35:02.013919+05', '2026-11-17 08:35:02.013919+05'),
	(682, 1, NULL, NULL, 'ticket.status_changed', 'ticket', '333', 'ticket status has been changed', '{"priority": "escalated"}', '{"priority": "resolved"}', 'null', 'success', NULL, NULL, '2026-11-17 08:37:35.319997+05', '2026-11-17 08:37:35.319997+05'),
	(683, 19, 'bc230203410 TABISH SARDAR ALI SAJWANI', 'student', 'auth.oauth2.login', 'user', '19', 'user logged in using google login', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 08:52:28.905689+05', '2026-11-17 08:52:28.905689+05'),
	(684, 19, NULL, NULL, 'ticket.created', 'ticket', '356', 'new ticket has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 08:54:31.636843+05', '2026-11-17 08:54:31.636843+05'),
	(685, 3, 'Officer User', 'officer', 'auth.login', 'user', '3', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 08:55:26.608362+05', '2026-11-17 08:55:26.608362+05'),
	(686, 3, NULL, NULL, 'ticket.status_changed', 'ticket', '356', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-17 08:56:45.556109+05', '2026-11-17 08:56:45.556109+05'),
	(687, 3, NULL, NULL, 'reply.created', 'reply', '43', 'New Reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 08:58:59.017719+05', '2026-11-17 08:58:59.017719+05'),
	(688, 3, NULL, NULL, 'reply.created', 'reply', '43', 'New reply has been created', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 08:58:59.086389+05', '2026-11-17 08:58:59.086389+05'),
	(689, 4, 'HOD User Updated', 'hod', 'auth.login', 'user', '4', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:00:19.72363+05', '2026-11-17 09:00:19.72363+05'),
	(690, 4, NULL, NULL, 'ticket.priority_changed', 'ticket', '356', 'HOD changed priority of the ticket', '{"priority": "high"}', '{"priority": "high"}', 'null', 'success', NULL, NULL, '2026-11-17 09:02:02.877883+05', '2026-11-17 09:02:02.877883+05'),
	(691, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:26:36.765694+05', '2026-11-17 09:26:36.765694+05'),
	(692, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:26:36.766187+05', '2026-11-17 09:26:36.766187+05'),
	(693, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:28:00.231146+05', '2026-11-17 09:28:00.231146+05'),
	(694, NULL, NULL, NULL, 'email.processed', 'ticket', '357', 'ticket created from email', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:39:35.203709+05', '2026-11-17 09:39:35.203709+05'),
	(695, 22, 'Tabish Officer', 'officer', 'auth.login', 'user', '22', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:43:24.087912+05', '2026-11-17 09:43:24.087912+05'),
	(696, 22, NULL, NULL, 'ticket.status_changed', 'ticket', '357', 'ticket status has been changed', '{"priority": "pending"}', '{"priority": "in_progress"}', 'null', 'success', NULL, NULL, '2026-11-17 09:44:25.024164+05', '2026-11-17 09:44:25.024164+05'),
	(698, 1, 'Admin User', 'admin', 'auth.login', 'user', '1', 'user logged in using web form', 'null', 'null', 'null', 'success', NULL, NULL, '2026-11-17 09:58:06.076917+05', '2026-11-17 09:58:06.076917+05');

-- Dumping structure for table public.categories
CREATE TABLE IF NOT EXISTS "categories" (
	"id" SERIAL NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"description" TEXT NULL DEFAULT NULL,
	"department_id" INTEGER NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	CONSTRAINT "categories_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.categories: 11 rows
DELETE FROM "categories";
INSERT INTO "categories" ("id", "name", "description", "department_id", "created_at", "updated_at") VALUES
	(1, 'general', 'general help desk related queries', NULL, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(2, 'academic', 'academic related queries', 1, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(3, 'finance', 'billing, accounts and finance related queries', 2, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(4, 'admissions', 'admissions related queries', 3, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(5, 'administration', 'administration and student affairs related queries', 4, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(6, 'housing', 'hostel and student housing related queries', 5, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(7, 'library', 'library related queries', 6, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(8, 'technical', 'bug report and information technology (IT) related queries', 7, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(9, 'maintenance', 'facility maintenance related queries', 8, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(10, 'security/discipline', 'student security and discipline queries', 9, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05'),
	(11, 'transport', 'student transport related queries', 10, '2026-08-29 16:25:16.05667+05', '2026-08-29 16:25:16.05667+05');

-- Dumping structure for table public.departments
CREATE TABLE IF NOT EXISTS "departments" (
	"id" SERIAL NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"description" TEXT NULL DEFAULT NULL,
	"is_active" BOOLEAN NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"hod_id" INTEGER NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "departments_hod_id_fkey" FOREIGN KEY ("hod_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.departments: 10 rows
DELETE FROM "departments";
INSERT INTO "departments" ("id", "name", "description", "is_active", "created_at", "updated_at", "hod_id") VALUES
	(1, 'academic affairs office', 'Queries regarding academic and examination', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(2, 'billing accounts & finance office', 'Queries regarding billing, accounts, and finance', 'true', '2026-08-29 16:25:16.050934+05', '2026-11-17 08:22:49.221667+05', 4),
	(3, 'admissions office', 'Queries regarding student admissions', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(4, 'student affairs & administration office', 'Queries regarding student affairs and administration', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(5, 'hostel & housing office', 'Queries regarding hostel and student housing', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(6, 'library office', 'Queries regarding library', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', 1),
	(7, 'information technology (IT) office', 'Queries regarding information technology and information communication', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(8, 'facilities & maintenance office', 'Queries regarding maintenance of student facilities', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(9, 'security & discipline office', 'Queries regarding student security and discipline', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL),
	(10, 'transportation office', 'Queries regarding transportation service provided by university', 'true', '2026-08-29 16:25:16.050934+05', '2026-08-29 16:25:16.050934+05', NULL);

-- Dumping structure for table public.incoming_emails
CREATE TABLE IF NOT EXISTS "incoming_emails" (
	"id" SERIAL NOT NULL,
	"message_id" VARCHAR(255) NOT NULL,
	"email_from" VARCHAR(255) NOT NULL,
	"creator_id" INTEGER NULL DEFAULT NULL,
	"subject" VARCHAR(255) NULL DEFAULT NULL,
	"body" TEXT NULL DEFAULT NULL,
	"is_processed" SMALLINT NOT NULL,
	"ticket_id" INTEGER NULL DEFAULT NULL,
	"received_on" TIMESTAMP NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	UNIQUE ("message_id"),
	CONSTRAINT "incoming_emails_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "incoming_emails_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "tickets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.incoming_emails: 202 rows
DELETE FROM "incoming_emails";
INSERT INTO "incoming_emails" ("id", "message_id", "email_from", "creator_id", "subject", "body", "is_processed", "ticket_id", "received_on", "created_at", "updated_at") VALUES
	(3, '1a065cf5b5497bf6', 'bc230203410tsa@vu.edu.pk', 19, 'Tuition payment error', 'Tuition payment error, urgent fix needed.
', 1, 36, '2026-09-03 05:47:50', '2026-09-03 11:31:02.115597+05', '2026-09-03 11:31:02.115597+05'),
	(4, '1a066033075e4695', 'bc230203410tsa@vu.edu.pk', 19, 'Dorm ID Card issue', 'My dorm ID card is not unlocking the laundry room door.
', 1, 37, '2026-09-03 06:44:28', '2026-09-03 11:44:59.430006+05', '2026-09-03 11:44:59.430006+05'),
	(5, '1a066029e5f4ebd5', 'bc230203410tsa@vu.edu.pk', 19, 'Need of Staplers', 'URGENT PLS!!!! I NEED TO KNOW IF THE LIBRARY HAS ANY STAPLERS RIGHT NOW I
HAVE A PAPER DUE ON FRIDAY!!!!!
', 1, 38, '2026-09-03 06:43:51', '2026-09-03 11:45:00.338243+05', '2026-09-03 11:45:00.338243+05'),
	(6, '1a066448ba27706f', 'bc230203410tsa@vu.edu.pk', 19, 'Contact information of the architecture', 'hi, do u have any information on the architect who designed the finance
office lobby? thx.
', 1, 39, '2026-09-03 07:55:49', '2026-09-03 13:00:04.589547+05', '2026-09-03 13:00:04.589547+05'),
	(7, '1a06643c7515afb5', 'bc230203410tsa@vu.edu.pk', 19, 'Contact information of Biology Department', 'i''m tryin to find the contact info for the biology department head. do u
have their email address?
', 1, 40, '2026-09-03 07:55:01', '2026-09-03 13:00:05.476616+05', '2026-09-03 13:00:05.476616+05'),
	(8, '1a0892ece063922e', 'bc230203410tsa@vu.edu.pk', 19, 'Inquiry about finance lobby', 'Is there a limit to the number of visitors a student can bring to the
finance office lobby at once?
', 1, 50, '2026-09-10 02:38:50', '2026-09-10 07:40:09.022385+05', '2026-09-10 07:40:09.022385+05'),
	(9, '1a08940bf26cc299', 'bc230203410tsa@vu.edu.pk', 19, 'filing taxes', 'I would like to know if the university provides any assistance for filing
taxes for international students on a J-1 visa.
', 1, 51, '2026-09-10 02:58:26', '2026-09-10 08:01:09.119433+05', '2026-09-10 08:01:09.119433+05'),
	(10, '1a08984be7cc2176', 'bc230203410tsa@vu.edu.pk', 19, 'Question Regarding Single Responsibility Principle', 'Asalam o Alaikum Sir,

I have a question regarding Single Responsibility Principle:

If a class is handling user registration, logging, updating, deleting, etc.
then does it break *Single Responsibility Principle (SRP)*?

If it breaks SRP, then isn''t having many classes for handling these user
methods isn''t create too much files?

Thanks
', 1, 52, '2026-09-10 04:12:40', '2026-09-10 09:13:09.901715+05', '2026-09-10 09:13:09.901715+05'),
	(11, '1a08985778e1b0a7', 'bc230203410tsa@vu.edu.pk', 19, 'Credit Hours Limit Increase', 'Assalam o Alaikum,

Sir, can you please increase my credit hours limit because after selecting
all current semester courses there are two credit hours remaining and I
can''t utilize these two remaining credit hours in selecting a new course
from next semester.

Additionally, at the end of five semesters I have earned 87 credit hours
but there should be 90 credit hours (18 * 5 = 90),

So it''s my request to increase my credit hours limit by 1 or 3, so I can
pick additional courses
', 1, 53, '2026-09-10 04:13:29', '2026-09-10 09:16:09.05415+05', '2026-09-10 09:16:09.05415+05'),
	(12, '1a08994e64eb8902', 'bc230203410tsa@vu.edu.pk', 19, 'Special permission code', 'hi, i''m trying to register for a course but it says I need a ''Special
Permission'' code even though it''s an open elective.
', 1, 54, '2026-09-10 04:30:20', '2026-09-10 09:31:09.154775+05', '2026-09-10 09:31:09.154775+05'),
	(15, '1a0b5e9d6900eb13', 'mailer-daemon@googlemail.com', NULL, 'Delivery Status Notification (Failure)', '', 1, NULL, '2026-09-18 19:06:35', '2026-09-19 00:09:04.879182+05', '2026-09-19 00:09:04.879182+05'),
	(16, '1a0b5ec6b7f4315f', 'mailer-daemon@googlemail.com', NULL, 'Delivery Status Notification (Failure)', '', 1, NULL, '2026-09-18 19:09:24', '2026-09-19 00:12:04.745388+05', '2026-09-19 00:12:04.745388+05'),
	(17, '1a0b8aface25afd4', 'bc230203410tsa@vu.edu.pk', 19, 'Issue with finance', 'I received an eviction notice for non-payment, but my scholarship was
supposed to cover it. I need the housing hold removed now.
', 1, 67, '2026-09-19 08:01:44', '2026-09-19 13:04:33.793711+05', '2026-09-19 13:04:33.793711+05'),
	(18, '1a0ba584963b87b3', 'no-reply@accounts.google.com', NULL, 'Security alert', '[image: Google]
Authenticator app added as sign-in step


virtualuniversity08@gmail.com
If you didn''t add the Authenticator app, someone might be using your
account. Check and secure your account now.
Check activity
<https://accounts.google.com/AccountChooser?Email=virtualuniversity08@gmail.com&continue=https://myaccount.google.com/alert/nt/1789832742598?rfn%3D252%26rfnc%3D1%26eid%3D1424002024499870683%26et%3D0>
You can also see security activity at
https://myaccount.google.com/notifications
You received this email to let you know about important changes to your
Google Account and services.
© 2026 Google LLC, 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA
', 1, 68, '2026-09-19 15:45:42', '2026-09-19 20:48:37.373557+05', '2026-09-19 20:48:37.373557+05'),
	(19, '1a0ba5b1b98fac1a', 'no-reply@accounts.google.com', NULL, '2-Step Verification turned on', '[image: Google]
2-Step Verification turned on


virtualuniversity08@gmail.com

Your Google Account virtualuniversity08@gmail.com is now protected with
2-Step Verification. When you sign in on a new or untrusted device, you’ll
need your second factor to verify your identity.

*Don''t get locked out!*
You can add a backup phone or get backup codes to use when you don’t have
your second factor with you.
You can review your 2SV settings
<https://accounts.google.com/AccountChooser?Email=virtualuniversity08@gmail.com&continue=https://myaccount.google.com/signinoptions/twosv?rfn%3D16%26rfnc%3D1%26eid%3D2211986483115191366%26et%3D0>
to make changes.
You can also see security activity at
https://myaccount.google.com/notifications
You received this email to let you know about important changes to your
Google Account and services.
© 2026 Google LLC, 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA
', 1, 69, '2026-09-19 15:48:47', '2026-09-19 20:51:37.421296+05', '2026-09-19 20:51:37.421296+05'),
	(85, '1a1323622facfdbe', 'CloudPlatform-noreply@google.com', NULL, '[Action Required] Mark AI agent OAuth clients as agentic for Google Workspace MCP by Nov 11, 2026', 'A new agentic setting for OAuth clients ahead of Workspace MCP servers.




MY CONSOLE




Hello Virtual,

You are receiving this communication because your Google Cloud project  
contains OAuth 2.0 credentials or applications that connect to Google  
Workspace via OAuth.

We will soon roll out the Google Workspace Model Context Protocol (MCP)  
servers, which expose new functionality to external AI Agents across Gmail,  
Drive, Calendar, and other Workspace apps using the open Model Context  
Protocol (MCP). Ahead of this launch, we are introducing an “agentic”  
setting ( is_agentic ) on Google OAuth clients, so that Google and  
Workspace administrators can differentiate AI agent traffic from  
traditional app traffic. Only OAuth clients marked as agentic will be able  
to call Workspace MCP servers. We are announcing this change early, so  
developers and project owners have time to prepare.

If your app is not an AI agent and only uses Google Workspace REST APIs  
(for example, the Gmail API or Drive API), you do not need to take any  
action for this change.

We have provided additional information below to outline the technical  
impact of this change and the actions required to keep access to Workspace  
MCP servers.

What you need to know

Key changes and timelines:


October 12, 2026 (New “agentic” OAuth client classification): Developers  
can directly mark their OAuth clients as "agentic" ( is_agentic ) in the  
Google Cloud console.
November 11, 2026 (Only agentic clients can call Workspace MCP servers):  
Google will reject requests to Workspace MCP servers from OAuth clients  
that are not marked as agentic.
November 12, 2026 (The agentic setting becomes permanent): Starting on this  
date, you can no longer change the agentic setting on an existing OAuth  
client. To change it, create a new OAuth Client ID.

Potential impact:


Refused access: Starting November 11, 2026, Workspace MCP servers will  
reject requests from any app or integration whose OAuth client is not  
marked as agentic. The error message will state “the client isn''t marked as  
an AI agent” and will link to steps to fix it.
New OAuth Client ID requirement: OAuth clients that are not marked as  
agentic by November 12, 2026 will remain non-agentic and cannot call  
Workspace MCP servers. To use MCP after this date, you will need to create  
a new OAuth client marked as agentic and update your app to use it.
Unaffected applications: Apps that are not AI agents and only call Google  
Workspace REST APIs are not affected by this change.

What you need to do

Action required:


Identify your AI agent clients: Identify the OAuth clients in your Google  
Cloud projects that belong to AI agents, including agents that currently  
use Workspace REST APIs only.

Only mark OAuth clients that are used by AI agents. Agentic clients have  
separate security controls applied, such as agent access controls.
If an app handles both AI agent and non-agent traffic, use a separate OAuth  
client for the AI agent.

Mark them as agentic between October 12 and November 11, 2026: Turn on the  
agentic setting for these OAuth clients in the Google Cloud console, so  
they can call Workspace MCP servers.
Plan for the setting becoming permanent starting November 12, 2026:

To change the setting on an existing OAuth client after this date, you will  
need to create a new OAuth Client ID.
When you create a new OAuth client, you must choose whether it is agentic.


Your affected projects are listed below:


fastemailautomation

We are here to help

If you have any questions or require assistance classifying your OAuth  
clients:


Review the Managing OAuth Clients Help Center article
Contact your Google Account Manager or Technical Account Manager
Contact Google Cloud Support with your Google Cloud Project ID and OAuth  
2.0 Client ID

Thanks for choosing Google Cloud.





– The Google Cloud Team





DOCUMENTATION



SUPPORT




Was this information helpful?

Yes Neutral No


© 2026 Google LLC 1600 Amphitheatre Parkway, Mountain View, CA 94043

You''ve received this mandatory service announcement to update you about  
important changes to Google Cloud or your account.



Visit GCP on GitHub Visit Google Cloud on LinkedIn Visit Google Cloud on  
Twitter




', 1, 138, '2026-10-12 22:22:50', '2026-10-25 12:40:22.289245+05', '2026-10-25 12:40:22.289245+05'),
	(86, '1a1820a2b91c3397', 'account-security-noreply@accountprotection.microsoft.com', NULL, 'Verify your email address', 'Microsoft account

Verify your email address

To finish setting up your Microsoft account, we just need to make sure this email address is yours.

To verify your email address use this security code: 700952

If you didn''t request this code, you can safely ignore this email. Someone else might have typed your email address by mistake.

Thanks,
The Microsoft account team 
Privacy Statement: https://go.microsoft.com/fwlink/?LinkId=521839
Microsoft Corporation, One Microsoft Way, Redmond, WA 98052
', 1, 139, '2026-10-28 10:24:24', '2026-11-03 15:22:16.902332+05', '2026-11-03 15:22:16.902332+05'),
	(88, '1a1a0eed17ba422d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-142217-WOMB is being created', '', 1, NULL, '2026-11-03 10:22:46', '2026-11-03 15:23:39.474443+05', '2026-11-03 15:23:39.474443+05'),
	(89, '1a1a0f0a333131bf', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-142339-TMFL is being created', '', 1, NULL, '2026-11-03 10:24:46', '2026-11-03 15:28:02.688923+05', '2026-11-03 15:28:02.688923+05'),
	(91, '1a1a0f4af2832732', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-142802-K84P is being created', '', 1, NULL, '2026-11-03 10:29:09', '2026-11-03 15:31:02.917103+05', '2026-11-03 15:31:02.917103+05'),
	(93, '1a1a0f76d3bcb297', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-143102-5GK0 is being created', '', 1, NULL, '2026-11-03 10:32:10', '2026-11-03 15:38:20.821948+05', '2026-11-03 15:38:20.821948+05'),
	(95, '1a1a0feac8a19d47', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-143820-GDH5 is being created', '', 1, NULL, '2026-11-03 10:40:05', '2026-11-03 15:52:16.625167+05', '2026-11-03 15:52:16.625167+05'),
	(97, '1a1a10ada501c3e5', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-145216-HL7R is being created', '', 1, NULL, '2026-11-03 10:53:23', '2026-11-03 15:59:55.055045+05', '2026-11-03 15:59:55.055045+05'),
	(99, '1a1a11271f5810ea', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-145955-Q91C is being created', '', 1, NULL, '2026-11-03 11:01:40', '2026-11-03 16:05:33.690219+05', '2026-11-03 16:05:33.690219+05'),
	(101, '1a1a11bb66991255', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-150533-DN32 is being created', '', 1, NULL, '2026-11-03 11:11:42', '2026-11-03 16:20:02.628191+05', '2026-11-03 16:20:02.628191+05'),
	(103, '1a1a1244147e7e7e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-152002-YQB8 is being created', '', 1, NULL, '2026-11-03 11:21:08', '2026-11-03 16:23:02.563494+05', '2026-11-03 16:23:02.563494+05'),
	(105, '1a1a127ff8b77110', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-152302-5JW9 is being created', '', 1, NULL, '2026-11-03 11:25:13', '2026-11-03 16:33:53.185426+05', '2026-11-03 16:33:53.185426+05'),
	(107, '1a1a130f70384305', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-153353-9YZ6 is being created', '', 1, NULL, '2026-11-03 11:35:01', '2026-11-03 16:36:53.041271+05', '2026-11-03 16:36:53.041271+05'),
	(109, '1a1a133b492a6c7b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-153653-H8R9 is being created', '', 1, NULL, '2026-11-03 11:38:00', '2026-11-03 16:42:02.059272+05', '2026-11-03 16:42:02.059272+05'),
	(111, '1a1a13879038abc6', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-154202-NSHU is being created', '', 1, NULL, '2026-11-03 11:43:14', '2026-11-03 16:52:20.084025+05', '2026-11-03 16:52:20.084025+05'),
	(113, '1a1a14335b11bcae', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-155220-4KAV is being created', '', 1, NULL, '2026-11-03 11:54:57', '2026-11-03 16:56:51.004064+05', '2026-11-03 16:56:51.004064+05'),
	(115, '1a1a145f283740b0', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-155651-16UW is being created', '', 1, NULL, '2026-11-03 11:57:57', '2026-11-03 16:59:50.949731+05', '2026-11-03 16:59:50.949731+05'),
	(117, '1a1a148cb648d6f3', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-155950-R14P is being created', '', 1, NULL, '2026-11-03 12:00:59', '2026-11-03 17:02:50.843946+05', '2026-11-03 17:02:50.843946+05'),
	(119, '1a1a14b7e2720469', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-160250-AXFW is being created', '', 1, NULL, '2026-11-03 12:04:00', '2026-11-03 17:05:50.92944+05', '2026-11-03 17:05:50.92944+05'),
	(121, '1a1a14e3f2ba7922', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-160550-W5VT is being created', '', 1, NULL, '2026-11-03 12:07:00', '2026-11-03 17:08:50.802322+05', '2026-11-03 17:08:50.802322+05'),
	(123, '1a1a15018fb07dcb', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-160850-I7SL is being created', '', 1, NULL, '2026-11-03 12:09:01', '2026-11-03 17:11:51.268473+05', '2026-11-03 17:11:51.268473+05'),
	(125, '1a1a153c0c00aed8', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-161151-VANQ is being created', '', 1, NULL, '2026-11-03 12:13:01', '2026-11-03 17:14:51.326756+05', '2026-11-03 17:14:51.326756+05'),
	(127, '1a1a15678d2c2578', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-161451-QTTJ is being created', '', 1, NULL, '2026-11-03 12:15:59', '2026-11-03 17:17:51.431813+05', '2026-11-03 17:17:51.431813+05'),
	(129, '1a1a15936b94813d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-161751-F0MR is being created', '', 1, NULL, '2026-11-03 12:18:59', '2026-11-03 17:20:50.846143+05', '2026-11-03 17:20:50.846143+05'),
	(131, '1a1a15bf8566a5a8', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-162050-L1C1 is being created', '', 1, NULL, '2026-11-03 12:21:59', '2026-11-03 17:23:50.801629+05', '2026-11-03 17:23:50.801629+05'),
	(133, '1a1a15eb33fcc93d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-162350-3Y1V is being created', '', 1, NULL, '2026-11-03 12:24:58', '2026-11-03 17:26:50.974558+05', '2026-11-03 17:26:50.974558+05'),
	(135, '1a1a16172770de15', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-162650-HADF is being created', '', 1, NULL, '2026-11-03 12:27:58', '2026-11-03 17:29:50.821273+05', '2026-11-03 17:29:50.821273+05'),
	(137, '1a1a16433ea5915f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-162950-L6FN is being created', '', 1, NULL, '2026-11-03 12:30:58', '2026-11-03 17:32:51.111009+05', '2026-11-03 17:32:51.111009+05'),
	(139, '1a1a166f449d240e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-163251-9WLW is being created', '', 1, NULL, '2026-11-03 12:33:59', '2026-11-03 17:35:50.802417+05', '2026-11-03 17:35:50.802417+05'),
	(141, '1a1a169b519ac59f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-163550-PO6J is being created', '', 1, NULL, '2026-11-03 12:37:00', '2026-11-03 17:38:50.924213+05', '2026-11-03 17:38:50.924213+05'),
	(143, '1a1a16c7c2693a2f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-163850-O2CW is being created', '', 1, NULL, '2026-11-03 12:40:01', '2026-11-03 17:41:50.924266+05', '2026-11-03 17:41:50.924266+05'),
	(145, '1a1a16f41a9325e8', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-164150-LU10 is being created', '', 1, NULL, '2026-11-03 12:42:57', '2026-11-03 17:44:50.793726+05', '2026-11-03 17:44:50.793726+05'),
	(147, '1a1a171eccf2be7f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-164450-CFSS is being created', '', 1, NULL, '2026-11-03 12:45:59', '2026-11-03 17:47:50.793455+05', '2026-11-03 17:47:50.793455+05'),
	(149, '1a1a174b69de1353', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-164750-59A8 is being created', '', 1, NULL, '2026-11-03 12:49:01', '2026-11-03 17:50:50.948418+05', '2026-11-03 17:50:50.948418+05'),
	(151, '1a1a1776f5bf38b6', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-165050-MV5A is being created', '', 1, NULL, '2026-11-03 12:51:59', '2026-11-03 17:53:50.969009+05', '2026-11-03 17:53:50.969009+05'),
	(153, '1a1a17a298dc1228', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-165350-9DK0 is being created', '', 1, NULL, '2026-11-03 12:54:58', '2026-11-03 17:56:50.90706+05', '2026-11-03 17:56:50.90706+05'),
	(155, '1a1a17d78e962e49', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-165650-V37C is being created', '', 1, NULL, '2026-11-03 12:58:35', '2026-11-03 17:59:50.880132+05', '2026-11-03 17:59:50.880132+05'),
	(157, '1a1a17fb3cf27994', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-165950-NOCE is being created', '', 1, NULL, '2026-11-03 13:01:01', '2026-11-03 18:02:50.941786+05', '2026-11-03 18:02:50.941786+05'),
	(160, '1a1a1827e48f249e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-170250-A06W is being created', '', 1, NULL, '2026-11-03 13:04:02', '2026-11-03 18:08:51.055449+05', '2026-11-03 18:08:51.055449+05'),
	(162, '1a1a187e1618fcc2', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-170851-YSQ3 is being created', '', 1, NULL, '2026-11-03 13:09:56', '2026-11-03 18:11:50.925757+05', '2026-11-03 18:11:50.925757+05'),
	(164, '1a1a18aa2f3335b2', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-171150-V79A is being created', '', 1, NULL, '2026-11-03 13:12:58', '2026-11-03 18:14:51.641002+05', '2026-11-03 18:14:51.641002+05'),
	(166, '1a1a18d5c1dfa1ac', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-171451-3HIU is being created', '', 1, NULL, '2026-11-03 13:15:56', '2026-11-03 18:17:51.023242+05', '2026-11-03 18:17:51.023242+05'),
	(168, '1a1a1901ea90bbae', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-171751-M0ER is being created', '', 1, NULL, '2026-11-03 13:18:58', '2026-11-03 18:20:50.993411+05', '2026-11-03 18:20:50.993411+05'),
	(170, '1a1a192dc4081265', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-172050-3823 is being created', '', 1, NULL, '2026-11-03 13:21:56', '2026-11-03 18:23:51.033417+05', '2026-11-03 18:23:51.033417+05'),
	(172, '1a1a195a2babfb2d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-172351-3TJY is being created', '', 1, NULL, '2026-11-03 13:24:58', '2026-11-03 18:26:51.31707+05', '2026-11-03 18:26:51.31707+05'),
	(174, '1a1a19879c669778', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-172651-EE0Z is being created', '', 1, NULL, '2026-11-03 13:27:59', '2026-11-03 18:29:50.929492+05', '2026-11-03 18:29:50.929492+05'),
	(176, '1a1a19b2b2977846', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-172950-YSIC is being created', '', 1, NULL, '2026-11-03 13:31:01', '2026-11-03 18:32:50.983508+05', '2026-11-03 18:32:50.983508+05'),
	(178, '1a1a19ddd325279f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-173250-RJJK is being created', '', 1, NULL, '2026-11-03 13:33:58', '2026-11-03 18:35:51.278457+05', '2026-11-03 18:35:51.278457+05'),
	(180, '1a1a1a094f456260', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-173551-6MIL is being created', '', 1, NULL, '2026-11-03 13:36:56', '2026-11-03 18:38:51.144592+05', '2026-11-03 18:38:51.144592+05'),
	(182, '1a1a1a357e839181', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-173851-AFJB is being created', '', 1, NULL, '2026-11-03 13:39:57', '2026-11-03 18:41:50.914021+05', '2026-11-03 18:41:50.914021+05'),
	(184, '1a1a1a61e6620054', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-174150-GXBL is being created', '', 1, NULL, '2026-11-03 13:42:58', '2026-11-03 18:44:50.925816+05', '2026-11-03 18:44:50.925816+05'),
	(186, '1a1a1a9723c58ce9', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-174450-4YJG is being created', '', 1, NULL, '2026-11-03 13:46:37', '2026-11-03 18:47:50.869345+05', '2026-11-03 18:47:50.869345+05'),
	(188, '1a1a1aba60f02bc7', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-174750-EONV is being created', '', 1, NULL, '2026-11-03 13:49:01', '2026-11-03 18:50:51.034844+05', '2026-11-03 18:50:51.034844+05'),
	(190, '1a1a1ae60f4de47d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-175051-G4ZZ is being created', '', 1, NULL, '2026-11-03 13:52:00', '2026-11-03 18:53:51.105739+05', '2026-11-03 18:53:51.105739+05'),
	(192, '1a1a1b128b0a5a1b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-175351-HNOY is being created', '', 1, NULL, '2026-11-03 13:55:02', '2026-11-03 18:56:51.347236+05', '2026-11-03 18:56:51.347236+05'),
	(194, '1a1a1b3e6ba9cbde', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-175651-OU5X is being created', '', 1, NULL, '2026-11-03 13:58:02', '2026-11-03 18:59:50.856081+05', '2026-11-03 18:59:50.856081+05'),
	(196, '1a1a1b6ae812d388', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-175950-L7RC is being created', '', 1, NULL, '2026-11-03 14:01:02', '2026-11-03 19:02:51.088647+05', '2026-11-03 19:02:51.088647+05'),
	(198, '1a1a1b95a2925d70', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-180251-IJ9U is being created', '', 1, NULL, '2026-11-03 14:03:59', '2026-11-03 19:05:50.962606+05', '2026-11-03 19:05:50.962606+05'),
	(200, '1a1a1bc1a65c720e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-180550-MKBP is being created', '', 1, NULL, '2026-11-03 14:06:59', '2026-11-03 19:08:50.791356+05', '2026-11-03 19:08:50.791356+05'),
	(202, '1a1a1bedb609eccf', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-180850-CO10 is being created', '', 1, NULL, '2026-11-03 14:10:00', '2026-11-03 19:11:51.581516+05', '2026-11-03 19:11:51.581516+05'),
	(204, '1a1a1c19288640ed', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-181151-NYY1 is being created', '', 1, NULL, '2026-11-03 14:12:58', '2026-11-03 19:14:51.55404+05', '2026-11-03 19:14:51.55404+05'),
	(206, '1a1a1c451d11c223', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-181451-0KBS is being created', '', 1, NULL, '2026-11-03 14:15:58', '2026-11-03 19:17:51.169628+05', '2026-11-03 19:17:51.169628+05'),
	(208, '1a1a1c73f583c236', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-181751-445C is being created', '', 1, NULL, '2026-11-03 14:19:09', '2026-11-03 19:20:51.186391+05', '2026-11-03 19:20:51.186391+05'),
	(210, '1a1a1c9e5b0e51d6', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-182051-RYWV is being created', '', 1, NULL, '2026-11-03 14:22:00', '2026-11-03 19:23:50.964098+05', '2026-11-03 19:23:50.964098+05'),
	(212, '1a1a1cc9fb73fab9', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-182350-407P is being created', '', 1, NULL, '2026-11-03 14:25:01', '2026-11-03 19:26:50.881532+05', '2026-11-03 19:26:50.881532+05'),
	(214, '1a1a1cf667b635f6', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-182650-9C10 is being created', '', 1, NULL, '2026-11-03 14:28:03', '2026-11-03 19:29:50.924971+05', '2026-11-03 19:29:50.924971+05'),
	(216, '1a1a1d21277a59b5', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-182950-ZQP3 is being created', '', 1, NULL, '2026-11-03 14:30:59', '2026-11-03 19:32:50.96379+05', '2026-11-03 19:32:50.96379+05'),
	(218, '1a1a1d4d9ccf91d9', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-183250-PPKG is being created', '', 1, NULL, '2026-11-03 14:34:00', '2026-11-03 19:35:51.314911+05', '2026-11-03 19:35:51.314911+05'),
	(220, '1a1a1d796f9e6f64', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-183551-5K01 is being created', '', 1, NULL, '2026-11-03 14:37:01', '2026-11-03 19:38:50.95671+05', '2026-11-03 19:38:50.95671+05'),
	(222, '1a1a1da6844c8bec', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-183850-PIBL is being created', '', 1, NULL, '2026-11-03 14:40:05', '2026-11-03 19:41:50.876254+05', '2026-11-03 19:41:50.876254+05'),
	(224, '1a1a1dd0ff9c5afd', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-184150-SPWG is being created', '', 1, NULL, '2026-11-03 14:42:59', '2026-11-03 19:44:50.842906+05', '2026-11-03 19:44:50.842906+05'),
	(226, '1a1a1dfdd3e8c7c7', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-184450-MHN6 is being created', '', 1, NULL, '2026-11-03 14:46:03', '2026-11-03 19:47:51.154225+05', '2026-11-03 19:47:51.154225+05'),
	(228, '1a1a1e29d0d37efc', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-184751-M267 is being created', '', 1, NULL, '2026-11-03 14:49:02', '2026-11-03 19:50:50.920594+05', '2026-11-03 19:50:50.920594+05'),
	(230, '1a1a1e641fc935aa', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-185050-H4BP is being created', '', 1, NULL, '2026-11-03 14:52:01', '2026-11-03 19:53:50.804076+05', '2026-11-03 19:53:50.804076+05'),
	(232, '1a1a1e811b67eb82', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-185350-TGQ2 is being created', '', 1, NULL, '2026-11-03 14:55:01', '2026-11-03 19:56:51.033905+05', '2026-11-03 19:56:51.033905+05'),
	(234, '1a1a1eadf0eb5956', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-185651-9B80 is being created', '', 1, NULL, '2026-11-03 14:58:04', '2026-11-03 19:59:50.885298+05', '2026-11-03 19:59:50.885298+05'),
	(236, '1a1a1ed93ac7464d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-185950-8JJ2 is being created', '', 1, NULL, '2026-11-03 15:01:02', '2026-11-03 20:02:51.404815+05', '2026-11-03 20:02:51.404815+05'),
	(238, '1a1a1f06c75f0556', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-190251-77CI is being created', '', 1, NULL, '2026-11-03 15:04:06', '2026-11-03 20:05:50.974109+05', '2026-11-03 20:05:50.974109+05'),
	(240, '1a1a1f31c944b2bf', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-190550-N3BC is being created', '', 1, NULL, '2026-11-03 15:07:04', '2026-11-03 20:08:51.357321+05', '2026-11-03 20:08:51.357321+05'),
	(245, '1a1a1f5d9d2d3c5b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-190851-K3TF is being created', '', 1, NULL, '2026-11-03 15:10:01', '2026-11-03 20:20:52.105482+05', '2026-11-03 20:20:52.105482+05'),
	(247, '1a1a200bc6315539', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-192052-34Q0 is being created', '', 1, NULL, '2026-11-03 15:21:57', '2026-11-03 20:23:51.628439+05', '2026-11-03 20:23:51.628439+05'),
	(249, '1a1a2037895b7a20', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-192351-AD4E is being created', '', 1, NULL, '2026-11-03 15:24:57', '2026-11-03 20:26:51.423078+05', '2026-11-03 20:26:51.423078+05'),
	(251, '1a1a2082c1f1faa0', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-192651-SXEP is being created', '', 1, NULL, '2026-11-03 15:30:05', '2026-11-03 21:56:53.818419+05', '2026-11-03 21:56:53.818419+05'),
	(253, '1a1a258afb4dc996', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-205653-WFQ5 is being created', '', 1, NULL, '2026-11-03 16:58:01', '2026-11-03 21:59:51.362901+05', '2026-11-03 21:59:51.362901+05'),
	(255, '1a1a25b7fb5ccb0c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-205951-34YO is being created', '', 1, NULL, '2026-11-03 17:01:02', '2026-11-03 22:02:50.854032+05', '2026-11-03 22:02:50.854032+05'),
	(257, '1a1a25e32d36175d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-210250-37XZ is being created', '', 1, NULL, '2026-11-03 17:04:03', '2026-11-03 22:05:50.987387+05', '2026-11-03 22:05:50.987387+05'),
	(259, '1a1a261311b3769a', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-210550-KOPN is being created', '', 1, NULL, '2026-11-03 17:07:18', '2026-11-03 22:08:50.931663+05', '2026-11-03 22:08:50.931663+05'),
	(261, '1a1a263ae37cc78c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-210850-QU85 is being created', '', 1, NULL, '2026-11-03 17:10:02', '2026-11-03 22:11:51.006356+05', '2026-11-03 22:11:51.006356+05'),
	(263, '1a1a2666cfc3694f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-211151-WHN8 is being created', '', 1, NULL, '2026-11-03 17:13:02', '2026-11-03 22:14:52.170405+05', '2026-11-03 22:14:52.170405+05'),
	(265, '1a1a26933b248c26', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-211452-KSR9 is being created', '', 1, NULL, '2026-11-03 17:16:04', '2026-11-03 22:17:52.701388+05', '2026-11-03 22:17:52.701388+05'),
	(267, '1a1a26beb59002a2', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-211752-TS66 is being created', '', 1, NULL, '2026-11-03 17:19:01', '2026-11-03 22:20:51.880037+05', '2026-11-03 22:20:51.880037+05'),
	(269, '1a1a26eaf7126a11', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-212051-6JQ0 is being created', '', 1, NULL, '2026-11-03 17:22:03', '2026-11-03 22:23:51.219677+05', '2026-11-03 22:23:51.219677+05'),
	(271, '1a1a2716cc12328b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-212351-6708 is being created', '', 1, NULL, '2026-11-03 17:25:02', '2026-11-03 22:26:50.967366+05', '2026-11-03 22:26:50.967366+05'),
	(273, '1a1a2742b1ec4845', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-212650-ZRL3 is being created', '', 1, NULL, '2026-11-03 17:28:03', '2026-11-03 22:29:50.97432+05', '2026-11-03 22:29:50.97432+05'),
	(275, '1a1a2770f1ecebd5', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-212950-0M75 is being created', '', 1, NULL, '2026-11-03 17:31:11', '2026-11-03 22:32:51.001871+05', '2026-11-03 22:32:51.001871+05'),
	(277, '1a1a279a644fc75e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-213251-MUK1 is being created', '', 1, NULL, '2026-11-03 17:34:02', '2026-11-03 22:35:51.089314+05', '2026-11-03 22:35:51.089314+05'),
	(279, '1a1a27c7a3afda46', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-213551-APAL is being created', '', 1, NULL, '2026-11-03 17:37:05', '2026-11-03 22:38:50.774331+05', '2026-11-03 22:38:50.774331+05'),
	(281, '1a1a27f2a581dec6', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-213850-YFMW is being created', '', 1, NULL, '2026-11-03 17:40:03', '2026-11-03 22:41:50.812113+05', '2026-11-03 22:41:50.812113+05'),
	(283, '1a1a281e291152b0', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-214150-6172 is being created', '', 1, NULL, '2026-11-03 17:43:01', '2026-11-03 22:44:51.286708+05', '2026-11-03 22:44:51.286708+05'),
	(285, '1a1a284a1696fa22', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-214451-EZXH is being created', '', 1, NULL, '2026-11-03 17:46:01', '2026-11-03 22:47:52.168908+05', '2026-11-03 22:47:52.168908+05'),
	(287, '1a1a2877113429f0', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-214752-EB5M is being created', '', 1, NULL, '2026-11-03 17:49:06', '2026-11-03 22:50:50.813985+05', '2026-11-03 22:50:50.813985+05'),
	(289, '1a1a28abfcbff558', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-215050-TK3X is being created', '', 1, NULL, '2026-11-03 17:52:42', '2026-11-03 22:53:52.047453+05', '2026-11-03 22:53:52.047453+05'),
	(291, '1a1a28cec461766d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-215352-ZOJV is being created', '', 1, NULL, '2026-11-03 17:55:03', '2026-11-03 22:56:51.294908+05', '2026-11-03 22:56:51.294908+05'),
	(293, '1a1a28f9fe314b82', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-215651-E6JO is being created', '', 1, NULL, '2026-11-03 17:57:59', '2026-11-03 22:59:50.986217+05', '2026-11-03 22:59:50.986217+05'),
	(295, '1a1a29272bef97d7', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-215950-5IRK is being created', '', 1, NULL, '2026-11-03 18:01:07', '2026-11-03 23:02:51.208562+05', '2026-11-03 23:02:51.208562+05'),
	(297, '1a1a2951a836c02a', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-220251-XCSY is being created', '', 1, NULL, '2026-11-03 18:03:59', '2026-11-03 23:05:51.057891+05', '2026-11-03 23:05:51.057891+05'),
	(299, '1a1a297d472ca70c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-220551-I7F8 is being created', '', 1, NULL, '2026-11-03 18:06:58', '2026-11-03 23:08:51.049671+05', '2026-11-03 23:08:51.049671+05'),
	(301, '1a1a29a8ebaa0b8f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-220851-SOQF is being created', '', 1, NULL, '2026-11-03 18:09:59', '2026-11-03 23:11:51.387291+05', '2026-11-03 23:11:51.387291+05'),
	(303, '1a1a4994f66f0978', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261103-221151-W70H is being created', '', 1, NULL, '2026-11-04 03:27:51', '2026-11-04 08:29:41.530856+05', '2026-11-04 08:29:41.530856+05'),
	(305, '1a1a49c60cdde152', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-072941-UHTR is being created', '', 1, NULL, '2026-11-04 03:31:12', '2026-11-04 10:39:54.707343+05', '2026-11-04 10:39:54.707343+05'),
	(307, '1a1a51332ce4cd6c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-093955-A6AY is being created', '', 1, NULL, '2026-11-04 05:40:59', '2026-11-04 10:42:54.125104+05', '2026-11-04 10:42:54.125104+05'),
	(309, '1a1a51604f7db967', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-094254-9ES7 is being created', '', 1, NULL, '2026-11-04 05:44:04', '2026-11-04 10:45:54.090891+05', '2026-11-04 10:45:54.090891+05'),
	(311, '1a1a5192f0cd3080', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-094554-LH29 is being created', '', 1, NULL, '2026-11-04 05:47:31', '2026-11-04 10:48:53.990394+05', '2026-11-04 10:48:53.990394+05'),
	(313, '1a1a51b73d2a39fa', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-094853-O3S1 is being created', '', 1, NULL, '2026-11-04 05:50:00', '2026-11-04 10:51:53.855315+05', '2026-11-04 10:51:53.855315+05'),
	(315, '1a1a51d690da81cd', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-095153-CL55 is being created', '', 1, NULL, '2026-11-04 05:52:03', '2026-11-04 10:54:53.790529+05', '2026-11-04 10:54:53.790529+05'),
	(317, '1a1a520f17c9556d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-095453-WIP2 is being created', '', 1, NULL, '2026-11-04 05:56:00', '2026-11-04 10:57:54.280796+05', '2026-11-04 10:57:54.280796+05'),
	(319, '1a1a524214a0de5d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-095754-2GUI is being created', '', 1, NULL, '2026-11-04 05:59:29', '2026-11-04 11:00:53.856604+05', '2026-11-04 11:00:53.856604+05'),
	(321, '1a1a5267773b5d1e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-100053-DVEG is being created', '', 1, NULL, '2026-11-04 06:02:02', '2026-11-04 11:03:53.906271+05', '2026-11-04 11:03:53.906271+05'),
	(323, '1a1a529347f620cf', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-100353-MAID is being created', '', 1, NULL, '2026-11-04 06:05:02', '2026-11-04 11:06:54.077166+05', '2026-11-04 11:06:54.077166+05'),
	(325, '1a1a52bf11f4539e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-100654-AJTL is being created', '', 1, NULL, '2026-11-04 06:08:00', '2026-11-04 11:09:54.045764+05', '2026-11-04 11:09:54.045764+05'),
	(327, '1a1a52fb8e2aefba', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-100954-5IZM is being created', '', 1, NULL, '2026-11-04 06:11:07', '2026-11-04 11:12:54.024802+05', '2026-11-04 11:12:54.024802+05'),
	(329, '1a1a5316b063f2f3', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-101254-JCRC is being created', '', 1, NULL, '2026-11-04 06:14:00', '2026-11-04 11:15:54.389908+05', '2026-11-04 11:15:54.389908+05'),
	(331, '1a1a5342eab8153c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-101554-LRLK is being created', '', 1, NULL, '2026-11-04 06:17:00', '2026-11-04 11:18:53.998435+05', '2026-11-04 11:18:53.998435+05'),
	(333, '1a1a536ea4a5a41b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-101854-ACI3 is being created', '', 1, NULL, '2026-11-04 06:20:00', '2026-11-04 11:21:54.137062+05', '2026-11-04 11:21:54.137062+05'),
	(335, '1a1a539af40771a5', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-102154-ZJAT is being created', '', 1, NULL, '2026-11-04 06:23:00', '2026-11-04 11:24:54.102053+05', '2026-11-04 11:24:54.102053+05'),
	(337, '1a1a53c6889c0d33', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-102454-JVS5 is being created', '', 1, NULL, '2026-11-04 06:26:00', '2026-11-04 11:30:54.048077+05', '2026-11-04 11:30:54.048077+05'),
	(339, '1a1a541e9196e51b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-103054-ZVRR is being created', '', 1, NULL, '2026-11-04 06:32:01', '2026-11-04 11:33:53.979886+05', '2026-11-04 11:33:53.979886+05'),
	(341, '1a1a544dafac9078', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-103353-XDBV is being created', '', 1, NULL, '2026-11-04 06:35:13', '2026-11-04 11:36:54.892762+05', '2026-11-04 11:36:54.892762+05'),
	(343, '1a1a547c9d4bfe8f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-103654-2ETU is being created', '', 1, NULL, '2026-11-04 06:38:25', '2026-11-04 11:39:53.841755+05', '2026-11-04 11:39:53.841755+05'),
	(345, '1a1a54a2271468fd', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-103953-8UL2 is being created', '', 1, NULL, '2026-11-04 06:40:59', '2026-11-04 11:42:54.068783+05', '2026-11-04 11:42:54.068783+05'),
	(347, '1a1a54cde73d0e2a', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-104254-4INH is being created', '', 1, NULL, '2026-11-04 06:43:59', '2026-11-04 11:45:54.245321+05', '2026-11-04 11:45:54.245321+05'),
	(349, '1a1a54fa9fb4b0c9', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-104554-7TYC is being created', '', 1, NULL, '2026-11-04 06:47:01', '2026-11-04 11:48:54.227864+05', '2026-11-04 11:48:54.227864+05'),
	(351, '1a1a5526cc9b6a53', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-104854-VOMV is being created', '', 1, NULL, '2026-11-04 06:50:03', '2026-11-04 11:51:54.102014+05', '2026-11-04 11:51:54.102014+05'),
	(353, '1a1a5564abeca4e4', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-105154-4NDO is being created', '', 1, NULL, '2026-11-04 06:54:16', '2026-11-04 11:56:08.965925+05', '2026-11-04 11:56:08.965925+05'),
	(355, '1a1a55ae8b0d409b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-105609-CVCQ is being created', '', 1, NULL, '2026-11-04 06:59:12', '2026-11-04 12:08:05.072204+05', '2026-11-04 12:08:05.072204+05'),
	(357, '1a1a563eff39ec8c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-110805-07JB is being created', '', 1, NULL, '2026-11-04 07:09:10', '2026-11-04 12:11:05.13994+05', '2026-11-04 12:11:05.13994+05'),
	(359, '1a1a566b07998881', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-111105-5OF6 is being created', '', 1, NULL, '2026-11-04 07:12:11', '2026-11-04 12:14:05.103352+05', '2026-11-04 12:14:05.103352+05'),
	(361, '1a1a5698df4ef19a', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-111405-YR0R is being created', '', 1, NULL, '2026-11-04 07:15:12', '2026-11-04 12:17:09.855358+05', '2026-11-04 12:17:09.855358+05'),
	(363, '1a1a56cc088c3d24', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-111709-FRJI is being created', '', 1, NULL, '2026-11-04 07:18:48', '2026-11-04 12:23:03.649059+05', '2026-11-04 12:23:03.649059+05'),
	(365, '1a1a571a98a282ec', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-112303-40W3 is being created', '', 1, NULL, '2026-11-04 07:24:10', '2026-11-04 12:26:03.711644+05', '2026-11-04 12:26:03.711644+05'),
	(367, '1a1a5746e3889ed0', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-112603-J2FQ is being created', '', 1, NULL, '2026-11-04 07:27:11', '2026-11-04 12:56:58.661354+05', '2026-11-04 12:56:58.661354+05'),
	(369, '1a1a590b2e6f43df', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-115658-KQW6 is being created', '', 1, NULL, '2026-11-04 07:58:04', '2026-11-04 12:59:58.372624+05', '2026-11-04 12:59:58.372624+05'),
	(371, '1a1a5937d652c00b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-115958-D8B8 is being created', '', 1, NULL, '2026-11-04 08:01:05', '2026-11-04 13:07:23.846594+05', '2026-11-04 13:07:23.846594+05'),
	(373, '1a1a59a3db6c5d4a', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-120723-6N4B is being created', '', 1, NULL, '2026-11-04 08:08:29', '2026-11-04 13:14:06.334808+05', '2026-11-04 13:14:06.334808+05'),
	(375, '1a1a5a07715dea66', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-121406-V2AU is being created', '', 1, NULL, '2026-11-04 08:15:17', '2026-11-04 13:19:25.080099+05', '2026-11-04 13:19:25.080099+05'),
	(377, '1a1a5a45ff729844', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-121925-S0D2 is being created', '', 1, NULL, '2026-11-04 08:19:33', '2026-11-04 13:28:52.71623+05', '2026-11-04 13:28:52.71623+05'),
	(379, '1a1a5adefbc039de', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-122852-HZFP is being created', '', 1, NULL, '2026-11-04 08:29:59', '2026-11-04 13:34:23.336454+05', '2026-11-04 13:34:23.336454+05'),
	(381, '1a1a5b2f4fa1fec3', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-123423-VPI8 is being created', '', 1, NULL, '2026-11-04 08:35:29', '2026-11-04 13:37:23.441771+05', '2026-11-04 13:37:23.441771+05'),
	(383, '1a1a5b5b9fe3817c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-123723-1TAE is being created', '', 1, NULL, '2026-11-04 08:38:30', '2026-11-04 13:40:23.416808+05', '2026-11-04 13:40:23.416808+05'),
	(385, '1a1a5b88093edeaa', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-124023-4CTJ is being created', '', 1, NULL, '2026-11-04 08:41:32', '2026-11-04 13:43:23.340301+05', '2026-11-04 13:43:23.340301+05'),
	(387, '1a1a5bb31364d44c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-124323-YKJ9 is being created', '', 1, NULL, '2026-11-04 08:44:28', '2026-11-04 13:46:23.393226+05', '2026-11-04 13:46:23.393226+05'),
	(389, '1a1a5bdf0964559c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-124623-DA7W is being created', '', 1, NULL, '2026-11-04 08:47:29', '2026-11-04 13:49:23.060799+05', '2026-11-04 13:49:23.060799+05'),
	(391, '1a1a5bfcf9061b81', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-124923-EZY1 is being created', '', 1, NULL, '2026-11-04 08:49:31', '2026-11-04 13:52:58.424785+05', '2026-11-04 13:52:58.424785+05'),
	(393, '1a1a5c3fa61203fd', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-125258-XB5P is being created', '', 1, NULL, '2026-11-04 08:54:05', '2026-11-04 13:55:58.318435+05', '2026-11-04 13:55:58.318435+05'),
	(395, '1a1a5c6c5f55e5a1', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-125558-ZNBE is being created', '', 1, NULL, '2026-11-04 08:57:07', '2026-11-04 13:58:58.432947+05', '2026-11-04 13:58:58.432947+05'),
	(397, '1a1a5c979359e531', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-125858-6SDI is being created', '', 1, NULL, '2026-11-04 09:00:05', '2026-11-04 14:06:45.260666+05', '2026-11-04 14:06:45.260666+05'),
	(399, '1a1a5d11289aca9d', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-130645-8W8A is being created', '', 1, NULL, '2026-11-04 09:08:23', '2026-11-04 14:15:19.444863+05', '2026-11-04 14:15:19.444863+05'),
	(401, '1a1a5da605cb074a', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-131519-TQN2 is being created', '', 1, NULL, '2026-11-04 09:18:32', '2026-11-04 14:20:26.727869+05', '2026-11-04 14:20:26.727869+05'),
	(403, '1a1a5dc3ece4806e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-132026-6CRW is being created', '', 1, NULL, '2026-11-04 09:20:35', '2026-11-04 14:23:26.834181+05', '2026-11-04 14:23:26.834181+05'),
	(405, '1a1a5dfdaeaef21c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-132326-P76F is being created', '', 1, NULL, '2026-11-04 09:24:32', '2026-11-04 14:26:26.755987+05', '2026-11-04 14:26:26.755987+05'),
	(407, '1a1a5e29d596229f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-132626-Y2KL is being created', '', 1, NULL, '2026-11-04 09:27:32', '2026-11-04 14:29:26.768834+05', '2026-11-04 14:29:26.768834+05'),
	(409, '1a1a5e574b1ec7ac', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-132926-QDHL is being created', '', 1, NULL, '2026-11-04 09:30:38', '2026-11-04 14:32:26.711664+05', '2026-11-04 14:32:26.711664+05'),
	(411, '1a1a5e73a97efc94', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-133226-JCER is being created', '', 1, NULL, '2026-11-04 09:32:35', '2026-11-04 14:35:26.970875+05', '2026-11-04 14:35:26.970875+05'),
	(413, '1a1a5eaf06ba3879', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-133526-6VWY is being created', '', 1, NULL, '2026-11-04 09:36:38', '2026-11-04 14:38:27.213987+05', '2026-11-04 14:38:27.213987+05'),
	(415, '1a1a5ee2677fe6ba', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-133827-GWFL is being created', '', 1, NULL, '2026-11-04 09:40:09', '2026-11-04 14:41:26.809374+05', '2026-11-04 14:41:26.809374+05'),
	(417, '1a1a5f0643035782', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-134126-H6R3 is being created', '', 1, NULL, '2026-11-04 09:42:35', '2026-11-04 14:44:26.881903+05', '2026-11-04 14:44:26.881903+05'),
	(419, '1a1a5f31cb261a29', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-134426-MZHB is being created', '', 1, NULL, '2026-11-04 09:45:33', '2026-11-04 14:47:26.830577+05', '2026-11-04 14:47:26.830577+05'),
	(421, '1a1a5f5d17f46e2e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-134726-CKGJ is being created', '', 1, NULL, '2026-11-04 09:48:31', '2026-11-04 14:50:27.26238+05', '2026-11-04 14:50:27.26238+05'),
	(423, '1a1a5f89292b257f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-135027-Q42L is being created', '', 1, NULL, '2026-11-04 09:51:32', '2026-11-04 14:53:26.956945+05', '2026-11-04 14:53:26.956945+05'),
	(425, '1a1a5fb56dec42fb', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-135326-ZBAP is being created', '', 1, NULL, '2026-11-04 09:54:33', '2026-11-04 14:56:26.876666+05', '2026-11-04 14:56:26.876666+05'),
	(427, '1a1a5fe1efbcde4f', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-135626-DB0V is being created', '', 1, NULL, '2026-11-04 09:57:35', '2026-11-04 14:59:26.791883+05', '2026-11-04 14:59:26.791883+05'),
	(429, '1a1a60164bf7ac66', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-135926-8NB2 is being created', '', 1, NULL, '2026-11-04 10:01:10', '2026-11-04 15:05:15.57909+05', '2026-11-04 15:05:15.57909+05'),
	(431, '1a1a6064156e8e4c', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-140515-OKAZ is being created', '', 1, NULL, '2026-11-04 10:06:27', '2026-11-04 15:08:15.470728+05', '2026-11-04 15:08:15.470728+05'),
	(433, '1a1a608e71c1f725', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-140815-EKQR is being created', '', 1, NULL, '2026-11-04 10:09:22', '2026-11-04 15:11:15.446923+05', '2026-11-04 15:11:15.446923+05'),
	(435, '1a1a60ba14be5a06', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-141115-1GUO is being created', '', 1, NULL, '2026-11-04 10:12:20', '2026-11-04 15:14:15.301391+05', '2026-11-04 15:14:15.301391+05'),
	(437, '1a1a60e6de33265e', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-141415-ARCT is being created', '', 1, NULL, '2026-11-04 10:15:24', '2026-11-04 15:17:15.518504+05', '2026-11-04 15:17:15.518504+05'),
	(439, '1a1a6113d4c99386', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-141715-T93N is being created', '', 1, NULL, '2026-11-04 10:18:22', '2026-11-04 15:20:15.326818+05', '2026-11-04 15:20:15.326818+05'),
	(441, '1a1a613e6218166b', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-142015-CDFL is being created', '', 1, NULL, '2026-11-04 10:21:22', '2026-11-04 15:23:15.479058+05', '2026-11-04 15:23:15.479058+05'),
	(443, '1a1a616b0c85e3dd', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-142315-Q3K6 is being created', '', 1, NULL, '2026-11-04 10:24:19', '2026-11-04 15:26:15.304009+05', '2026-11-04 15:26:15.304009+05'),
	(445, '1a1a6196943d52ab', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-142615-81UT is being created', '', 1, NULL, '2026-11-04 10:27:23', '2026-11-04 15:29:15.264515+05', '2026-11-04 15:29:15.264515+05'),
	(447, '1a1a61c26087baea', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-142915-AF3R is being created', '', 1, NULL, '2026-11-04 10:30:23', '2026-11-04 15:32:15.328644+05', '2026-11-04 15:32:15.328644+05'),
	(449, '1a1a61edf4e9ced5', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-143215-IJM7 is being created', '', 1, NULL, '2026-11-04 10:33:22', '2026-11-04 15:35:15.296327+05', '2026-11-04 15:35:15.296327+05'),
	(451, '1a1a6237a89db3d0', 'postmaster@accountprotection.microsoft.com', NULL, 'Undeliverable: Ticket with tracking id: QRY-20261104-143515-VSVM is being created', '', 1, NULL, '2026-11-04 10:38:23', '2026-11-04 15:40:18.084897+05', '2026-11-04 15:40:18.084897+05'),
	(453, '1a1ceb17c742fd0a', 'noreply-accounts@google.com', NULL, 'You shared some Google Account data with FastEmailAutomation', 'Keep track of your Google Account data



virtualuniversity08@gmail.com

 

<!--[if !mso]><!-->

<!--[if false]><!-->


You''re receiving this email because you used Sign in with Google to sign in  
to


FastEmailAutomation


on November 12 at 11:38 AM .

This email summarizes the info you shared. There’s nothing you need to do  
right now.


<!--[if !mso]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

You''re receiving this email because you used Sign in with Google to sign in  
to


FastEmailAutomation


on November 12 at 11:38 AM .

This email summarizes the info you shared. There’s nothing you need to do  
right now.

<!--[if false]><!-->


FastEmailAutomation received this profile info



Virtual University

Name and profile picture



virtualuniversity08@gmail.com

Email address





 


This email includes the info you shared on

November 12 at 11:38 AM

If you want to stop using Sign in with Google with

FastEmailAutomation , go to your Google Account.


<!--[if !mso]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

FastEmailAutomation received this profile info

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

Virtual University

Name and profile picture

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

virtualuniversity08@gmail.com

Email address

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

 

<!--[if false]><!-->

<!--[if false]><!-->

This email includes the info you shared on

November 12 at 11:38 AM

<!--[if false]><!-->

If you want to stop using Sign in with Google with

FastEmailAutomation , go to your Google Account.

<!--[if false]><!-->


<!--[if mso]>
<v:roundrect xmlns:v="urn:schemas-microsoft-com:vml"  
xmlns:w="urn:schemas-microsoft-com:office:word"  
href="https://accounts.google.com/AccountChooser?Email=virtualuniversity08@gmail.com&continue=https%3A%2F%2Fmyaccount.google.com%2Flinkedapps%2Foverview%2FAUKa-R5yKRMhr4txvWkPO37D20M9sjbF_ax1_XWMNQ3XT0Z0ZXEfJMYyGpkEv7HmN4sumbhqoXX1yME3mMKghufEM8c%3Futm_source%3De_notification%26utm_medium%3Demail_notification"  
style="height:48px;width:268px;v-text-anchor:middle;" arcsize="125%"  
stroke="false" fillcolor="#0b57d0">
<w:anchorlock/>
<v:textbox inset="0px,0px,0px,0px">

<![endif]-->
<https://c.gle/AGSJxQxWvbzIxSG_K9FwEfmfcQxYskChAzPaq-kD_v-Rj4zolrmhjJPZRYdDB5jaEeG3muMHJQXd-vq9Es6MR-vkYrj-amikbuzieYdsCoMcNjPL4raP5ax_FhirD47odO_pBUchH7f1XAWhMyJL8FsnuPvfLO_MaQys-O5yMK63F8lciM-W--tpFFWOtGN4YCBz_XFj3dUHrtGxliSSNvGQqMMC2revY703IO0takBIYYjl5aNWCwbyQMKg3TR1332lU-GYlwQ7NWgQl8xU1rWCX2T59EqRhPfjAU1vsD8AYc-dmiowU1uldTYfPzGi_7SypfH_NtA14NyfjiA7wAe5pJWEF1IIzzmoX3T2yjnx1KVL3SxgdsTOpkFWnPqwLagGuBbznDr6qlpVBTLo3JIcMHNwgwACVM93ZcmPWZIw2bkQm-ngG69uYbmQpkq9M30dnyZ-xokgAXpQ0G5fWuttxTk-ldrlr7HfHqoO91Tm>  
Go  
to your Google Account


Review

FastEmailAutomation ’s


Privacy Policy

  and


Terms of Service

  to understand how FastEmailAutomation will process and protect your data.

If you want to delete the data you shared with

FastEmailAutomation ,

visit

FastEmailAutomation .

Safer with Google

Your Google Account protects your privacy with advanced security designed  
to keep your data safe

<!--[if !mso]><!-->

<!--[if false]><!-->

Safer with Google

Your Google Account protects your privacy with advanced security designed  
to keep your data safe


 

You received this email to let you know about important changes to your  
Google Account and services.

If you want to stop receiving these emails, you can  
<https://myaccount.google.com/communication-preferences/unsubscribe/gt/AGSJxQz0qQ-0FkbhAWkQ3npZTnDaExqgQx2Y3iMviIkklEEJCviUFviVmH8NRTKzLUgNdkyr2rpMNZ6l2P07k0Tnlh0nKksAAn-XiYIPp4TokESD1AdUZ_5IJylGzrrRuXJpKiOflFBVbJouKcj9zPAn-PTlmkfqoGWf0lR7ZLl9wtxk_e3jhtLWth-aVj2TVZGb2_kNxjU2Awnz1_C4LT9exH_9VZuINp1YX0kcYLiQ9EN0XI2Uwt_LzC9onqmsWSivdKPQR9UjcuQV4ULU65fuiL0HkcPdxLLAQGq6rqAHdB3SIcoyLkX_Sb-Vkw?utm_source=gm&utm_medium=email&auto=true>unsubscribe .

Even if you unsubscribe from these emails, you’ll continue to receive  
security alerts.

© 2026 Google LLC 1600 Amphitheatre Parkway, Mountain View, CA 94043
', 1, 352, '2026-11-12 07:38:20', '2026-11-13 16:22:57.143514+05', '2026-11-13 16:22:57.143514+05'),
	(454, '1a1d4da61ce30d99', 'bc230203410tsa@vu.edu.pk', 19, 'Financial Aid Package Status', 'I would like to inquire about the *status of my application* for the
university''s financial aid package.
', 1, 354, '2026-11-13 12:20:32', '2026-11-13 17:22:50.317407+05', '2026-11-13 17:22:50.317407+05'),
	(455, '1a1d520f49d49bb9', 'bc230203410tsa@vu.edu.pk', 19, 'Issue in my dorm', 'I am calm but the sink in my dorm is overflowing and the water is reaching
the electrical outlets. I need maintenance immediately.
', 1, 355, '2026-11-13 13:37:37', '2026-11-13 19:00:25.016004+05', '2026-11-13 19:00:25.016004+05'),
	(456, '1a1e7ccdf4d42229', 'bc230203410tsa@vu.edu.pk', 19, 'Inline Assignment Submission Error', 'I don'':t know who have created this "Inline Assignment Submission" thing. I
completed the assignment in docx and when I saw it, I just click back and
now it is showing "Submitted": with no option to submit it again.  :
', 1, 357, '2026-11-17 04:38:35', '2026-11-17 09:39:35.203709+05', '2026-11-17 09:39:35.203709+05');

-- Dumping structure for table public.notifications
CREATE TABLE IF NOT EXISTS "notifications" (
	"id" SERIAL NOT NULL,
	"recipient_id" INTEGER NULL DEFAULT NULL,
	"ticket_id" INTEGER NULL DEFAULT NULL,
	"type" VARCHAR(255) NULL DEFAULT NULL,
	"channel" VARCHAR(255) NOT NULL,
	"subject" VARCHAR(255) NOT NULL,
	"message_body" TEXT NOT NULL,
	"status" VARCHAR(255) NOT NULL,
	"retry_count" SMALLINT NOT NULL DEFAULT '0',
	"error_message" VARCHAR(255) NULL DEFAULT NULL,
	"sent_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "notifications_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "tickets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.notifications: 318 rows
DELETE FROM "notifications";
INSERT INTO "notifications" ("id", "recipient_id", "ticket_id", "type", "channel", "subject", "message_body", "status", "retry_count", "error_message", "sent_at", "created_at", "updated_at") VALUES
	(1, 19, 17, 'ticket_created', 'email', 'new ticket created', 'this is new ticket created', 'sent', 0, NULL, '2026-09-18 23:38:18.011826+05', '2026-09-18 23:25:23.209017+05', '2026-09-18 23:38:16.812211+05'),
	(2, 19, 61, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-000349-46A4 is being created', '
Hello,

Your ticket "Availability of librarians" has been received successfully.

Ticket Tracking ID: QRY-20260919-000349-46A4
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 00:03:55.06313+05', '2026-09-19 00:03:49.934082+05', '2026-09-19 00:03:53.925564+05'),
	(3, 19, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-000628-EO9E is being created', '
Hello,

Your ticket "Student Scholarship Issue" has been received successfully.

Ticket Tracking ID: QRY-20260919-000628-EO9E
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 00:06:35.191451+05', '2026-09-19 00:06:28.783889+05', '2026-09-19 00:06:33.917059+05'),
	(4, 3, NULL, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-000628-EO9E', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-000628-EO9E
Subject: Student Scholarship Issue
Priority: Low
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-19 00:06:36.133885+05', '2026-09-19 00:06:28.783889+05', '2026-09-19 00:06:36.134823+05'),
	(5, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-000905-47RG is being created', '
Hello,

Your ticket "Delivery Status Notification (Failure)" has been received successfully.

Ticket Tracking ID: QRY-20260919-000905-47RG
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 00:09:14.903387+05', '2026-09-19 00:09:04.879182+05', '2026-09-19 00:09:13.917549+05'),
	(6, 3, NULL, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260919-000628-EO9E', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260919-000628-EO9E
Subject: Student Scholarship Issue

Reply:
I need help with my application for a student scholarship for first-generation students.

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-09-19 00:09:24.931371+05', '2026-09-19 00:09:15.497406+05', '2026-09-19 00:09:23.929481+05'),
	(7, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-001204-I5KN is being created', '
Hello,

Your ticket "Delivery Status Notification (Failure)" has been received successfully.

Ticket Tracking ID: QRY-20260919-001204-I5KN
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 00:12:14.778542+05', '2026-09-19 00:12:04.745388+05', '2026-09-19 00:12:13.917369+05'),
	(8, 1, 65, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-124723-ZO50 is being created', '
Hello,

Your ticket "overcharged for my lab fees" has been received successfully.

Ticket Tracking ID: QRY-20260919-124723-ZO50
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 12:47:33.749867+05', '2026-09-19 12:47:23.282028+05', '2026-09-19 12:47:32.901982+05'),
	(9, 3, 65, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-124723-ZO50', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-124723-ZO50
Subject: overcharged for my lab fees
Priority: Medium
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-19 12:47:35.584055+05', '2026-09-19 12:47:23.282028+05', '2026-09-19 12:47:35.584741+05'),
	(10, 19, 66, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-125154-TOEX is being created', '
Hello,

Your ticket "refund the fees for the semester" has been received successfully.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 12:52:03.858129+05', '2026-09-19 12:51:54.318317+05', '2026-09-19 12:52:02.90062+05'),
	(11, 3, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: Medium
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-19 12:52:04.650644+05', '2026-09-19 12:51:54.318317+05', '2026-09-19 12:52:04.651224+05'),
	(12, 19, 67, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-130433-3YTE is being created', '
Hello,

Your ticket "Issue with finance" has been received successfully.

Ticket Tracking ID: QRY-20260919-130433-3YTE
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 13:04:43.652302+05', '2026-09-19 13:04:33.793711+05', '2026-09-19 13:04:42.898693+05'),
	(13, 3, 67, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-130433-3YTE', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-130433-3YTE
Subject: Issue with finance
Priority: High
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-19 13:04:44.468035+05', '2026-09-19 13:04:33.793711+05', '2026-09-19 13:04:44.468858+05'),
	(14, 3, 67, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260919-130433-3YTE', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260919-130433-3YTE
Subject: Issue with finance

Reply:
I received an eviction notice for non-payment, but my scholarship was
supposed to cover it. I need the housing hold removed now.


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-09-19 14:03:54.808724+05', '2026-09-19 14:03:52.694899+05', '2026-09-19 14:03:53.944172+05'),
	(15, 19, 67, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260919-130433-3YTE', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260919-130433-3YTE
Subject: Issue with finance

Reply:
I received an eviction notice for non-payment, but my scholarship was
supposed to cover it. I need the housing hold removed now.


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-09-19 14:32:48.015662+05', '2026-09-19 14:32:39.57452+05', '2026-09-19 14:32:47.147745+05'),
	(16, 19, 67, 'status_changed', 'email', 'Ticket QRY-20260919-130433-3YTE Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-130433-3YTE
Subject: Issue with finance

Previous Status: pending
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-19 14:58:23.049684+05', '2026-09-19 14:49:22.615815+05', '2026-09-19 14:58:22.072635+05'),
	(17, NULL, 68, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-204838-43GV is being created', '
Hello,

Your ticket "Security alert" has been received successfully.

Ticket Tracking ID: QRY-20260919-204838-43GV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 20:49:37.609739+05', '2026-09-19 20:48:37.373557+05', '2026-09-19 20:49:36.511678+05'),
	(18, NULL, 69, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20260919-205137-RC8I is being created', '
Hello,

Your ticket "2-Step Verification turned on" has been received successfully.

Ticket Tracking ID: QRY-20260919-205137-RC8I
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-09-19 20:52:37.479042+05', '2026-09-19 20:51:37.421296+05', '2026-09-19 20:52:36.524105+05'),
	(19, 1, 65, 'escalated', 'email', 'Escalated Ticket No. QRY-20260919-124723-ZO50', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20260919-124723-ZO50
Subject: overcharged for my lab fees
Priority: Medium

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-09-20 15:48:23.907575+05', '2026-09-20 15:48:22.870793+05', '2026-09-20 15:48:22.97396+05'),
	(20, 1, 66, 'escalated', 'email', 'Escalated Ticket No. QRY-20260919-125154-TOEX', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: Medium

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-09-20 15:48:24.952678+05', '2026-09-20 15:48:22.870793+05', '2026-09-20 15:48:24.953601+05'),
	(21, 19, 28, 'status_changed', 'email', 'Ticket QRY-20260903-064157-PZ2W Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260903-064157-PZ2W
Subject: Overcharged for my lab fees

Previous Status: in_progress
New Status: assigned

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-21 21:08:08.415953+05', '2026-09-21 21:07:56.012379+05', '2026-09-21 21:08:07.306881+05'),
	(22, 2, 47, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260909-140005-DXE7', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260909-140005-DXE7
Subject: sign visa documents

Reply:
Dear Student User,

Thank you for contacting the Admissions Office. We understand the urgency of your situation, as your visa documents need to be signed ahead of your embassy appointment tomorrow afternoon.

Your request has been received and is being handled as a priority. A member of the Admissions team will review your documentation and follow up with you as soon as possible. To help avoid any delays, please ensure your visa documents have been submitted with your request; if not, kindly provide them at your earliest convenience.

Thank you for your patience.

Best regards,
Admissions Office
Reference: QRY-20260909-140005-DXE7

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-09-24 17:41:44.588759+05', '2026-09-24 17:40:47.197976+05', '2026-09-24 17:41:43.598209+05'),
	(23, 19, 66, 'status_changed', 'email', 'Ticket QRY-20260919-125154-TOEX Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Previous Status: escalated
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-25 13:35:54.788011+05', '2026-09-25 12:13:45.496806+05', '2026-09-25 13:35:52.875391+05'),
	(24, 19, 66, 'status_changed', 'email', 'Ticket QRY-20260919-125154-TOEX Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Previous Status: in_progress
New Status: assigned

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-25 13:35:55.782722+05', '2026-09-25 13:29:41.319539+05', '2026-09-25 13:35:55.783357+05'),
	(25, 19, 66, 'status_changed', 'email', 'Ticket QRY-20260919-125154-TOEX Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Previous Status: assigned
New Status: escalated

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-25 13:37:53.883566+05', '2026-09-25 13:37:15.577173+05', '2026-09-25 13:37:52.877714+05'),
	(26, 366, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: medium
Status: escalated

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-25 17:56:32.050157+05', '2026-09-25 17:55:31.191345+05', '2026-09-25 17:56:30.938168+05'),
	(27, 3, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: medium
Status: escalated

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-25 17:56:33.193918+05', '2026-09-25 17:55:46.981304+05', '2026-09-25 17:56:33.195177+05'),
	(28, 366, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: high
Status: escalated

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-25 18:18:32.251588+05', '2026-09-25 18:17:45.502466+05', '2026-09-25 18:18:30.93331+05'),
	(29, 4, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: high
Status: escalated

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-25 18:20:32.058639+05', '2026-09-25 18:20:30.134367+05', '2026-09-25 18:20:30.943062+05'),
	(30, 366, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: high
Status: escalated

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-25 18:23:32.137564+05', '2026-09-25 18:22:54.47601+05', '2026-09-25 18:23:30.93585+05'),
	(31, 3, 66, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260919-125154-TOEX', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester
Priority: high
Status: escalated

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-09-25 18:23:33.182017+05', '2026-09-25 18:23:08.124956+05', '2026-09-25 18:23:33.182912+05'),
	(32, 19, 66, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260919-125154-TOEX', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Reply:
Dear Tabish Sardar Ali Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office regarding your semester refund.

I understand that you have been waiting for three weeks since the approval of your refund, and I apologize for any inconvenience this delay may have caused. Please be assured that your case will be reviewed by our finance team to check the current status of your refund and identify any pending steps.

We will follow up with you shortly with an update. If any additional information or documentation is required from your side, we will let you know.

Thank you for your patience.

Best regards,
Billing, Accounts & Finance Office

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-09-25 19:08:24.914908+05', '2026-09-25 19:08:10.925036+05', '2026-09-25 19:08:22.07403+05'),
	(33, 19, 28, 'status_changed', 'email', 'Ticket QRY-20260903-064157-PZ2W Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260903-064157-PZ2W
Subject: Overcharged for my lab fees

Previous Status: assigned
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-25 19:12:23.905965+05', '2026-09-25 19:11:25.776757+05', '2026-09-25 19:12:22.75687+05'),
	(34, 19, 66, 'status_changed', 'email', 'Ticket QRY-20260919-125154-TOEX Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Previous Status: pending
New Status: resolved

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-26 15:04:20.59156+05', '2026-09-26 15:03:29.76967+05', '2026-09-26 15:04:19.549862+05'),
	(35, 19, 66, 'status_changed', 'email', 'Ticket QRY-20260919-125154-TOEX Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Previous Status: resolved
New Status: escalated

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-26 15:26:39.919431+05', '2026-09-26 15:26:21.827574+05', '2026-09-26 15:26:38.993604+05'),
	(36, 19, 66, 'status_changed', 'email', 'Ticket QRY-20260919-125154-TOEX Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-125154-TOEX
Subject: refund the fees for the semester

Previous Status: escalated
New Status: resolved

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-09-26 15:31:24.205707+05', '2026-09-26 15:30:23.384512+05', '2026-09-26 15:31:23.282827+05'),
	(37, 3, 19, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072812-MX7K', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072812-MX7K
Subject: Transfer to wrong school account

Reply:
sir, have you checked?

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-10 19:05:29.465898+05', '2026-10-10 19:05:00.829104+05', '2026-10-10 19:05:28.65789+05'),
	(38, 3, 19, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072812-MX7K', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072812-MX7K
Subject: Transfer to wrong school account

Reply:
please check now

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-10 19:19:29.127661+05', '2026-10-10 19:19:17.168826+05', '2026-10-10 19:19:28.064963+05'),
	(39, 19, 70, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261011-144532-7DS0 is being created', '
Hello,

Your ticket "Urgent: Challan Payment Verification & Late Fee Fine" has been received successfully.

Ticket Tracking ID: QRY-20261011-144532-7DS0
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-10-11 15:46:27.61625+05', '2026-10-11 15:45:32.663445+05', '2026-10-11 15:46:20.700506+05'),
	(42, 3, 19, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072812-MX7K', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072812-MX7K
Subject: Transfer to wrong school account

Reply:
Sir, I am waiting

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-11 15:54:23.814729+05', '2026-10-11 15:53:21.546425+05', '2026-10-11 15:54:21.411133+05'),
	(43, 19, 19, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072812-MX7K', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072812-MX7K
Subject: Transfer to wrong school account

Reply:
I am currently on leave

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-11 15:54:24.722434+05', '2026-10-11 15:53:21.586085+05', '2026-10-11 15:54:24.723044+05'),
	(44, 3, 18, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-071538-ZF5U', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-071538-ZF5U
Subject: Late Fees Issue

Reply:
any update on it sir?

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-11 15:55:22.488427+05', '2026-10-11 15:54:52.450072+05', '2026-10-11 15:55:21.409821+05'),
	(45, 19, 18, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-071538-ZF5U', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-071538-ZF5U
Subject: Late Fees Issue

Reply:
I am currently on leave

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-11 15:55:23.418405+05', '2026-10-11 15:54:52.45926+05', '2026-10-11 15:55:23.418999+05'),
	(46, 3, 18, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-071538-ZF5U', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-071538-ZF5U
Subject: Late Fees Issue

Reply:
ok thanks

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-10-11 15:57:24.335146+05', '2026-10-11 15:56:44.423004+05', '2026-10-11 15:57:21.408443+05'),
	(54, 2, 77, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261024-190543-7I8D is being created', '
Hello,

Your ticket "trouble logging into my account" has been received successfully.

Ticket Tracking ID: QRY-20261024-190543-7I8D
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-10-24 20:06:35.595319+05', '2026-10-24 20:05:43.186576+05', '2026-10-24 20:06:29.962188+05'),
	(55, 22, 77, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261024-190543-7I8D', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261024-190543-7I8D
Subject: trouble logging into my account
Priority: Medium
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-10-24 20:06:36.757435+05', '2026-10-24 20:05:43.186576+05', '2026-10-24 20:06:36.75839+05'),
	(121, NULL, 138, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261025-114022-OSBD is being created', '
Hello,

Your ticket "[Action Required] Mark AI agent OAuth clients as agentic for Google Workspace MCP by Nov 11, 2026" has been received successfully.

Ticket Tracking ID: QRY-20261025-114022-OSBD
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-10-25 12:41:22.293137+05', '2026-10-25 12:40:22.289245+05', '2026-10-25 12:41:21.046542+05'),
	(122, 4, 70, 'escalated', 'email', 'Escalated Ticket No. QRY-20261011-144532-7DS0', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20261011-144532-7DS0
Subject: Urgent: Challan Payment Verification & Late Fee Fine
Priority: Medium

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-10-25 13:25:28.060843+05', '2026-10-25 13:25:26.937641+05', '2026-10-25 13:25:27.044064+05'),
	(123, NULL, 139, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-142217-WOMB is being created', '
Hello,

Your ticket "Verify your email address" has been received successfully.

Ticket Tracking ID: QRY-20261103-142217-WOMB
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 15:22:38.953417+05', '2026-11-03 15:22:16.902332+05', '2026-11-03 15:22:38.147468+05'),
	(124, 22, 139, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261103-142217-WOMB', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261103-142217-WOMB
Subject: Verify your email address
Priority: Medium
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-11-03 15:22:41.149772+05', '2026-11-03 15:22:16.902332+05', '2026-11-03 15:22:41.152973+05'),
	(125, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-142339-TMFL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-142217-WOMB is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-142339-TMFL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 15:24:39.09536+05', '2026-11-03 15:23:39.474443+05', '2026-11-03 15:24:38.147471+05'),
	(126, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-142802-K84P is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-142339-TMFL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-142802-K84P
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 15:29:03.129507+05', '2026-11-03 15:28:02.688923+05', '2026-11-03 15:29:01.654433+05'),
	(127, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-143102-5GK0 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-142802-K84P is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-143102-5GK0
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 15:32:02.668085+05', '2026-11-03 15:31:02.917103+05', '2026-11-03 15:32:01.642729+05'),
	(128, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-143820-GDH5 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-143102-5GK0 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-143820-GDH5
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 15:39:58.708544+05', '2026-11-03 15:38:20.821948+05', '2026-11-03 15:39:56.639788+05'),
	(129, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-145216-HL7R is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-143820-GDH5 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-145216-HL7R
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 15:53:16.389116+05', '2026-11-03 15:52:16.625167+05', '2026-11-03 15:53:15.439768+05'),
	(130, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-145955-Q91C is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-145216-HL7R is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-145955-Q91C
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:01:29.748681+05', '2026-11-03 15:59:55.055045+05', '2026-11-03 16:01:28.73492+05'),
	(131, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-150533-DN32 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-145955-Q91C is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-150533-DN32
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:11:32.991499+05', '2026-11-03 16:05:33.690219+05', '2026-11-03 16:11:31.993748+05'),
	(132, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-152002-YQB8 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-150533-DN32 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-152002-YQB8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:21:02.11483+05', '2026-11-03 16:20:02.628191+05', '2026-11-03 16:21:01.214087+05'),
	(133, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-152302-5JW9 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-152002-YQB8 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-152302-5JW9
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:25:05.677914+05', '2026-11-03 16:23:02.563494+05', '2026-11-03 16:25:04.765161+05'),
	(134, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-153353-9YZ6 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-152302-5JW9 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-153353-9YZ6
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:34:53.044543+05', '2026-11-03 16:33:53.185426+05', '2026-11-03 16:34:52.195758+05'),
	(135, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-153653-H8R9 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-153353-9YZ6 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-153653-H8R9
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:37:53.063666+05', '2026-11-03 16:36:53.041271+05', '2026-11-03 16:37:52.195159+05'),
	(136, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-154202-NSHU is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-153653-H8R9 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-154202-NSHU
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:43:02.162559+05', '2026-11-03 16:42:02.059272+05', '2026-11-03 16:43:01.170748+05'),
	(137, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-155220-4KAV is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-154202-NSHU is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-155220-4KAV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:54:51.221241+05', '2026-11-03 16:52:20.084025+05', '2026-11-03 16:54:50.332378+05'),
	(138, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-155651-16UW is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-155220-4KAV is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-155651-16UW
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 16:57:51.004476+05', '2026-11-03 16:56:51.004064+05', '2026-11-03 16:57:50.132303+05'),
	(139, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-155950-R14P is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-155651-16UW is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-155950-R14P
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:00:50.99673+05', '2026-11-03 16:59:50.949731+05', '2026-11-03 17:00:50.125455+05'),
	(140, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-160250-AXFW is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-155950-R14P is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-160250-AXFW
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:03:51.39122+05', '2026-11-03 17:02:50.843946+05', '2026-11-03 17:03:50.133379+05'),
	(141, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-160550-W5VT is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-160250-AXFW is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-160550-W5VT
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:06:51.426177+05', '2026-11-03 17:05:50.92944+05', '2026-11-03 17:06:50.126024+05'),
	(142, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-160850-I7SL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-160550-W5VT is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-160850-I7SL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:08:53.185145+05', '2026-11-03 17:08:50.802322+05', '2026-11-03 17:08:52.105686+05'),
	(143, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-161151-VANQ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-160850-I7SL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-161151-VANQ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:12:51.444011+05', '2026-11-03 17:11:51.268473+05', '2026-11-03 17:12:50.128958+05'),
	(144, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-161451-QTTJ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-161151-VANQ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-161451-QTTJ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:15:51.405233+05', '2026-11-03 17:14:51.326756+05', '2026-11-03 17:15:50.131684+05'),
	(145, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-161751-F0MR is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-161451-QTTJ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-161751-F0MR
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:18:51.439869+05', '2026-11-03 17:17:51.431813+05', '2026-11-03 17:18:50.137226+05'),
	(146, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-162050-L1C1 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-161751-F0MR is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-162050-L1C1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:21:51.343179+05', '2026-11-03 17:20:50.846143+05', '2026-11-03 17:21:50.124623+05'),
	(147, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-162350-3Y1V is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-162050-L1C1 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-162350-3Y1V
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:24:51.499224+05', '2026-11-03 17:23:50.801629+05', '2026-11-03 17:24:50.134159+05'),
	(148, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-162650-HADF is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-162350-3Y1V is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-162650-HADF
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:27:51.383979+05', '2026-11-03 17:26:50.974558+05', '2026-11-03 17:27:50.127791+05'),
	(149, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-162950-L6FN is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-162650-HADF is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-162950-L6FN
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:30:51.487223+05', '2026-11-03 17:29:50.821273+05', '2026-11-03 17:30:50.128068+05'),
	(150, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-163251-9WLW is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-162950-L6FN is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-163251-9WLW
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:33:51.464297+05', '2026-11-03 17:32:51.111009+05', '2026-11-03 17:33:50.136648+05'),
	(151, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-163550-PO6J is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-163251-9WLW is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-163550-PO6J
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:36:51.494895+05', '2026-11-03 17:35:50.802417+05', '2026-11-03 17:36:50.127355+05'),
	(152, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-163850-O2CW is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-163550-PO6J is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-163850-O2CW
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:39:51.411852+05', '2026-11-03 17:38:50.924213+05', '2026-11-03 17:39:50.138686+05'),
	(153, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-164150-LU10 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-163850-O2CW is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-164150-LU10
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:42:51.517605+05', '2026-11-03 17:41:50.924266+05', '2026-11-03 17:42:50.129294+05'),
	(154, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-164450-CFSS is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-164150-LU10 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-164450-CFSS
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:45:51.495466+05', '2026-11-03 17:44:50.793726+05', '2026-11-03 17:45:50.130272+05'),
	(155, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-164750-59A8 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-164450-CFSS is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-164750-59A8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:48:51.601535+05', '2026-11-03 17:47:50.793455+05', '2026-11-03 17:48:50.13264+05'),
	(156, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-165050-MV5A is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-164750-59A8 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-165050-MV5A
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:51:51.415852+05', '2026-11-03 17:50:50.948418+05', '2026-11-03 17:51:50.126838+05'),
	(157, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-165350-9DK0 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-165050-MV5A is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-165350-9DK0
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:54:51.414741+05', '2026-11-03 17:53:50.969009+05', '2026-11-03 17:54:50.127814+05'),
	(158, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-165650-V37C is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-165350-9DK0 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-165650-V37C
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 17:57:51.521781+05', '2026-11-03 17:56:50.90706+05', '2026-11-03 17:57:50.136344+05'),
	(159, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-165950-NOCE is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-165650-V37C is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-165950-NOCE
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:00:51.473001+05', '2026-11-03 17:59:50.880132+05', '2026-11-03 18:00:50.134804+05'),
	(160, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-170250-A06W is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-165950-NOCE is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-170250-A06W
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:03:51.140503+05', '2026-11-03 18:02:50.941786+05', '2026-11-03 18:03:50.132864+05'),
	(161, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-170851-YSQ3 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-170250-A06W is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-170851-YSQ3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:09:51.049083+05', '2026-11-03 18:08:51.055449+05', '2026-11-03 18:09:50.131441+05'),
	(162, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-171150-V79A is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-170851-YSQ3 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-171150-V79A
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:12:51.026984+05', '2026-11-03 18:11:50.925757+05', '2026-11-03 18:12:50.125934+05'),
	(163, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-171451-3HIU is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-171150-V79A is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-171451-3HIU
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:15:51.035708+05', '2026-11-03 18:14:51.641002+05', '2026-11-03 18:15:50.12852+05'),
	(164, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-171751-M0ER is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-171451-3HIU is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-171751-M0ER
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:18:51.481747+05', '2026-11-03 18:17:51.023242+05', '2026-11-03 18:18:50.134402+05'),
	(165, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-172050-3823 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-171751-M0ER is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-172050-3823
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:21:51.015205+05', '2026-11-03 18:20:50.993411+05', '2026-11-03 18:21:50.129735+05'),
	(166, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-172351-3TJY is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-172050-3823 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-172351-3TJY
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:24:50.99565+05', '2026-11-03 18:23:51.033417+05', '2026-11-03 18:24:50.134198+05'),
	(167, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-172651-EE0Z is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-172351-3TJY is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-172651-EE0Z
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:27:51.071628+05', '2026-11-03 18:26:51.31707+05', '2026-11-03 18:27:50.134266+05'),
	(168, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-172950-YSIC is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-172651-EE0Z is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-172950-YSIC
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:30:51.716322+05', '2026-11-03 18:29:50.929492+05', '2026-11-03 18:30:50.127581+05'),
	(169, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-173250-RJJK is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-172950-YSIC is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-173250-RJJK
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:33:51.034498+05', '2026-11-03 18:32:50.983508+05', '2026-11-03 18:33:50.134226+05'),
	(170, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-173551-6MIL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-173250-RJJK is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-173551-6MIL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:36:51.010403+05', '2026-11-03 18:35:51.278457+05', '2026-11-03 18:36:50.132615+05'),
	(171, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-173851-AFJB is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-173551-6MIL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-173851-AFJB
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:39:51.040335+05', '2026-11-03 18:38:51.144592+05', '2026-11-03 18:39:50.133501+05'),
	(172, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-174150-GXBL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-173851-AFJB is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-174150-GXBL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:42:51.408298+05', '2026-11-03 18:41:50.914021+05', '2026-11-03 18:42:50.131145+05'),
	(173, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-174450-4YJG is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-174150-GXBL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-174450-4YJG
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:45:51.445131+05', '2026-11-03 18:44:50.925816+05', '2026-11-03 18:45:50.135032+05'),
	(174, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-174750-EONV is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-174450-4YJG is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-174750-EONV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:48:51.373543+05', '2026-11-03 18:47:50.869345+05', '2026-11-03 18:48:50.135677+05'),
	(175, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-175051-G4ZZ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-174750-EONV is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-175051-G4ZZ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:51:51.389981+05', '2026-11-03 18:50:51.034844+05', '2026-11-03 18:51:50.133384+05'),
	(176, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-175351-HNOY is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-175051-G4ZZ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-175351-HNOY
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:54:51.543998+05', '2026-11-03 18:53:51.105739+05', '2026-11-03 18:54:50.127541+05'),
	(177, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-175651-OU5X is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-175351-HNOY is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-175651-OU5X
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 18:57:54.917353+05', '2026-11-03 18:56:51.347236+05', '2026-11-03 18:57:50.131038+05'),
	(178, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-175950-L7RC is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-175651-OU5X is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-175950-L7RC
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:00:51.994258+05', '2026-11-03 18:59:50.856081+05', '2026-11-03 19:00:50.126172+05'),
	(179, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-180251-IJ9U is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-175950-L7RC is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-180251-IJ9U
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:03:51.450256+05', '2026-11-03 19:02:51.088647+05', '2026-11-03 19:03:50.137586+05'),
	(180, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-180550-MKBP is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-180251-IJ9U is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-180550-MKBP
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:06:51.527908+05', '2026-11-03 19:05:50.962606+05', '2026-11-03 19:06:50.13918+05'),
	(181, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-180850-CO10 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-180550-MKBP is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-180850-CO10
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:09:51.794544+05', '2026-11-03 19:08:50.791356+05', '2026-11-03 19:09:50.134748+05'),
	(182, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-181151-NYY1 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-180850-CO10 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-181151-NYY1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:12:51.007079+05', '2026-11-03 19:11:51.581516+05', '2026-11-03 19:12:50.131512+05'),
	(183, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-181451-0KBS is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-181151-NYY1 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-181451-0KBS
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:15:51.083986+05', '2026-11-03 19:14:51.55404+05', '2026-11-03 19:15:50.126659+05'),
	(184, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-181751-445C is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-181451-0KBS is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-181751-445C
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:18:51.167682+05', '2026-11-03 19:17:51.169628+05', '2026-11-03 19:18:50.125183+05'),
	(185, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-182051-RYWV is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-181751-445C is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-182051-RYWV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:21:51.267779+05', '2026-11-03 19:20:51.186391+05', '2026-11-03 19:21:50.137974+05'),
	(186, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-182350-407P is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-182051-RYWV is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-182350-407P
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:24:51.069846+05', '2026-11-03 19:23:50.964098+05', '2026-11-03 19:24:50.135209+05'),
	(187, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-182650-9C10 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-182350-407P is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-182650-9C10
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:27:51.436106+05', '2026-11-03 19:26:50.881532+05', '2026-11-03 19:27:50.130394+05'),
	(188, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-182950-ZQP3 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-182650-9C10 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-182950-ZQP3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:30:51.513942+05', '2026-11-03 19:29:50.924971+05', '2026-11-03 19:30:50.137942+05'),
	(189, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-183250-PPKG is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-182950-ZQP3 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-183250-PPKG
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:33:51.450076+05', '2026-11-03 19:32:50.96379+05', '2026-11-03 19:33:50.128579+05'),
	(190, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-183551-5K01 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-183250-PPKG is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-183551-5K01
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:36:51.419164+05', '2026-11-03 19:35:51.314911+05', '2026-11-03 19:36:50.13731+05'),
	(191, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-183850-PIBL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-183551-5K01 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-183850-PIBL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:39:51.552347+05', '2026-11-03 19:38:50.95671+05', '2026-11-03 19:39:50.136833+05'),
	(192, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-184150-SPWG is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-183850-PIBL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-184150-SPWG
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:42:51.527521+05', '2026-11-03 19:41:50.876254+05', '2026-11-03 19:42:50.133264+05'),
	(193, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-184450-MHN6 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-184150-SPWG is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-184450-MHN6
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:45:51.648682+05', '2026-11-03 19:44:50.842906+05', '2026-11-03 19:45:50.139251+05'),
	(194, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-184751-M267 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-184450-MHN6 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-184751-M267
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:48:51.528111+05', '2026-11-03 19:47:51.154225+05', '2026-11-03 19:48:50.138613+05'),
	(195, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-185050-H4BP is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-184751-M267 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-185050-H4BP
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:51:51.495929+05', '2026-11-03 19:50:50.920594+05', '2026-11-03 19:51:50.124535+05'),
	(196, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-185350-TGQ2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-185050-H4BP is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-185350-TGQ2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:54:51.427465+05', '2026-11-03 19:53:50.804076+05', '2026-11-03 19:54:50.129854+05'),
	(197, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-185651-9B80 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-185350-TGQ2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-185651-9B80
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 19:57:51.630876+05', '2026-11-03 19:56:51.033905+05', '2026-11-03 19:57:50.126576+05'),
	(198, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-185950-8JJ2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-185651-9B80 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-185950-8JJ2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:00:51.407924+05', '2026-11-03 19:59:50.885298+05', '2026-11-03 20:00:50.124762+05'),
	(199, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-190251-77CI is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-185950-8JJ2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-190251-77CI
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:03:51.409448+05', '2026-11-03 20:02:51.404815+05', '2026-11-03 20:03:50.133643+05'),
	(200, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-190550-N3BC is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-190251-77CI is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-190550-N3BC
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:06:51.59545+05', '2026-11-03 20:05:50.974109+05', '2026-11-03 20:06:50.136113+05'),
	(201, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-190851-K3TF is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-190550-N3BC is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-190851-K3TF
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:09:51.484773+05', '2026-11-03 20:08:51.357321+05', '2026-11-03 20:09:50.132442+05'),
	(202, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-192052-34Q0 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-190851-K3TF is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-192052-34Q0
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:21:51.210787+05', '2026-11-03 20:20:52.105482+05', '2026-11-03 20:21:50.138581+05'),
	(203, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-192351-AD4E is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-192052-34Q0 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-192351-AD4E
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:24:51.056503+05', '2026-11-03 20:23:51.628439+05', '2026-11-03 20:24:50.126205+05'),
	(204, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-192651-SXEP is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-192351-AD4E is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-192651-SXEP
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 20:27:51.168725+05', '2026-11-03 20:26:51.423078+05', '2026-11-03 20:27:50.133516+05'),
	(205, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-205653-WFQ5 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-192651-SXEP is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-205653-WFQ5
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 21:57:51.00121+05', '2026-11-03 21:56:53.818419+05', '2026-11-03 21:57:50.131344+05'),
	(206, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-205951-34YO is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-205653-WFQ5 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-205951-34YO
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:00:51.054518+05', '2026-11-03 21:59:51.362901+05', '2026-11-03 22:00:50.128242+05'),
	(207, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-210250-37XZ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-205951-34YO is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-210250-37XZ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:03:51.439375+05', '2026-11-03 22:02:50.854032+05', '2026-11-03 22:03:50.128712+05'),
	(208, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-210550-KOPN is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-210250-37XZ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-210550-KOPN
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:07:01.036311+05', '2026-11-03 22:05:50.987387+05', '2026-11-03 22:06:50.124522+05'),
	(209, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-210850-QU85 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-210550-KOPN is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-210850-QU85
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:09:51.595639+05', '2026-11-03 22:08:50.931663+05', '2026-11-03 22:09:50.136942+05'),
	(210, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-211151-WHN8 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-210850-QU85 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-211151-WHN8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:12:51.417869+05', '2026-11-03 22:11:51.006356+05', '2026-11-03 22:12:50.124837+05'),
	(211, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-211452-KSR9 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-211151-WHN8 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-211452-KSR9
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:15:51.944649+05', '2026-11-03 22:14:52.170405+05', '2026-11-03 22:15:50.130433+05'),
	(212, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-211752-TS66 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-211452-KSR9 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-211752-TS66
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:18:51.464935+05', '2026-11-03 22:17:52.701388+05', '2026-11-03 22:18:50.137419+05'),
	(213, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-212051-6JQ0 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-211752-TS66 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-212051-6JQ0
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:21:51.547315+05', '2026-11-03 22:20:51.880037+05', '2026-11-03 22:21:50.13795+05'),
	(214, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-212351-6708 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-212051-6JQ0 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-212351-6708
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:24:51.563482+05', '2026-11-03 22:23:51.219677+05', '2026-11-03 22:24:50.128684+05'),
	(215, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-212650-ZRL3 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-212351-6708 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-212650-ZRL3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:27:51.408807+05', '2026-11-03 22:26:50.967366+05', '2026-11-03 22:27:50.130637+05'),
	(216, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-212950-0M75 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-212650-ZRL3 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-212950-0M75
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:30:51.591602+05', '2026-11-03 22:29:50.97432+05', '2026-11-03 22:30:50.133034+05'),
	(217, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-213251-MUK1 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-212950-0M75 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-213251-MUK1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:33:51.410028+05', '2026-11-03 22:32:51.001871+05', '2026-11-03 22:33:50.135587+05'),
	(218, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-213551-APAL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-213251-MUK1 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-213551-APAL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:36:51.509609+05', '2026-11-03 22:35:51.089314+05', '2026-11-03 22:36:50.127054+05'),
	(219, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-213850-YFMW is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-213551-APAL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-213850-YFMW
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:39:51.476734+05', '2026-11-03 22:38:50.774331+05', '2026-11-03 22:39:50.129117+05'),
	(220, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-214150-6172 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-213850-YFMW is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-214150-6172
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:42:51.53264+05', '2026-11-03 22:41:50.812113+05', '2026-11-03 22:42:50.136844+05'),
	(221, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-214451-EZXH is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-214150-6172 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-214451-EZXH
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:45:51.505094+05', '2026-11-03 22:44:51.286708+05', '2026-11-03 22:45:50.127668+05'),
	(222, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-214752-EB5M is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-214451-EZXH is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-214752-EB5M
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:48:51.409298+05', '2026-11-03 22:47:52.168908+05', '2026-11-03 22:48:50.128215+05'),
	(223, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-215050-TK3X is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-214752-EB5M is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-215050-TK3X
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:51:52.784577+05', '2026-11-03 22:50:50.813985+05', '2026-11-03 22:51:50.137845+05'),
	(224, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-215352-ZOJV is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-215050-TK3X is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-215352-ZOJV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:54:51.304732+05', '2026-11-03 22:53:52.047453+05', '2026-11-03 22:54:50.135029+05'),
	(225, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-215651-E6JO is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-215352-ZOJV is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-215651-E6JO
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 22:57:51.133591+05', '2026-11-03 22:56:51.294908+05', '2026-11-03 22:57:50.139768+05'),
	(226, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-215950-5IRK is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-215651-E6JO is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-215950-5IRK
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 23:00:52.077862+05', '2026-11-03 22:59:50.986217+05', '2026-11-03 23:00:50.127879+05'),
	(227, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-220251-XCSY is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-215950-5IRK is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-220251-XCSY
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 23:03:50.918234+05', '2026-11-03 23:02:51.208562+05', '2026-11-03 23:03:50.128169+05'),
	(228, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-220551-I7F8 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-220251-XCSY is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-220551-I7F8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 23:06:50.896847+05', '2026-11-03 23:05:51.057891+05', '2026-11-03 23:06:50.125128+05'),
	(229, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-220851-SOQF is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-220551-I7F8 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-220851-SOQF
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-03 23:09:51.498355+05', '2026-11-03 23:08:51.049671+05', '2026-11-03 23:09:50.130387+05'),
	(230, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261103-221151-W70H is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-220851-SOQF is being created" has been received successfully.

Ticket Tracking ID: QRY-20261103-221151-W70H
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 08:27:42.572059+05', '2026-11-03 23:11:51.387291+05', '2026-11-04 08:27:40.879784+05'),
	(231, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-072941-UHTR is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261103-221151-W70H is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-072941-UHTR
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 08:30:41.742076+05', '2026-11-04 08:29:41.530856+05', '2026-11-04 08:30:40.653074+05'),
	(232, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-093955-A6AY is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-072941-UHTR is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-093955-A6AY
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:40:54.091377+05', '2026-11-04 10:39:54.707343+05', '2026-11-04 10:40:52.976695+05'),
	(233, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-094254-9ES7 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-093955-A6AY is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-094254-9ES7
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:43:54.017781+05', '2026-11-04 10:42:54.125104+05', '2026-11-04 10:43:52.9732+05'),
	(234, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-094554-LH29 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-094254-9ES7 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-094554-LH29
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:46:53.946287+05', '2026-11-04 10:45:54.090891+05', '2026-11-04 10:46:52.975695+05'),
	(235, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-094853-O3S1 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-094554-LH29 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-094853-O3S1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:49:54.182385+05', '2026-11-04 10:48:53.990394+05', '2026-11-04 10:49:52.978178+05'),
	(236, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-095153-CL55 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-094853-O3S1 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-095153-CL55
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:51:56.663353+05', '2026-11-04 10:51:53.855315+05', '2026-11-04 10:51:54.860725+05'),
	(237, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-095453-WIP2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-095153-CL55 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-095453-WIP2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:55:54.169709+05', '2026-11-04 10:54:53.790529+05', '2026-11-04 10:55:52.979202+05'),
	(238, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-095754-2GUI is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-095453-WIP2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-095754-2GUI
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 10:58:53.963626+05', '2026-11-04 10:57:54.280796+05', '2026-11-04 10:58:52.967151+05'),
	(239, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-100053-DVEG is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-095754-2GUI is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-100053-DVEG
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:01:53.929264+05', '2026-11-04 11:00:53.856604+05', '2026-11-04 11:01:52.97519+05'),
	(240, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-100353-MAID is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-100053-DVEG is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-100353-MAID
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:04:53.782014+05', '2026-11-04 11:03:53.906271+05', '2026-11-04 11:04:52.971547+05'),
	(241, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-100654-AJTL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-100353-MAID is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-100654-AJTL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:07:54.257854+05', '2026-11-04 11:06:54.077166+05', '2026-11-04 11:07:52.978371+05'),
	(242, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-100954-5IZM is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-100654-AJTL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-100954-5IZM
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:10:54.093077+05', '2026-11-04 11:09:54.045764+05', '2026-11-04 11:10:52.977089+05'),
	(243, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-101254-JCRC is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-100954-5IZM is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-101254-JCRC
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:13:53.906814+05', '2026-11-04 11:12:54.024802+05', '2026-11-04 11:13:52.969294+05'),
	(244, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-101554-LRLK is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-101254-JCRC is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-101554-LRLK
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:16:54.04041+05', '2026-11-04 11:15:54.389908+05', '2026-11-04 11:16:52.976675+05'),
	(245, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-101854-ACI3 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-101554-LRLK is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-101854-ACI3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:19:54.171606+05', '2026-11-04 11:18:53.998435+05', '2026-11-04 11:19:52.977877+05'),
	(246, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-102154-ZJAT is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-101854-ACI3 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-102154-ZJAT
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:22:53.995287+05', '2026-11-04 11:21:54.137062+05', '2026-11-04 11:22:52.965769+05'),
	(247, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-102454-JVS5 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-102154-ZJAT is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-102454-JVS5
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:25:53.924489+05', '2026-11-04 11:24:54.102053+05', '2026-11-04 11:25:52.968882+05'),
	(248, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-103054-ZVRR is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-102454-JVS5 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-103054-ZVRR
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:31:53.844605+05', '2026-11-04 11:30:54.048077+05', '2026-11-04 11:31:52.972197+05'),
	(249, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-103353-XDBV is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-103054-ZVRR is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-103353-XDBV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:34:53.96467+05', '2026-11-04 11:33:53.979886+05', '2026-11-04 11:34:52.976932+05'),
	(250, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-103654-2ETU is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-103353-XDBV is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-103654-2ETU
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:37:53.993594+05', '2026-11-04 11:36:54.892762+05', '2026-11-04 11:37:52.968381+05'),
	(251, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-103953-8UL2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-103654-2ETU is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-103953-8UL2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:40:53.920505+05', '2026-11-04 11:39:53.841755+05', '2026-11-04 11:40:52.965676+05'),
	(252, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-104254-4INH is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-103953-8UL2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-104254-4INH
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:43:53.848256+05', '2026-11-04 11:42:54.068783+05', '2026-11-04 11:43:52.96574+05'),
	(253, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-104554-7TYC is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-104254-4INH is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-104554-7TYC
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:46:53.877542+05', '2026-11-04 11:45:54.245321+05', '2026-11-04 11:46:52.9791+05'),
	(254, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-104854-VOMV is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-104554-7TYC is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-104854-VOMV
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:49:54.010806+05', '2026-11-04 11:48:54.227864+05', '2026-11-04 11:49:52.979277+05'),
	(255, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-105154-4NDO is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-104854-VOMV is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-105154-4NDO
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:54:09.002347+05', '2026-11-04 11:51:54.102014+05', '2026-11-04 11:54:07.872167+05'),
	(256, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-105609-CVCQ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-105154-4NDO is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-105609-CVCQ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 11:59:06.397178+05', '2026-11-04 11:56:08.965925+05', '2026-11-04 11:59:05.283949+05'),
	(257, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-110805-07JB is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-105609-CVCQ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-110805-07JB
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:09:04.840639+05', '2026-11-04 12:08:05.072204+05', '2026-11-04 12:09:03.898456+05'),
	(258, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-111105-5OF6 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-110805-07JB is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-111105-5OF6
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:12:04.737518+05', '2026-11-04 12:11:05.13994+05', '2026-11-04 12:12:03.892311+05'),
	(259, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-111405-YR0R is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-111105-5OF6 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-111405-YR0R
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:15:04.73498+05', '2026-11-04 12:14:05.103352+05', '2026-11-04 12:15:03.893457+05'),
	(260, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-111709-FRJI is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-111405-YR0R is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-111709-FRJI
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:18:04.937373+05', '2026-11-04 12:17:09.855358+05', '2026-11-04 12:18:03.893446+05'),
	(261, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-112303-40W3 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-111709-FRJI is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-112303-40W3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:24:03.639741+05', '2026-11-04 12:23:03.649059+05', '2026-11-04 12:24:02.711402+05'),
	(262, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-112603-J2FQ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-112303-40W3 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-112603-J2FQ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:27:03.748568+05', '2026-11-04 12:26:03.711644+05', '2026-11-04 12:27:02.702218+05'),
	(263, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-115658-KQW6 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-112603-J2FQ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-115658-KQW6
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 12:57:58.190946+05', '2026-11-04 12:56:58.661354+05', '2026-11-04 12:57:57.170456+05'),
	(264, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-115958-D8B8 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-115658-KQW6 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-115958-D8B8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:00:58.103437+05', '2026-11-04 12:59:58.372624+05', '2026-11-04 13:00:57.174289+05'),
	(265, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-120723-6N4B is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-115958-D8B8 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-120723-6N4B
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:08:23.746949+05', '2026-11-04 13:07:23.846594+05', '2026-11-04 13:08:22.457937+05'),
	(266, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-121406-V2AU is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-120723-6N4B is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-121406-V2AU
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:15:10.987474+05', '2026-11-04 13:14:06.334808+05', '2026-11-04 13:15:05.002255+05'),
	(267, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-121925-S0D2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-121406-V2AU is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-121925-S0D2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:19:26.866425+05', '2026-11-04 13:19:25.080099+05', '2026-11-04 13:19:25.179138+05'),
	(268, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-122852-HZFP is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-121925-S0D2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-122852-HZFP
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:29:52.971148+05', '2026-11-04 13:28:52.71623+05', '2026-11-04 13:29:51.671376+05'),
	(269, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-123423-VPI8 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-122852-HZFP is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-123423-VPI8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:35:23.319751+05', '2026-11-04 13:34:23.336454+05', '2026-11-04 13:35:22.230194+05'),
	(270, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-123723-1TAE is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-123423-VPI8 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-123723-1TAE
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:38:23.344133+05', '2026-11-04 13:37:23.441771+05', '2026-11-04 13:38:22.24303+05'),
	(271, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-124023-4CTJ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-123723-1TAE is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-124023-4CTJ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:41:23.263818+05', '2026-11-04 13:40:23.416808+05', '2026-11-04 13:41:22.239674+05'),
	(272, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-124323-YKJ9 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-124023-4CTJ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-124323-YKJ9
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:44:23.112502+05', '2026-11-04 13:43:23.340301+05', '2026-11-04 13:44:22.239283+05'),
	(273, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-124623-DA7W is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-124323-YKJ9 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-124623-DA7W
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:47:23.159272+05', '2026-11-04 13:46:23.393226+05', '2026-11-04 13:47:22.24264+05'),
	(274, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-124923-EZY1 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-124623-DA7W is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-124923-EZY1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:49:24.751267+05', '2026-11-04 13:49:23.060799+05', '2026-11-04 13:49:23.901718+05'),
	(275, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-125258-XB5P is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-124923-EZY1 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-125258-XB5P
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:53:58.861475+05', '2026-11-04 13:52:58.424785+05', '2026-11-04 13:53:57.507096+05'),
	(276, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-125558-ZNBE is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-125258-XB5P is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-125558-ZNBE
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:56:58.377493+05', '2026-11-04 13:55:58.318435+05', '2026-11-04 13:56:57.504592+05'),
	(277, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-125858-6SDI is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-125558-ZNBE is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-125858-6SDI
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 13:59:58.380753+05', '2026-11-04 13:58:58.432947+05', '2026-11-04 13:59:57.501947+05'),
	(278, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-130645-8W8A is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-125858-6SDI is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-130645-8W8A
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:07:45.308042+05', '2026-11-04 14:06:45.260666+05', '2026-11-04 14:07:44.403397+05'),
	(279, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-131519-TQN2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-130645-8W8A is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-131519-TQN2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:18:26.787393+05', '2026-11-04 14:15:19.444863+05', '2026-11-04 14:18:25.906999+05'),
	(280, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-132026-6CRW is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-131519-TQN2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-132026-6CRW
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:20:28.31164+05', '2026-11-04 14:20:26.727869+05', '2026-11-04 14:20:26.778985+05'),
	(281, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-132326-P76F is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-132026-6CRW is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-132326-P76F
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:24:26.834007+05', '2026-11-04 14:23:26.834181+05', '2026-11-04 14:24:25.906973+05'),
	(282, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-132626-Y2KL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-132326-P76F is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-132626-Y2KL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:27:26.717588+05', '2026-11-04 14:26:26.755987+05', '2026-11-04 14:27:25.907966+05'),
	(283, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-132926-QDHL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-132626-Y2KL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-132926-QDHL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:30:26.809808+05', '2026-11-04 14:29:26.768834+05', '2026-11-04 14:30:25.911129+05'),
	(284, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-133226-JCER is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-132926-QDHL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-133226-JCER
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:32:29.155686+05', '2026-11-04 14:32:26.711664+05', '2026-11-04 14:32:27.584925+05'),
	(285, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-133526-6VWY is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-133226-JCER is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-133526-6VWY
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:36:26.787443+05', '2026-11-04 14:35:26.970875+05', '2026-11-04 14:36:25.908223+05'),
	(286, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-133827-GWFL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-133526-6VWY is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-133827-GWFL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:39:26.751067+05', '2026-11-04 14:38:27.213987+05', '2026-11-04 14:39:25.907417+05'),
	(287, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-134126-H6R3 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-133827-GWFL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-134126-H6R3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:42:26.774359+05', '2026-11-04 14:41:26.809374+05', '2026-11-04 14:42:25.911201+05'),
	(288, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-134426-MZHB is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-134126-H6R3 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-134426-MZHB
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:45:26.690487+05', '2026-11-04 14:44:26.881903+05', '2026-11-04 14:45:25.907647+05'),
	(289, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-134726-CKGJ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-134426-MZHB is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-134726-CKGJ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:48:27.007337+05', '2026-11-04 14:47:26.830577+05', '2026-11-04 14:48:25.910492+05'),
	(290, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-135027-Q42L is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-134726-CKGJ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-135027-Q42L
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:51:26.687785+05', '2026-11-04 14:50:27.26238+05', '2026-11-04 14:51:25.90581+05'),
	(291, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-135326-ZBAP is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-135027-Q42L is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-135326-ZBAP
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:54:26.804422+05', '2026-11-04 14:53:26.956945+05', '2026-11-04 14:54:25.906203+05'),
	(292, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-135626-DB0V is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-135326-ZBAP is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-135626-DB0V
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 14:57:26.79431+05', '2026-11-04 14:56:26.876666+05', '2026-11-04 14:57:25.90952+05'),
	(293, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-135926-8NB2 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-135626-DB0V is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-135926-8NB2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:00:27.487642+05', '2026-11-04 14:59:26.791883+05', '2026-11-04 15:00:25.896697+05'),
	(294, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-140515-OKAZ is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-135926-8NB2 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-140515-OKAZ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:06:15.346911+05', '2026-11-04 15:05:15.57909+05', '2026-11-04 15:06:14.469635+05'),
	(295, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-140815-EKQR is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-140515-OKAZ is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-140815-EKQR
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:09:15.390365+05', '2026-11-04 15:08:15.470728+05', '2026-11-04 15:09:14.463195+05'),
	(296, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-141115-1GUO is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-140815-EKQR is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-141115-1GUO
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:12:15.348133+05', '2026-11-04 15:11:15.446923+05', '2026-11-04 15:12:14.464399+05'),
	(297, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-141415-ARCT is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-141115-1GUO is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-141415-ARCT
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:15:15.313326+05', '2026-11-04 15:14:15.301391+05', '2026-11-04 15:15:14.468967+05'),
	(298, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-141715-T93N is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-141415-ARCT is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-141715-T93N
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:18:15.371429+05', '2026-11-04 15:17:15.518504+05', '2026-11-04 15:18:14.469059+05'),
	(299, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-142015-CDFL is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-141715-T93N is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-142015-CDFL
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:21:15.366782+05', '2026-11-04 15:20:15.326818+05', '2026-11-04 15:21:14.469579+05'),
	(300, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-142315-Q3K6 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-142015-CDFL is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-142315-Q3K6
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:24:15.325595+05', '2026-11-04 15:23:15.479058+05', '2026-11-04 15:24:14.466621+05'),
	(301, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-142615-81UT is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-142315-Q3K6 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-142615-81UT
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:27:15.350484+05', '2026-11-04 15:26:15.304009+05', '2026-11-04 15:27:14.468184+05'),
	(302, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-142915-AF3R is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-142615-81UT is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-142915-AF3R
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:30:15.349128+05', '2026-11-04 15:29:15.264515+05', '2026-11-04 15:30:14.46757+05'),
	(303, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-143215-IJM7 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-142915-AF3R is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-143215-IJM7
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:33:15.508103+05', '2026-11-04 15:32:15.328644+05', '2026-11-04 15:33:14.460992+05'),
	(304, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-143515-VSVM is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-143215-IJM7 is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-143515-VSVM
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:38:17.361296+05', '2026-11-04 15:35:15.296327+05', '2026-11-04 15:38:16.403661+05'),
	(305, NULL, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261104-144018-MYA4 is being created', '
Hello,

Your ticket "Undeliverable: Ticket with tracking id: QRY-20261104-143515-VSVM is being created" has been received successfully.

Ticket Tracking ID: QRY-20261104-144018-MYA4
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-04 15:41:17.2864+05', '2026-11-04 15:40:18.084897+05', '2026-11-04 15:41:16.413455+05'),
	(306, 22, 20, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072952-CD1X', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072952-CD1X
Subject: VPN not working

Reply:
<h1 class="text-lg font-bold">sdsdsd</h1><p></p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 17:36:23.611889+05', '2026-11-05 17:35:27.154428+05', '2026-11-05 17:36:22.619718+05'),
	(307, 22, 20, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072952-CD1X', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072952-CD1X
Subject: VPN not working

Reply:
<p>Ok sir, I will check on <strong>tuesday</strong></p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 17:44:23.546096+05', '2026-11-05 17:43:42.358383+05', '2026-11-05 17:44:22.614389+05'),
	(308, 22, 20, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-072952-CD1X', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-072952-CD1X
Subject: VPN not working

Reply:
<p>Ok sir, I will check on <strong>tuesday</strong></p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 17:45:23.546832+05', '2026-11-05 17:45:20.73393+05', '2026-11-05 17:45:22.619637+05'),
	(309, 2, 321, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261105-172010-EOMQ is being created', '
Hello,

Your ticket "My VU Email Account Is Blocked" has been received successfully.

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-05 18:21:11.134817+05', '2026-11-05 18:20:10.631088+05', '2026-11-05 18:21:11.135619+05'),
	(310, 22, 321, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261105-172010-EOMQ', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Subject: My VU Email Account Is Blocked
Priority: medium
Status: pending

Please log in to the portal to review the student query.
', 'sent', 0, NULL, '2026-11-05 18:21:10.153418+05', '2026-11-05 18:20:10.631088+05', '2026-11-05 18:21:09.295119+05'),
	(311, 22, 321, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261105-172010-EOMQ', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Subject: My VU Email Account Is Blocked

Reply:
<p>Please check fast, I want to change my status to overseas student.</p><p></p><p><strong>I am waiting for swift response</strong></p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 18:26:09.818907+05', '2026-11-05 18:26:08.585247+05', '2026-11-05 18:26:08.743045+05'),
	(312, 2, 321, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261105-172010-EOMQ', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Subject: My VU Email Account Is Blocked

Reply:
<p>Dear Student,</p><p><br>Please email on the&nbsp;<a target="_blank" rel="noopener noreferrer nofollow" href="mailto:ghulam.haider@vu.edu.pk"><strong>ghulam.haider@vu.edu.pk</strong></a> to update the email or create a ticket to the student profile under the <em>registrar office section</em> then you will be able to change the password.</p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 18:32:09.809128+05', '2026-11-05 18:32:07.093835+05', '2026-11-05 18:32:08.748417+05'),
	(313, 2, 321, 'status_changed', 'email', 'Ticket QRY-20261105-172010-EOMQ Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Subject: My VU Email Account Is Blocked

Previous Status: pending
New Status: closed

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-05 18:34:09.644716+05', '2026-11-05 18:32:28.200617+05', '2026-11-05 18:34:08.74965+05'),
	(314, 2, 321, 'status_changed', 'email', 'Ticket QRY-20261105-172010-EOMQ Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Subject: My VU Email Account Is Blocked

Previous Status: pending
New Status: resolved

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-05 19:49:14.189897+05', '2026-11-05 19:48:44.514894+05', '2026-11-05 19:49:13.323427+05'),
	(315, 2, 321, 'status_changed', 'email', 'Ticket QRY-20261105-172010-EOMQ Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261105-172010-EOMQ
Subject: My VU Email Account Is Blocked

Previous Status: resolved
New Status: closed

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-05 19:49:15.226134+05', '2026-11-05 19:48:59.704841+05', '2026-11-05 19:49:15.226958+05'),
	(316, 19, 17, 'status_changed', 'email', 'Ticket QRY-20260902-070537-JX0F Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260902-070537-JX0F
Subject: Wrong Online Portal

Previous Status: open
New Status: pending

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-05 19:53:13.730147+05', '2026-11-05 19:52:33.930867+05', '2026-11-05 19:53:12.824582+05'),
	(317, 22, 17, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-070537-JX0F', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-070537-JX0F
Subject: Wrong Online Portal

Reply:
<blockquote><h1 class="text-lg font-bold">I am stilling waiting</h1></blockquote><p></p><p></p><p></p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 19:56:13.92746+05', '2026-11-05 19:55:19.037991+05', '2026-11-05 19:56:12.831825+05'),
	(318, 19, 17, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-070537-JX0F', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-070537-JX0F
Subject: Wrong Online Portal

Reply:
<p>OK, we are looking into it</p>

Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 19:57:13.840092+05', '2026-11-05 19:57:05.948202+05', '2026-11-05 19:57:12.83218+05'),
	(319, 19, 17, 'status_changed', 'email', 'Ticket QRY-20260902-070537-JX0F Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260902-070537-JX0F
Subject: Wrong Online Portal

Previous Status: pending
New Status: closed

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-05 19:58:14.145606+05', '2026-11-05 19:57:23.303109+05', '2026-11-05 19:58:13.293259+05'),
	(320, 19, 17, 'status_changed', 'email', 'Ticket QRY-20260902-070537-JX0F Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260902-070537-JX0F
Subject: Wrong Online Portal

Previous Status: closed
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-05 19:58:15.291635+05', '2026-11-05 19:57:56.835675+05', '2026-11-05 19:58:15.292381+05'),
	(321, 22, 25, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-101757-HHDU', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-101757-HHDU
Subject: my wifi is down


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-05 20:08:32.87283+05', '2026-11-05 20:08:08.473622+05', '2026-11-05 20:08:31.782046+05'),
	(322, 2, 322, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-134709-YDF2 is being created', '
Hello,

Your ticket "official enrollment veritification" has been received successfully.

Ticket Tracking ID: QRY-20261107-134709-YDF2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 15:16:34.146634+05', '2026-11-07 14:47:09.00851+05', '2026-11-07 15:16:33.259412+05'),
	(328, 2, 328, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-140239-0MY1 is being created', '
Hello,

Your ticket "university honor''s program" has been received successfully.

Ticket Tracking ID: QRY-20261107-140239-0MY1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 15:16:34.96131+05', '2026-11-07 15:02:39.750572+05', '2026-11-07 15:16:34.962485+05'),
	(329, 2, 329, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-140543-685V is being created', '
Hello,

Your ticket "university honor''s program" has been received successfully.

Ticket Tracking ID: QRY-20261107-140543-685V
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 15:16:35.760031+05', '2026-11-07 15:05:43.174743+05', '2026-11-07 15:16:35.760602+05'),
	(330, 2, 330, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-140716-J9PD is being created', '
Hello,

Your ticket "university honor''s program" has been received successfully.

Ticket Tracking ID: QRY-20261107-140716-J9PD
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 15:16:36.520764+05', '2026-11-07 15:07:16.28398+05', '2026-11-07 15:16:36.521341+05'),
	(331, 2, 331, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-141038-83SH is being created', '
Hello,

Your ticket "wrong mail address" has been received successfully.

Ticket Tracking ID: QRY-20261107-141038-83SH
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 15:16:37.415214+05', '2026-11-07 15:10:38.639016+05', '2026-11-07 15:16:37.415886+05'),
	(332, 2, 332, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-182918-IMYJ is being created', '
Hello,

Your ticket "Wrong termination warning" has been received successfully.

Ticket Tracking ID: QRY-20261107-182918-IMYJ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 19:39:06.576675+05', '2026-11-07 19:29:18.211395+05', '2026-11-07 19:39:05.628536+05'),
	(333, 2, 333, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261107-183153-LHPE is being created', '
Hello,

Your ticket "Booking group study room" has been received successfully.

Ticket Tracking ID: QRY-20261107-183153-LHPE
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-07 19:39:07.381905+05', '2026-11-07 19:31:53.920319+05', '2026-11-07 19:39:07.382471+05'),
	(334, 19, 334, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-121613-VF3T is being created', '
Hello,

Your ticket "Student Scholarship" has been received successfully.

Ticket Tracking ID: QRY-20261112-121613-VF3T
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:16:13.002353+05', '2026-11-12 13:16:13.002353+05'),
	(335, 19, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-121951-AA97 is being created', '
Hello,

Your ticket "Student Scholarship" has been received successfully.

Ticket Tracking ID: QRY-20261112-121951-AA97
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:19:51.359092+05', '2026-11-12 13:19:51.359092+05'),
	(336, 19, 336, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-122959-5P2X is being created', '
Hello,

Your ticket "Weak Wi-Fi Signals" has been received successfully.

Ticket Tracking ID: QRY-20261112-122959-5P2X
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:29:59.916178+05', '2026-11-12 13:29:59.916178+05'),
	(337, 22, 336, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261112-122959-5P2X', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261112-122959-5P2X
Subject: Weak Wi-Fi Signals
Priority: medium
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, NULL, '2026-11-12 13:29:59.916178+05', '2026-11-12 13:29:59.916178+05'),
	(338, 19, 337, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-123304-JY5P is being created', '
Hello,

Your ticket "I got a serious issue and need to be fix quickly" has been received successfully.

Ticket Tracking ID: QRY-20261112-123304-JY5P
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:33:04.06163+05', '2026-11-12 13:33:04.06163+05'),
	(339, 19, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-123706-O56R is being created', '
Hello,

Your ticket "Student Issue Please fix it" has been received successfully.

Ticket Tracking ID: QRY-20261112-123706-O56R
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:37:06.162779+05', '2026-11-12 13:37:06.162779+05'),
	(340, 19, 339, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-124251-ANO7 is being created', '
Hello,

Your ticket "My Tuition Refund is • "Delayed Again"!!" has been received successfully.

Ticket Tracking ID: QRY-20261112-124251-ANO7
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:42:51.248692+05', '2026-11-12 13:42:51.248692+05'),
	(341, 19, 340, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-124555-HIW1 is being created', '
Hello,

Your ticket "Copy of University Policy" has been received successfully.

Ticket Tracking ID: QRY-20261112-124555-HIW1
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:45:55.865638+05', '2026-11-12 13:45:55.865638+05'),
	(342, 19, 341, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-124848-P17X is being created', '
Hello,

Your ticket "University Policy about Internship" has been received successfully.

Ticket Tracking ID: QRY-20261112-124848-P17X
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:48:48.376659+05', '2026-11-12 13:48:48.376659+05'),
	(343, 19, 342, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-125040-W4XX is being created', '
Hello,

Your ticket "Tuition Payment Issue" has been received successfully.

Ticket Tracking ID: QRY-20261112-125040-W4XX
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:50:40.959993+05', '2026-11-12 13:50:40.959993+05'),
	(344, 19, 343, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-125144-PDG8 is being created', '
Hello,

Your ticket "Login for Immigration Portal" has been received successfully.

Ticket Tracking ID: QRY-20261112-125144-PDG8
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:51:44.54795+05', '2026-11-12 13:51:44.54795+05'),
	(345, 19, 344, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-125228-9T82 is being created', '
Hello,

Your ticket "Problem with online application" has been received successfully.

Ticket Tracking ID: QRY-20261112-125228-9T82
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:52:28.111994+05', '2026-11-12 13:52:28.111994+05'),
	(346, 19, 345, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-125311-4QD3 is being created', '
Hello,

Your ticket "Issue with Library Server" has been received successfully.

Ticket Tracking ID: QRY-20261112-125311-4QD3
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:53:11.394977+05', '2026-11-12 13:53:11.394977+05'),
	(347, 19, 346, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-125416-DGUQ is being created', '
Hello,

Your ticket "Policy for bringing animal" has been received successfully.

Ticket Tracking ID: QRY-20261112-125416-DGUQ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 13:54:16.900187+05', '2026-11-12 13:54:16.900187+05'),
	(348, 19, 347, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-130319-RNZ4 is being created', '
Hello,

Your ticket "Issue regarding my account" has been received successfully.

Ticket Tracking ID: QRY-20261112-130319-RNZ4
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 14:03:19.030507+05', '2026-11-12 14:03:19.030507+05'),
	(349, 22, 347, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261112-130319-RNZ4', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261112-130319-RNZ4
Subject: Issue regarding my account
Priority: medium
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, NULL, '2026-11-12 14:03:19.030507+05', '2026-11-12 14:03:19.030507+05'),
	(350, 19, 348, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261112-131047-XN14 is being created', '
Hello,

Your ticket "No MFA Code is received" has been received successfully.

Ticket Tracking ID: QRY-20261112-131047-XN14
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-12 14:10:47.221046+05', '2026-11-12 14:10:47.221046+05'),
	(351, 22, 348, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261112-131047-XN14', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261112-131047-XN14
Subject: No MFA Code is received
Priority: high
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, NULL, '2026-11-12 14:10:47.221046+05', '2026-11-12 14:10:47.221046+05'),
	(352, 19, 67, 'status_changed', 'email', 'Ticket QRY-20260919-130433-3YTE Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260919-130433-3YTE
Subject: Issue with finance

Previous Status: in_progress
New Status: resolved

Please log into the portal for more information.
', 'sent', 0, NULL, NULL, '2026-11-12 14:56:39.670544+05', '2026-11-12 14:56:39.670544+05'),
	(353, 19, 19, 'status_changed', 'email', 'Ticket QRY-20260902-072812-MX7K Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260902-072812-MX7K
Subject: Transfer to wrong school account

Previous Status: pending
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, NULL, '2026-11-12 15:04:21.491492+05', '2026-11-12 15:04:21.491492+05'),
	(354, 19, 19, 'status_changed', 'email', 'Ticket QRY-20260902-072812-MX7K Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260902-072812-MX7K
Subject: Transfer to wrong school account

Previous Status: in_progress
New Status: assigned

Please log into the portal for more information.
', 'sent', 0, NULL, NULL, '2026-11-12 15:04:36.994335+05', '2026-11-12 15:04:36.994335+05'),
	(355, 19, 348, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261112-131047-XN14', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261112-131047-XN14
Subject: No MFA Code is received


Please log into the portal for complete details.
', 'sent', 0, NULL, NULL, '2026-11-12 15:18:36.813418+05', '2026-11-12 15:18:36.813418+05'),
	(356, 19, 336, 'status_changed', 'email', 'Ticket QRY-20261112-122959-5P2X Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261112-122959-5P2X
Subject: Weak Wi-Fi Signals

Previous Status: pending
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, NULL, '2026-11-12 18:15:39.868059+05', '2026-11-12 18:15:39.868059+05'),
	(357, 19, 336, 'status_changed', 'email', 'Ticket QRY-20261112-122959-5P2X Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261112-122959-5P2X
Subject: Weak Wi-Fi Signals

Previous Status: in_progress
New Status: resolved

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-13 16:29:50.446732+05', '2026-11-12 18:16:16.100486+05', '2026-11-13 16:29:49.545913+05'),
	(358, 2, 25, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-101757-HHDU', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-101757-HHDU
Subject: my wifi is down


Please log into the portal for complete details.
', 'sent', 0, NULL, NULL, '2026-11-12 18:35:02.771877+05', '2026-11-12 18:35:02.771877+05'),
	(359, 2, 25, 'new_reply', 'email', 'New Reply - Ticket #QRY-20260902-101757-HHDU', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20260902-101757-HHDU
Subject: my wifi is down


Please log into the portal for complete details.
', 'sent', 0, NULL, NULL, '2026-11-12 18:42:04.424574+05', '2026-11-12 18:42:04.424574+05'),
	(360, 2, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-133414-2L3E is being created', '
Hello,

Your ticket "The problem is keep on coming" has been received successfully.

Ticket Tracking ID: QRY-20261113-133414-2L3E
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-13 14:34:14.287163+05', '2026-11-13 14:34:14.287163+05'),
	(361, 2, 350, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-143125-VBUZ is being created', '
Hello,

Your ticket "Roommate is smoking " has been received successfully.

Ticket Tracking ID: QRY-20261113-143125-VBUZ
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-13 15:31:25.937972+05', '2026-11-13 15:31:25.937972+05'),
	(362, 2, NULL, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-144839-3GLF is being created', '
Hello,

Your ticket "Testing XSS vulnerability in ticket description" has been received successfully.

Ticket Tracking ID: QRY-20261113-144839-3GLF
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, NULL, '2026-11-13 15:48:39.362191+05', '2026-11-13 15:48:39.362191+05'),
	(363, NULL, 352, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-152257-UGNB is being created', '
Hello,

Your ticket "You shared some Google Account data with FastEmailAutomation" has been received successfully.

Ticket Tracking ID: QRY-20261113-152257-UGNB
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-13 16:29:51.245205+05', '2026-11-13 16:22:57.143514+05', '2026-11-13 16:29:51.246329+05'),
	(364, 22, 352, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261113-152257-UGNB', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261113-152257-UGNB
Subject: You shared some Google Account data with FastEmailAutomation
Priority: low
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-13 16:29:52.119238+05', '2026-11-13 16:22:57.143514+05', '2026-11-13 16:29:52.120057+05'),
	(365, 1, 333, 'escalated', 'email', 'Escalated Ticket No. QRY-20261107-183153-LHPE', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20261107-183153-LHPE
Subject: Booking group study room
Priority: Low

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-11-13 16:39:50.416335+05', '2026-11-13 16:34:50.008538+05', '2026-11-13 16:39:49.537337+05'),
	(366, 4, 334, 'escalated', 'email', 'Escalated Ticket No. QRY-20261112-121613-VF3T', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20261112-121613-VF3T
Subject: Student Scholarship
Priority: Low

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-11-13 16:39:51.17995+05', '2026-11-13 16:34:50.008538+05', '2026-11-13 16:39:51.180955+05'),
	(367, 4, 339, 'escalated', 'email', 'Escalated Ticket No. QRY-20261112-124251-ANO7', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20261112-124251-ANO7
Subject: My Tuition Refund is • "Delayed Again"!!
Priority: High

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-11-13 16:39:52.053333+05', '2026-11-13 16:34:50.008538+05', '2026-11-13 16:39:52.053941+05'),
	(368, 4, 342, 'escalated', 'email', 'Escalated Ticket No. QRY-20261112-125040-W4XX', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20261112-125040-W4XX
Subject: Tuition Payment Issue
Priority: High

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-11-13 16:39:53.020325+05', '2026-11-13 16:34:50.008538+05', '2026-11-13 16:39:53.021097+05'),
	(369, 1, 345, 'escalated', 'email', 'Escalated Ticket No. QRY-20261112-125311-4QD3', '
A student query has been escalated to you.

Ticket Tracking ID: QRY-20261112-125311-4QD3
Subject: Issue with Library Server
Priority: High

The ticket was not solved within the required time period.

Please review it from your dashboard.
', 'sent', 0, NULL, '2026-11-13 16:39:53.924698+05', '2026-11-13 16:34:50.008538+05', '2026-11-13 16:39:53.925529+05'),
	(370, 19, 353, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-154518-RQI0 is being created', '
Hello,

Your ticket "Wrongly send tuition fees" has been received successfully.

Ticket Tracking ID: QRY-20261113-154518-RQI0
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-13 16:49:50.845266+05', '2026-11-13 16:45:18.855292+05', '2026-11-13 16:49:50.015084+05'),
	(371, 3, 353, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261113-154518-RQI0', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261113-154518-RQI0
Subject: Wrongly send tuition fees
Priority: high
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-13 16:49:51.672105+05', '2026-11-13 16:45:18.855292+05', '2026-11-13 16:49:51.672759+05'),
	(372, 19, 353, 'status_changed', 'email', 'Ticket QRY-20261113-154518-RQI0 Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261113-154518-RQI0
Subject: Wrongly send tuition fees

Previous Status: pending
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-13 16:59:50.331859+05', '2026-11-13 16:57:16.256174+05', '2026-11-13 16:59:49.510812+05'),
	(373, 19, 353, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261113-154518-RQI0', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261113-154518-RQI0
Subject: Wrongly send tuition fees


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-13 16:59:51.073635+05', '2026-11-13 16:57:54.865412+05', '2026-11-13 16:59:51.074279+05'),
	(374, 19, 354, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-162250-YTW6 is being created', '
Hello,

Your ticket "Financial Aid Package Status" has been received successfully.

Ticket Tracking ID: QRY-20261113-162250-YTW6
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-13 19:07:03.283628+05', '2026-11-13 17:22:50.317407+05', '2026-11-13 19:07:02.103463+05'),
	(375, 3, 354, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261113-162250-YTW6', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261113-162250-YTW6
Subject: Financial Aid Package Status
Priority: low
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-13 19:07:04.122397+05', '2026-11-13 17:22:50.317407+05', '2026-11-13 19:07:04.123043+05'),
	(376, 19, 355, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261113-180025-2F1D is being created', '
Hello,

Your ticket "Issue in my dorm" has been received successfully.

Ticket Tracking ID: QRY-20261113-180025-2F1D
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-13 19:07:04.9296+05', '2026-11-13 19:00:25.016004+05', '2026-11-13 19:07:04.930169+05'),
	(377, 19, 354, 'status_changed', 'email', 'Ticket QRY-20261113-162250-YTW6 Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261113-162250-YTW6
Subject: Financial Aid Package Status

Previous Status: pending
New Status: in_progress

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-13 20:02:03.54885+05', '2026-11-13 19:58:57.733331+05', '2026-11-13 20:02:02.774785+05'),
	(378, 19, 354, 'status_changed', 'email', 'Ticket QRY-20261113-162250-YTW6 Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261113-162250-YTW6
Subject: Financial Aid Package Status

Previous Status: in_progress
New Status: QueryStatusEnum.ASSIGNED

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-13 20:27:15.901954+05', '2026-11-13 20:22:20.802705+05', '2026-11-13 20:27:14.998036+05'),
	(379, 19, 354, 'status_changed', 'email', 'Ticket QRY-20261113-162250-YTW6 Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261113-162250-YTW6
Subject: Financial Aid Package Status

Previous Status: assigned
New Status: QueryStatusEnum.ESCALATED

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-13 20:27:16.954041+05', '2026-11-13 20:22:33.975674+05', '2026-11-13 20:27:16.95483+05'),
	(380, 19, 354, 'status_changed', 'email', 'Ticket QRY-20261113-162250-YTW6 Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261113-162250-YTW6
Subject: Financial Aid Package Status

Previous Status: escalated
New Status: QueryStatusEnum.RESOLVED

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-13 20:27:17.961584+05', '2026-11-13 20:22:40.523063+05', '2026-11-13 20:27:17.962201+05'),
	(381, 19, 353, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261113-154518-RQI0', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261113-154518-RQI0
Subject: Wrongly send tuition fees


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-13 21:07:08.442766+05', '2026-11-13 21:02:42.414102+05', '2026-11-13 21:07:07.581529+05'),
	(382, 19, 354, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261113-162250-YTW6', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261113-162250-YTW6
Subject: Financial Aid Package Status


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-13 21:48:54.987105+05', '2026-11-13 21:23:31.336858+05', '2026-11-13 21:48:54.01059+05'),
	(383, 19, 353, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261113-154518-RQI0', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261113-154518-RQI0
Subject: Wrongly send tuition fees


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-13 21:48:56.794653+05', '2026-11-13 21:26:30.122553+05', '2026-11-13 21:48:56.795271+05'),
	(384, 19, 353, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261113-154518-RQI0', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261113-154518-RQI0
Subject: Wrongly send tuition fees


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-13 21:48:55.8679+05', '2026-11-13 21:27:52.013362+05', '2026-11-13 21:48:55.868563+05'),
	(385, 4, 2, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260829-164128-YVRY', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260829-164128-YVRY
Subject: tuition payment issue
Priority: medium
Status: escalated

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-14 09:57:55.102063+05', '2026-11-14 09:18:27.000885+05', '2026-11-14 09:57:54.140444+05'),
	(386, 3, 2, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260829-164128-YVRY', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260829-164128-YVRY
Subject: tuition payment issue
Priority: medium
Status: escalated

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-14 09:57:57.047653+05', '2026-11-14 09:19:58.097021+05', '2026-11-14 09:57:57.04896+05'),
	(387, 4, 2, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20260829-164128-YVRY', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20260829-164128-YVRY
Subject: tuition payment issue
Priority: medium
Status: escalated

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-14 09:57:56.025723+05', '2026-11-14 09:21:30.240293+05', '2026-11-14 09:57:56.026842+05'),
	(388, 2, 2, 'status_changed', 'email', 'Ticket QRY-20260829-164128-YVRY Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260829-164128-YVRY
Subject: tuition payment issue

Previous Status: escalated
New Status: QueryStatusEnum.CLOSED

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-14 09:57:57.933717+05', '2026-11-14 09:21:35.602688+05', '2026-11-14 09:57:57.934685+05'),
	(389, 19, 18, 'status_changed', 'email', 'Ticket QRY-20260902-071538-ZF5U Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20260902-071538-ZF5U
Subject: Late Fees Issue

Previous Status: pending
New Status: QueryStatusEnum.CLOSED

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-14 09:57:58.778197+05', '2026-11-14 09:33:33.815605+05', '2026-11-14 09:57:58.779127+05'),
	(390, 2, 333, 'status_changed', 'email', 'Ticket QRY-20261107-183153-LHPE Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261107-183153-LHPE
Subject: Booking group study room

Previous Status: escalated
New Status: QueryStatusEnum.RESOLVED

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-17 08:56:40.413899+05', '2026-11-17 08:37:35.319997+05', '2026-11-17 08:56:39.290001+05'),
	(391, 19, 356, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261117-075431-KAW2 is being created', '
Hello,

Your ticket "Issue with Scholarship" has been received successfully.

Ticket Tracking ID: QRY-20261117-075431-KAW2
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-17 08:56:41.544077+05', '2026-11-17 08:54:31.636843+05', '2026-11-17 08:56:41.545076+05'),
	(392, 3, 356, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261117-075431-KAW2', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261117-075431-KAW2
Subject: Issue with Scholarship
Priority: medium
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-17 08:56:42.575775+05', '2026-11-17 08:54:31.636843+05', '2026-11-17 08:56:42.57666+05'),
	(393, 19, 356, 'status_changed', 'email', 'Ticket QRY-20261117-075431-KAW2 Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261117-075431-KAW2
Subject: Issue with Scholarship

Previous Status: pending
New Status: QueryStatusEnum.IN_PROGRESS

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-17 09:11:40.980922+05', '2026-11-17 08:56:45.556109+05', '2026-11-17 09:11:39.454024+05'),
	(394, 19, 356, 'new_reply', 'email', 'New Reply - Ticket #QRY-20261117-075431-KAW2', '
A new reply has been added to your query.

Ticket Tracking ID: QRY-20261117-075431-KAW2
Subject: Issue with Scholarship


Please log into the portal for complete details.
', 'sent', 0, NULL, '2026-11-17 09:11:41.987558+05', '2026-11-17 08:58:59.086389+05', '2026-11-17 09:11:41.989778+05'),
	(395, 19, 357, 'ticket_created', 'email', 'Ticket with tracking id: QRY-20261117-083935-NVDU is being created', '
Hello,

Your ticket "Inline Assignment Submission Error" has been received successfully.

Ticket Tracking ID: QRY-20261117-083935-NVDU
Current Status: Pending

You will be notified when there is an update.

Fast Smart Querying System
', 'sent', 0, NULL, '2026-11-17 09:57:15.62368+05', '2026-11-17 09:39:35.203709+05', '2026-11-17 09:57:14.761872+05'),
	(396, 22, 357, 'ticket_assigned', 'email', 'New Ticket Assigned - #QRY-20261117-083935-NVDU', '
A new student query is being assigned to you.

Ticket Tracking ID: QRY-20261117-083935-NVDU
Subject: Inline Assignment Submission Error
Priority: high
Status: pending

Please log in to the portal to review the student query
', 'sent', 0, NULL, '2026-11-17 09:57:16.748473+05', '2026-11-17 09:39:35.203709+05', '2026-11-17 09:57:16.74975+05'),
	(397, 19, 357, 'status_changed', 'email', 'Ticket QRY-20261117-083935-NVDU Status Updated', '
The status of your ticket query is being updated

Ticket Tracking ID: QRY-20261117-083935-NVDU
Subject: Inline Assignment Submission Error

Previous Status: pending
New Status: QueryStatusEnum.IN_PROGRESS

Please log into the portal for more information.
', 'sent', 0, NULL, '2026-11-17 09:57:17.672655+05', '2026-11-17 09:44:25.024164+05', '2026-11-17 09:57:17.67414+05');

-- Dumping structure for table public.replies
CREATE TABLE IF NOT EXISTS "replies" (
	"id" SERIAL NOT NULL,
	"ticket_id" INTEGER NULL DEFAULT NULL,
	"creator_id" INTEGER NULL DEFAULT NULL,
	"is_ai_draft" SMALLINT NOT NULL DEFAULT '0',
	"text" TEXT NOT NULL,
	"status" VARCHAR NOT NULL DEFAULT 'draft',
	"send_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"is_auto_reply" SMALLINT NOT NULL DEFAULT '0',
	PRIMARY KEY ("id"),
	CONSTRAINT "replies_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "replies_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "tickets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.replies: 43 rows
DELETE FROM "replies";
INSERT INTO "replies" ("id", "ticket_id", "creator_id", "is_ai_draft", "text", "status", "send_at", "created_at", "updated_at", "is_auto_reply") VALUES
	(3, 5, 3, 1, '**Subject: Re: Incorrect Late Fees – QRY-20260831-174517-LDUT**

Dear Mr. Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office regarding the $1,000 late fee showing on your account, and for your follow-up message regarding the attachment.

To verify your early payment, please send a screenshot of your payment confirmation within the week, as previously requested. Once received, the relevant staff member will review your account along with the documentation provided and will follow up with you through this ticket.

Please note that we are unable to confirm any adjustment to the late fee until this review is complete. We appreciate your patience and understanding.

Kind regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-05 11:49:16.396999+05', '2026-09-05 11:26:25.679991+05', '2026-09-05 11:49:16.39219+05', 0),
	(4, 2, 3, 1, 'Dear Student User,

Thank you for contacting the Billing, Accounts & Finance Office (Ticket ID: QRY-20260829-164128-YVRY).

We understand your concern regarding your tuition payment showing as "rejected" despite sufficient funds being available, particularly with your graduate program registration closing tomorrow morning.

A member of our billing team will review your payment status and follow up with you as soon as possible. To assist with a timely review, please have your payment details available, such as your transaction reference number and payment confirmation, as our team may request this information.

We appreciate your patience and will be in touch shortly.

Kind regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-05 14:59:21.785821+05', '2026-09-05 14:58:04.13381+05', '2026-09-05 14:59:21.777266+05', 0),
	(5, 41, NULL, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for contacting us, and we understand your concern given your midterm is scheduled for tomorrow.

We have noted the withdrawal notification you received and your statement that you hold a full scholarship. Please be assured that this matter is being treated with high priority. A representative from the Billing, Accounts & Finance Office will review your account and scholarship status as soon as possible and follow up with you directly.

To assist with the review, we kindly ask that you reply to this ticket with any supporting documentation you have regarding your scholarship (such as an award letter or confirmation email).

We apologize for any inconvenience and appreciate your patience while we look into this urgently.

Sincerely,
Billing, Accounts & Finance Office', 'sent', '2026-09-05 16:13:05.757761+05', '2026-09-05 16:11:30.870011+05', '2026-09-05 16:13:05.751876+05', 0),
	(6, 19, 3, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for bringing this to our attention. We understand your concern, especially with the late fee deadline being today.

Please note that your report regarding the tuition transfer sent to the wrong school account has been received, and the Billing, Accounts & Finance Office will review this matter urgently.

To assist with the review, kindly provide the following details, if available:

- Bank transfer receipt or proof of payment
- Transaction reference number and date of transfer
- The account details to which the payment was sent

Once received, the relevant staff member will verify the transaction and advise you on the next steps.

Kind regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-05 16:27:46.418053+05', '2026-09-05 16:26:11.000783+05', '2026-09-05 16:27:46.411235+05', 0),
	(7, 39, 3, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office.

We have received your query regarding information about the architect who designed the finance office lobby. Unfortunately, this information is not readily available with our office. The relevant staff member will review your request and follow up with any available details, or direct you to the appropriate department that may hold this information.

We appreciate your patience.

Best regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-05 17:06:08.33445+05', '2026-09-05 17:05:38.236402+05', '2026-09-05 17:06:08.32599+05', 0),
	(8, 5, 19, 0, 'Ok sir I will submit them as soon as possible', 'sent', '2026-09-05 18:29:21.952589+05', '2026-09-05 18:29:21.846144+05', '2026-09-05 18:29:21.942388+05', 0),
	(9, 43, 19, 0, 'Thank you sir, this issue has been solved. ', 'sent', '2026-09-06 07:19:18.60671+05', '2026-09-06 07:19:18.582021+05', '2026-09-06 07:19:18.602938+05', 0),
	(10, 28, 3, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office regarding your lab fees. We have noted your concern that you were charged an amount higher than expected and your request for a refund.

Your case will be reviewed by the relevant staff member, who will verify your payment details against the applicable fee structure. If any additional information is required, such as a payment receipt or fee statement, you will be contacted.

We appreciate your patience while your query is being reviewed.

Kind regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-07 04:16:45.718873+05', '2026-09-07 04:16:05.612715+05', '2026-09-07 04:16:45.714517+05', 0),
	(11, 6, 19, 0, 'Please respond to the ticket', 'sent', '2026-09-07 04:20:38.375948+05', '2026-09-07 04:20:38.350925+05', '2026-09-07 04:20:38.372933+05', 0),
	(12, 49, 3, 1, 'Dear Tabish,

Thank you for alerting us — we understand this is an urgent situation, and we are treating it with the highest priority.

While we arrange assistance, please:

- Stay calm and keep a safe distance from the roof edges.
- Remain in a visible spot if possible, and keep your phone with you.
- If you are able, please also contact Campus Security directly by phone, as they can respond fastest to on-campus emergencies.
- If you feel you are in immediate danger, please contact local emergency services as well.

I am escalating this matter immediately to campus security and library staff so they can locate you and arrange for the door to be opened as quickly as possible.

If your situation changes in any way, please reply to this ticket or contact security again right away.

Stay safe.

Kind regards,
Officer
Library Office', 'sent', '2026-09-10 07:29:43.734933+05', '2026-09-10 07:28:22.886723+05', '2026-09-10 07:29:43.729153+05', 0),
	(13, 53, NULL, 1, 'Dear Tabish,

Walaikum Assalam.

Thank you for reaching out regarding your credit hours limit. I understand that after registering for your current semester courses, two credit hours remain unused, and you are unable to use them to select an additional course. You have also noted that you have earned 87 credit hours at the end of five semesters and have requested an increase of 1 or 3 credit hours in your limit.

Your request, along with the details of your earned credit hours, will be reviewed by the relevant staff member. They will assess your eligibility and will either update you on the outcome or request any additional information that may be required.

Thank you for your patience and understanding.

Best regards,
[Staff Name]
Department of General Administration', 'draft', NULL, '2026-09-10 10:10:16.297573+05', '2026-09-10 10:10:16.297573+05', 0),
	(14, 57, 3, 1, 'Dear Tabish Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office and for providing your bank receipt.

We understand your concern regarding the unpaid status currently showing on your LMS account and the Rs. 1,000 late fine that has been applied. Please be assured that our finance team will review your payment receipt and verify the transaction with the bank. The late fee will also be reviewed as part of this process, and any necessary updates to your account will be made once the verification is complete.

If any additional information or documentation is required, a member of our team will reach out to you. We kindly request your patience while this matter is being reviewed.

Best regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-10 14:18:47.421506+05', '2026-09-10 14:18:22.431206+05', '2026-09-10 14:18:47.405894+05', 0),
	(15, NULL, 3, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office regarding your scholarship application for first-generation students.

To assist you effectively, could you please provide more details on the specific help you require? For example, let us know whether you need guidance with starting the application, information on required documents, or an update on an application you have already submitted.

Once we receive further details, the relevant staff member will review your query and respond accordingly.

Best regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-19 00:09:15.506522+05', '2026-09-19 00:08:33.181995+05', '2026-09-19 12:45:08.579491+05', 0),
	(16, 67, 3, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office. We understand the urgency and concern caused by the eviction notice, and we have marked your case as high priority.

Please be assured that a member of our finance team will review your account to verify the status of your scholarship and whether it has been applied to your outstanding charges. Once this review is complete, we will follow up with you regarding the outcome and any next steps concerning the housing hold.

If any additional information or documentation is required from you, our team will reach out directly. In the meantime, we kindly ask for your patience while we look into this matter.

Kind regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-19 14:03:52.700612+05', '2026-09-19 14:03:15.012297+05', '2026-09-19 14:03:52.694899+05', 0),
	(17, 67, 3, 0, 'waiting for your response', 'sent', '2026-09-19 14:32:39.579915+05', '2026-09-19 14:32:39.543959+05', '2026-09-19 14:32:39.57452+05', 0),
	(18, 47, 4, 1, 'Dear Student User,

Thank you for contacting the Admissions Office. We understand the urgency of your situation, as your visa documents need to be signed ahead of your embassy appointment tomorrow afternoon.

Your request has been received and is being handled as a priority. A member of the Admissions team will review your documentation and follow up with you as soon as possible. To help avoid any delays, please ensure your visa documents have been submitted with your request; if not, kindly provide them at your earliest convenience.

Thank you for your patience.

Best regards,
Admissions Office
Reference: QRY-20260909-140005-DXE7', 'sent', '2026-09-24 17:40:47.210284+05', '2026-09-24 17:40:14.956863+05', '2026-09-24 17:40:47.197976+05', 0),
	(19, 66, 4, 1, 'Dear Tabish Sardar Ali Sajwani,

Thank you for contacting the Billing, Accounts & Finance Office regarding your semester refund.

I understand that you have been waiting for three weeks since the approval of your refund, and I apologize for any inconvenience this delay may have caused. Please be assured that your case will be reviewed by our finance team to check the current status of your refund and identify any pending steps.

We will follow up with you shortly with an update. If any additional information or documentation is required from your side, we will let you know.

Thank you for your patience.

Best regards,
Billing, Accounts & Finance Office', 'sent', '2026-09-25 19:08:10.935019+05', '2026-09-25 19:07:33.827781+05', '2026-09-25 19:08:10.925036+05', 0),
	(20, 19, 19, 0, 'sir, have you checked?', 'sent', '2026-10-10 19:05:00.839209+05', '2026-10-10 19:05:00.773918+05', '2026-10-10 19:05:00.829104+05', 0),
	(21, 19, 19, 0, 'please check now', 'sent', '2026-10-10 19:19:17.172307+05', '2026-10-10 19:19:17.133164+05', '2026-10-10 19:19:17.168826+05', 0),
	(22, 19, 19, 0, 'Sir, I am waiting', 'sent', '2026-10-11 15:53:21.569207+05', '2026-10-11 15:46:44.28635+05', '2026-10-11 15:53:21.546425+05', 0),
	(23, 19, 3, 0, 'I am currently on leave', 'sent', NULL, '2026-10-11 15:53:21.546425+05', '2026-10-11 15:53:21.546425+05', 1),
	(24, 18, 19, 0, 'any update on it sir?', 'sent', '2026-10-11 15:54:52.452453+05', '2026-10-11 15:54:52.42116+05', '2026-10-11 15:54:52.450072+05', 0),
	(25, 18, 3, 0, 'I am currently on leave', 'sent', NULL, '2026-10-11 15:54:52.450072+05', '2026-10-11 15:54:52.450072+05', 1),
	(26, 18, 19, 0, 'ok thanks', 'sent', '2026-10-11 15:56:44.427031+05', '2026-10-11 15:56:44.389283+05', '2026-10-11 15:56:44.423004+05', 0),
	(27, 20, 2, 0, '<h1 class="text-lg font-bold">sdsdsd</h1><p></p>', 'sent', '2026-11-05 17:35:27.172024+05', '2026-11-05 17:35:27.098443+05', '2026-11-05 17:35:27.154428+05', 0),
	(28, 20, 2, 0, '<p>Ok sir, I will check on <strong>tuesday</strong></p>', 'sent', '2026-11-05 17:43:42.365395+05', '2026-11-05 17:43:42.32202+05', '2026-11-05 17:43:42.358383+05', 0),
	(29, 20, 2, 0, '<p>Ok sir, I will check on <strong>tuesday</strong></p>', 'sent', '2026-11-05 17:45:20.736315+05', '2026-11-05 17:45:20.711721+05', '2026-11-05 17:45:20.73393+05', 0),
	(30, 321, 2, 0, '<p>Please check fast, I want to change my status to overseas student.</p><p></p><p><strong>I am waiting for swift response</strong></p>', 'sent', '2026-11-05 18:26:08.59094+05', '2026-11-05 18:26:08.551309+05', '2026-11-05 18:26:08.585247+05', 0),
	(31, 321, 22, 0, '<p>Dear Student,</p><p><br>Please email on the&nbsp;<a target="_blank" rel="noopener noreferrer nofollow" href="mailto:ghulam.haider@vu.edu.pk"><strong>ghulam.haider@vu.edu.pk</strong></a> to update the email or create a ticket to the student profile under the <em>registrar office section</em> then you will be able to change the password.</p>', 'sent', '2026-11-05 18:32:07.09697+05', '2026-11-05 18:32:07.04957+05', '2026-11-05 18:32:07.093835+05', 0),
	(32, 17, 19, 0, '<blockquote><h1 class="text-lg font-bold">I am stilling waiting</h1></blockquote><p></p><p></p><p></p>', 'sent', '2026-11-05 19:55:19.044386+05', '2026-11-05 19:55:19.006007+05', '2026-11-05 19:55:19.037991+05', 0),
	(33, 17, 22, 0, '<p>OK, we are looking into it</p>', 'sent', '2026-11-05 19:57:05.951451+05', '2026-11-05 19:57:05.928955+05', '2026-11-05 19:57:05.948202+05', 0),
	(34, 25, 2, 0, '<p><strong>Please check fast</strong></p>', 'sent', '2026-11-05 20:08:08.478077+05', '2026-11-05 20:08:08.437756+05', '2026-11-05 20:08:08.473622+05', 0),
	(35, 348, 22, 0, '<p style="text-align: left;">Ok we are working on it.</p>', 'sent', '2026-11-12 15:18:36.821248+05', '2026-11-12 15:18:36.767019+05', '2026-11-12 15:18:36.813418+05', 0),
	(36, 25, 22, 0, '<p style="text-align: left;">Ok we are checking now.</p>', 'sent', '2026-11-12 18:35:02.777408+05', '2026-11-12 18:35:02.718721+05', '2026-11-12 18:35:02.771877+05', 0),
	(37, 25, 22, 0, '<p style="text-align: left;">Your query is now <strong>being looked at</strong></p>', 'sent', '2026-11-12 18:42:04.427529+05', '2026-11-12 18:42:04.37688+05', '2026-11-12 18:42:04.424574+05', 0),
	(38, 353, 3, 0, '<p style="text-align: left;">We are working on it.</p>', 'sent', '2026-11-13 16:57:54.87367+05', '2026-11-13 16:57:54.82377+05', '2026-11-13 16:57:54.865412+05', 0),
	(39, 353, 3, 1, '<p style="text-align: left;">Dear Mr. Sajwani, Thank you for letting us know. I’m sorry for the inconvenience.</p>', 'sent', '2026-11-13 21:02:42.418601+05', '2026-11-13 20:52:46.177999+05', '2026-11-13 21:02:42.414102+05', 0),
	(40, 354, 3, 1, '<p style="text-align: left;">Dear Tabish Sardar Ali Sajwani,</p><p style="text-align: left;"></p><p style="text-align: left;">Thank you for contacting the Billing Accounts &amp; Finance Office. Your financial‑aid application is currently under review. We normally take <strong>2–4 weeks</strong> to process an application. You can view the real‑time status of your request at any time by logging into the Student Portal and navigating to “Financial Aid → Application Status.”</p><p style="text-align: left;"></p><p style="text-align: left;">If you have not yet submitted a unique application ID or if you need to add any supporting documents, please let us know or upload them directly through the portal. Otherwise, we will notify you as soon as a decision is made.</p><p style="text-align: left;">Thank you for your patience. Feel free to reply to this ticket if you have further questions.</p><p style="text-align: left;"></p><p style="text-align: left;">Best regards,<br><strong>Billing Accounts &amp; Finance Office</strong></p>', 'sent', '2026-11-13 21:23:31.346091+05', '2026-11-13 21:03:04.241338+05', '2026-11-13 21:23:31.336858+05', 0),
	(41, 353, 3, 1, '<p style="text-align: left;">Dear Mr. Sajwani,</p><p style="text-align: left;">Thank you for letting us know that your tuition payment was sent to the incorrect account. We understand the urgency given that the late‑fee deadline is today.</p><ol><li><p style="text-align: left;">Please forward a copy of the bank transfer receipt or a screenshot showing the transfer date, amount, and recipient account number.</p></li><li><p style="text-align: left;">Upon receipt of this proof, we will credit the correct school account within 24 hours and waive any late fee for this payment.</p></li><li><p style="text-align: left;">We will send you a confirmation email once the correction is complete.</p></li></ol><p style="text-align: left;">If you require immediate assistance before the deadline, please call our Finance Office.</p><p style="text-align: left;">Sincerely,<br>Finance &amp; Billing Office</p>', 'sent', '2026-11-13 21:26:30.126994+05', '2026-11-13 21:25:23.349881+05', '2026-11-13 21:26:30.122553+05', 0),
	(42, 353, 3, 1, '<h2 class="text-lg font-bold" style="text-align: left;">Update on Your Tuition Payment</h2><p style="text-align: left;"><strong>Dear Mr. Sajwani,</strong></p><p style="text-align: left;">Thank you for your patience. We have received the bank transfer receipt you sent and are currently transferring the amount to the correct school account. The credit will be completed within the next 24 hours.</p><p style="text-align: left;"></p><p style="text-align: left;">As the late‑fee deadline is today, we will waive any late fee for this payment. You will receive a confirmation email once the transaction is finalized.</p><p style="text-align: left;">If you need immediate assistance before the deadline, please call our Finance Office at <strong>+1-555-1234</strong>.</p><p style="text-align: left;">Sincerely,<br>Finance &amp; Billing Office</p>', 'sent', '2026-11-13 21:27:52.015919+05', '2026-11-13 21:27:11.583598+05', '2026-11-13 21:27:52.013362+05', 0),
	(43, 356, 3, 0, '<p style="text-align: left;">Your ticket is forwarded to higher department for review</p>', 'sent', '2026-11-17 08:58:59.115314+05', '2026-11-17 08:58:59.017719+05', '2026-11-17 08:58:59.086389+05', 0),
	(9999, 5, 19, 0, 'Please seee the attachment', 'draft', NULL, '2026-09-05 08:14:54.687276+05', '2026-09-05 08:14:54.687276+05', 0),
	(66666, 5, 1, 0, 'Ok send us screenshot within a week', 'draft', NULL, '2026-09-05 07:19:10.605489+05', '2026-09-05 07:19:10.605489+05', 0);

-- Dumping structure for table public.roles
CREATE TABLE IF NOT EXISTS "roles" (
	"id" SERIAL NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("name")
);

-- Dumping data for table public.roles: 4 rows
DELETE FROM "roles";
INSERT INTO "roles" ("id", "name") VALUES
	(1, 'admin'),
	(2, 'hod'),
	(3, 'officer'),
	(4, 'student');

-- Dumping structure for table public.ticket_status_history
CREATE TABLE IF NOT EXISTS "ticket_status_history" (
	"id" SERIAL NOT NULL,
	"ticket_id" INTEGER NULL DEFAULT NULL,
	"old_status" VARCHAR(255) NULL DEFAULT NULL,
	"new_status" VARCHAR(255) NOT NULL,
	"changed_by" INTEGER NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY ("id"),
	CONSTRAINT "ticket_status_history_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT "ticket_status_history_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "tickets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.ticket_status_history: 112 rows
DELETE FROM "ticket_status_history";
INSERT INTO "ticket_status_history" ("id", "ticket_id", "old_status", "new_status", "changed_by", "created_at", "updated_at") VALUES
	(1, 2, 'pending', 'in_progress', 3, '2026-09-07 10:48:01.774616+05', '2026-09-07 10:48:01.774616+05'),
	(9, 2, 'in_progress', 'assigned', 3, '2026-09-07 16:47:39.7971+05', '2026-09-07 16:47:39.7971+05'),
	(10, 2, 'assigned', 'closed', 3, '2026-09-07 16:48:20.706151+05', '2026-09-07 16:48:20.706151+05'),
	(11, 2, 'closed', 'assigned', 3, '2026-09-07 16:59:25.102342+05', '2026-09-07 16:59:25.102342+05'),
	(12, 2, 'assigned', 'pending', 3, '2026-09-07 17:02:58.614592+05', '2026-09-07 17:02:58.614592+05'),
	(13, 44, NULL, 'pending', 2, '2026-09-08 13:44:47.951043+05', '2026-09-08 13:44:47.951043+05'),
	(14, 45, NULL, 'pending', 2, '2026-09-08 13:47:57.599592+05', '2026-09-08 13:47:57.599592+05'),
	(15, 46, NULL, 'pending', 2, '2026-09-08 14:18:45.532072+05', '2026-09-08 14:18:45.532072+05'),
	(16, 2, 'pending', 'escalated', NULL, '2026-09-09 13:37:51.595501+05', '2026-09-09 13:37:51.595501+05'),
	(17, 3, 'assigned', 'escalated', NULL, '2026-09-09 13:37:51.595501+05', '2026-09-09 13:37:51.595501+05'),
	(18, 47, NULL, 'pending', 2, '2026-09-09 14:00:05.796232+05', '2026-09-09 14:00:05.796232+05'),
	(19, 45, 'pending', 'escalated', NULL, '2026-09-09 14:02:48.430432+05', '2026-09-09 14:02:48.430432+05'),
	(20, 48, NULL, 'pending', 2, '2026-09-09 14:04:52.730179+05', '2026-09-09 14:04:52.730179+05'),
	(21, 1, 'pending', 'escalated', NULL, '2026-09-09 14:14:45.859141+05', '2026-09-09 14:14:45.859141+05'),
	(22, 24, 'pending', 'escalated', NULL, '2026-09-09 14:14:45.859141+05', '2026-09-09 14:14:45.859141+05'),
	(23, 38, 'pending', 'escalated', NULL, '2026-09-09 14:14:45.859141+05', '2026-09-09 14:14:45.859141+05'),
	(24, 48, 'pending', 'escalated', NULL, '2026-09-09 14:14:45.859141+05', '2026-09-09 14:14:45.859141+05'),
	(25, 49, NULL, 'pending', 19, '2026-09-10 07:07:46.605654+05', '2026-09-10 07:07:46.605654+05'),
	(26, 49, 'pending', 'in_progress', 3, '2026-09-10 07:30:00.669649+05', '2026-09-10 07:30:00.669649+05'),
	(27, 49, 'in_progress', 'assigned', 3, '2026-09-10 07:30:43.360034+05', '2026-09-10 07:30:43.360034+05'),
	(28, 49, 'assigned', 'closed', 3, '2026-09-10 07:31:07.619588+05', '2026-09-10 07:31:07.619588+05'),
	(29, 49, 'closed', 'open', 3, '2026-09-10 07:34:27.001786+05', '2026-09-10 07:34:27.001786+05'),
	(30, 49, 'open', 'pending', 3, '2026-09-10 07:34:52.343495+05', '2026-09-10 07:34:52.343495+05'),
	(31, 49, 'pending', 'in_progress', 3, '2026-09-10 07:36:25.235449+05', '2026-09-10 07:36:25.235449+05'),
	(32, 50, NULL, 'pending', 19, '2026-09-10 07:40:09.022385+05', '2026-09-10 07:40:09.022385+05'),
	(33, 51, NULL, 'pending', 19, '2026-09-10 08:01:09.119433+05', '2026-09-10 08:01:09.119433+05'),
	(34, 52, NULL, 'pending', 19, '2026-09-10 09:13:09.901715+05', '2026-09-10 09:13:09.901715+05'),
	(35, 53, NULL, 'pending', 19, '2026-09-10 09:16:09.05415+05', '2026-09-10 09:16:09.05415+05'),
	(36, 54, NULL, 'pending', 19, '2026-09-10 09:31:09.154775+05', '2026-09-10 09:31:09.154775+05'),
	(39, NULL, 'pending', 'closed', 1, '2026-09-10 10:08:39.860283+05', '2026-11-17 09:58:31.438135+05'),
	(40, NULL, 'closed', 'in_progress', 1, '2026-09-10 10:09:10.560762+05', '2026-11-17 09:58:31.438135+05'),
	(41, NULL, 'in_progress', 'closed', 1, '2026-09-10 10:09:18.639339+05', '2026-11-17 09:58:31.438135+05'),
	(42, 46, 'pending', 'escalated', NULL, '2026-09-10 11:37:16.983556+05', '2026-09-10 11:37:16.983556+05'),
	(43, 57, NULL, 'pending', 19, '2026-09-10 14:17:15.160147+05', '2026-09-10 14:17:15.160147+05'),
	(44, 57, 'pending', 'in_progress', 3, '2026-09-10 14:19:52.715111+05', '2026-09-10 14:19:52.715111+05'),
	(48, 61, NULL, 'pending', 19, '2026-09-19 00:03:49.934082+05', '2026-09-19 00:03:49.934082+05'),
	(49, NULL, NULL, 'pending', 19, '2026-09-19 00:06:28.783889+05', '2026-09-19 12:45:08.579491+05'),
	(52, 65, NULL, 'pending', 1, '2026-09-19 12:47:23.282028+05', '2026-09-19 12:47:23.282028+05'),
	(53, 66, NULL, 'pending', 19, '2026-09-19 12:51:54.318317+05', '2026-09-19 12:51:54.318317+05'),
	(54, 67, NULL, 'pending', 19, '2026-09-19 13:04:33.793711+05', '2026-09-19 13:04:33.793711+05'),
	(55, 67, 'pending', 'in_progress', 3, '2026-09-19 14:49:22.602825+05', '2026-09-19 14:49:22.602825+05'),
	(58, 65, 'pending', 'escalated', NULL, '2026-09-20 15:48:22.870793+05', '2026-09-20 15:48:22.870793+05'),
	(59, 66, 'pending', 'escalated', NULL, '2026-09-20 15:48:22.870793+05', '2026-09-20 15:48:22.870793+05'),
	(60, 28, 'in_progress', 'assigned', 3, '2026-09-21 21:07:55.964084+05', '2026-09-21 21:07:55.964084+05'),
	(61, 66, 'escalated', 'in_progress', 4, '2026-09-25 12:13:45.398261+05', '2026-09-25 12:13:45.398261+05'),
	(62, 66, 'in_progress', 'assigned', 4, '2026-09-25 13:29:41.295649+05', '2026-09-25 13:29:41.295649+05'),
	(63, 66, 'assigned', 'escalated', 4, '2026-09-25 13:37:15.559156+05', '2026-09-25 13:37:15.559156+05'),
	(64, 28, 'assigned', 'in_progress', 4, '2026-09-25 19:11:25.759828+05', '2026-09-25 19:11:25.759828+05'),
	(66, 66, 'resolved', 'escalated', 4, '2026-09-26 15:26:21.827574+05', '2026-09-26 15:26:21.827574+05'),
	(67, 66, 'escalated', 'resolved', 4, '2026-09-26 15:30:23.384512+05', '2026-09-26 15:30:23.384512+05'),
	(68, 70, NULL, 'pending', 19, '2026-10-11 15:45:32.663445+05', '2026-10-11 15:45:32.663445+05'),
	(75, 77, NULL, 'pending', 2, '2026-10-24 20:05:43.186576+05', '2026-10-24 20:05:43.186576+05'),
	(142, 70, 'pending', 'escalated', NULL, '2026-10-25 13:25:26.937641+05', '2026-10-25 13:25:26.937641+05'),
	(325, 321, NULL, 'pending', 2, '2026-11-05 18:20:10.631088+05', '2026-11-05 18:20:10.631088+05'),
	(326, 321, 'pending', 'closed', 22, '2026-11-05 18:32:28.200617+05', '2026-11-05 18:32:28.200617+05'),
	(327, 321, 'pending', 'resolved', 22, '2026-11-05 19:48:44.514894+05', '2026-11-05 19:48:44.514894+05'),
	(328, 321, 'resolved', 'closed', 22, '2026-11-05 19:48:59.704841+05', '2026-11-05 19:48:59.704841+05'),
	(329, 17, 'open', 'pending', 22, '2026-11-05 19:52:33.930867+05', '2026-11-05 19:52:33.930867+05'),
	(330, 17, 'pending', 'closed', 22, '2026-11-05 19:57:23.303109+05', '2026-11-05 19:57:23.303109+05'),
	(331, 17, 'closed', 'in_progress', 22, '2026-11-05 19:57:56.835675+05', '2026-11-05 19:57:56.835675+05'),
	(332, 322, NULL, 'pending', 2, '2026-11-07 14:47:09.00851+05', '2026-11-07 14:47:09.00851+05'),
	(338, 328, NULL, 'pending', 2, '2026-11-07 15:02:39.750572+05', '2026-11-07 15:02:39.750572+05'),
	(339, 329, NULL, 'pending', 2, '2026-11-07 15:05:43.174743+05', '2026-11-07 15:05:43.174743+05'),
	(340, 330, NULL, 'pending', 2, '2026-11-07 15:07:16.28398+05', '2026-11-07 15:07:16.28398+05'),
	(341, 331, NULL, 'pending', 2, '2026-11-07 15:10:38.639016+05', '2026-11-07 15:10:38.639016+05'),
	(342, 332, NULL, 'pending', 2, '2026-11-07 19:29:18.211395+05', '2026-11-07 19:29:18.211395+05'),
	(343, 333, NULL, 'pending', 2, '2026-11-07 19:31:53.920319+05', '2026-11-07 19:31:53.920319+05'),
	(344, 334, NULL, 'pending', 19, '2026-11-12 13:16:13.002353+05', '2026-11-12 13:16:13.002353+05'),
	(345, NULL, NULL, 'pending', 19, '2026-11-12 13:19:51.359092+05', '2026-11-17 10:04:05.834063+05'),
	(346, 336, NULL, 'pending', 19, '2026-11-12 13:29:59.916178+05', '2026-11-12 13:29:59.916178+05'),
	(347, 337, NULL, 'pending', 19, '2026-11-12 13:33:04.06163+05', '2026-11-12 13:33:04.06163+05'),
	(348, NULL, NULL, 'pending', 19, '2026-11-12 13:37:06.162779+05', '2026-11-17 10:04:37.810476+05'),
	(349, 339, NULL, 'pending', 19, '2026-11-12 13:42:51.248692+05', '2026-11-12 13:42:51.248692+05'),
	(350, 340, NULL, 'pending', 19, '2026-11-12 13:45:55.865638+05', '2026-11-12 13:45:55.865638+05'),
	(351, 341, NULL, 'pending', 19, '2026-11-12 13:48:48.376659+05', '2026-11-12 13:48:48.376659+05'),
	(352, 342, NULL, 'pending', 19, '2026-11-12 13:50:40.959993+05', '2026-11-12 13:50:40.959993+05'),
	(353, 343, NULL, 'pending', 19, '2026-11-12 13:51:44.54795+05', '2026-11-12 13:51:44.54795+05'),
	(354, 344, NULL, 'pending', 19, '2026-11-12 13:52:28.111994+05', '2026-11-12 13:52:28.111994+05'),
	(355, 345, NULL, 'pending', 19, '2026-11-12 13:53:11.394977+05', '2026-11-12 13:53:11.394977+05'),
	(356, 346, NULL, 'pending', 19, '2026-11-12 13:54:16.900187+05', '2026-11-12 13:54:16.900187+05'),
	(357, 347, NULL, 'pending', 19, '2026-11-12 14:03:19.030507+05', '2026-11-12 14:03:19.030507+05'),
	(358, 348, NULL, 'pending', 19, '2026-11-12 14:10:47.221046+05', '2026-11-12 14:10:47.221046+05'),
	(359, 67, 'in_progress', 'resolved', 3, '2026-11-12 14:56:39.670544+05', '2026-11-12 14:56:39.670544+05'),
	(360, 19, 'pending', 'in_progress', 3, '2026-11-12 15:04:21.491492+05', '2026-11-12 15:04:21.491492+05'),
	(361, 19, 'in_progress', 'assigned', 3, '2026-11-12 15:04:36.994335+05', '2026-11-12 15:04:36.994335+05'),
	(362, 336, 'pending', 'in_progress', 22, '2026-11-12 18:15:39.868059+05', '2026-11-12 18:15:39.868059+05'),
	(363, 336, 'in_progress', 'resolved', 22, '2026-11-12 18:16:16.100486+05', '2026-11-12 18:16:16.100486+05'),
	(364, NULL, NULL, 'pending', 2, '2026-11-13 14:34:14.287163+05', '2026-11-17 09:53:59.48204+05'),
	(365, 350, NULL, 'pending', 2, '2026-11-13 15:31:25.937972+05', '2026-11-13 15:31:25.937972+05'),
	(366, NULL, NULL, 'pending', 2, '2026-11-13 15:48:39.362191+05', '2026-11-17 09:50:42.244902+05'),
	(368, 333, 'pending', 'escalated', NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(369, 334, 'pending', 'escalated', NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(370, 339, 'pending', 'escalated', NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(371, 342, 'pending', 'escalated', NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(372, 345, 'pending', 'escalated', NULL, '2026-11-13 16:34:50.008538+05', '2026-11-13 16:34:50.008538+05'),
	(373, 353, NULL, 'pending', 19, '2026-11-13 16:45:18.855292+05', '2026-11-13 16:45:18.855292+05'),
	(374, 353, 'pending', 'in_progress', 3, '2026-11-13 16:57:16.256174+05', '2026-11-13 16:57:16.256174+05'),
	(375, 354, NULL, 'pending', 19, '2026-11-13 17:22:50.317407+05', '2026-11-13 17:22:50.317407+05'),
	(376, 355, NULL, 'pending', 19, '2026-11-13 19:00:25.016004+05', '2026-11-13 19:00:25.016004+05'),
	(377, 354, 'pending', 'in_progress', 3, '2026-11-13 19:58:57.733331+05', '2026-11-13 19:58:57.733331+05'),
	(378, 354, 'in_progress', 'assigned', 3, '2026-11-13 20:22:20.802705+05', '2026-11-13 20:22:20.802705+05'),
	(379, 354, 'assigned', 'escalated', 3, '2026-11-13 20:22:33.975674+05', '2026-11-13 20:22:33.975674+05'),
	(380, 354, 'escalated', 'resolved', 3, '2026-11-13 20:22:40.523063+05', '2026-11-13 20:22:40.523063+05'),
	(381, 2, 'escalated', 'closed', 4, '2026-11-14 09:21:35.602688+05', '2026-11-14 09:21:35.602688+05'),
	(382, 18, 'pending', 'closed', 4, '2026-11-14 09:33:33.815605+05', '2026-11-14 09:33:33.815605+05'),
	(383, 333, 'escalated', 'resolved', 1, '2026-11-17 08:37:35.319997+05', '2026-11-17 08:37:35.319997+05'),
	(384, 356, NULL, 'assigned', 19, '2026-11-17 08:54:31.636843+05', '2026-11-17 08:54:31.636843+05'),
	(385, 356, NULL, 'pending', 19, '2026-11-17 08:54:31.636843+05', '2026-11-17 08:54:31.636843+05'),
	(386, 356, 'pending', 'in_progress', 3, '2026-11-17 08:56:45.556109+05', '2026-11-17 08:56:45.556109+05'),
	(387, 357, NULL, 'assigned', 19, '2026-11-17 09:39:35.203709+05', '2026-11-17 09:39:35.203709+05'),
	(388, 357, NULL, 'pending', 19, '2026-11-17 09:39:35.203709+05', '2026-11-17 09:39:35.203709+05'),
	(389, 357, 'pending', 'in_progress', 22, '2026-11-17 09:44:25.024164+05', '2026-11-17 09:44:25.024164+05');

-- Dumping structure for table public.tickets
CREATE TABLE IF NOT EXISTS "tickets" (
	"id" SERIAL NOT NULL,
	"tracking_id" VARCHAR(255) NOT NULL,
	"student_id" INTEGER NULL DEFAULT NULL,
	"assigned_id" INTEGER NULL DEFAULT NULL,
	"department_id" INTEGER NULL DEFAULT NULL,
	"category_id" INTEGER NULL DEFAULT NULL,
	"channel" VARCHAR(255) NOT NULL,
	"subject" VARCHAR(255) NOT NULL,
	"body" TEXT NOT NULL,
	"intent" VARCHAR(255) NULL DEFAULT NULL,
	"confidence_level" NUMERIC(4,3) NULL DEFAULT NULL,
	"status" VARCHAR(255) NOT NULL,
	"escalation_level" SMALLINT NOT NULL,
	"awaiting_student_input" BOOLEAN NOT NULL,
	"resolved_at" TIMESTAMP NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"priority" VARCHAR(255) NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("tracking_id"),
	CONSTRAINT "tickets_assigned_id_fkey" FOREIGN KEY ("assigned_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "tickets_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "tickets_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT "tickets_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);

-- Dumping data for table public.tickets: 84 rows
DELETE FROM "tickets";
INSERT INTO "tickets" ("id", "tracking_id", "student_id", "assigned_id", "department_id", "category_id", "channel", "subject", "body", "intent", "confidence_level", "status", "escalation_level", "awaiting_student_input", "resolved_at", "created_at", "updated_at", "priority") VALUES
	(1, 'QRY-20260829-164022-YSET', 2, 1, 6, 7, 'web_form', 'Lost my flash drive', 'HELP!!!! I LOST MY FLASH DRIVE WITH MY ENTIRE SENIOR THESIS ON IT IN THE LIBRARY!!!!!', 'Library', NULL, 'escalated', 1, 'false', NULL, '2026-08-29 16:40:22.187679+05', '2026-09-09 14:14:45.859141+05', NULL),
	(2, 'QRY-20260829-164128-YVRY', 2, 4, 2, 3, 'web_form', 'tuition payment issue', 'My tuition payment is showing as ''rejected'' even though I have the funds. Registration for my grad program closes tomorrow morning.', 'Finance', NULL, 'closed', 1, 'false', NULL, '2026-08-29 16:41:28.299907+05', '2026-11-14 09:21:35.602688+05', 'medium'),
	(3, 'QRY-20260829-164900-5X7F', 1, 1, 2, 3, 'web_form', 'Urgent: Challan Payment Verification & Late Fee Fine', 'Respected Sir, I paid my semester fee voucher yesterday via mobile banking, but my LMS account still shows an unpaid status and has applied a Rs. 1000 late fine. Attached is my bank receipt. Kindly update my fee status.', 'Finance', NULL, 'escalated', 1, 'false', NULL, '2026-08-29 16:49:00.326297+05', '2026-09-09 13:37:51.595501+05', NULL),
	(5, 'QRY-20260831-174517-LDUT', 19, 3, 2, 3, 'web_form', 'Incorrect late fees', 'The bursar''s office is showing a $1,000 late fee on my account even though i paid early. registration for class is today.', 'Finance', NULL, 'closed', 0, 'false', NULL, '2026-08-31 17:45:17.857574+05', '2026-11-14 09:22:28.114619+05', 'medium'),
	(6, 'QRY-20260831-174623-RCKO', 19, NULL, 5, 6, 'web_form', 'request for specific room', 'is there a way to request a specific room in the dorm or is it first come first served this year?', 'Housing', NULL, 'pending', 0, 'false', NULL, '2026-08-31 17:46:23.339644+05', '2026-08-31 17:46:23.339644+05', NULL),
	(7, 'QRY-20260902-064432-WUMO', 19, NULL, NULL, 1, 'email', 'Issue in my enrollment', 'I AM PANICKING!! I NEED TO VERIFY MY ENROLLMENT FOR MY INSURANCE AND THE FORM SAYS I AM NOT A STUDENT!! I HAVE CLASSES!!', 'general', NULL, 'open', 2, 'false', NULL, '2026-09-02 06:44:32.494975+05', '2026-09-02 06:44:32.494975+05', NULL),
	(9, 'QRY-20260902-065245-CWPD', 19, NULL, 5, 6, 'email', 'Turtle in water tank', 'i want to know the university''s policy on pets in the dorm. can i have a small turtle in a tank?', 'Housing', 0.658, 'open', 0, 'false', NULL, '2026-09-02 06:52:45.676698+05', '2026-09-02 06:52:45.676698+05', NULL),
	(10, 'QRY-20260902-065624-CPRU', 19, NULL, 4, 5, 'email', 'Severe Privacy Breach', 'The university website is displaying my social security number on the student profile page. This is a severe privacy breach and must be fixed immediately.', 'Administration', 0.520, 'open', 2, 'false', NULL, '2026-09-02 06:56:24.681601+05', '2026-09-02 06:56:24.681601+05', NULL),
	(11, 'QRY-20260902-065734-Z3ZK', 19, NULL, 7, 8, 'email', 'Wifi not workng', 'the wifi in the laundry room is a bit slow today. maybe someone can check the router next week?', 'Technical', 0.472, 'open', 0, 'false', NULL, '2026-09-02 06:57:34.86821+05', '2026-09-02 06:57:34.86821+05', NULL),
	(12, 'QRY-20260902-065838-RR6E', 19, NULL, 6, 7, 'email', 'issue in library account', 'library account shows delayed check-in notification incorrectly', 'Library', 0.610, 'open', 1, 'false', NULL, '2026-09-02 06:58:38.104054+05', '2026-09-02 06:58:38.104054+05', NULL),
	(13, 'QRY-20260902-065957-N2IX', 19, NULL, 7, 8, 'email', 'IT System Error', 'IT system showing delayed MFA approval', 'Technical', 0.521, 'open', 1, 'false', NULL, '2026-09-02 06:59:57.209603+05', '2026-09-02 06:59:57.209603+05', NULL),
	(14, 'QRY-20260902-070309-P4XX', 19, NULL, 5, 6, 'email', 'Internet Not Working', 'HELP!! I am currently taking a timed online midterm and the internet in the dorm just went out completely!!', 'Housing', 0.484, 'open', 2, 'false', NULL, '2026-09-02 07:03:09.218225+05', '2026-09-02 07:03:09.218225+05', NULL),
	(15, 'QRY-20260902-070409-OL3Q', 19, NULL, NULL, 1, 'email', '505 Error on registration page', 'The enrollment portal is returning a 505 error on the final day of registration for my major. I have 2 hours left before the window closes forever.', 'general', 0.335, 'open', 2, 'false', NULL, '2026-09-02 07:04:09.048168+05', '2026-09-02 07:04:09.048168+05', NULL),
	(16, 'QRY-20260902-070503-RYWL', 19, NULL, 1, 2, 'email', 'Wrong Canvas Page', 'The Canvas page for my History class is missing the syllabus and all the assignment links. My professor said it was live.', 'Academic', 0.483, 'open', 1, 'false', NULL, '2026-09-02 07:05:03.057645+05', '2026-09-02 07:05:03.057645+05', NULL),
	(17, 'QRY-20260902-070537-JX0F', 19, 22, 7, 8, 'email', 'Wrong Online Portal', 'I''m having trouble with the online portal for my student content management request account.', 'Technical', 0.662, 'in_progress', 1, 'true', NULL, '2026-09-02 07:05:37.780514+05', '2026-11-05 19:57:56.835675+05', NULL),
	(18, 'QRY-20260902-071538-ZF5U', 19, 4, 2, 3, 'email', 'Late Fees Issue', 'The bursar''s office is showing a $1,000 late fee on my account even though i paid early. registration for class is today.', 'Finance', 0.830, 'closed', 2, 'false', NULL, '2026-09-02 07:15:38.614902+05', '2026-11-14 09:33:33.815605+05', 'medium'),
	(19, 'QRY-20260902-072812-MX7K', 19, 3, 2, 3, 'email', 'Transfer to wrong school account', 'i need to report that my bank transfer for tuition was sent to the wrong school account and the late fee deadline is today.', 'Finance', 0.731, 'assigned', 2, 'false', NULL, '2026-09-02 07:28:12.649733+05', '2026-11-12 15:04:36.994335+05', 'high'),
	(20, 'QRY-20260902-072952-CD1X', 2, 22, 7, 8, 'web_form', 'VPN not working', '<strong>VPN</strong> drops when switching between campus networks', 'Technical', 0.499, 'pending', 1, 'false', NULL, '2026-09-02 07:29:52.100251+05', '2026-09-02 07:29:52.100251+05', NULL),
	(21, 'QRY-20260902-075704-SXAR', 19, NULL, 1, 2, 'email', 'Unable to register for CS604', 'I am unable to register for CS604. The course is showing an error when I try to enroll. Please help', 'Academic', 0.533, 'pending', 2, 'false', NULL, '2026-09-02 07:57:04.181828+05', '2026-09-02 07:57:04.181828+05', NULL),
	(22, 'QRY-20260902-093756-W9FF', 19, NULL, 5, 6, 'email', 'Toilet paper issue in my bathroom', 'The toilet paper holder in my dorm bathroom is broken.', 'Housing', 0.851, 'pending', 0, 'false', NULL, '2026-09-02 09:37:56.570537+05', '2026-09-02 09:37:56.570537+05', NULL),
	(23, 'QRY-20260902-094008-BRAU', 27, 22, 7, 8, 'email', 'slow internet speed', 'internet speed drops occasionally during peak hours.', 'Technical', 0.449, 'pending', 1, 'false', NULL, '2026-09-02 09:40:08.515002+05', '2026-09-02 09:40:08.515002+05', NULL),
	(24, 'QRY-20260902-101551-4AX8', 27, 1, 6, 7, 'email', 'Request for a textbook', 'Does the library have a copy of the textbook for ''Introduction to Sociology''? I can''t afford to buy it.', 'Library', 0.747, 'escalated', 1, 'false', NULL, '2026-09-02 10:15:51.333079+05', '2026-09-09 14:14:45.859141+05', NULL),
	(25, 'QRY-20260902-101757-HHDU', 2, 22, 7, 8, 'web_form', 'my wifi is down', 'The wifi in the North dorms has been down since 6 PM. I have an online quiz due at midnight.', 'Technical', 0.625, 'pending', 2, 'true', NULL, '2026-09-02 10:17:57.765525+05', '2026-11-12 18:35:02.771877+05', NULL),
	(27, 'QRY-20260902-191642-DVJQ', 19, NULL, 5, 6, 'email', 'My room is flooding', 'MY ROOM IS FLOODING!!! A pipe just burst in the shared bathroom of block C
level 4. HELP ASAP!!!
', 'Housing', 0.680, 'pending', 2, 'false', NULL, '2026-09-02 19:16:42.62605+05', '2026-09-02 19:16:42.62605+05', NULL),
	(28, 'QRY-20260903-064157-PZ2W', 19, 4, 2, 3, 'email', 'Overcharged for my lab fees', 'i was overcharged for my lab fees but i already paid the full amount. i''d
like a refund please.
', 'Finance', 0.618, 'in_progress', 1, 'true', NULL, '2026-09-03 06:41:56.94876+05', '2026-11-14 09:37:14.632655+05', 'low'),
	(29, 'QRY-20260903-070858-AR5A', 19, NULL, 1, 2, 'email', 'Inquiry about placement test', 'id like to know if i can take a placement test for spanish or if i have to
start at level 1? no hurry.
', 'Academic', 0.401, 'pending', 0, 'false', NULL, '2026-09-03 07:08:58.676423+05', '2026-09-03 07:08:58.676423+05', NULL),
	(36, 'QRY-20260903-113102-Z4OF', 19, 3, 2, 3, 'email', 'Tuition payment error', 'Tuition payment error, urgent fix needed.
', 'Finance', 0.810, 'pending', 2, 'false', NULL, '2026-09-03 11:31:02.115597+05', '2026-09-03 11:31:02.115597+05', NULL),
	(37, 'QRY-20260903-114459-ZNS4', 19, NULL, 5, 6, 'email', 'Dorm ID Card issue', 'My dorm ID card is not unlocking the laundry room door.
', 'Housing', 0.910, 'pending', 2, 'false', NULL, '2026-09-03 11:44:59.430006+05', '2026-09-03 11:44:59.430006+05', NULL),
	(38, 'QRY-20260903-114500-0IBD', 19, 1, 6, 7, 'email', 'Need of Staplers', 'URGENT PLS!!!! I NEED TO KNOW IF THE LIBRARY HAS ANY STAPLERS RIGHT NOW I
HAVE A PAPER DUE ON FRIDAY!!!!!
', 'Library', 0.891, 'escalated', 1, 'false', NULL, '2026-09-03 11:45:00.338243+05', '2026-09-09 14:14:45.859141+05', NULL),
	(39, 'QRY-20260903-130004-X4S2', 19, 3, 2, 3, 'email', 'Contact information of the architecture', 'hi, do u have any information on the architect who designed the finance
office lobby? thx.
', 'Finance', 0.436, 'pending', 0, 'true', NULL, '2026-09-03 13:00:04.589547+05', '2026-09-05 17:06:08.32599+05', NULL),
	(40, 'QRY-20260903-130005-78NL', 19, NULL, 1, 2, 'email', 'Contact information of Biology Department', 'i''m tryin to find the contact info for the biology department head. do u
have their email address?
', 'Academic', 0.438, 'pending', 1, 'false', NULL, '2026-09-03 13:00:05.476616+05', '2026-09-03 13:00:05.476616+05', NULL),
	(41, 'QRY-20260904-065140-R1WG', 19, 3, 2, 3, 'web_form', 'Issue in my exam fees', 'I received an email saying I was withdrawn from my classes due to non-payment, but I have a full scholarship. I have a midterm tomorrow.', 'Finance', 0.533, 'pending', 2, 'false', NULL, '2026-09-04 06:51:40.897033+05', '2026-09-04 06:51:40.897033+05', NULL),
	(42, 'QRY-20260906-071035-RSTG', 19, NULL, NULL, 1, 'web_form', 'Incorrect health insurance', 'The university''s portal for international student health insurance is rejecting my proof of coverage. The deadline to avoid the $2000 charge is in 2 hours.', 'general', 0.347, 'pending', 2, 'false', NULL, '2026-09-06 07:10:35.160072+05', '2026-09-06 07:10:35.160072+05', NULL),
	(43, 'QRY-20260906-071223-7VQQ', 19, 3, 2, 3, 'web_form', 'Work-study paycheck', 'I need to talk to someone about my work-study paycheck. I haven''t been paid for the last two weeks.', 'Finance', 0.405, 'pending', 1, 'false', NULL, '2026-09-06 07:12:23.10246+05', '2026-09-06 07:12:23.10246+05', NULL),
	(44, 'QRY-20260908-134447-X3AB', 2, NULL, NULL, 1, 'web_form', 'financial assistance for students', 'I need to know if the university offers any financial assistance for students who are experiencing emergency situations.', 'general', 0.268, 'pending', 0, 'false', NULL, '2026-09-08 13:44:47.951043+05', '2026-09-08 13:44:47.951043+05', 'low'),
	(45, 'QRY-20260908-134757-J1NI', 2, 1, 2, 3, 'web_form', 'scholarship amount', 'Hello, my scholarship for the semester has not been applied to my account, and I have a registration hold. My final enrollment window for the nursing program closes tonight at midnight.', 'Finance', 0.647, 'escalated', 1, 'false', NULL, '2026-09-08 13:47:57.599592+05', '2026-09-09 14:02:48.430432+05', 'high'),
	(46, 'QRY-20260908-141845-L6XU', 2, 1, 2, 3, 'web_form', 'financial aid award letter', 'I would like to request a copy of my financial aid award letter.', 'Finance', 0.537, 'escalated', 1, 'false', NULL, '2026-09-08 14:18:45.532072+05', '2026-09-10 11:37:16.983556+05', 'low'),
	(47, 'QRY-20260909-140005-DXE7', 2, 4, 3, 4, 'web_form', 'sign visa documents', 'I am an international student and my visa documentation needs to be signed by the university by tomorrow afternoon for my appointment at the embassy.', 'Admissions', 0.492, 'pending', 0, 'true', NULL, '2026-09-07 14:00:05+05', '2026-09-24 17:40:47.197976+05', 'high'),
	(48, 'QRY-20260909-140452-3LGV', 2, 1, 6, 7, 'web_form', 'Library Room Information', 'URGENT!!!!! I NEED TO KNOW IF THE LIBRARY HAS ANY PLUGS FOR MY LAPTOP I AM AT 1% AND MY PAPER IS DUE IN TWO DAYS!!!!!!!', 'Library', 0.771, 'escalated', 1, 'false', NULL, '2026-09-08 04:04:52+05', '2026-09-09 14:14:45.859141+05', 'low'),
	(49, 'QRY-20260910-070746-V5IC', 19, 3, 6, 7, 'web_form', 'Trapped on the roof of the library', 'I am trapped on the roof of the library. The door locked behind me and it''s getting dark.', 'Library', 0.639, 'in_progress', 0, 'true', NULL, '2026-09-10 07:07:46.605654+05', '2026-09-10 07:36:25.245352+05', 'high'),
	(50, 'QRY-20260910-074009-7CVT', 19, NULL, NULL, 1, 'email', 'Inquiry about finance lobby', 'Is there a limit to the number of visitors a student can bring to the
finance office lobby at once?
', 'general', 0.332, 'pending', 0, 'false', NULL, '2026-09-10 07:40:09.022385+05', '2026-09-10 07:40:09.022385+05', 'low'),
	(51, 'QRY-20260910-080109-7ZB0', 19, NULL, NULL, 1, 'email', 'filing taxes', 'I would like to know if the university provides any assistance for filing
taxes for international students on a J-1 visa.
', 'general', 0.302, 'pending', 0, 'false', NULL, '2026-09-10 08:01:09.119433+05', '2026-09-10 08:01:09.119433+05', 'low'),
	(52, 'QRY-20260910-091309-80ZT', 19, NULL, NULL, 1, 'email', 'Question Regarding Single Responsibility Principle', 'Asalam o Alaikum Sir,

I have a question regarding Single Responsibility Principle:

If a class is handling user registration, logging, updating, deleting, etc.
then does it break *Single Responsibility Principle (SRP)*?

If it breaks SRP, then isn''t having many classes for handling these user
methods isn''t create too much files?

Thanks
', 'general', 0.264, 'pending', 0, 'false', NULL, '2026-09-10 09:13:09.901715+05', '2026-09-10 09:13:09.901715+05', 'medium'),
	(53, 'QRY-20260910-091609-RV29', 19, NULL, NULL, 1, 'email', 'Credit Hours Limit Increase', 'Assalam o Alaikum,

Sir, can you please increase my credit hours limit because after selecting
all current semester courses there are two credit hours remaining and I
can''t utilize these two remaining credit hours in selecting a new course
from next semester.

Additionally, at the end of five semesters I have earned 87 credit hours
but there should be 90 credit hours (18 * 5 = 90),

So it''s my request to increase my credit hours limit by 1 or 3, so I can
pick additional courses
', 'general', 0.339, 'pending', 0, 'false', NULL, '2026-09-10 09:16:09.05415+05', '2026-09-10 09:16:09.05415+05', 'high'),
	(54, 'QRY-20260910-093109-SVPT', 19, NULL, 1, 2, 'email', 'Special permission code', 'hi, i''m trying to register for a course but it says I need a ''Special
Permission'' code even though it''s an open elective.
', 'Academic', 0.476, 'pending', 0, 'false', NULL, '2026-09-10 09:31:09.154775+05', '2026-09-10 09:31:09.154775+05', 'medium'),
	(57, 'QRY-20260910-141715-QMX0', 19, 3, 2, 3, 'web_form', 'Urgent: Challan Payment Verification & Late Fee Fine', 'Respected Sir, I paid my semester fee voucher yesterday via mobile banking, but my LMS account still shows an unpaid status and has applied a Rs. 1000 late fine. Attached is my bank receipt. Kindly update my fee status', 'Finance', 0.656, 'in_progress', 0, 'true', NULL, '2026-09-10 14:17:15.160147+05', '2026-09-10 14:19:52.727187+05', 'medium'),
	(61, 'QRY-20260919-000349-46A4', 19, NULL, NULL, 1, 'web_form', 'Availability of librarians', 'i need help finding some research articles for my history paper. are there any librarians available to talk tomorrow?', 'General', 0.261, 'pending', 0, 'false', NULL, '2026-09-19 00:03:49.934082+05', '2026-09-19 00:03:49.934082+05', 'low'),
	(65, 'QRY-20260919-124723-ZO50', 1, 1, 2, 3, 'web_form', 'overcharged for my lab fees', 'i was overcharged for my lab fees but i already paid the full amount. i''d like a refund please.', 'Finance', 0.618, 'escalated', 1, 'false', NULL, '2026-09-19 12:47:23.282028+05', '2026-09-20 15:48:22.870793+05', 'medium'),
	(66, 'QRY-20260919-125154-TOEX', 19, 4, 2, 3, 'web_form', 'refund the fees for the semester', 'I would like to inquire about the status of my refund for the semester. It has been three weeks since it was approved.', 'Finance', 0.480, 'resolved', 1, 'true', '2026-09-26 15:30:23.419084', '2026-09-19 12:51:54.318317+05', '2026-09-26 15:30:23.384512+05', 'high'),
	(67, 'QRY-20260919-130433-3YTE', 19, 3, 2, 3, 'email', 'Issue with finance', 'I received an eviction notice for non-payment, but my scholarship was
supposed to cover it. I need the housing hold removed now.
', 'Finance', 0.651, 'resolved', 0, 'true', '2026-11-12 13:56:39.678975', '2026-09-19 13:04:33.793711+05', '2026-11-12 14:56:39.670544+05', 'high'),
	(68, 'QRY-20260919-204838-43GV', NULL, NULL, NULL, 1, 'email', 'Security alert', '[image: Google]
Authenticator app added as sign-in step


virtualuniversity08@gmail.com
If you didn''t add the Authenticator app, someone might be using your
account. Check and secure your account now.
Check activity
<https://accounts.google.com/AccountChooser?Email=virtualuniversity08@gmail.com&continue=https://myaccount.google.com/alert/nt/1789832742598?rfn%3D252%26rfnc%3D1%26eid%3D1424002024499870683%26et%3D0>
You can also see security activity at
https://myaccount.google.com/notifications
You received this email to let you know about important changes to your
Google Account and services.
© 2026 Google LLC, 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA
', 'General', 0.269, 'pending', 0, 'false', NULL, '2026-09-19 20:48:37.373557+05', '2026-09-19 20:48:37.373557+05', 'medium'),
	(69, 'QRY-20260919-205137-RC8I', NULL, NULL, NULL, 1, 'email', '2-Step Verification turned on', '[image: Google]
2-Step Verification turned on


virtualuniversity08@gmail.com

Your Google Account virtualuniversity08@gmail.com is now protected with
2-Step Verification. When you sign in on a new or untrusted device, you’ll
need your second factor to verify your identity.

*Don''t get locked out!*
You can add a backup phone or get backup codes to use when you don’t have
your second factor with you.
You can review your 2SV settings
<https://accounts.google.com/AccountChooser?Email=virtualuniversity08@gmail.com&continue=https://myaccount.google.com/signinoptions/twosv?rfn%3D16%26rfnc%3D1%26eid%3D2211986483115191366%26et%3D0>
to make changes.
You can also see security activity at
https://myaccount.google.com/notifications
You received this email to let you know about important changes to your
Google Account and services.
© 2026 Google LLC, 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA
', 'General', 0.284, 'pending', 0, 'false', NULL, '2026-09-19 20:51:37.421296+05', '2026-09-19 20:51:37.421296+05', 'low'),
	(70, 'QRY-20261011-144532-7DS0', 19, NULL, 2, 3, 'web_form', 'Urgent: Challan Payment Verification & Late Fee Fine', 'Respected Sir, I paid my semester fee voucher yesterday via mobile banking, but my LMS account still shows an unpaid status and has applied a Rs. 1000 late fine. Attached is my bank receipt. Kindly update my fee status.', 'Finance', 0.656, 'escalated', 1, 'false', NULL, '2026-10-11 15:45:32.663445+05', '2026-10-25 13:25:26.937641+05', 'medium'),
	(77, 'QRY-20261024-190543-7I8D', 2, 22, 7, 8, 'web_form', 'trouble logging into my account', 'I''m having trouble logging into my student account. It says my password has expired but the reset link is not working.', 'Technical', 0.768, 'pending', 0, 'false', NULL, '2026-10-24 20:05:43.186576+05', '2026-10-24 20:05:43.186576+05', 'medium'),
	(138, 'QRY-20261025-114022-OSBD', NULL, NULL, NULL, 1, 'email', '[Action Required] Mark AI agent OAuth clients as agentic for Google Workspace MCP by Nov 11, 2026', 'A new agentic setting for OAuth clients ahead of Workspace MCP servers.




MY CONSOLE




Hello Virtual,

You are receiving this communication because your Google Cloud project  
contains OAuth 2.0 credentials or applications that connect to Google  
Workspace via OAuth.

We will soon roll out the Google Workspace Model Context Protocol (MCP)  
servers, which expose new functionality to external AI Agents across Gmail,  
Drive, Calendar, and other Workspace apps using the open Model Context  
Protocol (MCP). Ahead of this launch, we are introducing an “agentic”  
setting ( is_agentic ) on Google OAuth clients, so that Google and  
Workspace administrators can differentiate AI agent traffic from  
traditional app traffic. Only OAuth clients marked as agentic will be able  
to call Workspace MCP servers. We are announcing this change early, so  
developers and project owners have time to prepare.

If your app is not an AI agent and only uses Google Workspace REST APIs  
(for example, the Gmail API or Drive API), you do not need to take any  
action for this change.

We have provided additional information below to outline the technical  
impact of this change and the actions required to keep access to Workspace  
MCP servers.

What you need to know

Key changes and timelines:


October 12, 2026 (New “agentic” OAuth client classification): Developers  
can directly mark their OAuth clients as "agentic" ( is_agentic ) in the  
Google Cloud console.
November 11, 2026 (Only agentic clients can call Workspace MCP servers):  
Google will reject requests to Workspace MCP servers from OAuth clients  
that are not marked as agentic.
November 12, 2026 (The agentic setting becomes permanent): Starting on this  
date, you can no longer change the agentic setting on an existing OAuth  
client. To change it, create a new OAuth Client ID.

Potential impact:


Refused access: Starting November 11, 2026, Workspace MCP servers will  
reject requests from any app or integration whose OAuth client is not  
marked as agentic. The error message will state “the client isn''t marked as  
an AI agent” and will link to steps to fix it.
New OAuth Client ID requirement: OAuth clients that are not marked as  
agentic by November 12, 2026 will remain non-agentic and cannot call  
Workspace MCP servers. To use MCP after this date, you will need to create  
a new OAuth client marked as agentic and update your app to use it.
Unaffected applications: Apps that are not AI agents and only call Google  
Workspace REST APIs are not affected by this change.

What you need to do

Action required:


Identify your AI agent clients: Identify the OAuth clients in your Google  
Cloud projects that belong to AI agents, including agents that currently  
use Workspace REST APIs only.

Only mark OAuth clients that are used by AI agents. Agentic clients have  
separate security controls applied, such as agent access controls.
If an app handles both AI agent and non-agent traffic, use a separate OAuth  
client for the AI agent.

Mark them as agentic between October 12 and November 11, 2026: Turn on the  
agentic setting for these OAuth clients in the Google Cloud console, so  
they can call Workspace MCP servers.
Plan for the setting becoming permanent starting November 12, 2026:

To change the setting on an existing OAuth client after this date, you will  
need to create a new OAuth Client ID.
When you create a new OAuth client, you must choose whether it is agentic.


Your affected projects are listed below:


fastemailautomation

We are here to help

If you have any questions or require assistance classifying your OAuth  
clients:


Review the Managing OAuth Clients Help Center article
Contact your Google Account Manager or Technical Account Manager
Contact Google Cloud Support with your Google Cloud Project ID and OAuth  
2.0 Client ID

Thanks for choosing Google Cloud.





– The Google Cloud Team





DOCUMENTATION



SUPPORT




Was this information helpful?

Yes Neutral No


© 2026 Google LLC 1600 Amphitheatre Parkway, Mountain View, CA 94043

You''ve received this mandatory service announcement to update you about  
important changes to Google Cloud or your account.



Visit GCP on GitHub Visit Google Cloud on LinkedIn Visit Google Cloud on  
Twitter




', 'General', 0.182, 'pending', 0, 'false', NULL, '2026-10-25 12:40:22.289245+05', '2026-10-25 12:40:22.289245+05', 'medium'),
	(139, 'QRY-20261103-142217-WOMB', NULL, 22, 7, 8, 'email', 'Verify your email address', 'Microsoft account

Verify your email address

To finish setting up your Microsoft account, we just need to make sure this email address is yours.

To verify your email address use this security code: 700952

If you didn''t request this code, you can safely ignore this email. Someone else might have typed your email address by mistake.

Thanks,
The Microsoft account team 
Privacy Statement: https://go.microsoft.com/fwlink/?LinkId=521839
Microsoft Corporation, One Microsoft Way, Redmond, WA 98052
', 'Technical', 0.316, 'pending', 0, 'false', NULL, '2026-11-03 15:22:16.902332+05', '2026-11-03 15:22:16.902332+05', 'medium'),
	(321, 'QRY-20261105-172010-EOMQ', 2, 22, 7, 8, 'web_form', 'My VU Email Account Is Blocked', '<p>I got notification from Google that they found unusual activity in my gmail account <a target="_blank" rel="noopener noreferrer nofollow" href="mailto:bc230203410tsa@vu.edu.pk"><strong>bc230203410tsa@vu.edu.pk</strong></a>&nbsp;and ask to change password. </p><p></p><p>When I changed the password then it showed my account is blocked due to violation of Google Workspace policies. </p><p></p><p>However, <strong>I didn''t any spam activity</strong> and using account as usual. </p><p></p><p><em>Can you please get it activate again?</em></p>', 'Technical', 0.404, 'closed', 0, 'true', '2026-11-05 18:48:44.521182', '2026-11-05 18:20:10.631088+05', '2026-11-05 19:48:59.704841+05', 'medium'),
	(322, 'QRY-20261107-134709-YDF2', 2, NULL, 4, 5, 'web_form', 'official enrollment veritification', 'I need my official enrollment verification for a court hearing tomorrow at 9 AM. The online system is giving a server error.', 'Administration', 0.563, 'pending', 0, 'false', NULL, '2026-11-07 14:47:09.00851+05', '2026-11-07 14:47:09.00851+05', 'high'),
	(328, 'QRY-20261107-140239-0MY1', 2, NULL, 1, 2, 'web_form', 'university honor''s program', 'i''m interested in the university''s honors program. how do i apply?', 'Academic', 0.352, 'pending', 0, 'false', NULL, '2026-11-07 15:02:39.750572+05', '2026-11-07 15:02:39.750572+05', 'low'),
	(329, 'QRY-20261107-140543-685V', 2, NULL, 1, 2, 'web_form', 'university honor''s program', 'i''m interested in the university''s honors program. how do i apply?', 'Academic', 0.352, 'pending', 0, 'false', NULL, '2026-11-07 15:05:43.174743+05', '2026-11-07 15:05:43.174743+05', 'low'),
	(330, 'QRY-20261107-140716-J9PD', 2, NULL, 1, 2, 'web_form', 'university honor''s program', 'i''m interested in the university''s honors program. how do i apply?', 'Academic', 0.352, 'pending', 0, 'false', NULL, '2026-11-07 15:07:16.28398+05', '2026-11-07 15:07:16.28398+05', 'low'),
	(331, 'QRY-20261107-141038-83SH', 2, NULL, 4, 5, 'web_form', 'wrong mail address', 'My official transcript was mailed to the wrong address for a law school application due tomorrow. I need a digital copy now.', 'Administration', 0.305, 'pending', 0, 'false', NULL, '2026-11-07 15:10:38.639016+05', '2026-11-07 15:10:38.639016+05', 'high'),
	(332, 'QRY-20261107-182918-IMYJ', 2, NULL, 3, 4, 'web_form', 'Wrong termination warning', '<p>I am an <strong>international student</strong> and my SEVIS record has a ''<strong>Termination</strong>'' warning for tomorrow. I need the university to <u>fix my status today</u>.</p>', 'Admissions', 0.383, 'pending', 0, 'false', NULL, '2026-11-07 19:29:18.211395+05', '2026-11-07 19:29:18.211395+05', 'high'),
	(333, 'QRY-20261107-183153-LHPE', 2, NULL, 6, 7, 'web_form', 'Booking group study room', '<p>Hello, I would like to <strong>book a group study room</strong> for next Tuesday at 3 PM for three hours.</p>', 'Library', 0.344, 'resolved', 1, 'false', '2026-11-17 07:37:35.338967', '2026-11-07 19:31:53.920319+05', '2026-11-17 08:37:35.319997+05', 'low'),
	(334, 'QRY-20261112-121613-VF3T', 19, NULL, 2, 3, 'web_form', 'Student Scholarship', '<p style="text-align: left;">I need help with my application for a student scholarship for students in the life and health sciences.</p>', 'Finance', 0.771, 'escalated', 1, 'false', NULL, '2026-11-12 13:16:13.002353+05', '2026-11-13 16:34:50.008538+05', 'low'),
	(336, 'QRY-20261112-122959-5P2X', 19, 22, 7, 8, 'web_form', 'Weak Wi-Fi Signals', '<p style="text-align: left;">The <strong>Wi-Fi in the North Dorm is extremely slow today</strong>. It''s making it hard to watch the lecture videos.</p>', 'Technical', 0.333, 'resolved', 0, 'false', '2026-11-12 17:16:16.109089', '2026-11-12 13:29:59.916178+05', '2026-11-12 18:16:16.100486+05', 'medium'),
	(337, 'QRY-20261112-123304-JY5P', 19, NULL, NULL, 1, 'web_form', 'I got a serious issue and need to be fix quickly', '<p style="text-align: left;">&lt;script&gt; // Unsafe: directly taking user query from the URL and injecting it into the DOM const params = new URLSearchParams(<a target="_blank" rel="noopener noreferrer nofollow" href="http://window.location.search">window.location.search</a>); const query = params.get(''query''); document.getElementById(''search-results'').innerHTML = "You searched for: " + query; &lt;/script&gt;</p>', 'General', 0.166, 'pending', 0, 'false', NULL, '2026-11-12 13:33:04.06163+05', '2026-11-12 13:33:04.06163+05', 'medium'),
	(339, 'QRY-20261112-124251-ANO7', 19, NULL, 2, 3, 'web_form', 'My Tuition Refund is • "Delayed Again"!!', '<p style="text-align: left;">THIS IS THE THIRD TIME MY TUITION REFUND HAS BEEN DELAYED!!!! á I CAN''T PAY MY RENT AND I''M GOING TO BE EVICTED BY FRIDAY!!!! I need ±$100 urgently</p>', 'Finance', 0.754, 'escalated', 1, 'false', NULL, '2026-11-12 13:42:51.248692+05', '2026-11-13 16:34:50.008538+05', 'high'),
	(340, 'QRY-20261112-124555-HIW1', 19, NULL, 4, 5, 'web_form', 'Copy of University Policy', '<p style="text-align: left;">I would like to request a copy of the university''s policy on occupational health and safety.</p>', 'Administration', 0.592, 'pending', 0, 'false', NULL, '2026-11-12 13:45:55.865638+05', '2026-11-12 13:45:55.865638+05', 'low'),
	(341, 'QRY-20261112-124848-P17X', 19, NULL, 1, 2, 'web_form', 'University Policy about Internship', '<p style="text-align: left;">I would like to inquire about the university''s policy for student internships and academic credits.</p>', 'Academic', 0.749, 'pending', 0, 'false', NULL, '2026-11-12 13:48:48.376659+05', '2026-11-12 13:48:48.376659+05', 'low'),
	(342, 'QRY-20261112-125040-W4XX', 19, NULL, 2, 3, 'web_form', 'Tuition Payment Issue', '<p style="text-align: left;">My <strong>tuition payment</strong> is showing as ''<strong>rejected</strong>'' even though I have the funds. Registration for my grad program closes tomorrow.</p>', 'Finance', 0.870, 'escalated', 1, 'false', NULL, '2026-11-12 13:50:40.959993+05', '2026-11-13 16:34:50.008538+05', 'high'),
	(343, 'QRY-20261112-125144-PDG8', 19, NULL, NULL, 1, 'web_form', 'Login for Immigration Portal', '<p style="text-align: left;">The international student orientation starts in 24 hours and I still have not received the login for the mandatory immigration portal.</p>', 'General', 0.227, 'pending', 0, 'false', NULL, '2026-11-12 13:51:44.54795+05', '2026-11-12 13:51:44.54795+05', 'high'),
	(344, 'QRY-20261112-125228-9T82', 19, NULL, 3, 4, 'web_form', 'Problem with online application', '<p style="text-align: left;">I am having trouble with the online application for the study abroad program. The ''Submit'' button isn''t working.</p>', 'Admissions', 0.324, 'pending', 0, 'false', NULL, '2026-11-12 13:52:28.111994+05', '2026-11-12 13:52:28.111994+05', 'medium'),
	(345, 'QRY-20261112-125311-4QD3', 19, NULL, 6, 7, 'web_form', 'Issue with Library Server', '<p style="text-align: left;">The library''s server has crashed and I cannot access my stored research data for my thesis defense tomorrow.</p>', 'Library', 0.421, 'escalated', 1, 'false', NULL, '2026-11-12 13:53:11.394977+05', '2026-11-13 16:34:50.008538+05', 'high'),
	(346, 'QRY-20261112-125416-DGUQ', 19, NULL, 5, 6, 'web_form', 'Policy for bringing animal', '<p style="text-align: left;">id like to know the policy for bringin a pet fish to the dorms? idk if i need a permit or what.</p>', 'Housing', 0.386, 'pending', 0, 'false', NULL, '2026-11-12 13:54:16.900187+05', '2026-11-12 13:54:16.900187+05', 'low'),
	(347, 'QRY-20261112-130319-RNZ4', 19, 22, 7, 8, 'web_form', 'Issue regarding my account', '<p style="text-align: left;">Somebody is trying to hack my student account right now. i keep getting password reset notifications every few seconds.</p>', 'Technical', 0.547, 'pending', 0, 'false', NULL, '2026-11-12 14:03:19.030507+05', '2026-11-12 14:03:19.030507+05', 'medium'),
	(348, 'QRY-20261112-131047-XN14', 19, 22, 7, 8, 'web_form', 'No MFA Code is received', '<p style="text-align: left;">the mfa code is not sending to my phone and i need to submit my final paper in 1 hour.</p>', 'Technical', 0.755, 'pending', 0, 'true', NULL, '2026-11-12 14:10:47.221046+05', '2026-11-12 15:18:36.813418+05', 'high'),
	(350, 'QRY-20261113-143125-VBUZ', 2, NULL, 5, 6, 'web_form', 'Roommate is smoking ', '<p style="text-align: left;">my roommate is <strong>smoking in the room</strong> and i am having an asthma attack. please send someone to assist immediately.</p>', 'Housing', 0.831, 'pending', 0, 'false', NULL, '2026-11-13 15:31:25.937972+05', '2026-11-13 15:31:25.937972+05', 'high'),
	(352, 'QRY-20261113-152257-UGNB', NULL, 22, 7, 8, 'email', 'You shared some Google Account data with FastEmailAutomation', 'Keep track of your Google Account data



virtualuniversity08@gmail.com

 

<!--[if !mso]><!-->

<!--[if false]><!-->


You''re receiving this email because you used Sign in with Google to sign in  
to


FastEmailAutomation


on November 12 at 11:38 AM .

This email summarizes the info you shared. There’s nothing you need to do  
right now.


<!--[if !mso]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

You''re receiving this email because you used Sign in with Google to sign in  
to


FastEmailAutomation


on November 12 at 11:38 AM .

This email summarizes the info you shared. There’s nothing you need to do  
right now.

<!--[if false]><!-->


FastEmailAutomation received this profile info



Virtual University

Name and profile picture



virtualuniversity08@gmail.com

Email address





 


This email includes the info you shared on

November 12 at 11:38 AM

If you want to stop using Sign in with Google with

FastEmailAutomation , go to your Google Account.


<!--[if !mso]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

FastEmailAutomation received this profile info

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

Virtual University

Name and profile picture

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

virtualuniversity08@gmail.com

Email address

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

<!--[if false]><!-->

 

<!--[if false]><!-->

<!--[if false]><!-->

This email includes the info you shared on

November 12 at 11:38 AM

<!--[if false]><!-->

If you want to stop using Sign in with Google with

FastEmailAutomation , go to your Google Account.

<!--[if false]><!-->


<!--[if mso]>
<v:roundrect xmlns:v="urn:schemas-microsoft-com:vml"  
xmlns:w="urn:schemas-microsoft-com:office:word"  
href="https://accounts.google.com/AccountChooser?Email=virtualuniversity08@gmail.com&continue=https%3A%2F%2Fmyaccount.google.com%2Flinkedapps%2Foverview%2FAUKa-R5yKRMhr4txvWkPO37D20M9sjbF_ax1_XWMNQ3XT0Z0ZXEfJMYyGpkEv7HmN4sumbhqoXX1yME3mMKghufEM8c%3Futm_source%3De_notification%26utm_medium%3Demail_notification"  
style="height:48px;width:268px;v-text-anchor:middle;" arcsize="125%"  
stroke="false" fillcolor="#0b57d0">
<w:anchorlock/>
<v:textbox inset="0px,0px,0px,0px">

<![endif]-->
<https://c.gle/AGSJxQxWvbzIxSG_K9FwEfmfcQxYskChAzPaq-kD_v-Rj4zolrmhjJPZRYdDB5jaEeG3muMHJQXd-vq9Es6MR-vkYrj-amikbuzieYdsCoMcNjPL4raP5ax_FhirD47odO_pBUchH7f1XAWhMyJL8FsnuPvfLO_MaQys-O5yMK63F8lciM-W--tpFFWOtGN4YCBz_XFj3dUHrtGxliSSNvGQqMMC2revY703IO0takBIYYjl5aNWCwbyQMKg3TR1332lU-GYlwQ7NWgQl8xU1rWCX2T59EqRhPfjAU1vsD8AYc-dmiowU1uldTYfPzGi_7SypfH_NtA14NyfjiA7wAe5pJWEF1IIzzmoX3T2yjnx1KVL3SxgdsTOpkFWnPqwLagGuBbznDr6qlpVBTLo3JIcMHNwgwACVM93ZcmPWZIw2bkQm-ngG69uYbmQpkq9M30dnyZ-xokgAXpQ0G5fWuttxTk-ldrlr7HfHqoO91Tm>  
Go  
to your Google Account


Review

FastEmailAutomation ’s


Privacy Policy

  and


Terms of Service

  to understand how FastEmailAutomation will process and protect your data.

If you want to delete the data you shared with

FastEmailAutomation ,

visit

FastEmailAutomation .

Safer with Google

Your Google Account protects your privacy with advanced security designed  
to keep your data safe

<!--[if !mso]><!-->

<!--[if false]><!-->

Safer with Google

Your Google Account protects your privacy with advanced security designed  
to keep your data safe


 

You received this email to let you know about important changes to your  
Google Account and services.

If you want to stop receiving these emails, you can  
<https://myaccount.google.com/communication-preferences/unsubscribe/gt/AGSJxQz0qQ-0FkbhAWkQ3npZTnDaExqgQx2Y3iMviIkklEEJCviUFviVmH8NRTKzLUgNdkyr2rpMNZ6l2P07k0Tnlh0nKksAAn-XiYIPp4TokESD1AdUZ_5IJylGzrrRuXJpKiOflFBVbJouKcj9zPAn-PTlmkfqoGWf0lR7ZLl9wtxk_e3jhtLWth-aVj2TVZGb2_kNxjU2Awnz1_C4LT9exH_9VZuINp1YX0kcYLiQ9EN0XI2Uwt_LzC9onqmsWSivdKPQR9UjcuQV4ULU65fuiL0HkcPdxLLAQGq6rqAHdB3SIcoyLkX_Sb-Vkw?utm_source=gm&utm_medium=email&auto=true>unsubscribe .

Even if you unsubscribe from these emails, you’ll continue to receive  
security alerts.

© 2026 Google LLC 1600 Amphitheatre Parkway, Mountain View, CA 94043
', 'Technical', 0.310, 'pending', 0, 'false', NULL, '2026-11-13 16:22:57.143514+05', '2026-11-13 16:22:57.143514+05', 'low'),
	(353, 'QRY-20261113-154518-RQI0', 19, 3, 2, 3, 'web_form', 'Wrongly send tuition fees', '<p style="text-align: left;">i need to report that my bank transfer for tuition was sent to the wrong school account and the <strong>late fee deadline is today</strong>.</p>', 'Finance', 0.806, 'pending', 0, 'true', NULL, '2026-11-13 16:45:18.855292+05', '2026-11-13 16:57:54.865412+05', 'high'),
	(354, 'QRY-20261113-162250-YTW6', 19, 3, 2, 3, 'email', 'Financial Aid Package Status', 'I would like to inquire about the *status of my application* for the
university''s financial aid package.
', 'Finance', 0.714, 'pending', 0, 'true', '2026-11-13 19:22:40.529716', '2026-11-13 17:22:50.317407+05', '2026-11-13 21:23:31.336858+05', 'low'),
	(355, 'QRY-20261113-180025-2F1D', 19, NULL, 5, 6, 'email', 'Issue in my dorm', 'I am calm but the sink in my dorm is overflowing and the water is reaching
the electrical outlets. I need maintenance immediately.
', 'Housing', 0.865, 'pending', 0, 'false', NULL, '2026-11-13 19:00:25.016004+05', '2026-11-13 19:00:25.016004+05', 'high'),
	(356, 'QRY-20261117-075431-KAW2', 19, 3, 2, 3, 'web_form', 'Issue with Scholarship', '<p style="text-align: left;">my <strong>scholarship disbursement</strong> is still pending on my portal even though my friends got theirs last Friday. whats the delay??</p>', 'Finance', 0.462, 'pending', 0, 'true', NULL, '2026-11-15 08:54:31+05', '2026-11-17 09:02:02.877883+05', 'high'),
	(357, 'QRY-20261117-083935-NVDU', 19, 22, 7, 8, 'email', 'Inline Assignment Submission Error', 'I don'':t know who have created this "Inline Assignment Submission" thing. I
completed the assignment in docx and when I saw it, I just click back and
now it is showing "Submitted": with no option to submit it again.  :
', 'Technical', 0.418, 'in_progress', 0, 'false', NULL, '2026-11-17 09:39:35.203709+05', '2026-11-17 09:44:25.024164+05', 'high');

-- Dumping structure for table public.user_roles
CREATE TABLE IF NOT EXISTS "user_roles" (
	"id" SERIAL NOT NULL,
	"role_id" INTEGER NOT NULL,
	"user_id" INTEGER NOT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.user_roles: 12 rows
DELETE FROM "user_roles";
INSERT INTO "user_roles" ("id", "role_id", "user_id") VALUES
	(1, 1, 1),
	(2, 2, 4),
	(3, 3, 3),
	(4, 4, 2),
	(5, 2, 4),
	(9, 4, 19),
	(10, 4, 20),
	(11, 3, 22),
	(12, 1, 23),
	(13, 4, 24),
	(14, 4, 25),
	(16, 4, 27);

-- Dumping structure for table public.users
CREATE TABLE IF NOT EXISTS "users" (
	"id" SERIAL NOT NULL,
	"student_id" VARCHAR(255) NULL DEFAULT NULL,
	"email" VARCHAR(255) NOT NULL,
	"password" VARCHAR(255) NULL DEFAULT NULL,
	"full_name" VARCHAR(255) NOT NULL,
	"department_id" INTEGER NULL DEFAULT NULL,
	"is_active" BOOLEAN NOT NULL,
	"is_student" BOOLEAN NOT NULL,
	"is_officer" BOOLEAN NOT NULL,
	"is_admin" BOOLEAN NOT NULL,
	"on_leave" BOOLEAN NOT NULL,
	"auto_reply_message" TEXT NULL DEFAULT NULL,
	"leave_start_day" DATE NULL DEFAULT NULL,
	"leave_end_day" DATE NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
	"google_sub" VARCHAR(255) NULL DEFAULT NULL,
	"profile_image" VARCHAR(500) NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("email"),
	UNIQUE ("student_id"),
	UNIQUE ("google_sub"),
	CONSTRAINT "users_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.users: 12 rows
DELETE FROM "users";
INSERT INTO "users" ("id", "student_id", "email", "password", "full_name", "department_id", "is_active", "is_student", "is_officer", "is_admin", "on_leave", "auto_reply_message", "leave_start_day", "leave_end_day", "created_at", "updated_at", "google_sub", "profile_image") VALUES
	(1, NULL, 'admin@example.com', '$argon2id$v=19$m=65536,t=3,p=4$fOHa7hNZpyiEOyvVrtyfRA$F19BHrJ7i4aPFIdae8JUsCo2HosqisJLJSqSU92VZ5E', 'Admin User', 1, 'true', 'false', 'false', 'true', 'false', NULL, NULL, NULL, '2026-08-29 16:25:16.290665+05', '2026-08-29 16:25:16.290665+05', NULL, NULL),
	(2, 'STU001', 'student@example.com', '$argon2id$v=19$m=65536,t=3,p=4$iAQ+ivthyr0qLPA4l8E1kw$Rp8KEdGCU/+WRO4Hbk+1A/0U7avPZw2sw49Wa09yQw4', 'Student User', 1, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-08-29 16:25:16.290665+05', '2026-11-12 15:53:41.613101+05', NULL, '/profile_images/bfe8cb5a853346a7a19734c0c2755fe6.jpg'),
	(3, NULL, 'officer@example.com', '$argon2id$v=19$m=65536,t=3,p=4$dbwnCDlAmcva+E1BaDygdA$yssBLasbn0m6nUdKQKm/qMSBTGgGMQlJtgwVGgkCIH0', 'Officer User', 2, 'true', 'false', 'true', 'false', 'false', 'I am currently on leave', NULL, NULL, '2026-08-29 16:25:16.290665+05', '2026-11-12 14:53:16.267314+05', NULL, NULL),
	(4, NULL, 'hod@example.com', '$argon2id$v=19$m=65536,t=3,p=4$9Nm3JRR9j1u+jySWE9PcvQ$44oOK317ZVhMthuQAC2ZNJ+7s6V7rRQbIDqJzuS/cLE', 'HOD User Updated', 2, 'true', 'false', 'true', 'false', 'false', NULL, NULL, NULL, '2026-08-29 16:25:16.290665+05', '2026-11-12 19:53:23.63085+05', NULL, NULL),
	(19, NULL, 'bc230203410tsa@vu.edu.pk', NULL, 'bc230203410 TABISH SARDAR ALI SAJWANI', NULL, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-08-31 10:56:52.47815+05', '2026-08-31 10:57:53.589195+05', '108817875214093039984', NULL),
	(20, 'STU002', 'tabishsardarali@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$4KitZXQmiL69smXRjP+EkQ$Hl+ELrXo89qtm1hN5RLBDd6ApoE183rkhihiHQ8AzUg', 'Tabish Sardar Ali', NULL, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-09-01 09:34:13.610572+05', '2026-09-01 09:34:13.610572+05', NULL, NULL),
	(22, NULL, 'tabishsajwani@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$GT+YmK8WlL+A6yj9ogD4QA$OFPmGhl70HRhLtVH6Gpzt8SsO8a8A882ZZ9OF1UqBVg', 'Tabish Officer', 7, 'true', 'false', 'true', 'false', 'false', 'I am on leave', NULL, NULL, '2026-09-01 09:49:51.643805+05', '2026-11-12 18:56:42.963277+05', NULL, NULL),
	(23, NULL, 'tabishadmin@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$gvFcnouocAkqAILyqAb91g$Z9PlHy+uFhu+AkzKAL7pZvF3NsnOs/ebC5V25RlRzuY', 'Tabish Admin', NULL, 'true', 'false', 'false', 'true', 'false', NULL, NULL, NULL, '2026-09-01 09:54:34.434779+05', '2026-09-01 09:54:34.434779+05', NULL, NULL),
	(24, 'STUD003', 'tabish8612@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$KovfmUjszKLfAfhe2trRpg$LXOqxpklAOCK6bK7qa+8WKclQfFvjzQJ+8vc85op44w', 'Tabish Student 3', NULL, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-09-01 10:48:38.437425+05', '2026-09-01 10:48:38.437425+05', NULL, NULL),
	(25, 'stud', 'tabishsajwani@hotmail.com', '$argon2id$v=19$m=65536,t=3,p=4$MFt8dw1Rem9OYHuA5+tl9g$+31PAlV45RIeBhLS0BO2FKVpSjmNGAPx0WLq7x+jEbk', 'Tabish', NULL, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-09-01 10:51:28.820958+05', '2026-09-01 10:51:28.820958+05', NULL, NULL),
	(27, 'newstudent', 'newstudent@vu.edu.pk', '$argon2id$v=19$m=65536,t=3,p=4$8/P93LpNsq6qPcHENuMGuA$pae7oN/iKWWizl2/djI6+4thteGJ14GWuBnYXZsxdQk', 'newstudent', NULL, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-09-02 09:40:08.515002+05', '2026-09-02 09:40:08.515002+05', NULL, NULL),
	(366, NULL, 'officerfinance@example.com', '$argon2id$v=19$m=65536,t=3,p=4$GT+YmK8WlL+A6yj9ogD4QA$OFPmGhl70HRhLtVH6Gpzt8SsO8a8A882ZZ9OF1UqBVg', 'Finance Officer', 2, 'true', 'false', 'true', 'false', 'true', NULL, NULL, NULL, '2026-09-25 14:41:54.996639+05', '2026-09-25 14:41:54.996639+05', NULL, NULL);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
