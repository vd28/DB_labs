-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'book'
-- 
-- ---

DROP TABLE IF EXISTS `book`;
		
CREATE TABLE `book` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `book_numb` INTEGER NOT NULL,
  `book_new` BINARY NOT NULL,
  `book_name` CHAR NOT NULL,
  `book_pages` INTEGER NOT NULL,
  `book_format` CHAR NOT NULL,
  `book_circulation` INTEGER NOT NULL,
  `book_data` DATE NOT NULL,
  `book_price` DOUBLE NOT NULL DEFAULT NULL,
  `book_topic_id` INTEGER NOT NULL,
  `book_category_id` INTEGER NOT NULL,
  `book_publiching_id` INTEGER NOT NULL,
  `id_topic` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'topic'
-- 
-- ---

DROP TABLE IF EXISTS `topic`;
		
CREATE TABLE `topic` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `topic` CHAR NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'category'
-- 
-- ---

DROP TABLE IF EXISTS `category`;
		
CREATE TABLE `category` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `category` CHAR NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'publiching'
-- 
-- ---

DROP TABLE IF EXISTS `publiching`;
		
CREATE TABLE `publiching` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `publiching` CHAR NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Foreign Keys 
-- ---

ALTER TABLE `book` ADD FOREIGN KEY (book_topic_id) REFERENCES `topic` (`id`);
ALTER TABLE `book` ADD FOREIGN KEY (book_category_id) REFERENCES `category` (`id`);
ALTER TABLE `book` ADD FOREIGN KEY (book_publiching_id) REFERENCES `publiching` (`id`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `book` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `topic` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `category` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `publiching` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `book` (`id`,`book_numb`,`book_new`,`book_name`,`book_pages`,`book_format`,`book_circulation`,`book_data`,`book_price`,`book_topic_id`,`book_category_id`,`book_publiching_id`,`id_topic`) VALUES
-- ('','','','','','','','','','','','','');
-- INSERT INTO `topic` (`id`,`topic`) VALUES
-- ('','');
-- INSERT INTO `category` (`id`,`category`) VALUES
-- ('','');
-- INSERT INTO `publiching` (`id`,`publiching`) VALUES
-- ('','');