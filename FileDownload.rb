# FileDownload.rb
# HypedSucker
#
# Created by Maximilian Schulz on 21.12.10.
# Copyright 2010 Freelancer. All rights reserved.


class FileDownload
	
	USER_AGENT = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.19 Safari/534.13"
	
	attr_accessor :bytesReceived
	
	def	initialize(url, cookieData, statusIndicator = nil)
		@request = NSMutableURLRequest.requestWithURL(url)
		
		# Set a decent user agent
		@request.setValue(USER_AGENT, forHTTPHeaderField:"User-Agent")
		
		# Set the auth cookie
		@request.setValue("AUTH=#{cookieData}", forHTTPHeaderField:"Cookie")
		
		# Store reference to status indicator
		@statusIndicator = statusIndicator
	end
	
	def	download_to(destination)
		connection = NSURLDownload.alloc.initWithRequest(@request, delegate:self)
		if connection
			connection.setDestination(destination, allowOverwrite:true)
		end
	end
	
	def download(download, didFailWithError:error)
		puts "Download failed"
	end
 
	def downloadDidFinish(download)
		puts "download finished"
		if @statusIndicator
			@statusIndicator.stopAnimation(self)
		end
	end
	
	# NSURLDownload, NSURLResponse
	def download(download, didReceiveResponse:response)
		# Reset the progress, this might be called multiple times. 
		# bytesReceived is an instance variable defined elsewhere.
    self.bytesReceived = 0.0;
 
    # Retain the response to use later.
		@downloadResponse = response
		#setDownloadResponse(response)
		
		if response.expectedContentLength > 0 and @statusIndicator
			@statusIndicator.setIndeterminate(false)
			@statusIndicator.setMaxValue(response.expectedContentLength.to_f)
		end
	end
	
	# NSURLDownload, unsigned
	def download(download, didReceiveDataOfLength:length)
    # Update the amout of downloaded data
    self.bytesReceived = self.bytesReceived + length.to_f
 
		# Get the expected download size
		@expectedFileSize ||= @downloadResponse.expectedContentLength.to_f
		
		# Check if everything is fine
    if @expectedFileSize != -1 and @statusIndicator
			@statusIndicator.setDoubleValue(self.bytesReceived)
    end
	end
	
end