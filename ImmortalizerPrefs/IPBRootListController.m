/* 
    Copyright (C) 2024  Serge Alagon

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>. 
*/

#import <Foundation/Foundation.h>
#import "IPBRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <notify.h>
#import "Localizer.h"



static NSArray *IPBAllInstalledApplicationBundleIdentifiers(void) {
    NSMutableArray *bundleIdentifiers = [NSMutableArray array];
    Class workspaceClass = NSClassFromString(@"LSApplicationWorkspace");
    id workspace = [workspaceClass respondsToSelector:@selector(defaultWorkspace)] ? [workspaceClass performSelector:@selector(defaultWorkspace)] : nil;
    NSArray *applications = [workspace respondsToSelector:@selector(allApplications)] ? [workspace performSelector:@selector(allApplications)] : nil;

    for (id application in applications) {
        NSString *bundleIdentifier = nil;
        if ([application respondsToSelector:@selector(applicationIdentifier)]) {
            bundleIdentifier = [application performSelector:@selector(applicationIdentifier)];
        } else if ([application respondsToSelector:@selector(bundleIdentifier)]) {
            bundleIdentifier = [application performSelector:@selector(bundleIdentifier)];
        }

        if (bundleIdentifier && ![bundleIdentifiers containsObject:bundleIdentifier]) {
            [bundleIdentifiers addObject:bundleIdentifier];
        }
    }

    return bundleIdentifiers;
}

static NSArray *IPBImmortalForegroundBundleIdentifiers(void) {
    NSArray *bundleIdentifiers = [[[NSUserDefaults alloc] initWithSuiteName:@"com.sergy.immortalizer.prefs"] arrayForKey:@"ImmortalForegroundBundleIDs"];
    if (![bundleIdentifiers isKindOfClass:[NSArray class]]) {
        bundleIdentifiers = [[[NSUserDefaults alloc] initWithSuiteName:@"com.apple.springboard"] arrayForKey:@"ImmortalForegroundBundleIDs"];
    }
    if (![bundleIdentifiers isKindOfClass:[NSArray class]]) {
        bundleIdentifiers = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ImmortalForegroundBundleIDs"];
    }
    return [bundleIdentifiers isKindOfClass:[NSArray class]] ? bundleIdentifiers : @[];
}

static NSArray *IPBDefaultSceneSettingsExcludedBundleIdentifiers(void) {
    return @[];
}

@implementation IPBRootListController
-(NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

    [self localizeSpecifiers:_specifiers];

    return _specifiers;
}


- (void)syncSceneSettingsExcludedApplications {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.sergy.immortalizer.prefs"];
    NSMutableArray *excludedBundleIDs = [[prefs arrayForKey:@"ImmortalizerSceneSettingsExcludedBundleIDs"] mutableCopy];
    if (!excludedBundleIDs) {
        excludedBundleIDs = [NSMutableArray array];
    } else {
        [excludedBundleIDs removeObjectsInArray:IPBImmortalForegroundBundleIdentifiers()];
    }

    [prefs setObject:excludedBundleIDs forKey:@"ImmortalizerSceneSettingsExcludedBundleIDs"];
    [prefs synchronize];
    notify_post("com.sergy.immortalizer.preferenceschanged.scenesettings");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self syncSceneSettingsExcludedApplications];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

    NSString *key = specifier.properties[@"key"];
    if ([key isEqualToString:@"ImmortalizerSceneSettingsExcludedBundleIDs"]) {
        [self syncSceneSettingsExcludedApplications];
    }
}

-(void)sourceCode {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/sergealagon/Immortalizer/"] withCompletionHandler:nil];
}

-(void)supportPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://buymeacoffee.com/sergy"] withCompletionHandler:nil];
}

-(void)socialPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://x.com/@srgndrlgn"] withCompletionHandler:nil];
}

- (void)localizeSpecifiers:(NSArray *)specifiers {
    for (PSSpecifier *specifier in specifiers) {
        NSString *labelKey = specifier.properties[@"label"];
        NSString *footerTextKey = specifier.properties[@"footerText"];
        NSArray *validTitles = specifier.properties[@"validTitles"];

        if (labelKey) specifier.name = localizer(labelKey);
        if (footerTextKey) [specifier setProperty:localizer(footerTextKey) forKey:@"footerText"];

        if (validTitles) {
            NSMutableDictionary *mutableTitleDictionary = [NSMutableDictionary dictionary];
            for (NSUInteger i = 0; i < validTitles.count; i++) {
                mutableTitleDictionary[@(i)] = localizer(validTitles[i]);  
            }

            specifier.titleDictionary = [mutableTitleDictionary copy];
        }

    }
}
@end
