DROP DATABASE IF EXISTS `en_dos_ruedas_[APELLIDO]-[LEGAJO]`;
CREATE DATABASE `en_dos_ruedas_[APELLIDO]-[LEGAJO]` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `en_dos_ruedas_[APELLIDO]-[LEGAJO]`;
-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: en_dos_ruedas
-- ------------------------------------------------------
-- Server version	8.0.34-0ubuntu0.22.04.1

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
-- Table structure for table `Carritos`
--

DROP TABLE IF EXISTS `Carritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Carritos` (
  `id_carrito` int NOT NULL AUTO_INCREMENT,
  `fecha_hora` datetime(1) NOT NULL,
  `cod_factura` int DEFAULT NULL,
  `forma_pago` int NOT NULL,
  `nro_doc` int NOT NULL,
  PRIMARY KEY (`id_carrito`),
  KEY `fk_forma_pago_idx` (`forma_pago`),
  KEY `fk_carrito_cliente_idx` (`nro_doc`),
  CONSTRAINT `fk_carrito_cliente` FOREIGN KEY (`nro_doc`) REFERENCES `Clientes` (`nro_doc`),
  CONSTRAINT `fk_forma_pago` FOREIGN KEY (`forma_pago`) REFERENCES `FormasDePago` (`id_forma_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Clientes`
--

DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clientes` (
  `nro_doc` int NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `celular` varchar(45) DEFAULT NULL,
  `calle` varchar(45) NOT NULL,
  `nro` varchar(45) NOT NULL,
  `piso_dpto` varchar(45) DEFAULT NULL,
  `localidad` varchar(45) NOT NULL,
  `tip_doc_iden` int NOT NULL,
  `tip_doc_resp` int NOT NULL,
  PRIMARY KEY (`nro_doc`),
  KEY `Fk_tip_doc_iden_idx` (`tip_doc_iden`),
  KEY `Fk_tip_doc_resp_idx` (`tip_doc_resp`),
  CONSTRAINT `Fk_tip_doc_iden` FOREIGN KEY (`tip_doc_iden`) REFERENCES `TiposDocumentos` (`id_tip_doc`),
  CONSTRAINT `Fk_tip_doc_resp` FOREIGN KEY (`tip_doc_resp`) REFERENCES `TiposDocumentos` (`id_tip_doc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DetallesCarritos`
--

DROP TABLE IF EXISTS `DetallesCarritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DetallesCarritos` (
  `id_carrito` int NOT NULL,
  `id_detalle` int NOT NULL,
  `cod_producto` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id_carrito`,`id_detalle`),
  KEY `fk_cod_producto_idx` (`cod_producto`),
  CONSTRAINT `fk_cod_producto_detalle` FOREIGN KEY (`cod_producto`) REFERENCES `Productos` (`cod_producto`),
  CONSTRAINT `fk_id_carrito` FOREIGN KEY (`id_carrito`) REFERENCES `Carritos` (`id_carrito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FormasDePago`
--

DROP TABLE IF EXISTS `FormasDePago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FormasDePago` (
  `id_forma_pago` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`id_forma_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Kits`
--

DROP TABLE IF EXISTS `Kits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Kits` (
  `cod_producto` int NOT NULL,
  `cod_producto_rel` int NOT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`cod_producto_rel`,`cod_producto`),
  KEY `fk_cod_producto_idx` (`cod_producto`),
  CONSTRAINT `fk_cod_producto_kits` FOREIGN KEY (`cod_producto`) REFERENCES `Productos` (`cod_producto`),
  CONSTRAINT `fk_cod_producto_rel_kits` FOREIGN KEY (`cod_producto`) REFERENCES `Productos` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PreciosHistoricos`
--

DROP TABLE IF EXISTS `PreciosHistoricos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PreciosHistoricos` (
  `cod_producto` int NOT NULL AUTO_INCREMENT,
  `fec_hora_alta` datetime NOT NULL,
  `precio` decimal(9,2) NOT NULL,
  PRIMARY KEY (`cod_producto`,`fec_hora_alta`),
  CONSTRAINT `fk_cod_producto` FOREIGN KEY (`cod_producto`) REFERENCES `Productos` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Productos`
--

DROP TABLE IF EXISTS `Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Productos` (
  `cod_producto` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  `meses_gtia` date NOT NULL,
  `stock_inicial` int NOT NULL,
  `umbral_stock` int NOT NULL,
  PRIMARY KEY (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TiposDocumentos`
--

DROP TABLE IF EXISTS `TiposDocumentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TiposDocumentos` (
  `id_tip_doc` int NOT NULL AUTO_INCREMENT,
  `descripcion_doc` varchar(45) NOT NULL,
  `tipo` varchar(45) NOT NULL,
  PRIMARY KEY (`id_tip_doc`),
  UNIQUE KEY `unique_descripcion` (`descripcion_doc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-19 11:23:56
