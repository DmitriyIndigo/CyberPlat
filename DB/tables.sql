CREATE TABLE `Users` (
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`email`)
);

CREATE TABLE `sessions` (
  `id` char(32) NOT NULL,
  `a_session` text NOT NULL,
  PRIMARY KEY (`id`)
);
