-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: hospital_management_system
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing` (
  `bill_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `appointment_id` int DEFAULT NULL,
  `admission_id` int DEFAULT NULL,
  `bill_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `consultation_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `medicine_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `room_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `test_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `payment_status` varchar(20) NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`bill_id`),
  KEY `fk_billing_patient` (`patient_id`),
  KEY `fk_billing_appointment` (`appointment_id`),
  KEY `fk_billing_admission` (`admission_id`),
  CONSTRAINT `fk_billing_admission` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`admission_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_billing_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_billing_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_billing_consultation` CHECK ((`consultation_fee` >= 0)),
  CONSTRAINT `chk_billing_discount` CHECK ((`discount` >= 0)),
  CONSTRAINT `chk_billing_medicine` CHECK ((`medicine_fee` >= 0)),
  CONSTRAINT `chk_billing_payment_status` CHECK ((`payment_status` in (_cp850'Pending',_cp850'Partial',_cp850'Paid',_cp850'Cancelled'))),
  CONSTRAINT `chk_billing_room` CHECK ((`room_fee` >= 0)),
  CONSTRAINT `chk_billing_tax` CHECK ((`tax` >= 0)),
  CONSTRAINT `chk_billing_test` CHECK ((`test_fee` >= 0)),
  CONSTRAINT `chk_billing_total` CHECK ((`total_amount` = (((((`consultation_fee` + `medicine_fee`) + `room_fee`) + `test_fee`) + `tax`) - `discount`)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-12 23:42:08
