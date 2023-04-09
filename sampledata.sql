/*
 Navicat MySQL Data Transfer

 Source Server         : finalyearproject
 Source Server Type    : MySQL
 Source Server Version : 80032 (8.0.32)
 Source Host           : localhost:3306
 Source Schema         : attendance

 Target Server Type    : MySQL
 Target Server Version : 80032 (8.0.32)
 File Encoding         : 65001

 Date: 07/04/2023 02:33:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('00a189013e5a');

-- ----------------------------
-- Table structure for attendance
-- ----------------------------
DROP TABLE IF EXISTS `attendance`;
CREATE TABLE `attendance`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cs_id` int NOT NULL,
  `stu_id` int NOT NULL,
  `att_at` datetime NOT NULL,
  `att_status` enum('0','1','2') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attendance
-- ----------------------------
INSERT INTO `attendance` VALUES (1, 1, 6, '2023-03-10 16:40:00', '2');
INSERT INTO `attendance` VALUES (2, 2, 6, '2023-03-22 10:00:00', '0');
INSERT INTO `attendance` VALUES (3, 3, 6, '2023-03-18 19:57:11', '0');
INSERT INTO `attendance` VALUES (4, 4, 6, '2023-03-25 23:59:53', '0');
INSERT INTO `attendance` VALUES (5, 6, 6, '2023-03-24 18:17:40', '0');
INSERT INTO `attendance` VALUES (6, 5, 6, '2023-03-02 20:32:40', '2');
INSERT INTO `attendance` VALUES (7, 7, 13, '2023-03-23 17:56:01', '0');
INSERT INTO `attendance` VALUES (8, 8, 8, '2023-03-27 18:02:33', '1');
INSERT INTO `attendance` VALUES (9, 7, 8, '2023-03-10 18:24:23', '0');
INSERT INTO `attendance` VALUES (10, 4, 8, '2023-03-17 18:25:06', '2');
INSERT INTO `attendance` VALUES (11, 9, 6, '2023-03-22 13:00:00', '1');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `teacher_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, 'CS101', 2);
INSERT INTO `course` VALUES (2, 'CS102', 2);
INSERT INTO `course` VALUES (3, 'CS103', 2);
INSERT INTO `course` VALUES (4, 'CS104', 2);
INSERT INTO `course` VALUES (6, 'CS105', 2);
INSERT INTO `course` VALUES (7, 'CS106', 2);
INSERT INTO `course` VALUES (8, 'CS107', 2);
INSERT INTO `course` VALUES (9, 'CS108', 2);
INSERT INTO `course` VALUES (12, 'CS109', 2);
INSERT INTO `course` VALUES (13, 'CS110', 2);
INSERT INTO `course` VALUES (14, 'CS111', 12);
INSERT INTO `course` VALUES (15, 'CS112', 2);

-- ----------------------------
-- Table structure for course_session
-- ----------------------------
DROP TABLE IF EXISTS `course_session`;
CREATE TABLE `course_session`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `begin_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_session
-- ----------------------------
INSERT INTO `course_session` VALUES (1, 2, '2023-01-02 12:00:00', '2023-01-02 14:00:00');
INSERT INTO `course_session` VALUES (2, 4, '2023-01-04 12:00:00', '2023-01-04 14:00:00');
INSERT INTO `course_session` VALUES (3, 8, '2023-01-08 12:00:00', '2023-01-08 14:00:00');
INSERT INTO `course_session` VALUES (4, 4, '2023-02-01 12:00:00', '2023-02-01 14:00:00');
INSERT INTO `course_session` VALUES (5, 6, '2023-02-12 12:00:00', '2023-02-12 14:00:00');
INSERT INTO `course_session` VALUES (6, 14, '2023-03-22 12:00:00', '2023-03-22 14:00:00');
INSERT INTO `course_session` VALUES (7, 4, '2023-04-02 12:00:00', '2023-04-02 14:00:00');
INSERT INTO `course_session` VALUES (8, 4, '2023-04-03 12:00:00', '2023-04-03 14:00:00');
INSERT INTO `course_session` VALUES (9, 14, '2023-03-22 12:00:00', '2023-03-22 14:00:00');

-- ----------------------------
-- Table structure for enrollment
-- ----------------------------
DROP TABLE IF EXISTS `enrollment`;
CREATE TABLE `enrollment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL,
  `stu_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enrollment
-- ----------------------------
INSERT INTO `enrollment` VALUES (1, 4, 5);
INSERT INTO `enrollment` VALUES (2, 4, 6);
INSERT INTO `enrollment` VALUES (3, 6, 3);
INSERT INTO `enrollment` VALUES (4, 6, 5);
INSERT INTO `enrollment` VALUES (5, 6, 6);
INSERT INTO `enrollment` VALUES (6, 6, 7);
INSERT INTO `enrollment` VALUES (7, 6, 8);
INSERT INTO `enrollment` VALUES (8, 7, 3);
INSERT INTO `enrollment` VALUES (9, 7, 5);
INSERT INTO `enrollment` VALUES (10, 8, 6);
INSERT INTO `enrollment` VALUES (21, 14, 3);
INSERT INTO `enrollment` VALUES (22, 14, 6);
INSERT INTO `enrollment` VALUES (23, 14, 7);
INSERT INTO `enrollment` VALUES (24, 15, 3);
INSERT INTO `enrollment` VALUES (25, 15, 5);
INSERT INTO `enrollment` VALUES (26, 15, 6);
INSERT INTO `enrollment` VALUES (27, 15, 7);
INSERT INTO `enrollment` VALUES (28, 15, 8);
INSERT INTO `enrollment` VALUES (29, 15, 13);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_type` enum('0','1','2') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '2',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '0', 'admin', 'admin123', 'pbkdf2:sha256:260000$WLQTnqvHpIe5HXNK$e5e6f950572aeebf6d58bf2b3573fd17e7d0c3ff775adc21acea7636903372e7', '2023-03-02 12:12:00');
INSERT INTO `user` VALUES (2, '1', 'Teacher', 'teach123', 'pbkdf2:sha256:260000$VN1BkxKg1dzKm7c1$f3abdb2985dca7600cae918519499310b919fd118092e5c944c8e488c3f43c1e', '2023-02-16 07:12:08');
INSERT INTO `user` VALUES (3, '2', 'Leon', 'Leon123', 'pbkdf2:sha256:260000$076mudWrsKgqVrrn$efd302b8bdf0c0aa560044623e855def23d507e8ce906c5fbeb491e8a01315dd', '2022-11-01 15:22:08');
INSERT INTO `user` VALUES (4, '0', 'Cooper', 'Cooper123', 'pbkdf2:sha256:260000$R4s2JKfhTSFyVna6$1cc5e1e789cc5470504783d7c0a56a018b4086e7f03f1076da143dc0ddd7ec01', '2023-03-24 12:12:37');
INSERT INTO `user` VALUES (5, '2', 'Alice', 'Alice123', 'pbkdf2:sha256:260000$GweZiwJeIdWuaOg5$6aa1db6361ba580ccc7929e8b35d6290d8598161de8941f330341b6a29e841f0', '2023-03-27 12:49:48');
INSERT INTO `user` VALUES (6, '2', 'Mike', 'Mike123', 'pbkdf2:sha256:260000$lxdMAgoOoT2dDeeZ$ed8f881c3e86e40aedfb0a2d5d77b680031218177fe2097c4dac60c632d521b4', '2023-03-27 12:50:13');
INSERT INTO `user` VALUES (7, '2', 'Brown', 'Brown123', 'pbkdf2:sha256:260000$iRhDRLb5Z0tTydx3$8293824b68a7233d7f4d14e1705474efb28681bf21ad9f2df23a5d51bf0a8425', '2023-03-27 12:50:26');
INSERT INTO `user` VALUES (8, '2', 'Smith', 'Smith123', 'pbkdf2:sha256:260000$4r0440KzR0Jc0zqw$df7711851da02b59f6240fdaa8e53582286e5c12c9da609666ada88b5fd11f2a', '2023-03-27 12:50:44');
INSERT INTO `user` VALUES (9, '1', 'Scoot', 'Scoot123', 'pbkdf2:sha256:260000$JEb7jSJm0tDJ2xgV$53c0abb71d23f3353474855bcccf837d8f5bcf2262018da018fb6e5c8a10e13f', '2023-03-27 19:31:08');
INSERT INTO `user` VALUES (10, '1', 'Trump', 'Trump123', 'pbkdf2:sha256:260000$cNVKlGp7gvCOs9eu$f6a4a180583bb2d85d6318f5ae3f87f26d081780bd2122a9ccf4082471588d6a', '2023-03-27 23:51:02');
INSERT INTO `user` VALUES (11, '0', 'Perl', 'Perl123', 'pbkdf2:sha256:260000$sBtSFudqKhby4FdH$f29ea29ff52d275c9a1d2f6da1a029f0c522c45405ba2b65cab8c10f7d417b56', '2023-03-28 00:12:03');
INSERT INTO `user` VALUES (12, '1', 'Tom', 'Tom123', 'pbkdf2:sha256:260000$LseFdFnJzQ0jpjzm$5fbbc64597fbcfedd74a42b7cc25ae6e7a400db6e58566769cb9c143606b7991', '2023-03-28 00:17:37');
INSERT INTO `user` VALUES (13, '2', 'Galileo', 'Galileo123', 'pbkdf2:sha256:260000$NnNYhYNUtZoV3fKa$4c02752b441cdbd7a1916cbc6499c97fbdc08f88709f7eb05758911499df9b4c', '2023-03-28 00:43:30');

SET FOREIGN_KEY_CHECKS = 1;
