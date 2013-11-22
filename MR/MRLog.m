//
//  MRLog.m
//  AMFObject
//
//  Created by AKEB on 1/5/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "MRLog.h"


@implementation MRLog

static MRLog  *_sharedController = nil;

+(MRLog *) sharedController {
	MRLogFunc(1);
	if (!_sharedController) {
		[[MRLog alloc] init];
	}
	return _sharedController;
}

+(void) writeToFile:(NSString *)log {
	//MRLogFunc(1);
	NSDateFormatter *formatDate1 = [[NSDateFormatter alloc] init];
	[formatDate1 setDoesRelativeDateFormatting:YES];
	[formatDate1 setDateFormat:@"yyyyMMddHH"];

	NSString *dirName = [NSString stringWithFormat:@"%@/tmp/Logs",NSHomeDirectory()];
	NSString *fileName = [NSString stringWithFormat:@"%@/%@.log",dirName,[formatDate1 stringFromDate:[NSDate date]] ];
	[formatDate1 release];
	
	NSFileHandle *handler = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
	if (!handler) {
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager createDirectoryAtPath:dirName attributes:nil];
		
		NSString *body = @"";
		[fileManager createFileAtPath:fileName contents:[body dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
		handler = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
	}
	if (!handler) {
		NSLog(@"ERROR: Can't create LOG file!");
	}
	[handler seekToEndOfFile];
	NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
	[formatDate setDoesRelativeDateFormatting:YES];
	[formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[handler writeData:[[NSString stringWithFormat:@"%@ %@[%d:] %@\n",[formatDate stringFromDate:[NSDate date]], [[NSProcessInfo processInfo] processName], [[NSProcessInfo processInfo] processIdentifier], log] dataUsingEncoding:NSUTF8StringEncoding]];
	[handler closeFile];
	[formatDate release];
}

-(id) init {
	MRLogFunc(1);
	self = [super initWithFrame:CGRectMake(0, 0, MRDisplayWidth, MRDisplayHeight)];
	_sharedController = self;
	if (self) {
		[self setOpaque:NO];
		[self setBackgroundColor:[UIColor whiteColor]];

		MRLogTableViewController *tabView = [[MRLogTableViewController alloc] init];
		
		navController = [[UINavigationController alloc] initWithRootViewController:tabView];
		
		[navController.view setFrame:CGRectMake(0, 0, MRDisplayWidth, MRDisplayHeight)];
		
		[self addSubview:[navController view]];
		
		[self setHidden:YES];
	}
	return self;
}

-(void) openLog {
	MRLogFunc(1);
	[self setHidden:NO];
}

-(void) closeLog {
	MRLogFunc(1);
	
	[self setHidden:YES];
	[self release];
}

@end

@implementation MRLogTableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	MRLogFunc(1);
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MRLogFunc(1);
	return [logsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MRLogFunc(1);
	MRLogView *aController = [[MRLogView alloc] init];
	[aController setLogFromName:[logsArray objectAtIndex:indexPath.row]];
	[aController.view setFrame:CGRectMake(0, 0, MRDisplayWidth, MRDisplayHeight)];
	[aController setNavController:self.navigationController];
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
}

- (UITableViewCell*)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MRLogFunc(1);
	static NSString *simpleTextName = @"Simple_Text_Cell_Style";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:simpleTextName];
	
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTextName] autorelease];
	}
	
	NSString *logName = [logsArray objectAtIndex:indexPath.row];
	NSString *title = logName;
	cell.textLabel.text = title;
	return cell;
}

- (void)viewDidLoad {
	MRLogFunc(1);
    [super viewDidLoad];
	
	self.title = @"MRLogs";
	
	[self.view setFrame:CGRectMake(0, 0, MRDisplayWidth, MRDisplayHeight)];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dirName = [NSString stringWithFormat:@"%@/tmp/Logs",NSHomeDirectory()];
	NSError *error;
	logsArray = [[NSMutableArray alloc ] initWithCapacity:1];
	NSArray *array = [fileManager contentsOfDirectoryAtPath:dirName error:&error];
	for (int i=[array count]-1; i>=0; i--) {
		NSString *fileName = [array objectAtIndex:i];
		if ([[fileName componentsSeparatedByString:@".log"] count] == 2) {
			[logsArray addObject:fileName];
		}
	}
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:NULL];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:[MRLog sharedController] action:@selector(closeLog)];
}

- (void)didReceiveMemoryWarning {
	MRLogFunc(1);
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	MRLogFunc(1);
    [super viewDidUnload];
}

- (void)dealloc {
	MRLogFunc(1);
	[logsArray release];
    [super dealloc];
}


@end

@implementation MRLogView

@synthesize navController;

- (void)setLogFromName:(NSString *)logName {
	MRLogFunc(1);
	self.title = logName;
	NSString *dirName = [NSString stringWithFormat:@"%@/tmp/Logs",NSHomeDirectory()];
	NSString *fileName = [NSString stringWithFormat:@"%@/%@",dirName,logName ];
	
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fileName];
	if (file == nil) {
		MRLogError(@"Нет файла логов! %@",fileName);
	}
	NSData *buffer = [file readDataToEndOfFile];
	[file closeFile];
	
	NSString *text = [[NSString alloc] initWithBytes:[buffer bytes] length:[buffer length] encoding:NSUTF8StringEncoding];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(sendLog)];	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MRDisplayWidth, MRDisplayHeight)];
	
	if (!text && [text length] < 1) {
		MRLogError(@"Длина файла %d Кб",([buffer length]/1024));
		MRLogError(@"Не удалось прочитать файл %@",fileName);
		[textView setText:@"Не удается прочитать файл. Возможно он слишком большой. Попробуйте отправить на почту!"];
	} else {
		[textView setText:text];
	}
	
	
	[textView setEditable:NO];
	[self.view addSubview:textView];
	[textView release];
	[text release];
}

-(void) sendLog {
	MRLogFunc(1);
	NSString *dirName = [NSString stringWithFormat:@"%@/tmp/Logs",NSHomeDirectory()];
	NSString *fileName = [NSString stringWithFormat:@"%@/%@",dirName,self.title ];
	//NSString *titleName = [NSString stringWithString:self.title];
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fileName];
	if (file == nil) {
		MRLogError(@"Нет файла логов! %@",fileName);
	}
	NSData *buffer = [file readDataToEndOfFile];
	[file closeFile];
	
	NSString *text = [[NSString alloc] initWithBytes:[buffer bytes] length:[buffer length] encoding:NSUTF8StringEncoding];
	
	int SEND_MODE = 2;
	
	if (!text && [text length] < 1) {
		MRLogError(@"Длина файла %d Кб",([buffer length]/1024));
		MRLogError(@"Не удалось прочитать файл %@",fileName);
		SEND_MODE = 1;
	}
	
	NSString *subjectLine = [NSString stringWithFormat:@"MRLogs [%@] %@",[[NSProcessInfo processInfo] processName],self.title];
	
	[UIApplication sharedApplication].statusBarHidden = YES;
	MFMailComposeViewController *mailClass = (MFMailComposeViewController *)(NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil && [MFMailComposeViewController canSendMail]) {
		//MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] initWithRootViewController:self];
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		
		picker.mailComposeDelegate = self;
		[picker setToRecipients:[NSArray arrayWithObjects:MRLogMailTo,nil]];
		[picker setSubject:subjectLine];
		
		if (SEND_MODE == 1) {
			[picker setMessageBody:@"" isHTML:YES];
		} else if (SEND_MODE == 2) {
			[picker setMessageBody:text isHTML:YES];
		}
		
		[picker addAttachmentData:buffer mimeType:@"text/plain" fileName:self.title];
		
		[[picker view] setFrame:CGRectMake(0, 0, MRDisplayWidth, MRDisplayHeight)];
		
		[[MRLog sharedController] addSubview:[picker view]];
	}
}

- (void)dealloc {
	MRLogFunc(1);
    [super dealloc];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	MRLogFunc(1);
	if (error) {
		MRLogError(@"%@",[error description]);
	}
	
	[[controller view] removeFromSuperview];
	
}

@end

