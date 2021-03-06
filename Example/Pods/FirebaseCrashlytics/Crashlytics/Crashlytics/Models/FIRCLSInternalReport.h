// Copyright 2019 Google
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>

#include "FIRCLSFeatures.h"

extern NSString *const CLSReportBinaryImageFile;
extern NSString *const CLSReportExceptionFile;
extern NSString *const CLSReportCustomExceptionAFile;
extern NSString *const CLSReportCustomExceptionBFile;
extern NSString *const CLSReportSignalFile;
#if CLS_MACH_EXCEPTION_SUPPORTED
extern NSString *const CLSReportMachExceptionFile;
#endif
extern NSString *const CLSReportErrorAFile;
extern NSString *const CLSReportErrorBFile;
extern NSString *const CLSReportMetadataFile;
extern NSString *const CLSReportInternalIncrementalKVFile;
extern NSString *const CLSReportInternalCompactedKVFile;
extern NSString *const CLSReportUserIncrementalKVFile;
extern NSString *const CLSReportUserCompactedKVFile;

@class FIRCLSFileManager;

@interface FIRCLSInternalReport : NSObject

+ (instancetype)reportWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path
         executionIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithPath:(NSString *)path;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property(nonatomic, copy, readonly) NSString *directoryName;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, assign, readonly) BOOL needsToBeSubmitted;

// content paths
@property(nonatomic, copy, readonly) NSString *binaryImagePath;
@property(nonatomic, copy, readonly) NSString *metadataPath;

- (void)enumerateSymbolicatableFilesInContent:(void (^)(NSString *path))block;

- (NSString *)pathForContentFile:(NSString *)name;

// Metadata Helpers

/**
 * Returns the org id for the report.
 **/
@property(nonatomic, copy, readonly) NSString *orgID;

/**
 * Returns the Install UUID for the report.
 **/
@property(nonatomic, copy, readonly) NSString *installID;

/**
 * Returns YES if report contains a signal, mach exception or unhandled exception record, NO
 * otherwise.
 **/
@property(nonatomic, assign, readonly) BOOL isCrash;

/**
 * Returns the session identifier for the report.
 **/
@property(nonatomic, copy, readonly) NSString *identifier;

/**
 * Returns the custom key value data for the report.
 **/
@property(nonatomic, copy, readonly) NSDictionary *customKeys;

/**
 * Returns the CFBundleVersion of the application that generated the report.
 **/
@property(nonatomic, copy, readonly) NSString *bundleVersion;

/**
 * Returns the CFBundleShortVersionString of the application that generated the report.
 **/
@property(nonatomic, copy, readonly) NSString *bundleShortVersionString;

/**
 * Returns the date that the report was created.
 **/
@property(nonatomic, copy, readonly) NSDate *dateCreated;

@property(nonatomic, copy, readonly) NSDate *crashedOnDate;

/**
 * Returns the os version that the application crashed on.
 **/
@property(nonatomic, copy, readonly) NSString *OSVersion;

/**
 * Returns the os build version that the application crashed on.
 **/
@property(nonatomic, copy, readonly) NSString *OSBuildVersion;

@end
