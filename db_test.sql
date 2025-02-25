-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 12, 2023 at 10:06 PM
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
-- Database: `db-test`
--

-- --------------------------------------------------------

--
-- Table structure for table `access_tokens`
--

CREATE TABLE `access_tokens` (
  `id` int(255) NOT NULL,
  `admins_id` int(255) NOT NULL,
  `token` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `access_tokens`
--

INSERT INTO `access_tokens` (`id`, `admins_id`, `token`) VALUES
(1, 13, '5bnSIqn8JLPZg16c5cO67n9cHCf2_7HMfdOJPdLTZwI'),
(2, 14, 'oDv2ETTGXaivAq9O-BrTrn5uOKDxeQvVcjZqZyktqGI'),
(3, 15, 'FoMUMtQhdi2cPGdc4QrWkKhzNVn_8UIusR79OpSsTKI'),
(4, 16, '6RfsSKTrUDRf1CFp2_2FS0rz3e4_IJsnWTiR6Gyg8Uc'),
(5, 17, 'pOz3W1rx1X7eVJBN0IEH4pl2HSrdrOnsJAd2GE5WVyI'),
(6, 18, 'StAD7tbtqJlE65LTT4e-EOT8wJXqRIkFmpR28noPAbg'),
(7, 19, 'wJifKwnN6GCm_T7aP2o456QWXS0RPa-vIelQzw48j70'),
(8, 20, '4QhyZ8DFu0QQX4Yg30FUp_swBH81W_uL0Xh9kRRRH_k'),
(9, 22, 'EBwQu_fRzq1ZaywxkRDMcNtph7i1ON7lDCfX7vP7AwU'),
(10, 22, 'mzzriU4clLgJywP2ACTOBFJ_dsu1lSV4-XIZ7ZukGe0'),
(11, 24, 'zr5J2I8bO_hlECFqV2dCLxHE63Brol5WznnxsykeuzI'),
(12, 25, 'MrVHp1mYQq2zaanbZ4fJ3uJmjQUvALWHJVb-_HFONwA'),
(13, 26, 'tb8TPNftOCHQMx0ELrJHtMenI_ZYeE8wY8J4HEwQMbA'),
(14, 22, 'QjQSCuQLheoJJUIKPxUCXQkCSpIdHFvqAJvzuOMKwWY'),
(15, 27, 'THioUqdRRZMAgO86ENkIkvp1-O_mlhL4zQ_gXQBwU1g'),
(16, 27, 'vuWXc1DJlLDgKOpIPWz1JxIguZQ6mvG7DEv5xBu_a5s'),
(17, 28, 'FPi6l1bfYg6wphc5BuMjo5s5hTB17oqpPqk8BqVgMEk'),
(18, 29, 'p5gtVS8nW0Xf7WVgIwerxZJ9JHkTnW_pyk6sSHKiOJ4'),
(19, 30, 'kiwjQRtBKPhMDn5hPlv_N3mTy0HG0qaEzW_wp6TVTDY'),
(20, 31, 'O77badnLnOHEF5Ez6n8lt12Dp3ImTIngd-_QTe3IGo4'),
(21, 32, 'Cf9xaRyIsuGIpwEudOkPLYGmKszeQ9R6ERJh76weokE'),
(22, 33, 'cL03fYQp4r_xtH8mULzQ9Zf9wSp119um41jXf5Kjr_s'),
(23, 34, 'AKlkVCeLs3ygXxyreHyIyDQGjCT-gaP-jnj5DWoaJrk'),
(24, 35, 's9LX4CFdI9uw9TVHVNTXex3V5OQ3HwSpQpolm1b1GRE'),
(25, 36, 'Coua-dADE1VJiF0LvM18SwWHXumFLxMMiyC1J31Fqtc'),
(26, 37, 'SoL2cPdmKtY9t5UhOsh8HcyZFJ-GYnC341GcNruNi7s'),
(27, 38, 'NZ3rI87edDRWyyDUl0BrfPCe7dDX-eo81LhZhfXraI4'),
(28, 39, 'KSKHixkXQ88lzg3gycAKPle_z0q_z3GXKYx_51byj3Q'),
(29, 40, 'wE1-SrloLYaykXcXqyFyJK36IdrRryvRtkl2LvU-yxQ'),
(30, 41, 'jMMwDB-myU9zlhpWE-dg4o6VPcMBlHMyDZQ_Naw8A-8'),
(31, 42, 'ccpq-VVzG0C07zQ75RCv5xktmVEaAn9S519UNWqkpKA'),
(32, 43, 'RutzbMc9mCv_1Y--WZ1Apvos1mKYW9B6bkL74jSU5UM'),
(33, 44, 'TjGxFBXSdbhmOgzXWVVj4RCnvMFBFuTN13V71dTlAms'),
(34, 45, 'VVFmTa5flVq4xbb2LtsI8D0LPjc_pe1j55uCEEXl_hY'),
(35, 46, 'lqNpSHGML9oR_VxzZbFlAcG8qz9pXuf9LVTymursubQ'),
(36, 47, 'TwTdCIRyfstdUdUMkbsQt1FuQNtCUmX-9h2Ajt4UJ9s'),
(37, 48, 'ft0_x77UInGA8U4WkJovfyqpDnSHbKzxFhWiselFlk0'),
(38, 49, 'JOk2ApEfvFR_4N9kUIJAKWQHSLTYGWAR4OMgizrW2z4'),
(39, 50, 'K4Cxp067hlwNWv05SAEQU45LE2ycobBr9umsLI7GvR0'),
(40, 51, 'HuRJuBI69r3ctq8iStvry2F91TbX5l-2B5CJ_Mxe174'),
(41, 52, 'FQ5Bqk2BxmD2EHR1ZGhGVs2YByYJIvfcv6MFEw4hsvc'),
(42, 53, '663HLfbgWXg-10IHQEW9xnAp1O-8Jd1ZlCv4ePVW8bM'),
(43, 54, 'UCtRHtfeu9fjjstuKMnUmAdLWQ4meZ1-e7qz9gURDSA'),
(44, 55, 'g93_QJznkcsiyj01xw4Bts9R7Byf5XyU5mKraXcOBOs'),
(45, 56, 'e5mvKcYg9-WntpWYYEs8eGSQEc3M-Uf33KlYDhq-AaA'),
(46, 57, 't8ToGzub7vf00jjuKLSDBAhqVvNlv2UUZJy4MuRN2VY'),
(47, 58, 'twE6KFGNBN5T4xVQ67ds0oWd0W5_hE0wEnEcvfKLSOI'),
(48, 59, '0HxQ7nrWsxGvUqAsNRQwG-n36IeuwIV19hnU3OCSBrI'),
(49, 60, 'nxTI2TDNC1WorghvBRyX6GFH0pgvXjoGl_CgnG8rBTg'),
(50, 61, 'XCjztf2dUStCGWp5DB-pDQlv9LDVRC1FFUZBQ8gV0qc'),
(51, 62, 'a8UVsHl86ObDDJbUCuC3Uqyc0qkgL_gW24hHpNGIKQ4'),
(52, 63, 'x9juqjWLAuWH4v1DpyR7ia-JmWpVaK5wmj27O76wRM0'),
(53, 64, 'soXQ38Ifrccb2ylNNgfOtPeGghaEKnfbFR20hA_fs_I'),
(54, 64, 'lamIyuuWYeUWDhXzZ1EaY1r1zhwe5q-FEZQ0JX8S5aY'),
(55, 64, 'I6ckGontlZO_DEq5qiwG3Ib8a2hxsa3q7i7pX1j_fpA'),
(56, 61, 'whMXu0gbm8JOMsN991OfcdrIypdmGv9Fw5ioAhpfwWA'),
(57, 64, '7SmYeDairptDfgHWv8KRDwh1p-92Rt_YpLCLlGAXtcc'),
(58, 64, 'A38d6m2_CNMfsHw-DldUN4WeUEW--hqAV1xvpRZZZf8'),
(59, 65, 'uZ5O9nork3PFWcA-oOXYyp22uztB1cne4OZrkmeCWl4'),
(60, 66, 'rZ243mxOCImKVe7ZZvZE7LcIPQphUpqUEHkzzYt_pVM'),
(61, 67, '6PEMyzM5IHf4imSfZNdiwa7peR-RaYPQYLbnbOS1puc'),
(62, 68, 'xFUWE0ufck9axkaD77Zmv-YubKNbAwFjYpELfjGpt0s'),
(63, 68, 'bOmL7Nsv3GfUBi_RSrJKFyMPcJ3lld97OxByliLkPrg'),
(64, 68, 'qh0OyhuODdH1w1iNwCCh5VH0UCJYIQH7xkSV3p0mBTg'),
(65, 68, '1hmBVWWZXbell_Q8kWT4QzU4H5HoULJO1Z0QICL-TgQ'),
(66, 68, 'RRi5Cf-ClDozxuZgqXrFFSmiAb3w5A5ubs5gWx6vlHQ'),
(67, 68, 'W1fqMB5pDuWwPvaI9bZGby0QWrYe_nZdItMNBOj-hTM'),
(68, 69, 'GCciVEazWWTxaiMmr8ctXE7rrZ6qOhB3etai4XlgUHM'),
(69, 69, 'ebALPSu4c-pOEzrJkHQ9jTzKnfoOlbOsFjd_UJewK_Q'),
(70, 69, 'BnNnxhAxHsD2mEkq5U1RE3ncN3lh4U0M2vwLceFwYF8'),
(71, 70, 's46CERBE6waTXv-gV-ymjwtIsS8uF1mAztvLu0KwJ1k'),
(72, 70, 'HA7DgGvFDN5n4BHzxU7Ra8SYg30d2lJzmtvWypO3cuc'),
(73, 70, 'An95AH4VtCKGvxXWQ9dmWgO-EFGDo5EvSb6-VhRYzgM'),
(74, 70, 'A47vObFuud5__1uClqE_ayVrfAO5Bou3FsWR05oTsFw'),
(75, 70, '4or3SfloMbI0cQAhloS6qkrldKIGEIx5RGZdjBWUnvQ'),
(76, 70, 'ux3LsYiUTrIvUxPvQwBjmVAYLJbHjxduTFRy1qI2VCA'),
(77, 70, '5wpdmm-VEwBCjBi8AmXhjz-Kt3FoEeL7c8d9e2BdTq8'),
(78, 70, '6Q4vUYeL4_oz7VSPsAo27fLLUBIoMx7NrbEyFblA-_g'),
(79, 70, 'a9K-knljP-QSm3XQGZ16ZLM1a8Oe8Y4O1M8YCpYi5L8'),
(80, 70, 'gbIcZWR3r6vwQOE44A0q9MKLvw_nu9Z1B6G_6WHsQVE'),
(81, 70, 'lRF6X26ECfTv5UpCPtLTJygirYHMnIM57Lnzwco0tuI'),
(82, 70, 'h4I0eItfuVia_fnQcYIKGObn7_HG0RUtFEoq9MK5PgY'),
(83, 70, 'yeOqxcQzqhfxaupO01DYNvbg83ly5nUP0cgWy2e5Dt0'),
(84, 70, '9dGRqr8jfeAC-qwuYr01Q0T0qxcgtQz8vZffjbf2_5E'),
(85, 70, 'vF_WMHxCtrykpKW3GdcZ4grXNamW7k8CLrtLPQFiYCM'),
(86, 70, '3nZVwiYGXQyJcnUU8DhSamJAApCVnFgVZaX7z71WVXk'),
(87, 70, 'XFB6mBqfnxPgxHx8HzxFz2H2XD-q8FbGF_3w2PHciWU'),
(88, 71, '6JGnrN41bZ1Q6JAwFHWWPbhQdhxNZB-Up_OX2BVgo8s'),
(89, 71, 'Yi7H_D8Lx6TGprkifYjPHrhRRcltuFKVc_8T3avSukM'),
(90, 71, 'Db6jqJ5whei4C8Pg_EhTkjP-c4c_B7mJaSIhgzV3hL0'),
(91, 71, 'xea67Jdng6I88tUvciiYw1OtsT4uexSMx0QHXf4p93c'),
(92, 71, 'a5nZJtwYqed2H0Dpu3UHdCvS4jAZuoMIvJuRUYFf4h8'),
(93, 71, '3nexFIQTcN8eKYkUhZI4U-zLTOArwJ_1e-N43jbqSiA'),
(94, 70, 'c7QQpWvKlloV6EseJMEsT_C-8qNwjAOQsN40iwxmveg'),
(95, 71, 'I-S433c-RWFSGQokvk-TBh81fKThfIc24ZSkX2OKnlQ'),
(96, 71, 'D8MJiz8W_p9c8hoNLbaWhaswbx8tcLyje3ZTBz4k_ds'),
(97, 71, 'qJbgGv0muI8tyXpo6wnqHq06_7nyMgVE_tPL_1Iwf_Y'),
(98, 71, 'ORmcx7W4ks9sLFzvuXo6Y3GtpyFT2b_Ts5JPQwnaRqI'),
(99, 71, 'ZhvPL42bDqCzaS86A59CEjc338NIBsIQqizHn0AmRLM'),
(100, 70, 'nMCqCAPjtTE40pPO3I4fEPltj-AbCHLiWYDSOG1-HPY'),
(101, 70, 'wljX8SM8HCyqIkROnd3a4GqpXFA7_NIkG59azx4Uv2A'),
(102, 70, 'RYZtdV-bq_pvqlyk0V0RvQ06FCJaKThI6nbcX1BM7iA'),
(103, 70, 'ECZUYuuPkGxo6ze2Ez-UbMguNUGTdpl9ooh2N5qZxPY'),
(104, 70, 'GjH1lshOSXbPQWgm_3RfLDGjWQS43GZNxRuF1EVWbOA'),
(105, 70, 'fArz6IxPfpGqMGkXmimNRP06ldHYWso2vB0-o1Ssd7c'),
(106, 70, 'cocHZuKqQKTWec5UBLc6-2ZJra-6hMBEmEu6OH8uj3Q'),
(107, 70, 'rtumDtka6NV_JlZtsyuG07tCoKNxRLd3WexpoiUnTEs'),
(108, 70, 'PK3diYjIClYUvvrlAfdjed5PslVnX0j45RAXoZfuTVE'),
(109, 70, 'BM2oA6ItmppmdXoM-ObHAzFpJ9AnBbO4mc1Q-_LI4EQ'),
(110, 70, 'lF3kt0Hdhp9s04cbtFWPjrpkktM-rCrYuOF6DP5V95s'),
(111, 70, '4e668mIl8ypwnUELwRMYsrxdESflYuuCrbZvRdFspNA'),
(112, 70, '0z2Dz4fOs7nsUEfpFiQvFLisVbBpZTLzNuGGB0pOh3U'),
(113, 70, 'LBYvkPquBhHzh6OacIZZQGk6Ok1aecgrUlVCOmptuXo'),
(114, 70, 'Xicq9VvRlc1zSBpF_ATA2hNqxWZ7J4iLLNhCaeeB7EM'),
(115, 70, '5NgsWErZCH6g6RDNeXNbz12LWNuIxAIsXahdA_i-Dak'),
(116, 70, 'Oy76rDCazZE4qz96EzIpNQoRWPhpzWAXQq-wm0qm_-s'),
(117, 70, '0PMfj3LT6PfcSm-nMkKow6cyxePU5e-CEnM7F6slsKU'),
(118, 70, 'KkNPIEWqRaK2QaNvUJweBRQYsPDAX3MQngLkK_zqEbs'),
(119, 70, '8venyAQGNoU0L2fxfaM4KOJ-BPc58vInPBAj0YCtJzM'),
(120, 70, 'YI0A7oJhywXxhWQG9SfWtvrV6bs7HdKTJz6SWg8INwA'),
(121, 70, '7Y-K5YVmYKUUY81Z2bmmWRpDB-eFvruJp0pD4BhacJY'),
(122, 70, 'usubGmJWbS6SXtXDhVqJivEWDhjr17WpmF2FWaDgwII'),
(123, 70, 'j1QCVO3smw08v8bsnvQ8GvYx7DYT216JMd4R9rPlT3E'),
(124, 70, '-dDVnKWjHyrnXCVD_lsdandOD8xtWhn13kMlzTxYmgw'),
(125, 70, 'tafqJYsS4v18VkXppGObBWfTccWQ81EruLSWVjZuCW4'),
(126, 70, '0fFOb7b92mzA30Mn_MWB4zTt4hd_DHh-8BcVUyxeirY'),
(127, 70, 'p-piQEYNB2qkD64CCwc6JrSUBcOLqfes0Vd7qFIo2MM'),
(128, 70, 'zILwLgQxdsqpJC1ShLj9LHXsg54c2xL3hVpjmUiqg9w'),
(129, 70, 'NCSaN8SrdCBaCNlyjyXO9MmmurfeaC1Szyr0whpyzLk'),
(130, 70, 'J_gf_YNfVUJ23rnP8lBjZnrDm2nCQg3EYfu5Q_VfU00'),
(131, 70, '9whT3KCyU9hVfT_5usgxFWlAx5oDwYFNsCPJkVmCWXY'),
(132, 70, 'zw3SDDif7KkYf2VlTqpOHleY4MHiai4bCh5j0gSSY0k'),
(133, 70, 'BmXkpjmOSJWrX-jP5g6fcQXERmpl3lByqLuKZWuzxMc'),
(134, 70, 'FLpzX5ep65R3LPBP51uL7DeYh6D3U1LluGJXzTiE7us'),
(135, 70, 'N6b2Q3_JtKyg2b8UPXJJxf3bP2M8G1kcuxGJEi2cI7k'),
(136, 70, '9pjP0vDtiHEvL0tUEsY0d__nCsaT_O502dhCnpampRU'),
(137, 70, 'CU3pzYQI7vAwwpvtIJQFilAwCjC9JHDPMHFgEzQbVqM'),
(138, 70, 'CJxaVHE8pmKLAXRetfCtM6Rcm19VJCWOnsP4f6jI_l8'),
(139, 70, '9lWPHraMgGyS83myfSHRpUjO3IAr0ng19QoiTUjOivQ'),
(140, 70, 'iiybLDlzwyDXw0KxbLQGNKu6yp7OHz6Bn-iKjWeKFFk'),
(141, 70, 'GqUDww6G3jQkWb62ub5jVxAJxtnJ3YgSfM3qT0X_Rsc'),
(142, 70, 'Jm64b3byvU9B5PVArZ9tGqm0AEui_IaDmZ3000LL9n4'),
(143, 70, 'eumHuay5IskHmh6WTyxnJHo-omJch7pXbOJrrkYCQlA'),
(144, 70, 'SdakGaSc695COIEneTexcoSo-y9BwjSWaZlNwYzS8fY'),
(145, 70, 'uiUynhtwRVpwX-6hx4d28C45V4-XW2k2d4yTyHN3Mfo'),
(146, 70, 'sTw9JuTdnsHXJlGlHSpijVHJmDFmliaCo0C9Uut6Tas'),
(147, 70, 'KWcBA76zHD95PZjJa1dv9N-gnlFT9Tzf2Havtn928U8'),
(148, 70, '8ufNrXjYoj4Dbkm9aWQ98SnN8NaWmMYs2QJ9M4PToak'),
(149, 70, 'aWbCfqxz2DmHS2zYxaFeTLH2qczYyDEr_wRjw8_pfQw'),
(150, 70, 'B0hENkBTrzMy04Vr0UGJ60fqB5N8ixpL8i-txRkd2zY'),
(151, 70, 'i3lOmH0M4fFwtP5lzItihYc50t5MnS0UkbNr00YA0tw'),
(152, 70, 'g_SU5LoP4m2Ibm5vJk-Y4e7vs2n0VLckh87PExRQuSM'),
(153, 70, 'Vg55WDY4CVPTzXcAXQsH3h9VuBTXzASGf8ym-RtPl5o'),
(154, 70, 'IKQlloIqma5AF5OE42lshkQVYI4ry1a4ODZNClaU3i8'),
(155, 70, 'Lh3VWI1rO22OiAIW67tvDLMxkrep9wqnxqcoPiI2RuM'),
(156, 70, 'NWUm0nBAL6ezdqPcIpqwvYnV3vE5hrFlME8RpY6n87g'),
(157, 70, 'JH2qN-tFwNuj539ZtraIEsjCXQsqNeydI0GklIqfjwc'),
(158, 70, 'h44o6vaAi02BhC2EQHkVzajWh5UZk4Sz9TbC73rcFKA'),
(159, 70, 'ceIZkve-2D7wo5p63-p7BE8wpO69JsizM29LpkPw6sM'),
(160, 70, '0e_iFN961m0w4AsnM_iKtfMytZU-I2Dgor16zUidy7U'),
(161, 70, '_l783TSHMnwOnItJ4PTzPVoDyuXHQeUXk5b1O4h1h7g'),
(162, 70, 'E1pjG44dnsXCqTu2rM-y862wYS4xzyiqsp2z8NBlAt4'),
(163, 70, 'Fa4cMo8Hw4EOIEE66dnyeFst9jFImTyFlnFPKkHeOIQ'),
(164, 70, '-yxGpW0QYkoGcmncG5KnCqvDts8C3OomtaFhwViGPto'),
(165, 70, 'r4BsU2EDPY6d_F-S9VCf6IhitYvpuoR7D2sacS119CI'),
(166, 70, 'tXpRJAb-a8824FBUyFrK0ZyYjR67fT0JfDMQo-jR7Ng'),
(167, 70, 'd-lAo53wt_zeVaBHlkFavYJeZY8bPgl3mvWILQBJCNw'),
(168, 70, 'xXmKlJQCAWA1zV2QO3X7zTw3KXJv0XrdyieVlO1ih0U'),
(169, 70, '5L2mV6Sl8CzwViRdryKusDsiXKYXT0qIVOpNCzM9nFg'),
(170, 70, 'a19BFZJbDMcVQ_SYFZ2UOj0pg9Cho5xlUdkv4ol8YIw'),
(171, 70, 'ZsUspWn6c4e9W-nZjVHLmTNyb4VMsAvbjpuKHkb0llE'),
(172, 70, 't9MXd1Y36KOnVd-bv9AI2kIXxGkudsVYAwtC_kJiRTo'),
(173, 70, '_PPCx2e3MtInfjMjRta_tnzdMDHwE3gsVY_qjpMkt4k'),
(174, 70, 'VkT9ZrxRmIyC4uf0edMT1oJmwYqJ1RO8iPJ0PMAOANA'),
(175, 70, '8jhgUd5qFAN1VsQXZqyABioz9Yq4u0T87fCijqNSvvw'),
(176, 70, 'jh0bpvBgo70V8dUS0KL-RbCaf3HlpnTvlJaWGq8wRcw'),
(177, 70, '3x5ro0TXBpd2sH7BFbFWKL9BYMC2OuyebMKyOeV5k2I'),
(178, 70, '42BoWvKoCmCYRQm2nQW43s7b-1_8rOoUtqxmhbnP_Zo'),
(179, 71, '3KijxiWOa9IRguugWGr2Xw9afny_ktWRbA7SBBriQo8'),
(180, 72, 'euj6ebuvktFYvkcHQsopUUtJPCwEwR5_GZ2hYfW4Djg'),
(181, 72, 'VAnAX-J3JqlPEonHpHVAUPcpHaooqsgZl3dMM2E5Sn4');

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_photo` text DEFAULT NULL,
  `token` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `username`, `email`, `password`, `profile_photo`, `token`) VALUES
(70, 'rani', 'rani', 'rani@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', NULL, ''),
(71, 'arana', 'aran', 'aran@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', NULL, ''),
(72, 'asd', 'asd', 'asd@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `container`
--

CREATE TABLE `container` (
  `id` int(255) NOT NULL,
  `cont_id` int(255) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hosts`
--

CREATE TABLE `hosts` (
  `id` int(255) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `port` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `usernameFromProxmox` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hosts`
--

INSERT INTO `hosts` (`id`, `ip_address`, `port`, `username`, `password`, `usernameFromProxmox`) VALUES
(245, '192.168.100.84', '8006', 'root', 'bismillahTA', 'root@pam'),
(246, '192.168.100.85', '8006', 'root', 'bismillahTA', 'root@pam');

-- --------------------------------------------------------

--
-- Table structure for table `machine`
--

CREATE TABLE `machine` (
  `id` int(255) NOT NULL,
  `vm_id` int(255) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `access_tokens`
--
ALTER TABLE `access_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `container`
--
ALTER TABLE `container`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hosts`
--
ALTER TABLE `hosts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `machine`
--
ALTER TABLE `machine`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `access_tokens`
--
ALTER TABLE `access_tokens`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `container`
--
ALTER TABLE `container`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hosts`
--
ALTER TABLE `hosts`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT for table `machine`
--
ALTER TABLE `machine`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
