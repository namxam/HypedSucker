# MainWindowController.rb
# HypedSucker
#
# Created by Maximilian Schulz on 21.12.10.
# Copyright 2010 Freelancer. All rights reserved.


class MainWindowController

	attr_accessor :button, :artistLabel, :titleLabel, :filenameField, :statusIndicator, :mainWindow
	
	def	clicked(sender)
		# Create the file location
		fileLocation = "~/Downloads/#{filenameField.stringValue}".stringByExpandingTildeInPath
		
		# create the connection with the request and start loading the data
		FileDownload.new(@currentUrl, @authCookieData, statusIndicator).download_to(fileLocation)
		
		# Start download animation
		statusIndicator.startAnimation(self)
	end
	
	# When the window is initialized from the .xib
	def	awakeFromNib
		# Do nothing
		registerMyUrlScheme
	end
	
		# When all init processes are completed
	def applicationDidFinishLaunching(notification)
		#
	end
	
	def registerMyUrlScheme
		# Access the event manager
		eventManager = NSAppleEventManager.sharedAppleEventManager
		
		# Fake kInternetEventClass, kAEGetURL constants
		gurl = 'GURL'.unpack('N').first
		
		# Register our getUrl method as the proper delegate
		eventManager.setEventHandler(self, andSelector: :"getUrl:withReplyEvent:", forEventClass:gurl, andEventID:gurl)
	end
	
	# NSAppleEventDescriptor: event, NSAppleEventDescriptor
	def getUrl (event, withReplyEvent:replyEvent)
		# Get the url as string
		rawUrl = event.paramDescriptorForKeyword('----'.unpack('N').first).stringValue
		
		# Replace our url scheme
		@currentUrl = NSURL.URLWithString rawUrl.gsub('hypedsucker://', 'http://')
		
		# post process the url
		processMetaData(@currentUrl.query)
		
		#processCookieData
		
		# Suggest a file name
		suggestedFilename = "#{artistLabel.stringValue} - #{titleLabel.stringValue}.mp3"
		filenameField.setStringValue(suggestedFilename)
		
		# Reset the status indicator
		statusIndicator.setDoubleValue(0.0)
		statusIndicator.setIndeterminate(true)
		
		# Bring app window to the front
		mainWindow.makeMainWindow
	end
	
	# Process the meta data provided by the url in form of a query string
	def	processMetaData(queryString)
		params = CGI::parse(queryString)
		
		# Set artist name and track title
		artistLabel.setStringValue(params['artist'] && params['artist'][0] || 'unknown')
		titleLabel.setStringValue(params['title'] && params['title'][0] || 'unknown')
		
		# Store cookie auth data
		@authCookieData = params && params['cookie']
	end
	
end