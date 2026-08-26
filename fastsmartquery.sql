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

-- Dumping data for table public.alembic_version: -1 rows
DELETE FROM "alembic_version";
INSERT INTO "alembic_version" ("version_num") VALUES
	('6685287f6456');

-- Dumping data for table public.categories: -1 rows
DELETE FROM "categories";
INSERT INTO "categories" ("id", "name", "description", "department_id", "created_at", "updated_at") VALUES
	(1, 'billing', 'Billing related queries', 1, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(2, 'refund', 'refund related queries', 1, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(3, 'payment failure', 'payment failure related queries', 1, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(4, 'invoice', 'invoice related queries', 1, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(5, 'subscription', 'subscription related queries', 1, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(6, 'technical', 'technical related queries', 2, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(7, 'bug report', 'bug report related queries', 2, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(8, 'performance issue', 'performance related queries', 2, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(9, 'outage', 'outage related queries', 2, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(10, 'integration issue', 'integration related queries', 2, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(11, 'account', 'account related queries', 3, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(12, 'login issues', 'login issues related queries', 3, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(13, 'security', 'security related queries', 3, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(14, 'profile update', 'profile update related queries', 3, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(15, 'general', 'general related queries', 4, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(16, 'feedback', 'feedback related queries', 4, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(17, 'feature request', 'feature request related queries', 4, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(18, 'complaint', 'complaint related queries', 4, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(19, 'greeting', 'greeting related queries', 4, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(20, 'sale inquiry', 'sale inquiry related queries', 5, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(21, 'demo request', 'demo request related queries', 5, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(22, 'demo request', 'demo request related queries', 5, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(23, 'pricing question', 'pricing question related queries', 5, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05'),
	(24, 'partnership', 'partnership related queries', 5, '2026-08-25 17:38:10.339012+05', '2026-08-25 17:38:10.339012+05');

-- Dumping data for table public.departments: 5 rows
DELETE FROM "departments";
INSERT INTO "departments" ("id", "name", "description", "is_active", "created_at", "updated_at", "hod_id") VALUES
	(1, 'finance and billing', 'Queries regarding finance and billng', 'true', '2026-08-25 17:38:10.333019+05', '2026-08-25 17:38:10.333019+05', NULL),
	(2, 'technical and IT support', 'Queries regarding technical support', 'true', '2026-08-25 17:38:10.333019+05', '2026-08-25 17:38:10.333019+05', NULL),
	(3, 'student account management', 'Queries regarding account management', 'true', '2026-08-25 17:38:10.333019+05', '2026-08-25 17:38:10.333019+05', NULL),
	(4, 'general administration', 'Queries regarding customer relation and general queries', 'true', '2026-08-25 17:38:10.333019+05', '2026-08-25 17:38:10.333019+05', NULL),
	(5, 'sales', 'Queries regarding sales queries', 'true', '2026-08-25 17:38:10.333019+05', '2026-08-25 17:38:10.333019+05', NULL);

-- Dumping data for table public.roles: -1 rows
DELETE FROM "roles";
INSERT INTO "roles" ("id", "name") VALUES
	(1, 'admin'),
	(2, 'hod'),
	(3, 'officer'),
	(4, 'student');

-- Dumping data for table public.tickets: 3 rows
DELETE FROM "tickets";
INSERT INTO "tickets" ("id", "tracking_id", "student_id", "assigned_id", "department_id", "category_id", "channel", "subject", "body", "intent", "confidence_level", "status", "escalation_level", "awaiting_student_input", "resolved_at", "created_at", "updated_at") VALUES
	(1, 'QRY-20260825-181035-I91O', 1, 5, 2, 1, 'web_form', 'Charged Twice', 'I paid my university fees but the amount was deducted twice', 'billing', 0.500, 'open', 0, 'false', NULL, '2026-08-25 18:10:35.684291+05', '2026-08-25 18:28:41.132884+05'),
	(2, 'QRY-20260825-181137-6S78', 2, 3, 1, 1, 'web_form', 'Charged Twice', 'I paid my university fees but the amount was deducted twice', 'billing', 0.500, 'open', 0, 'false', NULL, '2026-08-25 18:11:37.775375+05', '2026-08-25 18:11:37.775375+05'),
	(3, 'QRY-20260825-183856-GU3M', 2, 3, 1, 1, 'web_form', 'Urgent: Challan Payment Verification & Late Fee Fine', 'Respected Sir, I paid my semester fee voucher yesterday via mobile banking, but my LMS account still shows an unpaid status and has applied a Rs. 1000 late fine. Attached is my bank receipt. Kindly update my fee status.', 'billing', 0.438, 'open', 0, 'false', NULL, '2026-08-25 18:38:56.792421+05', '2026-08-25 18:38:56.792421+05'),
	(4, 'QRY-20260826-153536-28EC', 2, NULL, 4, 15, 'web_form', 'Paid the invoice', 'I have paid my fees but my LMS account is still block. Please unblock it', 'general', 0.398, 'open', 0, 'false', NULL, '2026-08-26 15:35:36.364432+05', '2026-08-26 15:35:36.364432+05'),
	(5, 'QRY-20260826-153719-7EJ6', 2, 3, 1, 1, 'web_form', 'Urgent: Challan Payment Verification & Late Fee Fine', 'Respected Sir, I paid my semester fee voucher yesterday via mobile banking, but my LMS account still shows an unpaid status and has applied a Rs. 1000 late fine. Attached is my bank receipt. Kindly update my fee status', 'billing', 0.438, 'open', 0, 'false', NULL, '2026-08-26 15:37:19.364241+05', '2026-08-26 15:37:19.364241+05'),
	(6, 'QRY-20260826-153829-EF0R', 2, 3, 1, 1, 'web_form', 'Urgent: Challan Payment Verification & Late Fee Fine', 'Respected Sir, I paid my semester fee voucher yesterday via mobile banking, but my LMS account still shows an unpaid status and has applied a Rs. 1000 late fine. Attached is my bank receipt. Kindly update my fee status.', 'billing', 0.438, 'open', 0, 'false', NULL, '2026-08-26 15:38:29.862662+05', '2026-08-26 15:38:29.862662+05'),
	(7, 'QRY-20260826-153913-GRJV', 2, 3, 1, 1, 'web_form', 'I have been Charged Twice', 'I paid my university fees but the amount was deducted twice', 'billing', 0.500, 'open', 0, 'false', NULL, '2026-08-26 15:39:13.840922+05', '2026-08-26 15:39:13.840922+05');

-- Dumping data for table public.user_roles: 6 rows
DELETE FROM "user_roles";
INSERT INTO "user_roles" ("id", "role_id", "user_id") VALUES
	(1, 1, 1),
	(2, 2, 4),
	(3, 3, 3),
	(4, 4, 2),
	(5, 3, 4),
	(6, 3, 5);

-- Dumping data for table public.users: 7 rows
DELETE FROM "users";
INSERT INTO "users" ("id", "student_id", "email", "password", "full_name", "department_id", "is_active", "is_student", "is_officer", "is_admin", "on_leave", "auto_reply_message", "leave_start_day", "leave_end_day", "created_at", "updated_at") VALUES
	(1, NULL, 'admin@example.com', '$argon2id$v=19$m=65536,t=3,p=4$Z4DFWqOfdtYllNygid81EA$lDT5jy3maVddMpYXgAuumsJKlJ9rqWllG/zocPoZvHQ', 'Admin User', 1, 'true', 'false', 'false', 'true', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05'),
	(2, 'STU001', 'student@example.com', '$argon2id$v=19$m=65536,t=3,p=4$tGV+FuVB0KvvD+zWSS9hSg$awbZ+Y1jERkK0vCB6LT7O1BAy/g4vPC42rPKiBk0QMs', 'Student User', 1, 'true', 'true', 'false', 'false', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05'),
	(3, NULL, 'officer@example.com', '$argon2id$v=19$m=65536,t=3,p=4$cHveNhvz54gwmBJzQ2RYLA$SMdGJ6eqX2NZWKBfiEBylke5nnH1FOH0ljmZHZnzxy4', 'Finance Officer User', 1, 'true', 'false', 'true', 'false', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05'),
	(4, NULL, 'hod@example.com', '$argon2id$v=19$m=65536,t=3,p=4$T7ObkFXJ/SGYPnV9geKfbQ$Beadb9G/ZG0e7dsrvcA8NFo9MYWbcPnTBdA9PX1n/+4', 'HOD User', 3, 'true', 'false', 'true', 'false', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05'),
	(5, NULL, 'officer123@example.com', '$argon2id$v=19$m=65536,t=3,p=4$cHveNhvz54gwmBJzQ2RYLA$SMdGJ6eqX2NZWKBfiEBylke5nnH1FOH0ljmZHZnzxy4', 'Technical Officer User', 2, 'true', 'false', 'true', 'false', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05'),
	(6, NULL, 'officer456@example.com', '$argon2id$v=19$m=65536,t=3,p=4$cHveNhvz54gwmBJzQ2RYLA$SMdGJ6eqX2NZWKBfiEBylke5nnH1FOH0ljmZHZnzxy4', 'Another Finance Officer User', 1, 'true', 'false', 'true', 'false', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05'),
	(7, NULL, 'officer789@example.com', '$argon2id$v=19$m=65536,t=3,p=4$cHveNhvz54gwmBJzQ2RYLA$SMdGJ6eqX2NZWKBfiEBylke5nnH1FOH0ljmZHZnzxy4', 'Yet Another Finance Officer User', 1, 'true', 'false', 'true', 'false', 'false', NULL, NULL, NULL, '2026-08-25 17:38:10.611126+05', '2026-08-25 17:38:10.611126+05');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
