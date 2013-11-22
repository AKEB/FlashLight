//
//  MRSqlite.h
//  AMFObject
//
//  Created by AKEB on 1/9/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MRConfig.h"
#import "MRDefine.h"
#import "MRLog.h"

typedef enum _MRSSQLITEMODES{
	MRSqlModeNone = 0,
    MRSqlModeInsert = 1,
    MRSqlModeUpdate = 2,
    MRSqlModeReplace = 3,
} MRSSQLITEMODES;

@interface MRSqlite : NSObject {
	BOOL _readonly;
	NSString *_path;
	NSString *_dataBase;
}

+(MRSqlite *) sharedController:(NSString *)dataBase;
+(MRSqlite *) sharedController:(NSString *)dataBase readonly:(BOOL)readonly;


-(NSDictionary *) get:(NSString *)table ref:(id)ref;
-(NSDictionary *) get:(NSString *)table ref:(id)ref add:(NSString *)add;
-(NSDictionary *) get:(NSString *)table ref:(id)ref add:(NSString *)add refName:(NSString *)refName;

-(NSArray *) list:(NSString *)table;
-(NSArray *) list:(NSString *)table ref:(NSDictionary *)ref;
-(NSArray *) list:(NSString *)table ref:(NSDictionary *)ref add:(NSString *)add;
-(NSArray *) list:(NSString *)table ref:(NSDictionary *)ref add:(NSString *)add fieldList:(NSString *)fieldList;

-(int) count:(NSString *)table;
-(int) count:(NSString *)table ref:(NSDictionary *)ref;
-(int) count:(NSString *)table ref:(NSDictionary *)ref add:(NSString *)add;

-(int) remove:(NSString *)table ref:(id)ref;
-(int) remove:(NSString *)table ref:(id)ref add:(NSString *)add;
-(int) remove:(NSString *)table ref:(id)ref add:(NSString *)add refName:(NSString *)refName;

-(BOOL) truncate:(NSString *)table;

-(int) save:(NSString *)table params:(NSDictionary *)param;
-(int) save:(NSString *)table params:(NSDictionary *)param refName:(NSString *)refName;
-(int) save:(NSString *)table params:(NSDictionary *)param refName:(NSString *)refName add:(NSString *)add;




-(id) initWithDatabase:(NSString *)dataBase readonly:(BOOL)readonly;
-(void) copyDataBase;

-(int) getQueryInt:(NSString *) sql;
-(NSArray *) getQueryArray:(NSString *) sql;
-(NSDictionary *) getQueryRow:(NSString *) sql;
-(BOOL) execQuery:(NSString *) sql;
-(int) execQueryWithChanges:(NSString *) sql;
-(long long int) execQueryWithId:(NSString *) sql;

-(void) dealloc;
@end
