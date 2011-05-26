//
//  main.m
//  HypedSucker
//
//  Created by Maximilian Schulz on 21.12.10.
//  Copyright Freelancer 2010. All rights reserved.
//

#import <MacRuby/MacRuby.h>


// Initialize the main runtime
int main(int argc, char *argv[])
{
		// Call the macruby initializer with our ruby script
    return macruby_main("rb_main.rb", argc, argv);
}