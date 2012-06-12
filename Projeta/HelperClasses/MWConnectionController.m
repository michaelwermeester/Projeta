//
//  PTConnectionController.m
//  Projeta
//
//  Created by Michael Wermeester on 31/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"

@implementation MWConnectionController

#pragma mark propriétés

@synthesize succeededAction;
@synthesize failedAction;

// méthode d'initialisation. Permet de définir les blocks a exécuter. 
- (id)initWithSuccessBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_ {
    
    if ((self = [super init])) {
    
        [self setSucceededAction:successBlock_];
        [self setFailedAction:failureBlock_];
    }
    
    return self;
}

// lancer une requête HTTP pour une URL spécifié. 
- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSMutableURLRequest *)request {
    
    // activer compression gzip.
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    // définir un http-header User-Agent.
	[request setValue:@"Projeta" forHTTPHeaderField:@"User-Agent"];
    
    // appeler NSURLConnection. 
    NSURLConnection* __autoreleasing connectionResponse = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connectionResponse)
    {
        // handle error
        return NO;
    } else {
        receivedData = [NSMutableData data];
    }
    
    return YES;
}

#pragma mark méthodes de callback pour le delegate de NSURLConnection

// lorsque le serveur renvoye une réponse, remettre la longueur de données à 0. 
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    [receivedData setLength:0];
}

// lecture de données et les garder/attacher en mémoire à la variable receivedData.
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [receivedData appendData:data];
}

// gérer les erreurs de connexion/lecture. 
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // exécuter le failure-block et lui passer l'erreur. 
    [self failedAction](error);
}

// exécute lorsque la requête ait terminé. 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // exécuter le success-block et lui passer les donées reçues. 
    [self succeededAction](receivedData);
}

@end
    


