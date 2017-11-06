set outputRoot to (choose folder with prompt "Select backup location")
set timeStamp to do shell script "date -n +%y%m%d-%H%M%S"

tell application "Finder"
	set outputRoot to make new folder at outputRoot with properties {name:timeStamp}
end tell

tell application "Notes"
	set allFolders to the name of every folder
end tell

repeat with notesFolderName in allFolders
	
	tell application "Finder"
		set outputFolder to make new folder at outputRoot with properties {name:notesFolderName}
	end tell
	
	tell application "Notes"
		set thisFolder to (the first folder whose name is notesFolderName)
		set footer to 0
		repeat with thisNote in notes of thisFolder
			set thisNoteBody to body of thisNote
			set thisNoteName to name of thisNote
			tell application "Finder"
				try
					set thisNoteFile to (make new file at outputFolder with properties {name:thisNoteName})
				on error
					set thisNoteName to thisNoteName & "_" & footer
					set footer to footer + 1
					set thisNoteFile to (make new file at outputFolder with properties {name:thisNoteName})
				end try
			end tell
			
			set posixPath to (thisNoteFile as string)
			set writeFile to open for access file posixPath with write permission
			write thisNoteBody to writeFile
			close access the writeFile
		end repeat
	end tell
	
end repeat
