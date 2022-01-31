SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP DATABASE IF EXISTS `pi2`;
CREATE DATABASE IF NOT EXISTS `pi2` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `pi2`;

CREATE TABLE `genres` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `genres` (`id`, `name`) VALUES
(1, 'Drama'),
(2, 'Crime'),
(3, 'Action');

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `year` int(11) NOT NULL,
  `rating` float NOT NULL,
  `link` varchar(255) NOT NULL,
  `genre_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `movies` (`id`, `title`, `year`, `rating`, `link`, `genre_id`) VALUES
(1, 'The Shawshank Redemption', 1994, 9.3, 'https://www.imdb.com/title/tt0111161', 1),
(2, 'The Godfather', 1972, 9.2, 'https://www.imdb.com/title/tt0068646', 2),
(5, 'The Godfather: Part II', 1974, 9, 'https://www.imdb.com/title/tt0071562', 2),
(6, 'The Dark Knight', 2008, 9, 'https://www.imdb.com/title/tt0468569', 3),
(7, 'test', 2000, 5.5, 'http://test.com', 1),
(8, 'test', 2000, 5.5, 'http://test.com', 1);


ALTER TABLE `genres`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `genre_id` (`genre_id`);


ALTER TABLE `genres`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;


ALTER TABLE `movies`
  ADD CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
