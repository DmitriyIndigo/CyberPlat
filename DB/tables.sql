База данных: `CyberPlat`

Структура таблицы `Users`

CREATE TABLE `Users` (
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`email`)
);

Структура таблицы `sessions`

CREATE TABLE `sessions` (
  `id` char(32) NOT NULL,
  `a_session` text NOT NULL,
  PRIMARY KEY (`id`)
);
