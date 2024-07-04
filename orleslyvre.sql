-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 04, 2024 at 05:16 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `orleslyvre`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id_cat` int(11) NOT NULL,
  `label_cat` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id_cat`, `label_cat`) VALUES
(1, 'Books'),
(2, 'Movies'),
(3, 'Series'),
(4, 'Music');

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id_item` int(11) NOT NULL,
  `name_item` varchar(50) NOT NULL,
  `avg_rating_item` varchar(50) DEFAULT '0',
  `desc_item` varchar(500) DEFAULT NULL,
  `id_cat` int(11) NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`id_item`, `name_item`, `avg_rating_item`, `desc_item`, `id_cat`, `createdAt`) VALUES
(2, 'divergent', '2.5', '1995 book, fantastic', 1, '2024-07-03 14:13:09'),
(3, 'kiriko', '2.5', 'fantastic music talking about dijsiio', 4, '2024-07-03 14:13:09'),
(6, 'phineas & ferb', '1.5', 'Movie inspired by disnep cartoon ', 2, '2024-07-03 14:14:51'),
(7, 'dankechen', '3.0', 'deutsh book by hansick flicken a autor that spend his life ...', 1, '2024-07-04 11:14:49'),
(8, 'lord of the rings', '0', '2022 american movie inspired by lord of the rings book', 2, '2024-07-04 11:46:41'),
(9, 'kingdom fall', '0', '2012 movie by Christopher takistan', 2, '2024-07-04 15:35:47'),
(10, 'sjoe', '0', 'testets', 1, '2024-07-04 16:54:36'),
(11, 'sara perche', '0', 'music italian eeee bora bora comme', 4, '2024-07-04 17:14:16');

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE `rating` (
  `id_rating` int(11) NOT NULL,
  `val_rating` int(11) NOT NULL,
  `name_rating` varchar(50) DEFAULT NULL,
  `id_item` int(11) NOT NULL,
  `comment_rating` varchar(500) DEFAULT NULL
) ;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`id_rating`, `val_rating`, `name_rating`, `id_item`, `comment_rating`) VALUES
(6, 5, 'kachkala', 2, NULL),
(7, 2, 'hoziam', 2, NULL),
(8, 2, 'hankocha', 2, NULL),
(9, 2, 'sandilifruit', 2, NULL),
(10, 2, 'erdokhan', 2, NULL),
(11, 2, 'sandokhan', 2, NULL),
(12, 2, 'tikchbila', 2, NULL),
(13, 2, 'tiwliwla', 2, NULL),
(14, 2, 'maktloni', 2, NULL),
(15, 2, 'mahyawni', 2, NULL),
(16, 5, 'herlkass', 2, NULL),
(17, 5, 'liatawni', 3, NULL),
(18, 0, 'walhrami', 3, NULL),
(19, 5, 'maymotchi', 5, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id_cat`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_item`),
  ADD UNIQUE KEY `name_item` (`name_item`),
  ADD KEY `id_cat` (`id_cat`);

--
-- Indexes for table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id_rating`),
  ADD KEY `id_item` (`id_item`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id_cat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `id_rating` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`id_cat`) REFERENCES `category` (`id_cat`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
