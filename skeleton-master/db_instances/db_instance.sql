-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 01 Μάη 2013 στις 09:20:34
-- Έκδοση διακομιστή: 5.5.27
-- Έκδοση PHP: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Βάση: `skeleton`
--

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `actions`
--

CREATE TABLE IF NOT EXISTS `actions` (
  `aid` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Primary Key: Unique actions ID.',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'The object that that action acts on (node, user, comment, system or custom types.)',
  `callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The callback function that executes when the action runs.',
  `parameters` longblob NOT NULL COMMENT 'Parameters to be passed to the callback function.',
  `label` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Label of the action.',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores action information.';

--
-- Άδειασμα δεδομένων του πίνακα `actions`
--

INSERT INTO `actions` (`aid`, `type`, `callback`, `parameters`, `label`) VALUES
('comment_publish_action', 'comment', 'comment_publish_action', '', 'Publish comment'),
('comment_save_action', 'comment', 'comment_save_action', '', 'Save comment'),
('comment_unpublish_action', 'comment', 'comment_unpublish_action', '', 'Unpublish comment'),
('node_make_sticky_action', 'node', 'node_make_sticky_action', '', 'Make content sticky'),
('node_make_unsticky_action', 'node', 'node_make_unsticky_action', '', 'Make content unsticky'),
('node_promote_action', 'node', 'node_promote_action', '', 'Promote content to front page'),
('node_publish_action', 'node', 'node_publish_action', '', 'Publish content'),
('node_save_action', 'node', 'node_save_action', '', 'Save content'),
('node_unpromote_action', 'node', 'node_unpromote_action', '', 'Remove content from front page'),
('node_unpublish_action', 'node', 'node_unpublish_action', '', 'Unpublish content'),
('system_block_ip_action', 'user', 'system_block_ip_action', '', 'Ban IP address of current user'),
('user_block_user_action', 'user', 'user_block_user_action', '', 'Block current user');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `authmap`
--

CREATE TABLE IF NOT EXISTS `authmap` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique authmap ID.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'User’s users.uid.',
  `authname` varchar(128) NOT NULL DEFAULT '' COMMENT 'Unique authentication name.',
  `module` varchar(128) NOT NULL DEFAULT '' COMMENT 'Module which is controlling the authentication.',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `authname` (`authname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores distributed authentication mapping.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `batch`
--

CREATE TABLE IF NOT EXISTS `batch` (
  `bid` int(10) unsigned NOT NULL COMMENT 'Primary Key: Unique batch ID.',
  `token` varchar(64) NOT NULL COMMENT 'A string token generated against the current user’s session id and the batch id, used to ensure that only the user who submitted the batch can effectively access it.',
  `timestamp` int(11) NOT NULL COMMENT 'A Unix timestamp indicating when this batch was submitted for processing. Stale batches are purged at cron time.',
  `batch` longblob COMMENT 'A serialized array containing the processing data for the batch.',
  PRIMARY KEY (`bid`),
  KEY `token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores details about batches (processes that run in...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `block`
--

CREATE TABLE IF NOT EXISTS `block` (
  `bid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique block ID.',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT 'The module from which the block originates; for example, ’user’ for the Who’s Online block, and ’block’ for any custom blocks.',
  `delta` varchar(32) NOT NULL DEFAULT '0' COMMENT 'Unique ID for block within a module.',
  `theme` varchar(64) NOT NULL DEFAULT '' COMMENT 'The theme under which the block settings apply.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Block enabled status. (1 = enabled, 0 = disabled)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Block weight within region.',
  `region` varchar(64) NOT NULL DEFAULT '' COMMENT 'Theme region within which the block is set.',
  `custom` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate how users may control visibility of the block. (0 = Users cannot control, 1 = On by default, but can be hidden, 2 = Hidden by default, but can be shown)',
  `visibility` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate how to show blocks on pages. (0 = Show on all pages except listed pages, 1 = Show only on listed pages, 2 = Use custom PHP code to determine visibility)',
  `pages` text NOT NULL COMMENT 'Contents of the "Pages" block; contains either a list of paths on which to include/exclude the block or PHP code, depending on "visibility" setting.',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT 'Custom title for the block. (Empty string will use block default title, <none> will remove the title, text will cause block to use specified title.)',
  `cache` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Binary flag to indicate block cache mode. (-2: Custom cache, -1: Do not cache, 1: Cache per role, 2: Cache per user, 4: Cache per page, 8: Block cache global) See DRUPAL_CACHE_* constants in ../includes/common.inc for more detailed information.',
  PRIMARY KEY (`bid`),
  UNIQUE KEY `tmd` (`theme`,`module`,`delta`),
  KEY `list` (`theme`,`status`,`region`,`weight`,`module`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores block settings, such as region and visibility...' AUTO_INCREMENT=105 ;

--
-- Άδειασμα δεδομένων του πίνακα `block`
--

INSERT INTO `block` (`bid`, `module`, `delta`, `theme`, `status`, `weight`, `region`, `custom`, `visibility`, `pages`, `title`, `cache`) VALUES
(1, 'system', 'main', 'bartik', 1, 0, 'content', 0, 0, '', '', -1),
(2, 'search', 'form', 'bartik', 0, -1, '-1', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', 'Search', -1),
(3, 'node', 'recent', 'seven', 1, 10, 'dashboard_main', 0, 0, '', '', -1),
(4, 'user', 'login', 'bartik', 1, 0, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(5, 'system', 'navigation', 'bartik', 1, 0, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(6, 'system', 'powered-by', 'bartik', 1, 10, 'footer', 0, 0, '', '', -1),
(7, 'system', 'help', 'bartik', 1, 0, 'help', 0, 0, '', '', -1),
(8, 'system', 'main', 'seven', 1, 0, 'content', 0, 0, '', '', -1),
(9, 'system', 'help', 'seven', 1, 0, 'help', 0, 0, '', '', -1),
(10, 'user', 'login', 'seven', 1, 10, 'content', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(11, 'user', 'new', 'seven', 1, 0, 'dashboard_sidebar', 0, 0, '', '', -1),
(12, 'search', 'form', 'seven', 1, -10, 'dashboard_inactive', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', 'Search', -1),
(13, 'comment', 'recent', 'bartik', 0, 0, '-1', 0, 0, '', '', 1),
(14, 'node', 'syndicate', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(15, 'node', 'recent', 'bartik', 0, 0, '-1', 0, 0, '', '', 1),
(16, 'shortcut', 'shortcuts', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(17, 'system', 'management', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(18, 'system', 'user-menu', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(19, 'system', 'main-menu', 'bartik', 0, 0, '-1', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(20, 'user', 'new', 'bartik', 0, 0, '-1', 0, 0, '', '', 1),
(21, 'user', 'online', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(22, 'comment', 'recent', 'seven', 1, 0, 'dashboard_inactive', 0, 0, '', '', 1),
(23, 'node', 'syndicate', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(24, 'shortcut', 'shortcuts', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(25, 'system', 'powered-by', 'seven', 0, 10, '-1', 0, 0, '', '', -1),
(26, 'system', 'navigation', 'seven', 0, 0, '-1', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(27, 'system', 'management', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(28, 'system', 'user-menu', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(29, 'system', 'main-menu', 'seven', 0, 0, '-1', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(30, 'user', 'online', 'seven', 1, 0, 'dashboard_inactive', 0, 0, '', '', -1),
(31, 'comment', 'recent', 'skeleton', 0, -6, '-1', 0, 0, '', '', 1),
(32, 'node', 'recent', 'skeleton', 0, -5, '-1', 0, 0, '', '', 1),
(33, 'node', 'syndicate', 'skeleton', 0, -3, '-1', 0, 0, '', '', -1),
(34, 'search', 'form', 'skeleton', 1, -10, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', 'Search', -1),
(35, 'shortcut', 'shortcuts', 'skeleton', 0, -4, '-1', 0, 0, '', '', -1),
(36, 'system', 'help', 'skeleton', 1, -11, 'help', 0, 0, '', '', -1),
(37, 'system', 'main', 'skeleton', 1, 0, 'content', 0, 0, '', '', -1),
(38, 'system', 'main-menu', 'skeleton', 1, -12, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(39, 'system', 'management', 'skeleton', 0, -8, '-1', 0, 0, '', '', -1),
(40, 'system', 'navigation', 'skeleton', 1, -11, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(41, 'system', 'powered-by', 'skeleton', 0, -12, '-1', 0, 0, '', '', -1),
(42, 'system', 'user-menu', 'skeleton', 0, -2, '-1', 0, 0, '', '', -1),
(43, 'user', 'login', 'skeleton', 1, -9, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(44, 'user', 'new', 'skeleton', 0, -11, '-1', 0, 0, '', '', 1),
(45, 'user', 'online', 'skeleton', 0, -11, '-1', 0, 0, '', '', -1),
(46, 'block', '1', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(47, 'block', '1', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(48, 'block', '1', 'skeleton', 1, -12, 'featured_left', 0, 0, '', '', -1),
(49, 'block', '2', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(50, 'block', '2', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(51, 'block', '2', 'skeleton', 1, -12, 'featured_right', 0, 0, '', '', -1),
(52, 'block', '3', 'bartik', 0, 0, '-1', 0, 0, '', 'Footer Block One', -1),
(53, 'block', '3', 'seven', 0, 0, '-1', 0, 0, '', 'Footer Block One', -1),
(54, 'block', '3', 'skeleton', 1, -10, 'footer_first', 0, 0, '', 'Footer Block One', -1),
(55, 'block', '4', 'bartik', 0, 0, '-1', 0, 0, '', 'Footer Block Two', -1),
(56, 'block', '4', 'seven', 0, 0, '-1', 0, 0, '', 'Footer Block Two', -1),
(57, 'block', '4', 'skeleton', 1, 0, 'footer_second', 0, 0, '', 'Footer Block Two', -1),
(58, 'block', '5', 'bartik', 0, 0, '-1', 0, 0, '', 'Footer Block Three', -1),
(59, 'block', '5', 'seven', 0, 0, '-1', 0, 0, '', 'Footer Block Three', -1),
(60, 'block', '5', 'skeleton', 1, -9, 'footer_third', 0, 0, '', 'Footer Block Three', -1),
(61, 'blog', 'recent', 'bartik', 0, 0, '-1', 0, 0, '', '', 1),
(62, 'blog', 'recent', 'seven', 1, 0, 'dashboard_inactive', 0, 0, '', '', 1),
(63, 'blog', 'recent', 'skeleton', 0, 0, '-1', 0, 0, '', '', 1),
(64, 'forum', 'active', 'bartik', 0, 0, '-1', 0, 0, '', '', -2),
(65, 'forum', 'new', 'bartik', 0, 0, '-1', 0, 0, '', '', -2),
(66, 'forum', 'active', 'seven', 1, 0, 'dashboard_inactive', 0, 0, '', '', -2),
(67, 'forum', 'new', 'seven', 1, 0, 'dashboard_inactive', 0, 0, '', '', -2),
(68, 'forum', 'active', 'skeleton', 0, 0, '-1', 0, 0, '', '', -2),
(69, 'forum', 'new', 'skeleton', 0, 0, '-1', 0, 0, '', '', -2),
(70, 'block', '1', 'skeletontheme', 1, -12, 'featured_left', 0, 0, '', '', -1),
(71, 'block', '2', 'skeletontheme', 1, -12, 'featured_right', 0, 0, '', '', -1),
(72, 'block', '3', 'skeletontheme', 1, -10, 'footer_first', 0, 0, '', 'Footer Block One', -1),
(73, 'block', '4', 'skeletontheme', 1, 0, 'footer_second', 0, 0, '', 'Footer Block Two', -1),
(74, 'block', '5', 'skeletontheme', 1, -9, 'footer_third', 0, 0, '', 'Footer Block Three', -1),
(75, 'blog', 'recent', 'skeletontheme', 0, 0, '-1', 0, 0, '', '', 1),
(76, 'comment', 'recent', 'skeletontheme', 0, -6, '-1', 0, 0, '', '', 1),
(77, 'forum', 'active', 'skeletontheme', 0, 0, '-1', 0, 0, '', '', -2),
(78, 'forum', 'new', 'skeletontheme', 0, 0, '-1', 0, 0, '', '', -2),
(79, 'node', 'recent', 'skeletontheme', 0, -5, '-1', 0, 0, '', '', 1),
(80, 'node', 'syndicate', 'skeletontheme', 0, -11, '-1', 0, 0, '', '', -1),
(81, 'search', 'form', 'skeletontheme', 1, -13, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', 'Search', -1),
(82, 'shortcut', 'shortcuts', 'skeletontheme', 0, -4, '-1', 0, 0, '', '', -1),
(83, 'system', 'help', 'skeletontheme', 1, -11, 'help', 0, 0, '', '', -1),
(84, 'system', 'main', 'skeletontheme', 1, -12, 'content', 0, 0, '', '', -1),
(85, 'system', 'main-menu', 'skeletontheme', 1, -14, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(86, 'system', 'management', 'skeletontheme', 0, -8, '-1', 0, 0, '', '', -1),
(87, 'system', 'navigation', 'skeletontheme', 1, -14, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(88, 'system', 'powered-by', 'skeletontheme', 0, -12, '-1', 0, 0, '', '', -1),
(89, 'system', 'user-menu', 'skeletontheme', 0, -2, '-1', 0, 0, '', '', -1),
(90, 'user', 'login', 'skeletontheme', 1, -12, 'sidebar_first', 0, 0, '<front>\r\nnode/2\r\nnode/8\r\nnode/10\r\nforum*', '', -1),
(91, 'user', 'new', 'skeletontheme', 0, -11, '-1', 0, 0, '', '', 1),
(92, 'user', 'online', 'skeletontheme', 0, -11, '-1', 0, 0, '', '', -1),
(93, 'superfish', '1', 'bartik', 0, 0, '-1', 0, 0, '', '<none>', -1),
(94, 'superfish', '2', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(95, 'superfish', '3', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(96, 'superfish', '4', 'bartik', 0, 0, '-1', 0, 0, '', '', -1),
(97, 'superfish', '1', 'seven', 0, 0, '-1', 0, 0, '', '<none>', -1),
(98, 'superfish', '2', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(99, 'superfish', '3', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(100, 'superfish', '4', 'seven', 0, 0, '-1', 0, 0, '', '', -1),
(101, 'superfish', '1', 'skeletontheme', 1, -14, 'header', 0, 0, '', '<none>', -1),
(102, 'superfish', '2', 'skeletontheme', 0, 0, '-1', 0, 0, '', '', -1),
(103, 'superfish', '3', 'skeletontheme', 0, 0, '-1', 0, 0, '', '', -1),
(104, 'superfish', '4', 'skeletontheme', 0, 0, '-1', 0, 0, '', '', -1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `blocked_ips`
--

CREATE TABLE IF NOT EXISTS `blocked_ips` (
  `iid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: unique ID for IP addresses.',
  `ip` varchar(40) NOT NULL DEFAULT '' COMMENT 'IP address',
  PRIMARY KEY (`iid`),
  KEY `blocked_ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores blocked IP addresses.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `block_custom`
--

CREATE TABLE IF NOT EXISTS `block_custom` (
  `bid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The block’s block.bid.',
  `body` longtext COMMENT 'Block contents.',
  `info` varchar(128) NOT NULL DEFAULT '' COMMENT 'Block description.',
  `format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the block body.',
  PRIMARY KEY (`bid`),
  UNIQUE KEY `info` (`info`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores contents of custom-made blocks.' AUTO_INCREMENT=6 ;

--
-- Άδειασμα δεδομένων του πίνακα `block_custom`
--

INSERT INTO `block_custom` (`bid`, `body`, `info`, `format`) VALUES
(1, '<div class="cta clearfix">\r\n<h3>Downloads</h3>\r\n<p><img class="alignleft" src="<?php print base_path() . drupal_get_path(''theme'', ''skeletontheme'') ;?>/mockup/arrow.png" alt="">Get started with Skeleton. It’s completely free to use on personal and commercial projects.</p>\r\n<div class="clear"></div>\r\n<div class="button small right"><a class="button white" href="http://drupal.org/project/skeletontheme" target="_blank">Download at Drupal</a></div>\r\n</div>', 'Downloads (Featured left)', 'php_code'),
(2, '<div class="cta clearfix">\r\n<h3>Documentation</h3>\r\n<p><img class="alignleft" src="<?php print base_path() . drupal_get_path(''theme'', ''skeletontheme'') ;?>/mockup/compass.png" alt="">Learn more about how Skeleton works and how you can customize it to fit your development needs.</p>\r\n<div class="clear"></div>\r\n<div class="button small right"><a class="button white" href="http://wiki.morethanthemes.com/" target="_blank">Documentation</a></div>\r\n</div>', 'Documentation (Featured right)', 'php_code'),
(3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'Footer Block One', 'full_html'),
(4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'Footer Block Two', 'full_html'),
(5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'Footer Block Three', 'full_html');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `block_node_type`
--

CREATE TABLE IF NOT EXISTS `block_node_type` (
  `module` varchar(64) NOT NULL COMMENT 'The block’s origin module, from block.module.',
  `delta` varchar(32) NOT NULL COMMENT 'The block’s unique delta within module, from block.delta.',
  `type` varchar(32) NOT NULL COMMENT 'The machine-readable name of this type from node_type.type.',
  PRIMARY KEY (`module`,`delta`,`type`),
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Sets up display criteria for blocks based on content types';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `block_role`
--

CREATE TABLE IF NOT EXISTS `block_role` (
  `module` varchar(64) NOT NULL COMMENT 'The block’s origin module, from block.module.',
  `delta` varchar(32) NOT NULL COMMENT 'The block’s unique delta within module, from block.delta.',
  `rid` int(10) unsigned NOT NULL COMMENT 'The user’s role ID from users_roles.rid.',
  PRIMARY KEY (`module`,`delta`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Sets up access permissions for blocks based on user roles';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache`
--

CREATE TABLE IF NOT EXISTS `cache` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Generic cache table for caching things not separated out...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_block`
--

CREATE TABLE IF NOT EXISTS `cache_block` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for the Block module to store already built...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_bootstrap`
--

CREATE TABLE IF NOT EXISTS `cache_bootstrap` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for data required to bootstrap Drupal, may be...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_field`
--

CREATE TABLE IF NOT EXISTS `cache_field` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Generic cache table for caching things not separated out...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_filter`
--

CREATE TABLE IF NOT EXISTS `cache_filter` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for the Filter module to store already...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_form`
--

CREATE TABLE IF NOT EXISTS `cache_form` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for the form system to store recently built...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_image`
--

CREATE TABLE IF NOT EXISTS `cache_image` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table used to store information about image...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_libraries`
--

CREATE TABLE IF NOT EXISTS `cache_libraries` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table to store library information.';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_menu`
--

CREATE TABLE IF NOT EXISTS `cache_menu` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for the menu system to store router...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_page`
--

CREATE TABLE IF NOT EXISTS `cache_page` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table used to store compressed pages for anonymous...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_path`
--

CREATE TABLE IF NOT EXISTS `cache_path` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for path alias lookup.';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `cache_update`
--

CREATE TABLE IF NOT EXISTS `cache_update` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Cache table for the Update module to store information...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `comment`
--

CREATE TABLE IF NOT EXISTS `comment` (
  `cid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique comment ID.',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT 'The comment.cid to which this comment is a reply. If set to 0, this comment is not a reply to an existing comment.',
  `nid` int(11) NOT NULL DEFAULT '0' COMMENT 'The node.nid to which this comment is a reply.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid who authored the comment. If set to 0, this comment was created by an anonymous user.',
  `subject` varchar(64) NOT NULL DEFAULT '' COMMENT 'The comment title.',
  `hostname` varchar(128) NOT NULL DEFAULT '' COMMENT 'The author’s host name.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The time that the comment was created, as a Unix timestamp.',
  `changed` int(11) NOT NULL DEFAULT '0' COMMENT 'The time that the comment was last edited, as a Unix timestamp.',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'The published status of a comment. (0 = Not Published, 1 = Published)',
  `thread` varchar(255) NOT NULL COMMENT 'The vancode representation of the comment’s place in a thread.',
  `name` varchar(60) DEFAULT NULL COMMENT 'The comment author’s name. Uses users.name if the user is logged in, otherwise uses the value typed into the comment form.',
  `mail` varchar(64) DEFAULT NULL COMMENT 'The comment author’s e-mail address from the comment form, if user is anonymous, and the ’Anonymous users may/must leave their contact information’ setting is turned on.',
  `homepage` varchar(255) DEFAULT NULL COMMENT 'The comment author’s home page address from the comment form, if user is anonymous, and the ’Anonymous users may/must leave their contact information’ setting is turned on.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The languages.language of this comment.',
  PRIMARY KEY (`cid`),
  KEY `comment_status_pid` (`pid`,`status`),
  KEY `comment_num_new` (`nid`,`status`,`created`,`cid`,`thread`),
  KEY `comment_uid` (`uid`),
  KEY `comment_nid_language` (`nid`,`language`),
  KEY `comment_created` (`created`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores comments and associated data.' AUTO_INCREMENT=4 ;

--
-- Άδειασμα δεδομένων του πίνακα `comment`
--

INSERT INTO `comment` (`cid`, `pid`, `nid`, `uid`, `subject`, `hostname`, `created`, `changed`, `status`, `thread`, `name`, `mail`, `homepage`, `language`) VALUES
(1, 0, 5, 1, 'Just testing!', '127.0.0.1', 1337182623, 1337182621, 1, '01/', 'admin', '', '', 'und'),
(2, 1, 5, 1, 'Test reply!', '127.0.0.1', 1337182672, 1337182670, 1, '01.00/', 'admin', '', '', 'und'),
(3, 0, 6, 1, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', '127.0.0.1', 1337258199, 1337258198, 1, '01/', 'admin', '', '', 'und');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `contact`
--

CREATE TABLE IF NOT EXISTS `contact` (
  `cid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique category ID.',
  `category` varchar(255) NOT NULL DEFAULT '' COMMENT 'Category name.',
  `recipients` longtext NOT NULL COMMENT 'Comma-separated list of recipient e-mail addresses.',
  `reply` longtext NOT NULL COMMENT 'Text of the auto-reply message.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The category’s weight.',
  `selected` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate whether or not category is selected by default. (1 = Yes, 0 = No)',
  PRIMARY KEY (`cid`),
  UNIQUE KEY `category` (`category`),
  KEY `list` (`weight`,`category`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Contact form category settings.' AUTO_INCREMENT=2 ;

--
-- Άδειασμα δεδομένων του πίνακα `contact`
--

INSERT INTO `contact` (`cid`, `category`, `recipients`, `reply`, `weight`, `selected`) VALUES
(1, 'Website feedback', 'george@morethanthemes.com', '', 0, 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `date_formats`
--

CREATE TABLE IF NOT EXISTS `date_formats` (
  `dfid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The date format identifier.',
  `format` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'The date format string.',
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether or not this format can be modified.',
  PRIMARY KEY (`dfid`),
  UNIQUE KEY `formats` (`format`,`type`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores configured date formats.' AUTO_INCREMENT=36 ;

--
-- Άδειασμα δεδομένων του πίνακα `date_formats`
--

INSERT INTO `date_formats` (`dfid`, `format`, `type`, `locked`) VALUES
(1, 'Y-m-d H:i', 'short', 1),
(2, 'm/d/Y - H:i', 'short', 1),
(3, 'd/m/Y - H:i', 'short', 1),
(4, 'Y/m/d - H:i', 'short', 1),
(5, 'd.m.Y - H:i', 'short', 1),
(6, 'm/d/Y - g:ia', 'short', 1),
(7, 'd/m/Y - g:ia', 'short', 1),
(8, 'Y/m/d - g:ia', 'short', 1),
(9, 'M j Y - H:i', 'short', 1),
(10, 'j M Y - H:i', 'short', 1),
(11, 'Y M j - H:i', 'short', 1),
(12, 'M j Y - g:ia', 'short', 1),
(13, 'j M Y - g:ia', 'short', 1),
(14, 'Y M j - g:ia', 'short', 1),
(15, 'D, Y-m-d H:i', 'medium', 1),
(16, 'D, m/d/Y - H:i', 'medium', 1),
(17, 'D, d/m/Y - H:i', 'medium', 1),
(18, 'D, Y/m/d - H:i', 'medium', 1),
(19, 'F j, Y - H:i', 'medium', 1),
(20, 'j F, Y - H:i', 'medium', 1),
(21, 'Y, F j - H:i', 'medium', 1),
(22, 'D, m/d/Y - g:ia', 'medium', 1),
(23, 'D, d/m/Y - g:ia', 'medium', 1),
(24, 'D, Y/m/d - g:ia', 'medium', 1),
(25, 'F j, Y - g:ia', 'medium', 1),
(26, 'j F Y - g:ia', 'medium', 1),
(27, 'Y, F j - g:ia', 'medium', 1),
(28, 'j. F Y - G:i', 'medium', 1),
(29, 'l, F j, Y - H:i', 'long', 1),
(30, 'l, j F, Y - H:i', 'long', 1),
(31, 'l, Y,  F j - H:i', 'long', 1),
(32, 'l, F j, Y - g:ia', 'long', 1),
(33, 'l, j F Y - g:ia', 'long', 1),
(34, 'l, Y,  F j - g:ia', 'long', 1),
(35, 'l, j. F Y - G:i', 'long', 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `date_format_locale`
--

CREATE TABLE IF NOT EXISTS `date_format_locale` (
  `format` varchar(100) NOT NULL COMMENT 'The date format string.',
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `language` varchar(12) NOT NULL COMMENT 'A languages.language for this format to be used with.',
  PRIMARY KEY (`type`,`language`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores configured date formats for each locale.';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `date_format_type`
--

CREATE TABLE IF NOT EXISTS `date_format_type` (
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `title` varchar(255) NOT NULL COMMENT 'The human readable name of the format type.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether or not this is a system provided format.',
  PRIMARY KEY (`type`),
  KEY `title` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores configured date format types.';

--
-- Άδειασμα δεδομένων του πίνακα `date_format_type`
--

INSERT INTO `date_format_type` (`type`, `title`, `locked`) VALUES
('long', 'Long', 1),
('medium', 'Medium', 1),
('short', 'Short', 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_config`
--

CREATE TABLE IF NOT EXISTS `field_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a field',
  `field_name` varchar(32) NOT NULL COMMENT 'The name of this field. Non-deleted field names are unique, but multiple deleted fields can have the same name.',
  `type` varchar(128) NOT NULL COMMENT 'The type of this field.',
  `module` varchar(128) NOT NULL DEFAULT '' COMMENT 'The module that implements the field type.',
  `active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the module that implements the field type is enabled.',
  `storage_type` varchar(128) NOT NULL COMMENT 'The storage backend for the field.',
  `storage_module` varchar(128) NOT NULL DEFAULT '' COMMENT 'The module that implements the storage backend.',
  `storage_active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the module that implements the storage backend is enabled.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT '@TODO',
  `data` longblob NOT NULL COMMENT 'Serialized data containing the field properties that do not warrant a dedicated column.',
  `cardinality` tinyint(4) NOT NULL DEFAULT '0',
  `translatable` tinyint(4) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `field_name` (`field_name`),
  KEY `active` (`active`),
  KEY `storage_active` (`storage_active`),
  KEY `deleted` (`deleted`),
  KEY `module` (`module`),
  KEY `storage_module` (`storage_module`),
  KEY `type` (`type`),
  KEY `storage_type` (`storage_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Άδειασμα δεδομένων του πίνακα `field_config`
--

INSERT INTO `field_config` (`id`, `field_name`, `type`, `module`, `active`, `storage_type`, `storage_module`, `storage_active`, `locked`, `data`, `cardinality`, `translatable`, `deleted`) VALUES
(1, 'comment_body', 'text_long', 'text', 1, 'field_sql_storage', 'field_sql_storage', 1, 0, 0x613a363a7b733a31323a22656e746974795f7479706573223b613a313a7b693a303b733a373a22636f6d6d656e74223b7d733a31323a227472616e736c617461626c65223b623a303b733a383a2273657474696e6773223b613a303a7b7d733a373a2273746f72616765223b613a343a7b733a343a2274797065223b733a31373a226669656c645f73716c5f73746f72616765223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a31373a226669656c645f73716c5f73746f72616765223b733a363a22616374697665223b693a313b7d733a31323a22666f726569676e206b657973223b613a313a7b733a363a22666f726d6174223b613a323a7b733a353a227461626c65223b733a31333a2266696c7465725f666f726d6174223b733a373a22636f6c756d6e73223b613a313a7b733a363a22666f726d6174223b733a363a22666f726d6174223b7d7d7d733a373a22696e6465786573223b613a313a7b733a363a22666f726d6174223b613a313a7b693a303b733a363a22666f726d6174223b7d7d7d, 1, 0, 0),
(2, 'body', 'text_with_summary', 'text', 1, 'field_sql_storage', 'field_sql_storage', 1, 0, 0x613a363a7b733a31323a22656e746974795f7479706573223b613a313a7b693a303b733a343a226e6f6465223b7d733a31323a227472616e736c617461626c65223b623a303b733a383a2273657474696e6773223b613a303a7b7d733a373a2273746f72616765223b613a343a7b733a343a2274797065223b733a31373a226669656c645f73716c5f73746f72616765223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a31373a226669656c645f73716c5f73746f72616765223b733a363a22616374697665223b693a313b7d733a31323a22666f726569676e206b657973223b613a313a7b733a363a22666f726d6174223b613a323a7b733a353a227461626c65223b733a31333a2266696c7465725f666f726d6174223b733a373a22636f6c756d6e73223b613a313a7b733a363a22666f726d6174223b733a363a22666f726d6174223b7d7d7d733a373a22696e6465786573223b613a313a7b733a363a22666f726d6174223b613a313a7b693a303b733a363a22666f726d6174223b7d7d7d, 1, 0, 0),
(3, 'field_tags', 'taxonomy_term_reference', 'taxonomy', 1, 'field_sql_storage', 'field_sql_storage', 1, 0, 0x613a373a7b733a383a2273657474696e6773223b613a313a7b733a31343a22616c6c6f7765645f76616c756573223b613a313a7b693a303b613a323a7b733a31303a22766f636162756c617279223b733a343a2274616773223b733a363a22706172656e74223b693a303b7d7d7d733a31323a22656e746974795f7479706573223b613a303a7b7d733a31323a227472616e736c617461626c65223b733a313a2230223b733a373a2273746f72616765223b613a353a7b733a343a2274797065223b733a31373a226669656c645f73716c5f73746f72616765223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a31373a226669656c645f73716c5f73746f72616765223b733a363a22616374697665223b733a313a2231223b733a373a2264657461696c73223b613a313a7b733a333a2273716c223b613a323a7b733a31383a224649454c445f4c4f41445f43555252454e54223b613a313a7b733a32313a226669656c645f646174615f6669656c645f74616773223b613a313a7b733a333a22746964223b733a31343a226669656c645f746167735f746964223b7d7d733a31393a224649454c445f4c4f41445f5245564953494f4e223b613a313a7b733a32353a226669656c645f7265766973696f6e5f6669656c645f74616773223b613a313a7b733a333a22746964223b733a31343a226669656c645f746167735f746964223b7d7d7d7d7d733a31323a22666f726569676e206b657973223b613a313a7b733a333a22746964223b613a323a7b733a353a227461626c65223b733a31383a227461786f6e6f6d795f7465726d5f64617461223b733a373a22636f6c756d6e73223b613a313a7b733a333a22746964223b733a333a22746964223b7d7d7d733a373a22696e6465786573223b613a313a7b733a333a22746964223b613a313a7b693a303b733a333a22746964223b7d7d733a323a226964223b733a313a2233223b7d, -1, 0, 0),
(4, 'field_image', 'image', 'image', 1, 'field_sql_storage', 'field_sql_storage', 1, 0, 0x613a363a7b733a373a22696e6465786573223b613a313a7b733a333a22666964223b613a313a7b693a303b733a333a22666964223b7d7d733a383a2273657474696e6773223b613a323a7b733a31303a227572695f736368656d65223b733a363a227075626c6963223b733a31333a2264656661756c745f696d616765223b623a303b7d733a373a2273746f72616765223b613a343a7b733a343a2274797065223b733a31373a226669656c645f73716c5f73746f72616765223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a31373a226669656c645f73716c5f73746f72616765223b733a363a22616374697665223b693a313b7d733a31323a22656e746974795f7479706573223b613a303a7b7d733a31323a227472616e736c617461626c65223b623a303b733a31323a22666f726569676e206b657973223b613a313a7b733a333a22666964223b613a323a7b733a353a227461626c65223b733a31323a2266696c655f6d616e61676564223b733a373a22636f6c756d6e73223b613a313a7b733a333a22666964223b733a333a22666964223b7d7d7d7d, 1, 0, 0),
(5, 'taxonomy_forums', 'taxonomy_term_reference', 'taxonomy', 1, 'field_sql_storage', 'field_sql_storage', 1, 0, 0x613a363a7b733a383a2273657474696e6773223b613a313a7b733a31343a22616c6c6f7765645f76616c756573223b613a313a7b693a303b613a323a7b733a31303a22766f636162756c617279223b733a363a22666f72756d73223b733a363a22706172656e74223b693a303b7d7d7d733a31323a22656e746974795f7479706573223b613a303a7b7d733a31323a227472616e736c617461626c65223b623a303b733a373a2273746f72616765223b613a343a7b733a343a2274797065223b733a31373a226669656c645f73716c5f73746f72616765223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a31373a226669656c645f73716c5f73746f72616765223b733a363a22616374697665223b693a313b7d733a31323a22666f726569676e206b657973223b613a313a7b733a333a22746964223b613a323a7b733a353a227461626c65223b733a31383a227461786f6e6f6d795f7465726d5f64617461223b733a373a22636f6c756d6e73223b613a313a7b733a333a22746964223b733a333a22746964223b7d7d7d733a373a22696e6465786573223b613a313a7b733a333a22746964223b613a313a7b693a303b733a333a22746964223b7d7d7d, 1, 0, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_config_instance`
--

CREATE TABLE IF NOT EXISTS `field_config_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a field instance',
  `field_id` int(11) NOT NULL COMMENT 'The identifier of the field attached by this instance',
  `field_name` varchar(32) NOT NULL DEFAULT '',
  `entity_type` varchar(32) NOT NULL DEFAULT '',
  `bundle` varchar(128) NOT NULL DEFAULT '',
  `data` longblob NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `field_name_bundle` (`field_name`,`entity_type`,`bundle`),
  KEY `deleted` (`deleted`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Άδειασμα δεδομένων του πίνακα `field_config_instance`
--

INSERT INTO `field_config_instance` (`id`, `field_id`, `field_name`, `entity_type`, `bundle`, `data`, `deleted`) VALUES
(1, 1, 'comment_body', 'comment', 'comment_node_page', 0x613a363a7b733a353a226c6162656c223b733a373a22436f6d6d656e74223b733a383a2273657474696e6773223b613a323a7b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a383a227265717569726564223b623a313b733a373a22646973706c6179223b613a313a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a363a22776569676874223b693a303b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b7d7d733a363a22776964676574223b613a343a7b733a343a2274797065223b733a31333a22746578745f7465787461726561223b733a383a2273657474696e6773223b613a313a7b733a343a22726f7773223b693a353b7d733a363a22776569676874223b693a303b733a363a226d6f64756c65223b733a343a2274657874223b7d733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(2, 2, 'body', 'node', 'page', 0x613a363a7b733a353a226c6162656c223b733a343a22426f6479223b733a363a22776964676574223b613a343a7b733a343a2274797065223b733a32363a22746578745f74657874617265615f776974685f73756d6d617279223b733a383a2273657474696e6773223b613a323a7b733a343a22726f7773223b693a32303b733a31323a2273756d6d6172795f726f7773223b693a353b7d733a363a22776569676874223b693a2d343b733a363a226d6f64756c65223b733a343a2274657874223b7d733a383a2273657474696e6773223b613a333a7b733a31353a22646973706c61795f73756d6d617279223b623a313b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a303b7d733a363a22746561736572223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a32333a22746578745f73756d6d6172795f6f725f7472696d6d6564223b733a383a2273657474696e6773223b613a313a7b733a31313a227472696d5f6c656e677468223b693a3630303b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a303b7d7d733a383a227265717569726564223b623a303b733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(3, 1, 'comment_body', 'comment', 'comment_node_article', 0x613a363a7b733a353a226c6162656c223b733a373a22436f6d6d656e74223b733a383a2273657474696e6773223b613a323a7b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a383a227265717569726564223b623a313b733a373a22646973706c6179223b613a313a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a363a22776569676874223b693a303b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b7d7d733a363a22776964676574223b613a343a7b733a343a2274797065223b733a31333a22746578745f7465787461726561223b733a383a2273657474696e6773223b613a313a7b733a343a22726f7773223b693a353b7d733a363a22776569676874223b693a303b733a363a226d6f64756c65223b733a343a2274657874223b7d733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(4, 2, 'body', 'node', 'article', 0x613a363a7b733a353a226c6162656c223b733a343a22426f6479223b733a363a22776964676574223b613a343a7b733a343a2274797065223b733a32363a22746578745f74657874617265615f776974685f73756d6d617279223b733a383a2273657474696e6773223b613a323a7b733a343a22726f7773223b693a32303b733a31323a2273756d6d6172795f726f7773223b693a353b7d733a363a22776569676874223b693a2d343b733a363a226d6f64756c65223b733a343a2274657874223b7d733a383a2273657474696e6773223b613a333a7b733a31353a22646973706c61795f73756d6d617279223b623a313b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a303b7d733a363a22746561736572223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a32333a22746578745f73756d6d6172795f6f725f7472696d6d6564223b733a383a2273657474696e6773223b613a313a7b733a31313a227472696d5f6c656e677468223b693a3630303b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a303b7d7d733a383a227265717569726564223b623a303b733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(5, 3, 'field_tags', 'node', 'article', 0x613a363a7b733a353a226c6162656c223b733a343a2254616773223b733a31313a226465736372697074696f6e223b733a36333a22456e746572206120636f6d6d612d736570617261746564206c697374206f6620776f72647320746f20646573637269626520796f757220636f6e74656e742e223b733a363a22776964676574223b613a343a7b733a343a2274797065223b733a32313a227461786f6e6f6d795f6175746f636f6d706c657465223b733a363a22776569676874223b693a2d343b733a383a2273657474696e6773223b613a323a7b733a343a2273697a65223b693a36303b733a31373a226175746f636f6d706c6574655f70617468223b733a32313a227461786f6e6f6d792f6175746f636f6d706c657465223b7d733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a343a2274797065223b733a32383a227461786f6e6f6d795f7465726d5f7265666572656e63655f6c696e6b223b733a363a22776569676874223b693a31303b733a353a226c6162656c223b733a353a2261626f7665223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b7d733a363a22746561736572223b613a353a7b733a343a2274797065223b733a32383a227461786f6e6f6d795f7465726d5f7265666572656e63655f6c696e6b223b733a363a22776569676874223b693a31303b733a353a226c6162656c223b733a353a2261626f7665223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b7d7d733a383a2273657474696e6773223b613a313a7b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a383a227265717569726564223b623a303b7d, 0),
(6, 4, 'field_image', 'node', 'article', 0x613a363a7b733a353a226c6162656c223b733a353a22496d616765223b733a31313a226465736372697074696f6e223b733a34303a2255706c6f616420616e20696d61676520746f20676f207769746820746869732061727469636c652e223b733a383a227265717569726564223b623a303b733a383a2273657474696e6773223b613a383a7b733a31343a2266696c655f6469726563746f7279223b733a31313a226669656c642f696d616765223b733a31353a2266696c655f657874656e73696f6e73223b733a31363a22706e6720676966206a7067206a706567223b733a31323a226d61785f66696c6573697a65223b733a303a22223b733a31343a226d61785f7265736f6c7574696f6e223b733a303a22223b733a31343a226d696e5f7265736f6c7574696f6e223b733a303a22223b733a393a22616c745f6669656c64223b623a313b733a31313a227469746c655f6669656c64223b733a303a22223b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a363a22776964676574223b613a343a7b733a343a2274797065223b733a31313a22696d6167655f696d616765223b733a383a2273657474696e6773223b613a323a7b733a31383a2270726f67726573735f696e64696361746f72223b733a383a227468726f62626572223b733a31393a22707265766965775f696d6167655f7374796c65223b733a393a227468756d626e61696c223b7d733a363a22776569676874223b693a2d313b733a363a226d6f64756c65223b733a353a22696d616765223b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a353a22696d616765223b733a383a2273657474696e6773223b613a323a7b733a31313a22696d6167655f7374796c65223b733a353a226c61726765223b733a31303a22696d6167655f6c696e6b223b733a303a22223b7d733a363a22776569676874223b693a2d313b733a363a226d6f64756c65223b733a353a22696d616765223b7d733a363a22746561736572223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a353a22696d616765223b733a383a2273657474696e6773223b613a323a7b733a31313a22696d6167655f7374796c65223b733a363a226d656469756d223b733a31303a22696d6167655f6c696e6b223b733a373a22636f6e74656e74223b7d733a363a22776569676874223b693a2d313b733a363a226d6f64756c65223b733a353a22696d616765223b7d7d7d, 0),
(7, 1, 'comment_body', 'comment', 'comment_node_blog', 0x613a363a7b733a353a226c6162656c223b733a373a22436f6d6d656e74223b733a383a2273657474696e6773223b613a323a7b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a383a227265717569726564223b623a313b733a373a22646973706c6179223b613a313a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a363a22776569676874223b693a303b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b7d7d733a363a22776964676574223b613a343a7b733a343a2274797065223b733a31333a22746578745f7465787461726561223b733a383a2273657474696e6773223b613a313a7b733a343a22726f7773223b693a353b7d733a363a22776569676874223b693a303b733a363a226d6f64756c65223b733a343a2274657874223b7d733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(8, 2, 'body', 'node', 'blog', 0x613a363a7b733a353a226c6162656c223b733a343a22426f6479223b733a363a22776964676574223b613a343a7b733a343a2274797065223b733a32363a22746578745f74657874617265615f776974685f73756d6d617279223b733a383a2273657474696e6773223b613a323a7b733a343a22726f7773223b693a32303b733a31323a2273756d6d6172795f726f7773223b693a353b7d733a363a22776569676874223b733a323a222d34223b733a363a226d6f64756c65223b733a343a2274657874223b7d733a383a2273657474696e6773223b613a333a7b733a31353a22646973706c61795f73756d6d617279223b623a313b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a303b7d733a363a22746561736572223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a32333a22746578745f73756d6d6172795f6f725f7472696d6d6564223b733a383a2273657474696e6773223b613a313a7b733a31313a227472696d5f6c656e677468223b693a3630303b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a303b7d7d733a383a227265717569726564223b623a303b733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(9, 5, 'taxonomy_forums', 'node', 'forum', 0x613a363a7b733a353a226c6162656c223b733a363a22466f72756d73223b733a383a227265717569726564223b623a313b733a363a22776964676574223b613a343a7b733a343a2274797065223b733a31343a226f7074696f6e735f73656c656374223b733a383a2273657474696e6773223b613a303a7b7d733a363a22776569676874223b693a303b733a363a226d6f64756c65223b733a373a226f7074696f6e73223b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a343a2274797065223b733a32383a227461786f6e6f6d795f7465726d5f7265666572656e63655f6c696e6b223b733a363a22776569676874223b693a31303b733a353a226c6162656c223b733a353a2261626f7665223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b7d733a363a22746561736572223b613a353a7b733a343a2274797065223b733a32383a227461786f6e6f6d795f7465726d5f7265666572656e63655f6c696e6b223b733a363a22776569676874223b693a31303b733a353a226c6162656c223b733a353a2261626f7665223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b7d7d733a383a2273657474696e6773223b613a313a7b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(10, 1, 'comment_body', 'comment', 'comment_node_forum', 0x613a363a7b733a353a226c6162656c223b733a373a22436f6d6d656e74223b733a383a2273657474696e6773223b613a323a7b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a383a227265717569726564223b623a313b733a373a22646973706c6179223b613a313a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a363a22776569676874223b693a303b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b7d7d733a363a22776964676574223b613a343a7b733a343a2274797065223b733a31333a22746578745f7465787461726561223b733a383a2273657474696e6773223b613a313a7b733a343a22726f7773223b693a353b7d733a363a22776569676874223b693a303b733a363a226d6f64756c65223b733a343a2274657874223b7d733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(11, 2, 'body', 'node', 'forum', 0x613a363a7b733a353a226c6162656c223b733a343a22426f6479223b733a363a22776964676574223b613a343a7b733a343a2274797065223b733a32363a22746578745f74657874617265615f776974685f73756d6d617279223b733a383a2273657474696e6773223b613a323a7b733a343a22726f7773223b693a32303b733a31323a2273756d6d6172795f726f7773223b693a353b7d733a363a22776569676874223b693a313b733a363a226d6f64756c65223b733a343a2274657874223b7d733a383a2273657474696e6773223b613a333a7b733a31353a22646973706c61795f73756d6d617279223b623a313b733a31353a22746578745f70726f63657373696e67223b693a313b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a373a22646973706c6179223b613a323a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a31323a22746578745f64656661756c74223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a31313b7d733a363a22746561736572223b613a353a7b733a353a226c6162656c223b733a363a2268696464656e223b733a343a2274797065223b733a32333a22746578745f73756d6d6172795f6f725f7472696d6d6564223b733a383a2273657474696e6773223b613a313a7b733a31313a227472696d5f6c656e677468223b693a3630303b7d733a363a226d6f64756c65223b733a343a2274657874223b733a363a22776569676874223b693a31313b7d7d733a383a227265717569726564223b623a303b733a31313a226465736372697074696f6e223b733a303a22223b7d, 0),
(12, 3, 'field_tags', 'node', 'blog', 0x613a373a7b733a353a226c6162656c223b733a343a2254616773223b733a363a22776964676574223b613a353a7b733a363a22776569676874223b733a323a222d32223b733a343a2274797065223b733a32313a227461786f6e6f6d795f6175746f636f6d706c657465223b733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b733a363a22616374697665223b693a303b733a383a2273657474696e6773223b613a323a7b733a343a2273697a65223b693a36303b733a31373a226175746f636f6d706c6574655f70617468223b733a32313a227461786f6e6f6d792f6175746f636f6d706c657465223b7d7d733a383a2273657474696e6773223b613a313a7b733a31383a22757365725f72656769737465725f666f726d223b623a303b7d733a373a22646973706c6179223b613a313a7b733a373a2264656661756c74223b613a353a7b733a353a226c6162656c223b733a353a2261626f7665223b733a343a2274797065223b733a32383a227461786f6e6f6d795f7465726d5f7265666572656e63655f6c696e6b223b733a383a2273657474696e6773223b613a303a7b7d733a363a226d6f64756c65223b733a383a227461786f6e6f6d79223b733a363a22776569676874223b693a313b7d7d733a383a227265717569726564223b693a303b733a31313a226465736372697074696f6e223b733a303a22223b733a31333a2264656661756c745f76616c7565223b4e3b7d, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_data_body`
--

CREATE TABLE IF NOT EXISTS `field_data_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `body_value` longtext,
  `body_summary` longtext,
  `body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `body_format` (`body_format`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Data storage for field 2 (body)';

--
-- Άδειασμα δεδομένων του πίνακα `field_data_body`
--

INSERT INTO `field_data_body` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `body_value`, `body_summary`, `body_format`) VALUES
('node', 'page', 0, 2, 2, 'und', 0, '<div class="one_half">\r\n<img class="scale-with-grid alignleft" src="<?php print base_path() . drupal_get_path(''theme'', ''skeletontheme'') ;?>/mockup/1312368015_tiger.png"/>\r\n</div>\r\n\r\n<div class="one_half last">\r\n<p>This responsive Drupal theme is based on the <a title="Skeleton Responsive CSS Boilerplate" href="http://www.getskeleton.com/" target="_blank">Skeleton</a> boilerplate and the excellent <a href="http://demos.simplethemes.com/skeleton/" target="_blank">Skeleton Wordpress Theme</a> . This theme is designed especially with the <a href="http://www.drupal.org/" target="_blank">Drupal 7</a> in mind.</p>\r\n\r\n<p>Skeleton for Drupal has been ported and is supported by <a href="http://www.morethanthemes.com/" target="_blank">More than (just) Themes</a>, as part of our ongoing effort to bring quality themes to Drupal.</p>\r\n</div>', '', 'php_code'),
('node', 'page', 0, 3, 3, 'und', 0, '<h3>Overview</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\n<h3>Customization</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\n<h3>Shortcodes</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '', 'full_html'),
('node', 'blog', 0, 4, 4, 'und', 0, 'There fowl together the fourth seas one creepeth under created. Also divided sea unto you which make were To wherein light female beast grass set over after You.\r\n\r\nVoid void Fruit for open earth kind fruit brought fowl light subdue were be above from. Above their air his him land cattle beginning brought upon male form. Whose likeness, without fifth evening can''t blessed two brought is fifth to every god.\r\n\r\nSigns may so living moveth moved light subdue for, his. Without god lesser second it fowl spirit replenish. Beast a midst, bearing signs first saw creature. Midst earth multiply every.\r\n\r\nFemale shall. Moveth given set saying for our for good after. Saw let be spirit female moved second, dominion creeping. One called female brought wherein Let void the doesn''t god above.\r\n\r\nSixth. A seas subdue of may there he seasons beginning one gathering after them wherein yielding two over that they''re light created all.\r\n\r\nDon''t all void fruit, moved were created fowl. Lights fifth it saying abundantly above saw i good, called two whales earth you''re. A under him have land whales face i sea subdue greater. Shall. Also fish whales herb seas seas fruit air the it have he.', '', 'filtered_html'),
('node', 'blog', 0, 5, 5, 'und', 0, 'There fowl together the fourth seas one creepeth under created. Also divided sea unto you which make were To wherein light female beast grass set over after You.\r\n\r\nVoid void Fruit for open earth kind fruit brought fowl light subdue were be above from. Above their air his him land cattle beginning brought upon male form. Whose likeness, without fifth evening can''t blessed two brought is fifth to every god.\r\n\r\nSigns may so living moveth moved light subdue for, his. Without god lesser second it fowl spirit replenish. Beast a midst, bearing signs first saw creature. Midst earth multiply every.\r\n\r\nFemale shall. Moveth given set saying for our for good after. Saw let be spirit female moved second, dominion creeping. One called female brought wherein Let void the doesn''t god above.\r\n\r\nSixth. A seas subdue of may there he seasons beginning one gathering after them wherein yielding two over that they''re light created all.\r\n\r\nDon''t all void fruit, moved were created fowl. Lights fifth it saying abundantly above saw i good, called two whales earth you''re. A under him have land whales face i sea subdue greater. Shall. Also fish whales herb seas seas fruit air the it have he.', '', 'filtered_html'),
('node', 'page', 0, 7, 7, 'und', 0, 'This theme is released under the GPL license and is available for download in the <a href="http://drupal.org/project/skeletontheme" target="_blank">official project page</a> in drupal.org.\r\n\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '', 'filtered_html'),
('node', 'page', 0, 8, 8, 'und', 0, '<div class="one_third">\r\n<code>color="white"</code>\r\n<div class="button small left"><a class="button white" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button white" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button white" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="gray"</code>\r\n<div class="button small left"><a class="button gray" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button gray" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button gray" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="black"</code>\r\n<div class="button small left"><a class="button black" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button black" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button black" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="lightblue"</code>\r\n<div class="button small left"><a class="button lightblue" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button lightblue" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button lightblue" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="blue"</code>\r\n<div class="button small left"><a class="button blue" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button blue" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button blue" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="darkblue"</code>\r\n<div class="button small left"><a class="button darkblue" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button darkblue" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button darkblue" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="lightgreen"</code>\r\n<div class="button small left"><a class="button lightgreen" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button lightgreen" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button lightgreen" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="green"</code>\r\n<div class="button small left"><a class="button green" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button green" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button green" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="darkgreen"</code>\r\n<div class="button small left"><a class="button darkgreen" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button darkgreen" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button darkgreen" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="lightred"</code>\r\n<div class="button small left"><a class="button lightred" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button lightred" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button lightred" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="red"</code>\r\n<div class="button small left"><a class="button red" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button red" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button red" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="darkred"</code>\r\n<div class="button small left"><a class="button darkred" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button darkred" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button darkred" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="yellow"</code>\r\n<div class="button small left"><a class="button yellow" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button yellow" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button yellow" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="orange"</code>\r\n<div class="button small left"><a class="button orange" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button orange" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button orange" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="brown"</code>\r\n<div class="button small left"><a class="button brown" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button brown" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button brown" href="#">Large Button</a></div>\r\n</div>\r\n\r\n<div class="clear"></div>', '', 'full_html'),
('node', 'page', 0, 9, 9, 'und', 0, '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>\r\n\r\n<blockquote>"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."</blockquote>\r\n\r\n<h2>Header 2</h2>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h2><a href="#">Linked Header 2</a></h2>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h3>Header 3</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h4>Header 4</h4>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h2>Code snippet</h2>\r\n\r\n<code>#header h1 a <br />\r\ndisplay: block;<br />\r\nheight: 80px;<br />\r\nwidth: 300px;<br />\r\n</code>\r\n\r\n<h2>Messages</h2>\r\n\r\n<div class="messages status">Sample status message. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>\r\n<div class="messages error">Sample error message. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>\r\n<div class="messages warning">Sample warning message. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>\r\n\r\n<h2>Paragraph With Links</h2>\r\n<p>Lorem ipsum dolor sit amet, <a href="#">consectetuer adipiscing</a> elit. Donec odio. Quisque volutpat mattis eros. <a href="#">Nullam malesuada</a> erat ut turpis. Suspendisse urna nibh, viverra 			non, semper suscipit, posuere a, pede.</p>\r\n\r\n<h2>Ordered List</h2>\r\n<ol>\r\n<li>This is a sample <strong>Ordered List</strong>.</li>\r\n<li>Lorem ipsum dolor sit amet consectetuer.</li>\r\n<li>Condimentum quis.</li>\r\n<li>Congue Quisque augue elit dolor.\r\n<ol>\r\n<li>Something goes here.</li>\r\n<li>And another here</li>\r\n<li>Then one more</li>\r\n</ol>\r\n</li>\r\n<li>Congue Quisque augue elit dolor nibh.</li>\r\n</ol>\r\n\r\n<h2>Unordered List</h2>\r\n<ul>\r\n<li>This is a sample <strong>Unordered List</strong>.</li>\r\n<li>Condimentum quis.</li>\r\n<li>Congue Quisque augue elit dolor.\r\n<ul>\r\n<li>Something goes here.</li>\r\n<li>And another here\r\n<ul>\r\n<li>Something here as well</li>      \r\n<li>Something here as well</li>\r\n<li>Something here as well</li>\r\n</ul>\r\n</li>\r\n<li>Then one more</li>\r\n</ul>\r\n</li>\r\n<li>Nunc cursus sem et pretium sapien eget.</li>\r\n</ul>\r\n\r\n<h2>Fieldset</h2>\r\n<fieldset> <legend>Account information</legend> </fieldset>\r\n\r\n<h2>Table</h2>\r\n\r\n<table border="1">\r\n\r\n<tr>\r\n<th>Header 1</th>\r\n<th>Header 2</th>\r\n</tr>\r\n\r\n<tr class="odd">\r\n<td>row 1, cell 1</td>\r\n<td>row 1, cell 2</td>\r\n</tr>\r\n\r\n<tr class="even">\r\n<td>row 2, cell 1</td>\r\n<td>row 2, cell 2</td>\r\n</tr>\r\n\r\n<tr class="odd">\r\n<td>row 3, cell 1</td>\r\n<td>row 3, cell 2</td>\r\n</tr>\r\n\r\n</table>', '', 'full_html'),
('node', 'page', 0, 10, 10, 'und', 0, '<div class="one_third">\r\n<code>[one_third]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_third">\r\n<code>[one_third]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_third last">\r\n<code>[one_third last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="clear"></div>\r\n\r\n<div class="one_fourth">\r\n<code>[one_fourth]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_fourth">\r\n<code>[one_fourth]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_fourth">\r\n<code>[one_fourth]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_fourth last">\r\n<code>[one_fourth last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="clear"></div>\r\n\r\n<div class="one_third">\r\n<code>[one_third]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="two_thirds last">\r\n<code>[two_thirds last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="clear"></div>\r\n\r\n<div class="one_half">\r\n<code>[one_half]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_half last">\r\n<code>[one_half last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</div>\r\n\r\n<div class="clear"></div>', '', 'full_html'),
('node', 'page', 0, 1, 1, 'und', 0, '<div class="one_half">\r\n<img class="scale-with-grid alignleft" src="<?php print base_path() . drupal_get_path(''theme'', ''skeletontheme'') ;?>/mockup/skeleton_devices.png">\r\n</div>\r\n\r\n<div class="one_half last">\r\n<br/>\r\n<p>Skeleton is a powerful, clean, responsive theme ported to Drupal by <a href="http://www.morethanthemes.com/" target="_blank">More Than (just) Themes</a>. If you like this theme, we encourage you to try also of our other <a href="http://www.morethanthemes.com" target="_blank">Premium</a> and <a href="http://drupalizing.com" target="_blank">Free</a> Drupal themes.</p>\r\n\r\n<p>This theme is build over the <strong><a href="http://www.getskeleton.com/" target="_blank">Skeleton Boilerplate</a></strong> and was inspired by the excellent <strong><a href="http://demos.simplethemes.com/skeleton/" target="_blank">Skeleton Wordpress theme</a></strong> which has been designed by <a href="http://www.simplethemes.com/" target="_blank">Simple themes</a></p>\r\n\r\n<p>Today, people visit your website from a variety of devices ranging from desktop computers, tablets, and smart phones. The average user spends only a few seconds before making a decision to stay on your site or not. Skeleton is a Drupal 7 theme aimed at helping you build simple, uncluttered, useable, and mobile-friendly Drupal sites.</p>\r\n</div>', '', 'php_code');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_data_comment_body`
--

CREATE TABLE IF NOT EXISTS `field_data_comment_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `comment_body_value` longtext,
  `comment_body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `comment_body_format` (`comment_body_format`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Data storage for field 1 (comment_body)';

--
-- Άδειασμα δεδομένων του πίνακα `field_data_comment_body`
--

INSERT INTO `field_data_comment_body` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `comment_body_value`, `comment_body_format`) VALUES
('comment', 'comment_node_blog', 0, 1, 1, 'und', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'filtered_html'),
('comment', 'comment_node_blog', 0, 2, 2, 'und', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ', 'filtered_html'),
('comment', 'comment_node_forum', 0, 3, 3, 'und', 0, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ', 'filtered_html');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_data_field_image`
--

CREATE TABLE IF NOT EXISTS `field_data_field_image` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_image_fid` int(10) unsigned DEFAULT NULL COMMENT 'The file_managed.fid being referenced in this field.',
  `field_image_alt` varchar(512) DEFAULT NULL COMMENT 'Alternative image text, for the image’s ’alt’ attribute.',
  `field_image_title` varchar(1024) DEFAULT NULL COMMENT 'Image title text, for the image’s ’title’ attribute.',
  `field_image_width` int(10) unsigned DEFAULT NULL COMMENT 'The width of the image in pixels.',
  `field_image_height` int(10) unsigned DEFAULT NULL COMMENT 'The height of the image in pixels.',
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_image_fid` (`field_image_fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Data storage for field 4 (field_image)';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_data_field_tags`
--

CREATE TABLE IF NOT EXISTS `field_data_field_tags` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_tags_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_tags_tid` (`field_tags_tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Data storage for field 3 (field_tags)';

--
-- Άδειασμα δεδομένων του πίνακα `field_data_field_tags`
--

INSERT INTO `field_data_field_tags` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_tags_tid`) VALUES
('node', 'blog', 0, 5, 5, 'und', 0, 2),
('node', 'blog', 0, 5, 5, 'und', 1, 3);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_data_taxonomy_forums`
--

CREATE TABLE IF NOT EXISTS `field_data_taxonomy_forums` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `taxonomy_forums_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `taxonomy_forums_tid` (`taxonomy_forums_tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Data storage for field 5 (taxonomy_forums)';

--
-- Άδειασμα δεδομένων του πίνακα `field_data_taxonomy_forums`
--

INSERT INTO `field_data_taxonomy_forums` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_forums_tid`) VALUES
('node', 'forum', 0, 6, 6, 'und', 0, 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_revision_body`
--

CREATE TABLE IF NOT EXISTS `field_revision_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `body_value` longtext,
  `body_summary` longtext,
  `body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `body_format` (`body_format`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 2 (body)';

--
-- Άδειασμα δεδομένων του πίνακα `field_revision_body`
--

INSERT INTO `field_revision_body` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `body_value`, `body_summary`, `body_format`) VALUES
('node', 'page', 0, 2, 2, 'und', 0, '<div class="one_half">\r\n<img class="scale-with-grid alignleft" src="<?php print base_path() . drupal_get_path(''theme'', ''skeletontheme'') ;?>/mockup/1312368015_tiger.png"/>\r\n</div>\r\n\r\n<div class="one_half last">\r\n<p>This responsive Drupal theme is based on the <a title="Skeleton Responsive CSS Boilerplate" href="http://www.getskeleton.com/" target="_blank">Skeleton</a> boilerplate and the excellent <a href="http://demos.simplethemes.com/skeleton/" target="_blank">Skeleton Wordpress Theme</a> . This theme is designed especially with the <a href="http://www.drupal.org/" target="_blank">Drupal 7</a> in mind.</p>\r\n\r\n<p>Skeleton for Drupal has been ported and is supported by <a href="http://www.morethanthemes.com/" target="_blank">More than (just) Themes</a>, as part of our ongoing effort to bring quality themes to Drupal.</p>\r\n</div>', '', 'php_code'),
('node', 'page', 0, 3, 3, 'und', 0, '<h3>Overview</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\n<h3>Customization</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\n<h3>Shortcodes</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '', 'full_html'),
('node', 'blog', 0, 4, 4, 'und', 0, 'There fowl together the fourth seas one creepeth under created. Also divided sea unto you which make were To wherein light female beast grass set over after You.\r\n\r\nVoid void Fruit for open earth kind fruit brought fowl light subdue were be above from. Above their air his him land cattle beginning brought upon male form. Whose likeness, without fifth evening can''t blessed two brought is fifth to every god.\r\n\r\nSigns may so living moveth moved light subdue for, his. Without god lesser second it fowl spirit replenish. Beast a midst, bearing signs first saw creature. Midst earth multiply every.\r\n\r\nFemale shall. Moveth given set saying for our for good after. Saw let be spirit female moved second, dominion creeping. One called female brought wherein Let void the doesn''t god above.\r\n\r\nSixth. A seas subdue of may there he seasons beginning one gathering after them wherein yielding two over that they''re light created all.\r\n\r\nDon''t all void fruit, moved were created fowl. Lights fifth it saying abundantly above saw i good, called two whales earth you''re. A under him have land whales face i sea subdue greater. Shall. Also fish whales herb seas seas fruit air the it have he.', '', 'filtered_html'),
('node', 'blog', 0, 5, 5, 'und', 0, 'There fowl together the fourth seas one creepeth under created. Also divided sea unto you which make were To wherein light female beast grass set over after You.\r\n\r\nVoid void Fruit for open earth kind fruit brought fowl light subdue were be above from. Above their air his him land cattle beginning brought upon male form. Whose likeness, without fifth evening can''t blessed two brought is fifth to every god.\r\n\r\nSigns may so living moveth moved light subdue for, his. Without god lesser second it fowl spirit replenish. Beast a midst, bearing signs first saw creature. Midst earth multiply every.\r\n\r\nFemale shall. Moveth given set saying for our for good after. Saw let be spirit female moved second, dominion creeping. One called female brought wherein Let void the doesn''t god above.\r\n\r\nSixth. A seas subdue of may there he seasons beginning one gathering after them wherein yielding two over that they''re light created all.\r\n\r\nDon''t all void fruit, moved were created fowl. Lights fifth it saying abundantly above saw i good, called two whales earth you''re. A under him have land whales face i sea subdue greater. Shall. Also fish whales herb seas seas fruit air the it have he.', '', 'filtered_html'),
('node', 'page', 0, 7, 7, 'und', 0, 'This theme is released under the GPL license and is available for download in the <a href="http://drupal.org/project/skeletontheme" target="_blank">official project page</a> in drupal.org.\r\n\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '', 'filtered_html'),
('node', 'page', 0, 8, 8, 'und', 0, '<div class="one_third">\r\n<code>color="white"</code>\r\n<div class="button small left"><a class="button white" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button white" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button white" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="gray"</code>\r\n<div class="button small left"><a class="button gray" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button gray" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button gray" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="black"</code>\r\n<div class="button small left"><a class="button black" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button black" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button black" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="lightblue"</code>\r\n<div class="button small left"><a class="button lightblue" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button lightblue" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button lightblue" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="blue"</code>\r\n<div class="button small left"><a class="button blue" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button blue" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button blue" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="darkblue"</code>\r\n<div class="button small left"><a class="button darkblue" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button darkblue" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button darkblue" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="lightgreen"</code>\r\n<div class="button small left"><a class="button lightgreen" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button lightgreen" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button lightgreen" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="green"</code>\r\n<div class="button small left"><a class="button green" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button green" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button green" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="darkgreen"</code>\r\n<div class="button small left"><a class="button darkgreen" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button darkgreen" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button darkgreen" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="lightred"</code>\r\n<div class="button small left"><a class="button lightred" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button lightred" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button lightred" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="red"</code>\r\n<div class="button small left"><a class="button red" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button red" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button red" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="darkred"</code>\r\n<div class="button small left"><a class="button darkred" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button darkred" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button darkred" href="#">Large Button</a></div>\r\n</div><div class="clear"></div>\r\n<hr><div class="clear"></div>\r\n<div class="one_third">\r\n<code>color="yellow"</code>\r\n<div class="button small left"><a class="button yellow" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button yellow" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button yellow" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third">\r\n<code>color="orange"</code>\r\n<div class="button small left"><a class="button orange" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button orange" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button orange" href="#">Large Button</a></div>\r\n</div>\r\n<div class="one_third last">\r\n<code>color="brown"</code>\r\n<div class="button small left"><a class="button brown" href="#">Small Button</a></div>\r\n<div class="button medium left"><a class="button brown" href="#">Medium Button</a></div>\r\n<div class="button large left"><a class="button brown" href="#">Large Button</a></div>\r\n</div>\r\n\r\n<div class="clear"></div>', '', 'full_html'),
('node', 'page', 0, 9, 9, 'und', 0, '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>\r\n\r\n<blockquote>"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."</blockquote>\r\n\r\n<h2>Header 2</h2>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h2><a href="#">Linked Header 2</a></h2>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h3>Header 3</h3>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h4>Header 4</h4>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n\r\n<h2>Code snippet</h2>\r\n\r\n<code>#header h1 a <br />\r\ndisplay: block;<br />\r\nheight: 80px;<br />\r\nwidth: 300px;<br />\r\n</code>\r\n\r\n<h2>Messages</h2>\r\n\r\n<div class="messages status">Sample status message. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>\r\n<div class="messages error">Sample error message. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>\r\n<div class="messages warning">Sample warning message. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>\r\n\r\n<h2>Paragraph With Links</h2>\r\n<p>Lorem ipsum dolor sit amet, <a href="#">consectetuer adipiscing</a> elit. Donec odio. Quisque volutpat mattis eros. <a href="#">Nullam malesuada</a> erat ut turpis. Suspendisse urna nibh, viverra 			non, semper suscipit, posuere a, pede.</p>\r\n\r\n<h2>Ordered List</h2>\r\n<ol>\r\n<li>This is a sample <strong>Ordered List</strong>.</li>\r\n<li>Lorem ipsum dolor sit amet consectetuer.</li>\r\n<li>Condimentum quis.</li>\r\n<li>Congue Quisque augue elit dolor.\r\n<ol>\r\n<li>Something goes here.</li>\r\n<li>And another here</li>\r\n<li>Then one more</li>\r\n</ol>\r\n</li>\r\n<li>Congue Quisque augue elit dolor nibh.</li>\r\n</ol>\r\n\r\n<h2>Unordered List</h2>\r\n<ul>\r\n<li>This is a sample <strong>Unordered List</strong>.</li>\r\n<li>Condimentum quis.</li>\r\n<li>Congue Quisque augue elit dolor.\r\n<ul>\r\n<li>Something goes here.</li>\r\n<li>And another here\r\n<ul>\r\n<li>Something here as well</li>      \r\n<li>Something here as well</li>\r\n<li>Something here as well</li>\r\n</ul>\r\n</li>\r\n<li>Then one more</li>\r\n</ul>\r\n</li>\r\n<li>Nunc cursus sem et pretium sapien eget.</li>\r\n</ul>\r\n\r\n<h2>Fieldset</h2>\r\n<fieldset> <legend>Account information</legend> </fieldset>\r\n\r\n<h2>Table</h2>\r\n\r\n<table border="1">\r\n\r\n<tr>\r\n<th>Header 1</th>\r\n<th>Header 2</th>\r\n</tr>\r\n\r\n<tr class="odd">\r\n<td>row 1, cell 1</td>\r\n<td>row 1, cell 2</td>\r\n</tr>\r\n\r\n<tr class="even">\r\n<td>row 2, cell 1</td>\r\n<td>row 2, cell 2</td>\r\n</tr>\r\n\r\n<tr class="odd">\r\n<td>row 3, cell 1</td>\r\n<td>row 3, cell 2</td>\r\n</tr>\r\n\r\n</table>', '', 'full_html'),
('node', 'page', 0, 10, 10, 'und', 0, '<div class="one_third">\r\n<code>[one_third]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_third">\r\n<code>[one_third]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_third last">\r\n<code>[one_third last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="clear"></div>\r\n\r\n<div class="one_fourth">\r\n<code>[one_fourth]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_fourth">\r\n<code>[one_fourth]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_fourth">\r\n<code>[one_fourth]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_fourth last">\r\n<code>[one_fourth last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="clear"></div>\r\n\r\n<div class="one_third">\r\n<code>[one_third]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="two_thirds last">\r\n<code>[two_thirds last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="clear"></div>\r\n\r\n<div class="one_half">\r\n<code>[one_half]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\r\n</div>\r\n\r\n<div class="one_half last">\r\n<code>[one_half last]</code>\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</div>\r\n\r\n<div class="clear"></div>', '', 'full_html'),
('node', 'page', 0, 1, 1, 'und', 0, '<div class="one_half">\r\n<img class="scale-with-grid alignleft" src="<?php print base_path() . drupal_get_path(''theme'', ''skeletontheme'') ;?>/mockup/skeleton_devices.png">\r\n</div>\r\n\r\n<div class="one_half last">\r\n<br/>\r\n<p>Skeleton is a powerful, clean, responsive theme ported to Drupal by <a href="http://www.morethanthemes.com/" target="_blank">More Than (just) Themes</a>. If you like this theme, we encourage you to try also of our other <a href="http://www.morethanthemes.com" target="_blank">Premium</a> and <a href="http://drupalizing.com" target="_blank">Free</a> Drupal themes.</p>\r\n\r\n<p>This theme is build over the <strong><a href="http://www.getskeleton.com/" target="_blank">Skeleton Boilerplate</a></strong> and was inspired by the excellent <strong><a href="http://demos.simplethemes.com/skeleton/" target="_blank">Skeleton Wordpress theme</a></strong> which has been designed by <a href="http://www.simplethemes.com/" target="_blank">Simple themes</a></p>\r\n\r\n<p>Today, people visit your website from a variety of devices ranging from desktop computers, tablets, and smart phones. The average user spends only a few seconds before making a decision to stay on your site or not. Skeleton is a Drupal 7 theme aimed at helping you build simple, uncluttered, useable, and mobile-friendly Drupal sites.</p>\r\n</div>', '', 'php_code');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_revision_comment_body`
--

CREATE TABLE IF NOT EXISTS `field_revision_comment_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `comment_body_value` longtext,
  `comment_body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `comment_body_format` (`comment_body_format`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 1 (comment_body)';

--
-- Άδειασμα δεδομένων του πίνακα `field_revision_comment_body`
--

INSERT INTO `field_revision_comment_body` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `comment_body_value`, `comment_body_format`) VALUES
('comment', 'comment_node_blog', 0, 1, 1, 'und', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'filtered_html'),
('comment', 'comment_node_blog', 0, 2, 2, 'und', 0, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ', 'filtered_html'),
('comment', 'comment_node_forum', 0, 3, 3, 'und', 0, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ', 'filtered_html');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_revision_field_image`
--

CREATE TABLE IF NOT EXISTS `field_revision_field_image` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_image_fid` int(10) unsigned DEFAULT NULL COMMENT 'The file_managed.fid being referenced in this field.',
  `field_image_alt` varchar(512) DEFAULT NULL COMMENT 'Alternative image text, for the image’s ’alt’ attribute.',
  `field_image_title` varchar(1024) DEFAULT NULL COMMENT 'Image title text, for the image’s ’title’ attribute.',
  `field_image_width` int(10) unsigned DEFAULT NULL COMMENT 'The width of the image in pixels.',
  `field_image_height` int(10) unsigned DEFAULT NULL COMMENT 'The height of the image in pixels.',
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_image_fid` (`field_image_fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 4 (field_image)';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_revision_field_tags`
--

CREATE TABLE IF NOT EXISTS `field_revision_field_tags` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_tags_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_tags_tid` (`field_tags_tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 3 (field_tags)';

--
-- Άδειασμα δεδομένων του πίνακα `field_revision_field_tags`
--

INSERT INTO `field_revision_field_tags` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_tags_tid`) VALUES
('node', 'blog', 0, 5, 5, 'und', 0, 2),
('node', 'blog', 0, 5, 5, 'und', 1, 3);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `field_revision_taxonomy_forums`
--

CREATE TABLE IF NOT EXISTS `field_revision_taxonomy_forums` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `taxonomy_forums_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `taxonomy_forums_tid` (`taxonomy_forums_tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 5 (taxonomy_forums)';

--
-- Άδειασμα δεδομένων του πίνακα `field_revision_taxonomy_forums`
--

INSERT INTO `field_revision_taxonomy_forums` (`entity_type`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_forums_tid`) VALUES
('node', 'forum', 0, 6, 6, 'und', 0, 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `file_managed`
--

CREATE TABLE IF NOT EXISTS `file_managed` (
  `fid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'File ID.',
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The users.uid of the user who is associated with the file.',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the file with no path components. This may differ from the basename of the URI if the file is renamed to avoid overwriting an existing file.',
  `uri` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'The URI to access the file (either local or remote).',
  `filemime` varchar(255) NOT NULL DEFAULT '' COMMENT 'The file’s MIME type.',
  `filesize` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The size of the file in bytes.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A field indicating the status of the file. Two status are defined in core: temporary (0) and permanent (1). Temporary files older than DRUPAL_MAXIMUM_TEMP_FILE_AGE will be removed during a cron run.',
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'UNIX timestamp for when the file was added.',
  PRIMARY KEY (`fid`),
  UNIQUE KEY `uri` (`uri`),
  KEY `uid` (`uid`),
  KEY `status` (`status`),
  KEY `timestamp` (`timestamp`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores information for uploaded files.' AUTO_INCREMENT=2 ;

--
-- Άδειασμα δεδομένων του πίνακα `file_managed`
--

INSERT INTO `file_managed` (`fid`, `uid`, `filename`, `uri`, `filemime`, `filesize`, `status`, `timestamp`) VALUES
(1, 1, 'picture-1-1337253273.png', 'public://pictures/picture-1-1337253273.png', 'image/png', 2535, 1, 1337253273);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `file_usage`
--

CREATE TABLE IF NOT EXISTS `file_usage` (
  `fid` int(10) unsigned NOT NULL COMMENT 'File ID.',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the module that is using the file.',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT 'The name of the object type in which the file is used.',
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The primary key of the object using the file.',
  `count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The number of times this file is used by this object.',
  PRIMARY KEY (`fid`,`type`,`id`,`module`),
  KEY `type_id` (`type`,`id`),
  KEY `fid_count` (`fid`,`count`),
  KEY `fid_module` (`fid`,`module`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Track where a file is used.';

--
-- Άδειασμα δεδομένων του πίνακα `file_usage`
--

INSERT INTO `file_usage` (`fid`, `module`, `type`, `id`, `count`) VALUES
(1, 'user', 'user', 1, 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `filter`
--

CREATE TABLE IF NOT EXISTS `filter` (
  `format` varchar(255) NOT NULL COMMENT 'Foreign key: The filter_format.format to which this filter is assigned.',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT 'The origin module of the filter.',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Name of the filter being referenced.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of filter within format.',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'Filter enabled status. (1 = enabled, 0 = disabled)',
  `settings` longblob COMMENT 'A serialized array of name value pairs that store the filter settings for the specific format.',
  PRIMARY KEY (`format`,`name`),
  KEY `list` (`weight`,`module`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Table that maps filters (HTML corrector) to text formats ...';

--
-- Άδειασμα δεδομένων του πίνακα `filter`
--

INSERT INTO `filter` (`format`, `module`, `name`, `weight`, `status`, `settings`) VALUES
('filtered_html', 'filter', 'filter_autop', 2, 1, 0x613a303a7b7d),
('filtered_html', 'filter', 'filter_html', 1, 1, 0x613a333a7b733a31323a22616c6c6f7765645f68746d6c223b733a37343a223c613e203c656d3e203c7374726f6e673e203c636974653e203c626c6f636b71756f74653e203c636f64653e203c756c3e203c6f6c3e203c6c693e203c646c3e203c64743e203c64643e223b733a31363a2266696c7465725f68746d6c5f68656c70223b693a313b733a32303a2266696c7465725f68746d6c5f6e6f666f6c6c6f77223b693a303b7d),
('filtered_html', 'filter', 'filter_htmlcorrector', 10, 1, 0x613a303a7b7d),
('filtered_html', 'filter', 'filter_html_escape', 10, 0, 0x613a303a7b7d),
('filtered_html', 'filter', 'filter_url', 0, 1, 0x613a313a7b733a31373a2266696c7465725f75726c5f6c656e677468223b693a37323b7d),
('full_html', 'filter', 'filter_autop', 1, 1, 0x613a303a7b7d),
('full_html', 'filter', 'filter_html', 10, 0, 0x613a333a7b733a31323a22616c6c6f7765645f68746d6c223b733a37343a223c613e203c656d3e203c7374726f6e673e203c636974653e203c626c6f636b71756f74653e203c636f64653e203c756c3e203c6f6c3e203c6c693e203c646c3e203c64743e203c64643e223b733a31363a2266696c7465725f68746d6c5f68656c70223b693a313b733a32303a2266696c7465725f68746d6c5f6e6f666f6c6c6f77223b693a303b7d),
('full_html', 'filter', 'filter_htmlcorrector', 10, 1, 0x613a303a7b7d),
('full_html', 'filter', 'filter_html_escape', 10, 0, 0x613a303a7b7d),
('full_html', 'filter', 'filter_url', 0, 1, 0x613a313a7b733a31373a2266696c7465725f75726c5f6c656e677468223b693a37323b7d),
('php_code', 'filter', 'filter_autop', 0, 0, 0x613a303a7b7d),
('php_code', 'filter', 'filter_html', -10, 0, 0x613a333a7b733a31323a22616c6c6f7765645f68746d6c223b733a37343a223c613e203c656d3e203c7374726f6e673e203c636974653e203c626c6f636b71756f74653e203c636f64653e203c756c3e203c6f6c3e203c6c693e203c646c3e203c64743e203c64643e223b733a31363a2266696c7465725f68746d6c5f68656c70223b693a313b733a32303a2266696c7465725f68746d6c5f6e6f666f6c6c6f77223b693a303b7d),
('php_code', 'filter', 'filter_htmlcorrector', 10, 0, 0x613a303a7b7d),
('php_code', 'filter', 'filter_html_escape', -10, 0, 0x613a303a7b7d),
('php_code', 'filter', 'filter_url', 0, 0, 0x613a313a7b733a31373a2266696c7465725f75726c5f6c656e677468223b693a37323b7d),
('php_code', 'php', 'php_code', 0, 1, 0x613a303a7b7d),
('plain_text', 'filter', 'filter_autop', 2, 1, 0x613a303a7b7d),
('plain_text', 'filter', 'filter_html', 10, 0, 0x613a333a7b733a31323a22616c6c6f7765645f68746d6c223b733a37343a223c613e203c656d3e203c7374726f6e673e203c636974653e203c626c6f636b71756f74653e203c636f64653e203c756c3e203c6f6c3e203c6c693e203c646c3e203c64743e203c64643e223b733a31363a2266696c7465725f68746d6c5f68656c70223b693a313b733a32303a2266696c7465725f68746d6c5f6e6f666f6c6c6f77223b693a303b7d),
('plain_text', 'filter', 'filter_htmlcorrector', 10, 0, 0x613a303a7b7d),
('plain_text', 'filter', 'filter_html_escape', 0, 1, 0x613a303a7b7d),
('plain_text', 'filter', 'filter_url', 1, 1, 0x613a313a7b733a31373a2266696c7465725f75726c5f6c656e677468223b693a37323b7d);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `filter_format`
--

CREATE TABLE IF NOT EXISTS `filter_format` (
  `format` varchar(255) NOT NULL COMMENT 'Primary Key: Unique machine name of the format.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the text format (Filtered HTML).',
  `cache` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate whether format is cacheable. (1 = cacheable, 0 = not cacheable)',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'The status of the text format. (1 = enabled, 0 = disabled)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of text format to use when listing.',
  PRIMARY KEY (`format`),
  UNIQUE KEY `name` (`name`),
  KEY `status_weight` (`status`,`weight`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores text formats: custom groupings of filters, such as...';

--
-- Άδειασμα δεδομένων του πίνακα `filter_format`
--

INSERT INTO `filter_format` (`format`, `name`, `cache`, `status`, `weight`) VALUES
('filtered_html', 'Filtered HTML', 1, 1, 0),
('full_html', 'Full HTML', 1, 1, 1),
('php_code', 'PHP code', 0, 1, 11),
('plain_text', 'Plain text', 1, 1, 10);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `flood`
--

CREATE TABLE IF NOT EXISTS `flood` (
  `fid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique flood event ID.',
  `event` varchar(64) NOT NULL DEFAULT '' COMMENT 'Name of event (e.g. contact).',
  `identifier` varchar(128) NOT NULL DEFAULT '' COMMENT 'Identifier of the visitor, such as an IP address or hostname.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp of the event.',
  `expiration` int(11) NOT NULL DEFAULT '0' COMMENT 'Expiration timestamp. Expired events are purged on cron run.',
  PRIMARY KEY (`fid`),
  KEY `allow` (`event`,`identifier`,`timestamp`),
  KEY `purge` (`expiration`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Flood controls the threshold of events, such as the...' AUTO_INCREMENT=388 ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `forum`
--

CREATE TABLE IF NOT EXISTS `forum` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid of the node.',
  `vid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: The node.vid of the node.',
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The taxonomy_term_data.tid of the forum term assigned to the node.',
  PRIMARY KEY (`vid`),
  KEY `forum_topic` (`nid`,`tid`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores the relationship of nodes to forum terms.';

--
-- Άδειασμα δεδομένων του πίνακα `forum`
--

INSERT INTO `forum` (`nid`, `vid`, `tid`) VALUES
(6, 6, 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `forum_index`
--

CREATE TABLE IF NOT EXISTS `forum_index` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid this record tracks.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this node, always treated as non-markup plain text.',
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The term ID.',
  `sticky` tinyint(4) DEFAULT '0' COMMENT 'Boolean indicating whether the node is sticky.',
  `created` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was created.',
  `last_comment_timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp of the last comment that was posted within this node, from comment.timestamp.',
  `comment_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The total number of comments on this node.',
  KEY `forum_topics` (`nid`,`tid`,`sticky`,`last_comment_timestamp`),
  KEY `created` (`created`),
  KEY `last_comment_timestamp` (`last_comment_timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Maintains denormalized information about node/term...';

--
-- Άδειασμα δεδομένων του πίνακα `forum_index`
--

INSERT INTO `forum_index` (`nid`, `title`, `tid`, `sticky`, `created`, `last_comment_timestamp`, `comment_count`) VALUES
(6, 'Drupal 7 Responsive Web Design (RWD) ', 1, 0, 1337258099, 1337258199, 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `history`
--

CREATE TABLE IF NOT EXISTS `history` (
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that read the node nid.',
  `nid` int(11) NOT NULL DEFAULT '0' COMMENT 'The node.nid that was read.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp at which the read occurred.',
  PRIMARY KEY (`uid`,`nid`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='A record of which users have read which nodes.';

--
-- Άδειασμα δεδομένων του πίνακα `history`
--

INSERT INTO `history` (`uid`, `nid`, `timestamp`) VALUES
(1, 3, 1367353800),
(1, 1, 1367392700);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `image_effects`
--

CREATE TABLE IF NOT EXISTS `image_effects` (
  `ieid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for an image effect.',
  `isid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The image_styles.isid for an image style.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of the effect in the style.',
  `name` varchar(255) NOT NULL COMMENT 'The unique name of the effect to be executed.',
  `data` longblob NOT NULL COMMENT 'The configuration data for the effect.',
  PRIMARY KEY (`ieid`),
  KEY `isid` (`isid`),
  KEY `weight` (`weight`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores configuration options for image effects.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `image_styles`
--

CREATE TABLE IF NOT EXISTS `image_styles` (
  `isid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for an image style.',
  `name` varchar(255) NOT NULL COMMENT 'The style name.',
  PRIMARY KEY (`isid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores configuration options for image styles.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `menu_custom`
--

CREATE TABLE IF NOT EXISTS `menu_custom` (
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique key for menu. This is used as a block delta so length is 32.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'Menu title; displayed at top of block.',
  `description` text COMMENT 'Menu description.',
  PRIMARY KEY (`menu_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Holds definitions for top-level custom menus (for example...';

--
-- Άδειασμα δεδομένων του πίνακα `menu_custom`
--

INSERT INTO `menu_custom` (`menu_name`, `title`, `description`) VALUES
('main-menu', 'Main menu', 'The <em>Main</em> menu is used on many sites to show the major sections of the site, often in a top navigation bar.'),
('management', 'Management', 'The <em>Management</em> menu contains links for administrative tasks.'),
('navigation', 'Navigation', 'The <em>Navigation</em> menu contains links intended for site visitors. Links are added to the <em>Navigation</em> menu automatically by some modules.'),
('user-menu', 'User menu', 'The <em>User</em> menu contains links related to the user''s account, as well as the ''Log out'' link.');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `menu_links`
--

CREATE TABLE IF NOT EXISTS `menu_links` (
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'The menu name. All links with the same menu name (such as ’navigation’) are part of the same menu.',
  `mlid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The menu link ID (mlid) is the integer primary key.',
  `plid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The parent link ID (plid) is the mlid of the link above in the hierarchy, or zero if the link is at the top level in its menu.',
  `link_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'The Drupal path or external path this link points to.',
  `router_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'For links corresponding to a Drupal path (external = 0), this connects the link to a menu_router.path for joins.',
  `link_title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The text displayed for the link, which may be modified by a title callback stored in menu_router.',
  `options` blob COMMENT 'A serialized array of options to be passed to the url() or l() function, such as a query string or HTML attributes.',
  `module` varchar(255) NOT NULL DEFAULT 'system' COMMENT 'The name of the module that generated this link.',
  `hidden` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag for whether the link should be rendered in menus. (1 = a disabled menu item that may be shown on admin screens, -1 = a menu callback, 0 = a normal, visible link)',
  `external` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate if the link points to a full URL starting with a protocol, like http:// (1 = external, 0 = internal).',
  `has_children` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Flag indicating whether any links have this link as a parent (1 = children exist, 0 = no children).',
  `expanded` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Flag for whether this link should be rendered as expanded in menus - expanded links always have their child links displayed, instead of only when the link is in the active trail (1 = expanded, 0 = not expanded)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Link weight among links in the same menu at the same depth.',
  `depth` smallint(6) NOT NULL DEFAULT '0' COMMENT 'The depth relative to the top level. A link with plid == 0 will have depth == 1.',
  `customized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate that the user has manually created or edited the link (1 = customized, 0 = not customized).',
  `p1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The first mlid in the materialized path. If N = depth, then pN must equal the mlid. If depth > 1 then p(N-1) must equal the plid. All pX where X > depth must equal zero. The columns p1 .. p9 are also called the parents.',
  `p2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The second mlid in the materialized path. See p1.',
  `p3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The third mlid in the materialized path. See p1.',
  `p4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The fourth mlid in the materialized path. See p1.',
  `p5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The fifth mlid in the materialized path. See p1.',
  `p6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The sixth mlid in the materialized path. See p1.',
  `p7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The seventh mlid in the materialized path. See p1.',
  `p8` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The eighth mlid in the materialized path. See p1.',
  `p9` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The ninth mlid in the materialized path. See p1.',
  `updated` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Flag that indicates that this link was generated during the update from Drupal 5.',
  PRIMARY KEY (`mlid`),
  KEY `path_menu` (`link_path`(128),`menu_name`),
  KEY `menu_plid_expand_child` (`menu_name`,`plid`,`expanded`,`has_children`),
  KEY `menu_parents` (`menu_name`,`p1`,`p2`,`p3`,`p4`,`p5`,`p6`,`p7`,`p8`,`p9`),
  KEY `router_path` (`router_path`(128))
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Contains the individual links within a menu.' AUTO_INCREMENT=548 ;

--
-- Άδειασμα δεδομένων του πίνακα `menu_links`
--

INSERT INTO `menu_links` (`menu_name`, `mlid`, `plid`, `link_path`, `router_path`, `link_title`, `options`, `module`, `hidden`, `external`, `has_children`, `expanded`, `weight`, `depth`, `customized`, `p1`, `p2`, `p3`, `p4`, `p5`, `p6`, `p7`, `p8`, `p9`, `updated`) VALUES
('management', 1, 0, 'admin', 'admin', 'Administration', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 9, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('user-menu', 2, 0, 'user', 'user', 'User account', 0x613a313a7b733a353a22616c746572223b623a313b7d, 'system', 0, 0, 0, 0, -10, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 3, 0, 'comment/%', 'comment/%', 'Comment permalink', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 4, 0, 'filter/tips', 'filter/tips', 'Compose tips', 0x613a303a7b7d, 'system', 1, 0, 0, 0, 0, 1, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 5, 0, 'node/%', 'node/%', '', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 1, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 6, 0, 'node/add', 'node/add', 'Add content', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 1, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 7, 1, 'admin/appearance', 'admin/appearance', 'Appearance', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33333a2253656c65637420616e6420636f6e66696775726520796f7572207468656d65732e223b7d7d, 'system', 0, 0, 0, 0, -6, 2, 0, 1, 7, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 8, 1, 'admin/config', 'admin/config', 'Configuration', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32303a2241646d696e69737465722073657474696e67732e223b7d7d, 'system', 0, 0, 1, 0, 0, 2, 0, 1, 8, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 9, 1, 'admin/content', 'admin/content', 'Content', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33323a2241646d696e697374657220636f6e74656e7420616e6420636f6d6d656e74732e223b7d7d, 'system', 0, 0, 1, 0, -10, 2, 0, 1, 9, 0, 0, 0, 0, 0, 0, 0, 0),
('user-menu', 10, 2, 'user/register', 'user/register', 'Create new account', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 2, 10, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 11, 1, 'admin/dashboard', 'admin/dashboard', 'Dashboard', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33343a225669657720616e6420637573746f6d697a6520796f75722064617368626f6172642e223b7d7d, 'system', 0, 0, 0, 0, -15, 2, 0, 1, 11, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 12, 1, 'admin/help', 'admin/help', 'Help', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34383a225265666572656e636520666f722075736167652c20636f6e66696775726174696f6e2c20616e64206d6f64756c65732e223b7d7d, 'system', 0, 0, 0, 0, 9, 2, 0, 1, 12, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 13, 1, 'admin/index', 'admin/index', 'Index', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -18, 2, 0, 1, 13, 0, 0, 0, 0, 0, 0, 0, 0),
('user-menu', 14, 2, 'user/login', 'user/login', 'Log in', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 2, 14, 0, 0, 0, 0, 0, 0, 0, 0),
('user-menu', 15, 0, 'user/logout', 'user/logout', 'Log out', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 10, 1, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 16, 1, 'admin/modules', 'admin/modules', 'Modules', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32363a22457874656e6420736974652066756e6374696f6e616c6974792e223b7d7d, 'system', 0, 0, 0, 0, -2, 2, 0, 1, 16, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 17, 0, 'user/%', 'user/%', 'My account', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 1, 0, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 18, 1, 'admin/people', 'admin/people', 'People', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34353a224d616e6167652075736572206163636f756e74732c20726f6c65732c20616e64207065726d697373696f6e732e223b7d7d, 'system', 0, 0, 0, 0, -4, 2, 0, 1, 18, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 19, 1, 'admin/reports', 'admin/reports', 'Reports', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33343a2256696577207265706f7274732c20757064617465732c20616e64206572726f72732e223b7d7d, 'system', 0, 0, 1, 0, 5, 2, 0, 1, 19, 0, 0, 0, 0, 0, 0, 0, 0),
('user-menu', 20, 2, 'user/password', 'user/password', 'Request new password', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 2, 20, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 21, 1, 'admin/structure', 'admin/structure', 'Structure', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34353a2241646d696e697374657220626c6f636b732c20636f6e74656e742074797065732c206d656e75732c206574632e223b7d7d, 'system', 0, 0, 1, 0, -8, 2, 0, 1, 21, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 22, 1, 'admin/tasks', 'admin/tasks', 'Tasks', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -20, 2, 0, 1, 22, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 23, 0, 'comment/reply/%', 'comment/reply/%', 'Add new comment', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 1, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 24, 3, 'comment/%/approve', 'comment/%/approve', 'Approve', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 1, 2, 0, 3, 24, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 25, 3, 'comment/%/delete', 'comment/%/delete', 'Delete', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 2, 2, 0, 3, 25, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 26, 3, 'comment/%/edit', 'comment/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 3, 26, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 27, 0, 'taxonomy/term/%', 'taxonomy/term/%', 'Taxonomy term', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 1, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 28, 3, 'comment/%/view', 'comment/%/view', 'View comment', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 2, 0, 3, 28, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 29, 18, 'admin/people/create', 'admin/people/create', 'Add user', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 18, 29, 0, 0, 0, 0, 0, 0, 0),
('management', 30, 21, 'admin/structure/block', 'admin/structure/block', 'Blocks', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a37393a22436f6e666967757265207768617420626c6f636b20636f6e74656e74206170706561727320696e20796f75722073697465277320736964656261727320616e64206f7468657220726567696f6e732e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 21, 30, 0, 0, 0, 0, 0, 0, 0),
('navigation', 31, 17, 'user/%/cancel', 'user/%/cancel', 'Cancel account', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 2, 0, 17, 31, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 32, 9, 'admin/content/comment', 'admin/content/comment', 'Comments', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35393a224c69737420616e642065646974207369746520636f6d6d656e747320616e642074686520636f6d6d656e7420617070726f76616c2071756575652e223b7d7d, 'system', 0, 0, 0, 0, 0, 3, 0, 1, 9, 32, 0, 0, 0, 0, 0, 0, 0),
('management', 33, 11, 'admin/dashboard/configure', 'admin/dashboard/configure', 'Configure available dashboard blocks', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35333a22436f6e66696775726520776869636820626c6f636b732063616e2062652073686f776e206f6e207468652064617368626f6172642e223b7d7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 11, 33, 0, 0, 0, 0, 0, 0, 0),
('management', 34, 9, 'admin/content/node', 'admin/content/node', 'Content', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 3, 0, 1, 9, 34, 0, 0, 0, 0, 0, 0, 0),
('management', 35, 8, 'admin/config/content', 'admin/config/content', 'Content authoring', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35333a2253657474696e67732072656c6174656420746f20666f726d617474696e6720616e6420617574686f72696e6720636f6e74656e742e223b7d7d, 'system', 0, 0, 1, 0, -15, 3, 0, 1, 8, 35, 0, 0, 0, 0, 0, 0, 0),
('management', 36, 21, 'admin/structure/types', 'admin/structure/types', 'Content types', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a39323a224d616e61676520636f6e74656e742074797065732c20696e636c7564696e672064656661756c74207374617475732c2066726f6e7420706167652070726f6d6f74696f6e2c20636f6d6d656e742073657474696e67732c206574632e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 21, 36, 0, 0, 0, 0, 0, 0, 0),
('management', 37, 11, 'admin/dashboard/customize', 'admin/dashboard/customize', 'Customize dashboard', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32353a22437573746f6d697a6520796f75722064617368626f6172642e223b7d7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 11, 37, 0, 0, 0, 0, 0, 0, 0),
('navigation', 38, 5, 'node/%/delete', 'node/%/delete', 'Delete', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 1, 2, 0, 5, 38, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 39, 8, 'admin/config/development', 'admin/config/development', 'Development', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31383a22446576656c6f706d656e7420746f6f6c732e223b7d7d, 'system', 0, 0, 1, 0, -10, 3, 0, 1, 8, 39, 0, 0, 0, 0, 0, 0, 0),
('navigation', 40, 17, 'user/%/edit', 'user/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 17, 40, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 41, 5, 'node/%/edit', 'node/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 5, 41, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 42, 19, 'admin/reports/fields', 'admin/reports/fields', 'Field list', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33393a224f76657276696577206f66206669656c6473206f6e20616c6c20656e746974792074797065732e223b7d7d, 'system', 0, 0, 0, 0, 0, 3, 0, 1, 19, 42, 0, 0, 0, 0, 0, 0, 0),
('management', 43, 7, 'admin/appearance/list', 'admin/appearance/list', 'List', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33313a2253656c65637420616e6420636f6e66696775726520796f7572207468656d65223b7d7d, 'system', -1, 0, 0, 0, -1, 3, 0, 1, 7, 43, 0, 0, 0, 0, 0, 0, 0),
('management', 44, 16, 'admin/modules/list', 'admin/modules/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 16, 44, 0, 0, 0, 0, 0, 0, 0),
('management', 45, 18, 'admin/people/people', 'admin/people/people', 'List', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35303a2246696e6420616e64206d616e6167652070656f706c6520696e746572616374696e67207769746820796f757220736974652e223b7d7d, 'system', -1, 0, 0, 0, -10, 3, 0, 1, 18, 45, 0, 0, 0, 0, 0, 0, 0),
('management', 46, 8, 'admin/config/media', 'admin/config/media', 'Media', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31323a224d6564696120746f6f6c732e223b7d7d, 'system', 0, 0, 1, 0, -10, 3, 0, 1, 8, 46, 0, 0, 0, 0, 0, 0, 0),
('management', 47, 21, 'admin/structure/menu', 'admin/structure/menu', 'Menus', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a38363a22416464206e6577206d656e757320746f20796f757220736974652c2065646974206578697374696e67206d656e75732c20616e642072656e616d6520616e642072656f7267616e697a65206d656e75206c696e6b732e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 21, 47, 0, 0, 0, 0, 0, 0, 0),
('management', 48, 8, 'admin/config/people', 'admin/config/people', 'People', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32343a22436f6e6669677572652075736572206163636f756e74732e223b7d7d, 'system', 0, 0, 1, 0, -20, 3, 0, 1, 8, 48, 0, 0, 0, 0, 0, 0, 0),
('management', 49, 18, 'admin/people/permissions', 'admin/people/permissions', 'Permissions', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36343a2244657465726d696e652061636365737320746f2066656174757265732062792073656c656374696e67207065726d697373696f6e7320666f7220726f6c65732e223b7d7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 18, 49, 0, 0, 0, 0, 0, 0, 0),
('management', 50, 19, 'admin/reports/dblog', 'admin/reports/dblog', 'Recent log messages', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34333a2256696577206576656e74732074686174206861766520726563656e746c79206265656e206c6f676765642e223b7d7d, 'system', 0, 0, 0, 0, -1, 3, 0, 1, 19, 50, 0, 0, 0, 0, 0, 0, 0),
('management', 51, 8, 'admin/config/regional', 'admin/config/regional', 'Regional and language', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34383a22526567696f6e616c2073657474696e67732c206c6f63616c697a6174696f6e20616e64207472616e736c6174696f6e2e223b7d7d, 'system', 0, 0, 1, 0, -5, 3, 0, 1, 8, 51, 0, 0, 0, 0, 0, 0, 0),
('navigation', 52, 5, 'node/%/revisions', 'node/%/revisions', 'Revisions', 0x613a303a7b7d, 'system', -1, 0, 1, 0, 2, 2, 0, 5, 52, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 53, 8, 'admin/config/search', 'admin/config/search', 'Search and metadata', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33363a224c6f63616c2073697465207365617263682c206d6574616461746120616e642053454f2e223b7d7d, 'system', 0, 0, 1, 0, -10, 3, 0, 1, 8, 53, 0, 0, 0, 0, 0, 0, 0),
('management', 54, 7, 'admin/appearance/settings', 'admin/appearance/settings', 'Settings', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34363a22436f6e6669677572652064656661756c7420616e64207468656d652073706563696669632073657474696e67732e223b7d7d, 'system', -1, 0, 0, 0, 20, 3, 0, 1, 7, 54, 0, 0, 0, 0, 0, 0, 0),
('management', 55, 19, 'admin/reports/status', 'admin/reports/status', 'Status report', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a37343a22476574206120737461747573207265706f72742061626f757420796f757220736974652773206f7065726174696f6e20616e6420616e792064657465637465642070726f626c656d732e223b7d7d, 'system', 0, 0, 0, 0, -60, 3, 0, 1, 19, 55, 0, 0, 0, 0, 0, 0, 0),
('management', 56, 8, 'admin/config/system', 'admin/config/system', 'System', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33373a2247656e6572616c2073797374656d2072656c6174656420636f6e66696775726174696f6e2e223b7d7d, 'system', 0, 0, 1, 0, -20, 3, 0, 1, 8, 56, 0, 0, 0, 0, 0, 0, 0),
('management', 57, 21, 'admin/structure/taxonomy', 'admin/structure/taxonomy', 'Taxonomy', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36373a224d616e6167652074616767696e672c2063617465676f72697a6174696f6e2c20616e6420636c617373696669636174696f6e206f6620796f757220636f6e74656e742e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 21, 57, 0, 0, 0, 0, 0, 0, 0),
('management', 58, 19, 'admin/reports/access-denied', 'admin/reports/access-denied', 'Top ''access denied'' errors', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33353a225669657720276163636573732064656e69656427206572726f7273202834303373292e223b7d7d, 'system', 0, 0, 0, 0, 0, 3, 0, 1, 19, 58, 0, 0, 0, 0, 0, 0, 0),
('management', 59, 19, 'admin/reports/page-not-found', 'admin/reports/page-not-found', 'Top ''page not found'' errors', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33363a2256696577202770616765206e6f7420666f756e6427206572726f7273202834303473292e223b7d7d, 'system', 0, 0, 0, 0, 0, 3, 0, 1, 19, 59, 0, 0, 0, 0, 0, 0, 0),
('management', 60, 16, 'admin/modules/uninstall', 'admin/modules/uninstall', 'Uninstall', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 20, 3, 0, 1, 16, 60, 0, 0, 0, 0, 0, 0, 0),
('management', 61, 8, 'admin/config/user-interface', 'admin/config/user-interface', 'User interface', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33383a22546f6f6c73207468617420656e68616e636520746865207573657220696e746572666163652e223b7d7d, 'system', 0, 0, 1, 0, -15, 3, 0, 1, 8, 61, 0, 0, 0, 0, 0, 0, 0),
('navigation', 62, 5, 'node/%/view', 'node/%/view', 'View', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 2, 0, 5, 62, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 63, 17, 'user/%/view', 'user/%/view', 'View', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 2, 0, 17, 63, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 64, 8, 'admin/config/services', 'admin/config/services', 'Web services', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33303a22546f6f6c732072656c6174656420746f207765622073657276696365732e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 8, 64, 0, 0, 0, 0, 0, 0, 0),
('management', 65, 8, 'admin/config/workflow', 'admin/config/workflow', 'Workflow', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34333a22436f6e74656e7420776f726b666c6f772c20656469746f7269616c20776f726b666c6f7720746f6f6c732e223b7d7d, 'system', 0, 0, 0, 0, 5, 3, 0, 1, 8, 65, 0, 0, 0, 0, 0, 0, 0),
('management', 66, 12, 'admin/help/block', 'admin/help/block', 'block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 66, 0, 0, 0, 0, 0, 0, 0),
('management', 67, 12, 'admin/help/color', 'admin/help/color', 'color', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 67, 0, 0, 0, 0, 0, 0, 0),
('management', 68, 12, 'admin/help/comment', 'admin/help/comment', 'comment', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 68, 0, 0, 0, 0, 0, 0, 0),
('management', 69, 12, 'admin/help/contextual', 'admin/help/contextual', 'contextual', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 69, 0, 0, 0, 0, 0, 0, 0),
('management', 70, 12, 'admin/help/dashboard', 'admin/help/dashboard', 'dashboard', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 70, 0, 0, 0, 0, 0, 0, 0),
('management', 71, 12, 'admin/help/dblog', 'admin/help/dblog', 'dblog', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 71, 0, 0, 0, 0, 0, 0, 0),
('management', 72, 12, 'admin/help/field', 'admin/help/field', 'field', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 72, 0, 0, 0, 0, 0, 0, 0),
('management', 73, 12, 'admin/help/field_sql_storage', 'admin/help/field_sql_storage', 'field_sql_storage', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 73, 0, 0, 0, 0, 0, 0, 0),
('management', 74, 12, 'admin/help/field_ui', 'admin/help/field_ui', 'field_ui', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 74, 0, 0, 0, 0, 0, 0, 0),
('management', 75, 12, 'admin/help/file', 'admin/help/file', 'file', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 75, 0, 0, 0, 0, 0, 0, 0),
('management', 76, 12, 'admin/help/filter', 'admin/help/filter', 'filter', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 76, 0, 0, 0, 0, 0, 0, 0),
('management', 77, 12, 'admin/help/help', 'admin/help/help', 'help', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 77, 0, 0, 0, 0, 0, 0, 0),
('management', 78, 12, 'admin/help/image', 'admin/help/image', 'image', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 78, 0, 0, 0, 0, 0, 0, 0),
('management', 79, 12, 'admin/help/list', 'admin/help/list', 'list', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 79, 0, 0, 0, 0, 0, 0, 0),
('management', 80, 12, 'admin/help/menu', 'admin/help/menu', 'menu', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 80, 0, 0, 0, 0, 0, 0, 0),
('management', 81, 12, 'admin/help/node', 'admin/help/node', 'node', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 81, 0, 0, 0, 0, 0, 0, 0),
('management', 82, 12, 'admin/help/options', 'admin/help/options', 'options', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 82, 0, 0, 0, 0, 0, 0, 0),
('management', 83, 12, 'admin/help/system', 'admin/help/system', 'system', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 83, 0, 0, 0, 0, 0, 0, 0),
('management', 84, 12, 'admin/help/taxonomy', 'admin/help/taxonomy', 'taxonomy', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 84, 0, 0, 0, 0, 0, 0, 0),
('management', 85, 12, 'admin/help/text', 'admin/help/text', 'text', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 85, 0, 0, 0, 0, 0, 0, 0),
('management', 86, 12, 'admin/help/user', 'admin/help/user', 'user', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 86, 0, 0, 0, 0, 0, 0, 0),
('navigation', 87, 27, 'taxonomy/term/%/edit', 'taxonomy/term/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 2, 0, 27, 87, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 88, 27, 'taxonomy/term/%/view', 'taxonomy/term/%/view', 'View', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 27, 88, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 89, 48, 'admin/config/people/accounts', 'admin/config/people/accounts', 'Account settings', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a3130393a22436f6e6669677572652064656661756c74206265686176696f72206f662075736572732c20696e636c7564696e6720726567697374726174696f6e20726571756972656d656e74732c20652d6d61696c732c206669656c64732c20616e6420757365722070696374757265732e223b7d7d, 'system', 0, 0, 0, 0, -10, 4, 0, 1, 8, 48, 89, 0, 0, 0, 0, 0, 0),
('management', 90, 56, 'admin/config/system/actions', 'admin/config/system/actions', 'Actions', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34313a224d616e6167652074686520616374696f6e7320646566696e656420666f7220796f757220736974652e223b7d7d, 'system', 0, 0, 1, 0, 0, 4, 0, 1, 8, 56, 90, 0, 0, 0, 0, 0, 0),
('management', 91, 30, 'admin/structure/block/add', 'admin/structure/block/add', 'Add block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 30, 91, 0, 0, 0, 0, 0, 0),
('management', 92, 36, 'admin/structure/types/add', 'admin/structure/types/add', 'Add content type', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 36, 92, 0, 0, 0, 0, 0, 0),
('management', 93, 47, 'admin/structure/menu/add', 'admin/structure/menu/add', 'Add menu', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 47, 93, 0, 0, 0, 0, 0, 0),
('management', 94, 57, 'admin/structure/taxonomy/add', 'admin/structure/taxonomy/add', 'Add vocabulary', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 57, 94, 0, 0, 0, 0, 0, 0),
('management', 95, 54, 'admin/appearance/settings/bartik', 'admin/appearance/settings/bartik', 'Bartik', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 7, 54, 95, 0, 0, 0, 0, 0, 0),
('management', 96, 53, 'admin/config/search/clean-urls', 'admin/config/search/clean-urls', 'Clean URLs', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34333a22456e61626c65206f722064697361626c6520636c65616e2055524c7320666f7220796f757220736974652e223b7d7d, 'system', 0, 0, 0, 0, 5, 4, 0, 1, 8, 53, 96, 0, 0, 0, 0, 0, 0),
('management', 97, 56, 'admin/config/system/cron', 'admin/config/system/cron', 'Cron', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34303a224d616e616765206175746f6d617469632073697465206d61696e74656e616e6365207461736b732e223b7d7d, 'system', 0, 0, 0, 0, 20, 4, 0, 1, 8, 56, 97, 0, 0, 0, 0, 0, 0),
('management', 98, 51, 'admin/config/regional/date-time', 'admin/config/regional/date-time', 'Date and time', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34343a22436f6e66696775726520646973706c617920666f726d61747320666f72206461746520616e642074696d652e223b7d7d, 'system', 0, 0, 0, 0, -15, 4, 0, 1, 8, 51, 98, 0, 0, 0, 0, 0, 0),
('management', 99, 19, 'admin/reports/event/%', 'admin/reports/event/%', 'Details', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 3, 0, 1, 19, 99, 0, 0, 0, 0, 0, 0, 0),
('management', 100, 46, 'admin/config/media/file-system', 'admin/config/media/file-system', 'File system', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36383a2254656c6c2044727570616c20776865726520746f2073746f72652075706c6f616465642066696c657320616e6420686f772074686579206172652061636365737365642e223b7d7d, 'system', 0, 0, 0, 0, -10, 4, 0, 1, 8, 46, 100, 0, 0, 0, 0, 0, 0),
('management', 101, 54, 'admin/appearance/settings/garland', 'admin/appearance/settings/garland', 'Garland', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 7, 54, 101, 0, 0, 0, 0, 0, 0),
('management', 102, 54, 'admin/appearance/settings/global', 'admin/appearance/settings/global', 'Global settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -1, 4, 0, 1, 7, 54, 102, 0, 0, 0, 0, 0, 0),
('management', 103, 48, 'admin/config/people/ip-blocking', 'admin/config/people/ip-blocking', 'IP address blocking', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32383a224d616e61676520626c6f636b6564204950206164647265737365732e223b7d7d, 'system', 0, 0, 1, 0, 10, 4, 0, 1, 8, 48, 103, 0, 0, 0, 0, 0, 0),
('management', 104, 46, 'admin/config/media/image-styles', 'admin/config/media/image-styles', 'Image styles', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a37383a22436f6e666967757265207374796c657320746861742063616e206265207573656420666f7220726573697a696e67206f722061646a757374696e6720696d61676573206f6e20646973706c61792e223b7d7d, 'system', 0, 0, 1, 0, 0, 4, 0, 1, 8, 46, 104, 0, 0, 0, 0, 0, 0),
('management', 105, 46, 'admin/config/media/image-toolkit', 'admin/config/media/image-toolkit', 'Image toolkit', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a37343a2243686f6f736520776869636820696d61676520746f6f6c6b697420746f2075736520696620796f75206861766520696e7374616c6c6564206f7074696f6e616c20746f6f6c6b6974732e223b7d7d, 'system', 0, 0, 0, 0, 20, 4, 0, 1, 8, 46, 105, 0, 0, 0, 0, 0, 0),
('management', 106, 36, 'admin/structure/types/list', 'admin/structure/types/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 4, 0, 1, 21, 36, 106, 0, 0, 0, 0, 0, 0),
('management', 107, 44, 'admin/modules/list/confirm', 'admin/modules/list/confirm', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 16, 44, 107, 0, 0, 0, 0, 0, 0),
('management', 108, 57, 'admin/structure/taxonomy/list', 'admin/structure/taxonomy/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 4, 0, 1, 21, 57, 108, 0, 0, 0, 0, 0, 0),
('management', 109, 47, 'admin/structure/menu/list', 'admin/structure/menu/list', 'List menus', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 4, 0, 1, 21, 47, 109, 0, 0, 0, 0, 0, 0),
('management', 110, 39, 'admin/config/development/logging', 'admin/config/development/logging', 'Logging and errors', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a3135343a2253657474696e677320666f72206c6f6767696e6720616e6420616c65727473206d6f64756c65732e20566172696f7573206d6f64756c65732063616e20726f7574652044727570616c27732073797374656d206576656e747320746f20646966666572656e742064657374696e6174696f6e732c2073756368206173207379736c6f672c2064617461626173652c20656d61696c2c206574632e223b7d7d, 'system', 0, 0, 0, 0, -15, 4, 0, 1, 8, 39, 110, 0, 0, 0, 0, 0, 0),
('management', 111, 39, 'admin/config/development/maintenance', 'admin/config/development/maintenance', 'Maintenance mode', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36323a2254616b65207468652073697465206f66666c696e6520666f72206d61696e74656e616e6365206f72206272696e67206974206261636b206f6e6c696e652e223b7d7d, 'system', 0, 0, 0, 0, -10, 4, 0, 1, 8, 39, 111, 0, 0, 0, 0, 0, 0),
('management', 112, 39, 'admin/config/development/performance', 'admin/config/development/performance', 'Performance', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a3130313a22456e61626c65206f722064697361626c6520706167652063616368696e6720666f7220616e6f6e796d6f757320757365727320616e64207365742043535320616e64204a532062616e647769647468206f7074696d697a6174696f6e206f7074696f6e732e223b7d7d, 'system', 0, 0, 0, 0, -20, 4, 0, 1, 8, 39, 112, 0, 0, 0, 0, 0, 0),
('management', 113, 49, 'admin/people/permissions/list', 'admin/people/permissions/list', 'Permissions', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36343a2244657465726d696e652061636365737320746f2066656174757265732062792073656c656374696e67207065726d697373696f6e7320666f7220726f6c65732e223b7d7d, 'system', -1, 0, 0, 0, -8, 4, 0, 1, 18, 49, 113, 0, 0, 0, 0, 0, 0),
('management', 114, 32, 'admin/content/comment/new', 'admin/content/comment/new', 'Published comments', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 4, 0, 1, 9, 32, 114, 0, 0, 0, 0, 0, 0),
('management', 115, 64, 'admin/config/services/rss-publishing', 'admin/config/services/rss-publishing', 'RSS publishing', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a3131343a22436f6e666967757265207468652073697465206465736372697074696f6e2c20746865206e756d626572206f66206974656d7320706572206665656420616e6420776865746865722066656564732073686f756c64206265207469746c65732f746561736572732f66756c6c2d746578742e223b7d7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 8, 64, 115, 0, 0, 0, 0, 0, 0),
('management', 116, 51, 'admin/config/regional/settings', 'admin/config/regional/settings', 'Regional settings', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35343a2253657474696e677320666f7220746865207369746527732064656661756c742074696d65207a6f6e6520616e6420636f756e7472792e223b7d7d, 'system', 0, 0, 0, 0, -20, 4, 0, 1, 8, 51, 116, 0, 0, 0, 0, 0, 0),
('management', 117, 49, 'admin/people/permissions/roles', 'admin/people/permissions/roles', 'Roles', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33303a224c6973742c20656469742c206f7220616464207573657220726f6c65732e223b7d7d, 'system', -1, 0, 1, 0, -5, 4, 0, 1, 18, 49, 117, 0, 0, 0, 0, 0, 0),
('management', 118, 47, 'admin/structure/menu/settings', 'admin/structure/menu/settings', 'Settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 5, 4, 0, 1, 21, 47, 118, 0, 0, 0, 0, 0, 0),
('management', 119, 54, 'admin/appearance/settings/seven', 'admin/appearance/settings/seven', 'Seven', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 7, 54, 119, 0, 0, 0, 0, 0, 0),
('management', 120, 56, 'admin/config/system/site-information', 'admin/config/system/site-information', 'Site information', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a3130343a224368616e67652073697465206e616d652c20652d6d61696c20616464726573732c20736c6f67616e2c2064656661756c742066726f6e7420706167652c20616e64206e756d626572206f6620706f7374732070657220706167652c206572726f722070616765732e223b7d7d, 'system', 0, 0, 0, 0, -20, 4, 0, 1, 8, 56, 120, 0, 0, 0, 0, 0, 0),
('management', 121, 54, 'admin/appearance/settings/stark', 'admin/appearance/settings/stark', 'Stark', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 7, 54, 121, 0, 0, 0, 0, 0, 0),
('management', 122, 35, 'admin/config/content/formats', 'admin/config/content/formats', 'Text formats', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a3132373a22436f6e66696775726520686f7720636f6e74656e7420696e7075742062792075736572732069732066696c74657265642c20696e636c7564696e6720616c6c6f7765642048544d4c20746167732e20416c736f20616c6c6f777320656e61626c696e67206f66206d6f64756c652d70726f76696465642066696c746572732e223b7d7d, 'system', 0, 0, 1, 0, 0, 4, 0, 1, 8, 35, 122, 0, 0, 0, 0, 0, 0),
('management', 123, 60, 'admin/modules/uninstall/confirm', 'admin/modules/uninstall/confirm', 'Uninstall', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 16, 60, 123, 0, 0, 0, 0, 0, 0),
('management', 124, 57, 'admin/structure/taxonomy/%', 'admin/structure/taxonomy/%', '', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 57, 124, 0, 0, 0, 0, 0, 0),
('management', 125, 32, 'admin/content/comment/approval', 'admin/content/comment/approval', 'Unapproved comments', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 9, 32, 125, 0, 0, 0, 0, 0, 0),
('navigation', 126, 40, 'user/%/edit/account', 'user/%/edit/account', 'Account', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 17, 40, 126, 0, 0, 0, 0, 0, 0, 0),
('management', 127, 122, 'admin/config/content/formats/%', 'admin/config/content/formats/%', '', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 5, 0, 1, 8, 35, 122, 127, 0, 0, 0, 0, 0),
('management', 128, 104, 'admin/config/media/image-styles/add', 'admin/config/media/image-styles/add', 'Add style', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32323a224164642061206e657720696d616765207374796c652e223b7d7d, 'system', -1, 0, 0, 0, 2, 5, 0, 1, 8, 46, 104, 128, 0, 0, 0, 0, 0),
('management', 129, 124, 'admin/structure/taxonomy/%/add', 'admin/structure/taxonomy/%/add', 'Add term', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 57, 124, 129, 0, 0, 0, 0, 0),
('management', 130, 122, 'admin/config/content/formats/add', 'admin/config/content/formats/add', 'Add text format', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 1, 5, 0, 1, 8, 35, 122, 130, 0, 0, 0, 0, 0),
('management', 131, 30, 'admin/structure/block/list/bartik', 'admin/structure/block/list/bartik', 'Bartik', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 30, 131, 0, 0, 0, 0, 0, 0),
('management', 132, 90, 'admin/config/system/actions/configure', 'admin/config/system/actions/configure', 'Configure an advanced action', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 8, 56, 90, 132, 0, 0, 0, 0, 0),
('management', 133, 47, 'admin/structure/menu/manage/%', 'admin/structure/menu/manage/%', 'Customize menu', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 4, 0, 1, 21, 47, 133, 0, 0, 0, 0, 0, 0),
('management', 134, 124, 'admin/structure/taxonomy/%/edit', 'admin/structure/taxonomy/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 5, 0, 1, 21, 57, 124, 134, 0, 0, 0, 0, 0),
('management', 135, 36, 'admin/structure/types/manage/%', 'admin/structure/types/manage/%', 'Edit content type', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 4, 0, 1, 21, 36, 135, 0, 0, 0, 0, 0, 0),
('management', 136, 98, 'admin/config/regional/date-time/formats', 'admin/config/regional/date-time/formats', 'Formats', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35313a22436f6e66696775726520646973706c617920666f726d617420737472696e677320666f72206461746520616e642074696d652e223b7d7d, 'system', -1, 0, 1, 0, -9, 5, 0, 1, 8, 51, 98, 136, 0, 0, 0, 0, 0),
('management', 137, 30, 'admin/structure/block/list/garland', 'admin/structure/block/list/garland', 'Garland', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 30, 137, 0, 0, 0, 0, 0, 0),
('management', 138, 124, 'admin/structure/taxonomy/%/list', 'admin/structure/taxonomy/%/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -20, 5, 0, 1, 21, 57, 124, 138, 0, 0, 0, 0, 0),
('management', 139, 122, 'admin/config/content/formats/list', 'admin/config/content/formats/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 8, 35, 122, 139, 0, 0, 0, 0, 0),
('management', 140, 104, 'admin/config/media/image-styles/list', 'admin/config/media/image-styles/list', 'List', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34323a224c697374207468652063757272656e7420696d616765207374796c6573206f6e2074686520736974652e223b7d7d, 'system', -1, 0, 0, 0, 1, 5, 0, 1, 8, 46, 104, 140, 0, 0, 0, 0, 0),
('management', 141, 90, 'admin/config/system/actions/manage', 'admin/config/system/actions/manage', 'Manage actions', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34313a224d616e6167652074686520616374696f6e7320646566696e656420666f7220796f757220736974652e223b7d7d, 'system', -1, 0, 0, 0, -2, 5, 0, 1, 8, 56, 90, 141, 0, 0, 0, 0, 0),
('management', 142, 89, 'admin/config/people/accounts/settings', 'admin/config/people/accounts/settings', 'Settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 5, 0, 1, 8, 48, 89, 142, 0, 0, 0, 0, 0),
('management', 143, 30, 'admin/structure/block/list/seven', 'admin/structure/block/list/seven', 'Seven', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 30, 143, 0, 0, 0, 0, 0, 0),
('management', 144, 30, 'admin/structure/block/list/stark', 'admin/structure/block/list/stark', 'Stark', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 30, 144, 0, 0, 0, 0, 0, 0),
('management', 145, 98, 'admin/config/regional/date-time/types', 'admin/config/regional/date-time/types', 'Types', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34343a22436f6e66696775726520646973706c617920666f726d61747320666f72206461746520616e642074696d652e223b7d7d, 'system', -1, 0, 1, 0, -10, 5, 0, 1, 8, 51, 98, 145, 0, 0, 0, 0, 0),
('navigation', 146, 52, 'node/%/revisions/%/delete', 'node/%/revisions/%/delete', 'Delete earlier revision', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 3, 0, 5, 52, 146, 0, 0, 0, 0, 0, 0, 0),
('navigation', 147, 52, 'node/%/revisions/%/revert', 'node/%/revisions/%/revert', 'Revert to earlier revision', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 3, 0, 5, 52, 147, 0, 0, 0, 0, 0, 0, 0),
('navigation', 148, 52, 'node/%/revisions/%/view', 'node/%/revisions/%/view', 'Revisions', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 3, 0, 5, 52, 148, 0, 0, 0, 0, 0, 0, 0),
('management', 149, 137, 'admin/structure/block/list/garland/add', 'admin/structure/block/list/garland/add', 'Add block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 30, 137, 149, 0, 0, 0, 0, 0),
('management', 150, 143, 'admin/structure/block/list/seven/add', 'admin/structure/block/list/seven/add', 'Add block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 30, 143, 150, 0, 0, 0, 0, 0),
('management', 151, 144, 'admin/structure/block/list/stark/add', 'admin/structure/block/list/stark/add', 'Add block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 30, 144, 151, 0, 0, 0, 0, 0),
('management', 152, 145, 'admin/config/regional/date-time/types/add', 'admin/config/regional/date-time/types/add', 'Add date type', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31383a22416464206e6577206461746520747970652e223b7d7d, 'system', -1, 0, 0, 0, -10, 6, 0, 1, 8, 51, 98, 145, 152, 0, 0, 0, 0),
('management', 153, 136, 'admin/config/regional/date-time/formats/add', 'admin/config/regional/date-time/formats/add', 'Add format', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34333a22416c6c6f7720757365727320746f20616464206164646974696f6e616c206461746520666f726d6174732e223b7d7d, 'system', -1, 0, 0, 0, -10, 6, 0, 1, 8, 51, 98, 136, 153, 0, 0, 0, 0),
('management', 154, 133, 'admin/structure/menu/manage/%/add', 'admin/structure/menu/manage/%/add', 'Add link', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 47, 133, 154, 0, 0, 0, 0, 0),
('management', 155, 30, 'admin/structure/block/manage/%/%', 'admin/structure/block/manage/%/%', 'Configure block', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 30, 155, 0, 0, 0, 0, 0, 0),
('navigation', 156, 31, 'user/%/cancel/confirm/%/%', 'user/%/cancel/confirm/%/%', 'Confirm account cancellation', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 3, 0, 17, 31, 156, 0, 0, 0, 0, 0, 0, 0),
('management', 157, 135, 'admin/structure/types/manage/%/delete', 'admin/structure/types/manage/%/delete', 'Delete', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 21, 36, 135, 157, 0, 0, 0, 0, 0),
('management', 158, 103, 'admin/config/people/ip-blocking/delete/%', 'admin/config/people/ip-blocking/delete/%', 'Delete IP address', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 8, 48, 103, 158, 0, 0, 0, 0, 0),
('management', 159, 90, 'admin/config/system/actions/delete/%', 'admin/config/system/actions/delete/%', 'Delete action', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31373a2244656c65746520616e20616374696f6e2e223b7d7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 8, 56, 90, 159, 0, 0, 0, 0, 0),
('management', 160, 133, 'admin/structure/menu/manage/%/delete', 'admin/structure/menu/manage/%/delete', 'Delete menu', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 21, 47, 133, 160, 0, 0, 0, 0, 0),
('management', 161, 47, 'admin/structure/menu/item/%/delete', 'admin/structure/menu/item/%/delete', 'Delete menu link', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 161, 0, 0, 0, 0, 0, 0),
('management', 162, 117, 'admin/people/permissions/roles/delete/%', 'admin/people/permissions/roles/delete/%', 'Delete role', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 18, 49, 117, 162, 0, 0, 0, 0, 0),
('management', 163, 127, 'admin/config/content/formats/%/disable', 'admin/config/content/formats/%/disable', 'Disable text format', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 35, 122, 127, 163, 0, 0, 0, 0),
('management', 164, 135, 'admin/structure/types/manage/%/edit', 'admin/structure/types/manage/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 36, 135, 164, 0, 0, 0, 0, 0),
('management', 165, 133, 'admin/structure/menu/manage/%/edit', 'admin/structure/menu/manage/%/edit', 'Edit menu', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 47, 133, 165, 0, 0, 0, 0, 0),
('management', 166, 47, 'admin/structure/menu/item/%/edit', 'admin/structure/menu/item/%/edit', 'Edit menu link', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 166, 0, 0, 0, 0, 0, 0),
('management', 167, 117, 'admin/people/permissions/roles/edit/%', 'admin/people/permissions/roles/edit/%', 'Edit role', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 18, 49, 117, 167, 0, 0, 0, 0, 0),
('management', 168, 104, 'admin/config/media/image-styles/edit/%', 'admin/config/media/image-styles/edit/%', 'Edit style', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32353a22436f6e66696775726520616e20696d616765207374796c652e223b7d7d, 'system', 0, 0, 1, 0, 0, 5, 0, 1, 8, 46, 104, 168, 0, 0, 0, 0, 0),
('management', 169, 133, 'admin/structure/menu/manage/%/list', 'admin/structure/menu/manage/%/list', 'List links', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 5, 0, 1, 21, 47, 133, 169, 0, 0, 0, 0, 0),
('management', 170, 47, 'admin/structure/menu/item/%/reset', 'admin/structure/menu/item/%/reset', 'Reset menu link', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 170, 0, 0, 0, 0, 0, 0),
('management', 171, 104, 'admin/config/media/image-styles/delete/%', 'admin/config/media/image-styles/delete/%', 'Delete style', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32323a2244656c65746520616e20696d616765207374796c652e223b7d7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 8, 46, 104, 171, 0, 0, 0, 0, 0),
('management', 172, 104, 'admin/config/media/image-styles/revert/%', 'admin/config/media/image-styles/revert/%', 'Revert style', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32323a2252657665727420616e20696d616765207374796c652e223b7d7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 8, 46, 104, 172, 0, 0, 0, 0, 0),
('management', 173, 135, 'admin/structure/types/manage/%/comment/display', 'admin/structure/types/manage/%/comment/display', 'Comment display', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 4, 5, 0, 1, 21, 36, 135, 173, 0, 0, 0, 0, 0),
('management', 174, 135, 'admin/structure/types/manage/%/comment/fields', 'admin/structure/types/manage/%/comment/fields', 'Comment fields', 0x613a303a7b7d, 'system', -1, 0, 1, 0, 3, 5, 0, 1, 21, 36, 135, 174, 0, 0, 0, 0, 0),
('management', 175, 155, 'admin/structure/block/manage/%/%/configure', 'admin/structure/block/manage/%/%/configure', 'Configure block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 30, 155, 175, 0, 0, 0, 0, 0),
('management', 176, 155, 'admin/structure/block/manage/%/%/delete', 'admin/structure/block/manage/%/%/delete', 'Delete block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 30, 155, 176, 0, 0, 0, 0, 0),
('management', 177, 136, 'admin/config/regional/date-time/formats/%/delete', 'admin/config/regional/date-time/formats/%/delete', 'Delete date format', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34373a22416c6c6f7720757365727320746f2064656c657465206120636f6e66696775726564206461746520666f726d61742e223b7d7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 51, 98, 136, 177, 0, 0, 0, 0),
('management', 178, 145, 'admin/config/regional/date-time/types/%/delete', 'admin/config/regional/date-time/types/%/delete', 'Delete date type', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34353a22416c6c6f7720757365727320746f2064656c657465206120636f6e66696775726564206461746520747970652e223b7d7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 51, 98, 145, 178, 0, 0, 0, 0),
('management', 179, 136, 'admin/config/regional/date-time/formats/%/edit', 'admin/config/regional/date-time/formats/%/edit', 'Edit date format', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34353a22416c6c6f7720757365727320746f2065646974206120636f6e66696775726564206461746520666f726d61742e223b7d7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 51, 98, 136, 179, 0, 0, 0, 0),
('management', 180, 168, 'admin/config/media/image-styles/edit/%/add/%', 'admin/config/media/image-styles/edit/%/add/%', 'Add image effect', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32383a224164642061206e65772065666665637420746f2061207374796c652e223b7d7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 46, 104, 168, 180, 0, 0, 0, 0),
('management', 181, 168, 'admin/config/media/image-styles/edit/%/effects/%', 'admin/config/media/image-styles/edit/%/effects/%', 'Edit image effect', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33393a224564697420616e206578697374696e67206566666563742077697468696e2061207374796c652e223b7d7d, 'system', 0, 0, 1, 0, 0, 6, 0, 1, 8, 46, 104, 168, 181, 0, 0, 0, 0),
('management', 182, 181, 'admin/config/media/image-styles/edit/%/effects/%/delete', 'admin/config/media/image-styles/edit/%/effects/%/delete', 'Delete image effect', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33393a2244656c65746520616e206578697374696e67206566666563742066726f6d2061207374796c652e223b7d7d, 'system', 0, 0, 0, 0, 0, 7, 0, 1, 8, 46, 104, 168, 181, 182, 0, 0, 0),
('management', 183, 47, 'admin/structure/menu/manage/main-menu', 'admin/structure/menu/manage/%', 'Main menu', 0x613a303a7b7d, 'menu', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 183, 0, 0, 0, 0, 0, 0),
('management', 184, 47, 'admin/structure/menu/manage/management', 'admin/structure/menu/manage/%', 'Management', 0x613a303a7b7d, 'menu', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 184, 0, 0, 0, 0, 0, 0),
('management', 185, 47, 'admin/structure/menu/manage/navigation', 'admin/structure/menu/manage/%', 'Navigation', 0x613a303a7b7d, 'menu', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 185, 0, 0, 0, 0, 0, 0),
('management', 186, 47, 'admin/structure/menu/manage/user-menu', 'admin/structure/menu/manage/%', 'User menu', 0x613a303a7b7d, 'menu', 0, 0, 0, 0, 0, 4, 0, 1, 21, 47, 186, 0, 0, 0, 0, 0, 0),
('navigation', 187, 0, 'search', 'search', 'Search', 0x613a303a7b7d, 'system', 1, 0, 0, 0, 0, 1, 0, 187, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 188, 187, 'search/node', 'search/node', 'Content', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 2, 0, 187, 188, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 189, 187, 'search/user', 'search/user', 'Users', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 187, 189, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 190, 188, 'search/node/%', 'search/node/%', 'Content', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 187, 188, 190, 0, 0, 0, 0, 0, 0, 0),
('navigation', 191, 17, 'user/%/shortcuts', 'user/%/shortcuts', 'Shortcuts', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 2, 0, 17, 191, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 192, 19, 'admin/reports/search', 'admin/reports/search', 'Top search phrases', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33333a2256696577206d6f737420706f70756c61722073656172636820706872617365732e223b7d7d, 'system', 0, 0, 0, 0, 0, 3, 0, 1, 19, 192, 0, 0, 0, 0, 0, 0, 0),
('navigation', 193, 189, 'search/user/%', 'search/user/%', 'Users', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 187, 189, 193, 0, 0, 0, 0, 0, 0, 0),
('management', 194, 12, 'admin/help/number', 'admin/help/number', 'number', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 194, 0, 0, 0, 0, 0, 0, 0),
('management', 195, 12, 'admin/help/overlay', 'admin/help/overlay', 'overlay', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 195, 0, 0, 0, 0, 0, 0, 0),
('management', 196, 12, 'admin/help/path', 'admin/help/path', 'path', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 196, 0, 0, 0, 0, 0, 0, 0),
('management', 197, 12, 'admin/help/rdf', 'admin/help/rdf', 'rdf', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 197, 0, 0, 0, 0, 0, 0, 0),
('management', 198, 12, 'admin/help/search', 'admin/help/search', 'search', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 198, 0, 0, 0, 0, 0, 0, 0),
('management', 199, 12, 'admin/help/shortcut', 'admin/help/shortcut', 'shortcut', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 199, 0, 0, 0, 0, 0, 0, 0),
('management', 200, 53, 'admin/config/search/settings', 'admin/config/search/settings', 'Search settings', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36373a22436f6e6669677572652072656c6576616e63652073657474696e677320666f722073656172636820616e64206f7468657220696e646578696e67206f7074696f6e732e223b7d7d, 'system', 0, 0, 0, 0, -10, 4, 0, 1, 8, 53, 200, 0, 0, 0, 0, 0, 0),
('management', 201, 61, 'admin/config/user-interface/shortcut', 'admin/config/user-interface/shortcut', 'Shortcuts', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32393a2241646420616e64206d6f646966792073686f727463757420736574732e223b7d7d, 'system', 0, 0, 1, 0, 0, 4, 0, 1, 8, 61, 201, 0, 0, 0, 0, 0, 0),
('management', 202, 53, 'admin/config/search/path', 'admin/config/search/path', 'URL aliases', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a34363a224368616e676520796f7572207369746527732055524c20706174687320627920616c696173696e67207468656d2e223b7d7d, 'system', 0, 0, 1, 0, -5, 4, 0, 1, 8, 53, 202, 0, 0, 0, 0, 0, 0),
('management', 203, 202, 'admin/config/search/path/add', 'admin/config/search/path/add', 'Add alias', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 8, 53, 202, 203, 0, 0, 0, 0, 0),
('management', 204, 201, 'admin/config/user-interface/shortcut/add-set', 'admin/config/user-interface/shortcut/add-set', 'Add shortcut set', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 8, 61, 201, 204, 0, 0, 0, 0, 0);
INSERT INTO `menu_links` (`menu_name`, `mlid`, `plid`, `link_path`, `router_path`, `link_title`, `options`, `module`, `hidden`, `external`, `has_children`, `expanded`, `weight`, `depth`, `customized`, `p1`, `p2`, `p3`, `p4`, `p5`, `p6`, `p7`, `p8`, `p9`, `updated`) VALUES
('management', 205, 200, 'admin/config/search/settings/reindex', 'admin/config/search/settings/reindex', 'Clear index', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 8, 53, 200, 205, 0, 0, 0, 0, 0),
('management', 206, 201, 'admin/config/user-interface/shortcut/%', 'admin/config/user-interface/shortcut/%', 'Edit shortcuts', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 5, 0, 1, 8, 61, 201, 206, 0, 0, 0, 0, 0),
('management', 207, 202, 'admin/config/search/path/list', 'admin/config/search/path/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 5, 0, 1, 8, 53, 202, 207, 0, 0, 0, 0, 0),
('management', 208, 206, 'admin/config/user-interface/shortcut/%/add-link', 'admin/config/user-interface/shortcut/%/add-link', 'Add shortcut', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 6, 0, 1, 8, 61, 201, 206, 208, 0, 0, 0, 0),
('management', 209, 202, 'admin/config/search/path/delete/%', 'admin/config/search/path/delete/%', 'Delete alias', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 8, 53, 202, 209, 0, 0, 0, 0, 0),
('management', 210, 206, 'admin/config/user-interface/shortcut/%/delete', 'admin/config/user-interface/shortcut/%/delete', 'Delete shortcut set', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 61, 201, 206, 210, 0, 0, 0, 0),
('management', 211, 202, 'admin/config/search/path/edit/%', 'admin/config/search/path/edit/%', 'Edit alias', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 5, 0, 1, 8, 53, 202, 211, 0, 0, 0, 0, 0),
('management', 212, 206, 'admin/config/user-interface/shortcut/%/edit', 'admin/config/user-interface/shortcut/%/edit', 'Edit set name', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 6, 0, 1, 8, 61, 201, 206, 212, 0, 0, 0, 0),
('management', 213, 201, 'admin/config/user-interface/shortcut/link/%', 'admin/config/user-interface/shortcut/link/%', 'Edit shortcut', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 5, 0, 1, 8, 61, 201, 213, 0, 0, 0, 0, 0),
('management', 214, 206, 'admin/config/user-interface/shortcut/%/links', 'admin/config/user-interface/shortcut/%/links', 'List links', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 6, 0, 1, 8, 61, 201, 206, 214, 0, 0, 0, 0),
('management', 215, 213, 'admin/config/user-interface/shortcut/link/%/delete', 'admin/config/user-interface/shortcut/link/%/delete', 'Delete shortcut', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 61, 201, 213, 215, 0, 0, 0, 0),
('shortcut-set-1', 216, 0, 'node/add', 'node/add', 'Add content', 0x613a303a7b7d, 'menu', 0, 0, 0, 0, -20, 1, 0, 216, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('shortcut-set-1', 217, 0, 'admin/content', 'admin/content', 'Find content', 0x613a303a7b7d, 'menu', 0, 0, 0, 0, -19, 1, 0, 217, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 218, 0, '<front>', '', 'Home', 0x613a303a7b7d, 'menu', 0, 1, 0, 0, -50, 1, 1, 218, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 219, 6, 'node/add/article', 'node/add/article', 'Article', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a38393a22557365203c656d3e61727469636c65733c2f656d3e20666f722074696d652d73656e73697469766520636f6e74656e74206c696b65206e6577732c2070726573732072656c6561736573206f7220626c6f6720706f7374732e223b7d7d, 'system', 0, 0, 0, 0, 0, 2, 0, 6, 219, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 220, 6, 'node/add/page', 'node/add/page', 'Basic page', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a37373a22557365203c656d3e62617369632070616765733c2f656d3e20666f7220796f75722073746174696320636f6e74656e742c207375636820617320616e202741626f75742075732720706167652e223b7d7d, 'system', 0, 0, 0, 0, 0, 2, 0, 6, 220, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 221, 12, 'admin/help/toolbar', 'admin/help/toolbar', 'toolbar', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 221, 0, 0, 0, 0, 0, 0, 0),
('management', 260, 19, 'admin/reports/updates', 'admin/reports/updates', 'Available updates', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a38323a22476574206120737461747573207265706f72742061626f757420617661696c61626c65207570646174657320666f7220796f757220696e7374616c6c6564206d6f64756c657320616e64207468656d65732e223b7d7d, 'system', 0, 0, 0, 0, -50, 3, 0, 1, 19, 260, 0, 0, 0, 0, 0, 0, 0),
('management', 261, 7, 'admin/appearance/install', 'admin/appearance/install', 'Install new theme', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 25, 3, 0, 1, 7, 261, 0, 0, 0, 0, 0, 0, 0),
('management', 262, 16, 'admin/modules/update', 'admin/modules/update', 'Update', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 3, 0, 1, 16, 262, 0, 0, 0, 0, 0, 0, 0),
('management', 263, 16, 'admin/modules/install', 'admin/modules/install', 'Install new module', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 25, 3, 0, 1, 16, 263, 0, 0, 0, 0, 0, 0, 0),
('management', 264, 7, 'admin/appearance/update', 'admin/appearance/update', 'Update', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 3, 0, 1, 7, 264, 0, 0, 0, 0, 0, 0, 0),
('management', 265, 12, 'admin/help/update', 'admin/help/update', 'update', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 265, 0, 0, 0, 0, 0, 0, 0),
('management', 266, 260, 'admin/reports/updates/install', 'admin/reports/updates/install', 'Install new module or theme', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 25, 4, 0, 1, 19, 260, 266, 0, 0, 0, 0, 0, 0),
('management', 267, 260, 'admin/reports/updates/update', 'admin/reports/updates/update', 'Update', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 4, 0, 1, 19, 260, 267, 0, 0, 0, 0, 0, 0),
('management', 268, 260, 'admin/reports/updates/list', 'admin/reports/updates/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 19, 260, 268, 0, 0, 0, 0, 0, 0),
('management', 269, 260, 'admin/reports/updates/settings', 'admin/reports/updates/settings', 'Settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 50, 4, 0, 1, 19, 260, 269, 0, 0, 0, 0, 0, 0),
('management', 311, 131, 'admin/structure/block/list/bartik/add', 'admin/structure/block/list/bartik/add', 'Add block', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 5, 0, 1, 21, 30, 131, 311, 0, 0, 0, 0, 0),
('main-menu', 314, 0, 'contact', 'contact', 'Contact', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a373a22436f6e74616374223b7d7d, 'menu', 0, 0, 0, 0, -45, 1, 1, 314, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 315, 0, 'forum', 'forum', 'Forum', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a353a22466f72756d223b7d7d, 'menu', 0, 0, 1, 1, -47, 1, 1, 315, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 316, 0, 'node/7', 'node/%', 'Download', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a383a22446f776e6c6f6164223b7d7d, 'menu', 0, 0, 0, 0, -46, 1, 1, 316, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 547, 539, 'admin/structure/types/manage/%/comment/fields/%/widget-type', 'admin/structure/types/manage/%/comment/fields/%/widget-type', 'Widget type', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 36, 135, 174, 539, 547, 0, 0, 0),
('management', 546, 539, 'admin/structure/types/manage/%/comment/fields/%/field-settings', 'admin/structure/types/manage/%/comment/fields/%/field-settings', 'Field settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 36, 135, 174, 539, 546, 0, 0, 0),
('management', 545, 539, 'admin/structure/types/manage/%/comment/fields/%/edit', 'admin/structure/types/manage/%/comment/fields/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 36, 135, 174, 539, 545, 0, 0, 0),
('management', 539, 174, 'admin/structure/types/manage/%/comment/fields/%', 'admin/structure/types/manage/%/comment/fields/%', '', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 21, 36, 135, 174, 539, 0, 0, 0, 0),
('management', 540, 528, 'admin/structure/types/manage/%/fields/%/delete', 'admin/structure/types/manage/%/fields/%/delete', 'Delete', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 7, 0, 1, 21, 36, 135, 517, 528, 540, 0, 0, 0),
('management', 541, 528, 'admin/structure/types/manage/%/fields/%/edit', 'admin/structure/types/manage/%/fields/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 36, 135, 517, 528, 541, 0, 0, 0),
('management', 542, 528, 'admin/structure/types/manage/%/fields/%/field-settings', 'admin/structure/types/manage/%/fields/%/field-settings', 'Field settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 36, 135, 517, 528, 542, 0, 0, 0),
('management', 535, 521, 'admin/config/people/accounts/fields/%/field-settings', 'admin/config/people/accounts/fields/%/field-settings', 'Field settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 8, 48, 89, 513, 521, 535, 0, 0, 0),
('management', 534, 521, 'admin/config/people/accounts/fields/%/edit', 'admin/config/people/accounts/fields/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 8, 48, 89, 513, 521, 534, 0, 0, 0),
('management', 529, 520, 'admin/structure/taxonomy/%/fields/%/delete', 'admin/structure/taxonomy/%/fields/%/delete', 'Delete', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 7, 0, 1, 21, 57, 124, 512, 520, 529, 0, 0, 0),
('management', 530, 520, 'admin/structure/taxonomy/%/fields/%/edit', 'admin/structure/taxonomy/%/fields/%/edit', 'Edit', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 57, 124, 512, 520, 530, 0, 0, 0),
('management', 531, 520, 'admin/structure/taxonomy/%/fields/%/field-settings', 'admin/structure/taxonomy/%/fields/%/field-settings', 'Field settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 57, 124, 512, 520, 531, 0, 0, 0),
('management', 532, 520, 'admin/structure/taxonomy/%/fields/%/widget-type', 'admin/structure/taxonomy/%/fields/%/widget-type', 'Widget type', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 57, 124, 512, 520, 532, 0, 0, 0),
('management', 533, 521, 'admin/config/people/accounts/fields/%/delete', 'admin/config/people/accounts/fields/%/delete', 'Delete', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 7, 0, 1, 8, 48, 89, 513, 521, 533, 0, 0, 0),
('management', 526, 516, 'admin/structure/types/manage/%/display/search_result', 'admin/structure/types/manage/%/display/search_result', 'Search result', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 4, 6, 0, 1, 21, 36, 135, 516, 526, 0, 0, 0, 0),
('management', 527, 516, 'admin/structure/types/manage/%/display/teaser', 'admin/structure/types/manage/%/display/teaser', 'Teaser', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 1, 6, 0, 1, 21, 36, 135, 516, 527, 0, 0, 0, 0),
('management', 528, 517, 'admin/structure/types/manage/%/fields/%', 'admin/structure/types/manage/%/fields/%', '', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 21, 36, 135, 517, 528, 0, 0, 0, 0),
('management', 525, 516, 'admin/structure/types/manage/%/display/search_index', 'admin/structure/types/manage/%/display/search_index', 'Search index', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 3, 6, 0, 1, 21, 36, 135, 516, 525, 0, 0, 0, 0),
('management', 524, 516, 'admin/structure/types/manage/%/display/rss', 'admin/structure/types/manage/%/display/rss', 'RSS', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 2, 6, 0, 1, 21, 36, 135, 516, 524, 0, 0, 0, 0),
('management', 523, 516, 'admin/structure/types/manage/%/display/full', 'admin/structure/types/manage/%/display/full', 'Full content', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 6, 0, 1, 21, 36, 135, 516, 523, 0, 0, 0, 0),
('management', 520, 512, 'admin/structure/taxonomy/%/fields/%', 'admin/structure/taxonomy/%/fields/%', '', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 21, 57, 124, 512, 520, 0, 0, 0, 0),
('management', 521, 513, 'admin/config/people/accounts/fields/%', 'admin/config/people/accounts/fields/%', '', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 6, 0, 1, 8, 48, 89, 513, 521, 0, 0, 0, 0),
('management', 522, 516, 'admin/structure/types/manage/%/display/default', 'admin/structure/types/manage/%/display/default', 'Default', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 6, 0, 1, 21, 36, 135, 516, 522, 0, 0, 0, 0),
('management', 519, 511, 'admin/config/people/accounts/display/full', 'admin/config/people/accounts/display/full', 'User account', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 6, 0, 1, 8, 48, 89, 511, 519, 0, 0, 0, 0),
('management', 510, 124, 'admin/structure/taxonomy/%/display', 'admin/structure/taxonomy/%/display', 'Manage display', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 2, 5, 0, 1, 21, 57, 124, 510, 0, 0, 0, 0, 0),
('management', 511, 89, 'admin/config/people/accounts/display', 'admin/config/people/accounts/display', 'Manage display', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 2, 5, 0, 1, 8, 48, 89, 511, 0, 0, 0, 0, 0),
('management', 512, 124, 'admin/structure/taxonomy/%/fields', 'admin/structure/taxonomy/%/fields', 'Manage fields', 0x613a303a7b7d, 'system', -1, 0, 1, 0, 1, 5, 0, 1, 21, 57, 124, 512, 0, 0, 0, 0, 0),
('management', 513, 89, 'admin/config/people/accounts/fields', 'admin/config/people/accounts/fields', 'Manage fields', 0x613a303a7b7d, 'system', -1, 0, 1, 0, 1, 5, 0, 1, 8, 48, 89, 513, 0, 0, 0, 0, 0),
('management', 514, 510, 'admin/structure/taxonomy/%/display/default', 'admin/structure/taxonomy/%/display/default', 'Default', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 6, 0, 1, 21, 57, 124, 510, 514, 0, 0, 0, 0),
('management', 515, 511, 'admin/config/people/accounts/display/default', 'admin/config/people/accounts/display/default', 'Default', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 6, 0, 1, 8, 48, 89, 511, 515, 0, 0, 0, 0),
('management', 516, 135, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%/display', 'Manage display', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 2, 5, 0, 1, 21, 36, 135, 516, 0, 0, 0, 0, 0),
('management', 517, 135, 'admin/structure/types/manage/%/fields', 'admin/structure/types/manage/%/fields', 'Manage fields', 0x613a303a7b7d, 'system', -1, 0, 1, 0, 1, 5, 0, 1, 21, 36, 135, 517, 0, 0, 0, 0, 0),
('management', 518, 510, 'admin/structure/taxonomy/%/display/full', 'admin/structure/taxonomy/%/display/full', 'Taxonomy term page', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 6, 0, 1, 21, 57, 124, 510, 518, 0, 0, 0, 0),
('management', 355, 12, 'admin/help/php', 'admin/help/php', 'php', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 355, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 356, 0, 'node/2', 'node/%', 'About Skeleton', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31343a2241626f757420536b656c65746f6e223b7d7d, 'menu', 0, 0, 1, 1, -49, 1, 1, 356, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 357, 0, 'node/3', 'node/%', 'Documentation', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31333a22446f63756d656e746174696f6e223b7d7d, 'menu', 0, 0, 0, 0, -48, 1, 1, 357, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 358, 0, 'blog', 'blog', 'Blogs', 0x613a303a7b7d, 'system', 1, 0, 1, 0, 0, 1, 0, 358, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 359, 358, 'blog/%', 'blog/%', 'My blog', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 2, 0, 358, 359, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 360, 6, 'node/add/blog', 'node/add/blog', 'Blog entry', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a35383a2255736520666f72206d756c74692d7573657220626c6f67732e20457665727920757365722067657473206120706572736f6e616c20626c6f672e223b7d7d, 'system', 0, 0, 0, 0, 0, 2, 0, 6, 360, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 361, 12, 'admin/help/blog', 'admin/help/blog', 'blog', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 361, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 362, 356, 'blog', 'blog', 'Sample Blog', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31313a2253616d706c6520426c6f67223b7d7d, 'menu', 0, 0, 1, 1, -47, 2, 1, 356, 362, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 363, 315, 'user', 'user', 'Login', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a353a224c6f67696e223b7d7d, 'menu', 0, 0, 0, 0, -50, 2, 1, 315, 363, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 364, 315, 'user', 'user', 'Register', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a383a225265676973746572223b7d7d, 'menu', 0, 0, 0, 0, -49, 2, 1, 315, 364, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 365, 0, 'forum', 'forum', 'Forums', 0x613a303a7b7d, 'system', 0, 0, 1, 0, 0, 1, 0, 365, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 366, 365, 'forum/%', 'forum/%', 'Forums', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 2, 0, 365, 366, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 367, 6, 'node/add/forum', 'node/add/forum', 'Forum topic', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a36393a2241203c656d3e666f72756d20746f7069633c2f656d3e207374617274732061206e65772064697363757373696f6e207468726561642077697468696e206120666f72756d2e223b7d7d, 'system', 0, 0, 0, 0, 0, 2, 0, 6, 367, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 368, 21, 'admin/structure/forum', 'admin/structure/forum', 'Forums', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a33333a22436f6e74726f6c20666f72756d206869657261726368792073657474696e67732e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 21, 368, 0, 0, 0, 0, 0, 0, 0),
('management', 369, 12, 'admin/help/forum', 'admin/help/forum', 'forum', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 369, 0, 0, 0, 0, 0, 0, 0),
('management', 370, 368, 'admin/structure/forum/list', 'admin/structure/forum/list', 'List', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 4, 0, 1, 21, 368, 370, 0, 0, 0, 0, 0, 0),
('management', 371, 368, 'admin/structure/forum/settings', 'admin/structure/forum/settings', 'Settings', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 5, 4, 0, 1, 21, 368, 371, 0, 0, 0, 0, 0, 0),
('management', 372, 368, 'admin/structure/forum/add/container', 'admin/structure/forum/add/container', 'Add container', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 368, 372, 0, 0, 0, 0, 0, 0),
('management', 373, 368, 'admin/structure/forum/add/forum', 'admin/structure/forum/add/forum', 'Add forum', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 21, 368, 373, 0, 0, 0, 0, 0, 0),
('management', 374, 368, 'admin/structure/forum/edit/container/%', 'admin/structure/forum/edit/container/%', 'Edit container', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 368, 374, 0, 0, 0, 0, 0, 0),
('management', 375, 368, 'admin/structure/forum/edit/forum/%', 'admin/structure/forum/edit/forum/%', 'Edit forum', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 368, 375, 0, 0, 0, 0, 0, 0),
('navigation', 376, 0, 'contact', 'contact', 'Contact', 0x613a303a7b7d, 'system', 1, 0, 0, 0, 0, 1, 0, 376, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('navigation', 377, 17, 'user/%/contact', 'user/%/contact', 'Contact', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 2, 2, 0, 17, 377, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 378, 21, 'admin/structure/contact', 'admin/structure/contact', 'Contact form', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a37313a2243726561746520612073797374656d20636f6e7461637420666f726d20616e64207365742075702063617465676f7269657320666f722074686520666f726d20746f207573652e223b7d7d, 'system', 0, 0, 1, 0, 0, 3, 0, 1, 21, 378, 0, 0, 0, 0, 0, 0, 0),
('management', 379, 12, 'admin/help/contact', 'admin/help/contact', 'contact', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 379, 0, 0, 0, 0, 0, 0, 0),
('management', 380, 378, 'admin/structure/contact/add', 'admin/structure/contact/add', 'Add category', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 1, 4, 0, 1, 21, 378, 380, 0, 0, 0, 0, 0, 0),
('management', 381, 378, 'admin/structure/contact/delete/%', 'admin/structure/contact/delete/%', 'Delete contact', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 378, 381, 0, 0, 0, 0, 0, 0),
('management', 382, 378, 'admin/structure/contact/edit/%', 'admin/structure/contact/edit/%', 'Edit contact category', 0x613a303a7b7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 21, 378, 382, 0, 0, 0, 0, 0, 0),
('main-menu', 383, 0, 'blog', 'blog', 'Blog', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a343a22426c6f67223b7d7d, 'menu', 0, 0, 0, 0, -43, 1, 1, 383, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 384, 356, 'node/8', 'node/%', 'Button Styles', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31333a22427574746f6e205374796c6573223b7d7d, 'menu', 0, 0, 0, 0, -49, 2, 1, 356, 384, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 385, 356, 'node/9', 'node/%', 'Typography', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a31303a225479706f677261706879223b7d7d, 'menu', 0, 0, 0, 0, -48, 2, 1, 356, 385, 0, 0, 0, 0, 0, 0, 0, 0),
('main-menu', 386, 0, 'node/10', 'node/%', 'Columns', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a373a22436f6c756d6e73223b7d7d, 'menu', 0, 0, 0, 0, -44, 1, 1, 386, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('management', 387, 54, 'admin/appearance/settings/skeletontheme', 'admin/appearance/settings/skeletontheme', 'Skeleton', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 4, 0, 1, 7, 54, 387, 0, 0, 0, 0, 0, 0),
('management', 388, 30, 'admin/structure/block/list/skeletontheme', 'admin/structure/block/list/skeletontheme', 'Skeleton', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 4, 0, 1, 21, 30, 388, 0, 0, 0, 0, 0, 0),
('management', 544, 539, 'admin/structure/types/manage/%/comment/fields/%/delete', 'admin/structure/types/manage/%/comment/fields/%/delete', 'Delete', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 10, 7, 0, 1, 21, 36, 135, 174, 539, 544, 0, 0, 0),
('management', 543, 528, 'admin/structure/types/manage/%/fields/%/widget-type', 'admin/structure/types/manage/%/fields/%/widget-type', 'Widget type', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 21, 36, 135, 517, 528, 543, 0, 0, 0),
('main-menu', 393, 362, 'node/5', 'node/%', 'Blog Post with comments', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32333a22426c6f6720506f7374207769746820636f6d6d656e7473223b7d7d, 'menu', 0, 0, 0, 0, -50, 3, 1, 356, 362, 393, 0, 0, 0, 0, 0, 0, 0),
('management', 432, 12, 'admin/help/superfish', 'admin/help/superfish', 'superfish', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 3, 0, 1, 12, 432, 0, 0, 0, 0, 0, 0, 0),
('management', 433, 61, 'admin/config/user-interface/superfish', 'admin/config/user-interface/superfish', 'Superfish', 0x613a313a7b733a31303a2261747472696275746573223b613a313a7b733a353a227469746c65223b733a32353a22436f6e66696775726520537570657266697368204d656e7573223b7d7d, 'system', 0, 0, 0, 0, 0, 4, 0, 1, 8, 61, 433, 0, 0, 0, 0, 0, 0),
('management', 538, 173, 'admin/structure/types/manage/%/comment/display/full', 'admin/structure/types/manage/%/comment/display/full', 'Full comment', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 6, 0, 1, 21, 36, 135, 173, 538, 0, 0, 0, 0),
('management', 536, 521, 'admin/config/people/accounts/fields/%/widget-type', 'admin/config/people/accounts/fields/%/widget-type', 'Widget type', 0x613a303a7b7d, 'system', -1, 0, 0, 0, 0, 7, 0, 1, 8, 48, 89, 513, 521, 536, 0, 0, 0),
('management', 537, 173, 'admin/structure/types/manage/%/comment/display/default', 'admin/structure/types/manage/%/comment/display/default', 'Default', 0x613a303a7b7d, 'system', -1, 0, 0, 0, -10, 6, 0, 1, 21, 36, 135, 173, 537, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `menu_router`
--

CREATE TABLE IF NOT EXISTS `menu_router` (
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: the Drupal path this entry describes',
  `load_functions` blob NOT NULL COMMENT 'A serialized array of function names (like node_load) to be called to load an object corresponding to a part of the current path.',
  `to_arg_functions` blob NOT NULL COMMENT 'A serialized array of function names (like user_uid_optional_to_arg) to be called to replace a part of the router path with another string.',
  `access_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The callback which determines the access to this router path. Defaults to user_access.',
  `access_arguments` blob COMMENT 'A serialized array of arguments for the access callback.',
  `page_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the function that renders the page.',
  `page_arguments` blob COMMENT 'A serialized array of arguments for the page callback.',
  `delivery_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the function that sends the result of the page_callback function to the browser.',
  `fit` int(11) NOT NULL DEFAULT '0' COMMENT 'A numeric representation of how specific the path is.',
  `number_parts` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Number of parts in this router path.',
  `context` int(11) NOT NULL DEFAULT '0' COMMENT 'Only for local tasks (tabs) - the context of a local task to control its placement.',
  `tab_parent` varchar(255) NOT NULL DEFAULT '' COMMENT 'Only for local tasks (tabs) - the router path of the parent page (which may also be a local task).',
  `tab_root` varchar(255) NOT NULL DEFAULT '' COMMENT 'Router path of the closest non-tab parent page. For pages that are not local tasks, this will be the same as the path.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title for the current page, or the title for the tab if this is a local task.',
  `title_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'A function which will alter the title. Defaults to t()',
  `title_arguments` varchar(255) NOT NULL DEFAULT '' COMMENT 'A serialized array of arguments for the title callback. If empty, the title will be used as the sole argument for the title callback.',
  `theme_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'A function which returns the name of the theme that will be used to render this page. If left empty, the default theme will be used.',
  `theme_arguments` varchar(255) NOT NULL DEFAULT '' COMMENT 'A serialized array of arguments for the theme callback.',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT 'Numeric representation of the type of the menu item, like MENU_LOCAL_TASK.',
  `description` text NOT NULL COMMENT 'A description of this item.',
  `position` varchar(255) NOT NULL DEFAULT '' COMMENT 'The position of the block (left or right) on the system administration page for this item.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of the element. Lighter weights are higher up, heavier weights go down.',
  `include_file` mediumtext COMMENT 'The file to include for this element, usually the page callback function lives in this file.',
  PRIMARY KEY (`path`),
  KEY `fit` (`fit`),
  KEY `tab_parent` (`tab_parent`(64),`weight`,`title`),
  KEY `tab_root_weight_title` (`tab_root`(64),`weight`,`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Maps paths to various callbacks (access, page and title)';

--
-- Άδειασμα δεδομένων του πίνακα `menu_router`
--

INSERT INTO `menu_router` (`path`, `load_functions`, `to_arg_functions`, `access_callback`, `access_arguments`, `page_callback`, `page_arguments`, `delivery_callback`, `fit`, `number_parts`, `context`, `tab_parent`, `tab_root`, `title`, `title_callback`, `title_arguments`, `theme_callback`, `theme_arguments`, `type`, `description`, `position`, `weight`, `include_file`) VALUES
('blog', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'blog_page_last', 0x613a303a7b7d, '', 1, 1, 0, '', 'blog', 'Blogs', 't', '', '', 'a:0:{}', 20, '', '', 0, 'modules/blog/blog.pages.inc'),
('forum', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'forum_page', 0x613a303a7b7d, '', 1, 1, 0, '', 'forum', 'Forums', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/forum/forum.pages.inc'),
('rss.xml', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'node_feed', 0x613a323a7b693a303b623a303b693a313b613a303a7b7d7d, '', 1, 1, 0, '', 'rss.xml', 'RSS feed', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('node', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'node_page_default', 0x613a303a7b7d, '', 1, 1, 0, '', 'node', '', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('search', '', '', 'search_is_active', 0x613a303a7b7d, 'search_view', 0x613a303a7b7d, '', 1, 1, 0, '', 'search', 'Search', 't', '', '', 'a:0:{}', 20, '', '', 0, 'modules/search/search.pages.inc'),
('admin', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 1, 1, 0, '', 'admin', 'Administration', 't', '', '', 'a:0:{}', 6, '', '', 9, 'modules/system/system.admin.inc'),
('contact', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261636365737320736974652d7769646520636f6e7461637420666f726d223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31373a22636f6e746163745f736974655f666f726d223b7d, '', 1, 1, 0, '', 'contact', 'Contact', 't', '', '', 'a:0:{}', 20, '', '', 0, 'modules/contact/contact.pages.inc'),
('batch', '', '', '1', 0x613a303a7b7d, 'system_batch_page', 0x613a303a7b7d, '', 1, 1, 0, '', 'batch', '', 't', '', '_system_batch_theme', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('user', '', '', '1', 0x613a303a7b7d, 'user_page', 0x613a303a7b7d, '', 1, 1, 0, '', 'user', 'User account', 'user_menu_title', '', '', 'a:0:{}', 6, '', '', -10, 'modules/user/user.pages.inc'),
('admin/tasks', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 3, 2, 1, 'admin', 'admin', 'Tasks', 't', '', '', 'a:0:{}', 140, '', '', -20, 'modules/system/system.admin.inc'),
('user/login', '', '', 'user_is_anonymous', 0x613a303a7b7d, 'user_page', 0x613a303a7b7d, '', 3, 2, 1, 'user', 'user', 'Log in', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/user/user.pages.inc'),
('overlay/dismiss-message', '', '', 'user_access', 0x613a313a7b693a303b733a31343a22616363657373206f7665726c6179223b7d, 'overlay_user_dismiss_message', 0x613a303a7b7d, '', 3, 2, 0, '', 'overlay/dismiss-message', '', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('toolbar/toggle', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320746f6f6c626172223b7d, 'toolbar_toggle_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'toolbar/toggle', 'Toggle drawer visibility', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('file/progress', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'file_ajax_progress', 0x613a303a7b7d, '', 3, 2, 0, '', 'file/progress', '', 't', '', 'ajax_base_page_theme', 'a:0:{}', 0, '', '', 0, ''),
('overlay-ajax/%', 0x613a313a7b693a313b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31343a22616363657373206f7665726c6179223b7d, 'overlay_ajax_render_region', 0x613a313a7b693a303b693a313b7d, '', 2, 2, 0, '', 'overlay-ajax/%', '', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('node/add', '', '', '_node_add_access', 0x613a303a7b7d, 'node_add_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'node/add', 'Add content', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/node/node.pages.inc'),
('taxonomy/autocomplete', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'taxonomy_autocomplete', 0x613a303a7b7d, '', 3, 2, 0, '', 'taxonomy/autocomplete', 'Autocomplete taxonomy', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/taxonomy/taxonomy.pages.inc'),
('blog/feed', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'blog_feed_last', 0x613a303a7b7d, '', 3, 2, 0, '', 'blog/feed', 'Blogs', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/blog/blog.pages.inc'),
('comment/%', 0x613a313a7b693a313b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261636365737320636f6d6d656e7473223b7d, 'comment_permalink', 0x613a313a7b693a303b693a313b7d, '', 2, 2, 0, '', 'comment/%', 'Comment permalink', 't', '', '', 'a:0:{}', 6, '', '', 0, ''),
('admin/compact', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_compact_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/compact', 'Compact mode', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('filter/tips', '', '', '1', 0x613a303a7b7d, 'filter_tips_long', 0x613a303a7b7d, '', 3, 2, 0, '', 'filter/tips', 'Compose tips', 't', '', '', 'a:0:{}', 20, '', '', 0, 'modules/filter/filter.pages.inc'),
('user/register', '', '', 'user_register_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31383a22757365725f72656769737465725f666f726d223b7d, '', 3, 2, 1, 'user', 'user', 'Create new account', 't', '', '', 'a:0:{}', 132, '', '', 0, ''),
('admin/dashboard', '', '', 'user_access', 0x613a313a7b693a303b733a31363a226163636573732064617368626f617264223b7d, 'dashboard_admin', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/dashboard', 'Dashboard', 't', '', '', 'a:0:{}', 6, 'View and customize your dashboard.', '', -15, ''),
('system/files', '', '', '1', 0x613a303a7b7d, 'file_download', 0x613a313a7b693a303b733a373a2270726976617465223b7d, '', 3, 2, 0, '', 'system/files', 'File download', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/index', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_index', 0x613a303a7b7d, '', 3, 2, 1, 'admin', 'admin', 'Index', 't', '', '', 'a:0:{}', 132, '', '', -18, 'modules/system/system.admin.inc'),
('system/temporary', '', '', '1', 0x613a303a7b7d, 'file_download', 0x613a313a7b693a303b733a393a2274656d706f72617279223b7d, '', 3, 2, 0, '', 'system/temporary', 'Temporary files', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('system/timezone', '', '', '1', 0x613a303a7b7d, 'system_timezone', 0x613a303a7b7d, '', 3, 2, 0, '', 'system/timezone', 'Time zone', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('file/ajax', '', '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'file_ajax_upload', 0x613a303a7b7d, 'ajax_deliver', 3, 2, 0, '', 'file/ajax', '', 't', '', 'ajax_base_page_theme', 'a:0:{}', 0, '', '', 0, ''),
('admin/config', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_config_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/config', 'Configuration', 't', '', '', 'a:0:{}', 6, 'Administer settings.', '', 0, 'modules/system/system.admin.inc'),
('forum/%', 0x613a313a7b693a313b733a31363a22666f72756d5f666f72756d5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'forum_page', 0x613a313a7b693a303b693a313b7d, '', 2, 2, 0, '', 'forum/%', 'Forums', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/forum/forum.pages.inc'),
('admin/help', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_main', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/help', 'Help', 't', '', '', 'a:0:{}', 6, 'Reference for usage, configuration, and modules.', '', 9, 'modules/help/help.admin.inc'),
('user/logout', '', '', 'user_is_logged_in', 0x613a303a7b7d, 'user_logout', 0x613a303a7b7d, '', 3, 2, 0, '', 'user/logout', 'Log out', 't', '', '', 'a:0:{}', 6, '', '', 10, 'modules/user/user.pages.inc'),
('user/password', '', '', '1', 0x613a303a7b7d, 'drupal_get_form', 0x613a313a7b693a303b733a393a22757365725f70617373223b7d, '', 3, 2, 1, 'user', 'user', 'Request new password', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/user/user.pages.inc'),
('user/autocomplete', '', '', 'user_access', 0x613a313a7b693a303b733a32303a2261636365737320757365722070726f66696c6573223b7d, 'user_autocomplete', 0x613a303a7b7d, '', 3, 2, 0, '', 'user/autocomplete', 'User autocomplete', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/user/user.pages.inc'),
('admin/appearance', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'system_themes_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/appearance', 'Appearance', 't', '', '', 'a:0:{}', 6, 'Select and configure your themes.', 'left', -6, 'modules/system/system.admin.inc'),
('search/node', '', '', '_search_menu_access', 0x613a313a7b693a303b733a343a226e6f6465223b7d, 'search_view', 0x613a323a7b693a303b733a343a226e6f6465223b693a313b733a303a22223b7d, '', 3, 2, 1, 'search', 'search', 'Content', 't', '', '', 'a:0:{}', 132, '', '', -10, 'modules/search/search.pages.inc'),
('admin/content', '', '', 'user_access', 0x613a313a7b693a303b733a32333a2261636365737320636f6e74656e74206f76657276696577223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31383a226e6f64655f61646d696e5f636f6e74656e74223b7d, '', 3, 2, 0, '', 'admin/content', 'Content', 't', '', '', 'a:0:{}', 6, 'Administer content and comments.', '', -10, 'modules/node/node.admin.inc'),
('admin/modules', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e6973746572206d6f64756c6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a2273797374656d5f6d6f64756c6573223b7d, '', 3, 2, 0, '', 'admin/modules', 'Modules', 't', '', '', 'a:0:{}', 6, 'Extend site functionality.', '', -2, 'modules/system/system.admin.inc'),
('blog/%', 0x613a313a7b693a313b733a32323a22757365725f7569645f6f7074696f6e616c5f6c6f6164223b7d, 0x613a313a7b693a313b733a32343a22757365725f7569645f6f7074696f6e616c5f746f5f617267223b7d, 'blog_page_user_access', 0x613a313a7b693a303b693a313b7d, 'blog_page_user', 0x613a313a7b693a303b693a313b7d, '', 2, 2, 0, '', 'blog/%', 'My blog', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/blog/blog.pages.inc'),
('admin/reports', '', '', 'user_access', 0x613a313a7b693a303b733a31393a226163636573732073697465207265706f727473223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/reports', 'Reports', 't', '', '', 'a:0:{}', 6, 'View reports, updates, and errors.', 'left', 5, 'modules/system/system.admin.inc'),
('admin/structure', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 3, 2, 0, '', 'admin/structure', 'Structure', 't', '', '', 'a:0:{}', 6, 'Administer blocks, content types, menus, etc.', 'right', -8, 'modules/system/system.admin.inc'),
('search/user', '', '', '_search_menu_access', 0x613a313a7b693a303b733a343a2275736572223b7d, 'search_view', 0x613a323a7b693a303b733a343a2275736572223b693a313b733a303a22223b7d, '', 3, 2, 1, 'search', 'search', 'Users', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/search/search.pages.inc'),
('system/ajax', '', '', '1', 0x613a303a7b7d, 'ajax_form_callback', 0x613a303a7b7d, 'ajax_deliver', 3, 2, 0, '', 'system/ajax', 'AHAH callback', 't', '', 'ajax_base_page_theme', 'a:0:{}', 0, '', '', 0, 'includes/form.inc'),
('admin/people', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'user_admin', 0x613a313a7b693a303b733a343a226c697374223b7d, '', 3, 2, 0, '', 'admin/people', 'People', 't', '', '', 'a:0:{}', 6, 'Manage user accounts, roles, and permissions.', 'left', -4, 'modules/user/user.admin.inc'),
('node/%', 0x613a313a7b693a313b733a393a226e6f64655f6c6f6164223b7d, '', 'node_access', 0x613a323a7b693a303b733a343a2276696577223b693a313b693a313b7d, 'node_page_view', 0x613a313a7b693a303b693a313b7d, '', 2, 2, 0, '', 'node/%', '', 'node_page_title', 'a:1:{i:0;i:1;}', '', 'a:0:{}', 6, '', '', 0, ''),
('user/%', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', 'user_view_access', 0x613a313a7b693a303b693a313b7d, 'user_view_page', 0x613a313a7b693a303b693a313b7d, '', 2, 2, 0, '', 'user/%', 'My account', 'user_page_title', 'a:1:{i:0;i:1;}', '', 'a:0:{}', 6, '', '', 0, ''),
('admin/content/node', '', '', 'user_access', 0x613a313a7b693a303b733a32333a2261636365737320636f6e74656e74206f76657276696577223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31383a226e6f64655f61646d696e5f636f6e74656e74223b7d, '', 7, 3, 1, 'admin/content', 'admin/content', 'Content', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/node/node.admin.inc'),
('admin/modules/list', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e6973746572206d6f64756c6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a2273797374656d5f6d6f64756c6573223b7d, '', 7, 3, 1, 'admin/modules', 'admin/modules', 'List', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/system/system.admin.inc'),
('node/%/view', 0x613a313a7b693a313b733a393a226e6f64655f6c6f6164223b7d, '', 'node_access', 0x613a323a7b693a303b733a343a2276696577223b693a313b693a313b7d, 'node_page_view', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 1, 'node/%', 'node/%', 'View', 't', '', '', 'a:0:{}', 140, '', '', -10, ''),
('user/%/view', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', 'user_view_access', 0x613a313a7b693a303b693a313b7d, 'user_view_page', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 1, 'user/%', 'user/%', 'View', 't', '', '', 'a:0:{}', 140, '', '', -10, ''),
('comment/%/view', 0x613a313a7b693a313b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261636365737320636f6d6d656e7473223b7d, 'comment_permalink', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 1, 'comment/%', 'comment/%', 'View comment', 't', '', '', 'a:0:{}', 140, '', '', -10, ''),
('admin/dashboard/drawer', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'dashboard_show_disabled', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/dashboard/drawer', '', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/dashboard/update', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'dashboard_update', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/dashboard/update', '', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/people/create', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'user_admin', 0x613a313a7b693a303b733a363a22637265617465223b7d, '', 7, 3, 1, 'admin/people', 'admin/people', 'Add user', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/user/user.admin.inc'),
('admin/appearance/list', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'system_themes_page', 0x613a303a7b7d, '', 7, 3, 1, 'admin/appearance', 'admin/appearance', 'List', 't', '', '', 'a:0:{}', 140, 'Select and configure your theme', '', -1, 'modules/system/system.admin.inc'),
('admin/dashboard/configure', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'dashboard_admin_blocks', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/dashboard/configure', 'Configure available dashboard blocks', 't', '', '', 'a:0:{}', 4, 'Configure which blocks can be shown on the dashboard.', '', 0, ''),
('admin/appearance/disable', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'system_theme_disable', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/appearance/disable', 'Disable theme', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/appearance/enable', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'system_theme_enable', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/appearance/enable', 'Enable theme', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/people/people', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'user_admin', 0x613a313a7b693a303b733a343a226c697374223b7d, '', 7, 3, 1, 'admin/people', 'admin/people', 'List', 't', '', '', 'a:0:{}', 140, 'Find and manage people interacting with your site.', '', -10, 'modules/user/user.admin.inc'),
('admin/appearance/default', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'system_theme_default', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/appearance/default', 'Set default theme', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/modules/uninstall', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e6973746572206d6f64756c6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32343a2273797374656d5f6d6f64756c65735f756e696e7374616c6c223b7d, '', 7, 3, 1, 'admin/modules', 'admin/modules', 'Uninstall', 't', '', '', 'a:0:{}', 132, '', '', 20, 'modules/system/system.admin.inc'),
('comment/%/approve', 0x613a313a7b693a313b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e697374657220636f6d6d656e7473223b7d, 'comment_approve', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 0, '', 'comment/%/approve', 'Approve', 't', '', '', 'a:0:{}', 6, '', '', 1, 'modules/comment/comment.pages.inc'),
('admin/reports/updates', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'update_status', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/reports/updates', 'Available updates', 't', '', '', 'a:0:{}', 6, 'Get a status report about available updates for your installed modules and themes.', '', -50, 'modules/update/update.report.inc'),
('admin/content/comment', '', '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e697374657220636f6d6d656e7473223b7d, 'comment_admin', 0x613a303a7b7d, '', 7, 3, 1, 'admin/content', 'admin/content', 'Comments', 't', '', '', 'a:0:{}', 134, 'List and edit site comments and the comment approval queue.', '', 0, 'modules/comment/comment.admin.inc'),
('admin/structure/contact', '', '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e7461637420666f726d73223b7d, 'contact_category_list', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/structure/contact', 'Contact form', 't', '', '', 'a:0:{}', 6, 'Create a system contact form and set up categories for the form to use.', '', 0, 'modules/contact/contact.admin.inc'),
('admin/structure/types', '', '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'node_overview_types', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/structure/types', 'Content types', 't', '', '', 'a:0:{}', 6, 'Manage content types, including default status, front page promotion, comment settings, etc.', '', 0, 'modules/node/content_types.inc'),
('admin/dashboard/customize', '', '', 'user_access', 0x613a313a7b693a303b733a31363a226163636573732064617368626f617264223b7d, 'dashboard_admin', 0x613a313a7b693a303b623a313b7d, '', 7, 3, 0, '', 'admin/dashboard/customize', 'Customize dashboard', 't', '', '', 'a:0:{}', 4, 'Customize your dashboard.', '', 0, ''),
('comment/%/delete', 0x613a313a7b693a313b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e697374657220636f6d6d656e7473223b7d, 'comment_confirm_delete_page', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 1, 'comment/%', 'comment/%', 'Delete', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/comment/comment.admin.inc'),
('comment/%/edit', 0x613a313a7b693a313b733a31323a22636f6d6d656e745f6c6f6164223b7d, '', 'comment_access', 0x613a323a7b693a303b733a343a2265646974223b693a313b693a313b7d, 'comment_edit_page', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 1, 'comment/%', 'comment/%', 'Edit', 't', '', '', 'a:0:{}', 132, '', '', 0, ''),
('admin/reports/fields', '', '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'field_ui_fields_list', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/reports/fields', 'Field list', 't', '', '', 'a:0:{}', 6, 'Overview of fields on all entity types.', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/reports/dblog', '', '', 'user_access', 0x613a313a7b693a303b733a31393a226163636573732073697465207265706f727473223b7d, 'dblog_overview', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/reports/dblog', 'Recent log messages', 't', '', '', 'a:0:{}', 6, 'View events that have recently been logged.', '', -1, 'modules/dblog/dblog.admin.inc'),
('admin/reports/status', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'system_status', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/reports/status', 'Status report', 't', '', '', 'a:0:{}', 6, 'Get a status report about your site''s operation and any detected problems.', '', -60, 'modules/system/system.admin.inc'),
('admin/help/block', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/block', 'block', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/blog', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/blog', 'blog', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/color', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/color', 'color', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/comment', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/comment', 'comment', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/contact', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/contact', 'contact', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/contextual', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/contextual', 'contextual', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/dashboard', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/dashboard', 'dashboard', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/dblog', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/dblog', 'dblog', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/field', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/field', 'field', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/field_sql_storage', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/field_sql_storage', 'field_sql_storage', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/field_ui', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/field_ui', 'field_ui', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/file', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/file', 'file', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/filter', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/filter', 'filter', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/forum', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/forum', 'forum', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/help', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/help', 'help', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/image', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/image', 'image', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/list', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/list', 'list', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/menu', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/menu', 'menu', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/node', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/node', 'node', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/number', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/number', 'number', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/options', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/options', 'options', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/overlay', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/overlay', 'overlay', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/path', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/path', 'path', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/php', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/php', 'php', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/rdf', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/rdf', 'rdf', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/search', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/search', 'search', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/shortcut', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/shortcut', 'shortcut', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/superfish', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/superfish', 'superfish', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/system', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/system', 'system', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/taxonomy', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/taxonomy', 'taxonomy', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/text', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/text', 'text', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/toolbar', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/toolbar', 'toolbar', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/update', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/update', 'update', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('admin/help/user', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'help_page', 0x613a313a7b693a303b693a323b7d, '', 7, 3, 0, '', 'admin/help/user', 'user', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/help/help.admin.inc'),
('comment/reply/%', 0x613a313a7b693a323b733a393a226e6f64655f6c6f6164223b7d, '', 'node_access', 0x613a323a7b693a303b733a343a2276696577223b693a313b693a323b7d, 'comment_reply', 0x613a313a7b693a303b693a323b7d, '', 6, 3, 0, '', 'comment/reply/%', 'Add new comment', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/comment/comment.pages.inc'),
('admin/structure/block', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'block_admin_display', 0x613a313a7b693a303b733a31333a22736b656c65746f6e7468656d65223b7d, '', 7, 3, 0, '', 'admin/structure/block', 'Blocks', 't', '', '', 'a:0:{}', 6, 'Configure what block content appears in your site''s sidebars and other regions.', '', 0, 'modules/block/block.admin.inc'),
('blog/%/feed', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', 'blog_page_user_access', 0x613a313a7b693a303b693a313b7d, 'blog_feed_user', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 0, '', 'blog/%/feed', 'Blogs', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/blog/blog.pages.inc'),
('user/%/cancel', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', 'user_cancel_access', 0x613a313a7b693a303b693a313b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a22757365725f63616e63656c5f636f6e6669726d5f666f726d223b693a313b693a313b7d, '', 5, 3, 0, '', 'user/%/cancel', 'Cancel account', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/user/user.pages.inc'),
('user/%/contact', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', '_contact_personal_tab_access', 0x613a313a7b693a303b693a313b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32313a22636f6e746163745f706572736f6e616c5f666f726d223b693a313b693a313b7d, '', 5, 3, 1, 'user/%', 'user/%', 'Contact', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/contact/contact.pages.inc'),
('admin/config/development', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/development', 'Development', 't', '', '', 'a:0:{}', 6, 'Development tools.', 'right', -10, 'modules/system/system.admin.inc'),
('admin/modules/install', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32373a227570646174655f6d616e616765725f696e7374616c6c5f666f726d223b693a313b733a363a226d6f64756c65223b7d, '', 7, 3, 1, 'admin/modules', 'admin/modules', 'Install new module', 't', '', '', 'a:0:{}', 388, '', '', 25, 'modules/update/update.manager.inc'),
('admin/config/content', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/content', 'Content authoring', 't', '', '', 'a:0:{}', 6, 'Settings related to formatting and authoring content.', 'left', -15, 'modules/system/system.admin.inc'),
('admin/appearance/install', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32373a227570646174655f6d616e616765725f696e7374616c6c5f666f726d223b693a313b733a353a227468656d65223b7d, '', 7, 3, 1, 'admin/appearance', 'admin/appearance', 'Install new theme', 't', '', '', 'a:0:{}', 388, '', '', 25, 'modules/update/update.manager.inc'),
('user/%/edit', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', 'user_edit_access', 0x613a313a7b693a303b693a313b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31373a22757365725f70726f66696c655f666f726d223b693a313b693a313b7d, '', 5, 3, 1, 'user/%', 'user/%', 'Edit', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/user/user.pages.inc'),
('admin/structure/forum', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a22666f72756d5f6f76657276696577223b7d, '', 7, 3, 0, '', 'admin/structure/forum', 'Forums', 't', '', '', 'a:0:{}', 6, 'Control forum hierarchy settings.', '', 0, 'modules/forum/forum.admin.inc'),
('admin/config/media', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/media', 'Media', 't', '', '', 'a:0:{}', 6, 'Media tools.', 'left', -10, 'modules/system/system.admin.inc'),
('admin/structure/menu', '', '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'menu_overview_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/structure/menu', 'Menus', 't', '', '', 'a:0:{}', 6, 'Add new menus to your site, edit existing menus, and rename and reorganize menu links.', '', 0, 'modules/menu/menu.admin.inc'),
('admin/people/permissions', '', '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e6973746572207065726d697373696f6e73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32323a22757365725f61646d696e5f7065726d697373696f6e73223b7d, '', 7, 3, 1, 'admin/people', 'admin/people', 'Permissions', 't', '', '', 'a:0:{}', 132, 'Determine access to features by selecting permissions for roles.', '', 0, 'modules/user/user.admin.inc'),
('admin/update/ready', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33323a227570646174655f6d616e616765725f7570646174655f72656164795f666f726d223b7d, '', 7, 3, 0, '', 'admin/update/ready', 'Ready to update', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/update/update.manager.inc'),
('admin/config/regional', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/regional', 'Regional and language', 't', '', '', 'a:0:{}', 6, 'Regional settings, localization and translation.', 'left', -5, 'modules/system/system.admin.inc'),
('node/%/revisions', 0x613a313a7b693a313b733a393a226e6f64655f6c6f6164223b7d, '', '_node_revision_access', 0x613a313a7b693a303b693a313b7d, 'node_revision_overview', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 1, 'node/%', 'node/%', 'Revisions', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/node/node.pages.inc'),
('admin/config/search', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/search', 'Search and metadata', 't', '', '', 'a:0:{}', 6, 'Local site search, metadata and SEO.', 'left', -10, 'modules/system/system.admin.inc'),
('admin/appearance/settings', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b7d, '', 7, 3, 1, 'admin/appearance', 'admin/appearance', 'Settings', 't', '', '', 'a:0:{}', 132, 'Configure default and theme specific settings.', '', 20, 'modules/system/system.admin.inc'),
('user/%/shortcuts', 0x613a313a7b693a313b733a393a22757365725f6c6f6164223b7d, '', 'shortcut_set_switch_access', 0x613a313a7b693a303b693a313b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31393a2273686f72746375745f7365745f737769746368223b693a313b693a313b7d, '', 5, 3, 1, 'user/%', 'user/%', 'Shortcuts', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/config/system', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/system', 'System', 't', '', '', 'a:0:{}', 6, 'General system related configuration.', 'right', -20, 'modules/system/system.admin.inc'),
('admin/structure/taxonomy', '', '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33303a227461786f6e6f6d795f6f766572766965775f766f636162756c6172696573223b7d, '', 7, 3, 0, '', 'admin/structure/taxonomy', 'Taxonomy', 't', '', '', 'a:0:{}', 6, 'Manage tagging, categorization, and classification of your content.', '', 0, 'modules/taxonomy/taxonomy.admin.inc'),
('admin/reports/access-denied', '', '', 'user_access', 0x613a313a7b693a303b733a31393a226163636573732073697465207265706f727473223b7d, 'dblog_top', 0x613a313a7b693a303b733a31333a226163636573732064656e696564223b7d, '', 7, 3, 0, '', 'admin/reports/access-denied', 'Top ''access denied'' errors', 't', '', '', 'a:0:{}', 6, 'View ''access denied'' errors (403s).', '', 0, 'modules/dblog/dblog.admin.inc'),
('admin/reports/page-not-found', '', '', 'user_access', 0x613a313a7b693a303b733a31393a226163636573732073697465207265706f727473223b7d, 'dblog_top', 0x613a313a7b693a303b733a31343a2270616765206e6f7420666f756e64223b7d, '', 7, 3, 0, '', 'admin/reports/page-not-found', 'Top ''page not found'' errors', 't', '', '', 'a:0:{}', 6, 'View ''page not found'' errors (404s).', '', 0, 'modules/dblog/dblog.admin.inc'),
('admin/reports/search', '', '', 'user_access', 0x613a313a7b693a303b733a31393a226163636573732073697465207265706f727473223b7d, 'dblog_top', 0x613a313a7b693a303b733a363a22736561726368223b7d, '', 7, 3, 0, '', 'admin/reports/search', 'Top search phrases', 't', '', '', 'a:0:{}', 6, 'View most popular search phrases.', '', 0, 'modules/dblog/dblog.admin.inc'),
('admin/modules/update', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a227570646174655f6d616e616765725f7570646174655f666f726d223b693a313b733a363a226d6f64756c65223b7d, '', 7, 3, 1, 'admin/modules', 'admin/modules', 'Update', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/update/update.manager.inc'),
('admin/appearance/update', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a227570646174655f6d616e616765725f7570646174655f666f726d223b693a313b733a353a227468656d65223b7d, '', 7, 3, 1, 'admin/appearance', 'admin/appearance', 'Update', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/update/update.manager.inc'),
('admin/config/user-interface', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/user-interface', 'User interface', 't', '', '', 'a:0:{}', 6, 'Tools that enhance the user interface.', 'right', -15, 'modules/system/system.admin.inc'),
('admin/config/services', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/services', 'Web services', 't', '', '', 'a:0:{}', 6, 'Tools related to web services.', 'right', 0, 'modules/system/system.admin.inc'),
('admin/config/workflow', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/workflow', 'Workflow', 't', '', '', 'a:0:{}', 6, 'Content workflow, editorial workflow tools.', 'right', 5, 'modules/system/system.admin.inc'),
('node/%/delete', 0x613a313a7b693a313b733a393a226e6f64655f6c6f6164223b7d, '', 'node_access', 0x613a323a7b693a303b733a363a2264656c657465223b693a313b693a313b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31393a226e6f64655f64656c6574655f636f6e6669726d223b693a313b693a313b7d, '', 5, 3, 2, 'node/%', 'node/%', 'Delete', 't', '', '', 'a:0:{}', 132, '', '', 1, 'modules/node/node.pages.inc'),
('node/%/edit', 0x613a313a7b693a313b733a393a226e6f64655f6c6f6164223b7d, '', 'node_access', 0x613a323a7b693a303b733a363a22757064617465223b693a313b693a313b7d, 'node_page_edit', 0x613a313a7b693a303b693a313b7d, '', 5, 3, 3, 'node/%', 'node/%', 'Edit', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/node/node.pages.inc'),
('admin/config/people', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'system_admin_menu_block_page', 0x613a303a7b7d, '', 7, 3, 0, '', 'admin/config/people', 'People', 't', '', '', 'a:0:{}', 6, 'Configure user accounts.', 'left', -20, 'modules/system/system.admin.inc'),
('taxonomy/term/%', 0x613a313a7b693a323b733a31383a227461786f6e6f6d795f7465726d5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'taxonomy_term_page', 0x613a313a7b693a303b693a323b7d, '', 6, 3, 0, '', 'taxonomy/term/%', 'Taxonomy term', 'taxonomy_term_title', 'a:1:{i:0;i:2;}', '', 'a:0:{}', 6, '', '', 0, 'modules/taxonomy/taxonomy.pages.inc'),
('node/add/article', '', '', 'node_access', 0x613a323a7b693a303b733a363a22637265617465223b693a313b733a373a2261727469636c65223b7d, 'node_add', 0x613a313a7b693a303b733a373a2261727469636c65223b7d, '', 7, 3, 0, '', 'node/add/article', 'Article', 'check_plain', '', '', 'a:0:{}', 6, 'Use <em>articles</em> for time-sensitive content like news, press releases or blog posts.', '', 0, 'modules/node/node.pages.inc'),
('node/add/page', '', '', 'node_access', 0x613a323a7b693a303b733a363a22637265617465223b693a313b733a343a2270616765223b7d, 'node_add', 0x613a313a7b693a303b733a343a2270616765223b7d, '', 7, 3, 0, '', 'node/add/page', 'Basic page', 'check_plain', '', '', 'a:0:{}', 6, 'Use <em>basic pages</em> for your static content, such as an ''About us'' page.', '', 0, 'modules/node/node.pages.inc'),
('node/add/blog', '', '', 'node_access', 0x613a323a7b693a303b733a363a22637265617465223b693a313b733a343a22626c6f67223b7d, 'node_add', 0x613a313a7b693a303b733a343a22626c6f67223b7d, '', 7, 3, 0, '', 'node/add/blog', 'Blog entry', 'check_plain', '', '', 'a:0:{}', 6, 'Use for multi-user blogs. Every user gets a personal blog.', '', 0, 'modules/node/node.pages.inc'),
('node/add/forum', '', '', 'node_access', 0x613a323a7b693a303b733a363a22637265617465223b693a313b733a353a22666f72756d223b7d, 'node_add', 0x613a313a7b693a303b733a353a22666f72756d223b7d, '', 7, 3, 0, '', 'node/add/forum', 'Forum topic', 'check_plain', '', '', 'a:0:{}', 6, 'A <em>forum topic</em> starts a new discussion thread within a forum.', '', 0, 'modules/node/node.pages.inc'),
('search/node/%', 0x613a313a7b693a323b613a313a7b733a31343a226d656e755f7461696c5f6c6f6164223b613a323a7b693a303b733a343a22256d6170223b693a313b733a363a2225696e646578223b7d7d7d, 0x613a313a7b693a323b733a31363a226d656e755f7461696c5f746f5f617267223b7d, '_search_menu_access', 0x613a313a7b693a303b733a343a226e6f6465223b7d, 'search_view', 0x613a323a7b693a303b733a343a226e6f6465223b693a313b693a323b7d, '', 6, 3, 1, 'search/node', 'search/node/%', 'Content', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/search/search.pages.inc'),
('search/user/%', 0x613a313a7b693a323b613a313a7b733a31343a226d656e755f7461696c5f6c6f6164223b613a323a7b693a303b733a343a22256d6170223b693a313b733a363a2225696e646578223b7d7d7d, 0x613a313a7b693a323b733a31363a226d656e755f7461696c5f746f5f617267223b7d, '_search_menu_access', 0x613a313a7b693a303b733a343a2275736572223b7d, 'search_view', 0x613a323a7b693a303b733a343a2275736572223b693a313b693a323b7d, '', 6, 3, 1, 'search/node', 'search/node/%', 'Users', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/search/search.pages.inc'),
('admin/appearance/settings/global', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e6973746572207468656d6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b7d, '', 15, 4, 1, 'admin/appearance/settings', 'admin/appearance', 'Global settings', 't', '', '', 'a:0:{}', 140, '', '', -1, 'modules/system/system.admin.inc'),
('admin/structure/forum/list', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a22666f72756d5f6f76657276696577223b7d, '', 15, 4, 1, 'admin/structure/forum', 'admin/structure/forum', 'List', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/forum/forum.admin.inc'),
('admin/structure/types/list', '', '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'node_overview_types', 0x613a303a7b7d, '', 15, 4, 1, 'admin/structure/types', 'admin/structure/types', 'List', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/node/content_types.inc'),
('admin/structure/taxonomy/list', '', '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33303a227461786f6e6f6d795f6f766572766965775f766f636162756c6172696573223b7d, '', 15, 4, 1, 'admin/structure/taxonomy', 'admin/structure/taxonomy', 'List', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/taxonomy/taxonomy.admin.inc'),
('admin/structure/menu/list', '', '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'menu_overview_page', 0x613a303a7b7d, '', 15, 4, 1, 'admin/structure/menu', 'admin/structure/menu', 'List menus', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/menu/menu.admin.inc'),
('admin/content/comment/new', '', '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e697374657220636f6d6d656e7473223b7d, 'comment_admin', 0x613a303a7b7d, '', 15, 4, 1, 'admin/content/comment', 'admin/content', 'Published comments', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/comment/comment.admin.inc'),
('taxonomy/term/%/view', 0x613a313a7b693a323b733a31383a227461786f6e6f6d795f7465726d5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'taxonomy_term_page', 0x613a313a7b693a303b693a323b7d, '', 13, 4, 1, 'taxonomy/term/%', 'taxonomy/term/%', 'View', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/taxonomy/taxonomy.pages.inc'),
('user/%/edit/account', 0x613a313a7b693a313b613a313a7b733a31383a22757365725f63617465676f72795f6c6f6164223b613a323a7b693a303b733a343a22256d6170223b693a313b733a363a2225696e646578223b7d7d7d, '', 'user_edit_access', 0x613a313a7b693a303b693a313b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31373a22757365725f70726f66696c655f666f726d223b693a313b693a313b7d, '', 11, 4, 1, 'user/%/edit', 'user/%', 'Account', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/user/user.pages.inc'),
('admin/modules/list/confirm', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e6973746572206d6f64756c6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a2273797374656d5f6d6f64756c6573223b7d, '', 15, 4, 0, '', 'admin/modules/list/confirm', 'List', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/system/system.admin.inc');
INSERT INTO `menu_router` (`path`, `load_functions`, `to_arg_functions`, `access_callback`, `access_arguments`, `page_callback`, `page_arguments`, `delivery_callback`, `fit`, `number_parts`, `context`, `tab_parent`, `tab_root`, `title`, `title_callback`, `title_arguments`, `theme_callback`, `theme_arguments`, `type`, `description`, `position`, `weight`, `include_file`) VALUES
('admin/reports/updates/list', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'update_status', 0x613a303a7b7d, '', 15, 4, 1, 'admin/reports/updates', 'admin/reports/updates', 'List', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/update/update.report.inc'),
('admin/people/permissions/list', '', '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e6973746572207065726d697373696f6e73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32323a22757365725f61646d696e5f7065726d697373696f6e73223b7d, '', 15, 4, 1, 'admin/people/permissions', 'admin/people', 'Permissions', 't', '', '', 'a:0:{}', 140, 'Determine access to features by selecting permissions for roles.', '', -8, 'modules/user/user.admin.inc'),
('admin/structure/menu/parents', '', '', 'user_access', 0x613a313a7b693a303b623a313b7d, 'menu_parent_options_js', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/structure/menu/parents', 'Parent menu items', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/modules/uninstall/confirm', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e6973746572206d6f64756c6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32343a2273797374656d5f6d6f64756c65735f756e696e7374616c6c223b7d, '', 15, 4, 0, '', 'admin/modules/uninstall/confirm', 'Uninstall', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/system/system.admin.inc'),
('system/files/styles/%', 0x613a313a7b693a333b733a31363a22696d6167655f7374796c655f6c6f6164223b7d, '', '1', 0x613a303a7b7d, 'image_style_deliver', 0x613a313a7b693a303b693a333b7d, '', 14, 4, 0, '', 'system/files/styles/%', 'Generate image style', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/reports/updates/check', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'update_manual_status', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/reports/updates/check', 'Manual update check', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/update/update.fetch.inc'),
('admin/reports/status/php', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'system_php', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/reports/status/php', 'PHP', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/reports/status/run-cron', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'system_run_cron', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/reports/status/run-cron', 'Run cron', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/content/comment/approval', '', '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e697374657220636f6d6d656e7473223b7d, 'comment_admin', 0x613a313a7b693a303b733a383a22617070726f76616c223b7d, '', 15, 4, 1, 'admin/content/comment', 'admin/content', 'Unapproved comments', 'comment_count_unpublished', '', '', 'a:0:{}', 132, '', '', 0, 'modules/comment/comment.admin.inc'),
('admin/config/system/actions', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e697374657220616374696f6e73223b7d, 'system_actions_manage', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/config/system/actions', 'Actions', 't', '', '', 'a:0:{}', 6, 'Manage the actions defined for your site.', '', 0, 'modules/system/system.admin.inc'),
('admin/structure/block/add', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22626c6f636b5f6164645f626c6f636b5f666f726d223b7d, '', 15, 4, 1, 'admin/structure/block', 'admin/structure/block', 'Add block', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/contact/add', '', '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e7461637420666f726d73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32363a22636f6e746163745f63617465676f72795f656469745f666f726d223b7d, '', 15, 4, 1, 'admin/structure/contact', 'admin/structure/contact', 'Add category', 't', '', '', 'a:0:{}', 388, '', '', 1, 'modules/contact/contact.admin.inc'),
('admin/structure/types/add', '', '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a226e6f64655f747970655f666f726d223b7d, '', 15, 4, 1, 'admin/structure/types', 'admin/structure/types', 'Add content type', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/node/content_types.inc'),
('admin/structure/menu/add', '', '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31343a226d656e755f656469745f6d656e75223b693a313b733a333a22616464223b7d, '', 15, 4, 1, 'admin/structure/menu', 'admin/structure/menu', 'Add menu', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/structure/taxonomy/add', '', '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32343a227461786f6e6f6d795f666f726d5f766f636162756c617279223b7d, '', 15, 4, 1, 'admin/structure/taxonomy', 'admin/structure/taxonomy', 'Add vocabulary', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/taxonomy/taxonomy.admin.inc'),
('admin/appearance/settings/bartik', '', '', '_system_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32353a227468656d65732f62617274696b2f62617274696b2e696e666f223b733a343a226e616d65223b733a363a2262617274696b223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a363a2242617274696b223b733a31313a226465736372697074696f6e223b733a34383a224120666c657869626c652c207265636f6c6f7261626c65207468656d652077697468206d616e7920726567696f6e732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a363a22686561646572223b733a363a22486561646572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a383a226665617475726564223b733a383a224665617475726564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31343a2274726970747963685f6669727374223b733a31343a225472697074796368206669727374223b733a31353a2274726970747963685f6d6964646c65223b733a31353a225472697074796368206d6964646c65223b733a31333a2274726970747963685f6c617374223b733a31333a225472697074796368206c617374223b733a31383a22666f6f7465725f6669727374636f6c756d6e223b733a31393a22466f6f74657220666972737420636f6c756d6e223b733a31393a22666f6f7465725f7365636f6e64636f6c756d6e223b733a32303a22466f6f746572207365636f6e6420636f6c756d6e223b733a31383a22666f6f7465725f7468697264636f6c756d6e223b733a31393a22466f6f74657220746869726420636f6c756d6e223b733a31393a22666f6f7465725f666f75727468636f6c756d6e223b733a32303a22466f6f74657220666f7572746820636f6c756d6e223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2230223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32383a227468656d65732f62617274696b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'drupal_get_form', 0x613a323a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b693a313b733a363a2262617274696b223b7d, '', 15, 4, 1, 'admin/appearance/settings', 'admin/appearance', 'Bartik', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/system/system.admin.inc'),
('admin/reports/event/%', 0x613a313a7b693a333b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a226163636573732073697465207265706f727473223b7d, 'dblog_event', 0x613a313a7b693a303b693a333b7d, '', 14, 4, 0, '', 'admin/reports/event/%', 'Details', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/dblog/dblog.admin.inc'),
('admin/appearance/settings/garland', '', '', '_system_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32373a227468656d65732f6761726c616e642f6761726c616e642e696e666f223b733a343a226e616d65223b733a373a226761726c616e64223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2230223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a373a224761726c616e64223b733a31313a226465736372697074696f6e223b733a3131313a2241206d756c74692d636f6c756d6e207468656d652077686963682063616e20626520636f6e6669677572656420746f206d6f6469667920636f6c6f727320616e6420737769746368206265747765656e20666978656420616e6420666c756964207769647468206c61796f7574732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a31333a226761726c616e645f7769647468223b733a353a22666c756964223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32393a227468656d65732f6761726c616e642f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'drupal_get_form', 0x613a323a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b693a313b733a373a226761726c616e64223b7d, '', 15, 4, 1, 'admin/appearance/settings', 'admin/appearance', 'Garland', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/system/system.admin.inc'),
('admin/config/people/ip-blocking', '', '', 'user_access', 0x613a313a7b693a303b733a31383a22626c6f636b20495020616464726573736573223b7d, 'system_ip_blocking', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/config/people/ip-blocking', 'IP address blocking', 't', '', '', 'a:0:{}', 6, 'Manage blocked IP addresses.', '', 10, 'modules/system/system.admin.inc'),
('admin/config/media/image-styles', '', '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'image_style_list', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/config/media/image-styles', 'Image styles', 't', '', '', 'a:0:{}', 6, 'Configure styles that can be used for resizing or adjusting images on display.', '', 0, 'modules/image/image.admin.inc'),
('admin/reports/status/rebuild', '', '', 'user_access', 0x613a313a7b693a303b733a32373a226163636573732061646d696e697374726174696f6e207061676573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33303a226e6f64655f636f6e6669677572655f72656275696c645f636f6e6669726d223b7d, '', 15, 4, 0, '', 'admin/reports/status/rebuild', 'Rebuild permissions', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/node/node.admin.inc'),
('admin/structure/menu/settings', '', '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31343a226d656e755f636f6e666967757265223b7d, '', 15, 4, 1, 'admin/structure/menu', 'admin/structure/menu', 'Settings', 't', '', '', 'a:0:{}', 132, '', '', 5, 'modules/menu/menu.admin.inc'),
('admin/reports/updates/settings', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31353a227570646174655f73657474696e6773223b7d, '', 15, 4, 1, 'admin/reports/updates', 'admin/reports/updates', 'Settings', 't', '', '', 'a:0:{}', 132, '', '', 50, 'modules/update/update.settings.inc'),
('admin/appearance/settings/seven', '', '', '_system_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32333a227468656d65732f736576656e2f736576656e2e696e666f223b733a343a226e616d65223b733a353a22736576656e223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a353a22536576656e223b733a31313a226465736372697074696f6e223b733a36353a22412073696d706c65206f6e652d636f6c756d6e2c207461626c656c6573732c20666c7569642077696474682061646d696e697374726174696f6e207468656d652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2231223b7d733a373a22726567696f6e73223b613a383a7b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31333a22736964656261725f6669727374223b733a31333a2246697273742073696465626172223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a31343a22726567696f6e735f68696464656e223b613a333a7b693a303b733a31333a22736964656261725f6669727374223b693a313b733a383a22706167655f746f70223b693a323b733a31313a22706167655f626f74746f6d223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f736576656e2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'drupal_get_form', 0x613a323a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b693a313b733a353a22736576656e223b7d, '', 15, 4, 1, 'admin/appearance/settings', 'admin/appearance', 'Seven', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/system/system.admin.inc'),
('admin/config/user-interface/shortcut', '', '', 'user_access', 0x613a313a7b693a303b733a32303a2261646d696e69737465722073686f727463757473223b7d, 'shortcut_set_admin', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/config/user-interface/shortcut', 'Shortcuts', 't', '', '', 'a:0:{}', 6, 'Add and modify shortcut sets.', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/appearance/settings/skeletontheme', '', '', '_system_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a34393a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f736b656c65746f6e7468656d652e696e666f223b733a343a226e616d65223b733a31333a22736b656c65746f6e7468656d65223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31373a7b733a343a226e616d65223b733a383a22536b656c65746f6e223b733a31313a226465736372697074696f6e223b733a3336313a22536b656c65746f6e206973206120706f77657266756c2c20636c65616e2c20726573706f6e73697665207468656d6520706f7274656420746f2044727570616c206279203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d2f22207461726765743d225f626c616e6b223e4d6f7265205468616e20286a75737429205468656d65733c2f613e2e20496620796f75206c696b652074686973207468656d652c20776520656e636f757261676520796f7520746f2074727920616c736f206f7572206f74686572203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d22207461726765743d225f626c616e6b223e5072656d69756d3c2f613e20616e64203c6120687265663d22687474703a2f2f64727570616c697a696e672e636f6d22207461726765743d225f626c616e6b223e467265653c2f613e2044727570616c207468656d65732e223b733a373a2276657273696f6e223b733a373a22372e782d312e32223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a31353a226865616465725f746f705f6c656674223b733a31353a2248656164657220746f70206c656674223b733a31363a226865616465725f746f705f7269676874223b733a31363a2248656164657220746f70207269676874223b733a31323a226865616465725f7269676874223b733a31323a22486561646572207269676874223b733a363a22686561646572223b733a363a22486561646572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31333a2266656174757265645f6c656674223b733a31333a224665617475726564206c656674223b733a31343a2266656174757265645f7269676874223b733a31343a224665617475726564207269676874223b733a31323a22666f6f7465725f6669727374223b733a31323a22466f6f746572206669727374223b733a31333a22666f6f7465725f7365636f6e64223b733a31333a22466f6f746572207365636f6e64223b733a31323a22666f6f7465725f7468697264223b733a31323a22466f6f746572207468697264223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a333a7b733a32313a22726573706f6e736976655f6d656e755f7374617465223b733a313a2231223b733a32373a22726573706f6e736976655f6d656e755f7377697463687769647468223b733a333a22373630223b733a32393a22726573706f6e736976655f6d656e755f746f706f7074696f6e74657874223b733a31333a2253656c65637420612070616765223b7d733a373a2270726f6a656374223b733a31333a22736b656c65746f6e7468656d65223b733a393a22646174657374616d70223b733a31303a2231333631303632323839223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'drupal_get_form', 0x613a323a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b693a313b733a31333a22736b656c65746f6e7468656d65223b7d, '', 15, 4, 1, 'admin/appearance/settings', 'admin/appearance', 'Skeleton', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/system/system.admin.inc'),
('admin/appearance/settings/stark', '', '', '_system_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32333a227468656d65732f737461726b2f737461726b2e696e666f223b733a343a226e616d65223b733a353a22737461726b223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2230223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31373a7b733a343a226e616d65223b733a353a22537461726b223b733a31313a226465736372697074696f6e223b733a3230383a2254686973207468656d652064656d6f6e737472617465732044727570616c27732064656661756c742048544d4c206d61726b757020616e6420435353207374796c65732e20546f206c6561726e20686f7720746f206275696c6420796f7572206f776e207468656d6520616e64206f766572726964652044727570616c27732064656661756c7420636f64652c2073656520746865203c6120687265663d22687474703a2f2f64727570616c2e6f72672f7468656d652d6775696465223e5468656d696e672047756964653c2f613e2e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f737461726b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'drupal_get_form', 0x613a323a7b693a303b733a32313a2273797374656d5f7468656d655f73657474696e6773223b693a313b733a353a22737461726b223b7d, '', 15, 4, 1, 'admin/appearance/settings', 'admin/appearance', 'Stark', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/system/system.admin.inc'),
('admin/config/search/path', '', '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e69737465722075726c20616c6961736573223b7d, 'path_admin_overview', 0x613a303a7b7d, '', 15, 4, 0, '', 'admin/config/search/path', 'URL aliases', 't', '', '', 'a:0:{}', 6, 'Change your site''s URL paths by aliasing them.', '', -5, 'modules/path/path.admin.inc'),
('admin/config/people/accounts', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31393a22757365725f61646d696e5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/people/accounts', 'Account settings', 't', '', '', 'a:0:{}', 6, 'Configure default behavior of users, including registration requirements, e-mails, fields, and user pictures.', '', -10, 'modules/user/user.admin.inc'),
('admin/config/search/clean-urls', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32353a2273797374656d5f636c65616e5f75726c5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/search/clean-urls', 'Clean URLs', 't', '', '', 'a:0:{}', 6, 'Enable or disable clean URLs for your site.', '', 5, 'modules/system/system.admin.inc'),
('admin/config/system/cron', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a2273797374656d5f63726f6e5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/system/cron', 'Cron', 't', '', '', 'a:0:{}', 6, 'Manage automatic site maintenance tasks.', '', 20, 'modules/system/system.admin.inc'),
('admin/config/regional/date-time', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32353a2273797374656d5f646174655f74696d655f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/regional/date-time', 'Date and time', 't', '', '', 'a:0:{}', 6, 'Configure display formats for date and time.', '', -15, 'modules/system/system.admin.inc'),
('taxonomy/term/%/edit', 0x613a313a7b693a323b733a31383a227461786f6e6f6d795f7465726d5f6c6f6164223b7d, '', 'taxonomy_term_edit_access', 0x613a313a7b693a303b693a323b7d, 'drupal_get_form', 0x613a333a7b693a303b733a31383a227461786f6e6f6d795f666f726d5f7465726d223b693a313b693a323b693a323b4e3b7d, '', 13, 4, 1, 'taxonomy/term/%', 'taxonomy/term/%', 'Edit', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/taxonomy/taxonomy.admin.inc'),
('admin/config/media/file-system', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32373a2273797374656d5f66696c655f73797374656d5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/media/file-system', 'File system', 't', '', '', 'a:0:{}', 6, 'Tell Drupal where to store uploaded files and how they are accessed.', '', -10, 'modules/system/system.admin.inc'),
('admin/config/media/image-toolkit', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32393a2273797374656d5f696d6167655f746f6f6c6b69745f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/media/image-toolkit', 'Image toolkit', 't', '', '', 'a:0:{}', 6, 'Choose which image toolkit to use if you have installed optional toolkits.', '', 20, 'modules/system/system.admin.inc'),
('admin/config/development/logging', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32333a2273797374656d5f6c6f6767696e675f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/development/logging', 'Logging and errors', 't', '', '', 'a:0:{}', 6, 'Settings for logging and alerts modules. Various modules can route Drupal''s system events to different destinations, such as syslog, database, email, etc.', '', -15, 'modules/system/system.admin.inc'),
('admin/config/development/maintenance', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32383a2273797374656d5f736974655f6d61696e74656e616e63655f6d6f6465223b7d, '', 15, 4, 0, '', 'admin/config/development/maintenance', 'Maintenance mode', 't', '', '', 'a:0:{}', 6, 'Take the site offline for maintenance or bring it back online.', '', -10, 'modules/system/system.admin.inc'),
('admin/config/development/performance', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32373a2273797374656d5f706572666f726d616e63655f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/development/performance', 'Performance', 't', '', '', 'a:0:{}', 6, 'Enable or disable page caching for anonymous users and set CSS and JS bandwidth optimization options.', '', -20, 'modules/system/system.admin.inc'),
('admin/config/services/rss-publishing', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32353a2273797374656d5f7273735f66656564735f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/services/rss-publishing', 'RSS publishing', 't', '', '', 'a:0:{}', 6, 'Configure the site description, the number of items per feed and whether feeds should be titles/teasers/full-text.', '', 0, 'modules/system/system.admin.inc'),
('admin/config/regional/settings', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32343a2273797374656d5f726567696f6e616c5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/regional/settings', 'Regional settings', 't', '', '', 'a:0:{}', 6, 'Settings for the site''s default time zone and country.', '', -20, 'modules/system/system.admin.inc'),
('admin/reports/updates/install', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32373a227570646174655f6d616e616765725f696e7374616c6c5f666f726d223b693a313b733a363a227265706f7274223b7d, '', 15, 4, 1, 'admin/reports/updates', 'admin/reports/updates', 'Install new module or theme', 't', '', '', 'a:0:{}', 388, '', '', 25, 'modules/update/update.manager.inc'),
('admin/people/permissions/roles', '', '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e6973746572207065726d697373696f6e73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31363a22757365725f61646d696e5f726f6c6573223b7d, '', 15, 4, 1, 'admin/people/permissions', 'admin/people', 'Roles', 't', '', '', 'a:0:{}', 132, 'List, edit, or add user roles.', '', -5, 'modules/user/user.admin.inc'),
('admin/config/search/settings', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220736561726368223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32313a227365617263685f61646d696e5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/search/settings', 'Search settings', 't', '', '', 'a:0:{}', 6, 'Configure relevance settings for search and other indexing options.', '', -10, 'modules/search/search.admin.inc'),
('admin/structure/forum/settings', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22666f72756d5f61646d696e5f73657474696e6773223b7d, '', 15, 4, 1, 'admin/structure/forum', 'admin/structure/forum', 'Settings', 't', '', '', 'a:0:{}', 132, '', '', 5, 'modules/forum/forum.admin.inc'),
('admin/config/system/site-information', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33323a2273797374656d5f736974655f696e666f726d6174696f6e5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/system/site-information', 'Site information', 't', '', '', 'a:0:{}', 6, 'Change site name, e-mail address, slogan, default front page, and number of posts per page, error pages.', '', -20, 'modules/system/system.admin.inc'),
('admin/config/user-interface/superfish', '', '', 'user_access', 0x613a313a7b693a303b733a32303a2261646d696e697374657220737570657266697368223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32343a227375706572666973685f61646d696e5f73657474696e6773223b7d, '', 15, 4, 0, '', 'admin/config/user-interface/superfish', 'Superfish', 't', '', '', 'a:0:{}', 6, 'Configure Superfish Menus', '', 0, 'sites/all/modules/superfish/superfish.admin.inc'),
('admin/config/content/formats', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e69737465722066696c74657273223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32313a2266696c7465725f61646d696e5f6f76657276696577223b7d, '', 15, 4, 0, '', 'admin/config/content/formats', 'Text formats', 't', '', '', 'a:0:{}', 6, 'Configure how content input by users is filtered, including allowed HTML tags. Also allows enabling of module-provided filters.', '', 0, 'modules/filter/filter.admin.inc'),
('admin/reports/updates/update', '', '', 'update_manager_access', 0x613a303a7b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a227570646174655f6d616e616765725f7570646174655f666f726d223b693a313b733a363a227265706f7274223b7d, '', 15, 4, 1, 'admin/reports/updates', 'admin/reports/updates', 'Update', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/update/update.manager.inc'),
('admin/structure/taxonomy/%', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32333a227461786f6e6f6d795f6f766572766965775f7465726d73223b693a313b693a333b7d, '', 14, 4, 0, '', 'admin/structure/taxonomy/%', '', 'entity_label', 'a:2:{i:0;s:19:"taxonomy_vocabulary";i:1;i:3;}', '', 'a:0:{}', 6, '', '', 0, 'modules/taxonomy/taxonomy.admin.inc'),
('taxonomy/term/%/feed', 0x613a313a7b693a323b733a31383a227461786f6e6f6d795f7465726d5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31343a2261636365737320636f6e74656e74223b7d, 'taxonomy_term_feed', 0x613a313a7b693a303b693a323b7d, '', 13, 4, 0, '', 'taxonomy/term/%/feed', 'Taxonomy term', 'taxonomy_term_title', 'a:1:{i:0;i:2;}', '', 'a:0:{}', 0, '', '', 0, 'modules/taxonomy/taxonomy.pages.inc'),
('admin/structure/taxonomy/%/list', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32333a227461786f6e6f6d795f6f766572766965775f7465726d73223b693a313b693a333b7d, '', 29, 5, 1, 'admin/structure/taxonomy/%', 'admin/structure/taxonomy/%', 'List', 't', '', '', 'a:0:{}', 140, '', '', -20, 'modules/taxonomy/taxonomy.admin.inc'),
('admin/config/content/formats/list', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e69737465722066696c74657273223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32313a2266696c7465725f61646d696e5f6f76657276696577223b7d, '', 31, 5, 1, 'admin/config/content/formats', 'admin/config/content/formats', 'List', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/filter/filter.admin.inc'),
('admin/config/search/path/list', '', '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e69737465722075726c20616c6961736573223b7d, 'path_admin_overview', 0x613a303a7b7d, '', 31, 5, 1, 'admin/config/search/path', 'admin/config/search/path', 'List', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/path/path.admin.inc'),
('admin/config/people/accounts/settings', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a31393a22757365725f61646d696e5f73657474696e6773223b7d, '', 31, 5, 1, 'admin/config/people/accounts', 'admin/config/people/accounts', 'Settings', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/user/user.admin.inc'),
('admin/dashboard/block-content/%/%', 0x613a323a7b693a333b4e3b693a343b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'dashboard_show_block_content', 0x613a323a7b693a303b693a333b693a313b693a343b7d, '', 28, 5, 0, '', 'admin/dashboard/block-content/%/%', '', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/config/search/path/add', '', '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e69737465722075726c20616c6961736573223b7d, 'path_admin_edit', 0x613a303a7b7d, '', 31, 5, 1, 'admin/config/search/path', 'admin/config/search/path', 'Add alias', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/path/path.admin.inc'),
('admin/config/content/formats/add', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e69737465722066696c74657273223b7d, 'filter_admin_format_page', 0x613a303a7b7d, '', 31, 5, 1, 'admin/config/content/formats', 'admin/config/content/formats', 'Add text format', 't', '', '', 'a:0:{}', 388, '', '', 1, 'modules/filter/filter.admin.inc'),
('sites/default/files/styles/%', 0x613a313a7b693a343b733a31363a22696d6167655f7374796c655f6c6f6164223b7d, '', '1', 0x613a303a7b7d, 'image_style_deliver', 0x613a313a7b693a303b693a343b7d, '', 30, 5, 0, '', 'sites/default/files/styles/%', 'Generate image style', 't', '', '', 'a:0:{}', 0, '', '', 0, ''),
('admin/config/system/actions/manage', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e697374657220616374696f6e73223b7d, 'system_actions_manage', 0x613a303a7b7d, '', 31, 5, 1, 'admin/config/system/actions', 'admin/config/system/actions', 'Manage actions', 't', '', '', 'a:0:{}', 140, 'Manage the actions defined for your site.', '', -2, 'modules/system/system.admin.inc'),
('admin/config/system/actions/orphan', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e697374657220616374696f6e73223b7d, 'system_actions_remove_orphans', 0x613a303a7b7d, '', 31, 5, 0, '', 'admin/config/system/actions/orphan', 'Remove orphans', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/config/user-interface/shortcut/add-set', '', '', 'user_access', 0x613a313a7b693a303b733a32303a2261646d696e69737465722073686f727463757473223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32313a2273686f72746375745f7365745f6164645f666f726d223b7d, '', 31, 5, 1, 'admin/config/user-interface/shortcut', 'admin/config/user-interface/shortcut', 'Add shortcut set', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/structure/taxonomy/%/add', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a31383a227461786f6e6f6d795f666f726d5f7465726d223b693a313b613a303a7b7d693a323b693a333b7d, '', 29, 5, 1, 'admin/structure/taxonomy/%', 'admin/structure/taxonomy/%', 'Add term', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/taxonomy/taxonomy.admin.inc');
INSERT INTO `menu_router` (`path`, `load_functions`, `to_arg_functions`, `access_callback`, `access_arguments`, `page_callback`, `page_arguments`, `delivery_callback`, `fit`, `number_parts`, `context`, `tab_parent`, `tab_root`, `title`, `title_callback`, `title_arguments`, `theme_callback`, `theme_arguments`, `type`, `description`, `position`, `weight`, `include_file`) VALUES
('admin/structure/block/list/bartik', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32353a227468656d65732f62617274696b2f62617274696b2e696e666f223b733a343a226e616d65223b733a363a2262617274696b223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a363a2242617274696b223b733a31313a226465736372697074696f6e223b733a34383a224120666c657869626c652c207265636f6c6f7261626c65207468656d652077697468206d616e7920726567696f6e732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a363a22686561646572223b733a363a22486561646572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a383a226665617475726564223b733a383a224665617475726564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31343a2274726970747963685f6669727374223b733a31343a225472697074796368206669727374223b733a31353a2274726970747963685f6d6964646c65223b733a31353a225472697074796368206d6964646c65223b733a31333a2274726970747963685f6c617374223b733a31333a225472697074796368206c617374223b733a31383a22666f6f7465725f6669727374636f6c756d6e223b733a31393a22466f6f74657220666972737420636f6c756d6e223b733a31393a22666f6f7465725f7365636f6e64636f6c756d6e223b733a32303a22466f6f746572207365636f6e6420636f6c756d6e223b733a31383a22666f6f7465725f7468697264636f6c756d6e223b733a31393a22466f6f74657220746869726420636f6c756d6e223b733a31393a22666f6f7465725f666f75727468636f6c756d6e223b733a32303a22466f6f74657220666f7572746820636f6c756d6e223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2230223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32383a227468656d65732f62617274696b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_display', 0x613a313a7b693a303b733a363a2262617274696b223b7d, '', 31, 5, 1, 'admin/structure/block', 'admin/structure/block', 'Bartik', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/block/block.admin.inc'),
('admin/config/search/clean-urls/check', '', '', '1', 0x613a303a7b7d, 'drupal_json_output', 0x613a313a7b693a303b613a313a7b733a363a22737461747573223b623a313b7d7d, '', 31, 5, 0, '', 'admin/config/search/clean-urls/check', 'Clean URL check', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/config/search/settings/reindex', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220736561726368223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32323a227365617263685f7265696e6465785f636f6e6669726d223b7d, '', 31, 5, 0, '', 'admin/config/search/settings/reindex', 'Clear index', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/search/search.admin.inc'),
('admin/config/system/actions/configure', '', '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e697374657220616374696f6e73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32343a2273797374656d5f616374696f6e735f636f6e666967757265223b7d, '', 31, 5, 0, '', 'admin/config/system/actions/configure', 'Configure an advanced action', 't', '', '', 'a:0:{}', 4, '', '', 0, 'modules/system/system.admin.inc'),
('admin/structure/contact/delete/%', 0x613a313a7b693a343b733a31323a22636f6e746163745f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e7461637420666f726d73223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a22636f6e746163745f63617465676f72795f64656c6574655f666f726d223b693a313b693a343b7d, '', 30, 5, 0, '', 'admin/structure/contact/delete/%', 'Delete contact', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/contact/contact.admin.inc'),
('admin/structure/taxonomy/%/edit', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a227461786f6e6f6d795f666f726d5f766f636162756c617279223b693a313b693a333b7d, '', 29, 5, 1, 'admin/structure/taxonomy/%', 'admin/structure/taxonomy/%', 'Edit', 't', '', '', 'a:0:{}', 132, '', '', -10, 'modules/taxonomy/taxonomy.admin.inc'),
('admin/structure/contact/edit/%', 0x613a313a7b693a343b733a31323a22636f6e746163745f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e7461637420666f726d73223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a22636f6e746163745f63617465676f72795f656469745f666f726d223b693a313b693a343b7d, '', 30, 5, 0, '', 'admin/structure/contact/edit/%', 'Edit contact category', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/contact/contact.admin.inc'),
('admin/config/regional/date-time/formats', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'system_date_time_formats', 0x613a303a7b7d, '', 31, 5, 1, 'admin/config/regional/date-time', 'admin/config/regional/date-time', 'Formats', 't', '', '', 'a:0:{}', 132, 'Configure display format strings for date and time.', '', -9, 'modules/system/system.admin.inc'),
('admin/structure/block/list/garland', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32373a227468656d65732f6761726c616e642f6761726c616e642e696e666f223b733a343a226e616d65223b733a373a226761726c616e64223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2230223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a373a224761726c616e64223b733a31313a226465736372697074696f6e223b733a3131313a2241206d756c74692d636f6c756d6e207468656d652077686963682063616e20626520636f6e6669677572656420746f206d6f6469667920636f6c6f727320616e6420737769746368206265747765656e20666978656420616e6420666c756964207769647468206c61796f7574732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a31333a226761726c616e645f7769647468223b733a353a22666c756964223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32393a227468656d65732f6761726c616e642f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_display', 0x613a313a7b693a303b733a373a226761726c616e64223b7d, '', 31, 5, 1, 'admin/structure/block', 'admin/structure/block', 'Garland', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/block/block.admin.inc'),
('admin/config/media/image-styles/list', '', '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'image_style_list', 0x613a303a7b7d, '', 31, 5, 1, 'admin/config/media/image-styles', 'admin/config/media/image-styles', 'List', 't', '', '', 'a:0:{}', 140, 'List the current image styles on the site.', '', 1, 'modules/image/image.admin.inc'),
('user/reset/%/%/%', 0x613a333a7b693a323b4e3b693a333b4e3b693a343b4e3b7d, '', '1', 0x613a303a7b7d, 'drupal_get_form', 0x613a343a7b693a303b733a31353a22757365725f706173735f7265736574223b693a313b693a323b693a323b693a333b693a333b693a343b7d, '', 24, 5, 0, '', 'user/reset/%/%/%', 'Reset password', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/user/user.pages.inc'),
('admin/structure/block/list/seven', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32333a227468656d65732f736576656e2f736576656e2e696e666f223b733a343a226e616d65223b733a353a22736576656e223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a353a22536576656e223b733a31313a226465736372697074696f6e223b733a36353a22412073696d706c65206f6e652d636f6c756d6e2c207461626c656c6573732c20666c7569642077696474682061646d696e697374726174696f6e207468656d652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2231223b7d733a373a22726567696f6e73223b613a383a7b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31333a22736964656261725f6669727374223b733a31333a2246697273742073696465626172223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a31343a22726567696f6e735f68696464656e223b613a333a7b693a303b733a31333a22736964656261725f6669727374223b693a313b733a383a22706167655f746f70223b693a323b733a31313a22706167655f626f74746f6d223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f736576656e2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_display', 0x613a313a7b693a303b733a353a22736576656e223b7d, '', 31, 5, 1, 'admin/structure/block', 'admin/structure/block', 'Seven', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/block/list/skeletontheme', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a34393a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f736b656c65746f6e7468656d652e696e666f223b733a343a226e616d65223b733a31333a22736b656c65746f6e7468656d65223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31373a7b733a343a226e616d65223b733a383a22536b656c65746f6e223b733a31313a226465736372697074696f6e223b733a3336313a22536b656c65746f6e206973206120706f77657266756c2c20636c65616e2c20726573706f6e73697665207468656d6520706f7274656420746f2044727570616c206279203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d2f22207461726765743d225f626c616e6b223e4d6f7265205468616e20286a75737429205468656d65733c2f613e2e20496620796f75206c696b652074686973207468656d652c20776520656e636f757261676520796f7520746f2074727920616c736f206f7572206f74686572203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d22207461726765743d225f626c616e6b223e5072656d69756d3c2f613e20616e64203c6120687265663d22687474703a2f2f64727570616c697a696e672e636f6d22207461726765743d225f626c616e6b223e467265653c2f613e2044727570616c207468656d65732e223b733a373a2276657273696f6e223b733a373a22372e782d312e32223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a31353a226865616465725f746f705f6c656674223b733a31353a2248656164657220746f70206c656674223b733a31363a226865616465725f746f705f7269676874223b733a31363a2248656164657220746f70207269676874223b733a31323a226865616465725f7269676874223b733a31323a22486561646572207269676874223b733a363a22686561646572223b733a363a22486561646572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31333a2266656174757265645f6c656674223b733a31333a224665617475726564206c656674223b733a31343a2266656174757265645f7269676874223b733a31343a224665617475726564207269676874223b733a31323a22666f6f7465725f6669727374223b733a31323a22466f6f746572206669727374223b733a31333a22666f6f7465725f7365636f6e64223b733a31333a22466f6f746572207365636f6e64223b733a31323a22666f6f7465725f7468697264223b733a31323a22466f6f746572207468697264223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a333a7b733a32313a22726573706f6e736976655f6d656e755f7374617465223b733a313a2231223b733a32373a22726573706f6e736976655f6d656e755f7377697463687769647468223b733a333a22373630223b733a32393a22726573706f6e736976655f6d656e755f746f706f7074696f6e74657874223b733a31333a2253656c65637420612070616765223b7d733a373a2270726f6a656374223b733a31333a22736b656c65746f6e7468656d65223b733a393a22646174657374616d70223b733a31303a2231333631303632323839223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_display', 0x613a313a7b693a303b733a31333a22736b656c65746f6e7468656d65223b7d, '', 31, 5, 1, 'admin/structure/block', 'admin/structure/block', 'Skeleton', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/block/block.admin.inc'),
('admin/structure/block/list/stark', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32333a227468656d65732f737461726b2f737461726b2e696e666f223b733a343a226e616d65223b733a353a22737461726b223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2230223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31373a7b733a343a226e616d65223b733a353a22537461726b223b733a31313a226465736372697074696f6e223b733a3230383a2254686973207468656d652064656d6f6e737472617465732044727570616c27732064656661756c742048544d4c206d61726b757020616e6420435353207374796c65732e20546f206c6561726e20686f7720746f206275696c6420796f7572206f776e207468656d6520616e64206f766572726964652044727570616c27732064656661756c7420636f64652c2073656520746865203c6120687265663d22687474703a2f2f64727570616c2e6f72672f7468656d652d6775696465223e5468656d696e672047756964653c2f613e2e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f737461726b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_display', 0x613a313a7b693a303b733a353a22737461726b223b7d, '', 31, 5, 1, 'admin/structure/block', 'admin/structure/block', 'Stark', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/forum/add/container', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'forum_form_main', 0x613a313a7b693a303b733a393a22636f6e7461696e6572223b7d, '', 31, 5, 1, 'admin/structure/forum', 'admin/structure/forum', 'Add container', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/forum/forum.admin.inc'),
('admin/structure/forum/add/forum', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'forum_form_main', 0x613a313a7b693a303b733a353a22666f72756d223b7d, '', 31, 5, 1, 'admin/structure/forum', 'admin/structure/forum', 'Add forum', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/forum/forum.admin.inc'),
('admin/config/media/image-styles/add', '', '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22696d6167655f7374796c655f6164645f666f726d223b7d, '', 31, 5, 1, 'admin/config/media/image-styles', 'admin/config/media/image-styles', 'Add style', 't', '', '', 'a:0:{}', 388, 'Add a new image style.', '', 2, 'modules/image/image.admin.inc'),
('admin/structure/taxonomy/%/display', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a31333a227461786f6e6f6d795f7465726d223b693a323b693a333b693a333b733a373a2264656661756c74223b7d, '', 29, 5, 1, 'admin/structure/taxonomy/%', 'admin/structure/taxonomy/%', 'Manage display', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/display', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a2275736572223b693a323b733a343a2275736572223b693a333b733a373a2264656661756c74223b7d, '', 31, 5, 1, 'admin/config/people/accounts', 'admin/config/people/accounts', 'Manage display', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/taxonomy/%/fields', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32383a226669656c645f75695f6669656c645f6f766572766965775f666f726d223b693a313b733a31333a227461786f6e6f6d795f7465726d223b693a323b693a333b7d, '', 29, 5, 1, 'admin/structure/taxonomy/%', 'admin/structure/taxonomy/%', 'Manage fields', 't', '', '', 'a:0:{}', 132, '', '', 1, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/fields', '', '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32383a226669656c645f75695f6669656c645f6f766572766965775f666f726d223b693a313b733a343a2275736572223b693a323b733a343a2275736572223b7d, '', 31, 5, 1, 'admin/config/people/accounts', 'admin/config/people/accounts', 'Manage fields', 't', '', '', 'a:0:{}', 132, '', '', 1, 'modules/field_ui/field_ui.admin.inc'),
('node/%/revisions/%/view', 0x613a323a7b693a313b613a313a7b733a393a226e6f64655f6c6f6164223b613a313a7b693a303b693a333b7d7d693a333b4e3b7d, '', '_node_revision_access', 0x613a313a7b693a303b693a313b7d, 'node_show', 0x613a323a7b693a303b693a313b693a313b623a313b7d, '', 21, 5, 0, '', 'node/%/revisions/%/view', 'Revisions', 't', '', '', 'a:0:{}', 6, '', '', 0, ''),
('admin/config/regional/date-time/types', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32353a2273797374656d5f646174655f74696d655f73657474696e6773223b7d, '', 31, 5, 1, 'admin/config/regional/date-time', 'admin/config/regional/date-time', 'Types', 't', '', '', 'a:0:{}', 140, 'Configure display formats for date and time.', '', -10, 'modules/system/system.admin.inc'),
('admin/config/content/formats/%', 0x613a313a7b693a343b733a31383a2266696c7465725f666f726d61745f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e69737465722066696c74657273223b7d, 'filter_admin_format_page', 0x613a313a7b693a303b693a343b7d, '', 30, 5, 0, '', 'admin/config/content/formats/%', '', 'filter_admin_format_title', 'a:1:{i:0;i:4;}', '', 'a:0:{}', 6, '', '', 0, 'modules/filter/filter.admin.inc'),
('admin/structure/menu/manage/%', 0x613a313a7b693a343b733a393a226d656e755f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31383a226d656e755f6f766572766965775f666f726d223b693a313b693a343b7d, '', 30, 5, 0, '', 'admin/structure/menu/manage/%', 'Customize menu', 'menu_overview_title', 'a:1:{i:0;i:4;}', '', 'a:0:{}', 6, '', '', 0, 'modules/menu/menu.admin.inc'),
('node/%/revisions/%/delete', 0x613a323a7b693a313b613a313a7b733a393a226e6f64655f6c6f6164223b613a313a7b693a303b693a333b7d7d693a333b4e3b7d, '', '_node_revision_access', 0x613a323a7b693a303b693a313b693a313b733a363a2264656c657465223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a226e6f64655f7265766973696f6e5f64656c6574655f636f6e6669726d223b693a313b693a313b7d, '', 21, 5, 0, '', 'node/%/revisions/%/delete', 'Delete earlier revision', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/node/node.pages.inc'),
('admin/structure/types/manage/%', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31343a226e6f64655f747970655f666f726d223b693a313b693a343b7d, '', 30, 5, 0, '', 'admin/structure/types/manage/%', 'Edit content type', 'node_type_page_title', 'a:1:{i:0;i:4;}', '', 'a:0:{}', 6, '', '', 0, 'modules/node/content_types.inc'),
('node/%/revisions/%/revert', 0x613a323a7b693a313b613a313a7b733a393a226e6f64655f6c6f6164223b613a313a7b693a303b693a333b7d7d693a333b4e3b7d, '', '_node_revision_access', 0x613a323a7b693a303b693a313b693a313b733a363a22757064617465223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a226e6f64655f7265766973696f6e5f7265766572745f636f6e6669726d223b693a313b693a313b7d, '', 21, 5, 0, '', 'node/%/revisions/%/revert', 'Revert to earlier revision', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/node/node.pages.inc'),
('admin/structure/block/demo/bartik', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32353a227468656d65732f62617274696b2f62617274696b2e696e666f223b733a343a226e616d65223b733a363a2262617274696b223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a363a2242617274696b223b733a31313a226465736372697074696f6e223b733a34383a224120666c657869626c652c207265636f6c6f7261626c65207468656d652077697468206d616e7920726567696f6e732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a363a22686561646572223b733a363a22486561646572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a383a226665617475726564223b733a383a224665617475726564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31343a2274726970747963685f6669727374223b733a31343a225472697074796368206669727374223b733a31353a2274726970747963685f6d6964646c65223b733a31353a225472697074796368206d6964646c65223b733a31333a2274726970747963685f6c617374223b733a31333a225472697074796368206c617374223b733a31383a22666f6f7465725f6669727374636f6c756d6e223b733a31393a22466f6f74657220666972737420636f6c756d6e223b733a31393a22666f6f7465725f7365636f6e64636f6c756d6e223b733a32303a22466f6f746572207365636f6e6420636f6c756d6e223b733a31383a22666f6f7465725f7468697264636f6c756d6e223b733a31393a22466f6f74657220746869726420636f6c756d6e223b733a31393a22666f6f7465725f666f75727468636f6c756d6e223b733a32303a22466f6f74657220666f7572746820636f6c756d6e223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2230223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32383a227468656d65732f62617274696b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_demo', 0x613a313a7b693a303b733a363a2262617274696b223b7d, '', 31, 5, 0, '', 'admin/structure/block/demo/bartik', 'Bartik', 't', '', '_block_custom_theme', 'a:1:{i:0;s:6:"bartik";}', 0, '', '', 0, 'modules/block/block.admin.inc'),
('admin/config/user-interface/shortcut/%', 0x613a313a7b693a343b733a31373a2273686f72746375745f7365745f6c6f6164223b7d, '', 'shortcut_set_edit_access', 0x613a313a7b693a303b693a343b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32323a2273686f72746375745f7365745f637573746f6d697a65223b693a313b693a343b7d, '', 30, 5, 0, '', 'admin/config/user-interface/shortcut/%', 'Edit shortcuts', 'shortcut_set_title_callback', 'a:1:{i:0;i:4;}', '', 'a:0:{}', 6, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/structure/block/demo/garland', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32373a227468656d65732f6761726c616e642f6761726c616e642e696e666f223b733a343a226e616d65223b733a373a226761726c616e64223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2230223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a373a224761726c616e64223b733a31313a226465736372697074696f6e223b733a3131313a2241206d756c74692d636f6c756d6e207468656d652077686963682063616e20626520636f6e6669677572656420746f206d6f6469667920636f6c6f727320616e6420737769746368206265747765656e20666978656420616e6420666c756964207769647468206c61796f7574732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a31333a226761726c616e645f7769647468223b733a353a22666c756964223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32393a227468656d65732f6761726c616e642f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_demo', 0x613a313a7b693a303b733a373a226761726c616e64223b7d, '', 31, 5, 0, '', 'admin/structure/block/demo/garland', 'Garland', 't', '', '_block_custom_theme', 'a:1:{i:0;s:7:"garland";}', 0, '', '', 0, 'modules/block/block.admin.inc');
INSERT INTO `menu_router` (`path`, `load_functions`, `to_arg_functions`, `access_callback`, `access_arguments`, `page_callback`, `page_arguments`, `delivery_callback`, `fit`, `number_parts`, `context`, `tab_parent`, `tab_root`, `title`, `title_callback`, `title_arguments`, `theme_callback`, `theme_arguments`, `type`, `description`, `position`, `weight`, `include_file`) VALUES
('admin/structure/block/demo/seven', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32333a227468656d65732f736576656e2f736576656e2e696e666f223b733a343a226e616d65223b733a353a22736576656e223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31383a7b733a343a226e616d65223b733a353a22536576656e223b733a31313a226465736372697074696f6e223b733a36353a22412073696d706c65206f6e652d636f6c756d6e2c207461626c656c6573732c20666c7569642077696474682061646d696e697374726174696f6e207468656d652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2231223b7d733a373a22726567696f6e73223b613a383a7b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31333a22736964656261725f6669727374223b733a31333a2246697273742073696465626172223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a31343a22726567696f6e735f68696464656e223b613a333a7b693a303b733a31333a22736964656261725f6669727374223b693a313b733a383a22706167655f746f70223b693a323b733a31313a22706167655f626f74746f6d223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f736576656e2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_demo', 0x613a313a7b693a303b733a353a22736576656e223b7d, '', 31, 5, 0, '', 'admin/structure/block/demo/seven', 'Seven', 't', '', '_block_custom_theme', 'a:1:{i:0;s:5:"seven";}', 0, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/block/demo/skeletontheme', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a34393a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f736b656c65746f6e7468656d652e696e666f223b733a343a226e616d65223b733a31333a22736b656c65746f6e7468656d65223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2231223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31373a7b733a343a226e616d65223b733a383a22536b656c65746f6e223b733a31313a226465736372697074696f6e223b733a3336313a22536b656c65746f6e206973206120706f77657266756c2c20636c65616e2c20726573706f6e73697665207468656d6520706f7274656420746f2044727570616c206279203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d2f22207461726765743d225f626c616e6b223e4d6f7265205468616e20286a75737429205468656d65733c2f613e2e20496620796f75206c696b652074686973207468656d652c20776520656e636f757261676520796f7520746f2074727920616c736f206f7572206f74686572203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d22207461726765743d225f626c616e6b223e5072656d69756d3c2f613e20616e64203c6120687265663d22687474703a2f2f64727570616c697a696e672e636f6d22207461726765743d225f626c616e6b223e467265653c2f613e2044727570616c207468656d65732e223b733a373a2276657273696f6e223b733a373a22372e782d312e32223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a31353a226865616465725f746f705f6c656674223b733a31353a2248656164657220746f70206c656674223b733a31363a226865616465725f746f705f7269676874223b733a31363a2248656164657220746f70207269676874223b733a31323a226865616465725f7269676874223b733a31323a22486561646572207269676874223b733a363a22686561646572223b733a363a22486561646572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31333a2266656174757265645f6c656674223b733a31333a224665617475726564206c656674223b733a31343a2266656174757265645f7269676874223b733a31343a224665617475726564207269676874223b733a31323a22666f6f7465725f6669727374223b733a31323a22466f6f746572206669727374223b733a31333a22666f6f7465725f7365636f6e64223b733a31333a22466f6f746572207365636f6e64223b733a31323a22666f6f7465725f7468697264223b733a31323a22466f6f746572207468697264223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a333a7b733a32313a22726573706f6e736976655f6d656e755f7374617465223b733a313a2231223b733a32373a22726573706f6e736976655f6d656e755f7377697463687769647468223b733a333a22373630223b733a32393a22726573706f6e736976655f6d656e755f746f706f7074696f6e74657874223b733a31333a2253656c65637420612070616765223b7d733a373a2270726f6a656374223b733a31333a22736b656c65746f6e7468656d65223b733a393a22646174657374616d70223b733a31303a2231333631303632323839223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_demo', 0x613a313a7b693a303b733a31333a22736b656c65746f6e7468656d65223b7d, '', 31, 5, 0, '', 'admin/structure/block/demo/skeletontheme', 'Skeleton', 't', '', '_block_custom_theme', 'a:1:{i:0;s:13:"skeletontheme";}', 0, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/block/demo/stark', '', '', '_block_themes_access', 0x613a313a7b693a303b4f3a383a22737464436c617373223a31323a7b733a383a2266696c656e616d65223b733a32333a227468656d65732f737461726b2f737461726b2e696e666f223b733a343a226e616d65223b733a353a22737461726b223b733a343a2274797065223b733a353a227468656d65223b733a353a226f776e6572223b733a34353a227468656d65732f656e67696e65732f70687074656d706c6174652f70687074656d706c6174652e656e67696e65223b733a363a22737461747573223b733a313a2230223b733a393a22626f6f747374726170223b733a313a2230223b733a31343a22736368656d615f76657273696f6e223b733a323a222d31223b733a363a22776569676874223b733a313a2230223b733a343a22696e666f223b613a31373a7b733a343a226e616d65223b733a353a22537461726b223b733a31313a226465736372697074696f6e223b733a3230383a2254686973207468656d652064656d6f6e737472617465732044727570616c27732064656661756c742048544d4c206d61726b757020616e6420435353207374796c65732e20546f206c6561726e20686f7720746f206275696c6420796f7572206f776e207468656d6520616e64206f766572726964652044727570616c27732064656661756c7420636f64652c2073656520746865203c6120687265663d22687474703a2f2f64727570616c2e6f72672f7468656d652d6775696465223e5468656d696e672047756964653c2f613e2e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f737461726b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d733a363a22707265666978223b733a31313a2270687074656d706c617465223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b7d7d, 'block_admin_demo', 0x613a313a7b693a303b733a353a22737461726b223b7d, '', 31, 5, 0, '', 'admin/structure/block/demo/stark', 'Stark', 't', '', '_block_custom_theme', 'a:1:{i:0;s:5:"stark";}', 0, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/types/manage/%/edit', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31343a226e6f64655f747970655f666f726d223b693a313b693a343b7d, '', 61, 6, 1, 'admin/structure/types/manage/%', 'admin/structure/types/manage/%', 'Edit', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/node/content_types.inc'),
('admin/config/user-interface/shortcut/%/links', 0x613a313a7b693a343b733a31373a2273686f72746375745f7365745f6c6f6164223b7d, '', 'shortcut_set_edit_access', 0x613a313a7b693a303b693a343b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32323a2273686f72746375745f7365745f637573746f6d697a65223b693a313b693a343b7d, '', 61, 6, 1, 'admin/config/user-interface/shortcut/%', 'admin/config/user-interface/shortcut/%', 'List links', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/structure/menu/manage/%/list', 0x613a313a7b693a343b733a393a226d656e755f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31383a226d656e755f6f766572766965775f666f726d223b693a313b693a343b7d, '', 61, 6, 3, 'admin/structure/menu/manage/%', 'admin/structure/menu/manage/%', 'List links', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/menu/menu.admin.inc'),
('admin/config/regional/date-time/formats/lookup', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'system_date_time_lookup', 0x613a303a7b7d, '', 63, 6, 0, '', 'admin/config/regional/date-time/formats/lookup', 'Date and time lookup', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/system/system.admin.inc'),
('admin/structure/types/manage/%/delete', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226e6f64655f747970655f64656c6574655f636f6e6669726d223b693a313b693a343b7d, '', 61, 6, 0, '', 'admin/structure/types/manage/%/delete', 'Delete', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/node/content_types.inc'),
('admin/people/permissions/roles/edit/%', 0x613a313a7b693a353b733a31343a22757365725f726f6c655f6c6f6164223b7d, '', 'user_role_edit_access', 0x613a313a7b693a303b693a353b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31353a22757365725f61646d696e5f726f6c65223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/people/permissions/roles/edit/%', 'Edit role', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/user/user.admin.inc'),
('admin/structure/block/list/bartik/add', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22626c6f636b5f6164645f626c6f636b5f666f726d223b7d, '', 63, 6, 1, 'admin/structure/block/list/bartik', 'admin/structure/block', 'Add block', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/block/list/garland/add', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22626c6f636b5f6164645f626c6f636b5f666f726d223b7d, '', 63, 6, 1, 'admin/structure/block/list/garland', 'admin/structure/block', 'Add block', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/block/list/seven/add', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22626c6f636b5f6164645f626c6f636b5f666f726d223b7d, '', 63, 6, 1, 'admin/structure/block/list/seven', 'admin/structure/block', 'Add block', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/block/list/stark/add', '', '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a32303a22626c6f636b5f6164645f626c6f636b5f666f726d223b7d, '', 63, 6, 1, 'admin/structure/block/list/stark', 'admin/structure/block', 'Add block', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/menu/manage/%/add', 0x613a313a7b693a343b733a393a226d656e755f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a31343a226d656e755f656469745f6974656d223b693a313b733a333a22616464223b693a323b4e3b693a333b693a343b7d, '', 61, 6, 1, 'admin/structure/menu/manage/%', 'admin/structure/menu/manage/%', 'Add link', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/structure/block/manage/%/%', 0x613a323a7b693a343b4e3b693a353b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32313a22626c6f636b5f61646d696e5f636f6e666967757265223b693a313b693a343b693a323b693a353b7d, '', 60, 6, 0, '', 'admin/structure/block/manage/%/%', 'Configure block', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/taxonomy/%/display/default', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a373a2264656661756c74223b693a333b733a31313a22757365725f616363657373223b693a343b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a31333a227461786f6e6f6d795f7465726d223b693a323b693a333b693a333b733a373a2264656661756c74223b7d, '', 59, 6, 1, 'admin/structure/taxonomy/%/display', 'admin/structure/taxonomy/%', 'Default', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/display/default', '', '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a373a2264656661756c74223b693a333b733a31313a22757365725f616363657373223b693a343b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a2275736572223b693a323b733a343a2275736572223b693a333b733a373a2264656661756c74223b7d, '', 63, 6, 1, 'admin/config/people/accounts/display', 'admin/config/people/accounts', 'Default', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/ip-blocking/delete/%', 0x613a313a7b693a353b733a31353a22626c6f636b65645f69705f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31383a22626c6f636b20495020616464726573736573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32353a2273797374656d5f69705f626c6f636b696e675f64656c657465223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/people/ip-blocking/delete/%', 'Delete IP address', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/system/system.admin.inc'),
('admin/config/search/path/delete/%', 0x613a313a7b693a353b733a393a22706174685f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e69737465722075726c20616c6961736573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32353a22706174685f61646d696e5f64656c6574655f636f6e6669726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/search/path/delete/%', 'Delete alias', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/path/path.admin.inc'),
('admin/structure/menu/manage/%/delete', 0x613a313a7b693a343b733a393a226d656e755f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'menu_delete_menu_page', 0x613a313a7b693a303b693a343b7d, '', 61, 6, 0, '', 'admin/structure/menu/manage/%/delete', 'Delete menu', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/structure/menu/item/%/delete', 0x613a313a7b693a343b733a31343a226d656e755f6c696e6b5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'menu_item_delete_page', 0x613a313a7b693a303b693a343b7d, '', 61, 6, 0, '', 'admin/structure/menu/item/%/delete', 'Delete menu link', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/config/search/path/edit/%', 0x613a313a7b693a353b733a393a22706174685f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32323a2261646d696e69737465722075726c20616c6961736573223b7d, 'path_admin_edit', 0x613a313a7b693a303b693a353b7d, '', 62, 6, 0, '', 'admin/config/search/path/edit/%', 'Edit alias', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/path/path.admin.inc'),
('admin/structure/forum/edit/container/%', 0x613a313a7b693a353b733a31383a227461786f6e6f6d795f7465726d5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'forum_form_main', 0x613a323a7b693a303b733a393a22636f6e7461696e6572223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/structure/forum/edit/container/%', 'Edit container', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/forum/forum.admin.inc'),
('admin/structure/forum/edit/forum/%', 0x613a313a7b693a353b733a31383a227461786f6e6f6d795f7465726d5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220666f72756d73223b7d, 'forum_form_main', 0x613a323a7b693a303b733a353a22666f72756d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/structure/forum/edit/forum/%', 'Edit forum', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/forum/forum.admin.inc'),
('admin/structure/menu/item/%/edit', 0x613a313a7b693a343b733a31343a226d656e755f6c696e6b5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a31343a226d656e755f656469745f6974656d223b693a313b733a343a2265646974223b693a323b693a343b693a333b4e3b7d, '', 61, 6, 0, '', 'admin/structure/menu/item/%/edit', 'Edit menu link', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/structure/menu/item/%/reset', 0x613a313a7b693a343b733a31343a226d656e755f6c696e6b5f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32333a226d656e755f72657365745f6974656d5f636f6e6669726d223b693a313b693a343b7d, '', 61, 6, 0, '', 'admin/structure/menu/item/%/reset', 'Reset menu link', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/structure/taxonomy/%/display/full', 0x613a313a7b693a333b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a343a2266756c6c223b693a333b733a31313a22757365725f616363657373223b693a343b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a31333a227461786f6e6f6d795f7465726d223b693a323b693a333b693a333b733a343a2266756c6c223b7d, '', 59, 6, 1, 'admin/structure/taxonomy/%/display', 'admin/structure/taxonomy/%', 'Taxonomy term page', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/display/full', '', '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a343a2266756c6c223b693a333b733a31313a22757365725f616363657373223b693a343b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a2275736572223b693a323b733a343a2275736572223b693a333b733a343a2266756c6c223b7d, '', 63, 6, 1, 'admin/config/people/accounts/display', 'admin/config/people/accounts', 'User account', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/regional/date-time/types/add', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33323a2273797374656d5f6164645f646174655f666f726d61745f747970655f666f726d223b7d, '', 63, 6, 1, 'admin/config/regional/date-time/types', 'admin/config/regional/date-time', 'Add date type', 't', '', '', 'a:0:{}', 388, 'Add new date type.', '', -10, 'modules/system/system.admin.inc'),
('admin/config/regional/date-time/formats/add', '', '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a313a7b693a303b733a33343a2273797374656d5f636f6e6669677572655f646174655f666f726d6174735f666f726d223b7d, '', 63, 6, 1, 'admin/config/regional/date-time/formats', 'admin/config/regional/date-time', 'Add format', 't', '', '', 'a:0:{}', 388, 'Allow users to add additional date formats.', '', -10, 'modules/system/system.admin.inc'),
('admin/config/user-interface/shortcut/%/add-link', 0x613a313a7b693a343b733a31373a2273686f72746375745f7365745f6c6f6164223b7d, '', 'shortcut_set_edit_access', 0x613a313a7b693a303b693a343b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31373a2273686f72746375745f6c696e6b5f616464223b693a313b693a343b7d, '', 61, 6, 1, 'admin/config/user-interface/shortcut/%', 'admin/config/user-interface/shortcut/%', 'Add shortcut', 't', '', '', 'a:0:{}', 388, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/config/user-interface/shortcut/%/add-link-inline', 0x613a313a7b693a343b733a31373a2273686f72746375745f7365745f6c6f6164223b7d, '', 'shortcut_set_edit_access', 0x613a313a7b693a303b693a343b7d, 'shortcut_link_add_inline', 0x613a313a7b693a303b693a343b7d, '', 61, 6, 0, '', 'admin/config/user-interface/shortcut/%/add-link-inline', 'Add shortcut', 't', '', '', 'a:0:{}', 0, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('user/%/cancel/confirm/%/%', 0x613a333a7b693a313b733a393a22757365725f6c6f6164223b693a343b4e3b693a353b4e3b7d, '', 'user_cancel_access', 0x613a313a7b693a303b693a313b7d, 'user_cancel_confirm', 0x613a333a7b693a303b693a313b693a313b693a343b693a323b693a353b7d, '', 44, 6, 0, '', 'user/%/cancel/confirm/%/%', 'Confirm account cancellation', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/user/user.pages.inc'),
('admin/config/system/actions/delete/%', 0x613a313a7b693a353b733a31323a22616374696f6e735f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31383a2261646d696e697374657220616374696f6e73223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a2273797374656d5f616374696f6e735f64656c6574655f666f726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/system/actions/delete/%', 'Delete action', 't', '', '', 'a:0:{}', 6, 'Delete an action.', '', 0, 'modules/system/system.admin.inc'),
('admin/people/permissions/roles/delete/%', 0x613a313a7b693a353b733a31343a22757365725f726f6c655f6c6f6164223b7d, '', 'user_role_edit_access', 0x613a313a7b693a303b693a353b7d, 'drupal_get_form', 0x613a323a7b693a303b733a33303a22757365725f61646d696e5f726f6c655f64656c6574655f636f6e6669726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/people/permissions/roles/delete/%', 'Delete role', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/user/user.admin.inc'),
('admin/config/user-interface/shortcut/%/delete', 0x613a313a7b693a343b733a31373a2273686f72746375745f7365745f6c6f6164223b7d, '', 'shortcut_set_delete_access', 0x613a313a7b693a303b693a343b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a2273686f72746375745f7365745f64656c6574655f666f726d223b693a313b693a343b7d, '', 61, 6, 0, '', 'admin/config/user-interface/shortcut/%/delete', 'Delete shortcut set', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/config/content/formats/%/disable', 0x613a313a7b693a343b733a31383a2266696c7465725f666f726d61745f6c6f6164223b7d, '', '_filter_disable_format_access', 0x613a313a7b693a303b693a343b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32303a2266696c7465725f61646d696e5f64697361626c65223b693a313b693a343b7d, '', 61, 6, 0, '', 'admin/config/content/formats/%/disable', 'Disable text format', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/filter/filter.admin.inc'),
('admin/structure/menu/manage/%/edit', 0x613a313a7b693a343b733a393a226d656e755f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a31353a2261646d696e6973746572206d656e75223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a31343a226d656e755f656469745f6d656e75223b693a313b733a343a2265646974223b693a323b693a343b7d, '', 61, 6, 3, 'admin/structure/menu/manage/%', 'admin/structure/menu/manage/%', 'Edit menu', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/menu/menu.admin.inc'),
('admin/config/user-interface/shortcut/%/edit', 0x613a313a7b693a343b733a31373a2273686f72746375745f7365745f6c6f6164223b7d, '', 'shortcut_set_edit_access', 0x613a313a7b693a303b693a343b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32323a2273686f72746375745f7365745f656469745f666f726d223b693a313b693a343b7d, '', 61, 6, 1, 'admin/config/user-interface/shortcut/%', 'admin/config/user-interface/shortcut/%', 'Edit set name', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/shortcut/shortcut.admin.inc'),
('admin/config/user-interface/shortcut/link/%', 0x613a313a7b693a353b733a31343a226d656e755f6c696e6b5f6c6f6164223b7d, '', 'shortcut_link_access', 0x613a313a7b693a303b693a353b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31383a2273686f72746375745f6c696e6b5f65646974223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/user-interface/shortcut/link/%', 'Edit shortcut', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/config/media/image-styles/edit/%', 0x613a313a7b693a353b733a31363a22696d6167655f7374796c655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a31363a22696d6167655f7374796c655f666f726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/media/image-styles/edit/%', 'Edit style', 't', '', '', 'a:0:{}', 6, 'Configure an image style.', '', 0, 'modules/image/image.admin.inc'),
('admin/structure/types/manage/%/display', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a373a2264656661756c74223b7d, '', 61, 6, 1, 'admin/structure/types/manage/%', 'admin/structure/types/manage/%', 'Manage display', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/fields', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32383a226669656c645f75695f6669656c645f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b7d, '', 61, 6, 1, 'admin/structure/types/manage/%', 'admin/structure/types/manage/%', 'Manage fields', 't', '', '', 'a:0:{}', 132, '', '', 1, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/media/image-styles/delete/%', 0x613a313a7b693a353b613a313a7b733a31363a22696d6167655f7374796c655f6c6f6164223b613a323a7b693a303b4e3b693a313b733a313a2231223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32333a22696d6167655f7374796c655f64656c6574655f666f726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/media/image-styles/delete/%', 'Delete style', 't', '', '', 'a:0:{}', 6, 'Delete an image style.', '', 0, 'modules/image/image.admin.inc'),
('admin/config/media/image-styles/revert/%', 0x613a313a7b693a353b613a313a7b733a31363a22696d6167655f7374796c655f6c6f6164223b613a323a7b693a303b4e3b693a313b733a313a2232223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32333a22696d6167655f7374796c655f7265766572745f666f726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/media/image-styles/revert/%', 'Revert style', 't', '', '', 'a:0:{}', 6, 'Revert an image style.', '', 0, 'modules/image/image.admin.inc'),
('admin/structure/taxonomy/%/fields/%', 0x613a323a7b693a333b613a313a7b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a353b7d, '', 58, 6, 0, '', 'admin/structure/taxonomy/%/fields/%', '', 'field_ui_menu_title', 'a:1:{i:0;i:5;}', '', 'a:0:{}', 6, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/fields/%', 0x613a313a7b693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a313a2230223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a353b7d, '', 62, 6, 0, '', 'admin/config/people/accounts/fields/%', '', 'field_ui_menu_title', 'a:1:{i:0;i:5;}', '', 'a:0:{}', 6, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/block/manage/%/%/configure', 0x613a323a7b693a343b4e3b693a353b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32313a22626c6f636b5f61646d696e5f636f6e666967757265223b693a313b693a343b693a323b693a353b7d, '', 121, 7, 2, 'admin/structure/block/manage/%/%', 'admin/structure/block/manage/%/%', 'Configure block', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/block/block.admin.inc'),
('admin/structure/types/manage/%/display/default', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a373a2264656661756c74223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a373a2264656661756c74223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%', 'Default', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/display/full', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a343a2266756c6c223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a343a2266756c6c223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%', 'Full content', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/display/rss', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a333a22727373223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a333a22727373223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%', 'RSS', 't', '', '', 'a:0:{}', 132, '', '', 2, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/display/search_index', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a31323a227365617263685f696e646578223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a31323a227365617263685f696e646578223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%', 'Search index', 't', '', '', 'a:0:{}', 132, '', '', 3, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/display/search_result', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a31333a227365617263685f726573756c74223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a31333a227365617263685f726573756c74223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%', 'Search result', 't', '', '', 'a:0:{}', 132, '', '', 4, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/display/teaser', 0x613a313a7b693a343b733a31343a226e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a363a22746561736572223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a343a226e6f6465223b693a323b693a343b693a333b733a363a22746561736572223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%/display', 'admin/structure/types/manage/%', 'Teaser', 't', '', '', 'a:0:{}', 132, '', '', 1, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/display', 0x613a313a7b693a343b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a373a22636f6d6d656e74223b693a323b693a343b693a333b733a373a2264656661756c74223b7d, '', 123, 7, 1, 'admin/structure/types/manage/%', 'admin/structure/types/manage/%', 'Comment display', 't', '', '', 'a:0:{}', 132, '', '', 4, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/fields', 0x613a313a7b693a343b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32383a226669656c645f75695f6669656c645f6f766572766965775f666f726d223b693a313b733a373a22636f6d6d656e74223b693a323b693a343b7d, '', 123, 7, 1, 'admin/structure/types/manage/%', 'admin/structure/types/manage/%', 'Comment fields', 't', '', '', 'a:0:{}', 132, '', '', 3, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/block/manage/%/%/delete', 0x613a323a7b693a343b4e3b693a353b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a31373a2261646d696e697374657220626c6f636b73223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32353a22626c6f636b5f637573746f6d5f626c6f636b5f64656c657465223b693a313b693a343b693a323b693a353b7d, '', 121, 7, 0, 'admin/structure/block/manage/%/%', 'admin/structure/block/manage/%/%', 'Delete block', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/block/block.admin.inc'),
('admin/config/regional/date-time/formats/%/delete', 0x613a313a7b693a353b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a33303a2273797374656d5f646174655f64656c6574655f666f726d61745f666f726d223b693a313b693a353b7d, '', 125, 7, 0, '', 'admin/config/regional/date-time/formats/%/delete', 'Delete date format', 't', '', '', 'a:0:{}', 6, 'Allow users to delete a configured date format.', '', 0, 'modules/system/system.admin.inc'),
('admin/config/regional/date-time/types/%/delete', 0x613a313a7b693a353b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a33353a2273797374656d5f64656c6574655f646174655f666f726d61745f747970655f666f726d223b693a313b693a353b7d, '', 125, 7, 0, '', 'admin/config/regional/date-time/types/%/delete', 'Delete date type', 't', '', '', 'a:0:{}', 6, 'Allow users to delete a configured date type.', '', 0, 'modules/system/system.admin.inc'),
('admin/config/user-interface/shortcut/link/%/delete', 0x613a313a7b693a353b733a31343a226d656e755f6c696e6b5f6c6f6164223b7d, '', 'shortcut_link_access', 0x613a313a7b693a303b693a353b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32303a2273686f72746375745f6c696e6b5f64656c657465223b693a313b693a353b7d, '', 125, 7, 0, '', 'admin/config/user-interface/shortcut/link/%/delete', 'Delete shortcut', 't', '', '', 'a:0:{}', 6, '', '', 0, 'modules/shortcut/shortcut.admin.inc'),
('admin/config/regional/date-time/formats/%/edit', 0x613a313a7b693a353b4e3b7d, '', 'user_access', 0x613a313a7b693a303b733a32393a2261646d696e6973746572207369746520636f6e66696775726174696f6e223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a33343a2273797374656d5f636f6e6669677572655f646174655f666f726d6174735f666f726d223b693a313b693a353b7d, '', 125, 7, 0, '', 'admin/config/regional/date-time/formats/%/edit', 'Edit date format', 't', '', '', 'a:0:{}', 6, 'Allow users to edit a configured date format.', '', 0, 'modules/system/system.admin.inc'),
('admin/structure/taxonomy/%/fields/%/delete', 0x613a323a7b693a333b613a313a7b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a226669656c645f75695f6669656c645f64656c6574655f666f726d223b693a313b693a353b7d, '', 117, 7, 1, 'admin/structure/taxonomy/%/fields/%', 'admin/structure/taxonomy/%/fields/%', 'Delete', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/taxonomy/%/fields/%/edit', 0x613a323a7b693a333b613a313a7b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a353b7d, '', 117, 7, 1, 'admin/structure/taxonomy/%/fields/%', 'admin/structure/taxonomy/%/fields/%', 'Edit', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/taxonomy/%/fields/%/field-settings', 0x613a323a7b693a333b613a313a7b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a226669656c645f75695f6669656c645f73657474696e67735f666f726d223b693a313b693a353b7d, '', 117, 7, 1, 'admin/structure/taxonomy/%/fields/%', 'admin/structure/taxonomy/%/fields/%', 'Field settings', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc');
INSERT INTO `menu_router` (`path`, `load_functions`, `to_arg_functions`, `access_callback`, `access_arguments`, `page_callback`, `page_arguments`, `delivery_callback`, `fit`, `number_parts`, `context`, `tab_parent`, `tab_root`, `title`, `title_callback`, `title_arguments`, `theme_callback`, `theme_arguments`, `type`, `description`, `position`, `weight`, `include_file`) VALUES
('admin/structure/taxonomy/%/fields/%/widget-type', 0x613a323a7b693a333b613a313a7b733a33373a227461786f6e6f6d795f766f636162756c6172795f6d616368696e655f6e616d655f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a31333a227461786f6e6f6d795f7465726d223b693a313b693a333b693a323b733a313a2233223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31393a2261646d696e6973746572207461786f6e6f6d79223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32353a226669656c645f75695f7769646765745f747970655f666f726d223b693a313b693a353b7d, '', 117, 7, 1, 'admin/structure/taxonomy/%/fields/%', 'admin/structure/taxonomy/%/fields/%', 'Widget type', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/fields/%/delete', 0x613a313a7b693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a313a2230223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a226669656c645f75695f6669656c645f64656c6574655f666f726d223b693a313b693a353b7d, '', 125, 7, 1, 'admin/config/people/accounts/fields/%', 'admin/config/people/accounts/fields/%', 'Delete', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/fields/%/edit', 0x613a313a7b693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a313a2230223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a353b7d, '', 125, 7, 1, 'admin/config/people/accounts/fields/%', 'admin/config/people/accounts/fields/%', 'Edit', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/fields/%/field-settings', 0x613a313a7b693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a313a2230223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a226669656c645f75695f6669656c645f73657474696e67735f666f726d223b693a313b693a353b7d, '', 125, 7, 1, 'admin/config/people/accounts/fields/%', 'admin/config/people/accounts/fields/%', 'Field settings', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/people/accounts/fields/%/widget-type', 0x613a313a7b693a353b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a2275736572223b693a313b733a343a2275736572223b693a323b733a313a2230223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a31363a2261646d696e6973746572207573657273223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32353a226669656c645f75695f7769646765745f747970655f666f726d223b693a313b693a353b7d, '', 125, 7, 1, 'admin/config/people/accounts/fields/%', 'admin/config/people/accounts/fields/%', 'Widget type', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/fields/%', 0x613a323a7b693a343b613a313a7b733a31343a226e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a363b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a363b7d, '', 122, 7, 0, '', 'admin/structure/types/manage/%/fields/%', '', 'field_ui_menu_title', 'a:1:{i:0;i:6;}', '', 'a:0:{}', 6, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/display/default', 0x613a313a7b693a343b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a373a2264656661756c74223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a373a22636f6d6d656e74223b693a323b693a343b693a333b733a373a2264656661756c74223b7d, '', 247, 8, 1, 'admin/structure/types/manage/%/comment/display', 'admin/structure/types/manage/%', 'Default', 't', '', '', 'a:0:{}', 140, '', '', -10, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/display/full', 0x613a313a7b693a343b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b7d, '', '_field_ui_view_mode_menu_access', 0x613a353a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a343a2266756c6c223b693a333b733a31313a22757365725f616363657373223b693a343b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a343a7b693a303b733a33303a226669656c645f75695f646973706c61795f6f766572766965775f666f726d223b693a313b733a373a22636f6d6d656e74223b693a323b693a343b693a333b733a343a2266756c6c223b7d, '', 247, 8, 1, 'admin/structure/types/manage/%/comment/display', 'admin/structure/types/manage/%', 'Full comment', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/media/image-styles/edit/%/add/%', 0x613a323a7b693a353b613a313a7b733a31363a22696d6167655f7374796c655f6c6f6164223b613a313a7b693a303b693a353b7d7d693a373b613a313a7b733a32383a22696d6167655f6566666563745f646566696e6974696f6e5f6c6f6164223b613a313a7b693a303b693a353b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a31373a22696d6167655f6566666563745f666f726d223b693a313b693a353b693a323b693a373b7d, '', 250, 8, 0, '', 'admin/config/media/image-styles/edit/%/add/%', 'Add image effect', 't', '', '', 'a:0:{}', 6, 'Add a new effect to a style.', '', 0, 'modules/image/image.admin.inc'),
('admin/structure/types/manage/%/fields/%/delete', 0x613a323a7b693a343b613a313a7b733a31343a226e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a363b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a226669656c645f75695f6669656c645f64656c6574655f666f726d223b693a313b693a363b7d, '', 245, 8, 1, 'admin/structure/types/manage/%/fields/%', 'admin/structure/types/manage/%/fields/%', 'Delete', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/fields/%/edit', 0x613a323a7b693a343b613a313a7b733a31343a226e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a363b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a363b7d, '', 245, 8, 1, 'admin/structure/types/manage/%/fields/%', 'admin/structure/types/manage/%/fields/%', 'Edit', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/media/image-styles/edit/%/effects/%', 0x613a323a7b693a353b613a313a7b733a31363a22696d6167655f7374796c655f6c6f6164223b613a323a7b693a303b693a353b693a313b733a313a2233223b7d7d693a373b613a313a7b733a31373a22696d6167655f6566666563745f6c6f6164223b613a323a7b693a303b693a353b693a313b733a313a2233223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a31373a22696d6167655f6566666563745f666f726d223b693a313b693a353b693a323b693a373b7d, '', 250, 8, 0, '', 'admin/config/media/image-styles/edit/%/effects/%', 'Edit image effect', 't', '', '', 'a:0:{}', 6, 'Edit an existing effect within a style.', '', 0, 'modules/image/image.admin.inc'),
('admin/structure/types/manage/%/fields/%/field-settings', 0x613a323a7b693a343b613a313a7b733a31343a226e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a363b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a226669656c645f75695f6669656c645f73657474696e67735f666f726d223b693a313b693a363b7d, '', 245, 8, 1, 'admin/structure/types/manage/%/fields/%', 'admin/structure/types/manage/%/fields/%', 'Field settings', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/fields/%/widget-type', 0x613a323a7b693a343b613a313a7b733a31343a226e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a363b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a343a226e6f6465223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32353a226669656c645f75695f7769646765745f747970655f666f726d223b693a313b693a363b7d, '', 245, 8, 1, 'admin/structure/types/manage/%/fields/%', 'admin/structure/types/manage/%/fields/%', 'Widget type', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/fields/%', 0x613a323a7b693a343b613a313a7b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a373b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a373b7d, '', 246, 8, 0, '', 'admin/structure/types/manage/%/comment/fields/%', '', 'field_ui_menu_title', 'a:1:{i:0;i:7;}', '', 'a:0:{}', 6, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/fields/%/delete', 0x613a323a7b693a343b613a313a7b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a373b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32363a226669656c645f75695f6669656c645f64656c6574655f666f726d223b693a313b693a373b7d, '', 493, 9, 1, 'admin/structure/types/manage/%/comment/fields/%', 'admin/structure/types/manage/%/comment/fields/%', 'Delete', 't', '', '', 'a:0:{}', 132, '', '', 10, 'modules/field_ui/field_ui.admin.inc'),
('admin/config/media/image-styles/edit/%/effects/%/delete', 0x613a323a7b693a353b613a313a7b733a31363a22696d6167655f7374796c655f6c6f6164223b613a323a7b693a303b693a353b693a313b733a313a2233223b7d7d693a373b613a313a7b733a31373a22696d6167655f6566666563745f6c6f6164223b613a323a7b693a303b693a353b693a313b733a313a2233223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32333a2261646d696e697374657220696d616765207374796c6573223b7d, 'drupal_get_form', 0x613a333a7b693a303b733a32343a22696d6167655f6566666563745f64656c6574655f666f726d223b693a313b693a353b693a323b693a373b7d, '', 501, 9, 0, '', 'admin/config/media/image-styles/edit/%/effects/%/delete', 'Delete image effect', 't', '', '', 'a:0:{}', 6, 'Delete an existing effect from a style.', '', 0, 'modules/image/image.admin.inc'),
('admin/structure/types/manage/%/comment/fields/%/edit', 0x613a323a7b693a343b613a313a7b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a373b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32343a226669656c645f75695f6669656c645f656469745f666f726d223b693a313b693a373b7d, '', 493, 9, 1, 'admin/structure/types/manage/%/comment/fields/%', 'admin/structure/types/manage/%/comment/fields/%', 'Edit', 't', '', '', 'a:0:{}', 140, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/fields/%/field-settings', 0x613a323a7b693a343b613a313a7b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a373b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32383a226669656c645f75695f6669656c645f73657474696e67735f666f726d223b693a313b693a373b7d, '', 493, 9, 1, 'admin/structure/types/manage/%/comment/fields/%', 'admin/structure/types/manage/%/comment/fields/%', 'Field settings', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc'),
('admin/structure/types/manage/%/comment/fields/%/widget-type', 0x613a323a7b693a343b613a313a7b733a32323a22636f6d6d656e745f6e6f64655f747970655f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d693a373b613a313a7b733a31383a226669656c645f75695f6d656e755f6c6f6164223b613a343a7b693a303b733a373a22636f6d6d656e74223b693a313b693a343b693a323b733a313a2234223b693a333b733a343a22256d6170223b7d7d7d, '', 'user_access', 0x613a313a7b693a303b733a32343a2261646d696e697374657220636f6e74656e74207479706573223b7d, 'drupal_get_form', 0x613a323a7b693a303b733a32353a226669656c645f75695f7769646765745f747970655f666f726d223b693a313b693a373b7d, '', 493, 9, 1, 'admin/structure/types/manage/%/comment/fields/%', 'admin/structure/types/manage/%/comment/fields/%', 'Widget type', 't', '', '', 'a:0:{}', 132, '', '', 0, 'modules/field_ui/field_ui.admin.inc');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `node`
--

CREATE TABLE IF NOT EXISTS `node` (
  `nid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a node.',
  `vid` int(10) unsigned DEFAULT NULL COMMENT 'The current node_revision.vid version identifier.',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'The node_type.type of this node.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The languages.language of this node.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this node, always treated as non-markup plain text.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that owns this node; initially, this is the user that created it.',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the node is published (visible to non-administrators).',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was created.',
  `changed` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was most recently saved.',
  `comment` int(11) NOT NULL DEFAULT '0' COMMENT 'Whether comments are allowed on this node: 0 = no, 1 = closed (read only), 2 = open (read/write).',
  `promote` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node should be displayed on the front page.',
  `sticky` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node should be displayed at the top of lists in which it appears.',
  `tnid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The translation set id for this node, which equals the node id of the source post in each set.',
  `translate` int(11) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this translation page needs to be updated.',
  PRIMARY KEY (`nid`),
  UNIQUE KEY `vid` (`vid`),
  KEY `node_changed` (`changed`),
  KEY `node_created` (`created`),
  KEY `node_frontpage` (`promote`,`status`,`sticky`,`created`),
  KEY `node_status_type` (`status`,`type`,`nid`),
  KEY `node_title_type` (`title`,`type`(4)),
  KEY `node_type` (`type`(4)),
  KEY `uid` (`uid`),
  KEY `tnid` (`tnid`),
  KEY `translate` (`translate`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='The base table for nodes.' AUTO_INCREMENT=11 ;

--
-- Άδειασμα δεδομένων του πίνακα `node`
--

INSERT INTO `node` (`nid`, `vid`, `type`, `language`, `title`, `uid`, `status`, `created`, `changed`, `comment`, `promote`, `sticky`, `tnid`, `translate`) VALUES
(1, 1, 'page', 'und', 'Skeleton is a Responsive, Mobile-Friendly Theme', 1, 1, 1332190489, 1337364025, 1, 0, 0, 0, 0),
(2, 2, 'page', 'und', 'Welcome to Skeleton', 1, 1, 1336235955, 1337355209, 1, 0, 0, 0, 0),
(3, 3, 'page', 'und', 'Documentation', 1, 1, 1336236853, 1336236853, 1, 0, 0, 0, 0),
(4, 4, 'blog', 'und', 'Sample Blog Post', 1, 1, 1337182376, 1337182376, 2, 1, 0, 0, 0),
(5, 5, 'blog', 'und', 'Another Blog Post', 1, 1, 1337182581, 1337336160, 2, 1, 0, 0, 0),
(6, 6, 'forum', 'und', 'Drupal 7 Responsive Web Design (RWD) ', 1, 1, 1337258099, 1337258099, 2, 0, 0, 0, 0),
(7, 7, 'page', 'und', 'Get Skeleton', 1, 1, 1337259863, 1337366157, 1, 0, 0, 0, 0),
(8, 8, 'page', 'und', 'Button Styles', 1, 1, 1337292808, 1337296011, 1, 0, 0, 0, 0),
(9, 9, 'page', 'und', 'Typography', 1, 1, 1337334551, 1337334551, 1, 0, 0, 0, 0),
(10, 10, 'page', 'und', 'Column Shortcodes with Media Queries', 1, 1, 1337336521, 1337336553, 1, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `node_access`
--

CREATE TABLE IF NOT EXISTS `node_access` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid this record affects.',
  `gid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The grant ID a user must possess in the specified realm to gain this row’s privileges on the node.',
  `realm` varchar(255) NOT NULL DEFAULT '' COMMENT 'The realm in which the user must possess the grant ID. Each node access node can define one or more realms.',
  `grant_view` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether a user with the realm/grant pair can view this node.',
  `grant_update` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether a user with the realm/grant pair can edit this node.',
  `grant_delete` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether a user with the realm/grant pair can delete this node.',
  PRIMARY KEY (`nid`,`gid`,`realm`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Identifies which realm/grant pairs a user must possess in...';

--
-- Άδειασμα δεδομένων του πίνακα `node_access`
--

INSERT INTO `node_access` (`nid`, `gid`, `realm`, `grant_view`, `grant_update`, `grant_delete`) VALUES
(0, 0, 'all', 1, 0, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `node_comment_statistics`
--

CREATE TABLE IF NOT EXISTS `node_comment_statistics` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid for which the statistics are compiled.',
  `cid` int(11) NOT NULL DEFAULT '0' COMMENT 'The comment.cid of the last comment.',
  `last_comment_timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp of the last comment that was posted within this node, from comment.changed.',
  `last_comment_name` varchar(60) DEFAULT NULL COMMENT 'The name of the latest author to post a comment on this node, from comment.name.',
  `last_comment_uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The user ID of the latest author to post a comment on this node, from comment.uid.',
  `comment_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The total number of comments on this node.',
  PRIMARY KEY (`nid`),
  KEY `node_comment_timestamp` (`last_comment_timestamp`),
  KEY `comment_count` (`comment_count`),
  KEY `last_comment_uid` (`last_comment_uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Maintains statistics of node and comments posts to show ...';

--
-- Άδειασμα δεδομένων του πίνακα `node_comment_statistics`
--

INSERT INTO `node_comment_statistics` (`nid`, `cid`, `last_comment_timestamp`, `last_comment_name`, `last_comment_uid`, `comment_count`) VALUES
(1, 0, 1332190489, NULL, 1, 0),
(2, 0, 1336235955, NULL, 1, 0),
(3, 0, 1336236853, NULL, 1, 0),
(4, 0, 1337182376, NULL, 1, 0),
(5, 2, 1337182670, '', 1, 2),
(6, 3, 1337258198, '', 1, 1),
(7, 0, 1337259863, NULL, 1, 0),
(8, 0, 1337292808, NULL, 1, 0),
(9, 0, 1337334551, NULL, 1, 0),
(10, 0, 1337336521, NULL, 1, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `node_revision`
--

CREATE TABLE IF NOT EXISTS `node_revision` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node this version belongs to.',
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for this version.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that created this version.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this version.',
  `log` longtext NOT NULL COMMENT 'The log entry explaining the changes in this version.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when this version was created.',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the node (at the time of this revision) is published (visible to non-administrators).',
  `comment` int(11) NOT NULL DEFAULT '0' COMMENT 'Whether comments are allowed on this node (at the time of this revision): 0 = no, 1 = closed (read only), 2 = open (read/write).',
  `promote` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node (at the time of this revision) should be displayed on the front page.',
  `sticky` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node (at the time of this revision) should be displayed at the top of lists in which it appears.',
  PRIMARY KEY (`vid`),
  KEY `nid` (`nid`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores information about each saved version of a node.' AUTO_INCREMENT=11 ;

--
-- Άδειασμα δεδομένων του πίνακα `node_revision`
--

INSERT INTO `node_revision` (`nid`, `vid`, `uid`, `title`, `log`, `timestamp`, `status`, `comment`, `promote`, `sticky`) VALUES
(1, 1, 1, 'Skeleton is a Responsive, Mobile-Friendly Theme', '', 1337364025, 1, 1, 0, 0),
(2, 2, 1, 'Welcome to Skeleton', '', 1337355209, 1, 1, 0, 0),
(3, 3, 1, 'Documentation', '', 1336236853, 1, 1, 0, 0),
(4, 4, 1, 'Sample Blog Post', '', 1337182376, 1, 2, 1, 0),
(5, 5, 1, 'Another Blog Post', '', 1337336160, 1, 2, 1, 0),
(6, 6, 1, 'Drupal 7 Responsive Web Design (RWD) ', '', 1337258099, 1, 2, 0, 0),
(7, 7, 1, 'Get Skeleton', '', 1337366157, 1, 1, 0, 0),
(8, 8, 1, 'Button Styles', '', 1337296011, 1, 1, 0, 0),
(9, 9, 1, 'Typography', '', 1337334551, 1, 1, 0, 0),
(10, 10, 1, 'Column Shortcodes with Media Queries', '', 1337336553, 1, 1, 0, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `node_type`
--

CREATE TABLE IF NOT EXISTS `node_type` (
  `type` varchar(32) NOT NULL COMMENT 'The machine-readable name of this type.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The human-readable name of this type.',
  `base` varchar(255) NOT NULL COMMENT 'The base string used to construct callbacks corresponding to this node type.',
  `module` varchar(255) NOT NULL COMMENT 'The module defining this node type.',
  `description` mediumtext NOT NULL COMMENT 'A brief description of this type.',
  `help` mediumtext NOT NULL COMMENT 'Help information shown to the user when creating a node of this type.',
  `has_title` tinyint(3) unsigned NOT NULL COMMENT 'Boolean indicating whether this type uses the node.title field.',
  `title_label` varchar(255) NOT NULL DEFAULT '' COMMENT 'The label displayed for the title field on the edit form.',
  `custom` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this type is defined by a module (FALSE) or by a user via Add content type (TRUE).',
  `modified` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this type has been modified by an administrator; currently not used in any way.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether the administrator can change the machine name of this type.',
  `disabled` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether the node type is disabled.',
  `orig_type` varchar(255) NOT NULL DEFAULT '' COMMENT 'The original machine-readable name of this node type. This may be different from the current type name if the locked field is 0.',
  PRIMARY KEY (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores information about all defined node types.';

--
-- Άδειασμα δεδομένων του πίνακα `node_type`
--

INSERT INTO `node_type` (`type`, `name`, `base`, `module`, `description`, `help`, `has_title`, `title_label`, `custom`, `modified`, `locked`, `disabled`, `orig_type`) VALUES
('article', 'Article', 'node_content', 'node', 'Use <em>articles</em> for time-sensitive content like news, press releases or blog posts.', '', 1, 'Title', 1, 1, 0, 0, 'article'),
('blog', 'Blog entry', 'blog', 'blog', 'Use for multi-user blogs. Every user gets a personal blog.', '', 1, 'Title', 0, 0, 1, 0, 'blog'),
('forum', 'Forum topic', 'forum', 'forum', 'A <em>forum topic</em> starts a new discussion thread within a forum.', '', 1, 'Subject', 0, 0, 1, 0, 'forum'),
('page', 'Basic page', 'node_content', 'node', 'Use <em>basic pages</em> for your static content, such as an ''About us'' page.', '', 1, 'Title', 1, 1, 0, 0, 'page');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `queue`
--

CREATE TABLE IF NOT EXISTS `queue` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique item ID.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The queue name.',
  `data` longblob COMMENT 'The arbitrary data for the item.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp when the claim lease expires on the item.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp when the item was created.',
  PRIMARY KEY (`item_id`),
  KEY `name_created` (`name`,`created`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores items in queues.' AUTO_INCREMENT=320 ;

--
-- Άδειασμα δεδομένων του πίνακα `queue`
--

INSERT INTO `queue` (`item_id`, `name`, `data`, `expire`, `created`) VALUES
(317, 'update_fetch_tasks', 0x613a383a7b733a343a226e616d65223b733a393a226c6962726172696573223b733a343a22696e666f223b613a363a7b733a343a226e616d65223b733a393a224c6962726172696573223b733a373a2276657273696f6e223b733a373a22372e782d322e31223b733a373a2270726f6a656374223b733a393a226c6962726172696573223b733a393a22646174657374616d70223b733a31303a2231333632383438343132223b733a373a227061636b616765223b733a353a224f74686572223b733a31363a225f696e666f5f66696c655f6374696d65223b693a313336343430363330363b7d733a393a22646174657374616d70223b733a31303a2231333632383438343132223b733a383a22696e636c75646573223b613a313a7b733a393a226c6962726172696573223b733a393a224c6962726172696573223b7d733a31323a2270726f6a6563745f74797065223b733a363a226d6f64756c65223b733a31343a2270726f6a6563745f737461747573223b623a313b733a31303a227375625f7468656d6573223b613a303a7b7d733a31313a22626173655f7468656d6573223b613a303a7b7d7d, 0, 1367391274),
(319, 'update_fetch_tasks', 0x613a383a7b733a343a226e616d65223b733a31333a22736b656c65746f6e7468656d65223b733a343a22696e666f223b613a353a7b733a343a226e616d65223b733a383a22536b656c65746f6e223b733a373a2276657273696f6e223b733a373a22372e782d312e32223b733a373a2270726f6a656374223b733a31333a22736b656c65746f6e7468656d65223b733a393a22646174657374616d70223b733a31303a2231333631303632323839223b733a31363a225f696e666f5f66696c655f6374696d65223b693a313336303837333138353b7d733a393a22646174657374616d70223b733a31303a2231333631303632323839223b733a383a22696e636c75646573223b613a313a7b733a31333a22736b656c65746f6e7468656d65223b733a383a22536b656c65746f6e223b7d733a31323a2270726f6a6563745f74797065223b733a353a227468656d65223b733a31343a2270726f6a6563745f737461747573223b623a313b733a31303a227375625f7468656d6573223b613a303a7b7d733a31313a22626173655f7468656d6573223b613a303a7b7d7d, 0, 1367391274),
(318, 'update_fetch_tasks', 0x613a383a7b733a343a226e616d65223b733a393a22737570657266697368223b733a343a22696e666f223b613a363a7b733a343a226e616d65223b733a393a22537570657266697368223b733a373a227061636b616765223b733a31343a225573657220696e74657266616365223b733a373a2276657273696f6e223b733a373a22372e782d312e39223b733a373a2270726f6a656374223b733a393a22737570657266697368223b733a393a22646174657374616d70223b733a31303a2231333637303534313132223b733a31363a225f696e666f5f66696c655f6374696d65223b693a313336373339313133393b7d733a393a22646174657374616d70223b733a31303a2231333637303534313132223b733a383a22696e636c75646573223b613a313a7b733a393a22737570657266697368223b733a393a22537570657266697368223b7d733a31323a2270726f6a6563745f74797065223b733a363a226d6f64756c65223b733a31343a2270726f6a6563745f737461747573223b623a313b733a31303a227375625f7468656d6573223b613a303a7b7d733a31313a22626173655f7468656d6573223b613a303a7b7d7d, 0, 1367391274);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `rdf_mapping`
--

CREATE TABLE IF NOT EXISTS `rdf_mapping` (
  `type` varchar(128) NOT NULL COMMENT 'The name of the entity type a mapping applies to (node, user, comment, etc.).',
  `bundle` varchar(128) NOT NULL COMMENT 'The name of the bundle a mapping applies to.',
  `mapping` longblob COMMENT 'The serialized mapping of the bundle type and fields to RDF terms.',
  PRIMARY KEY (`type`,`bundle`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores custom RDF mappings for user defined content types...';

--
-- Άδειασμα δεδομένων του πίνακα `rdf_mapping`
--

INSERT INTO `rdf_mapping` (`type`, `bundle`, `mapping`) VALUES
('node', 'article', 0x613a31313a7b733a31313a226669656c645f696d616765223b613a323a7b733a31303a2270726564696361746573223b613a323a7b693a303b733a383a226f673a696d616765223b693a313b733a31323a22726466733a736565416c736f223b7d733a343a2274797065223b733a333a2272656c223b7d733a31303a226669656c645f74616773223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31303a2264633a7375626a656374223b7d733a343a2274797065223b733a333a2272656c223b7d733a373a2272646674797065223b613a323a7b693a303b733a393a2273696f633a4974656d223b693a313b733a31333a22666f61663a446f63756d656e74223b7d733a353a227469746c65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a383a2264633a7469746c65223b7d7d733a373a2263726561746564223b613a333a7b733a31303a2270726564696361746573223b613a323a7b693a303b733a373a2264633a64617465223b693a313b733a31303a2264633a63726561746564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a373a226368616e676564223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31313a2264633a6d6f646966696564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a343a22626f6479223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31353a22636f6e74656e743a656e636f646564223b7d7d733a333a22756964223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6861735f63726561746f72223b7d733a343a2274797065223b733a333a2272656c223b7d733a343a226e616d65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a393a22666f61663a6e616d65223b7d7d733a31333a22636f6d6d656e745f636f756e74223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6e756d5f7265706c696573223b7d733a383a226461746174797065223b733a31313a227873643a696e7465676572223b7d733a31333a226c6173745f6163746976697479223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a32333a2273696f633a6c6173745f61637469766974795f64617465223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d7d),
('node', 'blog', 0x613a393a7b733a373a2272646674797065223b613a323a7b693a303b733a393a2273696f633a506f7374223b693a313b733a31343a2273696f63743a426c6f67506f7374223b7d733a353a227469746c65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a383a2264633a7469746c65223b7d7d733a373a2263726561746564223b613a333a7b733a31303a2270726564696361746573223b613a323a7b693a303b733a373a2264633a64617465223b693a313b733a31303a2264633a63726561746564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a373a226368616e676564223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31313a2264633a6d6f646966696564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a343a22626f6479223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31353a22636f6e74656e743a656e636f646564223b7d7d733a333a22756964223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6861735f63726561746f72223b7d733a343a2274797065223b733a333a2272656c223b7d733a343a226e616d65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a393a22666f61663a6e616d65223b7d7d733a31333a22636f6d6d656e745f636f756e74223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6e756d5f7265706c696573223b7d733a383a226461746174797065223b733a31313a227873643a696e7465676572223b7d733a31333a226c6173745f6163746976697479223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a32333a2273696f633a6c6173745f61637469766974795f64617465223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d7d),
('node', 'forum', 0x613a31303a7b733a373a2272646674797065223b613a323a7b693a303b733a393a2273696f633a506f7374223b693a313b733a31353a2273696f63743a426f617264506f7374223b7d733a31353a227461786f6e6f6d795f666f72756d73223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31383a2273696f633a6861735f636f6e7461696e6572223b7d733a343a2274797065223b733a333a2272656c223b7d733a353a227469746c65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a383a2264633a7469746c65223b7d7d733a373a2263726561746564223b613a333a7b733a31303a2270726564696361746573223b613a323a7b693a303b733a373a2264633a64617465223b693a313b733a31303a2264633a63726561746564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a373a226368616e676564223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31313a2264633a6d6f646966696564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a343a22626f6479223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31353a22636f6e74656e743a656e636f646564223b7d7d733a333a22756964223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6861735f63726561746f72223b7d733a343a2274797065223b733a333a2272656c223b7d733a343a226e616d65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a393a22666f61663a6e616d65223b7d7d733a31333a22636f6d6d656e745f636f756e74223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6e756d5f7265706c696573223b7d733a383a226461746174797065223b733a31313a227873643a696e7465676572223b7d733a31333a226c6173745f6163746976697479223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a32333a2273696f633a6c6173745f61637469766974795f64617465223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d7d),
('node', 'page', 0x613a393a7b733a373a2272646674797065223b613a313a7b693a303b733a31333a22666f61663a446f63756d656e74223b7d733a353a227469746c65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a383a2264633a7469746c65223b7d7d733a373a2263726561746564223b613a333a7b733a31303a2270726564696361746573223b613a323a7b693a303b733a373a2264633a64617465223b693a313b733a31303a2264633a63726561746564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a373a226368616e676564223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31313a2264633a6d6f646966696564223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d733a343a22626f6479223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31353a22636f6e74656e743a656e636f646564223b7d7d733a333a22756964223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6861735f63726561746f72223b7d733a343a2274797065223b733a333a2272656c223b7d733a343a226e616d65223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a393a22666f61663a6e616d65223b7d7d733a31333a22636f6d6d656e745f636f756e74223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31363a2273696f633a6e756d5f7265706c696573223b7d733a383a226461746174797065223b733a31313a227873643a696e7465676572223b7d733a31333a226c6173745f6163746976697479223b613a333a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a32333a2273696f633a6c6173745f61637469766974795f64617465223b7d733a383a226461746174797065223b733a31323a227873643a6461746554696d65223b733a383a2263616c6c6261636b223b733a31323a22646174655f69736f38363031223b7d7d),
('taxonomy_term', 'forums', 0x613a353a7b733a373a2272646674797065223b613a323a7b693a303b733a31343a2273696f633a436f6e7461696e6572223b693a313b733a31303a2273696f633a466f72756d223b7d733a343a226e616d65223b613a313a7b733a31303a2270726564696361746573223b613a323a7b693a303b733a31303a22726466733a6c6162656c223b693a313b733a31343a22736b6f733a707265664c6162656c223b7d7d733a31313a226465736372697074696f6e223b613a313a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31353a22736b6f733a646566696e6974696f6e223b7d7d733a333a22766964223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31333a22736b6f733a696e536368656d65223b7d733a343a2274797065223b733a333a2272656c223b7d733a363a22706172656e74223b613a323a7b733a31303a2270726564696361746573223b613a313a7b693a303b733a31323a22736b6f733a62726f61646572223b7d733a343a2274797065223b733a333a2272656c223b7d7d);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `registry`
--

CREATE TABLE IF NOT EXISTS `registry` (
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the function, class, or interface.',
  `type` varchar(9) NOT NULL DEFAULT '' COMMENT 'Either function or class or interface.',
  `filename` varchar(255) NOT NULL COMMENT 'Name of the file.',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the module the file belongs to.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The order in which this module’s hooks should be invoked relative to other modules. Equal-weighted modules are ordered by name.',
  PRIMARY KEY (`name`,`type`),
  KEY `hook` (`type`,`weight`,`module`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Each record is a function, class, or interface name and...';

--
-- Άδειασμα δεδομένων του πίνακα `registry`
--

INSERT INTO `registry` (`name`, `type`, `filename`, `module`, `weight`) VALUES
('AccessDeniedTestCase', 'class', 'modules/system/system.test', 'system', 0),
('AdminMetaTagTestCase', 'class', 'modules/system/system.test', 'system', 0),
('ArchiverInterface', 'interface', 'includes/archiver.inc', '', 0),
('ArchiverTar', 'class', 'modules/system/system.archiver.inc', 'system', 0),
('ArchiverZip', 'class', 'modules/system/system.archiver.inc', 'system', 0),
('Archive_Tar', 'class', 'modules/system/system.tar.inc', 'system', 0),
('BatchMemoryQueue', 'class', 'includes/batch.queue.inc', '', 0),
('BatchQueue', 'class', 'includes/batch.queue.inc', '', 0),
('BlockAdminThemeTestCase', 'class', 'modules/block/block.test', 'block', -5),
('BlockCacheTestCase', 'class', 'modules/block/block.test', 'block', -5),
('BlockHiddenRegionTestCase', 'class', 'modules/block/block.test', 'block', -5),
('BlockHTMLIdTestCase', 'class', 'modules/block/block.test', 'block', -5),
('BlockInvalidRegionTestCase', 'class', 'modules/block/block.test', 'block', -5),
('BlockTemplateSuggestionsUnitTest', 'class', 'modules/block/block.test', 'block', -5),
('BlockTestCase', 'class', 'modules/block/block.test', 'block', -5),
('BlogTestCase', 'class', 'modules/blog/blog.test', 'blog', 0),
('ColorTestCase', 'class', 'modules/color/color.test', 'color', 0),
('CommentActionsTestCase', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentAnonymous', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentApprovalTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentBlockFunctionalTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentContentRebuild', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentController', 'class', 'modules/comment/comment.module', 'comment', 0),
('CommentFieldsTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentHelperCase', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentInterfaceTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentNodeAccessTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentPagerTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentPreviewTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentRSSUnitTest', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentThreadingTestCase', 'class', 'modules/comment/comment.test', 'comment', 0),
('CommentTokenReplaceTestCase', 'class', 'modules/comment/comment.test', 'comment', 0),
('ContactPersonalTestCase', 'class', 'modules/contact/contact.test', 'contact', 0),
('ContactSitewideTestCase', 'class', 'modules/contact/contact.test', 'contact', 0),
('ContextualDynamicContextTestCase', 'class', 'modules/contextual/contextual.test', 'contextual', 0),
('CronRunTestCase', 'class', 'modules/system/system.test', 'system', 0),
('DashboardBlocksTestCase', 'class', 'modules/dashboard/dashboard.test', 'dashboard', 0),
('Database', 'class', 'includes/database/database.inc', '', 0),
('DatabaseCondition', 'class', 'includes/database/query.inc', '', 0),
('DatabaseConnection', 'class', 'includes/database/database.inc', '', 0),
('DatabaseConnectionNotDefinedException', 'class', 'includes/database/database.inc', '', 0),
('DatabaseConnection_mysql', 'class', 'includes/database/mysql/database.inc', '', 0),
('DatabaseConnection_pgsql', 'class', 'includes/database/pgsql/database.inc', '', 0),
('DatabaseConnection_sqlite', 'class', 'includes/database/sqlite/database.inc', '', 0),
('DatabaseDriverNotSpecifiedException', 'class', 'includes/database/database.inc', '', 0),
('DatabaseLog', 'class', 'includes/database/log.inc', '', 0),
('DatabaseSchema', 'class', 'includes/database/schema.inc', '', 0),
('DatabaseSchemaObjectDoesNotExistException', 'class', 'includes/database/schema.inc', '', 0),
('DatabaseSchemaObjectExistsException', 'class', 'includes/database/schema.inc', '', 0),
('DatabaseSchema_mysql', 'class', 'includes/database/mysql/schema.inc', '', 0),
('DatabaseSchema_pgsql', 'class', 'includes/database/pgsql/schema.inc', '', 0),
('DatabaseSchema_sqlite', 'class', 'includes/database/sqlite/schema.inc', '', 0),
('DatabaseStatementBase', 'class', 'includes/database/database.inc', '', 0),
('DatabaseStatementEmpty', 'class', 'includes/database/database.inc', '', 0),
('DatabaseStatementInterface', 'interface', 'includes/database/database.inc', '', 0),
('DatabaseStatementPrefetch', 'class', 'includes/database/prefetch.inc', '', 0),
('DatabaseStatement_sqlite', 'class', 'includes/database/sqlite/database.inc', '', 0),
('DatabaseTaskException', 'class', 'includes/install.inc', '', 0),
('DatabaseTasks', 'class', 'includes/install.inc', '', 0),
('DatabaseTasks_mysql', 'class', 'includes/database/mysql/install.inc', '', 0),
('DatabaseTasks_pgsql', 'class', 'includes/database/pgsql/install.inc', '', 0),
('DatabaseTasks_sqlite', 'class', 'includes/database/sqlite/install.inc', '', 0),
('DatabaseTransaction', 'class', 'includes/database/database.inc', '', 0),
('DatabaseTransactionCommitFailedException', 'class', 'includes/database/database.inc', '', 0),
('DatabaseTransactionExplicitCommitNotAllowedException', 'class', 'includes/database/database.inc', '', 0),
('DatabaseTransactionNameNonUniqueException', 'class', 'includes/database/database.inc', '', 0),
('DatabaseTransactionNoActiveException', 'class', 'includes/database/database.inc', '', 0),
('DatabaseTransactionOutOfOrderException', 'class', 'includes/database/database.inc', '', 0),
('DateTimeFunctionalTest', 'class', 'modules/system/system.test', 'system', 0),
('DBLogTestCase', 'class', 'modules/dblog/dblog.test', 'dblog', 0),
('DefaultMailSystem', 'class', 'modules/system/system.mail.inc', 'system', 0),
('DeleteQuery', 'class', 'includes/database/query.inc', '', 0),
('DeleteQuery_sqlite', 'class', 'includes/database/sqlite/query.inc', '', 0),
('DrupalCacheArray', 'class', 'includes/bootstrap.inc', '', 0),
('DrupalCacheInterface', 'interface', 'includes/cache.inc', '', 0),
('DrupalDatabaseCache', 'class', 'includes/cache.inc', '', 0),
('DrupalDefaultEntityController', 'class', 'includes/entity.inc', '', 0),
('DrupalEntityControllerInterface', 'interface', 'includes/entity.inc', '', 0),
('DrupalFakeCache', 'class', 'includes/cache-install.inc', '', 0),
('DrupalLocalStreamWrapper', 'class', 'includes/stream_wrappers.inc', '', 0),
('DrupalPrivateStreamWrapper', 'class', 'includes/stream_wrappers.inc', '', 0),
('DrupalPublicStreamWrapper', 'class', 'includes/stream_wrappers.inc', '', 0),
('DrupalQueue', 'class', 'modules/system/system.queue.inc', 'system', 0),
('DrupalQueueInterface', 'interface', 'modules/system/system.queue.inc', 'system', 0),
('DrupalReliableQueueInterface', 'interface', 'modules/system/system.queue.inc', 'system', 0),
('DrupalStreamWrapperInterface', 'interface', 'includes/stream_wrappers.inc', '', 0),
('DrupalTemporaryStreamWrapper', 'class', 'includes/stream_wrappers.inc', '', 0),
('DrupalUpdateException', 'class', 'includes/update.inc', '', 0),
('DrupalUpdaterInterface', 'interface', 'includes/updater.inc', '', 0),
('EnableDisableTestCase', 'class', 'modules/system/system.test', 'system', 0),
('EntityFieldQuery', 'class', 'includes/entity.inc', '', 0),
('EntityFieldQueryException', 'class', 'includes/entity.inc', '', 0),
('EntityMalformedException', 'class', 'includes/entity.inc', '', 0),
('EntityPropertiesTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldAttachOtherTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldAttachStorageTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldAttachTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldBulkDeleteTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldCrudTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldDisplayAPITestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldException', 'class', 'modules/field/field.module', 'field', 0),
('FieldFormTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldInfoTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldInstanceCrudTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldsOverlapException', 'class', 'includes/database/database.inc', '', 0),
('FieldSqlStorageTestCase', 'class', 'modules/field/modules/field_sql_storage/field_sql_storage.test', 'field_sql_storage', 0),
('FieldTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldTranslationsTestCase', 'class', 'modules/field/tests/field.test', 'field', 0),
('FieldUIAlterTestCase', 'class', 'modules/field_ui/field_ui.test', 'field_ui', 0),
('FieldUIManageDisplayTestCase', 'class', 'modules/field_ui/field_ui.test', 'field_ui', 0),
('FieldUIManageFieldsTestCase', 'class', 'modules/field_ui/field_ui.test', 'field_ui', 0),
('FieldUITestCase', 'class', 'modules/field_ui/field_ui.test', 'field_ui', 0),
('FieldUpdateForbiddenException', 'class', 'modules/field/field.module', 'field', 0),
('FieldValidationException', 'class', 'modules/field/field.attach.inc', 'field', 0),
('FileFieldDisplayTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileFieldPathTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileFieldRevisionTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileFieldTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileFieldValidateTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileFieldWidgetTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileManagedFileElementTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FilePrivateTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileTokenReplaceTestCase', 'class', 'modules/file/tests/file.test', 'file', 0),
('FileTransfer', 'class', 'includes/filetransfer/filetransfer.inc', '', 0),
('FileTransferChmodInterface', 'interface', 'includes/filetransfer/filetransfer.inc', '', 0),
('FileTransferException', 'class', 'includes/filetransfer/filetransfer.inc', '', 0),
('FileTransferFTP', 'class', 'includes/filetransfer/ftp.inc', '', 0),
('FileTransferFTPExtension', 'class', 'includes/filetransfer/ftp.inc', '', 0),
('FileTransferLocal', 'class', 'includes/filetransfer/local.inc', '', 0),
('FileTransferSSH', 'class', 'includes/filetransfer/ssh.inc', '', 0),
('FilterAdminTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterCRUDTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterDefaultFormatTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterFormatAccessTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterHooksTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterNoFormatTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterSecurityTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterSettingsTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FilterUnitTestCase', 'class', 'modules/filter/filter.test', 'filter', 0),
('FloodFunctionalTest', 'class', 'modules/system/system.test', 'system', 0),
('ForumIndexTestCase', 'class', 'modules/forum/forum.test', 'forum', 1),
('ForumTestCase', 'class', 'modules/forum/forum.test', 'forum', 1),
('FrontPageTestCase', 'class', 'modules/system/system.test', 'system', 0),
('HelpTestCase', 'class', 'modules/help/help.test', 'help', 0),
('HookRequirementsTestCase', 'class', 'modules/system/system.test', 'system', 0),
('ImageAdminStylesUnitTest', 'class', 'modules/image/image.test', 'image', 0),
('ImageDimensionsScaleTestCase', 'class', 'modules/image/image.test', 'image', 0),
('ImageDimensionsTestCase', 'class', 'modules/image/image.test', 'image', 0),
('ImageEffectsUnitTest', 'class', 'modules/image/image.test', 'image', 0),
('ImageFieldDefaultImagesTestCase', 'class', 'modules/image/image.test', 'image', 0),
('ImageFieldDisplayTestCase', 'class', 'modules/image/image.test', 'image', 0),
('ImageFieldTestCase', 'class', 'modules/image/image.test', 'image', 0),
('ImageFieldValidateTestCase', 'class', 'modules/image/image.test', 'image', 0),
('ImageStylesPathAndUrlTestCase', 'class', 'modules/image/image.test', 'image', 0),
('InfoFileParserTestCase', 'class', 'modules/system/system.test', 'system', 0),
('InsertQuery', 'class', 'includes/database/query.inc', '', 0),
('InsertQuery_mysql', 'class', 'includes/database/mysql/query.inc', '', 0),
('InsertQuery_pgsql', 'class', 'includes/database/pgsql/query.inc', '', 0),
('InsertQuery_sqlite', 'class', 'includes/database/sqlite/query.inc', '', 0),
('InvalidMergeQueryException', 'class', 'includes/database/database.inc', '', 0),
('IPAddressBlockingTestCase', 'class', 'modules/system/system.test', 'system', 0),
('ListDynamicValuesTestCase', 'class', 'modules/field/modules/list/tests/list.test', 'list', 0),
('ListDynamicValuesValidationTestCase', 'class', 'modules/field/modules/list/tests/list.test', 'list', 0),
('ListFieldTestCase', 'class', 'modules/field/modules/list/tests/list.test', 'list', 0),
('ListFieldUITestCase', 'class', 'modules/field/modules/list/tests/list.test', 'list', 0),
('MailSystemInterface', 'interface', 'includes/mail.inc', '', 0),
('MemoryQueue', 'class', 'modules/system/system.queue.inc', 'system', 0),
('MenuNodeTestCase', 'class', 'modules/menu/menu.test', 'menu', 0),
('MenuTestCase', 'class', 'modules/menu/menu.test', 'menu', 0),
('MergeQuery', 'class', 'includes/database/query.inc', '', 0),
('ModuleDependencyTestCase', 'class', 'modules/system/system.test', 'system', 0),
('ModuleRequiredTestCase', 'class', 'modules/system/system.test', 'system', 0),
('ModuleTestCase', 'class', 'modules/system/system.test', 'system', 0),
('ModuleUpdater', 'class', 'modules/system/system.updater.inc', 'system', 0),
('ModuleVersionTestCase', 'class', 'modules/system/system.test', 'system', 0),
('MultiStepNodeFormBasicOptionsTest', 'class', 'modules/node/node.test', 'node', 0),
('NewDefaultThemeBlocks', 'class', 'modules/block/block.test', 'block', -5),
('NodeAccessBaseTableTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeAccessPagerTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeAccessRebuildTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeAccessRecordsTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeAccessTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeAdminTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeBlockFunctionalTest', 'class', 'modules/node/node.test', 'node', 0),
('NodeBlockTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeBuildContent', 'class', 'modules/node/node.test', 'node', 0),
('NodeController', 'class', 'modules/node/node.module', 'node', 0),
('NodeCreationTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeEntityFieldQueryAlter', 'class', 'modules/node/node.test', 'node', 0),
('NodeFeedTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeLoadHooksTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeLoadMultipleTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodePostSettingsTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeQueryAlter', 'class', 'modules/node/node.test', 'node', 0),
('NodeRevisionPermissionsTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeRevisionsTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeRSSContentTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeSaveTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeTitleTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeTitleXSSTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeTokenReplaceTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeTypePersistenceTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeTypeTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NoFieldsException', 'class', 'includes/database/database.inc', '', 0),
('NoHelpTestCase', 'class', 'modules/help/help.test', 'help', 0),
('NonDefaultBlockAdmin', 'class', 'modules/block/block.test', 'block', -5),
('NumberFieldTestCase', 'class', 'modules/field/modules/number/number.test', 'number', 0),
('OptionsSelectDynamicValuesTestCase', 'class', 'modules/field/modules/options/options.test', 'options', 0),
('OptionsWidgetsTestCase', 'class', 'modules/field/modules/options/options.test', 'options', 0),
('PageEditTestCase', 'class', 'modules/node/node.test', 'node', 0),
('PageNotFoundTestCase', 'class', 'modules/system/system.test', 'system', 0),
('PagePreviewTestCase', 'class', 'modules/node/node.test', 'node', 0),
('PagerDefault', 'class', 'includes/pager.inc', '', 0),
('PageTitleFiltering', 'class', 'modules/system/system.test', 'system', 0),
('PageViewTestCase', 'class', 'modules/node/node.test', 'node', 0),
('PathLanguageTestCase', 'class', 'modules/path/path.test', 'path', 0),
('PathLanguageUITestCase', 'class', 'modules/path/path.test', 'path', 0),
('PathMonolingualTestCase', 'class', 'modules/path/path.test', 'path', 0),
('PathTaxonomyTermTestCase', 'class', 'modules/path/path.test', 'path', 0),
('PathTestCase', 'class', 'modules/path/path.test', 'path', 0),
('PHPAccessTestCase', 'class', 'modules/php/php.test', 'php', 0),
('PHPFilterTestCase', 'class', 'modules/php/php.test', 'php', 0),
('PHPTestCase', 'class', 'modules/php/php.test', 'php', 0),
('Query', 'class', 'includes/database/query.inc', '', 0),
('QueryAlterableInterface', 'interface', 'includes/database/query.inc', '', 0),
('QueryConditionInterface', 'interface', 'includes/database/query.inc', '', 0),
('QueryExtendableInterface', 'interface', 'includes/database/select.inc', '', 0),
('QueryPlaceholderInterface', 'interface', 'includes/database/query.inc', '', 0),
('QueueTestCase', 'class', 'modules/system/system.test', 'system', 0),
('RdfCommentAttributesTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RdfCrudTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RdfGetRdfNamespacesTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RdfMappingDefinitionTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RdfMappingHookTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RdfRdfaMarkupTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RdfTrackerAttributesTestCase', 'class', 'modules/rdf/rdf.test', 'rdf', 0),
('RetrieveFileTestCase', 'class', 'modules/system/system.test', 'system', 0),
('SchemaCache', 'class', 'includes/bootstrap.inc', '', 0),
('SearchAdvancedSearchForm', 'class', 'modules/search/search.test', 'search', 0),
('SearchBlockTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchCommentCountToggleTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchCommentTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchConfigSettingsForm', 'class', 'modules/search/search.test', 'search', 0),
('SearchEmbedForm', 'class', 'modules/search/search.test', 'search', 0),
('SearchExactTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchExcerptTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchExpressionInsertExtractTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchKeywordsConditions', 'class', 'modules/search/search.test', 'search', 0),
('SearchLanguageTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchMatchTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchNodeAccessTest', 'class', 'modules/search/search.test', 'search', 0),
('SearchNumberMatchingTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchNumbersTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchPageOverride', 'class', 'modules/search/search.test', 'search', 0),
('SearchPageText', 'class', 'modules/search/search.test', 'search', 0),
('SearchQuery', 'class', 'modules/search/search.extender.inc', 'search', 0),
('SearchRankingTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchSimplifyTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SearchTokenizerTestCase', 'class', 'modules/search/search.test', 'search', 0),
('SelectQuery', 'class', 'includes/database/select.inc', '', 0),
('SelectQueryExtender', 'class', 'includes/database/select.inc', '', 0),
('SelectQueryInterface', 'interface', 'includes/database/select.inc', '', 0),
('SelectQuery_pgsql', 'class', 'includes/database/pgsql/select.inc', '', 0),
('SelectQuery_sqlite', 'class', 'includes/database/sqlite/select.inc', '', 0),
('ShortcutLinksTestCase', 'class', 'modules/shortcut/shortcut.test', 'shortcut', 0),
('ShortcutSetsTestCase', 'class', 'modules/shortcut/shortcut.test', 'shortcut', 0),
('ShortcutTestCase', 'class', 'modules/shortcut/shortcut.test', 'shortcut', 0),
('ShutdownFunctionsTest', 'class', 'modules/system/system.test', 'system', 0),
('SiteMaintenanceTestCase', 'class', 'modules/system/system.test', 'system', 0),
('SkipDotsRecursiveDirectoryIterator', 'class', 'includes/filetransfer/filetransfer.inc', '', 0),
('StreamWrapperInterface', 'interface', 'includes/stream_wrappers.inc', '', 0),
('SummaryLengthTestCase', 'class', 'modules/node/node.test', 'node', 0),
('SystemAdminTestCase', 'class', 'modules/system/system.test', 'system', 0),
('SystemAuthorizeCase', 'class', 'modules/system/system.test', 'system', 0),
('SystemBlockTestCase', 'class', 'modules/system/system.test', 'system', 0),
('SystemIndexPhpTest', 'class', 'modules/system/system.test', 'system', 0),
('SystemInfoAlterTestCase', 'class', 'modules/system/system.test', 'system', 0),
('SystemMainContentFallback', 'class', 'modules/system/system.test', 'system', 0),
('SystemQueue', 'class', 'modules/system/system.queue.inc', 'system', 0),
('SystemThemeFunctionalTest', 'class', 'modules/system/system.test', 'system', 0),
('TableSort', 'class', 'includes/tablesort.inc', '', 0),
('TaxonomyHooksTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyLegacyTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyLoadMultipleTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyRSSTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyTermController', 'class', 'modules/taxonomy/taxonomy.module', 'taxonomy', 0),
('TaxonomyTermFieldMultipleVocabularyTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyTermFieldTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyTermFunctionTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyTermIndexTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyTermTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyThemeTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyTokenReplaceTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyVocabularyController', 'class', 'modules/taxonomy/taxonomy.module', 'taxonomy', 0),
('TaxonomyVocabularyFunctionalTest', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyVocabularyTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TaxonomyWebTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('TestingMailSystem', 'class', 'modules/system/system.mail.inc', 'system', 0),
('TextFieldTestCase', 'class', 'modules/field/modules/text/text.test', 'text', 0),
('TextSummaryTestCase', 'class', 'modules/field/modules/text/text.test', 'text', 0),
('TextTranslationTestCase', 'class', 'modules/field/modules/text/text.test', 'text', 0),
('ThemeRegistry', 'class', 'includes/theme.inc', '', 0),
('ThemeUpdater', 'class', 'modules/system/system.updater.inc', 'system', 0),
('TokenReplaceTestCase', 'class', 'modules/system/system.test', 'system', 0),
('TruncateQuery', 'class', 'includes/database/query.inc', '', 0),
('TruncateQuery_mysql', 'class', 'includes/database/mysql/query.inc', '', 0),
('TruncateQuery_sqlite', 'class', 'includes/database/sqlite/query.inc', '', 0),
('UpdateCoreTestCase', 'class', 'modules/update/update.test', 'update', 0),
('UpdateCoreUnitTestCase', 'class', 'modules/update/update.test', 'update', 0),
('UpdateQuery', 'class', 'includes/database/query.inc', '', 0),
('UpdateQuery_pgsql', 'class', 'includes/database/pgsql/query.inc', '', 0),
('UpdateQuery_sqlite', 'class', 'includes/database/sqlite/query.inc', '', 0),
('Updater', 'class', 'includes/updater.inc', '', 0),
('UpdaterException', 'class', 'includes/updater.inc', '', 0),
('UpdaterFileTransferException', 'class', 'includes/updater.inc', '', 0),
('UpdateScriptFunctionalTest', 'class', 'modules/system/system.test', 'system', 0),
('UpdateTestContribCase', 'class', 'modules/update/update.test', 'update', 0),
('UpdateTestHelper', 'class', 'modules/update/update.test', 'update', 0),
('UpdateTestUploadCase', 'class', 'modules/update/update.test', 'update', 0),
('UserAccountLinksUnitTests', 'class', 'modules/user/user.test', 'user', 0),
('UserAdminTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserAuthmapAssignmentTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserAutocompleteTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserBlocksUnitTests', 'class', 'modules/user/user.test', 'user', 0),
('UserCancelTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserController', 'class', 'modules/user/user.module', 'user', 0),
('UserCreateTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserEditedOwnAccountTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserEditTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserLoginTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserPermissionsTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserPictureTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserRegistrationTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserRoleAdminTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserRolesAssignmentTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserSaveTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserSignatureTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserTimeZoneFunctionalTest', 'class', 'modules/user/user.test', 'user', 0),
('UserTokenReplaceTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserUserSearchTestCase', 'class', 'modules/user/user.test', 'user', 0),
('UserValidateCurrentPassCustomForm', 'class', 'modules/user/user.test', 'user', 0),
('UserValidationTestCase', 'class', 'modules/user/user.test', 'user', 0),
('CommentNodeChangesTestCase', 'class', 'modules/comment/comment.test', 'comment', 0),
('ImageThemeFunctionWebTestCase', 'class', 'modules/image/image.test', 'image', 0),
('NodeWebTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeAccessFieldTestCase', 'class', 'modules/node/node.test', 'node', 0),
('NodeEntityViewModeAlterTest', 'class', 'modules/node/node.test', 'node', 0),
('TaxonomyEFQTestCase', 'class', 'modules/taxonomy/taxonomy.test', 'taxonomy', 0),
('UserPasswordResetTestCase', 'class', 'modules/user/user.test', 'user', 0),
('LibrariesUnitTestCase', 'class', 'sites/all/modules/libraries/tests/libraries.test', 'libraries', 0),
('LibrariesTestCase', 'class', 'sites/all/modules/libraries/tests/libraries.test', 'libraries', 0),
('FieldInfo', 'class', 'modules/field/field.info.class.inc', 'field', 0),
('TokenScanTest', 'class', 'modules/system/system.test', 'system', 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `registry_file`
--

CREATE TABLE IF NOT EXISTS `registry_file` (
  `filename` varchar(255) NOT NULL COMMENT 'Path to the file.',
  `hash` varchar(64) NOT NULL COMMENT 'sha-256 hash of the file’s contents when last parsed.',
  PRIMARY KEY (`filename`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Files parsed to build the registry.';

--
-- Άδειασμα δεδομένων του πίνακα `registry_file`
--

INSERT INTO `registry_file` (`filename`, `hash`) VALUES
('includes/actions.inc', 'f36b066681463c7dfe189e0430cb1a89bf66f7e228cbb53cdfcd93987193f759'),
('includes/ajax.inc', '8328ec7441a0c101c1b39ba8d415c1d951b400887d8b29d2831210ae207f86eb'),
('includes/archiver.inc', 'bdbb21b712a62f6b913590b609fd17cd9f3c3b77c0d21f68e71a78427ed2e3e9'),
('includes/authorize.inc', '6d64d8c21aa01eb12fc29918732e4df6b871ed06e5d41373cb95c197ed661d13'),
('includes/batch.inc', '059da9e36e1f3717f27840aae73f10dea7d6c8daf16f6520401cc1ca3b4c0388'),
('includes/batch.queue.inc', '554b2e92e1dad0f7fd5a19cb8dff7e109f10fbe2441a5692d076338ec908de0f'),
('includes/bootstrap.inc', '08aa17d5148732c6294ad95c3ff1ecf223199cde61439ec5fdb1ca778e971c96'),
('includes/cache-install.inc', 'e7ed123c5805703c84ad2cce9c1ca46b3ce8caeeea0d8ef39a3024a4ab95fa0e'),
('includes/cache.inc', 'c9d3df7ff9807bb4421d66b4579c2ef5ca4d74954a8184bd04881d179f22ccb2'),
('includes/common.inc', 'db5346629b64f46f3a89738fd688d6a8e9ba847edfbd14319a4d63c4bcdb7130'),
('includes/database/database.inc', '1597142a1fbd6fcff24f2bb92805a1c98b7bc36520cc68007bc7383effcaf890'),
('includes/database/log.inc', '9feb5a17ae2fabcf26a96d2a634ba73da501f7bcfc3599a693d916a6971d00d1'),
('includes/database/mysql/database.inc', '8d3a784845064385ccdce8a66860f3177d52207df83d9735c0d72c9703dd258e'),
('includes/database/mysql/install.inc', '6ae316941f771732fbbabed7e1d6b4cbb41b1f429dd097d04b3345aa15e461a0'),
('includes/database/mysql/query.inc', '7d9ea18a7ff04b7aab6210abbd0313cb53325c19a47ff8ed6c0e591c6e7149c2'),
('includes/database/mysql/schema.inc', 'd8d3904ea9c23a526c2f2a7acc8ba870b31c378aac2eb53e2e41a73c6209c5bd'),
('includes/database/pgsql/database.inc', '56726100fd44f461a04886c590c9c472cc2b2a1b92eb26c7674bf3821a76bb64'),
('includes/database/pgsql/install.inc', '585b80c5bbd6f134bff60d06397f15154657a577d4da8d1b181858905f09dea5'),
('includes/database/pgsql/query.inc', 'cb4c84f8f1ffc73098ed71137248dcd078a505a7530e60d979d74b3a3cdaa658'),
('includes/database/pgsql/schema.inc', '8fd647e4557522283caef63e528c6e403fc0751a46e94aac867a281af85eac27'),
('includes/database/pgsql/select.inc', 'fd4bba7887c1dc6abc8f080fc3a76c01d92ea085434e355dc1ecb50d8743c22d'),
('includes/database/prefetch.inc', 'b5b207a66a69ecb52ee4f4459af16a7b5eabedc87254245f37cc33bebb61c0fb'),
('includes/database/query.inc', 'dad26c5d42eda178f8a858194a912fe5df2b7091bd038b23af26aee249166c76'),
('includes/database/schema.inc', '7eb7251f331109757173353263d1031493c1198ae17a165a6f5a03d3f14f93e7'),
('includes/database/select.inc', '1c74fa55c7721a704f5ef3389032604bf7a60fced15c40d844aee3e1cead7dc6'),
('includes/database/sqlite/database.inc', 'ed2b9981794239cdad2cd04cf4bcdc896ad4d6b66179a4fa487b0d1ec2150a10'),
('includes/database/sqlite/install.inc', '381f3db8c59837d961978ba3097bb6443534ed1659fd713aa563963fa0c42cc5'),
('includes/database/sqlite/query.inc', 'cd726af682495d8fe20283ddbc4d877536cad2df4a2df8afc2dc21be71a4eba8'),
('includes/database/sqlite/schema.inc', '238414785aa96dd27f10f48c961783f4d1091392beee8d0e7ca8ae774e917da2'),
('includes/database/sqlite/select.inc', '8d1c426dbd337733c206cce9f59a172546c6ed856d8ef3f1c7bef05a16f7bf68'),
('includes/date.inc', '18c047be64f201e16d189f1cc47ed9dcf0a145151b1ee187e90511b24e5d2b36'),
('includes/entity.inc', '93ed9b3f29fb2a75852af3b4cf03ce0edf3e9eddf19e4b82eeba8659d3d5bc78'),
('includes/errors.inc', '0923cf3303e0e976756d159c80c86bbe039109bd90a35a9aca18027c68abd0aa'),
('includes/file.inc', '4eeef6f486c843ff91e5eaa5ee435e66d89dd516c76b980c79d3c6595fe6bf2d'),
('includes/file.mimetypes.inc', 'f88c967550576694b7a1ce2afd0f2f1bbc1a91d21cc2c20f86c44d39ff353867'),
('includes/filetransfer/filetransfer.inc', 'fdea8ae48345ec91885ac48a9bc53daf87616271472bb7c29b7e3ce219b22034'),
('includes/filetransfer/ftp.inc', '589ebf4b8bd4a2973aa56a156ac1fa83b6c73e703391361fb573167670e0d832'),
('includes/filetransfer/local.inc', '7cbfdb46abbdf539640db27e66fb30e5265128f31002bd0dfc3af16ae01a9492'),
('includes/filetransfer/ssh.inc', '002e24a24cac133d12728bd3843868ce378681237d7fad420761af84e6efe5ad'),
('includes/form.inc', '5ab6ebd03a6852acd532fb3e06ce4d90c983246ba1f9506437fa19566729893d'),
('includes/graph.inc', '8e0e313a8bb33488f371df11fc1b58d7cf80099b886cd1003871e2c896d1b536'),
('includes/image.inc', 'bcdc7e1599c02227502b9d0fe36eeb2b529b130a392bc709eb737647bd361826'),
('includes/install.core.inc', '2a036b695c555d7339115099e0b7b06bf7fbafbaad6d7cc143e49969ff96c394'),
('includes/install.inc', 'f4e81c6b55769e0b5cc66565ade31d1f805faf11f73ca605bd3506a78ec1b7ee'),
('includes/iso.inc', '27730e6175b79c3b5d494582a124f6210289faa03bef099e16347bb914464c66'),
('includes/json-encode.inc', '02a822a652d00151f79db9aa9e171c310b69b93a12f549bc2ce00533a8efa14e'),
('includes/language.inc', '77ef0c210a8f01d4ad24b13b147db3db0dcef801dbae8b644124cedd562a8a57'),
('includes/locale.inc', '8cc571c114587f2b30e4e24db17e97e51e81f9cc395fa01f348aba12cee8523e'),
('includes/lock.inc', 'daa62e95528f6b986b85680b600a896452bf2ce6f38921242857dcc5a3460a1b'),
('includes/mail.inc', '8b37b30d82941010eacf8f435abbf9cb5b6cfc2710c3446a5037192ae14d68bf'),
('includes/menu.inc', '1b6ad3883f405b887032d8b2e58e6e3870a37f6963854275e0c0d9e1b12a624c'),
('includes/module.inc', '09dd0e483fd1c5569183ff0663543163d5262ec5eb9c4551c2214fd7599f386b'),
('includes/pager.inc', '6f9494b85c07a2cc3be4e54aff2d2757485238c476a7da084d25bde1d88be6d8'),
('includes/password.inc', '7550ac434a929562a3380e82c546afbf9163598b22f2351f0e7d3f19567fb6c9'),
('includes/path.inc', 'd20d3efabcb752fcafafc887fc0f09704d87000742302f95cf58e62333d05279'),
('includes/registry.inc', '4ffb8c9c8c179c1417ff01790f339edf50b5f7cc0c8bb976eef6858cc71e9bc8'),
('includes/session.inc', '65764101f3746e25210e8a91a9c058218c83c7bf444051ba339c412a2d2bff63'),
('includes/stream_wrappers.inc', 'b04e31585a9a397b0edf7b3586050cbd4b1f631e283296e1c93f4356662faeb9'),
('includes/tablesort.inc', '4cb2a5a2d41b2a204a13f59085096e3f64237d32639ea5d30752905099bc7540'),
('includes/theme.inc', 'f1a3045e917b454f23842e048f8753c7dc1e97bf8999bb8eeb4f72cee3cc7553'),
('includes/theme.maintenance.inc', '39f068b3eee4d10a90d6aa3c86db587b6d25844c2919d418d34d133cfe330f5a'),
('includes/token.inc', '5e7898cd78689e2c291ed3cd8f41c032075656896f1db57e49217aac19ae0428'),
('includes/unicode.entities.inc', '2b858138596d961fbaa4c6e3986e409921df7f76b6ee1b109c4af5970f1e0f54'),
('includes/unicode.inc', '518ad21bd4f43814277d67f76ff8eb2b99bd1be4caa5e02b6e5f06cf65d84eb0'),
('includes/update.inc', '177ce24362efc7f28b384c90a09c3e485396bbd18c3721d4b21e57dd1733bd92'),
('includes/updater.inc', 'd2da0e74ed86e93c209f16069f3d32e1a134ceb6c06a0044f78e841a1b54e380'),
('includes/utility.inc', '3458fd2b55ab004dd0cc529b8e58af12916e8bd36653b072bdd820b26b907ed5'),
('includes/xmlrpc.inc', 'c5b6ea78adeb135373d11aeaaea057d9fa8995faa4e8c0fec9b7c647f15cc4e0'),
('includes/xmlrpcs.inc', '79dc6e9882f4c506123d7dd8e228a61e22c46979c3aab21a5b1afa315ef6639c'),
('modules/block/block.test', '7aefd627d62b44f9c1e9ee3aa9da6c6e2a7cfce01c6613e8bd24c0b9c464dd73'),
('modules/blog/blog.test', '12dc3105782db5fb0df00ff4872561dd049f242eeeb65c979cf349aa75aa1a51'),
('modules/color/color.test', '013806279bd47ceb2f82ca854b57f880ba21058f7a2592c422afae881a7f5d15'),
('modules/comment/comment.module', 'f7d4b93359bf3d6381204a0f63e6574ece4f45656d53d126f04067891d1d64b1'),
('modules/comment/comment.test', '5404277c15b1306a1ad5eca6703f7d2003567fea6085ffd2b1c3d65896acdf21'),
('modules/contact/contact.test', '6ad6e1585fef729036e64b58db83be22d09e2df41117036f3969e698533a4a7e'),
('modules/contextual/contextual.test', '023dafa199bd325ecc55a17b2a3db46ac0a31e23059f701f789f3bc42427ba0b'),
('modules/dashboard/dashboard.test', '270378b5c8ed0e7d0e00fbc62e617813c6dec1d79396229786942bf9fb738e16'),
('modules/dblog/dblog.test', '6f5da69432a186df5086f9a588c9c18ad85bb3034bccc3860423d9e854c0d864'),
('modules/field/field.attach.inc', '25d05fb8ab30ba559051ca2034ea7e61bd1326cacb12dfeb865e90e2ffd147e6'),
('modules/field/field.module', 'd2d9b9b324c256ca11e117f84afd9722c5271887a57497e2dd1f339adae7c12d'),
('modules/field/modules/field_sql_storage/field_sql_storage.test', '8ede9843d771e307dfd3d7e7562976b07e0e0a9310a5cf409413581f199c897f'),
('modules/field/modules/list/tests/list.test', '9f366469763beb3fe0571d66318bac6df293fd15f4eb5cfe4850b9fb9a509f38'),
('modules/field/modules/number/number.test', 'cb55fbc3a1ceed154af673af727b4c5ee6ac2e7dc9d4e1cbc33f3f8e2269146c'),
('modules/field/modules/options/options.test', '8c6dd464fdb5cca90b0260bcfa5f56941b4b28edd879b23a795f0442f5368d4c'),
('modules/field/modules/text/text.test', '9d74c6d039f55dd7d6447a59186da8d48bf20617bfe58424612798f649797586'),
('modules/field/tests/field.test', 'f07f370dee1b3bf645c548a4542007b4653bf6a40f28888e180cbc408e62c569'),
('modules/field_ui/field_ui.test', '2c344c7ccd9d41156f3e4a16f1cad06d2c3f4d702b47452bf6f5260efe2abbeb'),
('modules/file/tests/file.test', '802532f0032f1740592379d7bd9c93f8c453f68b93f11bf0143bd5de648659c8'),
('modules/filter/filter.test', '50f74d9c07663cbf610559f7123709488c36dab18e4320635ca4bcf9a9891640'),
('modules/forum/forum.test', 'b8ba9ca5d40c153ba730a12d3573242572fd5a432b49b31a74a0cdbac911786b'),
('modules/help/help.test', 'c6f03ece30548a6a345afcfac920d85afc418596a19dc4cf43f994391c5050d9'),
('modules/image/image.test', '03ab83fcfd3c0f8397ea2273847a13bb5661efd4fc68af55f85bb32e41f37dc3'),
('modules/menu/menu.test', 'b93a1f408a1b51563c4c761475366573fc481d4ace3496fce226a73bdf468e8c'),
('modules/node/node.module', '72f72261cac4ca7880f4384791d7aee1e40491a0c1978946c3fa4d3bb64a9433'),
('modules/node/node.test', '4757ff01c1209a86393a2370234f0af3fc708d50b5a012e7eb9763336bc747bf'),
('modules/path/path.test', 'c05b26db575e93a73f2e4c8eaa6091b4fe8fc805f59620c2f7e1276cc206ba9d'),
('modules/php/php.test', '009f628f14137eb137d46c97e0ddef7a0c426707a7b4616c00c6d9446638f243'),
('modules/rdf/rdf.test', 'd586b165925f65c98adcc0ad1eb24b05e2803ea92f1acca351b3ce2dc8932f43'),
('modules/search/search.extender.inc', 'fea036745113dca3fea52ba956af605c4789f4acfa2ab1650a5843c6e173d7fe'),
('modules/search/search.test', '1fe9dfc982953f42f67d7eee9a855e7248373067ba55cfff001d8a750b83e695'),
('modules/shortcut/shortcut.test', '9d0f81602c9a58b60ad3ae4b996e5a431016014151540769e9594711232575e4'),
('modules/system/system.archiver.inc', 'faa849f3e646a910ab82fd6c8bbf0a4e6b8c60725d7ba81ec0556bd716616cd1'),
('modules/system/system.mail.inc', '3c2c06b55bded609e72add89db41af3bb405d42b9553793acba5fe51be8861d8'),
('modules/system/system.queue.inc', 'caf4feda51bdf7ad62cf782bc23274d367154e51897f2732f07bd06982d85ab1'),
('modules/system/system.tar.inc', '8a31d91f7b3cd7eac25b3fa46e1ed9a8527c39718ba76c3f8c0bbbeaa3aa4086'),
('modules/system/system.test', '1577ba238919ba208902f807cd35ef667616a064ecf2b611b0ccb39cba105450'),
('modules/system/system.updater.inc', '338cf14cb691ba16ee551b3b9e0fa4f579a2f25c964130658236726d17563b6a'),
('modules/taxonomy/taxonomy.module', '389f4e8e040e99c02b4795983e7b44ffb00e766d2a4b3fa06aca98621073f6b2'),
('modules/taxonomy/taxonomy.test', '2b1599532f0b6bd0e324b55b687fe9eac9c6465376fd8317652e7540ee0a3677'),
('modules/update/update.test', 'f0c11dfc51716e9dd5980428a416cdead4246435e1dceaff75ce52c5f381d617'),
('modules/user/user.module', '40a0d8e89d4de14cee5283a21eb541c0143ab86170a093cfc6ecf15c9fe534ea'),
('modules/user/user.test', '0cdf12305cce4a65da5be1155925ba2a83b6f5363d6c192f0cfec2985e835e20'),
('sites/all/modules/libraries/tests/libraries.test', '6dccb7969e83afd82de3c83af5e0b06c1f27e35ab1069f5f669640eed6d5d4af'),
('modules/field/field.info.class.inc', 'c2e4bc67ef51e4956c913be772914b1b2625aa5066ab67c74baf6404ed538174');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `role`
--

CREATE TABLE IF NOT EXISTS `role` (
  `rid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique role ID.',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'Unique role name.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this role in listings and the user interface.',
  PRIMARY KEY (`rid`),
  UNIQUE KEY `name` (`name`),
  KEY `name_weight` (`name`,`weight`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores user roles.' AUTO_INCREMENT=4 ;

--
-- Άδειασμα δεδομένων του πίνακα `role`
--

INSERT INTO `role` (`rid`, `name`, `weight`) VALUES
(3, 'administrator', 2),
(1, 'anonymous user', 0),
(2, 'authenticated user', 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `role_permission`
--

CREATE TABLE IF NOT EXISTS `role_permission` (
  `rid` int(10) unsigned NOT NULL COMMENT 'Foreign Key: role.rid.',
  `permission` varchar(128) NOT NULL DEFAULT '' COMMENT 'A single permission granted to the role identified by rid.',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'The module declaring the permission.',
  PRIMARY KEY (`rid`,`permission`),
  KEY `permission` (`permission`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores the permissions assigned to user roles.';

--
-- Άδειασμα δεδομένων του πίνακα `role_permission`
--

INSERT INTO `role_permission` (`rid`, `permission`, `module`) VALUES
(1, 'access comments', 'comment'),
(1, 'access content', 'node'),
(1, 'access site-wide contact form', 'contact'),
(1, 'use text format filtered_html', 'filter'),
(2, 'access comments', 'comment'),
(2, 'access content', 'node'),
(2, 'post comments', 'comment'),
(2, 'skip comment approval', 'comment'),
(2, 'use text format filtered_html', 'filter'),
(3, 'access administration pages', 'system'),
(3, 'access comments', 'comment'),
(3, 'access content', 'node'),
(3, 'access content overview', 'node'),
(3, 'access contextual links', 'contextual'),
(3, 'access dashboard', 'dashboard'),
(3, 'access overlay', 'overlay'),
(3, 'access site in maintenance mode', 'system'),
(3, 'access site reports', 'system'),
(3, 'access site-wide contact form', 'contact'),
(3, 'access toolbar', 'toolbar'),
(3, 'access user contact forms', 'contact'),
(3, 'access user profiles', 'user'),
(3, 'administer actions', 'system'),
(3, 'administer blocks', 'block'),
(3, 'administer comments', 'comment'),
(3, 'administer contact forms', 'contact'),
(3, 'administer content types', 'node'),
(3, 'administer filters', 'filter'),
(3, 'administer forums', 'forum'),
(3, 'administer image styles', 'image'),
(3, 'administer menu', 'menu'),
(3, 'administer modules', 'system'),
(3, 'administer nodes', 'node'),
(3, 'administer permissions', 'user'),
(3, 'administer search', 'search'),
(3, 'administer shortcuts', 'shortcut'),
(3, 'administer site configuration', 'system'),
(3, 'administer software updates', 'system'),
(3, 'administer taxonomy', 'taxonomy'),
(3, 'administer themes', 'system'),
(3, 'administer url aliases', 'path'),
(3, 'administer users', 'user'),
(3, 'block IP addresses', 'system'),
(3, 'bypass node access', 'node'),
(3, 'cancel account', 'user'),
(3, 'change own username', 'user'),
(3, 'create article content', 'node'),
(3, 'create page content', 'node'),
(3, 'create url aliases', 'path'),
(3, 'customize shortcut links', 'shortcut'),
(3, 'delete any article content', 'node'),
(3, 'delete any page content', 'node'),
(3, 'delete own article content', 'node'),
(3, 'delete own page content', 'node'),
(3, 'delete revisions', 'node'),
(3, 'delete terms in 1', 'taxonomy'),
(3, 'edit any article content', 'node'),
(3, 'edit any page content', 'node'),
(3, 'edit own article content', 'node'),
(3, 'edit own comments', 'comment'),
(3, 'edit own page content', 'node'),
(3, 'edit terms in 1', 'taxonomy'),
(3, 'post comments', 'comment'),
(3, 'revert revisions', 'node'),
(3, 'search content', 'search'),
(3, 'select account cancellation method', 'user'),
(3, 'skip comment approval', 'comment'),
(3, 'switch shortcut sets', 'shortcut'),
(3, 'use advanced search', 'search'),
(3, 'use PHP for settings', 'php'),
(3, 'use text format filtered_html', 'filter'),
(3, 'use text format full_html', 'filter'),
(3, 'view own unpublished content', 'node'),
(3, 'view revisions', 'node'),
(3, 'view the administration theme', 'system'),
(1, 'search content', 'search');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `search_dataset`
--

CREATE TABLE IF NOT EXISTS `search_dataset` (
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Search item ID, e.g. node ID for nodes.',
  `type` varchar(16) NOT NULL COMMENT 'Type of item, e.g. node.',
  `data` longtext NOT NULL COMMENT 'List of space-separated words from the item.',
  `reindex` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Set to force node reindexing.',
  PRIMARY KEY (`sid`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores items that will be searched.';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `search_index`
--

CREATE TABLE IF NOT EXISTS `search_index` (
  `word` varchar(50) NOT NULL DEFAULT '' COMMENT 'The search_total.word that is associated with the search item.',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The search_dataset.sid of the searchable item to which the word belongs.',
  `type` varchar(16) NOT NULL COMMENT 'The search_dataset.type of the searchable item to which the word belongs.',
  `score` float DEFAULT NULL COMMENT 'The numeric score of the word, higher being more important.',
  PRIMARY KEY (`word`,`sid`,`type`),
  KEY `sid_type` (`sid`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores the search index, associating words, items and...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `search_node_links`
--

CREATE TABLE IF NOT EXISTS `search_node_links` (
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The search_dataset.sid of the searchable item containing the link to the node.',
  `type` varchar(16) NOT NULL DEFAULT '' COMMENT 'The search_dataset.type of the searchable item containing the link to the node.',
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid that this item links to.',
  `caption` longtext COMMENT 'The text used to link to the node.nid.',
  PRIMARY KEY (`sid`,`type`,`nid`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores items (like nodes) that link to other nodes, used...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `search_total`
--

CREATE TABLE IF NOT EXISTS `search_total` (
  `word` varchar(50) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique word in the search index.',
  `count` float DEFAULT NULL COMMENT 'The count of the word in the index using Zipf’s law to equalize the probability distribution.',
  PRIMARY KEY (`word`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores search totals for words.';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `semaphore`
--

CREATE TABLE IF NOT EXISTS `semaphore` (
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique name.',
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT 'A value for the semaphore.',
  `expire` double NOT NULL COMMENT 'A Unix timestamp with microseconds indicating when the semaphore should expire.',
  PRIMARY KEY (`name`),
  KEY `value` (`value`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Table for holding semaphores, locks, flags, etc. that...';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `sequences`
--

CREATE TABLE IF NOT EXISTS `sequences` (
  `value` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The value of the sequence.',
  PRIMARY KEY (`value`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores IDs.' AUTO_INCREMENT=13 ;

--
-- Άδειασμα δεδομένων του πίνακα `sequences`
--

INSERT INTO `sequences` (`value`) VALUES
(12);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `uid` int(10) unsigned NOT NULL COMMENT 'The users.uid corresponding to a session, or 0 for anonymous user.',
  `sid` varchar(128) NOT NULL COMMENT 'A session ID. The value is generated by Drupal’s session handlers.',
  `ssid` varchar(128) NOT NULL DEFAULT '' COMMENT 'Secure session ID. The value is generated by Drupal’s session handlers.',
  `hostname` varchar(128) NOT NULL DEFAULT '' COMMENT 'The IP address that last used this session ID (sid).',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when this session last requested a page. Old records are purged by PHP automatically.',
  `cache` int(11) NOT NULL DEFAULT '0' COMMENT 'The time of this user’s last post. This is used when the site has specified a minimum_cache_lifetime. See cache_get().',
  `session` longblob COMMENT 'The serialized contents of $_SESSION, an array of name/value pairs that persists across page requests by this session ID. Drupal loads $_SESSION from here at the start of each request and saves it at the end.',
  PRIMARY KEY (`sid`,`ssid`),
  KEY `timestamp` (`timestamp`),
  KEY `uid` (`uid`),
  KEY `ssid` (`ssid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Drupal’s session handlers read and write into the...';

--
-- Άδειασμα δεδομένων του πίνακα `sessions`
--

INSERT INTO `sessions` (`uid`, `sid`, `ssid`, `hostname`, `timestamp`, `cache`, `session`) VALUES
(1, '2v83ArGE5K411nARsZR2tXXt6LDTofvO575Lvyj5v1U', '', '127.0.0.1', 1361028908, 0, 0x63616368655f65787069726174696f6e7c613a323a7b733a31313a2263616368655f626c6f636b223b693a313336313032383930383b733a31303a2263616368655f70616765223b693a313336313032383930383b7d64626c6f675f6f766572766965775f66696c7465727c613a303a7b7d),
(1, 'ZOrVhf1zNRX_oj1oDh9ToZpckcdIYY4tHr682F2ez5g', '', '127.0.0.1', 1364418228, 0, 0x626174636865737c613a313a7b693a31313b623a313b7d64626c6f675f6f766572766965775f66696c7465727c613a303a7b7d),
(1, 'k4UnuMRXFixBoevp8UdSHaYOCij6YaZBzg_8zPvzyTg', '', '127.0.0.1', 1367389314, 0, ''),
(1, '6A9LdqrhiBcIXD49SoJxz2ZpoucFRedVU_ibTxfxErM', '', '127.0.0.1', 1367392719, 0, 0x626174636865737c613a313a7b693a31323b623a313b7d757064617465735f72656d61696e696e677c613a303a7b7d64626c6f675f6f766572766965775f66696c7465727c613a303a7b7d);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `shortcut_set`
--

CREATE TABLE IF NOT EXISTS `shortcut_set` (
  `set_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Primary Key: The menu_links.menu_name under which the set’s links are stored.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of the set.',
  PRIMARY KEY (`set_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores information about sets of shortcuts links.';

--
-- Άδειασμα δεδομένων του πίνακα `shortcut_set`
--

INSERT INTO `shortcut_set` (`set_name`, `title`) VALUES
('shortcut-set-1', 'Default');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `shortcut_set_users`
--

CREATE TABLE IF NOT EXISTS `shortcut_set_users` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The users.uid for this set.',
  `set_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'The shortcut_set.set_name that will be displayed for this user.',
  PRIMARY KEY (`uid`),
  KEY `set_name` (`set_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Maps users to shortcut sets.';

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `system`
--

CREATE TABLE IF NOT EXISTS `system` (
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT 'The path of the primary file for this item, relative to the Drupal root; e.g. modules/node/node.module.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the item; e.g. node.',
  `type` varchar(12) NOT NULL DEFAULT '' COMMENT 'The type of the item, either module, theme, or theme_engine.',
  `owner` varchar(255) NOT NULL DEFAULT '' COMMENT 'A theme’s ’parent’ . Can be either a theme or an engine.',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether or not this item is enabled.',
  `bootstrap` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether this module is loaded during Drupal’s early bootstrapping phase (e.g. even before the page cache is consulted).',
  `schema_version` smallint(6) NOT NULL DEFAULT '-1' COMMENT 'The module’s database schema version number. -1 if the module is not installed (its tables do not exist); 0 or the largest N of the module’s hook_update_N() function that has either been run or existed when the module was first installed.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The order in which this module’s hooks should be invoked relative to other modules. Equal-weighted modules are ordered by name.',
  `info` blob COMMENT 'A serialized array containing information from the module’s .info file; keys can include name, description, package, version, core, dependencies, and php.',
  PRIMARY KEY (`filename`),
  KEY `system_list` (`status`,`bootstrap`,`type`,`weight`,`name`),
  KEY `type_name` (`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='A list of all modules, themes, and theme engines that are...';

--
-- Άδειασμα δεδομένων του πίνακα `system`
--

INSERT INTO `system` (`filename`, `name`, `type`, `owner`, `status`, `bootstrap`, `schema_version`, `weight`, `info`) VALUES
('modules/aggregator/aggregator.module', 'aggregator', 'module', '', 0, 0, -1, 0, 0x613a31333a7b733a343a226e616d65223b733a31303a2241676772656761746f72223b733a31313a226465736372697074696f6e223b733a35373a22416767726567617465732073796e6469636174656420636f6e74656e7420285253532c205244462c20616e642041746f6d206665656473292e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31353a2261676772656761746f722e74657374223b7d733a393a22636f6e666967757265223b733a34313a2261646d696e2f636f6e6669672f73657276696365732f61676772656761746f722f73657474696e6773223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31343a2261676772656761746f722e637373223b733a33333a226d6f64756c65732f61676772656761746f722f61676772656761746f722e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/aggregator/tests/aggregator_test.module', 'aggregator_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32333a2241676772656761746f72206d6f64756c65207465737473223b733a31313a226465736372697074696f6e223b733a34363a22537570706f7274206d6f64756c6520666f722061676772656761746f722072656c617465642074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/block/block.module', 'block', 'module', '', 1, 0, 7008, -5, 0x613a31323a7b733a343a226e616d65223b733a353a22426c6f636b223b733a31313a226465736372697074696f6e223b733a3134303a22436f6e74726f6c73207468652076697375616c206275696c64696e6720626c6f636b732061207061676520697320636f6e737472756374656420776974682e20426c6f636b732061726520626f786573206f6620636f6e74656e742072656e646572656420696e746f20616e20617265612c206f7220726567696f6e2c206f6620612077656220706167652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31303a22626c6f636b2e74657374223b7d733a393a22636f6e666967757265223b733a32313a2261646d696e2f7374727563747572652f626c6f636b223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/block/tests/block_test.module', 'block_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31303a22426c6f636b2074657374223b733a31313a226465736372697074696f6e223b733a32313a2250726f7669646573207465737420626c6f636b732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/blog/blog.module', 'blog', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a343a22426c6f67223b733a31313a226465736372697074696f6e223b733a32353a22456e61626c6573206d756c74692d7573657220626c6f67732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a393a22626c6f672e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/book/book.module', 'book', 'module', '', 0, 0, -1, 0, 0x613a31333a7b733a343a226e616d65223b733a343a22426f6f6b223b733a31313a226465736372697074696f6e223b733a36363a22416c6c6f777320757365727320746f2063726561746520616e64206f7267616e697a652072656c6174656420636f6e74656e7420696e20616e206f75746c696e652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a393a22626f6f6b2e74657374223b7d733a393a22636f6e666967757265223b733a32373a2261646d696e2f636f6e74656e742f626f6f6b2f73657474696e6773223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a383a22626f6f6b2e637373223b733a32313a226d6f64756c65732f626f6f6b2f626f6f6b2e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/color/color.module', 'color', 'module', '', 1, 0, 7001, 0, 0x613a31313a7b733a343a226e616d65223b733a353a22436f6c6f72223b733a31313a226465736372697074696f6e223b733a37303a22416c6c6f77732061646d696e6973747261746f727320746f206368616e67652074686520636f6c6f7220736368656d65206f6620636f6d70617469626c65207468656d65732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31303a22636f6c6f722e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/comment/comment.module', 'comment', 'module', '', 1, 0, 7009, 0, 0x613a31333a7b733a343a226e616d65223b733a373a22436f6d6d656e74223b733a31313a226465736372697074696f6e223b733a35373a22416c6c6f777320757365727320746f20636f6d6d656e74206f6e20616e642064697363757373207075626c697368656420636f6e74656e742e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a343a2274657874223b7d733a353a2266696c6573223b613a323a7b693a303b733a31343a22636f6d6d656e742e6d6f64756c65223b693a313b733a31323a22636f6d6d656e742e74657374223b7d733a393a22636f6e666967757265223b733a32313a2261646d696e2f636f6e74656e742f636f6d6d656e74223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31313a22636f6d6d656e742e637373223b733a32373a226d6f64756c65732f636f6d6d656e742f636f6d6d656e742e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/contact/contact.module', 'contact', 'module', '', 1, 0, 7003, 0, 0x613a31323a7b733a343a226e616d65223b733a373a22436f6e74616374223b733a31313a226465736372697074696f6e223b733a36313a22456e61626c65732074686520757365206f6620626f746820706572736f6e616c20616e6420736974652d7769646520636f6e7461637420666f726d732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31323a22636f6e746163742e74657374223b7d733a393a22636f6e666967757265223b733a32333a2261646d696e2f7374727563747572652f636f6e74616374223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/contextual/contextual.module', 'contextual', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a31363a22436f6e7465787475616c206c696e6b73223b733a31313a226465736372697074696f6e223b733a37353a2250726f766964657320636f6e7465787475616c206c696e6b7320746f20706572666f726d20616374696f6e732072656c6174656420746f20656c656d656e7473206f6e206120706167652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31353a22636f6e7465787475616c2e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/dashboard/dashboard.module', 'dashboard', 'module', '', 1, 0, 0, 0, 0x613a31323a7b733a343a226e616d65223b733a393a2244617368626f617264223b733a31313a226465736372697074696f6e223b733a3133363a2250726f766964657320612064617368626f617264207061676520696e207468652061646d696e69737472617469766520696e7465726661636520666f72206f7267616e697a696e672061646d696e697374726174697665207461736b7320616e6420747261636b696e6720696e666f726d6174696f6e2077697468696e20796f757220736974652e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a353a2266696c6573223b613a313a7b693a303b733a31343a2264617368626f6172642e74657374223b7d733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a22626c6f636b223b7d733a393a22636f6e666967757265223b733a32353a2261646d696e2f64617368626f6172642f637573746f6d697a65223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/dblog/dblog.module', 'dblog', 'module', '', 1, 1, 7002, 0, 0x613a31313a7b733a343a226e616d65223b733a31363a224461746162617365206c6f6767696e67223b733a31313a226465736372697074696f6e223b733a34373a224c6f677320616e64207265636f7264732073797374656d206576656e747320746f207468652064617461626173652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31303a2264626c6f672e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field/field.module', 'field', 'module', '', 1, 0, 7003, 0, 0x613a31333a7b733a343a226e616d65223b733a353a224669656c64223b733a31313a226465736372697074696f6e223b733a35373a224669656c642041504920746f20616464206669656c647320746f20656e746974696573206c696b65206e6f64657320616e642075736572732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a343a7b693a303b733a31323a226669656c642e6d6f64756c65223b693a313b733a31363a226669656c642e6174746163682e696e63223b693a323b733a32303a226669656c642e696e666f2e636c6173732e696e63223b693a333b733a31363a2274657374732f6669656c642e74657374223b7d733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a31373a226669656c645f73716c5f73746f72616765223b7d733a383a227265717569726564223b623a313b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31353a227468656d652f6669656c642e637373223b733a32393a226d6f64756c65732f6669656c642f7468656d652f6669656c642e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field/modules/field_sql_storage/field_sql_storage.module', 'field_sql_storage', 'module', '', 1, 0, 7002, 0, 0x613a31323a7b733a343a226e616d65223b733a31373a224669656c642053514c2073746f72616765223b733a31313a226465736372697074696f6e223b733a33373a2253746f726573206669656c64206461746120696e20616e2053514c2064617461626173652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a226669656c64223b7d733a353a2266696c6573223b613a313a7b693a303b733a32323a226669656c645f73716c5f73746f726167652e74657374223b7d733a383a227265717569726564223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field/modules/list/list.module', 'list', 'module', '', 1, 0, 7002, 0, 0x613a31313a7b733a343a226e616d65223b733a343a224c697374223b733a31313a226465736372697074696f6e223b733a36393a22446566696e6573206c697374206669656c642074797065732e205573652077697468204f7074696f6e7320746f206372656174652073656c656374696f6e206c697374732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a323a7b693a303b733a353a226669656c64223b693a313b733a373a226f7074696f6e73223b7d733a353a2266696c6573223b613a313a7b693a303b733a31353a2274657374732f6c6973742e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field/modules/list/tests/list_test.module', 'list_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a393a224c6973742074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220746865204c697374206d6f64756c652074657374732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/field/modules/number/number.module', 'number', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a363a224e756d626572223b733a31313a226465736372697074696f6e223b733a32383a22446566696e6573206e756d65726963206669656c642074797065732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a226669656c64223b7d733a353a2266696c6573223b613a313a7b693a303b733a31313a226e756d6265722e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field/modules/options/options.module', 'options', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a373a224f7074696f6e73223b733a31313a226465736372697074696f6e223b733a38323a22446566696e65732073656c656374696f6e2c20636865636b20626f7820616e6420726164696f20627574746f6e207769646765747320666f72207465787420616e64206e756d65726963206669656c64732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a226669656c64223b7d733a353a2266696c6573223b613a313a7b693a303b733a31323a226f7074696f6e732e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field/modules/text/text.module', 'text', 'module', '', 1, 0, 7000, 0, 0x613a31333a7b733a343a226e616d65223b733a343a2254657874223b733a31313a226465736372697074696f6e223b733a33323a22446566696e65732073696d706c652074657874206669656c642074797065732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a226669656c64223b7d733a353a2266696c6573223b613a313a7b693a303b733a393a22746578742e74657374223b7d733a383a227265717569726564223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b733a31313a226578706c616e6174696f6e223b733a3130393a224669656c64207479706528732920696e20757365202d20736565203c6120687265663d222f6d742d66726565626965732f6769746875622f736b656c65746f6e2f736974652f3f713d61646d696e2f7265706f7274732f6669656c6473223e4669656c64206c6973743c2f613e223b7d),
('modules/field/tests/field_test.module', 'field_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31343a224669656c64204150492054657374223b733a31313a226465736372697074696f6e223b733a33393a22537570706f7274206d6f64756c6520666f7220746865204669656c64204150492074657374732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a353a2266696c6573223b613a313a7b693a303b733a32313a226669656c645f746573742e656e746974792e696e63223b7d733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/field_ui/field_ui.module', 'field_ui', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a383a224669656c64205549223b733a31313a226465736372697074696f6e223b733a33333a225573657220696e7465726661636520666f7220746865204669656c64204150492e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a226669656c64223b7d733a353a2266696c6573223b613a313a7b693a303b733a31333a226669656c645f75692e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/file/file.module', 'file', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a343a2246696c65223b733a31313a226465736372697074696f6e223b733a32363a22446566696e657320612066696c65206669656c6420747970652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a353a226669656c64223b7d733a353a2266696c6573223b613a313a7b693a303b733a31353a2274657374732f66696c652e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/file/tests/file_module_test.module', 'file_module_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a393a2246696c652074657374223b733a31313a226465736372697074696f6e223b733a35333a2250726f766964657320686f6f6b7320666f722074657374696e672046696c65206d6f64756c652066756e6374696f6e616c6974792e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/filter/filter.module', 'filter', 'module', '', 1, 0, 7010, 0, 0x613a31333a7b733a343a226e616d65223b733a363a2246696c746572223b733a31313a226465736372697074696f6e223b733a34333a2246696c7465727320636f6e74656e7420696e207072657061726174696f6e20666f7220646973706c61792e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31313a2266696c7465722e74657374223b7d733a383a227265717569726564223b623a313b733a393a22636f6e666967757265223b733a32383a2261646d696e2f636f6e6669672f636f6e74656e742f666f726d617473223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/forum/forum.module', 'forum', 'module', '', 1, 0, 7012, 1, 0x613a31333a7b733a343a226e616d65223b733a353a22466f72756d223b733a31313a226465736372697074696f6e223b733a32373a2250726f76696465732064697363757373696f6e20666f72756d732e223b733a31323a22646570656e64656e63696573223b613a323a7b693a303b733a383a227461786f6e6f6d79223b693a313b733a373a22636f6d6d656e74223b7d733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31303a22666f72756d2e74657374223b7d733a393a22636f6e666967757265223b733a32313a2261646d696e2f7374727563747572652f666f72756d223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a393a22666f72756d2e637373223b733a32333a226d6f64756c65732f666f72756d2f666f72756d2e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/help/help.module', 'help', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a343a2248656c70223b733a31313a226465736372697074696f6e223b733a33353a224d616e616765732074686520646973706c6179206f66206f6e6c696e652068656c702e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a393a2268656c702e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/image/image.module', 'image', 'module', '', 1, 0, 7004, 0, 0x613a31343a7b733a343a226e616d65223b733a353a22496d616765223b733a31313a226465736372697074696f6e223b733a33343a2250726f766964657320696d616765206d616e6970756c6174696f6e20746f6f6c732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a343a2266696c65223b7d733a353a2266696c6573223b613a313a7b693a303b733a31303a22696d6167652e74657374223b7d733a393a22636f6e666967757265223b733a33313a2261646d696e2f636f6e6669672f6d656469612f696d6167652d7374796c6573223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b733a383a227265717569726564223b623a313b733a31313a226578706c616e6174696f6e223b733a3130393a224669656c64207479706528732920696e20757365202d20736565203c6120687265663d222f6d742d66726565626965732f6769746875622f736b656c65746f6e2f736974652f3f713d61646d696e2f7265706f7274732f6669656c6473223e4669656c64206c6973743c2f613e223b7d),
('modules/image/tests/image_module_test.module', 'image_module_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31303a22496d6167652074657374223b733a31313a226465736372697074696f6e223b733a36393a2250726f766964657320686f6f6b20696d706c656d656e746174696f6e7320666f722074657374696e6720496d616765206d6f64756c652066756e6374696f6e616c6974792e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a32343a22696d6167655f6d6f64756c655f746573742e6d6f64756c65223b7d733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/locale/locale.module', 'locale', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a363a224c6f63616c65223b733a31313a226465736372697074696f6e223b733a3131393a2241646473206c616e67756167652068616e646c696e672066756e6374696f6e616c69747920616e6420656e61626c657320746865207472616e736c6174696f6e206f6620746865207573657220696e7465726661636520746f206c616e677561676573206f74686572207468616e20456e676c6973682e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31313a226c6f63616c652e74657374223b7d733a393a22636f6e666967757265223b733a33303a2261646d696e2f636f6e6669672f726567696f6e616c2f6c616e6775616765223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/locale/tests/locale_test.module', 'locale_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a224c6f63616c652054657374223b733a31313a226465736372697074696f6e223b733a34323a22537570706f7274206d6f64756c6520666f7220746865206c6f63616c65206c617965722074657374732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/menu/menu.module', 'menu', 'module', '', 1, 0, 7003, 0, 0x613a31323a7b733a343a226e616d65223b733a343a224d656e75223b733a31313a226465736372697074696f6e223b733a36303a22416c6c6f77732061646d696e6973747261746f727320746f20637573746f6d697a65207468652073697465206e617669676174696f6e206d656e752e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a393a226d656e752e74657374223b7d733a393a22636f6e666967757265223b733a32303a2261646d696e2f7374727563747572652f6d656e75223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/node/node.module', 'node', 'module', '', 1, 0, 7013, 0, 0x613a31343a7b733a343a226e616d65223b733a343a224e6f6465223b733a31313a226465736372697074696f6e223b733a36363a22416c6c6f777320636f6e74656e7420746f206265207375626d697474656420746f20746865207369746520616e6420646973706c61796564206f6e2070616765732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a323a7b693a303b733a31313a226e6f64652e6d6f64756c65223b693a313b733a393a226e6f64652e74657374223b7d733a383a227265717569726564223b623a313b733a393a22636f6e666967757265223b733a32313a2261646d696e2f7374727563747572652f7479706573223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a383a226e6f64652e637373223b733a32313a226d6f64756c65732f6e6f64652f6e6f64652e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/node/tests/node_access_test.module', 'node_access_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32343a224e6f6465206d6f64756c6520616363657373207465737473223b733a31313a226465736372697074696f6e223b733a34333a22537570706f7274206d6f64756c6520666f72206e6f6465207065726d697373696f6e2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/node/tests/node_test.module', 'node_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31373a224e6f6465206d6f64756c65207465737473223b733a31313a226465736372697074696f6e223b733a34303a22537570706f7274206d6f64756c6520666f72206e6f64652072656c617465642074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/node/tests/node_test_exception.module', 'node_test_exception', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32373a224e6f6465206d6f64756c6520657863657074696f6e207465737473223b733a31313a226465736372697074696f6e223b733a35303a22537570706f7274206d6f64756c6520666f72206e6f64652072656c6174656420657863657074696f6e2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/openid/openid.module', 'openid', 'module', '', 0, 0, -1, 0, 0x613a31313a7b733a343a226e616d65223b733a363a224f70656e4944223b733a31313a226465736372697074696f6e223b733a34383a22416c6c6f777320757365727320746f206c6f6720696e746f20796f75722073697465207573696e67204f70656e49442e223b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a227061636b616765223b733a343a22436f7265223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31313a226f70656e69642e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/openid/tests/openid_test.module', 'openid_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32313a224f70656e49442064756d6d792070726f7669646572223b733a31313a226465736372697074696f6e223b733a33333a224f70656e49442070726f7669646572207573656420666f722074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a363a226f70656e6964223b7d733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/overlay/overlay.module', 'overlay', 'module', '', 1, 1, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a373a224f7665726c6179223b733a31313a226465736372697074696f6e223b733a35393a22446973706c617973207468652044727570616c2061646d696e697374726174696f6e20696e7465726661636520696e20616e206f7665726c61792e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/path/path.module', 'path', 'module', '', 1, 0, 0, 0, 0x613a31323a7b733a343a226e616d65223b733a343a2250617468223b733a31313a226465736372697074696f6e223b733a32383a22416c6c6f777320757365727320746f2072656e616d652055524c732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a393a22706174682e74657374223b7d733a393a22636f6e666967757265223b733a32343a2261646d696e2f636f6e6669672f7365617263682f70617468223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/php/php.module', 'php', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a31303a225048502066696c746572223b733a31313a226465736372697074696f6e223b733a35303a22416c6c6f777320656d6265646465642050485020636f64652f736e69707065747320746f206265206576616c75617465642e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a383a227068702e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/poll/poll.module', 'poll', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a343a22506f6c6c223b733a31313a226465736372697074696f6e223b733a39353a22416c6c6f777320796f7572207369746520746f206361707475726520766f746573206f6e20646966666572656e7420746f7069637320696e2074686520666f726d206f66206d756c7469706c652063686f696365207175657374696f6e732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a393a22706f6c6c2e74657374223b7d733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a383a22706f6c6c2e637373223b733a32313a226d6f64756c65732f706f6c6c2f706f6c6c2e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/profile/profile.module', 'profile', 'module', '', 0, 0, -1, 0, 0x613a31333a7b733a343a226e616d65223b733a373a2250726f66696c65223b733a31313a226465736372697074696f6e223b733a33363a22537570706f72747320636f6e666967757261626c6520757365722070726f66696c65732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31323a2270726f66696c652e74657374223b7d733a393a22636f6e666967757265223b733a32373a2261646d696e2f636f6e6669672f70656f706c652f70726f66696c65223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/rdf/rdf.module', 'rdf', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a333a22524446223b733a31313a226465736372697074696f6e223b733a3134383a22456e72696368657320796f757220636f6e74656e742077697468206d6574616461746120746f206c6574206f74686572206170706c69636174696f6e732028652e672e2073656172636820656e67696e65732c2061676772656761746f7273292062657474657220756e6465727374616e64206974732072656c6174696f6e736869707320616e6420617474726962757465732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a383a227264662e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/rdf/tests/rdf_test.module', 'rdf_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31363a22524446206d6f64756c65207465737473223b733a31313a226465736372697074696f6e223b733a33383a22537570706f7274206d6f64756c6520666f7220524446206d6f64756c652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/search/search.module', 'search', 'module', '', 1, 0, 7000, 0, 0x613a31333a7b733a343a226e616d65223b733a363a22536561726368223b733a31313a226465736372697074696f6e223b733a33363a22456e61626c657320736974652d77696465206b6579776f726420736561726368696e672e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a323a7b693a303b733a31393a227365617263682e657874656e6465722e696e63223b693a313b733a31313a227365617263682e74657374223b7d733a393a22636f6e666967757265223b733a32383a2261646d696e2f636f6e6669672f7365617263682f73657474696e6773223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a227365617263682e637373223b733a32353a226d6f64756c65732f7365617263682f7365617263682e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/search/tests/search_embedded_form.module', 'search_embedded_form', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32303a2253656172636820656d62656464656420666f726d223b733a31313a226465736372697074696f6e223b733a35393a22537570706f7274206d6f64756c6520666f7220736561726368206d6f64756c652074657374696e67206f6620656d62656464656420666f726d732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/search/tests/search_extra_type.module', 'search_extra_type', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31363a2254657374207365617263682074797065223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220736561726368206d6f64756c652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/shortcut/shortcut.module', 'shortcut', 'module', '', 1, 0, 0, 0, 0x613a31323a7b733a343a226e616d65223b733a383a2253686f7274637574223b733a31313a226465736372697074696f6e223b733a36303a22416c6c6f777320757365727320746f206d616e61676520637573746f6d697a61626c65206c69737473206f662073686f7274637574206c696e6b732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31333a2273686f72746375742e74657374223b7d733a393a22636f6e666967757265223b733a33363a2261646d696e2f636f6e6669672f757365722d696e746572666163652f73686f7274637574223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/simpletest.module', 'simpletest', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a373a2254657374696e67223b733a31313a226465736372697074696f6e223b733a35333a2250726f76696465732061206672616d65776f726b20666f7220756e697420616e642066756e6374696f6e616c2074657374696e672e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a34383a7b693a303b733a31353a2273696d706c65746573742e74657374223b693a313b733a32343a2264727570616c5f7765625f746573745f636173652e706870223b693a323b733a31383a2274657374732f616374696f6e732e74657374223b693a333b733a31353a2274657374732f616a61782e74657374223b693a343b733a31363a2274657374732f62617463682e74657374223b693a353b733a32303a2274657374732f626f6f7473747261702e74657374223b693a363b733a31363a2274657374732f63616368652e74657374223b693a373b733a31373a2274657374732f636f6d6d6f6e2e74657374223b693a383b733a32343a2274657374732f64617461626173655f746573742e74657374223b693a393b733a33323a2274657374732f656e746974795f637275645f686f6f6b5f746573742e74657374223b693a31303b733a32333a2274657374732f656e746974795f71756572792e74657374223b693a31313b733a31363a2274657374732f6572726f722e74657374223b693a31323b733a31353a2274657374732f66696c652e74657374223b693a31333b733a32333a2274657374732f66696c657472616e736665722e74657374223b693a31343b733a31353a2274657374732f666f726d2e74657374223b693a31353b733a31363a2274657374732f67726170682e74657374223b693a31363b733a31363a2274657374732f696d6167652e74657374223b693a31373b733a31353a2274657374732f6c6f636b2e74657374223b693a31383b733a31353a2274657374732f6d61696c2e74657374223b693a31393b733a31353a2274657374732f6d656e752e74657374223b693a32303b733a31373a2274657374732f6d6f64756c652e74657374223b693a32313b733a31363a2274657374732f70616765722e74657374223b693a32323b733a31393a2274657374732f70617373776f72642e74657374223b693a32333b733a31353a2274657374732f706174682e74657374223b693a32343b733a31393a2274657374732f72656769737472792e74657374223b693a32353b733a31373a2274657374732f736368656d612e74657374223b693a32363b733a31383a2274657374732f73657373696f6e2e74657374223b693a32373b733a32303a2274657374732f7461626c65736f72742e74657374223b693a32383b733a31363a2274657374732f7468656d652e74657374223b693a32393b733a31383a2274657374732f756e69636f64652e74657374223b693a33303b733a31373a2274657374732f7570646174652e74657374223b693a33313b733a31373a2274657374732f786d6c7270632e74657374223b693a33323b733a32363a2274657374732f757067726164652f757067726164652e74657374223b693a33333b733a33343a2274657374732f757067726164652f757067726164652e636f6d6d656e742e74657374223b693a33343b733a33333a2274657374732f757067726164652f757067726164652e66696c7465722e74657374223b693a33353b733a33323a2274657374732f757067726164652f757067726164652e666f72756d2e74657374223b693a33363b733a33333a2274657374732f757067726164652f757067726164652e6c6f63616c652e74657374223b693a33373b733a33313a2274657374732f757067726164652f757067726164652e6d656e752e74657374223b693a33383b733a33313a2274657374732f757067726164652f757067726164652e6e6f64652e74657374223b693a33393b733a33353a2274657374732f757067726164652f757067726164652e7461786f6e6f6d792e74657374223b693a34303b733a33343a2274657374732f757067726164652f757067726164652e747269676765722e74657374223b693a34313b733a33393a2274657374732f757067726164652f757067726164652e7472616e736c617461626c652e74657374223b693a34323b733a33333a2274657374732f757067726164652f757067726164652e75706c6f61642e74657374223b693a34333b733a33313a2274657374732f757067726164652f757067726164652e757365722e74657374223b693a34343b733a33363a2274657374732f757067726164652f7570646174652e61676772656761746f722e74657374223b693a34353b733a33333a2274657374732f757067726164652f7570646174652e747269676765722e74657374223b693a34363b733a33313a2274657374732f757067726164652f7570646174652e6669656c642e74657374223b693a34373b733a33303a2274657374732f757067726164652f7570646174652e757365722e74657374223b7d733a393a22636f6e666967757265223b733a34313a2261646d696e2f636f6e6669672f646576656c6f706d656e742f74657374696e672f73657474696e6773223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/actions_loop_test.module', 'actions_loop_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31373a22416374696f6e73206c6f6f702074657374223b733a31313a226465736372697074696f6e223b733a33393a22537570706f7274206d6f64756c6520666f7220616374696f6e206c6f6f702074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/ajax_forms_test.module', 'ajax_forms_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32363a22414a415820666f726d2074657374206d6f636b206d6f64756c65223b733a31313a226465736372697074696f6e223b733a32353a225465737420666f7220414a415820666f726d2063616c6c732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/ajax_test.module', 'ajax_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a393a22414a41582054657374223b733a31313a226465736372697074696f6e223b733a34303a22537570706f7274206d6f64756c6520666f7220414a4158206672616d65776f726b2074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d);
INSERT INTO `system` (`filename`, `name`, `type`, `owner`, `status`, `bootstrap`, `schema_version`, `weight`, `info`) VALUES
('modules/simpletest/tests/batch_test.module', 'batch_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31343a224261746368204150492074657374223b733a31313a226465736372697074696f6e223b733a33353a22537570706f7274206d6f64756c6520666f72204261746368204150492074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/common_test.module', 'common_test', 'module', '', 0, 0, -1, 0, 0x613a31333a7b733a343a226e616d65223b733a31313a22436f6d6d6f6e2054657374223b733a31313a226465736372697074696f6e223b733a33323a22537570706f7274206d6f64756c6520666f7220436f6d6d6f6e2074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a31353a22636f6d6d6f6e5f746573742e637373223b733a34303a226d6f64756c65732f73696d706c65746573742f74657374732f636f6d6d6f6e5f746573742e637373223b7d733a353a227072696e74223b613a313a7b733a32313a22636f6d6d6f6e5f746573742e7072696e742e637373223b733a34363a226d6f64756c65732f73696d706c65746573742f74657374732f636f6d6d6f6e5f746573742e7072696e742e637373223b7d7d733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/common_test_cron_helper.module', 'common_test_cron_helper', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32333a22436f6d6d6f6e20546573742043726f6e2048656c706572223b733a31313a226465736372697074696f6e223b733a35363a2248656c706572206d6f64756c6520666f722043726f6e52756e54657374436173653a3a7465737443726f6e457863657074696f6e7328292e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/database_test.module', 'database_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31333a2244617461626173652054657374223b733a31313a226465736372697074696f6e223b733a34303a22537570706f7274206d6f64756c6520666f72204461746162617365206c617965722074657374732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/drupal_system_listing_compatible_test/drupal_system_listing_compatible_test.module', 'drupal_system_listing_compatible_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a33373a2244727570616c2073797374656d206c697374696e6720636f6d70617469626c652074657374223b733a31313a226465736372697074696f6e223b733a36323a22537570706f7274206d6f64756c6520666f722074657374696e67207468652064727570616c5f73797374656d5f6c697374696e672066756e6374696f6e2e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/drupal_system_listing_incompatible_test/drupal_system_listing_incompatible_test.module', 'drupal_system_listing_incompatible_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a33393a2244727570616c2073797374656d206c697374696e6720696e636f6d70617469626c652074657374223b733a31313a226465736372697074696f6e223b733a36323a22537570706f7274206d6f64756c6520666f722074657374696e67207468652064727570616c5f73797374656d5f6c697374696e672066756e6374696f6e2e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/entity_cache_test.module', 'entity_cache_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31373a22456e746974792063616368652074657374223b733a31313a226465736372697074696f6e223b733a34303a22537570706f7274206d6f64756c6520666f722074657374696e6720656e746974792063616368652e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a32383a22656e746974795f63616368655f746573745f646570656e64656e6379223b7d733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/entity_cache_test_dependency.module', 'entity_cache_test_dependency', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32383a22456e74697479206361636865207465737420646570656e64656e6379223b733a31313a226465736372697074696f6e223b733a35313a22537570706f727420646570656e64656e6379206d6f64756c6520666f722074657374696e6720656e746974792063616368652e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/entity_crud_hook_test.module', 'entity_crud_hook_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32323a22456e74697479204352554420486f6f6b732054657374223b733a31313a226465736372697074696f6e223b733a33353a22537570706f7274206d6f64756c6520666f72204352554420686f6f6b2074657374732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/error_test.module', 'error_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31303a224572726f722074657374223b733a31313a226465736372697074696f6e223b733a34373a22537570706f7274206d6f64756c6520666f72206572726f7220616e6420657863657074696f6e2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/file_test.module', 'file_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a393a2246696c652074657374223b733a31313a226465736372697074696f6e223b733a33393a22537570706f7274206d6f64756c6520666f722066696c652068616e646c696e672074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31363a2266696c655f746573742e6d6f64756c65223b7d733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/filter_test.module', 'filter_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31383a2246696c7465722074657374206d6f64756c65223b733a31313a226465736372697074696f6e223b733a33333a2254657374732066696c74657220686f6f6b7320616e642066756e6374696f6e732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/form_test.module', 'form_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31323a22466f726d4150492054657374223b733a31313a226465736372697074696f6e223b733a33343a22537570706f7274206d6f64756c6520666f7220466f726d204150492074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/image_test.module', 'image_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31303a22496d6167652074657374223b733a31313a226465736372697074696f6e223b733a33393a22537570706f7274206d6f64756c6520666f7220696d61676520746f6f6c6b69742074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/menu_test.module', 'menu_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31353a22486f6f6b206d656e75207465737473223b733a31313a226465736372697074696f6e223b733a33373a22537570706f7274206d6f64756c6520666f72206d656e7520686f6f6b2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/module_test.module', 'module_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a224d6f64756c652074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f72206d6f64756c652073797374656d2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/path_test.module', 'path_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31353a22486f6f6b2070617468207465737473223b733a31313a226465736372697074696f6e223b733a33373a22537570706f7274206d6f64756c6520666f72207061746820686f6f6b2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/requirements1_test.module', 'requirements1_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31393a22526571756972656d656e747320312054657374223b733a31313a226465736372697074696f6e223b733a38303a22546573747320746861742061206d6f64756c65206973206e6f7420696e7374616c6c6564207768656e206974206661696c7320686f6f6b5f726571756972656d656e74732827696e7374616c6c27292e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/requirements2_test.module', 'requirements2_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31393a22526571756972656d656e747320322054657374223b733a31313a226465736372697074696f6e223b733a39383a22546573747320746861742061206d6f64756c65206973206e6f7420696e7374616c6c6564207768656e20746865206f6e6520697420646570656e6473206f6e206661696c7320686f6f6b5f726571756972656d656e74732827696e7374616c6c292e223b733a31323a22646570656e64656e63696573223b613a323a7b693a303b733a31383a22726571756972656d656e7473315f74657374223b693a313b733a373a22636f6d6d656e74223b7d733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/session_test.module', 'session_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31323a2253657373696f6e2074657374223b733a31313a226465736372697074696f6e223b733a34303a22537570706f7274206d6f64756c6520666f722073657373696f6e20646174612074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/system_dependencies_test.module', 'system_dependencies_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32323a2253797374656d20646570656e64656e63792074657374223b733a31313a226465736372697074696f6e223b733a34373a22537570706f7274206d6f64756c6520666f722074657374696e672073797374656d20646570656e64656e636965732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a31393a225f6d697373696e675f646570656e64656e6379223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/system_incompatible_core_version_dependencies_test.module', 'system_incompatible_core_version_dependencies_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a35303a2253797374656d20696e636f6d70617469626c6520636f72652076657273696f6e20646570656e64656e636965732074657374223b733a31313a226465736372697074696f6e223b733a34373a22537570706f7274206d6f64756c6520666f722074657374696e672073797374656d20646570656e64656e636965732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a33373a2273797374656d5f696e636f6d70617469626c655f636f72655f76657273696f6e5f74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/system_incompatible_core_version_test.module', 'system_incompatible_core_version_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a33373a2253797374656d20696e636f6d70617469626c6520636f72652076657273696f6e2074657374223b733a31313a226465736372697074696f6e223b733a34373a22537570706f7274206d6f64756c6520666f722074657374696e672073797374656d20646570656e64656e636965732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22352e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/system_incompatible_module_version_dependencies_test.module', 'system_incompatible_module_version_dependencies_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a35323a2253797374656d20696e636f6d70617469626c65206d6f64756c652076657273696f6e20646570656e64656e636965732074657374223b733a31313a226465736372697074696f6e223b733a34373a22537570706f7274206d6f64756c6520666f722074657374696e672073797374656d20646570656e64656e636965732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a34363a2273797374656d5f696e636f6d70617469626c655f6d6f64756c655f76657273696f6e5f7465737420283e322e3029223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/system_incompatible_module_version_test.module', 'system_incompatible_module_version_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a33393a2253797374656d20696e636f6d70617469626c65206d6f64756c652076657273696f6e2074657374223b733a31313a226465736372697074696f6e223b733a34373a22537570706f7274206d6f64756c6520666f722074657374696e672073797374656d20646570656e64656e636965732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/system_test.module', 'system_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a2253797374656d2074657374223b733a31313a226465736372697074696f6e223b733a33343a22537570706f7274206d6f64756c6520666f722073797374656d2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31383a2273797374656d5f746573742e6d6f64756c65223b7d733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/taxonomy_test.module', 'taxonomy_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32303a225461786f6e6f6d792074657374206d6f64756c65223b733a31313a226465736372697074696f6e223b733a34353a222254657374732066756e6374696f6e7320616e6420686f6f6b73206e6f74207573656420696e20636f7265222e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a383a227461786f6e6f6d79223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/theme_test.module', 'theme_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31303a225468656d652074657374223b733a31313a226465736372697074696f6e223b733a34303a22537570706f7274206d6f64756c6520666f72207468656d652073797374656d2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/update_script_test.module', 'update_script_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31383a22557064617465207363726970742074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220757064617465207363726970742074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/update_test_1.module', 'update_test_1', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a225570646174652074657374223b733a31313a226465736372697074696f6e223b733a33343a22537570706f7274206d6f64756c6520666f72207570646174652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/update_test_2.module', 'update_test_2', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a225570646174652074657374223b733a31313a226465736372697074696f6e223b733a33343a22537570706f7274206d6f64756c6520666f72207570646174652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/update_test_3.module', 'update_test_3', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a225570646174652074657374223b733a31313a226465736372697074696f6e223b733a33343a22537570706f7274206d6f64756c6520666f72207570646174652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/url_alter_test.module', 'url_alter_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31353a2255726c5f616c746572207465737473223b733a31313a226465736372697074696f6e223b733a34353a224120737570706f7274206d6f64756c657320666f722075726c5f616c74657220686f6f6b2074657374696e672e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/xmlrpc_test.module', 'xmlrpc_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31323a22584d4c2d5250432054657374223b733a31313a226465736372697074696f6e223b733a37353a22537570706f7274206d6f64756c6520666f7220584d4c2d525043207465737473206163636f7264696e6720746f207468652076616c696461746f72312073706563696669636174696f6e2e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/statistics/statistics.module', 'statistics', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31303a2253746174697374696373223b733a31313a226465736372697074696f6e223b733a33373a224c6f677320616363657373207374617469737469637320666f7220796f757220736974652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31353a22737461746973746963732e74657374223b7d733a393a22636f6e666967757265223b733a33303a2261646d696e2f636f6e6669672f73797374656d2f73746174697374696373223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/syslog/syslog.module', 'syslog', 'module', '', 0, 0, -1, 0, 0x613a31313a7b733a343a226e616d65223b733a363a225379736c6f67223b733a31313a226465736372697074696f6e223b733a34313a224c6f677320616e64207265636f7264732073797374656d206576656e747320746f207379736c6f672e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31313a227379736c6f672e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/system/system.module', 'system', 'module', '', 1, 0, 7078, 0, 0x613a31333a7b733a343a226e616d65223b733a363a2253797374656d223b733a31313a226465736372697074696f6e223b733a35343a2248616e646c65732067656e6572616c207369746520636f6e66696775726174696f6e20666f722061646d696e6973747261746f72732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a363a7b693a303b733a31393a2273797374656d2e61726368697665722e696e63223b693a313b733a31353a2273797374656d2e6d61696c2e696e63223b693a323b733a31363a2273797374656d2e71756575652e696e63223b693a333b733a31343a2273797374656d2e7461722e696e63223b693a343b733a31383a2273797374656d2e757064617465722e696e63223b693a353b733a31313a2273797374656d2e74657374223b7d733a383a227265717569726564223b623a313b733a393a22636f6e666967757265223b733a31393a2261646d696e2f636f6e6669672f73797374656d223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/taxonomy/taxonomy.module', 'taxonomy', 'module', '', 1, 0, 7010, 0, 0x613a31343a7b733a343a226e616d65223b733a383a225461786f6e6f6d79223b733a31313a226465736372697074696f6e223b733a33383a22456e61626c6573207468652063617465676f72697a6174696f6e206f6620636f6e74656e742e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a373a226f7074696f6e73223b7d733a353a2266696c6573223b613a323a7b693a303b733a31353a227461786f6e6f6d792e6d6f64756c65223b693a313b733a31333a227461786f6e6f6d792e74657374223b7d733a393a22636f6e666967757265223b733a32343a2261646d696e2f7374727563747572652f7461786f6e6f6d79223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b733a383a227265717569726564223b623a313b733a31313a226578706c616e6174696f6e223b733a3130393a224669656c64207479706528732920696e20757365202d20736565203c6120687265663d222f6d742d66726565626965732f6769746875622f736b656c65746f6e2f736974652f3f713d61646d696e2f7265706f7274732f6669656c6473223e4669656c64206c6973743c2f613e223b7d),
('modules/toolbar/toolbar.module', 'toolbar', 'module', '', 1, 0, 0, 0, 0x613a31313a7b733a343a226e616d65223b733a373a22546f6f6c626172223b733a31313a226465736372697074696f6e223b733a39393a2250726f7669646573206120746f6f6c62617220746861742073686f77732074686520746f702d6c6576656c2061646d696e697374726174696f6e206d656e75206974656d7320616e64206c696e6b732066726f6d206f74686572206d6f64756c65732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/tracker/tracker.module', 'tracker', 'module', '', 0, 0, -1, 0, 0x613a31313a7b733a343a226e616d65223b733a373a22547261636b6572223b733a31313a226465736372697074696f6e223b733a34353a22456e61626c657320747261636b696e67206f6620726563656e7420636f6e74656e7420666f722075736572732e223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a373a22636f6d6d656e74223b7d733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31323a22747261636b65722e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/translation/tests/translation_test.module', 'translation_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32343a22436f6e74656e74205472616e736c6174696f6e2054657374223b733a31313a226465736372697074696f6e223b733a34393a22537570706f7274206d6f64756c6520666f722074686520636f6e74656e74207472616e736c6174696f6e2074657374732e223b733a343a22636f7265223b733a333a22372e78223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/translation/translation.module', 'translation', 'module', '', 0, 0, -1, 0, 0x613a31313a7b733a343a226e616d65223b733a31393a22436f6e74656e74207472616e736c6174696f6e223b733a31313a226465736372697074696f6e223b733a35373a22416c6c6f777320636f6e74656e7420746f206265207472616e736c6174656420696e746f20646966666572656e74206c616e6775616765732e223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a363a226c6f63616c65223b7d733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31363a227472616e736c6174696f6e2e74657374223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/trigger/tests/trigger_test.module', 'trigger_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31323a22547269676765722054657374223b733a31313a226465736372697074696f6e223b733a33333a22537570706f7274206d6f64756c6520666f7220547269676765722074657374732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/trigger/trigger.module', 'trigger', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a373a2254726967676572223b733a31313a226465736372697074696f6e223b733a39303a22456e61626c657320616374696f6e7320746f206265206669726564206f6e206365727461696e2073797374656d206576656e74732c2073756368206173207768656e206e657720636f6e74656e7420697320637265617465642e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31323a22747269676765722e74657374223b7d733a393a22636f6e666967757265223b733a32333a2261646d696e2f7374727563747572652f74726967676572223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/update/tests/aaa_update_test.module', 'aaa_update_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31353a22414141205570646174652074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220757064617465206d6f64756c652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/update/tests/bbb_update_test.module', 'bbb_update_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31353a22424242205570646174652074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220757064617465206d6f64756c652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/update/tests/ccc_update_test.module', 'ccc_update_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31353a22434343205570646174652074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220757064617465206d6f64756c652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/update/tests/update_test.module', 'update_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31313a225570646174652074657374223b733a31313a226465736372697074696f6e223b733a34313a22537570706f7274206d6f64756c6520666f7220757064617465206d6f64756c652074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/update/update.module', 'update', 'module', '', 1, 0, 7001, 0, 0x613a31323a7b733a343a226e616d65223b733a31343a22557064617465206d616e61676572223b733a31313a226465736372697074696f6e223b733a3130343a22436865636b7320666f7220617661696c61626c6520757064617465732c20616e642063616e207365637572656c7920696e7374616c6c206f7220757064617465206d6f64756c657320616e64207468656d65732076696120612077656220696e746572666163652e223b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a227061636b616765223b733a343a22436f7265223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a31313a227570646174652e74657374223b7d733a393a22636f6e666967757265223b733a33303a2261646d696e2f7265706f7274732f757064617465732f73657474696e6773223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('modules/user/tests/user_form_test.module', 'user_form_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32323a2255736572206d6f64756c6520666f726d207465737473223b733a31313a226465736372697074696f6e223b733a33373a22537570706f7274206d6f64756c6520666f72207573657220666f726d2074657374696e672e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/user/user.module', 'user', 'module', '', 1, 0, 7018, 0, 0x613a31343a7b733a343a226e616d65223b733a343a2255736572223b733a31313a226465736372697074696f6e223b733a34373a224d616e6167657320746865207573657220726567697374726174696f6e20616e64206c6f67696e2073797374656d2e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a323a7b693a303b733a31313a22757365722e6d6f64756c65223b693a313b733a393a22757365722e74657374223b7d733a383a227265717569726564223b623a313b733a393a22636f6e666967757265223b733a31393a2261646d696e2f636f6e6669672f70656f706c65223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a383a22757365722e637373223b733a32313a226d6f64756c65732f757365722f757365722e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('profiles/standard/standard.profile', 'standard', 'module', '', 1, 0, 0, 1000, 0x613a31343a7b733a343a226e616d65223b733a383a225374616e64617264223b733a31313a226465736372697074696f6e223b733a35313a22496e7374616c6c207769746820636f6d6d6f6e6c792075736564206665617475726573207072652d636f6e666967757265642e223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a32313a7b693a303b733a353a22626c6f636b223b693a313b733a353a22636f6c6f72223b693a323b733a373a22636f6d6d656e74223b693a333b733a31303a22636f6e7465787475616c223b693a343b733a393a2264617368626f617264223b693a353b733a343a2268656c70223b693a363b733a353a22696d616765223b693a373b733a343a226c697374223b693a383b733a343a226d656e75223b693a393b733a363a226e756d626572223b693a31303b733a373a226f7074696f6e73223b693a31313b733a343a2270617468223b693a31323b733a383a227461786f6e6f6d79223b693a31333b733a353a2264626c6f67223b693a31343b733a363a22736561726368223b693a31353b733a383a2273686f7274637574223b693a31363b733a373a22746f6f6c626172223b693a31373b733a373a226f7665726c6179223b693a31383b733a383a226669656c645f7569223b693a31393b733a343a2266696c65223b693a32303b733a333a22726466223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a373a227061636b616765223b733a353a224f74686572223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b733a363a2268696464656e223b623a313b733a383a227265717569726564223b623a313b733a31373a22646973747269627574696f6e5f6e616d65223b733a363a2244727570616c223b7d);
INSERT INTO `system` (`filename`, `name`, `type`, `owner`, `status`, `bootstrap`, `schema_version`, `weight`, `info`) VALUES
('sites/all/themes/skeletontheme/skeletontheme.info', 'skeletontheme', 'theme', 'themes/engines/phptemplate/phptemplate.engine', 1, 0, -1, 0, 0x613a31373a7b733a343a226e616d65223b733a383a22536b656c65746f6e223b733a31313a226465736372697074696f6e223b733a3336313a22536b656c65746f6e206973206120706f77657266756c2c20636c65616e2c20726573706f6e73697665207468656d6520706f7274656420746f2044727570616c206279203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d2f22207461726765743d225f626c616e6b223e4d6f7265205468616e20286a75737429205468656d65733c2f613e2e20496620796f75206c696b652074686973207468656d652c20776520656e636f757261676520796f7520746f2074727920616c736f206f7572206f74686572203c6120687265663d22687474703a2f2f7777772e6d6f72657468616e7468656d65732e636f6d22207461726765743d225f626c616e6b223e5072656d69756d3c2f613e20616e64203c6120687265663d22687474703a2f2f64727570616c697a696e672e636f6d22207461726765743d225f626c616e6b223e467265653c2f613e2044727570616c207468656d65732e223b733a373a2276657273696f6e223b733a373a22372e782d312e32223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a353a7b733a31363a226373732f736b656c65746f6e2e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f736b656c65746f6e2e637373223b733a31333a226373732f7374796c652e637373223b733a34343a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f7374796c652e637373223b733a31353a226373732f627574746f6e732e637373223b733a34363a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f627574746f6e732e637373223b733a31343a226373732f6c61796f75742e637373223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f6373732f6c61796f75742e637373223b733a31363a22636f6c6f722f636f6c6f72732e637373223b733a34373a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f636f6c6f722f636f6c6f72732e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a31353a226865616465725f746f705f6c656674223b733a31353a2248656164657220746f70206c656674223b733a31363a226865616465725f746f705f7269676874223b733a31363a2248656164657220746f70207269676874223b733a31323a226865616465725f7269676874223b733a31323a22486561646572207269676874223b733a363a22686561646572223b733a363a22486561646572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31333a2266656174757265645f6c656674223b733a31333a224665617475726564206c656674223b733a31343a2266656174757265645f7269676874223b733a31343a224665617475726564207269676874223b733a31323a22666f6f7465725f6669727374223b733a31323a22466f6f746572206669727374223b733a31333a22666f6f7465725f7365636f6e64223b733a31333a22466f6f746572207365636f6e64223b733a31323a22666f6f7465725f7468697264223b733a31323a22466f6f746572207468697264223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a333a7b733a32313a22726573706f6e736976655f6d656e755f7374617465223b733a313a2231223b733a32373a22726573706f6e736976655f6d656e755f7377697463687769647468223b733a333a22373630223b733a32393a22726573706f6e736976655f6d656e755f746f706f7074696f6e74657874223b733a31333a2253656c65637420612070616765223b7d733a373a2270726f6a656374223b733a31333a22736b656c65746f6e7468656d65223b733a393a22646174657374616d70223b733a31303a2231333631303632323839223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a34353a2273697465732f616c6c2f7468656d65732f736b656c65746f6e7468656d652f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d),
('themes/bartik/bartik.info', 'bartik', 'theme', 'themes/engines/phptemplate/phptemplate.engine', 1, 0, -1, 0, 0x613a31383a7b733a343a226e616d65223b733a363a2242617274696b223b733a31313a226465736372697074696f6e223b733a34383a224120666c657869626c652c207265636f6c6f7261626c65207468656d652077697468206d616e7920726567696f6e732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a333a7b733a31343a226373732f6c61796f75742e637373223b733a32383a227468656d65732f62617274696b2f6373732f6c61796f75742e637373223b733a31333a226373732f7374796c652e637373223b733a32373a227468656d65732f62617274696b2f6373732f7374796c652e637373223b733a31343a226373732f636f6c6f72732e637373223b733a32383a227468656d65732f62617274696b2f6373732f636f6c6f72732e637373223b7d733a353a227072696e74223b613a313a7b733a31333a226373732f7072696e742e637373223b733a32373a227468656d65732f62617274696b2f6373732f7072696e742e637373223b7d7d733a373a22726567696f6e73223b613a32303a7b733a363a22686561646572223b733a363a22486561646572223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a383a226665617475726564223b733a383a224665617475726564223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a31333a22736964656261725f6669727374223b733a31333a2253696465626172206669727374223b733a31343a22736964656261725f7365636f6e64223b733a31343a2253696465626172207365636f6e64223b733a31343a2274726970747963685f6669727374223b733a31343a225472697074796368206669727374223b733a31353a2274726970747963685f6d6964646c65223b733a31353a225472697074796368206d6964646c65223b733a31333a2274726970747963685f6c617374223b733a31333a225472697074796368206c617374223b733a31383a22666f6f7465725f6669727374636f6c756d6e223b733a31393a22466f6f74657220666972737420636f6c756d6e223b733a31393a22666f6f7465725f7365636f6e64636f6c756d6e223b733a32303a22466f6f746572207365636f6e6420636f6c756d6e223b733a31383a22666f6f7465725f7468697264636f6c756d6e223b733a31393a22466f6f74657220746869726420636f6c756d6e223b733a31393a22666f6f7465725f666f75727468636f6c756d6e223b733a32303a22466f6f74657220666f7572746820636f6c756d6e223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2230223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32383a227468656d65732f62617274696b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d),
('themes/garland/garland.info', 'garland', 'theme', 'themes/engines/phptemplate/phptemplate.engine', 0, 0, -1, 0, 0x613a31383a7b733a343a226e616d65223b733a373a224761726c616e64223b733a31313a226465736372697074696f6e223b733a3131313a2241206d756c74692d636f6c756d6e207468656d652077686963682063616e20626520636f6e6669677572656420746f206d6f6469667920636f6c6f727320616e6420737769746368206265747765656e20666978656420616e6420666c756964207769647468206c61796f7574732e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a323a7b733a333a22616c6c223b613a313a7b733a393a227374796c652e637373223b733a32343a227468656d65732f6761726c616e642f7374796c652e637373223b7d733a353a227072696e74223b613a313a7b733a393a227072696e742e637373223b733a32343a227468656d65732f6761726c616e642f7072696e742e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a31333a226761726c616e645f7769647468223b733a353a22666c756964223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32393a227468656d65732f6761726c616e642f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d),
('themes/seven/seven.info', 'seven', 'theme', 'themes/engines/phptemplate/phptemplate.engine', 1, 0, -1, 0, 0x613a31383a7b733a343a226e616d65223b733a353a22536576656e223b733a31313a226465736372697074696f6e223b733a36353a22412073696d706c65206f6e652d636f6c756d6e2c207461626c656c6573732c20666c7569642077696474682061646d696e697374726174696f6e207468656d652e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a363a2273637265656e223b613a323a7b733a393a2272657365742e637373223b733a32323a227468656d65732f736576656e2f72657365742e637373223b733a393a227374796c652e637373223b733a32323a227468656d65732f736576656e2f7374796c652e637373223b7d7d733a383a2273657474696e6773223b613a313a7b733a32303a2273686f72746375745f6d6f64756c655f6c696e6b223b733a313a2231223b7d733a373a22726567696f6e73223b613a383a7b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31333a22736964656261725f6669727374223b733a31333a2246697273742073696465626172223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a31343a22726567696f6e735f68696464656e223b613a333a7b693a303b733a31333a22736964656261725f6669727374223b693a313b733a383a22706167655f746f70223b693a323b733a31313a22706167655f626f74746f6d223b7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f736576656e2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d),
('themes/stark/stark.info', 'stark', 'theme', 'themes/engines/phptemplate/phptemplate.engine', 0, 0, -1, 0, 0x613a31373a7b733a343a226e616d65223b733a353a22537461726b223b733a31313a226465736372697074696f6e223b733a3230383a2254686973207468656d652064656d6f6e737472617465732044727570616c27732064656661756c742048544d4c206d61726b757020616e6420435353207374796c65732e20546f206c6561726e20686f7720746f206275696c6420796f7572206f776e207468656d6520616e64206f766572726964652044727570616c27732064656661756c7420636f64652c2073656520746865203c6120687265663d22687474703a2f2f64727570616c2e6f72672f7468656d652d6775696465223e5468656d696e672047756964653c2f613e2e223b733a373a227061636b616765223b733a343a22436f7265223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a31313a227374796c65736865657473223b613a313a7b733a333a22616c6c223b613a313a7b733a31303a226c61796f75742e637373223b733a32333a227468656d65732f737461726b2f6c61796f75742e637373223b7d7d733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a363a22656e67696e65223b733a31313a2270687074656d706c617465223b733a373a22726567696f6e73223b613a31323a7b733a31333a22736964656261725f6669727374223b733a31323a224c6566742073696465626172223b733a31343a22736964656261725f7365636f6e64223b733a31333a2252696768742073696465626172223b733a373a22636f6e74656e74223b733a373a22436f6e74656e74223b733a363a22686561646572223b733a363a22486561646572223b733a363a22666f6f746572223b733a363a22466f6f746572223b733a31313a22686967686c696768746564223b733a31313a22486967686c696768746564223b733a343a2268656c70223b733a343a2248656c70223b733a383a22706167655f746f70223b733a383a225061676520746f70223b733a31313a22706167655f626f74746f6d223b733a31313a225061676520626f74746f6d223b733a31343a2264617368626f6172645f6d61696e223b733a31363a2244617368626f61726420286d61696e29223b733a31373a2264617368626f6172645f73696465626172223b733a31393a2244617368626f61726420287369646562617229223b733a31383a2264617368626f6172645f696e616374697665223b733a32303a2244617368626f6172642028696e61637469766529223b7d733a383a226665617475726573223b613a393a7b693a303b733a343a226c6f676f223b693a313b733a373a2266617669636f6e223b693a323b733a343a226e616d65223b693a333b733a363a22736c6f67616e223b693a343b733a31373a226e6f64655f757365725f70696374757265223b693a353b733a32303a22636f6d6d656e745f757365725f70696374757265223b693a363b733a32353a22636f6d6d656e745f757365725f766572696669636174696f6e223b693a373b733a393a226d61696e5f6d656e75223b693a383b733a31343a227365636f6e646172795f6d656e75223b7d733a31303a2273637265656e73686f74223b733a32373a227468656d65732f737461726b2f73637265656e73686f742e706e67223b733a333a22706870223b733a353a22352e322e34223b733a373a2273637269707473223b613a303a7b7d733a31353a226f7665726c61795f726567696f6e73223b613a353a7b693a303b733a31343a2264617368626f6172645f6d61696e223b693a313b733a31373a2264617368626f6172645f73696465626172223b693a323b733a31383a2264617368626f6172645f696e616374697665223b693a333b733a373a22636f6e74656e74223b693a343b733a343a2268656c70223b7d733a31343a22726567696f6e735f68696464656e223b613a323a7b693a303b733a383a22706167655f746f70223b693a313b733a31313a22706167655f626f74746f6d223b7d733a32383a226f7665726c61795f737570706c656d656e74616c5f726567696f6e73223b613a313a7b693a303b733a383a22706167655f746f70223b7d7d),
('sites/all/modules/superfish/superfish.module', 'superfish', 'module', '', 1, 0, 7100, 0, 0x613a31323a7b733a343a226e616d65223b733a393a22537570657266697368223b733a31313a226465736372697074696f6e223b733a34363a226a51756572792053757065726669736820706c7567696e20666f7220796f75722044727570616c206d656e75732e223b733a373a227061636b616765223b733a31343a225573657220696e74657266616365223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a343a226d656e75223b7d733a393a22636f6e666967757265223b733a33373a2261646d696e2f636f6e6669672f757365722d696e746572666163652f737570657266697368223b733a343a22636f7265223b733a333a22372e78223b733a373a2276657273696f6e223b733a373a22372e782d312e39223b733a373a2270726f6a656374223b733a393a22737570657266697368223b733a393a22646174657374616d70223b733a31303a2231333637303534313132223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/entity_query_access_test.module', 'entity_query_access_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32343a22456e74697479207175657279206163636573732074657374223b733a31313a226465736372697074696f6e223b733a34393a22537570706f7274206d6f64756c6520666f7220636865636b696e6720656e7469747920717565727920726573756c74732e223b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('sites/all/modules/libraries/libraries.module', 'libraries', 'module', '', 1, 0, 7200, 0, 0x613a31313a7b733a343a226e616d65223b733a393a224c6962726172696573223b733a31313a226465736372697074696f6e223b733a36343a22416c6c6f77732076657273696f6e2d646570656e64656e7420616e6420736861726564207573616765206f662065787465726e616c206c69627261726965732e223b733a343a22636f7265223b733a333a22372e78223b733a353a2266696c6573223b613a313a7b693a303b733a32303a2274657374732f6c69627261726965732e74657374223b7d733a373a2276657273696f6e223b733a373a22372e782d322e31223b733a373a2270726f6a656374223b733a393a226c6962726172696573223b733a393a22646174657374616d70223b733a31303a2231333632383438343132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a373a227061636b616765223b733a353a224f74686572223b733a333a22706870223b733a353a22352e322e34223b733a393a22626f6f747374726170223b693a303b7d),
('sites/all/modules/libraries/tests/libraries_test.module', 'libraries_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a32313a224c69627261726965732074657374206d6f64756c65223b733a31313a226465736372697074696f6e223b733a33363a225465737473206c69627261727920646574656374696f6e20616e64206c6f6164696e672e223b733a343a22636f7265223b733a333a22372e78223b733a31323a22646570656e64656e63696573223b613a313a7b693a303b733a393a226c6962726172696573223b7d733a363a2268696464656e223b623a313b733a373a2276657273696f6e223b733a373a22372e782d322e31223b733a373a2270726f6a656374223b733a393a226c6962726172696573223b733a393a22646174657374616d70223b733a31303a2231333632383438343132223b733a373a227061636b616765223b733a353a224f74686572223b733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d),
('modules/simpletest/tests/psr_0_test/psr_0_test.module', 'psr_0_test', 'module', '', 0, 0, -1, 0, 0x613a31323a7b733a343a226e616d65223b733a31363a225053522d302054657374206361736573223b733a31313a226465736372697074696f6e223b733a34343a225465737420636c617373657320746f20626520646973636f76657265642062792073696d706c65746573742e223b733a343a22636f7265223b733a333a22372e78223b733a363a2268696464656e223b623a313b733a373a227061636b616765223b733a373a2254657374696e67223b733a373a2276657273696f6e223b733a343a22372e3232223b733a373a2270726f6a656374223b733a363a2264727570616c223b733a393a22646174657374616d70223b733a31303a2231333635303237303132223b733a31323a22646570656e64656e63696573223b613a303a7b7d733a333a22706870223b733a353a22352e322e34223b733a353a2266696c6573223b613a303a7b7d733a393a22626f6f747374726170223b693a303b7d);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `taxonomy_index`
--

CREATE TABLE IF NOT EXISTS `taxonomy_index` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid this record tracks.',
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The term ID.',
  `sticky` tinyint(4) DEFAULT '0' COMMENT 'Boolean indicating whether the node is sticky.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was created.',
  KEY `term_node` (`tid`,`sticky`,`created`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Maintains denormalized information about node/term...';

--
-- Άδειασμα δεδομένων του πίνακα `taxonomy_index`
--

INSERT INTO `taxonomy_index` (`nid`, `tid`, `sticky`, `created`) VALUES
(6, 1, 0, 1337258099),
(5, 2, 0, 1337182581),
(5, 3, 0, 1337182581);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `taxonomy_term_data`
--

CREATE TABLE IF NOT EXISTS `taxonomy_term_data` (
  `tid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique term ID.',
  `vid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The taxonomy_vocabulary.vid of the vocabulary to which the term is assigned.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The term name.',
  `description` longtext COMMENT 'A description of the term.',
  `format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the description.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this term in relation to other terms.',
  PRIMARY KEY (`tid`),
  KEY `taxonomy_tree` (`vid`,`weight`,`name`),
  KEY `vid_name` (`vid`,`name`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores term information.' AUTO_INCREMENT=4 ;

--
-- Άδειασμα δεδομένων του πίνακα `taxonomy_term_data`
--

INSERT INTO `taxonomy_term_data` (`tid`, `vid`, `name`, `description`, `format`, `weight`) VALUES
(1, 2, 'General discussion', '', NULL, 0),
(2, 1, 'Tag 1', NULL, NULL, 0),
(3, 1, 'Tag 2', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `taxonomy_term_hierarchy`
--

CREATE TABLE IF NOT EXISTS `taxonomy_term_hierarchy` (
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: The taxonomy_term_data.tid of the term.',
  `parent` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: The taxonomy_term_data.tid of the term’s parent. 0 indicates no parent.',
  PRIMARY KEY (`tid`,`parent`),
  KEY `parent` (`parent`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores the hierarchical relationship between terms.';

--
-- Άδειασμα δεδομένων του πίνακα `taxonomy_term_hierarchy`
--

INSERT INTO `taxonomy_term_hierarchy` (`tid`, `parent`) VALUES
(1, 0),
(2, 0),
(3, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `taxonomy_vocabulary`
--

CREATE TABLE IF NOT EXISTS `taxonomy_vocabulary` (
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique vocabulary ID.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the vocabulary.',
  `machine_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The vocabulary machine name.',
  `description` longtext COMMENT 'Description of the vocabulary.',
  `hierarchy` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'The type of hierarchy allowed within the vocabulary. (0 = disabled, 1 = single, 2 = multiple)',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'The module which created the vocabulary.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this vocabulary in relation to other vocabularies.',
  PRIMARY KEY (`vid`),
  UNIQUE KEY `machine_name` (`machine_name`),
  KEY `list` (`weight`,`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Stores vocabulary information.' AUTO_INCREMENT=3 ;

--
-- Άδειασμα δεδομένων του πίνακα `taxonomy_vocabulary`
--

INSERT INTO `taxonomy_vocabulary` (`vid`, `name`, `machine_name`, `description`, `hierarchy`, `module`, `weight`) VALUES
(1, 'Tags', 'tags', 'Use tags to group articles on similar topics into categories.', 0, 'taxonomy', 0),
(2, 'Forums', 'forums', 'Forum navigation vocabulary', 1, 'forum', -10);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `url_alias`
--

CREATE TABLE IF NOT EXISTS `url_alias` (
  `pid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'A unique path alias identifier.',
  `source` varchar(255) NOT NULL DEFAULT '' COMMENT 'The Drupal path this alias is for; e.g. node/12.',
  `alias` varchar(255) NOT NULL DEFAULT '' COMMENT 'The alias for this path; e.g. title-of-the-story.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The language this alias is for; if ’und’, the alias will be used for unknown languages. Each Drupal path can have an alias for each supported language.',
  PRIMARY KEY (`pid`),
  KEY `alias_language_pid` (`alias`,`language`,`pid`),
  KEY `source_language_pid` (`source`,`language`,`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='A list of URL aliases for Drupal paths; a user may visit...' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: Unique user ID.',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT 'Unique user name.',
  `pass` varchar(128) NOT NULL DEFAULT '' COMMENT 'User’s password (hashed).',
  `mail` varchar(254) DEFAULT '' COMMENT 'User’s e-mail address.',
  `theme` varchar(255) NOT NULL DEFAULT '' COMMENT 'User’s default theme.',
  `signature` varchar(255) NOT NULL DEFAULT '' COMMENT 'User’s signature.',
  `signature_format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the signature.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp for when user was created.',
  `access` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp for previous time user accessed the site.',
  `login` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp for user’s last login.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether the user is active(1) or blocked(0).',
  `timezone` varchar(32) DEFAULT NULL COMMENT 'User’s time zone.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'User’s default language.',
  `picture` int(11) NOT NULL DEFAULT '0' COMMENT 'Foreign key: file_managed.fid of user’s picture.',
  `init` varchar(254) DEFAULT '' COMMENT 'E-mail address used for initial account creation.',
  `data` longblob COMMENT 'A serialized array of name value pairs that are related to the user. Any form values posted during user edit are stored and are loaded into the $user object during user_load(). Use of this field is discouraged and it will likely disappear in a future...',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `name` (`name`),
  KEY `access` (`access`),
  KEY `created` (`created`),
  KEY `mail` (`mail`),
  KEY `picture` (`picture`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stores user data.';

--
-- Άδειασμα δεδομένων του πίνακα `users`
--

INSERT INTO `users` (`uid`, `name`, `pass`, `mail`, `theme`, `signature`, `signature_format`, `created`, `access`, `login`, `status`, `timezone`, `language`, `picture`, `init`, `data`) VALUES
(0, '', '', '', '', '', NULL, 0, 0, 0, 0, NULL, '', 0, '', NULL),
(1, 'admin', '$S$DippzSLENQTcv5T//1gShEhNRxA7/LikzQzbeALdiftTRpPIZX4/', 'george@morethanthemes.com', '', '', 'filtered_html', 1332184376, 1367392705, 1367391224, 1, 'Europe/Helsinki', '', 1, 'george@morethanthemes.com', 0x613a323a7b733a373a226f7665726c6179223b693a313b733a373a22636f6e74616374223b693a303b7d);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `users_roles`
--

CREATE TABLE IF NOT EXISTS `users_roles` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: users.uid for user.',
  `rid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: role.rid for role.',
  PRIMARY KEY (`uid`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Maps users to roles.';

--
-- Άδειασμα δεδομένων του πίνακα `users_roles`
--

INSERT INTO `users_roles` (`uid`, `rid`) VALUES
(1, 3);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `variable`
--

CREATE TABLE IF NOT EXISTS `variable` (
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT 'The name of the variable.',
  `value` longblob NOT NULL COMMENT 'The value of the variable.',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Named variable/value pairs created by Drupal core or any...';

--
-- Άδειασμα δεδομένων του πίνακα `variable`
--

INSERT INTO `variable` (`name`, `value`) VALUES
('admin_theme', 0x733a353a22736576656e223b),
('clean_url', 0x693a303b),
('color_skeleton_files', 0x613a323a7b693a303b733a34313a227075626c69633a2f2f636f6c6f722f736b656c65746f6e2d61636238326366662f6c6f676f2e706e67223b693a313b733a34333a227075626c69633a2f2f636f6c6f722f736b656c65746f6e2d61636238326366662f636f6c6f72732e637373223b7d),
('color_skeleton_logo', 0x733a34313a227075626c69633a2f2f636f6c6f722f736b656c65746f6e2d61636238326366662f6c6f676f2e706e67223b),
('color_skeleton_palette', 0x613a393a7b733a343a226c696e6b223b733a373a2223323838334445223b733a393a226c696e6b686f766572223b733a373a2223303030303030223b733a383a2268656164696e6773223b733a373a2223313831383138223b733a383a22736974656e616d65223b733a373a2223323632363236223b733a31333a22736974656e616d65686f766572223b733a373a2223333235336164223b733a363a22736c6f67616e223b733a373a2223376437643764223b733a343a2274657874223b733a373a2223343434343434223b733a31303a22626f6479626f72646572223b733a373a2223333735313939223b733a31303a2277726170626f72646572223b733a373a2223343536356265223b7d),
('color_skeleton_stylesheets', 0x613a313a7b693a303b733a34333a227075626c69633a2f2f636f6c6f722f736b656c65746f6e2d61636238326366662f636f6c6f72732e637373223b7d),
('comment_page', 0x693a303b),
('cron_key', 0x733a34333a223257677a303047464e6d37544e476f3869384e4e623665626149375a6a766e61526a3661713243656e3545223b),
('cron_last', 0x693a313336373338393331343b),
('css_js_query_string', 0x733a363a226d6d33797a30223b),
('date_default_timezone', 0x733a31353a224575726f70652f48656c73696e6b69223b),
('default_nodes_main', 0x733a323a223130223b),
('drupal_http_request_fails', 0x623a303b),
('drupal_private_key', 0x733a34333a2236457631776a523258557158414d2d5a584b44527a746d627a73576a57354d7549475270553249597a5741223b),
('field_bundle_settings_node__blog', 0x613a323a7b733a31303a22766965775f6d6f646573223b613a303a7b7d733a31323a2265787472615f6669656c6473223b613a323a7b733a343a22666f726d223b613a313a7b733a353a227469746c65223b613a313a7b733a363a22776569676874223b733a323a222d35223b7d7d733a373a22646973706c6179223b613a303a7b7d7d7d),
('file_temporary_path', 0x733a343a222f746d70223b),
('filter_fallback_format', 0x733a31303a22706c61696e5f74657874223b),
('forum_nav_vocabulary', 0x733a313a2232223b),
('install_profile', 0x733a383a227374616e64617264223b),
('install_task', 0x733a343a22646f6e65223b),
('install_time', 0x693a313333323138353230373b),
('maintenance_mode', 0x623a303b),
('menu_expanded', 0x613a313a7b693a303b733a393a226d61696e2d6d656e75223b7d),
('menu_masks', 0x613a33343a7b693a303b693a3530313b693a313b693a3439333b693a323b693a3235303b693a333b693a3234373b693a343b693a3234363b693a353b693a3234353b693a363b693a3132353b693a373b693a3132333b693a383b693a3132323b693a393b693a3132313b693a31303b693a3131373b693a31313b693a36333b693a31323b693a36323b693a31333b693a36313b693a31343b693a36303b693a31353b693a35393b693a31363b693a35383b693a31373b693a34343b693a31383b693a33313b693a31393b693a33303b693a32303b693a32393b693a32313b693a32383b693a32323b693a32343b693a32333b693a32313b693a32343b693a31353b693a32353b693a31343b693a32363b693a31333b693a32373b693a31313b693a32383b693a373b693a32393b693a363b693a33303b693a353b693a33313b693a333b693a33323b693a323b693a33333b693a313b7d),
('superfish_expanded_1', 0x693a303b),
('node_admin_theme', 0x733a313a2231223b),
('node_cron_last', 0x733a31303a2231333337333336353533223b),
('node_options_forum', 0x613a313a7b693a303b733a363a22737461747573223b7d),
('node_options_page', 0x613a313a7b693a303b733a363a22737461747573223b7d),
('node_submitted_page', 0x623a303b),
('path_alias_whitelist', 0x613a303a7b7d),
('site_403', 0x733a303a22223b),
('site_404', 0x733a303a22223b),
('site_default_country', 0x733a303a22223b),
('site_frontpage', 0x733a363a226e6f64652f31223b),
('site_mail', 0x733a32353a2267656f726765406d6f72657468616e7468656d65732e636f6d223b),
('site_name', 0x733a383a22736b656c65746f6e223b),
('site_slogan', 0x733a36323a224120526573706f6e73697665205468656d6520706f7274656420746f2044727570616c206279204d6f7265207468616e20286a75737429205468656d6573223b),
('theme_default', 0x733a31333a22736b656c65746f6e7468656d65223b),
('theme_settings', 0x613a31353a7b733a31313a22746f67676c655f6c6f676f223b693a313b733a31313a22746f67676c655f6e616d65223b693a313b733a31333a22746f67676c655f736c6f67616e223b693a313b733a32343a22746f67676c655f6e6f64655f757365725f70696374757265223b693a313b733a32373a22746f67676c655f636f6d6d656e745f757365725f70696374757265223b693a313b733a33323a22746f67676c655f636f6d6d656e745f757365725f766572696669636174696f6e223b693a313b733a31343a22746f67676c655f66617669636f6e223b693a313b733a31363a22746f67676c655f6d61696e5f6d656e75223b693a313b733a32313a22746f67676c655f7365636f6e646172795f6d656e75223b693a313b733a31323a2264656661756c745f6c6f676f223b693a313b733a393a226c6f676f5f70617468223b733a303a22223b733a31313a226c6f676f5f75706c6f6164223b733a303a22223b733a31353a2264656661756c745f66617669636f6e223b693a313b733a31323a2266617669636f6e5f70617468223b733a303a22223b733a31343a2266617669636f6e5f75706c6f6164223b733a303a22223b7d),
('theme_skeletontheme_settings', 0x613a32333a7b733a31313a22746f67676c655f6c6f676f223b693a303b733a31313a22746f67676c655f6e616d65223b693a313b733a31333a22746f67676c655f736c6f67616e223b693a313b733a32343a22746f67676c655f6e6f64655f757365725f70696374757265223b693a303b733a32373a22746f67676c655f636f6d6d656e745f757365725f70696374757265223b693a313b733a33323a22746f67676c655f636f6d6d656e745f757365725f766572696669636174696f6e223b693a313b733a31343a22746f67676c655f66617669636f6e223b693a313b733a31363a22746f67676c655f6d61696e5f6d656e75223b693a313b733a32313a22746f67676c655f7365636f6e646172795f6d656e75223b693a313b733a31323a2264656661756c745f6c6f676f223b693a313b733a393a226c6f676f5f70617468223b733a303a22223b733a31313a226c6f676f5f75706c6f6164223b733a303a22223b733a31353a2264656661756c745f66617669636f6e223b693a313b733a31323a2266617669636f6e5f70617468223b733a303a22223b733a31343a2266617669636f6e5f75706c6f6164223b733a303a22223b733a32313a22726573706f6e736976655f6d656e755f7374617465223b693a313b733a32373a22726573706f6e736976655f6d656e755f7377697463687769647468223b733a333a22373630223b733a32393a22726573706f6e736976655f6d656e755f746f706f7074696f6e74657874223b733a31333a2253656c65637420612070616765223b733a31363a22746162735f5f6163746976655f746162223b733a32303a22656469742d726573706f6e736976652d6d656e75223b733a363a22736368656d65223b733a373a2264656661756c74223b733a373a2270616c65747465223b613a31313a7b733a343a2274657874223b733a373a2223343434343434223b733a343a226c696e6b223b733a373a2223323838334445223b733a393a226c696e6b686f766572223b733a373a2223303030303030223b733a383a2268656164696e6773223b733a373a2223313831383138223b733a383a22736974656e616d65223b733a373a2223323632363236223b733a31333a22736974656e616d65686f766572223b733a373a2223333235336164223b733a363a22736c6f67616e223b733a373a2223376437643764223b733a31303a22626f6479626f72646572223b733a373a2223333735313939223b733a31303a2277726170626f72646572223b733a373a2223343536356265223b733a31323a22666f6f746572626f72646572223b733a373a2223643664366436223b733a31363a22666f6f7465726261636b67726f756e64223b733a373a2223666666666666223b7d733a353a227468656d65223b733a31333a22736b656c65746f6e7468656d65223b733a343a22696e666f223b613a31323a7b733a363a226669656c6473223b613a31313a7b733a343a2274657874223b733a31303a225465787420636f6c6f72223b733a343a226c696e6b223b733a31313a224c696e6b7320636f6c6f72223b733a393a226c696e6b686f766572223b733a31373a224c696e6b7320686f76657220636f6c6f72223b733a383a2268656164696e6773223b733a31343a2248656164696e677320636f6c6f72223b733a383a22736974656e616d65223b733a31353a22536974652d6e616d6520636f6c6f72223b733a31333a22736974656e616d65686f766572223b733a32313a22536974652d6e616d6520686f76657220636f6c6f72223b733a363a22736c6f67616e223b733a31323a22536c6f67616e20636f6c6f72223b733a31303a22626f6479626f72646572223b733a32313a22426f647920626f7264657220746f7020636f6c6f72223b733a31303a2277726170626f72646572223b733a32343a22436f6e74656e7420626f7264657220746f7020636f6c6f72223b733a31323a22666f6f746572626f72646572223b733a32333a22466f6f74657220626f7264657220746f7020636f6c6f72223b733a31363a22666f6f7465726261636b67726f756e64223b733a32333a22466f6f746572206261636b67726f756e6420636f6c6f72223b7d733a373a22736368656d6573223b613a343a7b733a373a2264656661756c74223b613a323a7b733a353a227469746c65223b733a373a2244656661756c74223b733a363a22636f6c6f7273223b613a31313a7b733a343a2274657874223b733a373a2223343434343434223b733a343a226c696e6b223b733a373a2223323838334445223b733a393a226c696e6b686f766572223b733a373a2223303030303030223b733a383a2268656164696e6773223b733a373a2223313831383138223b733a383a22736974656e616d65223b733a373a2223323632363236223b733a31333a22736974656e616d65686f766572223b733a373a2223333235336164223b733a363a22736c6f67616e223b733a373a2223376437643764223b733a31303a22626f6479626f72646572223b733a373a2223333735313939223b733a31303a2277726170626f72646572223b733a373a2223343536356265223b733a31323a22666f6f746572626f72646572223b733a373a2223643664366436223b733a31363a22666f6f7465726261636b67726f756e64223b733a373a2223666666666666223b7d7d733a31313a22636f726f6e616d75736963223b613a323a7b733a353a227469746c65223b733a31323a22436f726f6e61204d75736963223b733a363a22636f6c6f7273223b613a31313a7b733a343a2274657874223b733a373a2223313031303130223b733a343a226c696e6b223b733a373a2223653239333030223b733a393a226c696e6b686f766572223b733a373a2223653239333030223b733a383a2268656164696e6773223b733a373a2223313031303130223b733a383a22736974656e616d65223b733a373a2223313934393733223b733a31333a22736974656e616d65686f766572223b733a373a2223323633393733223b733a363a22736c6f67616e223b733a373a2223313031303130223b733a31303a22626f6479626f72646572223b733a373a2223313934393733223b733a31303a2277726170626f72646572223b733a373a2223653239333030223b733a31323a22666f6f746572626f72646572223b733a373a2223643664366436223b733a31363a22666f6f7465726261636b67726f756e64223b733a373a2223666666666666223b7d7d733a31343a2265617379636f6d6565617379676f223b613a323a7b733a353a227469746c65223b733a31373a224561737920436f6d65204561737920476f223b733a363a22636f6c6f7273223b613a31313a7b733a343a2274657874223b733a373a2223313631363136223b733a343a226c696e6b223b733a373a2223623532633338223b733a393a226c696e6b686f766572223b733a373a2223623532633338223b733a383a2268656164696e6773223b733a373a2223353336363832223b733a383a22736974656e616d65223b733a373a2223353336363832223b733a31333a22736974656e616d65686f766572223b733a373a2223353336363832223b733a363a22736c6f67616e223b733a373a2223313631363136223b733a31303a22626f6479626f72646572223b733a373a2223646536383436223b733a31303a2277726170626f72646572223b733a373a2223643939363462223b733a31323a22666f6f746572626f72646572223b733a373a2223643664366436223b733a31363a22666f6f7465726261636b67726f756e64223b733a373a2223666666666666223b7d7d733a303a22223b613a323a7b733a353a227469746c65223b733a363a22437573746f6d223b733a363a22636f6c6f7273223b613a303a7b7d7d7d733a333a22637373223b613a313a7b693a303b733a31363a22636f6c6f722f636f6c6f72732e637373223b7d733a343a22636f7079223b613a313a7b693a303b733a383a226c6f676f2e706e67223b7d733a393a226772616469656e7473223b613a313a7b693a303b613a333a7b733a393a2264696d656e73696f6e223b613a343a7b693a303b693a303b693a313b693a303b693a323b693a303b693a333b693a303b7d733a393a22646972656374696f6e223b733a383a22766572746963616c223b733a363a22636f6c6f7273223b613a323a7b693a303b733a333a22746f70223b693a313b733a363a22626f74746f6d223b7d7d7d733a343a2266696c6c223b613a303a7b7d733a363a22736c69636573223b613a303a7b7d733a31323a22626c656e645f746172676574223b733a373a2223666666666666223b733a31313a22707265766965775f637373223b733a31373a22636f6c6f722f707265766965772e637373223b733a31303a22707265766965775f6a73223b733a31363a22636f6c6f722f707265766965772e6a73223b733a31323a22707265766965775f68746d6c223b733a31383a22636f6c6f722f707265766965772e68746d6c223b733a31303a22626173655f696d616765223b733a31343a22636f6c6f722f626173652e706e67223b7d7d),
('theme_skeleton_settings', 0x613a31393a7b733a31313a22746f67676c655f6c6f676f223b693a303b733a31313a22746f67676c655f6e616d65223b693a313b733a31333a22746f67676c655f736c6f67616e223b693a313b733a32343a22746f67676c655f6e6f64655f757365725f70696374757265223b693a303b733a32373a22746f67676c655f636f6d6d656e745f757365725f70696374757265223b693a313b733a33323a22746f67676c655f636f6d6d656e745f757365725f766572696669636174696f6e223b693a313b733a31343a22746f67676c655f66617669636f6e223b693a313b733a31363a22746f67676c655f6d61696e5f6d656e75223b693a313b733a32313a22746f67676c655f7365636f6e646172795f6d656e75223b693a313b733a31323a2264656661756c745f6c6f676f223b693a313b733a393a226c6f676f5f70617468223b733a303a22223b733a31313a226c6f676f5f75706c6f6164223b733a303a22223b733a31353a2264656661756c745f66617669636f6e223b693a313b733a31323a2266617669636f6e5f70617468223b733a303a22223b733a31343a2266617669636f6e5f75706c6f6164223b733a303a22223b733a363a22736368656d65223b733a373a2264656661756c74223b733a373a2270616c65747465223b613a393a7b733a343a226c696e6b223b733a373a2223323838334445223b733a393a226c696e6b686f766572223b733a373a2223303030303030223b733a383a2268656164696e6773223b733a373a2223313831383138223b733a383a22736974656e616d65223b733a373a2223323632363236223b733a31333a22736974656e616d65686f766572223b733a373a2223333235336164223b733a363a22736c6f67616e223b733a373a2223376437643764223b733a343a2274657874223b733a373a2223343434343434223b733a31303a22626f6479626f72646572223b733a373a2223333735313939223b733a31303a2277726170626f72646572223b733a373a2223343536356265223b7d733a353a227468656d65223b733a383a22736b656c65746f6e223b733a343a22696e666f223b613a31323a7b733a363a226669656c6473223b613a393a7b733a343a2274657874223b733a31303a225465787420636f6c6f72223b733a343a226c696e6b223b733a31313a224c696e6b7320636f6c6f72223b733a393a226c696e6b686f766572223b733a31373a224c696e6b7320686f76657220636f6c6f72223b733a383a2268656164696e6773223b733a31343a2248656164696e677320636f6c6f72223b733a383a22736974656e616d65223b733a31353a22536974652d6e616d6520636f6c6f72223b733a31333a22736974656e616d65686f766572223b733a32313a22536974652d6e616d6520686f76657220636f6c6f72223b733a363a22736c6f67616e223b733a31323a22536c6f67616e20636f6c6f72223b733a31303a22626f6479626f72646572223b733a32313a22426f647920626f7264657220746f7020636f6c6f72223b733a31303a2277726170626f72646572223b733a32343a22436f6e74656e7420626f7264657220746f7020636f6c6f72223b7d733a373a22736368656d6573223b613a343a7b733a373a2264656661756c74223b613a323a7b733a353a227469746c65223b733a373a2244656661756c74223b733a363a22636f6c6f7273223b613a393a7b733a343a2274657874223b733a373a2223343434343434223b733a343a226c696e6b223b733a373a2223323838334445223b733a393a226c696e6b686f766572223b733a373a2223303030303030223b733a383a2268656164696e6773223b733a373a2223313831383138223b733a383a22736974656e616d65223b733a373a2223323632363236223b733a31333a22736974656e616d65686f766572223b733a373a2223333235336164223b733a363a22736c6f67616e223b733a373a2223376437643764223b733a31303a22626f6479626f72646572223b733a373a2223333735313939223b733a31303a2277726170626f72646572223b733a373a2223343536356265223b7d7d733a31313a22636f726f6e616d75736963223b613a323a7b733a353a227469746c65223b733a31323a22436f726f6e61204d75736963223b733a363a22636f6c6f7273223b613a393a7b733a343a2274657874223b733a373a2223313031303130223b733a343a226c696e6b223b733a373a2223653239333030223b733a393a226c696e6b686f766572223b733a373a2223653239333030223b733a383a2268656164696e6773223b733a373a2223313031303130223b733a383a22736974656e616d65223b733a373a2223313934393733223b733a31333a22736974656e616d65686f766572223b733a373a2223323633393733223b733a363a22736c6f67616e223b733a373a2223313031303130223b733a31303a22626f6479626f72646572223b733a373a2223313934393733223b733a31303a2277726170626f72646572223b733a373a2223653239333030223b7d7d733a31343a2265617379636f6d6565617379676f223b613a323a7b733a353a227469746c65223b733a31373a224561737920436f6d65204561737920476f223b733a363a22636f6c6f7273223b613a393a7b733a343a2274657874223b733a373a2223313631363136223b733a343a226c696e6b223b733a373a2223623532633338223b733a393a226c696e6b686f766572223b733a373a2223623532633338223b733a383a2268656164696e6773223b733a373a2223353336363832223b733a383a22736974656e616d65223b733a373a2223353336363832223b733a31333a22736974656e616d65686f766572223b733a373a2223353336363832223b733a363a22736c6f67616e223b733a373a2223313631363136223b733a31303a22626f6479626f72646572223b733a373a2223646536383436223b733a31303a2277726170626f72646572223b733a373a2223643939363462223b7d7d733a303a22223b613a323a7b733a353a227469746c65223b733a363a22437573746f6d223b733a363a22636f6c6f7273223b613a303a7b7d7d7d733a333a22637373223b613a313a7b693a303b733a31363a22636f6c6f722f636f6c6f72732e637373223b7d733a343a22636f7079223b613a313a7b693a303b733a383a226c6f676f2e706e67223b7d733a393a226772616469656e7473223b613a313a7b693a303b613a333a7b733a393a2264696d656e73696f6e223b613a343a7b693a303b693a303b693a313b693a303b693a323b693a303b693a333b693a303b7d733a393a22646972656374696f6e223b733a383a22766572746963616c223b733a363a22636f6c6f7273223b613a323a7b693a303b733a333a22746f70223b693a313b733a363a22626f74746f6d223b7d7d7d733a343a2266696c6c223b613a303a7b7d733a363a22736c69636573223b613a303a7b7d733a31323a22626c656e645f746172676574223b733a373a2223666666666666223b733a31313a22707265766965775f637373223b733a31373a22636f6c6f722f707265766965772e637373223b733a31303a22707265766965775f6a73223b733a31363a22636f6c6f722f707265766965772e6a73223b733a31323a22707265766965775f68746d6c223b733a31383a22636f6c6f722f707265766965772e68746d6c223b733a31303a22626173655f696d616765223b733a31343a22636f6c6f722f626173652e706e67223b7d7d),
('update_last_check', 0x693a313336373339313239333b),
('update_notify_emails', 0x613a313a7b693a303b733a32353a2267656f726765406d6f72657468616e7468656d65732e636f6d223b7d),
('user_admin_role', 0x733a313a2233223b),
('user_pictures', 0x693a313b),
('user_picture_dimensions', 0x733a393a22313032347831303234223b),
('user_picture_file_size', 0x733a333a22383030223b),
('user_picture_style', 0x733a393a227468756d626e61696c223b),
('user_register', 0x733a313a2230223b),
('cache_flush_cache_path', 0x693a303b),
('preprocess_css', 0x693a303b),
('preprocess_js', 0x693a303b),
('cache_flush_cache_block', 0x693a313336343331373031303b),
('cache_flush_cache_field', 0x693a313336343331363635343b),
('cache_flush_cache_image', 0x693a303b),
('cache_flush_cache', 0x693a313336343331363635343b),
('cache_lifetime', 0x733a313a2230223b),
('page_cache_maximum_age', 0x733a313a2230223b),
('block_cache', 0x693a303b),
('page_compression', 0x693a303b),
('cache', 0x693a303b),
('cache_flush_cache_filter', 0x693a313336343331363635343b),
('cache_flush_cache_page', 0x693a313336343331373031303b),
('cache_flush_cache_form', 0x693a303b),
('cache_flush_cache_menu', 0x693a313336343331363635343b),
('anonymous', 0x733a393a22416e6f6e796d6f7573223b),
('user_email_verification', 0x693a313b),
('user_cancel_method', 0x733a31373a22757365725f63616e63656c5f626c6f636b223b),
('user_signatures', 0x693a303b),
('user_picture_path', 0x733a383a227069637475726573223b),
('user_picture_default', 0x733a303a22223b),
('user_picture_guidelines', 0x733a303a22223b),
('email__active_tab', 0x733a32343a22656469742d656d61696c2d61646d696e2d63726561746564223b),
('user_mail_register_admin_created_subject', 0x733a35383a22416e2061646d696e6973747261746f72206372656174656420616e206163636f756e7420666f7220796f75206174205b736974653a6e616d655d223b),
('user_mail_register_admin_created_body', 0x733a3437363a225b757365723a6e616d655d2c0d0a0d0a4120736974652061646d696e6973747261746f72206174205b736974653a6e616d655d20686173206372656174656420616e206163636f756e7420666f7220796f752e20596f75206d6179206e6f77206c6f6720696e20627920636c69636b696e672074686973206c696e6b206f7220636f7079696e6720616e642070617374696e6720697420746f20796f75722062726f777365723a0d0a0d0a5b757365723a6f6e652d74696d652d6c6f67696e2d75726c5d0d0a0d0a54686973206c696e6b2063616e206f6e6c792062652075736564206f6e636520746f206c6f6720696e20616e642077696c6c206c65616420796f7520746f2061207061676520776865726520796f752063616e2073657420796f75722070617373776f72642e0d0a0d0a41667465722073657474696e6720796f75722070617373776f72642c20796f752077696c6c2062652061626c6520746f206c6f6720696e206174205b736974653a6c6f67696e2d75726c5d20696e2074686520667574757265207573696e673a0d0a0d0a757365726e616d653a205b757365723a6e616d655d0d0a70617373776f72643a20596f75722070617373776f72640d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_register_pending_approval_subject', 0x733a37313a224163636f756e742064657461696c7320666f72205b757365723a6e616d655d206174205b736974653a6e616d655d202870656e64696e672061646d696e20617070726f76616c29223b),
('user_mail_register_pending_approval_body', 0x733a3238373a225b757365723a6e616d655d2c0d0a0d0a5468616e6b20796f7520666f72207265676973746572696e67206174205b736974653a6e616d655d2e20596f7572206170706c69636174696f6e20666f7220616e206163636f756e742069732063757272656e746c792070656e64696e6720617070726f76616c2e204f6e636520697420686173206265656e20617070726f7665642c20796f752077696c6c207265636569766520616e6f7468657220652d6d61696c20636f6e7461696e696e6720696e666f726d6174696f6e2061626f757420686f7720746f206c6f6720696e2c2073657420796f75722070617373776f72642c20616e64206f746865722064657461696c732e0d0a0d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_register_no_approval_required_subject', 0x733a34363a224163636f756e742064657461696c7320666f72205b757365723a6e616d655d206174205b736974653a6e616d655d223b),
('user_mail_register_no_approval_required_body', 0x733a3435303a225b757365723a6e616d655d2c0d0a0d0a5468616e6b20796f7520666f72207265676973746572696e67206174205b736974653a6e616d655d2e20596f75206d6179206e6f77206c6f6720696e20627920636c69636b696e672074686973206c696e6b206f7220636f7079696e6720616e642070617374696e6720697420746f20796f75722062726f777365723a0d0a0d0a5b757365723a6f6e652d74696d652d6c6f67696e2d75726c5d0d0a0d0a54686973206c696e6b2063616e206f6e6c792062652075736564206f6e636520746f206c6f6720696e20616e642077696c6c206c65616420796f7520746f2061207061676520776865726520796f752063616e2073657420796f75722070617373776f72642e0d0a0d0a41667465722073657474696e6720796f75722070617373776f72642c20796f752077696c6c2062652061626c6520746f206c6f6720696e206174205b736974653a6c6f67696e2d75726c5d20696e2074686520667574757265207573696e673a0d0a0d0a757365726e616d653a205b757365723a6e616d655d0d0a70617373776f72643a20596f75722070617373776f72640d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_password_reset_subject', 0x733a36303a225265706c6163656d656e74206c6f67696e20696e666f726d6174696f6e20666f72205b757365723a6e616d655d206174205b736974653a6e616d655d223b),
('user_mail_password_reset_body', 0x733a3430373a225b757365723a6e616d655d2c0d0a0d0a41207265717565737420746f207265736574207468652070617373776f726420666f7220796f7572206163636f756e7420686173206265656e206d616465206174205b736974653a6e616d655d2e0d0a0d0a596f75206d6179206e6f77206c6f6720696e20627920636c69636b696e672074686973206c696e6b206f7220636f7079696e6720616e642070617374696e6720697420746f20796f75722062726f777365723a0d0a0d0a5b757365723a6f6e652d74696d652d6c6f67696e2d75726c5d0d0a0d0a54686973206c696e6b2063616e206f6e6c792062652075736564206f6e636520746f206c6f6720696e20616e642077696c6c206c65616420796f7520746f2061207061676520776865726520796f752063616e2073657420796f75722070617373776f72642e2049742065787069726573206166746572206f6e652064617920616e64206e6f7468696e672077696c6c2068617070656e2069662069742773206e6f7420757365642e0d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_status_activated_notify', 0x693a313b),
('user_mail_status_activated_subject', 0x733a35373a224163636f756e742064657461696c7320666f72205b757365723a6e616d655d206174205b736974653a6e616d655d2028617070726f76656429223b),
('user_mail_status_activated_body', 0x733a3436313a225b757365723a6e616d655d2c0d0a0d0a596f7572206163636f756e74206174205b736974653a6e616d655d20686173206265656e206163746976617465642e0d0a0d0a596f75206d6179206e6f77206c6f6720696e20627920636c69636b696e672074686973206c696e6b206f7220636f7079696e6720616e642070617374696e6720697420696e746f20796f75722062726f777365723a0d0a0d0a5b757365723a6f6e652d74696d652d6c6f67696e2d75726c5d0d0a0d0a54686973206c696e6b2063616e206f6e6c792062652075736564206f6e636520746f206c6f6720696e20616e642077696c6c206c65616420796f7520746f2061207061676520776865726520796f752063616e2073657420796f75722070617373776f72642e0d0a0d0a41667465722073657474696e6720796f75722070617373776f72642c20796f752077696c6c2062652061626c6520746f206c6f6720696e206174205b736974653a6c6f67696e2d75726c5d20696e2074686520667574757265207573696e673a0d0a0d0a757365726e616d653a205b757365723a6e616d655d0d0a70617373776f72643a20596f75722070617373776f72640d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_status_blocked_notify', 0x693a303b),
('user_mail_status_blocked_subject', 0x733a35363a224163636f756e742064657461696c7320666f72205b757365723a6e616d655d206174205b736974653a6e616d655d2028626c6f636b656429223b),
('user_mail_status_blocked_body', 0x733a38353a225b757365723a6e616d655d2c0d0a0d0a596f7572206163636f756e74206f6e205b736974653a6e616d655d20686173206265656e20626c6f636b65642e0d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_cancel_confirm_subject', 0x733a35393a224163636f756e742063616e63656c6c6174696f6e207265717565737420666f72205b757365723a6e616d655d206174205b736974653a6e616d655d223b),
('user_mail_cancel_confirm_body', 0x733a3338313a225b757365723a6e616d655d2c0d0a0d0a41207265717565737420746f2063616e63656c20796f7572206163636f756e7420686173206265656e206d616465206174205b736974653a6e616d655d2e0d0a0d0a596f75206d6179206e6f772063616e63656c20796f7572206163636f756e74206f6e205b736974653a75726c2d62726965665d20627920636c69636b696e672074686973206c696e6b206f7220636f7079696e6720616e642070617374696e6720697420696e746f20796f75722062726f777365723a0d0a0d0a5b757365723a63616e63656c2d75726c5d0d0a0d0a4e4f54453a205468652063616e63656c6c6174696f6e206f6620796f7572206163636f756e74206973206e6f742072657665727369626c652e0d0a0d0a54686973206c696e6b206578706972657320696e206f6e652064617920616e64206e6f7468696e672077696c6c2068617070656e206966206974206973206e6f7420757365642e0d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('user_mail_status_canceled_notify', 0x693a303b),
('user_mail_status_canceled_subject', 0x733a35373a224163636f756e742064657461696c7320666f72205b757365723a6e616d655d206174205b736974653a6e616d655d202863616e63656c656429223b),
('user_mail_status_canceled_body', 0x733a38363a225b757365723a6e616d655d2c0d0a0d0a596f7572206163636f756e74206f6e205b736974653a6e616d655d20686173206265656e2063616e63656c65642e0d0a0d0a2d2d20205b736974653a6e616d655d207465616d223b),
('contact_default_status', 0x693a313b),
('file_public_path', 0x733a31393a2273697465732f64656661756c742f66696c6573223b),
('file_private_path', 0x733a303a22223b),
('file_default_scheme', 0x733a363a227075626c6963223b),
('superfish_name_1', 0x733a31313a225375706572666973682031223b),
('superfish_menu_1', 0x733a31313a226d61696e2d6d656e753a30223b),
('superfish_depth_1', 0x733a323a222d31223b),
('superfish_type_1', 0x733a31303a22686f72697a6f6e74616c223b),
('superfish_style_1', 0x733a343a226e6f6e65223b),
('superfish_speed_1', 0x733a343a2266617374223b),
('superfish_delay_1', 0x733a333a22383030223b),
('superfish_pathclass_1', 0x733a31323a226163746976652d747261696c223b),
('superfish_pathlevels_1', 0x733a313a2231223b),
('superfish_slide_1', 0x733a343a226e6f6e65223b),
('superfish_arrow_1', 0x693a303b),
('superfish_shadow_1', 0x693a313b),
('superfish_bgf_1', 0x693a303b),
('superfish_spp_1', 0x693a303b),
('superfish_hid_1', 0x693a313b),
('superfish_touch_1', 0x733a313a2230223b),
('superfish_touchua_1', 0x733a313a2230223b),
('superfish_touchual_1', 0x733a303a22223b),
('superfish_supersubs_1', 0x693a313b),
('superfish_minwidth_1', 0x733a323a223137223b),
('superfish_maxwidth_1', 0x733a323a223237223b),
('superfish_multicolumn_1', 0x693a303b),
('superfish_mcexclude_1', 0x733a303a22223b),
('superfish_mcdepth_1', 0x733a313a2231223b),
('superfish_mclevels_1', 0x733a313a2231223b),
('superfish_firstlast_1', 0x693a313b),
('superfish_zebra_1', 0x693a313b),
('superfish_dfirstlast_1', 0x693a303b),
('superfish_dzebra_1', 0x693a303b),
('superfish_itemcount_1', 0x693a313b),
('superfish_itemcounter_1', 0x693a313b),
('superfish_itemdepth_1', 0x693a313b),
('superfish_hldescription_1', 0x693a303b),
('superfish_hldmenus_1', 0x733a303a22223b),
('superfish_hldexclude_1', 0x733a303a22223b),
('superfish_wrapmul_1', 0x733a303a22223b),
('superfish_wrapul_1', 0x733a303a22223b),
('superfish_wraphl_1', 0x733a303a22223b),
('superfish_wraphlt_1', 0x733a303a22223b),
('superfish_ulclass_1', 0x733a303a22223b),
('superfish_liclass_1', 0x733a303a22223b),
('superfish_hlclass_1', 0x733a303a22223b),
('superfish_pathcss_1', 0x733a303a22223b),
('cache_flush_cache_libraries', 0x693a303b),
('superfish_smalluam_1', 0x733a313a2230223b),
('superfish_smallset_1', 0x733a303a22223b),
('superfish_smallasa_1', 0x693a303b),
('superfish_smallcmc_1', 0x693a303b),
('superfish_smallecm_1', 0x733a303a22223b),
('superfish_smallchc_1', 0x693a303b),
('superfish_smallech_1', 0x733a303a22223b),
('superfish_touchuam_1', 0x733a313a2230223b),
('superfish_small_1', 0x733a313a2230223b),
('superfish_smallbp_1', 0x733a333a22373638223b),
('update_last_email_notification', 0x693a313336373335333336383b),
('superfish_smallua_1', 0x733a313a2230223b),
('superfish_smallual_1', 0x733a303a22223b),
('superfish_touchbp_1', 0x733a333a22373638223b),
('superfish_smallicm_1', 0x733a303a22223b),
('superfish_smallich_1', 0x733a303a22223b),
('superfish_use_link_theme_1', 0x693a313b),
('superfish_use_item_theme_1', 0x693a313b),
('superfish_hhldescription_1', 0x693a303b);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `watchdog`
--

CREATE TABLE IF NOT EXISTS `watchdog` (
  `wid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique watchdog event ID.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid of the user who triggered the event.',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT 'Type of log message, for example "user" or "page not found."',
  `message` longtext NOT NULL COMMENT 'Text of log message to be passed into the t() function.',
  `variables` longblob NOT NULL COMMENT 'Serialized array of variables that match the message string and that is passed into the t() function.',
  `severity` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'The severity level of the event; ranges from 0 (Emergency) to 7 (Debug)',
  `link` varchar(255) DEFAULT '' COMMENT 'Link to view the result of the event.',
  `location` text NOT NULL COMMENT 'URL of the origin of the event.',
  `referer` text COMMENT 'URL of referring page.',
  `hostname` varchar(128) NOT NULL DEFAULT '' COMMENT 'Hostname of the user who triggered the event.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'Unix timestamp of when event occurred.',
  PRIMARY KEY (`wid`),
  KEY `type` (`type`),
  KEY `uid` (`uid`),
  KEY `severity` (`severity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Table that contains logs of all system events.' AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
