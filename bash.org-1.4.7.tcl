###############################
##                           ##
##   bash.org quotefetcher   ##
##        for eggdrops       ##
##---------------------------##
##       version: 1.4.7      ##
##      ( 25th Nov 2003 )    ##
##---------------------------##
##       by DJ Grenola       ##
##---------------------------##
##  suggestions & bugs to :  ##
##                           ##
##  bash@alicampbell.org.uk  ##
##                           ##
## You can modify it, but if ##
## you don't credit me, I'll ##
## urinate in your shoes.    ##
##                           ##
###############################

## TBC
## ~~~
## - check through documentation
## - add op-only spit on/off command
## - seems to suffer from the usual eggdrop problem of
##      refusing to display two identical lines in the
##      same batch (try !bash 99060 for the proof)


## VERSION HISTORY
##
## 1.4.7: (25th Nov 2003)
##       - ?? fixed bug where bot would fail to refill
##         bash_cache if random public spit mode is activated ??
##       - script now works in channels whose names contain
##         [square brackets], and sending to nicks containing
##         [square brackets]. Thanks to CGlass for pointing
##         this bug out. No thanks to TCL and its cavalier
##         approach to string handling.

## 1.4.6: (9th Oct 2003)
##       - added option to allow bot to /notice excessively
##         long quotes to people rather than /msging them
##       - uncommented unset lines for the nick/HTTP token
##         and channel/HTTP token hashes
##       - updated documentation
##       - added ability to be able to automatically spit
##         out a random quote every so often
##       - modified random fetch procedure to filter out
##         long quotes before they are placed into the cache
##         (rather than their being filtered afterwards)
##       - fixed bug with quotes containing '[' or ']' not
##         being displayed

## 1.4.5: (14th Sept 2003)
##       - added config option to set the HTTP fetch type
##         (blocking / non-blocking [i.e. callback]) for
##         random, text search and number fetches.
##         Following a discussion on the egghelp forums
##         about different people's preferences for different
##         HTTP modes, I decided to make it possible for the
##         user to pick his or her own.

## 1.4.4: (10th Sept 2003)
##       - added bash_enable_debug constant to enable logging
##         of the control flow into the eggdrop logs
##       - fixed bug with bash_seconds_per_quote preventing
##         any quotes from being displayed ([clock clicks
##         -milliseconds] was returning apparently negative
##         numbers)

## 1.4.3: (not released)
##       - improved documentation
##       - fixed minor bugs in bash_dot_org_fetch_random
##         and bashCallback_number

## 1.4.2: (3rd September 2003)
##       - no longer requires a channel name and so will
##         now work out of the box across all channels the
##         bot is in.

## 1.4.1: (29th August 2003)
##       - 'fixed' problem with regsub for ampersand
##         substitution not working ('&' appearing as
##         '&amp;').

## 1.4: (29th August 2003)
##       - added new !bash <text> command to search
##         for quotes containing text <text>
##       - added new !bash_usage command to display the
##         script commands publically
##       - few minor crappy fixes
##       - removed all puts commands, as some eggdrops
##         didn't seem to like them (thanks to ^DooM^)
##       - floodprotection (^DooM^ again)
##       - configuration improvements
##       - fixed bug that sometimes caused last lines of
##         quotes to be missed out

## b0.3: (25th August 2003)
##       - added new !bash <quotenumber> command to get a
##            specific numbered quote
##       - !bash command now shows the quote numbers
##       - added private message mode for quotes with lots
##            of lines
##       - few minor crappy fixes

## b0.2: (5th August 2003)
##       - initial release version

## b0.1: (?)
##       - experimental, slow, and crap

# ---------------------------------------------
# *** READ THIS ***

# INSTALLATION

# i) Place this TCL into your eggdrop/scripts directory,
# ii) make the usual 'source scripts/bash.org-1.4.7.tcl'
#     entry at the end of eggdrop.conf,
# iii) and rehash the bot as normal.

# CONFIGURATION

# The configuration section is below. Those who insist on
# tinkering will find another section beneath that defining
# various constants used by the script, including nearly all
# the outputted text, and the regexps used to strip the
# quotes from the HTML.
# Don't muck with this if you don't know what you're doing.

# COMMANDS

# The following commands are recognised by default:

# !bash
#     - this displays a random quote from the bash.org quote
#       database. The quote will always appear in a public
#       channel, because the script will ignore entries in
#       its random quote cache that have a length exceeding
#       bash_max_public_line_length.
#	  If you didn't understand this, don't worry about it.

# !bash <text>
#     - Needless to say, the < and > symbols should not be
#       typed in as part of the command.
#       (Unless you're searching for a nick, of course.)
#       Fetches the quote numbers of the first N quotes
#       (N being defined by bash_max_search_results in the
#       config section below) that match text <text>.

# !bash <number>
#     - Again, no < and > symbols, please.
#       Fetches a specific numbered quote from the QDB.
#       If it contains less lines than the
#       bash_max_public_line_length setting,
#       the quote will be displayed publically. If not, it
#       will be privately /msged or /noticed to the use
#       who requested it.

# HOW IT WORKS

# If you want to get on and configure the damn thing, skip this
# section.

# The random quote function was the first written. It makes
# an HTTP query to the 'Random' link on the bash.org front page.
# It receives the response and then uses various regexp filters
# to extract the quotes and place them in a TCL list (bash_cache).
# Meanwhile the numbers of the quotes are stored in another list
# (bash_number_list). The position of the next item that is
# to be displayed from these lists is marked by the
# bash_cache_pointer_position variable. Requesting quotes is
# disabled when the cache is empty and, if not already running,
# an HTTP query is attempted to refill the cache. The cache will
# also be refilled when the pointer hits the end of the list.
# When a quote is requested, bash_cache[bash_cache_pointer_position]
# and bash_number_list[bash_cache_pointer_position] are read,
# the pointer is incremented, and the resulting texts are again
# regexp filtered by the bash_output function for de-escaping of
# HTML entities (&nbsp; etc). If the length of the quote exceeds
# bash_max_public_line_length, the pointer is repeatedly
# incremented until this condition is not true. If
# bash_max_public_line_length is set low, only a few quotes will
# be displayed by this command per HTML query.
# The TCL commands to display the quote in the channel are placed
# on the event queue with the 'after' command and told to execute
# a certain time apart (this time being set by the
# bash_seconds_per_line setting). 

# The !bash <number> command works similarly to the random quote
# function and borrows a lot of code from it. This time, an HTTP 
# query is made to the appropriate bash.org web page for a certain
# numbered quote. The returned HTML is stripped of its tags as
# before. If the quote is longer than bash_max_public_line_length,
# it is privately messaged to the requesting nick. Otherwise,
# it is displayed in the channel.

# The !bash <text> command is a little different to the other two.
# It makes a request using the search function of the bash.org
# website (for a maximum number of quotes set by
# bash_max_search_results), and parses out only the quote numbers
# of the returned HTML. These are always displayed publically.

# ---------------------------------------------
# *** CONFIGURATION SECTION ***
#
set bash_command "!bash"
#
# ^-- the public command to invoke the script
#
#     the suffices '_usage' and '_version', when appended onto the
#     end of this command, also form commands.
#     i.e. if bash_command were, say, "!moose", then the commands
#     "!bash_usage" and "!bash_version"
#     would now become "!moose_usage" and "!moose_version".
#
#
set bash_max_public_line_length 5
#
# ^-- this defines the longest quote (number of lines) which the
#     script will display publically rather than as a private message.
#     Somewhere between 4 and 12 should be good depending on how
#     busy your channel is.
#
#
set bash_seconds_per_quote 6
#
# ^-- this defines the number of seconds that the bot will wait
#     for after displaying one quote before it allows another
#     to be requested. Set to 0 to disable this floodprotection.
#
#
set bash_seconds_per_line 0
#
# ^-- this defines the number of seconds that the bot will wait
#     between displaying two lines of the same quote.
#     Bear in mind that eggdrops won't display more than one
#     line per few seconds even if this is set to 0.
#
#
set bash_max_search_results 10
#
# ^-- maximum number of search results returned by a
#     !bash <text> query.
#     Bear in mind that the maximum IRC server line length will
#     limit you if you set this to something large (> 25 or so).
#
#
set bash_enable_debug 0
#
# ^-- this should always be set to 0 unless you're having some
#     issues, i.e. the script isn't working. Beware that it will
#     spray all sorts of debugging crap into the eggdrop logs.
#
#
set bash_use_blocking_number_fetch 1
set bash_use_blocking_search_fetch 1
set bash_use_blocking_random_fetch 0
#
# ^-- these three define the mode used to make the queries to the
#     bash.org webserver. If you don't understand the difference
#     between blocking and non-blocking (callback) fetch, you're
#     probably better leaving them as they are.
#     This is the default because it has been discovered through
#     experimentation than blocking fetches are a lot faster than non-
#     blocking ones, at least on my eggdrop (1.6.12 / linux 2.4.20).
#     However some may consider non-blocking fetches to be more stable.
#     Feel free to set them to 0 but don't be surprised if it's as
#     slow as a snail.
#
#
set bash_lock_reset_time_ms 600000
#
# ^-- this is the amount of time in milliseconds the script
#     will wait for before removing a stale bash_lock lock.
#     This attempts to combat failed fetch-related siezeups,
#     and their associated annoying public messages.
#     Currently 10 minutes. You shouldn't need to change it.
#     This is new and experimental. I don't know whether it
#     solves the problem successfully or not.
#
#
set bash_use_notices 1
#
# ^-- this specifies whether lengthy quotes should be /noticed to
#     the recipient's nick or /msged there. Set to 0 to use /msg.
#     Set to 1 to use /notice.
#
#
set bash_spit_channel_list [list]

# lappend bash_spit_channel_list "#somechannel 5"
# lappend bash_spit_channel_list "#someotherchannel 10"
# lappend bash_spit_channel_list "#anotherchannel 60"
# lappend bash_spit_channel_list "#\[channel_with_brackets\] 120"
# # ... more lappend lines here ...

#
# ^-- if you want the bot to spit out random quotes into a channel
#     or channels, you will need to add the names of the channels
#     to which this applies by uncommenting one or more 'lappend ...' lines
#     here and changing the channel name and the number that follows
#     it. This number is the number of minutes you want the bot to
#     wait between spitting out one quote and spitting out the next.
#     It may be set independently for each of the channels on the list.
#     There must be a space between the channel name and the number.
#	If your channel name contains [square brackets], you will need
#	to slash-escape the brackets ( '[' -> '\[' , ']' -> '\]' )
#	as in the example above.

# ----------------------------------------------
# *** DEFAULT CHANNEL (PUBLIC) COMMANDS ***

# !bash          :  displays a random quote from the bash.org QDB;
# !bash <number> :  displays a specific quote from the bash.org QDB;
# !bash <text>   :  searches for quotes matching <text> in the bash.org
#                   QDB and displays their numbers;
# !bash_version  :  shows the script version;
# !bash_usage    :  shows the commands that this script supports.

## ---------------------------------------------
## Don't change anything below this line.
## ---------------------------------------------

package require http

set agent "Mozilla"
set query_prefix "http://www.bash.org/?"
set query_suffix_random "random"
set query_suffix_number "quote="
set query_suffix_search "sort=0&"
set query_get_parm_number "show"
set query_get_parm_search "search"
set bash_cache_pointer_position 0
set bash_cache [list]
set bash_number_list [list]
set bash_lock 0
set bash_result_regexp "<p class=\"qt\">(.*?)</p>(.*</html>)"
set bash_number_regexp "<b>#(\[0-9\]+)</b>(.*)"
set bash_newline_regexp "<br />|</p>"

# text strings

set bash_ver 					"!bash for bash.org 1.4.7 by DJGrenola (bash@alicampbell.org.uk)"
set bash_search_result_individual_prefix 	"Q# "
set bash_search_result_separator 		" | "
set bash_command_suffix_debug 		"_debug"
set bash_command_suffix_version 		"_version"
set bash_command_suffix_usage 		"_usage"
set bash_command_suffix_restart 		"_restart"

set bash_errortext_http_fetch 		"error: \002$bash_command\002: command is locked while HTTP fetch is performed. Try again in 10 seconds."
set bash_errortext_failed_init 		"error: \002$bash_command\002: bash_cache is empty (failed initialisation)"
set bash_errortext_cache_spent		"error: \002$bash_command\002: bash_cache is spent (HTTP lookup to refresh it must have failed ... retrying)" 
set bash_errortext_fetch_locked		"error: \002$bash_command\002: bash_lock is 1, cannot continue."
set bash_errortext_infinite_loop		"error: \002$bash_command\002: safety_measure > 100 in bashCallback, assuming infinite loop and terminating"
set bash_errortext_spitlist_invalid		"error: \002$bash_command\002: bash_spit_channel_list contains illegal entries : check configuration"
set bash_unlock_warning				"$bash_ver: WARNING: waited longer than $bash_lock_reset_time_ms for query, unlocking."

set bash_text_search_result_prefix 		"\002$bash_command\002 search results: "
set bash_text_usage_1 				"\002$bash_command\002: usage: $bash_command for a random quote"
set bash_text_usage_2 				"              $bash_command <number> for a specific quote"
set bash_text_usage_3 				"              $bash_command <text> to search for a quote containing text <text>"
set bash_text_no_search_results 		"\002$bash_command\002: no results found for search"
set bash_text_version 				"\002$bash_ver"
set bash_text_too_many_lines_1		"\002$bash_command\002: quote has too many lines to display in public channel (max $bash_max_public_line_length, quote has "
set bash_text_too_many_lines_2		"): sending as privmsg instead"
set bash_text_quote_not_found			"\002$bash_command\002: quote not found"
set bash_text_running				"$bash_ver: RUNNING, use $bash_command to invoke."

bind pubm * "* $bash_command*" bash_decide
bind pubm * "* $bash_command$bash_command_suffix_usage" bash_usage_wrapper
bind pubm * "* $bash_command$bash_command_suffix_version" bash_version

#bind pubm * "* $bash_command$bash_command_suffix_restart" bash_restart
#bind pubm * "* $bash_command$bash_command_suffix_debug" bash_debug

## -------------------------------------------------
## DEFINITELY don't change anything below THIS line.
## -------------------------------------------------

set startup_time [clock clicks -milliseconds]
set bash_last_quote_time [expr $startup_time - 60000]
set bash_nick_token_hash(0) 0
set bash_channel_token_hash(0) 0

## we need to disable any 'after' commands that may still be on
## the event queue from a previous invocation:

set bash_after_list [after info]

foreach token $bash_after_list {
	set id_info [after info $token]
	if { [regexp .*bash_spit.* $id_info] } {
		if { $bash_enable_debug } {
			putlog "!bash: procname matched bash_spit: removing from queue"
		}
		after cancel $token
	}
}

proc bash_debug { n u h c t } {

	global bash_cache
	global bash_lock
	global bash_cache_pointer_position
	global bash_number_list

	op "list length: [llength $bash_cache] | number list length: [llength $bash_number_list] | lock: $bash_lock | bash_cache_pointer_position: $bash_cache_pointer_position" $c

}

proc locked_error { c } {
	global bash_errortext_http_fetch
	op $bash_errortext_http_fetch $c
}

proc bash_decide { n u h c t } {

	global bash_command
	global bash_command_suffix_debug
	global bash_command_suffix_restart
	global bash_command_suffix_usage
	global bash_command_suffix_version
	global bash_last_quote_time
	global bash_seconds_per_quote
	global bash_enable_debug

	if { $bash_enable_debug } {
		putlog "bash_decide $n $u $h $c $t"
	}

	if { [expr "$bash_last_quote_time + ($bash_seconds_per_quote * 1000)"] > [clock clicks -milliseconds] } {
		if { $bash_enable_debug } {
			putlog "bash_decide: returned due to inter-quote time being exceeded: b_l_q_t = $bash_last_quote_time | b_s_p_q = $bash_seconds_per_quote | clock clicks = [clock clicks -milliseconds]"
		}
		return
	}

	if { [regexp "($bash_command$bash_command_suffix_debug *)|($bash_command$bash_command_suffix_restart *)|($bash_command$bash_command_suffix_usage *)|($bash_command$bash_command_suffix_version)" $t] } {
		if { $bash_enable_debug } {
			putlog "bash_decide: returned due to detection of valid alternate command suffix"
		}
		return
	}

	if { [string length $t] > [string length $bash_command] } {
		set blah "^$bash_command *\[0-9\]+$"
		if { [regexp $blah $t match] } {
			bash_number $n $u $h $c $t
			return
		}
		bash_search $n $u $h $c $t
	} else {
		bash_random $n $u $h $c $t
	}

}

proc bash_search { n u h c t } {

	global bash_command
	global agent
	global query_get_parm_search
	global query_get_parm_number
	global query_prefix
	global query_suffix_search
	global bash_max_search_results
	global bash_enable_debug
	global bash_nick_token_hash
	global bash_channel_token_hash
	global bash_use_blocking_search_fetch

	if { $bash_enable_debug } {
		putlog "bash_search $n $u $h $c $t"
	}
		
	regexp "^$bash_command *(.*)$" $t blah text

	http::config -useragent $agent
	set url $query_prefix$query_suffix_search[http::formatQuery $query_get_parm_search $text $query_get_parm_number $bash_max_search_results]
	if { $bash_use_blocking_search_fetch == 0 } {
		set token [http::geturl $url -command bashCallback_search]
		set bash_nick_token_hash($token) $n
		set bash_channel_token_hash($token) $c
	} else {
		set token [http::geturl $url]
		set bash_nick_token_hash($token) $n
		set bash_channel_token_hash($token) $c
		bashCallback_search $token
	}

}

proc bashCallback_search { token } {

	global bash_result_regexp
	global bash_number_regexp
	global bash_max_search_results
	global bash_search_result_separator
	global bash_text_search_result_prefix
	global bash_command
	global bash_search_result_individual_prefix
	global bash_text_no_search_results
	global bash_enable_debug
	global bash_nick_token_hash
	global bash_channel_token_hash

	set nick $bash_nick_token_hash($token)
	set channel $bash_channel_token_hash($token)
	unset bash_nick_token_hash($token)
	unset bash_channel_token_hash($token)

	if { $bash_enable_debug } {
		putlog "bashCallback_search $token $nick $channel"
	}

	catch {

		set result [http::data $token]
		unset $token
		set search_results [list]

		set count 0

		while { [regexp $bash_number_regexp $result blah numero the_rest] } {

			if { $count > $bash_max_search_results } {
				break
			}

			lappend search_results $numero

			set result $the_rest
			incr count

		}

		set search_result_string $bash_text_search_result_prefix
		set separator ""

		foreach search_result $search_results {
			set search_result_string $search_result_string$separator$bash_search_result_individual_prefix$search_result
			set separator $bash_search_result_separator
		}

		if { $count == 0 } {
			op $bash_text_no_search_results $channel
			return
		}

		op $search_result_string $channel

		return

	} errorstg

	putlog $errorstg

}

proc bash_number { n u h c t } {
	global bash_enable_debug
	if { $bash_enable_debug } {
		putlog "bash_number $n $u $h $c $t"
	}
	regexp "\[0-9\]+" $t match
	bash_dot_org_fetch_number $match $n $c
}

proc bash_usage_wrapper { n u h c t } {
	bash_usage $c
}

proc bash_usage { c } {

	global bash_text_usage_1
	global bash_text_usage_2
	global bash_text_usage_3

	op $bash_text_usage_1 $c
	op $bash_text_usage_2 $c
	op $bash_text_usage_3 $c

}

proc bash_version { n u h c t } {
	global bash_text_version
	op $bash_text_version $c
}

proc bash_random { n u h c t } {

	global bash_cache
	global bash_cache_pointer_position
	global bash_lock
	global bash_number_list
	global bash_command
	global bash_errortext_failed_init
	global bash_errortext_cache_spent
	global bash_enable_debug
	global bash_lock_reset_time_ms

	if { $bash_enable_debug } {
		putlog "bash_random $n $u $h $c $t"
	}

#	if { $bash_lock != 0 } {
#		locked_error $c
#		return
#	}
	if { $bash_lock != 0 } {
		locked_error $c
		if { [expr [clock clicks -milliseconds] - $bash_lock] < $bash_lock_reset_time_ms } {
#			putlog $bash_ver $bash_errortext_fetch_locked
			return
		}
		putlog $bash_unlock_warning
		set bash_lock 0
	}

	if { [llength $bash_cache] == 0 } {
		op "bash_cache is empty - refilling ..." $c
		bash_dot_org_fetch_random
		return
	}

	if { $bash_cache_pointer_position >= [llength $bash_cache] } {
		op "bash_cache is empty - refilling ..." $c
		bash_dot_org_fetch_random
		return
	}

	if { [bash_output [lindex $bash_cache $bash_cache_pointer_position] [lindex $bash_number_list $bash_cache_pointer_position] $c $n 1] == 0 } {
		set failed 1
	} else {
		set failed 0
	}

	incr bash_cache_pointer_position

	if { $bash_cache_pointer_position >= [llength $bash_cache] } {
		if { $failed == 1 } {
			locked_error $c
		}
		bash_dot_org_fetch_random
	} else {
		if { $failed == 1 } {
			bash_random $n $u $h $c $t
		}
	}
}

proc bash_output { text number c n allow_failure } {

	global bash_max_public_line_length
	global bash_command
	global bash_text_too_many_lines_1
	global bash_text_too_many_lines_2
	global bash_seconds_per_line
	global bash_last_quote_time
	global bash_enable_debug
	global bash_use_notices
	global bash_newline_regexp

	if { $bash_enable_debug } {
		putlog "bash_output $text $number $c $n $allow_failure"
	}

	regsub -all "(\r)|(\n)" "$text " "" tmp4
	regsub -all $bash_newline_regexp $tmp4 "\n" tmp5
	regsub -all "&gt;" $tmp5 ">" tmp6
	regsub -all "&lt;" $tmp6 "<" tmp7
	regsub -all "&quot;" $tmp7 "'" tmp8
	regsub -all "&nbsp;" $tmp8 " " tmp9
	regsub -all "amp;" $tmp9 "" tmp10

	set lst [split $tmp10 "\n"]

	if { [llength $lst] > $bash_max_public_line_length } {
		if { $allow_failure } {
			return 0
		}
		op $bash_text_too_many_lines_1[llength $lst]$bash_text_too_many_lines_2 $c
		if { $bash_use_notices } {
			set target "NOTICE $n"
		} else {
			set target "PRIVMSG $n"
		}
	} else {
		set target "PRIVMSG $c"
	}

	set delay_increment [expr $bash_seconds_per_line * 1000]
	set delay 0

	set bash_last_quote_time [clock clicks -milliseconds]

	# fix for brackets-in-channel-name bug (thanks CGlass)
	regsub -all \\\] $target \\\] target
	regsub -all \\\[ $target \\\[ target

	foreach tmp11 $lst {
		# these two might look like NOPs. They aren't. Remember square brackets are reserved in regexp too.
		regsub -all \\\] $tmp11 \\\] tmp11
		regsub -all \\\[ $tmp11 \\\[ tmp11
		if { $number == -1 } {
			set to_ex "putserv \"$target :\002|bash|\002 $tmp11\""
			after $delay $to_ex
		} else {
			set to_ex "putserv \"$target :\002|bash $number|\002 $tmp11\""
			after $delay $to_ex
		}
		set delay [expr $delay + $delay_increment]
	}

	return 1

}

proc bash_restart { n u h c t } {
	bash_init
}

proc bash_init { } {

	global bash_ver
	global bash_spit_channel_list
	global bash_error
	global bash_errortext_spitlist_invalid
	global bash_enable_debug
	global bash_lock

	set bash_lock 0

	bash_dot_org_fetch_random

	if { [llength $bash_spit_channel_list] > 0 } {

		if { [check_bash_spit_channel_list] == 0 } {

			putlog $bash_errortext_spitlist_invalid
			die

		} else {

			set i 0

			while { $i < [llength $bash_spit_channel_list] } {

				regexp "^(.+) (\[0-9\]+)$" [lindex $bash_spit_channel_list $i] blah channel delay
				set delay_ms [expr $delay * 60000]

				# fix for brackets-in-channel-name bug (thanks CGlass)
				regsub -all \\\] $channel \\\] channel
				regsub -all \\\[ $channel \\\[ channel
				set to_ex "bash_spit $channel $delay_ms"

				if { $bash_enable_debug } {
					putlog "!bash: placing spit command on event queue : after $delay_ms $to_ex"
				}

				after $delay_ms $to_ex

				incr i

			}
		}
	}
}

proc bash_spit { channel delay } {

	global bash_enable_debug

	if { $bash_enable_debug } {
		putlog "bash_spit $channel $delay"
	}

	bash_random \000 \000 \000 $channel \000

	regsub -all \\\] $channel \\\] channel
	regsub -all \\\[ $channel \\\[ channel

	set to_ex "bash_spit $channel $delay"
	if { $bash_enable_debug } {
		putlog "!bash: placing spit command on event queue : after $delay $to_ex"
	}
	after $delay $to_ex

}

proc check_bash_spit_channel_list { } {

	global bash_spit_channel_list

	set i 0

	while { $i < [llength $bash_spit_channel_list] } {
		if { [regexp "^.+ \[0-9\]+$" [lindex $bash_spit_channel_list $i]] == 0 } {
			return 0
		} else {
			incr i
		}
	}

	return 1

}

proc bash_dot_org_fetch_number { n nick c } {

	global agent
	global query_prefix
	global query_suffix_number
	global bash_enable_debug
	global bash_nick_token_hash
	global bash_channel_token_hash
	global bash_use_blocking_number_fetch

	if { $bash_enable_debug } {
		putlog "bash_dot_org_fetch_number $n $nick $c"
	}

	set query $query_prefix$query_suffix_number$n

	http::config -useragent $agent

	if { $bash_use_blocking_number_fetch == 0 } {
		set token [http::geturl $query -command bashCallback_number]
		set bash_nick_token_hash($token) $nick
		set bash_channel_token_hash($token) $c
	} else {
		set token [http::geturl $query]
		set bash_nick_token_hash($token) $nick
		set bash_channel_token_hash($token) $c
		bashCallback_number $token
	}

}

proc bash_dot_org_fetch_random { } {

	global agent
	global query_prefix
	global query_suffix_random
	global bash_lock
	global bash_command
	global bash_errortext_fetch_locked
	global bash_ver
	global bash_enable_debug
	global bash_use_blocking_random_fetch

	if { $bash_enable_debug } {
		putlog "bash_dot_org_fetch_random"
	}

	set bash_lock [clock clicks -milliseconds]

	http::config -useragent $agent

	if { $bash_use_blocking_random_fetch == 0 } {
		set token [http::geturl $query_prefix$query_suffix_random -command bashCallback_random]
	} else {
		set token [http::geturl $query_prefix$query_suffix_random]
		bashCallback_random $token
	}

}

proc bashCallback_number { token } {

	global bash_result_regexp
	global bash_command
	global bash_text_quote_not_found
	global bash_enable_debug
	global bash_nick_token_hash
	global bash_channel_token_hash

	if { $bash_enable_debug } {
		putlog "bashCallback_number $token"
	}

	set nick $bash_nick_token_hash($token)
	set c $bash_channel_token_hash($token)
	unset bash_nick_token_hash($token)
	unset bash_channel_token_hash($token)

	if { $bash_enable_debug } {
		putlog "bashCallback_number $token $nick $c"
	}

	catch {

		set result [http::data $token]
		unset $token

		if { [regexp $bash_result_regexp $result tmp data] == 1} {
			bash_output $data -1 $c $nick 0
		} else {
			op $bash_text_quote_not_found $c
		}

		return 1

	} blah

	if { $bash_enable_debug } {
		putlog $blah
	}

	return 0

}

proc bashCallback_random { token } {

	global bash_lock
	global bash_cache
	global bash_cache_pointer_position
	global bash_result_regexp
	global bash_number_regexp
	global bash_number_list
	global bash_command
	global bash_errortext_infinite_loop
	global bash_ver
	global bash_enable_debug
	global bash_max_public_line_length
	global bash_newline_regexp

	set bash_cache [list]
	set bash_number_list [list]

	if { $bash_enable_debug } {
		putlog "bashCallback_random $token"
	}

	catch {

		set result [http::data $token]
		unset $token

		set safety_measure 0
		set limit [expr $bash_max_public_line_length + 1]

		while { [regexp $bash_result_regexp $result tmp data the_rest] } {

			if { [regexp "(.*$bash_newline_regexp.*){$limit}" $data] == 0 } {
				if { [regexp $bash_number_regexp $result blah numero] == 1 } {
					lappend bash_number_list $numero
				} else {
					lappend bash_number_list -1
				}
				lappend bash_cache $data
			}

			set result $the_rest
			incr safety_measure

			if { $safety_measure > 100 } {
				putlog $bash_ver $bash_errortext_infinite_loop
				set bash_lock 0
				return
			}
		}

		set bash_cache_pointer_position 0
		set bash_lock 0
		return

	} errorstg

	if { $bash_enable_debug } {
		putlog $errorstg
	}

	set bash_lock 0

}

proc op { o c } {
	putserv "PRIVMSG $c :$o"
}

bash_init

putlog $bash_text_running
