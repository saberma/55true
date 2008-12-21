CREATE TABLE `answers` (
  `id` int(11) NOT NULL auto_increment,
  `content` varchar(255) default NULL,
  `question_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6562002 DEFAULT CHARSET=utf8;

CREATE TABLE `page_views` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `request_url` varchar(255) default NULL,
  `ip_address` varchar(255) default NULL,
  `referer` varchar(255) default NULL,
  `user_agent` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL auto_increment,
  `content` varchar(255) default NULL,
  `is_answered` tinyint(1) default '0',
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7644387 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `login` varchar(255) default NULL,
  `remember_token` varchar(255) default NULL,
  `crypted_password` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1830235195 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20080709153806');

INSERT INTO schema_migrations (version) VALUES ('20080714122101');

INSERT INTO schema_migrations (version) VALUES ('20080730152126');

INSERT INTO schema_migrations (version) VALUES ('20080802124608');

INSERT INTO schema_migrations (version) VALUES ('20080927133556');