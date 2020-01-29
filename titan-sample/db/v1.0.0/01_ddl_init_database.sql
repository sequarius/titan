CREATE DATABASE titan_sample CHARACTER SET utf8mb4;

CREATE TABLE `sys_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `permission` varchar(100) DEFAULT NULL COMMENT '权限',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='权限'

CREATE TABLE `sys_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role` varchar(100) DEFAULT NULL COMMENT '角色名称',
  `description` varchar(100) DEFAULT NULL COMMENT '角色描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_USER_ROLE_ROLE_ID` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='角色'

CREATE TABLE `sys_role_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色id',
  `permission_id` bigint(20) DEFAULT NULL COMMENT '权限id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_ROLE_PERMISSION_PERMISSION_ID` (`permission_id`),
  KEY `FK_ROLE_PERMISSION_ROLE_ID` (`role_id`),
  CONSTRAINT `FK_ROLE_PERMISSION_PERMISSION_ID` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`),
  CONSTRAINT `FK_ROLE_PERMISSION_ROLE_ID` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='角色权限关系'

CREATE TABLE `sys_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` char(16) NOT NULL COMMENT '登录名',
  `password` char(32) NOT NULL COMMENT '密码',
  `password_salt` char(32) DEFAULT NULL COMMENT 'salt',
  `phone_number` char(11) DEFAULT NULL COMMENT '电话号码',
  `guid` int(11) DEFAULT '0' COMMENT '预留防坑字段',
  `locked` tinyint(1) DEFAULT '0' COMMENT '是否被冻结',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否被删除',
  `last_sign_in_ip` char(64) DEFAULT NULL COMMENT 'ip',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='用户'

CREATE TABLE `sys_user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '管理员id',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_SYSTEM_USER_ROLE_USER_ID` (`user_id`),
  KEY `FK_SYSTEM_USER_ROLE_ROLE_ID` (`role_id`),
  CONSTRAINT `FK_SYSTEM_USER_ROLE_ROLE_ID` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`),
  CONSTRAINT `FK_SYSTEM_USER_ROLE_USER_ID` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户角色关系'

