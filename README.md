LanguageToolNSServer
====================

A NSSpellServer that forwards requests to LanguageTool for grammar checking


This is a quick-and-dirty hack to use [LanguageTool](https://www.languagetool.org/) as a spell/grammar server on Mac OS X.

To use it, build the project, download LanguageTool and run it as a local HTTP service at port 8081.

To run LanguageTool:

    java -cp languagetool-server.jar org.languagetool.server.HTTPServer --port 8081
    
To create and install the service:

* Download the project. 
* Do a ``pod install'' to install dependencies (you need cocoapods). 
* Open LanguageToolServer.xcworkspace (Not the xcproject).
* In the project LanguageToolApp-Info.plist, edit the service and add or remove the desired languages (as iso codes) 
* Build LanguageTool.service
* Copy the LanguageTool.service bundle to ~/Library/Services 
* To force the system to pick it up, go to the terminal and execute:


    /System/Library/CoreServices/pbs -update

You can then use TextEdit or any editor using the standard spelling and grammar dialog to check your texts.


