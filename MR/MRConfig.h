/*
 *  MRConfig.h
 *  AMFObject
 *
 *  Created by AKEB on 1/11/11.
 *  Copyright 2011 AKEB.RU. All rights reserved.
 *
 */

#define MRLogMailTo @"akeb@akeb.ru" // Куда отправлять логи

#define MRLogFuncDefine   1       // Вывод логов функций
#define MRLogLevelDefine  1         // Уровень логов
#define MRLogFileFuncDefine  1    // Вывод логов функций в файл
#define MRLogFileLevelDefine  1     // Уровень логов в файле

#define MRLogDefine 1             // Вывод Логов
#define MRLogFileDefine 1         // Вывод логов в файл

#define MRLogErrorDefine 1        // Вывод Логов
#define MRLogErrorFileDefine 1    // Вывод логов в файл

#define MRDisplayWidth 320			// Ширина вывода логов
#define MRDisplayHeight 480         // Высота вывода логов



#define MRSTAT NO // Включить статистику

// Домен для статистики
//#define MRSTATURL   @"mobile-test.ext.terrhq.ru/"
#define MRSTATURL   @"mobile.ext.terrhq.ru/action.php"