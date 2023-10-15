/* +-----------------------------------------------------------------------+
 |  StudySage                                                              |
 +-------------------------------------------------------------------------+ */

import GUI
View.Set ("graphics:1280;720,nobuttonbar")
Dir.Change ("Files")

% Variables
var gren : int := 169
var logo : int := Pic.Scale (Pic.FileNew ("LOGO.bmp"), 186, 96)
var border : int := Pic.FileNew ("BORDER.bmp")
var MusicStatus : boolean := false

% Procedures
forward proc sidebar
forward proc mprint (text : string)
forward proc ShowB
forward proc drawSideBar
forward proc MUSIC
forward proc drawBorder

% FEATURES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure list_tasks (arr : array 1 .. * of string)
    for i : 1 .. upper (arr)
	if arr (i) not= "COCONUT" then % This is a coconut we don't need it but it breaks everything without it there
	    put "Task ", i, ": " ..
	    put arr (i)
	end if
    end for
end list_tasks

proc AGENDA % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    var selection : string (1) := ""
    var stream : int
    var taskCount : int := 0
    var agenda : flexible array 1 .. 0 of string

    % Create Save!
    if File.Exists ("agendafile.txt") = false then
	open : stream, "agendafile.txt", put
	close : stream
    end if

    % Get Data
    open : stream, "agendafile.txt", get
    loop
	exit when eof (stream)
	new agenda, upper (agenda) + 1
	get : stream, agenda (upper (agenda)) : *
	%THIS ASTREISK IS IMPORTANT WITHOUT IT EVERY SPACE WOULD BE ENTERED AS A NEW TASK (eg. "finish math homeowork" would be 3 tasks for each word without that beautiful amazing sexy asterisk)
	taskCount := taskCount + 1
    end loop
    close : stream

    loop
	cls
	put "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	put "1 - Add Task"
	put "2 - List Tasks"
	put "3 - Complete/Delete Task"
	put "Press Space Bar to Activate Sidebar"
	put "\nUse keyboard to select operation."
	drawSideBar
	drawBorder

	selection := ""
	getch (selection)

	%ADDING A TASK
	%-----------------------------------------------------------------------------------------------------
	if selection = ('1') then
	    cls
	    drawSideBar
	    drawBorder

	    %V2 VERSION: now using flexible arrays so we dont need to look for an empty slot
	    var taskName : string
	    mprint ("Please enter task name: ")
	    get taskName : * %This makes sure that the user can input spaces I have no idea why it did not let me do this before but it doesnt work without this baboon

	    %update taskCount
	    taskCount := taskCount + 1

	    %add to array
	    new agenda, taskCount
	    agenda (taskCount) := taskName


	    %------------------------------------------------------------------------------------------------------

	    %LISTING TASKS
	    %------------------------------------------------------------------------------------------------------

	    %if there are no tasks say congrats u finished all tasks
	elsif selection = ('2') then
	    if taskCount = 0 then
		mprint ("\nCongrats you finished all your tasks you have nothing on your Agenda :D")
		delay (1500)
	    else
		cls

		put "Agenda: "
		put ""
		list_tasks (agenda)
		put ""
		mprint ("Click any character to continue")
		drawBorder

		loop
		    exit when hasch
		end loop
	    end if

	    %-----------------------------------------------------------------------------------------------------


	    %DELETING TASKS
	    %------------------------------------------------------------------------------------------------------
	elsif selection = ('3') then
	    cls
	    drawSideBar
	    drawBorder

	    %first check if there are any tasks to delete/complete
	    if taskCount = 0 then
		mprint ("\nYou do not have any tasks to delete/complete")
		delay (1500)
	    else
		loop
		    put "Agenda: "
		    put ""
		    list_tasks (agenda)
		    put ""

		    put "Enter the Task you would like to complete/delete (NUMBER!)"
		    put ">> " ..
		    drawSideBar
		    drawBorder
		    var AGremoveIndex : int

		    %V2 VERSION: renamed taskNumber to RemoveIndex, and the upper bound of the if is now going to to be taskCount


		    get AGremoveIndex
		    %upper bound is less than or equal to task count
		    if AGremoveIndex > 0 & AGremoveIndex <= taskCount then

			for i : AGremoveIndex .. upper (agenda) - 1
			    agenda (i) := agenda (i + 1)
			end for

			new agenda, upper (agenda) - 1
			%update taskcount
			taskCount := taskCount - 1
			exit

		    else
			mprint ("Invalid Task Number.")
			delay (1500)
			cls
		    end if

		    exit when AGremoveIndex > 0 & AGremoveIndex <= taskCount
		end loop

	    end if

	    %-----------------------------------------------------------------------------------------------------

	elsif selection = (' ') then
	    open : stream, "agendafile.txt", put

	    %creating a loop of taskCount length

	    for i : 1 .. taskCount
		put : stream, agenda (i)
	    end for

	    %if agenda is empty (which means taskcount is 0) we need to clear the entire file
	    close : stream

	    exit
	end if
    end loop

end AGENDA

% Calendar Procedures
var dat : string
var word : array char of boolean
var year, month, day, maxX, iWidth : int
var dmonths : array 1 .. 12 of int := init (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
var months : array 1 .. 12 of string := init ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
var x : array 1 .. 6, 1 .. 7 of int
var y : array 1 .. 6, 1 .. 7 of int
var text : array 1 .. 6, 1 .. 7 of string
maxX := 1080

proc grid
    var startx := floor ((maxX - 7 * floor (maxX / 7)) / 2)
    var starty := maxy - (floor ((maxy - 100) / 6))
    for a : 1 .. 6
	for b : 1 .. 7
	    x (a, b) := startx
	    y (a, b) := starty
	    startx += floor (maxX / 7)
	end for
	startx := floor ((maxX - 7 * floor (maxX / 7)) / 2)
	starty -= floor ((maxy - 100) / 6)
    end for
    drawfillbox (x (6, 1), y (6, 1) - floor ((maxy - 100) / 6), x (1, 7) + floor (maxX / 7), y (1, 7), 191)
    for a : 1 .. 6
	drawline (x (a, 1), y (a, 1), x (a, 7) + floor (maxX / 7), y (a, 7), black)
    end for
    for b : 1 .. 7
	drawline (x (1, b), y (1, b), x (6, b), y (6, b) - floor ((maxy - 100) / 6), black)
    end for
    drawline (x (1, 7) + floor (maxX / 7), y (1, 7), x (6, 7) + floor (maxX / 7), y (6, 7) - floor ((maxy - 100) / 6), black)
    drawline (x (6, 1), y (6, 1) - floor ((maxy - 100) / 6), x (6, 7) + floor (maxX / 7), y (6, 7) - floor ((maxy - 100) / 6), black)
end grid

function leapyear (var year : int) : int
    %Checks if the current year is a leap year
    var days : int
    if year mod 4 not= 0 then
	days := 28
    else
	if year mod 100 = 0 then
	    if year mod 4 = 0 then
		days := 29
	    else
		days := 28
	    end if
	else
	    days := 29
	end if
    end if
    result days
end leapyear

function weekday (month, day, year : int) : int
    % calculates the day of the week based on the date passed in.
    % eg: Sun = 0   Mon = 1  .... Sat = 6
    var k, oldmonth, yr, oldyear, oldday, oldc : int
    yr := year
    oldmonth := (month + 9) mod 12 + 1
    oldday := day
    if (month = 1 or month = 2) then
	yr := yr - 1
    end if
    oldyear := yr mod 100
    oldc := yr div 100
    k := floor (2.6 * oldmonth - 0.2) + (oldyear div 4)
    k := k + (oldc div 4) + oldday + oldyear - (2 * oldc)
    if (k < 0) then
	k := k - 7 * (k div 7)
    end if
    result (k mod 7) + 1
end weekday

proc Assign
    var counter : int := 0
    var start : boolean := false
    for a : 1 .. 6
	for b : 1 .. 7
	    if b = weekday (month, 1, year) and a = 1 then
		start := true
	    end if
	    if start = true then
		counter += 1
		text (a, b) := intstr (counter)
	    else
		text (a, b) := ""
	    end if
	    if strintok (text (a, b)) then
		if strint (text (a, b)) = dmonths (month) then
		    start := false
		end if
	    end if
	end for
    end for
end Assign

proc print
    var font := Font.New ("Century Gothic:28")

    var col : int
    for a : 1 .. 6
	for b : 1 .. 7
	    if text (a, b) not= intstr (day) then
		col := 31
	    elsif text (a, b) = intstr (day) and month = 10 and year = 2023 then
		col := 31
		drawfill (x (a, b) + 10, y (a, b) - 10, 169, black)
	    end if

	    if length (text (a, b)) < 2 then
		Draw.Text (text (a, b), x (a, b) + floor (maxX / 7 / 2) - 10, y (a, b) - floor (maxy / 6 / 2) - 10, font, col)
	    else
		Draw.Text (text (a, b), x (a, b) + floor (maxX / 7 / 2) - 20, y (a, b) - floor (maxy / 6 / 2) - 10, font, col)
	    end if
	end for
    end for
    font := Font.New ("Century Gothic:36")
    var font2 := Font.New ("Century Gothic:12")

    iWidth := Font.Width (months (month) + " " + intstr (year), font)
    Draw.Text (months (month) + " " + intstr (year), maxX div 2 - iWidth div 2, maxy - 68, font, black)
    Draw.Text ("Press Space to Access SideBar", maxX div 2 - Font.Width ("Press Space to Access SideBar", font2) div 2, maxy - 90, font2, black)
    drawbox (0, 0, maxX, maxy, black)
end print

proc validate
    day := 15
    month := 10
    year := 2023
    setscreen ("nocursor")
end validate

proc CALENDAR % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cls
    loop
	% Draw SideBar
	drawSideBar
	validate
	grid
	Assign
	print
	loop
	    Input.KeyDown (word)
	    Input.Flush ()
	    if word (KEY_UP_ARROW) then
		if month = 1 then
		    month := 12
		    year -= 1
		else
		    month -= 1
		end if
		cls
		% Draw SideBar
		drawSideBar
		grid
		Assign
		print
		delay (100)

	    elsif word (KEY_DOWN_ARROW) then
		Input.Flush ()
		if month = 12 then
		    month := 1
		    year += 1
		else
		    month += 1
		end if
		cls
		% Draw SideBar
		drawSideBar
		grid
		Assign
		print
		delay (100)

	    elsif word (' ') then
		sidebar
	    end if
	end loop
	delay (300)
    end loop
end CALENDAR

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Variables
var noteName : flexible array 1 .. 0 of string
var choice, stremin, stremout : int
var noteCount := 0
var key : string (1) := ""

% Procedures
proc displayNotes
    var viewNote, printText : string
    var viewNoteNum : int
    var noteStatus : boolean
    loop
	cls
	put "Notes:"
	for i : 1 .. upper (noteName)
	    put noteName (i)
	end for

	% Check for notes
	put "Choose note to display : " ..
	drawSideBar
	drawBorder
	get viewNote : *
	drawSideBar
	drawBorder

	% Iterate until note is found
	for i : 1 .. noteCount
	    if viewNote = noteName (i) then
		noteStatus := true
		viewNoteNum := i
		exit
	    end if
	    noteStatus := false
	end for

	% If it does not exist
	if noteStatus = false then
	    mprint ("Error: Please Enter an Existing Note (Case Sensitive)!")
	    delay (1500)
	end if

	exit when noteStatus = true
    end loop

    % Print out note
    cls
    put ("Press Any Key to Exit\n")
    open : stremout, noteName (viewNoteNum) + ".txt", get
    loop
	exit when eof (stremout)
	get : stremout, printText : *
	put printText
    end loop

    loop
	exit when hasch
    end loop
end displayNotes

proc addNote
    noteCount += 1
    var status : boolean := true
    new noteName, noteCount

    % Get Note Name
    loop
	cls
	put ("Enter Note Name: ") ..
	drawSideBar
	drawBorder
	get noteName (noteCount) : *
	drawSideBar
	drawBorder

	% Check if it already exists
	for i : 1 .. noteCount - 1
	    if noteName (noteCount) = noteName (i) then
		status := false
	    else
		status := true
	    end if
	end for

	if status = false then
	    mprint ("Error: This file already exists!")
	    delay (1500)
	end if

	exit when status = true
    end loop

    cls
    % Put Note Title
    open : stremin, noteName (noteCount) + ".txt", put
    put : stremin, noteName (noteCount) + "\n"

    % Add Note
    var newNote : string
    put "Enter your note (enter \"END\" to finish): "
    loop
	get newNote : *

	if Str.Upper (newNote) not= "END" then
	    put : stremin, newNote
	end if

	exit when Str.Upper (newNote) = "END"
    end loop
    close : stremin

end addNote

proc deleteNote
    var removeIndex : int

    % Display Notes
    loop
	cls
	put "Notes:"
	for i : 1 .. upper (noteName)
	    put "(", i, ") ", noteName (i)
	end for
	put ""

	put "Enter note to remove (NUMBER!):"
	drawSideBar
	drawBorder
	get removeIndex
	drawSideBar
	drawBorder

	%upper bound is less than or equal to task count
	if removeIndex > 0 & removeIndex <= noteCount then

	    File.Delete (noteName (removeIndex) + ".txt")
	    for i : removeIndex .. upper (noteName) - 1
		noteName (i) := noteName (i + 1)
	    end for

	    new noteName, upper (noteName) - 1
	    %update taskcount
	    noteCount := noteCount - 1

	    % Save Data
	    open : stremout, "noteconfig.sav", write
	    write : stremout, noteCount

	    % Save array data
	    for i : 1 .. noteCount
		write : stremout, noteName (i)
	    end for
	    close : stremout

	    mprint ("Success!")
	    delay (1000)
	    exit
	else
	    mprint ("Invalid Number.")
	    delay (1500)
	end if

	exit when removeIndex > 0 & removeIndex <= noteCount
    end loop

end deleteNote

proc NOTES % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if File.Exists ("noteconfig.sav") then
	open : stremin, "noteconfig.sav", read
	read : stremin, noteCount

	% update array size
	for i : 1 .. noteCount
	    new noteName, i
	end for

	% get array data
	for i : 1 .. noteCount
	    read : stremin, noteName (i)
	end for
	close : stremin
    end if

    loop
	cls
	Input.Flush
	put "Note Taking Database\n"
	put "1. Read Notes"
	put "2. Add a Note"
	put "3. Delete Note"
	put "Press Space Bar to Activate Sidebar"
	put "\nUse keyboard to select operation."
	drawSideBar
	drawBorder

	key := ""
	getch (key)

	% Display Note
	if key = ('1') then

	    % if there are no notes
	    if noteCount = 0 then
		mprint ("No Notes!")
		delay (1500)
	    else
		%View Notes
		displayNotes ()
	    end if

	    % Add Note
	elsif key = ('2') then
	    addNote ()

	    % Delete Note
	elsif key = ('3') then
	    if noteCount = 0 then
		mprint ("No Notes!")
		delay (1500)
	    else
		deleteNote ()
	    end if

	    % Quit
	elsif key = (' ') then
	    % Save Data
	    open : stremout, "noteconfig.sav", write
	    write : stremout, noteCount

	    % Save array data
	    for i : 1 .. noteCount
		write : stremout, noteName (i)
	    end for

	    close : stremout
	    exit
	end if
    end loop
    sidebar
end NOTES

proc QUIT
    quit
end QUIT

% BUTTONS
var bAGENDA : int := GUI.CreateButtonFull (maxx - 200 + 7, maxy div 2 + 20, 186, "Agenda", AGENDA, 40, '*', false)
var bCALENDAR : int := GUI.CreateButtonFull (maxx - 200 + 7, maxy div 2 - 25, 186, "Calendar", CALENDAR, 40, '*', false)
var bNOTES : int := GUI.CreateButtonFull (maxx - 200 + 7, maxy div 2 - 70, 186, "Notes", NOTES, 40, '*', false)
var bQUIT : int := GUI.CreateButtonFull (maxx - 200 + 7, maxy div 2 - 115, 186, "Quit", QUIT, 40, '*', false)
var bMUSIC : int := GUI.CreateButtonFull (maxx - 200 + 7, 10, 186, "Music", MUSIC, 40, '*', false)

% MAIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MUSIC
CALENDAR
sidebar

% Procedures ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
body proc sidebar
    drawfillbox (maxx, 0, maxx - 200, maxy, gren)
    Pic.Draw (logo, maxx - 200 + 7, maxy - 96 - 15, 0)

    % Button
    loop
	ShowB
	delay (50)
	exit when GUI.ProcessEvent
    end loop
end sidebar

body proc drawSideBar
    drawfillbox (maxx, 0, maxx - 200, maxy, gren)
    Pic.Draw (logo, maxx - 200 + 7, maxy - 96 - 15, 0)

end drawSideBar

body proc ShowB
    GUI.Show (bAGENDA)
    GUI.Show (bCALENDAR)
    GUI.Show (bNOTES)
    GUI.Show (bQUIT)
    GUI.Show (bMUSIC)
end ShowB

body proc mprint (text : string)
    put text
    drawSideBar
end mprint

body proc MUSIC
    if MusicStatus = false then
	MusicStatus := true
    elsif MusicStatus = true then
	MusicStatus := false
    end if

    if MusicStatus = true then
	Music.PlayFileLoop ("backgroundmusic.mp3")
    else
	Music.PlayFileStop
    end if
end MUSIC

body proc drawBorder
    Pic.Draw (border, 0, 0, 0)
end drawBorder
