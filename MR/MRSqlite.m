//
//  MRSqlite.m
//  AMFObject
//
//  Created by AKEB on 1/9/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "MRSqlite.h"
#import "MRLog.h"

@implementation MRSqlite

static NSMutableDictionary  *_sharedController = nil;

#pragma mark -
#pragma mark INIT METHODS

+(MRSqlite *) sharedController:(NSString *)dataBase readonly:(BOOL)readonly {
	MRLogFunc(1);
	if (!_sharedController) {
		_sharedController = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	
	if (![_sharedController objectForKey:dataBase]) {
		[[MRSqlite alloc] initWithDatabase:dataBase readonly:readonly];
	}
	return [_sharedController objectForKey:dataBase];
}

+(MRSqlite *) sharedController:(NSString *)dataBase {
	MRLogFunc(1);
	return [MRSqlite sharedController:dataBase readonly:NO];
}

-(id) initWithDatabase:(NSString *)dataBase readonly:(BOOL)readonly {
	MRLogFunc(1);
	self = [super init];
	[_sharedController setObject:self forKey:dataBase];
	if (self) {
		_readonly = readonly;
		_dataBase = [dataBase retain];
		_path = [[NSString alloc] initWithString:[[NSBundle mainBundle] resourcePath]];
		if (!_readonly) [self copyDataBase];		
	}
	return self;
}


#pragma mark -
#pragma mark GET

-(NSDictionary *) get:(NSString *)table ref:(id)ref {
	MRLogFunc(1);
	return [self get:table ref:ref add:@"" refName:@"id"];
}

-(NSDictionary *) get:(NSString *)table ref:(id)ref add:(NSString *)add {
	MRLogFunc(1);
	return [self get:table ref:ref add:add refName:@"id"];
}

-(NSDictionary *) get:(NSString *)table ref:(id)ref add:(NSString *)add refName:(NSString *)refName {
	MRLogFunc(1);
	
	NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT rowid AS rowid, * FROM `%@` AS t WHERE 1 ",table];
	if (ref && ![ref isKindOfClass:[NSNull class]]) {
		if (![ref isKindOfClass:[NSDictionary class]]) {
			if (!ref || ref == NULL || [ref isKindOfClass:[NSNull class]]) {
				[sql appendFormat:@" AND `%@` IS NULL ",refName];
			} else if ([ref isKindOfClass:[NSArray class]]) {
				[sql appendFormat:@" AND `%@` IN (%@) ",refName,[ref componentsJoinedByString:@", "]];
			} else {
				[sql appendFormat:@" AND `%@` = '%@' ",refName,ref];
			}
		} else {
			if ([ref count] < 1) return [NSDictionary dictionary];
			for (id k in ref) {
				id v = [ref objectForKey:k];
				if (!v || v == NULL || [v isKindOfClass:[NSNull class]]) {
					[sql appendFormat:@" AND `%@` IS NULL ",k];
				} else if ([v isKindOfClass:[NSArray class]]) {
					[sql appendFormat:@" AND `%@` IN (%@) ",k,[v componentsJoinedByString:@", "]];
				} else {
					[sql appendFormat:@" AND `%@` = '%@' ",k,v];
				}	
			}
		}
	}
	[sql appendFormat:@"%@ LIMIT 1;",add];
	MRLog(@"SQL GET = [%@]",sql);
	
	return [self getQueryRow:sql];
	
}

#pragma mark -
#pragma mark LIST

-(NSArray *) list:(NSString *)table {
	MRLogFunc(1);
	return [self list:table ref:nil add:@"" fieldList:@"*"];
}

-(NSArray *) list:(NSString *)table ref:(NSDictionary *)ref {
	MRLogFunc(1);
	return [self list:table ref:ref add:@"" fieldList:@"*"];
}

-(NSArray *) list:(NSString *)table ref:(NSDictionary *)ref add:(NSString *)add {
	MRLogFunc(1);
	return [self list:table ref:ref add:add fieldList:@"*"];
}

-(NSArray *) list:(NSString *)table ref:(NSDictionary *)ref add:(NSString *)add fieldList:(NSString *)fieldList {
	MRLogFunc(1);
	
	NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT rowid AS rowid, %@ FROM `%@` AS t WHERE 1 ",fieldList,table];
	if (ref && ![ref isKindOfClass:[NSNull class]]) {
		if (![ref isKindOfClass:[NSDictionary class]]) return [NSArray array];
		if ([ref count] < 1) return [NSArray array];
		for (id k in ref) {
			id v = [ref objectForKey:k];
			if (!v || v == NULL || [v isKindOfClass:[NSNull class]]) {
				[sql appendFormat:@" AND `%@` IS NULL ",k];
			} else if ([v isKindOfClass:[NSArray class]]) {
				[sql appendFormat:@" AND `%@` IN (%@) ",k,[v componentsJoinedByString:@", "]];
			} else {
				[sql appendFormat:@" AND `%@` = '%@' ",k,v];
			}	
		}
	}
	[sql appendFormat:@"%@ ;",add];
	MRLog(@"SQL LIST = [%@]",sql);
	
	return [self getQueryArray:sql];
}

#pragma mark -
#pragma mark COUNT

-(int) count:(NSString *)table {
	MRLogFunc(1);
	return [self count:table ref:nil add:@""];
}

-(int) count:(NSString *)table ref:(NSDictionary *)ref {
	MRLogFunc(1);
	return [self count:table ref:ref add:@""];
}

-(int) count:(NSString *)table ref:(NSDictionary *)ref add:(NSString *)add {
	MRLogFunc(1);
	
	NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT count(*) FROM `%@` AS t WHERE 1 ",table];
	if (ref && ![ref isKindOfClass:[NSNull class]]) {
		if (![ref isKindOfClass:[NSDictionary class]]) return 0;
		if ([ref count] < 1) return 0;
		for (id k in ref) {
			id v = [ref objectForKey:k];
			if (!v || v == NULL || [v isKindOfClass:[NSNull class]]) {
				[sql appendFormat:@" AND `%@` IS NULL ",k];
			} else if ([v isKindOfClass:[NSArray class]]) {
				[sql appendFormat:@" AND `%@` IN (%@) ",k,[v componentsJoinedByString:@", "]];
			} else {
				[sql appendFormat:@" AND `%@` = '%@' ",k,v];
			}	
		}
	}
	[sql appendFormat:@"%@ ;",add];
	MRLog(@"SQL COUNT = [%@]",sql);
	return [self getQueryInt:sql];
}


#pragma mark -
#pragma mark REMOVE

-(int) remove:(NSString *)table ref:(id)ref {
	MRLogFunc(1);
	return [self remove:table ref:ref add:@"" refName:@"id"];
}

-(int) remove:(NSString *)table ref:(id)ref add:(NSString *)add {
	MRLogFunc(1);
	return [self remove:table ref:ref add:add refName:@"id"];
}

-(int) remove:(NSString *)table ref:(id)ref add:(NSString *)add refName:(NSString *)refName {
	MRLogFunc(1);
	if (_readonly) return 0;
	
	NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM `%@` WHERE 1 ",table];
	if (ref && ![ref isKindOfClass:[NSNull class]]) {
		if (![ref isKindOfClass:[NSDictionary class]]) {
			if (!ref || ref == NULL || [ref isKindOfClass:[NSNull class]]) {
				[sql appendFormat:@" AND `%@` IS NULL ",refName];
			} else if ([ref isKindOfClass:[NSArray class]]) {
				[sql appendFormat:@" AND `%@` IN (%@) ",refName,[ref componentsJoinedByString:@", "]];
			} else {
				[sql appendFormat:@" AND `%@` = '%@' ",refName,ref];
			}
		} else {
			if ([ref count] < 1) return [NSDictionary dictionary];
			for (id k in ref) {
				id v = [ref objectForKey:k];
				if (!v || v == NULL || [v isKindOfClass:[NSNull class]]) {
					[sql appendFormat:@" AND `%@` IS NULL ",k];
				} else if ([v isKindOfClass:[NSArray class]]) {
					[sql appendFormat:@" AND `%@` IN (%@) ",k,[v componentsJoinedByString:@", "]];
				} else {
					[sql appendFormat:@" AND `%@` = '%@' ",k,v];
				}	
			}
		}
	} else {
		return 0;
	}
	[sql appendFormat:@"%@ ;",add];
	MRLog(@"SQL REMOVE = [%@]",sql);
	return [self execQueryWithChanges:sql];
}

#pragma mark -
#pragma mark TRUNCATE

-(BOOL) truncate:(NSString *)table {
	MRLogFunc(1);
	if (_readonly) return NO;
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM `%@` ;",table];
	MRLog(@"SQL TRUNCATE = [%@]",sql);
	return [self execQuery:sql];
}

#pragma mark -
#pragma mark SAVE

-(int) save:(NSString *)table params:(NSDictionary *)param {
	MRLogFunc(1);
	if (_readonly) return NO;
	return [self save:table params:param refName:@"id" add:@""];
}

-(int) save:(NSString *)table params:(NSDictionary *)param refName:(NSString *)refName {
	MRLogFunc(1);
	if (_readonly) return NO;
	return [self save:table params:param refName:refName add:@""];
}

// params:
// '_mode' - MRSSQLITEMODES
// '_set' - UPDATE SET part
-(int) save:(NSString *)table params:(NSDictionary *)param refName:(NSString *)refName add:(NSString *)add {
	MRLogFunc(1);
	if (_readonly) return NO;
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
	id refId = [params objectForKey:refName];
	int result = 0;
	NSMutableString *set = [NSMutableString string];
	MRSSQLITEMODES mode = MRSqlModeNone;
	if ([params objectForKey:@"_mode"]) {
		mode = [[params objectForKey:@"_mode"] intValue];
		[params removeObjectForKey:@"_mode"];
	}
	if ([params objectForKey:@"_set"]) {
		set = [params objectForKey:@"_set"];
		[params removeObjectForKey:@"_set"];
	}
	if ([set length] > 0 && !refId && ![add length] < 1) return result;
	if (mode == MRSqlModeNone) mode = (([set length] > 0 || refId || [add length] > 0) ? MRSqlModeUpdate : MRSqlModeInsert);
	
	if (mode == MRSqlModeInsert) {
		NSString *sql = [NSString stringWithFormat:@"INSERT INTO `%@` (`%@`) VALUES ('%@'); ",table,[[params allKeys] componentsJoinedByString:@"`,`"],[[params allValues] componentsJoinedByString:@"','"]];
		MRLog(@"SQL INSERT = [%@]",sql);
		refId = [NSNumber numberWithLongLong:[self execQueryWithId:sql]];
		result = [refId longLongValue];
	} else if (mode == MRSqlModeUpdate) {
		NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE `%@` ",table];
		NSMutableArray *t = [NSMutableArray array];
		for (id k in params) {
			id v = [params objectForKey:k];
			NSString *_t = [NSString stringWithFormat:@" `%@`='%@' ",k,v];
			[t addObject:_t];
		}
		if ([set length] > 0) [t addObject:set];
		[sql appendFormat:@" SET %@ WHERE 1 ",[t componentsJoinedByString:@","]];
		if (refId) [sql appendFormat:@" AND `%@` = '%@' ",refName,refId];
		[sql appendFormat:@"%@ ;",add];
		MRLog(@"SQL UPDATE = [%@]",sql);
		result = [self execQueryWithChanges:sql];
	} else if (mode == MRSqlModeReplace) {
		NSMutableArray *t = [NSMutableArray array];
		for (id k in params) {
			id v = [params objectForKey:k];
			NSString *_t = [NSString stringWithFormat:@" `%@`='%@' ",k,v];
			[t addObject:_t];
		}
		NSMutableString *sql = [NSMutableString stringWithFormat:@"REPLACE INTO `%@` SET %@ ;",table,[t componentsJoinedByString:@","]];
		MRLog(@"SQL REPLACE = [%@]",sql);
		refId = [NSNumber numberWithLongLong:[self execQueryWithId:sql]];
		result = [refId longLongValue];
	}
	return result;
}

#pragma mark -
#pragma mark PRIVATE METHODS


-(NSArray *) getQueryArray:(NSString *) sql {
	MRLogFunc(1);
	NSMutableArray *recordsArray = [[[NSMutableArray alloc] init] autorelease];
	NSString *defaultDBPath = [_path stringByAppendingPathComponent:_dataBase];
	sqlite3 *database;
	
	// Открываем базу данных
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		// Запрашиваем список идентификаторов записей
		sqlite3_stmt *statement;
		// Компилируем запрос в байткод перед отправкой в базу данных
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//int ParamsCount = sqlite3_bind_parameter_count(statement);
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int dataCount = sqlite3_data_count(statement);
				NSMutableDictionary *row = [[NSMutableDictionary alloc] initWithCapacity:dataCount];
				for (int i=0; i<dataCount; i++) {
					NSString *columnName = [NSString stringWithCString:sqlite3_column_name(statement, i) encoding:NSUTF8StringEncoding];
					int typeColumn = sqlite3_column_type(statement, i);
					id object;
					if (typeColumn == SQLITE_INTEGER) {
						object = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
					} else if (typeColumn == SQLITE_FLOAT) {
						object = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
					} else if (typeColumn == SQLITE_BLOB) {
						const void *test = sqlite3_column_blob(statement, i);
						NSLog(@"BLOB %s",test);
					} else if (typeColumn == SQLITE3_TEXT) {
						object = [NSString stringWithCString:sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding];
					} else {
						object = [NSNull null];
					}
					[row setObject:object forKey:columnName];
				}
				[recordsArray addObject:row];
				[row release];
			}
		}
		sqlite3_finalize(statement);
	} else {
		// Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
		sqlite3_close(database);
		NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	return recordsArray;
}

-(NSDictionary *) getQueryRow:(NSString *) sql {
	MRLogFunc(1);
	NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
	NSString *defaultDBPath = [_path stringByAppendingPathComponent:_dataBase];
	sqlite3 *database;
	
	// Открываем базу данных
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		// Запрашиваем список идентификаторов записей
		sqlite3_stmt *statement;
		// Компилируем запрос в байткод перед отправкой в базу данных
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//int ParamsCount = sqlite3_bind_parameter_count(statement);
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int dataCount = sqlite3_data_count(statement);
				for (int i=0; i<dataCount; i++) {
					NSString *columnName = [NSString stringWithCString:sqlite3_column_name(statement, i) encoding:NSUTF8StringEncoding];
					int typeColumn = sqlite3_column_type(statement, i);
					id object;
					if (typeColumn == SQLITE_INTEGER) {
						object = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
					} else if (typeColumn == SQLITE_FLOAT) {
						object = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
					} else if (typeColumn == SQLITE_BLOB) {
						const void *test = sqlite3_column_blob(statement, i);
						NSLog(@"BLOB %s",test);
					} else if (typeColumn == SQLITE3_TEXT) {
						object = [NSString stringWithCString:sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding];
					} else {
						object = [NSNull null];
					}
					[row setObject:object forKey:columnName];
				}
				break;
			}
		}
		sqlite3_finalize(statement);
	} else {
		// Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
		sqlite3_close(database);
		NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	return row;
}

-(BOOL) execQuery:(NSString *) sql {
	MRLogFunc(1);
	BOOL result = NO;
	NSString *defaultDBPath = [_path stringByAppendingPathComponent:_dataBase];
	sqlite3 *database;
	// Открываем базу данных
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, [sql UTF8String], 0, NULL, NULL) == SQLITE_OK) {
			result = YES;
		}
	} else {
		// Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
		sqlite3_close(database);
		NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	return result;
}

-(int) execQueryWithChanges:(NSString *) sql {
	MRLogFunc(1);
	int result = 0;
	NSString *defaultDBPath = [_path stringByAppendingPathComponent:_dataBase];
	sqlite3 *database;
	// Открываем базу данных
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, [sql UTF8String], 0, NULL, NULL) == SQLITE_OK) {
			result = sqlite3_changes(database);
		}
	} else {
		// Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
		sqlite3_close(database);
		NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	return result;
}

-(long long int) execQueryWithId:(NSString *) sql {
	MRLogFunc(1);
	long long int result = 0;
	NSString *defaultDBPath = [_path stringByAppendingPathComponent:_dataBase];
	sqlite3 *database;
	// Открываем базу данных
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, [sql UTF8String], 0, NULL, NULL) == SQLITE_OK) {
			result = sqlite3_changes(database) > 0 ? sqlite3_last_insert_rowid(database) : 0;
		}
	} else {
		// Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
		sqlite3_close(database);
		NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	return result;
}

-(int) getQueryInt:(NSString *) sql {
	MRLogFunc(1);
	int result = 0;
	NSString *defaultDBPath = [_path stringByAppendingPathComponent:_dataBase];
	sqlite3 *database;
	// Открываем базу данных
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		// Запрашиваем список идентификаторов записей
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				result = sqlite3_column_int(statement, 0);
				break;
			}
		}
		sqlite3_finalize(statement);
	} else {
		sqlite3_close(database);
		NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	return result;
}


-(void) copyDataBase {
	MRLogFunc(1);
	BOOL success;
	NSError *error;
	
	NSString *homePath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
	NSString *writableDBPath = [homePath stringByAppendingPathComponent:_dataBase];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_dataBase];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	}
	if (!success) {
		NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	_path = [homePath retain];
}

-(void) dealloc {
	MRLogFunc(1);
	[_sharedController removeObjectForKey:_dataBase];
	[_dataBase release];
	[_path release];
	if ([_sharedController count] < 1) {
		[_sharedController release];
		_sharedController = nil;
	}
	[super dealloc];
}

@end
