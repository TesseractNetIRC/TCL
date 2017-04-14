#### Comment this off to start this script
die "Did you read your alphachat.tcl?"
### Contact Joe @ irc.alphachat.net
#######Shortcut for Botname
set easykey "sy"
#######All of your bots with this will respond
set easybotnet "**"
#######Home Channel
set home "#dnetworks"
#######Name of your bot rooms w/o #
set organization "BotLand"
###### 1- On     0- Off           This will respond everything to Home Channel
set broadcast 1
set broadcast_flags "x"

##################################################################
# TCL Code
# Do not edit anything below this set of comments. You could
# possibly damage your copy of AlphaChat TCL if you are unfamiliar with
# what you are doing.
#

##################################################################
# Settings Check
#

if {(![info exists easykey]) || ($easykey == "")} {
  if {[string length $botnick] > 2} {
    set easykey "[string index $botnick 0][string index $easykey [expr [string length $botnick] - 1]]"
  } else {
    set easykey "$botnick"
  }
} elseif {$easykey == "(none)"} {
  set easykey ""
}
if {![info exists easybotnet]} {
  set easybotnet ""
}
if {(![info exists home]) || ($home == "")} {
  die "AlphaChat.TCL - You need to specify a home channel for the bot"
} elseif {!([string index $home 0] == "#")} {
  set home "#$home"
}
if {![info exists organization]} {
  set organization ""
}
if {(![info exists broadcast]) || ($broadcast == "") || ($broadcast > 1) || ($broadcast < 0)} {
  set broadcast 1
}
if {($broadcast == 1) && ((![info exists broadcast_flags]) || ($broadcast_flags == ""))} {
  set broadcast_flags "x"
}
if {$broadcast == 1} {
  if {$broadcast_flags == "x"} {
    set broadcast_flags "adgkns"
  }
}

##################################################################
# Security Measures
#

foreach user [userlist A] {
  chattr $user -A
}

##################################################################
# System Variables
#

set flagD D
set flagA A
set defchanmodes {
            -clearbans
            +enforcebans
            +dynamicbans
            +userbans
            -autoop
            -bitch
            +greet
            -protectops
            +statuslog
            +stopnethack
            -revenge
            +autovoice
            -secret
            +shared
            -cycle
        }
set double-mode 1

##################################################################
# TCL Script Binds
#

unbind dcc o|o say *dcc:say
unbind dcc o|- msg *dcc:msg
bind dcc o|n say *dcc:say
bind dcc o msg *dcc:msg
bind pub - $nick ns.kernal
bind pub - $altnick ns.kernal
bind pub - $easykey ns.kernal
bind pub o $easybotnet ns.kernal
bind mode -o "% -o" deopped
bind msg - auth auth
bind msg - login auth
bind sign A * logout
bind kick - * kickwarn
bind join - * onjoin_disp
unbind msg - ident *msg:ident
bind msg - ident do_ident

proc getacc {handle chan} {
  if {[matchattr $handle o]} {
    set access "AlphaChat.TCL Operator"
  }
  if {[matchattr $handle m]} {
    set access "AlphaChat.TCL Co-Administrator"
  }
  if {[matchattr $handle n]} {
    set access "AlphaChat.TCL Administrator"
  }
  if {[info exists access]} {
    return $access
  }
  if {[matchattr $handle |v $chan]} {
    set access "AVoice"
  }
  if {[matchattr $handle |a $chan]} {
    set access "AutoOp"
  }
  if {[matchattr $handle |o $chan]} {
    set access "Channel Operator"
  }
  if {[matchattr $handle |m $chan]} {
    set access "Channel Co-Administrator"
  }
  if {[matchattr $handle |n $chan]} {
    set access "Channel Administrator"
  }
  if {![info exists access]} {
    set access ""
  }
  return $access
}

proc getaccchan {handle chan} {
  if {[matchattr $handle |v $chan]} {
    set access "AVoice"
  }
  if {[matchattr $handle |a $chan]} {
    set access "AutoOp"
  }
  if {[matchattr $handle |o $chan]} {
    set access "Channel Operator"
  }
  if {[matchattr $handle |m $chan]} {
    set access "Channel Co-Administrator"
  }
  if {[matchattr $handle |n $chan]} {
    set access "Channel Administrator"
  }
  if {![info exists access]} {
    set access ""
  }
  return $access
}

proc bcast {type message} {
  global broadcast home broadcast_flags
  if {[string match "*$type*" $broadcast_flags]} {
    putquick "PRIVMSG $home :$message"
  }
}

proc ns.kernal {nick host handle chan arg} {
global home botnick defchanoptions defchanmodes
  set defchanoptions {
  chanmode "+nt"
  idle-kick 0
  need-op { }
  need-invite { }
  need-key { }
  need-unban { }
  need-limit { }
  flood-chan 20:60
  flood-deop 3:10
  flood-kick 3:10
  flood-join 5:60
  flood-ctcp 3:60
  }
  set defchanmodes {
  -clearbans
  +enforcebans
  -dynamicbans
  +userbans
  -autoop
  -bitch
  +greet
  -protectops
  +statuslog
  -stopnethack
  -revenge
  +autovoice
  -secret
  -shared
  +cycle
  }
  set hitkey [string tolower [lindex $arg 0]]
if {[string match "#*" $chan] && ([string match {addchan} $hitkey] == 1)} {
if {[validchan $chan]} {
  set ns1 [lindex $arg 1]
  set ns [lindex $arg 3]
  set tcl [lindex $arg 4]
  set botnet [lrange $arg 2 end]
  set botnet2 [lrange $arg 3 end]
  set botnet3 [lrange $arg 4 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found In Channel Records."
  return 0
  }
  } else {
if {([string match "#*" [lindex $arg 1]]) && ($hitkey != "remchan")} {
  set chan [lindex $arg 1]
  set ns1 [lindex $arg 2]
  set ns [lindex $arg 3]
  set tcl [lindex $arg 4]
  set botnet [lrange $arg 2 end]
  set botnet2 [lrange $arg 3 end]
  set botnet3 [lrange $arg 4 end]
  } else {
  set ns1 [lindex $arg 1]
  set ns [lindex $arg 2]
  set tcl [lindex $arg 3]
  set botnet [lrange $arg 1 end]
  set botnet2 [lrange $arg 2 end]
  set botnet3 [lrange $arg 3 end]
  }
  }
if {[string match {version} $hitkey] == 1} {
  version $nick $host
  return 0
  }
if {[string match {credits} $hitkey] == 1} {
  credits $nick $host
  return 0
  }
if {[string match {botinfo} $hitkey] == 1} {
  botinfo $nick $host $handle $arg
  return 0
  }
if {[string match {commands} $hitkey] == 1} {
  commands $nick $handle $chan $ns1 $host
  return 0
  }
if {[string match {access} $hitkey] == 1} {
  do_access $nick $chan $ns1 $host
  return 0
  }
if {[string match {banlist} $hitkey] == 1} {
  do_banlist $nick $chan $host
  return 0
  }
if {[string match {userlist} $hitkey] == 1} {
  do_userlist $nick $chan $host $ns1
  return 0
  }
if {[string match {help} $hitkey] == 1} {
  help $nick $handle $ns1 $chan $host
  return 0
  }
if {[string match {admin} $hitkey] == 1} {
  admin $nick $host
  return 0
  }
if {![matchattr $handle o|v $chan] && ![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[string match {voice} $hitkey] == 1} {
  voice $nick $handle $chan $ns1 $host $botnet
  return 0
  }
if {[string match {devoice} $hitkey] == 1} {
  devoice $nick $handle $chan $ns1 $host $botnet
  return 0
  }
if {[string match {comment} $hitkey] == 1} {
  comment $nick $handle $host $chan $ns1 $botnet
  return 0
  }
if {[string match {sendnote} $hitkey] == 1} {
  sndnote $nick $handle $ns1 $botnet2 $host $chan
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied"
  return 0
  }
if {[string match {topic} $hitkey] == 1} {
  topic $nick $chan $botnet $host
  return 0
  }
if {[string match {op} $hitkey] == 1} {
  op $nick $chan $ns1 $host $botnet
  return 0
  }
if {[string match {deop} $hitkey] == 1} {
  deop $nick $chan $host $ns1 $botnet $handle
  return 0
  }
if {[string match {kick} $hitkey] == 1} {
  kick $nick $handle $chan $host $ns1 $botnet2
  return 0
  }
if {[string match {ban} $hitkey] == 1} {
  ban $nick $handle $chan $ns1 $ns $botnet2 $botnet3 $host
  return 0
  }
if {[string match {unban} $hitkey] == 1} {
  unban $nick $handle $chan $ns1 $host
  return 0
  }
if {[string match {invite} $hitkey] == 1} {
  invite $nick $handle $host $chan $ns1
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied"
  return 0
  }
if {[string match {usermod} $hitkey] == 1} {
  usermod $nick $handle $chan $ns1 $ns $tcl $host
  return 0
  }
if {[string match {killmodes} $hitkey] == 1} {
  killmodes $nick $chan $host
  return 0
  }
if {[string match {userdel} $hitkey] == 1} {
  userdel $nick $handle $chan $ns1 $ns $host
  return 0
  }
if {[string match {useradd} $hitkey] == 1} {
  useradd $nick $handle $chan $ns1 $host $ns $tcl
  return 0
  }
if {[string match {mode} $hitkey] == 1} {
  mode $nick $chan $botnet $host
  return 0
  }
if {[string match {onjoin} $hitkey] == 1} {
  onjoin $nick $chan $host $botnet
  return 0
  }
if {![matchattr $handle o|n $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {[string match {say} $hitkey] == 1} {
  say $nick $chan $botnet $host
  return 0
  }
if {[string match {act} $hitkey] == 1} {
  act $nick $chan $host $botnet
  return 0
  }
if {[string match {cycle} $hitkey] == 1} {
  cycle $nick $host $handle $chan
  return 0
}
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied"
  return 0
  }
if {[string match {chanstats} $hitkey] == 1} {
  chanstats $nick $host
  return 0
  }
if {[string match {addchan} $hitkey] == 1} {
  addchan $nick $ns1 $host $handle
  return 0
  }
if {[string match {remchan} $hitkey] == 1} {
  remchan $nick $chan $ns1 $handle $host
  return 0
  }
if {[string match {broadcast} $hitkey] == 1} {
  broadcast $nick $host $botnet
  return 0
  }
if {[string match {disable} $hitkey] == 1} {
  disable $nick $handle $host $chan $ns1
  return 0
  }
if {[string match {enable} $hitkey] == 1} {
  enable $nick $host $chan $ns1
  return 0
  }
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied"
  return 0
  }
if {[string match {save} $hitkey] == 1} {
  do_save $nick $host
  return 0
  }
if {[string match {rehash} $hitkey] == 1} {
  do_rehash $nick $host
  return 0
  }
if {[string match {restart} $hitkey] == 1} {
  do_restart $nick $host
  return 0
  }
if {[string match {sendmsg} $hitkey] == 1} {
  sndmsg $nick $ns1 $host $botnet2
  return 0
  }
if {[string match {sendnotice} $hitkey] == 1} {
  sndnotice $nick $ns1 $host $botnet2
  return 0
  }
if {[string match {servers} $hitkey] == 1} {
  servers $nick $host
  return 0
  }
if {![matchattr $handle n]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {([string match {core} $hitkey] == 1) || ([string match {shutdown} $hitkey] == 1) || ([string match {die} $hitkey] == 1)} {
  core $nick $host $handle $botnet
  return 0
  }
  }
proc version {nick host} {
global botnick
  putlog "!$nick ($host)! version"
  putquick "NOTICE $nick :$botnick is operating with \002AlphaChat.TCL\002 version 1.5"
  putquick "NOTICE $nick :Developed by AlphaChat.Net"
  bcast u "\002$nick\002 ($host) has requested version information from me."
  }
proc credits {nick host} {
global botnick
  putlog "!$nick ($host)! credits"
  bcast u "\002$nick\002 ($host) has requested credits information from me."
  putquick "NOTICE $nick :\002NSChat.TCL\002 Version 2.0"
  putquick "NOTICE $nick :Developed by AlphaChat.NET"
  putquick "NOTICE $nick : "
  putquick "NOTICE $nick :AlphaChat Source Code for version 2.0 developed by:"
  putquick "NOTICE $nick :  Joe - webmaster@dnetworks.co.uk"
  }
proc commands {nick handle chan ns1 host} {
global botnick
  putlog "!$nick ($host)! commands"
  putquick "NOTICE $nick :Commands for \002AlphaChat.TCL\002 version 2.0:"
  putquick "NOTICE $nick : "
if {[matchattr $handle n]} {
  putquick "NOTICE $nick :\002AlphaChat.TCL Administrator\002:"
  putquick "NOTICE $nick :  core"
  }
if {[matchattr $handle m]} {
  putquick "NOTICE $nick :\002AlphaChat.TCL Co-Administrator\002:"
  putquick "NOTICE $nick :  rehash restart sendmsg sendnotice servers"
  }
if {[matchattr $handle o]} {
  putquick "NOTICE $nick :\002AlphaChat.TCL Operator\002:"
  putquick "NOTICE $nick :  addchan remchan broadcast save chanstats disable enable"
  }
if {[matchattr $handle o|n $chan]} {
  putquick "NOTICE $nick :\002Channel Administrator\002:"
  putquick "NOTICE $nick :  say act cycle"
  }
if {[matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :\002Channel Co-Administrator\002:"
  putquick "NOTICE $nick :  useradd userdel usermod killmodes mode onjoin"
  }
if {[matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :\002Op\002:"
  putquick "NOTICE $nick :  topic op deop kick ban unban invite"
  }
if {[matchattr $handle o|v $chan]} {
  putquick "NOTICE $nick :\002AVoice\002:"
  putquick "NOTICE $nick :  voice devoice comment sendnote"
  }
  putquick "NOTICE $nick :\002Public\002:"
  putquick "NOTICE $nick :  version userlist banlist botinfo commands help access credits admin auth"
  putquick "NOTICE $nick : "
  putquick "NOTICE $nick :For specific information about a command, type \002(/msg) $botnick help <command>\002"
  }
proc do_banlist {nick chan host} {
global botnick
if {![validchan $chan]} {
  putquick "NOTICE $nick :$chan was not found in the channel records"
  return 0
  }
if {[banlist $chan] == ""} {
  putquick "NOTICE $nick :No bans are set in the bot for $chan"
  } else {
if {!([banlist $chan] == "")} {
  putlog "!$nick ($host)! banlist $chan"
  putquick "NOTICE $nick :Listing bans set in the bot for \002$chan\002:"
  putquick "NOTICE $nick : "
  bcast u "\002$nick\002 ($host) has requested the ban list for $chan."
  set bancount 0
  set banlistlen [llength [banlist $chan]]
  foreach newban [banlist $chan] {
  set mask [lindex $newban 0]
  set reason [lindex $newban 1]
  set expire [lindex $newban 2]
  set added [lindex $newban 3]
  set setter [lindex $newban 5]
  set dateexpired [ctime $expire]
  set dateadded [ctime $added]
  putquick "NOTICE $nick :\002Mask\002: $mask"
  putquick "NOTICE $nick :\002Banned By\002: $setter"
  putquick "NOTICE $nick :\002Reason\002: $reason"
  putquick "NOTICE $nick :\002Additional Information\002:"
  if {$expire == 0} {
    putquick "NOTICE $nick :  Banned from $dateadded without expiration."
  } else {
    putquick "NOTICE $nick :  Banned from $dateadded until $dateexpired."
  }
  incr bancount
  if {($banlistlen > 1) && ($bancount != $banlistlen)} {
    putquick "NOTICE $nick : "
  }
  }
  }
  }
  }
proc do_userlist {nick chan host ns1} {
global botnick
set ulist ""
if {![validchan $chan]} {
  putquick "NOTICE $nick :\002$chan\002 could not be found in the channel records."
  return 0
  }
if {$ns1 == ""} {
  putlog "!$nick ($host)! userlist $chan"
  if {[llength [userlist |f $chan]] < 1} {
    putquick "NOTICE $nick :There are currently no users for \002$chan\002"
    return 0
  }
  bcast u "\002$nick\002 ($host) requested the userlist for $chan."
  putquick "NOTICE $nick :Listing users for \002$chan\002 from the bot's user records:"
  putquick "NOTICE $nick : "
  putquick "NOTICE $nick :[join [userlist |f $chan]]"
  putquick "NOTICE $nick : "
  putquick "NOTICE $nick :For details on a specified user type \002(/msg) $botnick access <user>\002"
  return 0
  }
if {$ns1 == "global"} {
  putlog "!$nick ($host)! userlist global"
  if {[llength [userlist o]] < 1} {
    putquick "NOTICE $nick :There are currently no \002global\002 users"
    return 0
  }
  bcast u "\002$nick\002 ($host) requested the global userlist."
  putquick "NOTICE $nick :Listing \002global\002 users from the bot's user records:"
  putquick "NOTICE $nick : "
  putquick "NOTICE $nick :[join [userlist o]]"
  putquick "NOTICE $nick : "
  putquick "NOTICE $nick :For details on a specified user type \002(/msg) $botnick access <user>\002"
  }
  }
proc do_access {nick chan ns1 host} {
global botnick
if {![validchan $chan]} {
  putquick "NOTICE $nick :\002$chan\002 could not be found in my channel records."
  return 0
  }
if {($ns1 == "") || (($ns1 == "me") && (![onchan "me" $chan]))} {
  set ns1 $nick
}
if {[validuser $ns1]} {
  set hand2 $ns1
  set hand3 [nick2hand $hand2 $chan]
  if {($hand3 == "*") || ($hand3 == "")} {
    set hand3 $hand2
  }
  } elseif {[validuser [nick2hand $ns1 $chan]]} {
  set hand2 $ns1
  set hand3 [nick2hand $hand2 $chan]
  } else {
    putquick "NOTICE $nick :$ns1 was not found in the user records"
    return 0
  }
  set access [getacc $hand3 $chan]
  set rhosts [getuser $hand3 HOSTS]
  set comment [getchaninfo $hand3 $chan]
  putlog "!$nick ($host)! access $chan $hand3"
  bcast u "\002$nick\002 ($host) requested the access for $hand3 on $chan."
  if {$ns1 != $hand3} {
    if {([string match "*AlphaChat*" [getacc [nick2hand $nick $chan] $chan]]) && ([matchattr [nick2hand $nick $chan] A])} {
      if {[matchattr [nick2hand $nick $chan] A]} {
        putquick "NOTICE $nick :Showing access report for \002$hand3\002 ($hand2):"
      } else {
        putquick "NOTICE $nick :Showing access report for \002$hand2\002:"
      }
    } else {
      putquick "NOTICE $nick :Showing access report for \002$hand2\002:"
    }
  } else {
    putquick "NOTICE $nick :Showing access report for \002$hand3\002:"
  }
  putquick "NOTICE $nick :  \002Nickname\002: $hand2"
  if {([string match "*AlphaChat*" [getacc [nick2hand $nick $chan] $chan]]) && ([matchattr [nick2hand $nick $chan] A])} {
    putquick "NOTICE $nick :  \002Handle\002: $hand3"
  }
  if {$access != ""} {
    putquick "NOTICE $nick :  \002Access Level\002: $access"
  }
  if {$comment != ""} {
    putquick "NOTICE $nick :  \002Comment\002: $comment"
  }
  if {([string match "*AlphaChat*" [getacc [nick2hand $nick $chan] $chan]]) && ([matchattr [nick2hand $nick $chan] A])} {
    if {$rhosts != ""} {
      putquick "NOTICE $nick :  \002Hostnames\002: $rhosts"
    }
    if {[matchattr $hand3 A]} {
      putquick "NOTICE $nick :\002$hand2\002 is currently logged-in."
    }
    if {[matchattr $hand3 D]} {
      putquick "NOTICE $nick :Account for \002$hand2\002 is currently disabled."
    }
  }
  return 0
  }
proc help {nick handle ns1 chan host} {
global botnick
if {$ns1 == ""} {
  commands $nick $handle $chan $ns1 $host
  }
if {$ns1 == "auth"} {
  putlog "!$nick ($host)! help auth"
  putquick "NOTICE $nick :HELP ON AUTH - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to authenticate onto the bot to access commands."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :/msg $botnick auth password"
  }
if {$ns1 == "version"} {
  putlog "!$nick ($host)! help version"
  putquick "NOTICE $nick :HELP ON VERSION - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command shows the current version of AlphaChat.TCL the bot is running."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick version"
  }
if {$ns1 == "botinfo"} {
  putlog "!$nick ($host)! help botinfo"
  putquick "NOTICE $nick :HELP ON BOTINFO - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command shows specific information about the bot that is useful in problem solving."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick botinfo"
  }
if {$ns1 == "commands"} {
  putlog "!$nick ($host)! help commands"
  putquick "NOTICE $nick :HELP ON COMMANDS - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to see the current commands available to you depending on how much access you have."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick commands"
  }
if {$ns1 == "access"} {
  putlog "!$nick ($host)! help access"
  putquick "NOTICE $nick :HELP ON ACCESS - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to get information on a added user on the bot"
  putquick "NOTICE $nick :This will show you such information as access,channel access,comment,& there added host(s)."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick access VaLoR"
  }
if {$ns1 == "banlist"} {
  putlog "!$nick ($host)! help banlist"
  putquick "NOTICE $nick :HELP ON BANLIST - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command will show you the list of banned masks for the specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick banlist"
  putquick "NOTICE $nick :(/msg) $botnick banlist #alphachat"
  }
if {$ns1 == "userlist"} {
  putlog "!$nick ($host)! help userlist"
  putquick "NOTICE $nick :HELP ON USERLIST - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to view the added users on a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick userlist"
  putquick "NOTICE $nick :(/msg) $botnick userlist #BotHelp"
  putquick "NOTICE $nick :(/msg) $botnick userlist global"
  }
if {$ns1 == "admin"} {
  putlog "!$nick ($host)! help admin"
  putquick "NOTICE $nick :HELP ON ADMIN - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to gain the administrative contact for the bot."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick admin"
  }
if {$ns1 == "voice"} {
  putlog "!$nick ($host)! help voice"
  putquick "NOTICE $nick :HELP ON VOICE - MINIMUM ACCESS REQUIRED: \002AVOICE\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to give voice (+) to a specified user in a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick voice"
  putquick "NOTICE $nick :(/msg) $botnick voice $nick"
  putquick "NOTICE $nick :(/msg) $botnick voice #alphachat $nick"
  }
if {$ns1 == "devoice"} {
  putlog "!$nick $host)! help devoice"
  putquick "NOTICE $nick :HELP ON DEVOICE - MINIMUM ACCESS REQUIRED: \002AVOICE\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to remove voice (-v) to a specified user on a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick devoice"
  putquick "NOTICE $nick :(/msg) $botnick devoice $nick"
  putquick "NOTICE $nick :(/msg) $botnick devoice #alphachat $nick"
  }
if {$ns1 == "comment"} {
  putlog "!$nick ($host)! help comment"
  putquick "NOTICE $nick :HELP ON COMMENT - MINIMUM ACCESS REQUIRED: \002AVOICE\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used for the sole purpose of the bot saying something as soon as you join a channel that you have access to it in."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick comment my really cool comment"
  putquick "NOTICE $nick :(/msg) $botnick comment #BotHelp my really cool comment"
  }
if {$ns1 == "topic"} {
  putlog "!$nick ($host)! help topic"
  putquick "NOTICE $nick :HELP ON TOPIC - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This sets the channel's topic to a specific topic."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick topic my really cool topic"
  putquick "NOTICE $nick :(/msg) $botnick topic #alphachat my chan topic"
  }
if {$ns1 == "mode"} {
  putlog "!$nick ($host)! help mode"
  putquick "NOTICE $nick :HELP ON MODE - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command allows you to add/remove/modify specific channel modes"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick mode +k blah"
  putquick "NOTICE $nick :(/msg) $botnick mode #BotHelp +k blah"
  }
if {$ns1 == "op"} {
  putlog "!$nick ($host)! help op"
  putquick "NOTICE $nick :HELP ON OP - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to give ops (+o) to a specified user on a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick op"
  putquick "NOTICE $nick :(/msg) $botnick op #AlphaChat"
  putquick "NOTICE $nick :(/msg) $botnick op Joe"
  putquick "NOTICE $nick :(/msg) $botnick op #AlphaChat Joe"
  }
if {$ns1 == "deop"} {
  putlog "!$nick ($host)! help deop"
  putquick "NOTICE $nick :HELP ON DEOP - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to remove op status (-o) from a specified user on a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick deop"
  putquick "NOTICE $nick :(/msg) $botnick deop #AlphaChat"
  putquick "NOTICE $nick :(/msg) $botnick deop Joe"
  putquick "NOTICE $nick :(/msg) $botnick deop #AlphaChat Joe"
  }
if {$ns1 == "kick"} {
  putlog "!$nick ($host)! help kick"
  putquick "NOTICE $nick :HELP ON KICK - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to kick (remove) a user from a specific channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick kick Joe"
  putquick "NOTICE $nick :(/msg) $botnick kick Joe my cool reason"
  putquick "NOTICE $nick :(/msg) $botnick kick #BotHelp Joe"
  putquick "NOTICE $nick :(/msg) $botnick kick #BotHelp Joe my cool reason"
  }
if {$ns1 == "ban"} {
  putlog "!$nick ($host)! help ban"
  putquick "NOTICE $nick :HELP ON BAN - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to remove a user from a channel for a specified amount time."
  putquick "NOTICE $nick :You can use a time set up to 1m-60m|1h-24h|1d-50d|perm (m = minute(s),h= hour(s),d= day(s))"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick ban Joe 3d"
  putquick "NOTICE $nick :(/msg) $botnick ban Joe 3d my cool reason"
  putquick "NOTICE $nick :(/msg) $botnick ban #AlphaChat VaLoR 3d"
  putquick "NOTICE $nick :(/msg) $botnick ban #BotLand Joe 3d my cool reason"
  putquick "NOTICE $nick :(/msg) $botnick ban #BotLand *!*lamer@*.lamer.org perm my cool reason"
  }
if {$ns1 == "unban"} {
  putlog "!$nick ($host)! help unban"
  putquick "NOTICE $nick :HELP ON UNBAN - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to remove a ban from a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick unban *!*lamer@*.lamer.org"
  putquick "NOTICE $nick :(/msg) $botnick unban #BotHelp *!*lamer@*.lamer.org"
  }
if {$ns1 == "adduser"} {
  putquick "NOTICE $nick :The propper command to that would be useradd.Please type (/msg) $botnick help useradd :P"
  }
if {$ns1 == "useradd"} {
  putlog "!$nick ($host)! help useradd"
  putquick "NOTICE $nick :HELP ON USERADD - MINIMUM ACCESS REQUIRED: \002CHANNEL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to add a user to the bot as a certain level in a specified channel."
  putquick "NOTICE $nick :Levels included in this bot are: Avoice,Aop,Op,Ccadmin,Cadmin,Bop,Bcadmin,Root."
  putquick "NOTICE $nick :Avoice = Auto Voice , Aop = AutoOP , Op = Channel Op , Ccadmin = Channel Co-Admin"
  putquick "NOTICE $nick :Cadmin = Channel Admin , Bop = AlphaChat.TCL Operator , Bcadmin = AlphaChat.TCL Co-Admin , & Root = AlphaChat.TCL Admin"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick useradd Joe op"
  putquick "NOTICE $nick :(/msg) $botnick useradd #BotHelp Joe op"
  }
if {$ns1 == "remuser"} {
  putquick "NOTICE $nick :The propper command to that would be userdel.Please type (/msg) $botnick help userdel :P"
  }
if {$ns1 == "userdel"} {
  putlog "!$nick ($host)! help userdel"
  putquick "NOTICE $nick :HELP ON USERDEL - MINIMUM ACCESS REQUIRED: \002CHANNEL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to remove a user from the bot from a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick userdel Joe"
  putquick "NOTICE $nick :(/msg) $botnick userdel #BotLand Joe"
  putquick "NOTICE $nick :(/msg) $botnick userdel Joe global"
  }
if {$ns1 == "onjoin"} {
  putlog "!$nick ($host)! help onjoin"
  putquick "NOTICE $nick :HELP ON ONJOIN - MINIMUM ACCESS REQUIRED: \002CHANNEL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to create a greeting shown to every user that enters a specific channel."
  putquick "NOTICE $nick :This command uses special sub-commands, listed below:"
  putquick "NOTICE $nick :  - ADD <text> - adds information to the ONJOIN message."
  putquick "NOTICE $nick :  - CLEAR - clears the whole onjoin."
  putquick "NOTICE $nick :  - PREVIEW - displays how the ONJOIN will look."
  putquick "NOTICE $nick :  - REPLACE <line> <newtext> - replaces an individual line in the ONJOIN."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick onjoin add welcome to our great channel!"
  putquick "NOTICE $nick :(/msg) $botnick onjoin #BotLand clear"
  putquick "NOTICE $nick :(/msg) $botnick onjoin replace 3 this is line 3, not 2!"
  putquick "NOTICE $nick :(/msg) $botnick onjoin preview"
  }
if {$ns1 == "act"} {
  putlog "!$nick ($host)! help act"
  putquick "NOTICE $nick :HELP ON ACT - MINIMUM ACCESS REQUIRED: \002CHANNEL ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to make the bot do a specified action in a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick act is cool because it runs AlphaChat.TCL"
  putquick "NOTICE $nick :(/msg) $botnick act #BotHelp is cool because it runs AlphaChat.TCL"
  }
if {$ns1 == "say"} {
  putlog "!$nick ($host)! help say"
  putquick "NOTICE $nick :HELP ON SAY - MINIMUM ACCESS REQUIRED: \002CHANNEL ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to make the bot say specified text to a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick say my really cool text."
  putquick "NOTICE $nick :(/msg) $botnick say #BotLand my really cool text."
  }
if {$ns1 == "cycle"} {
  putlog "!$nick ($host)! help cycle"
  putquick "NOTICE $nick :HELP ON CYCLE - MINIMUM ACCESS REQUIRED: \002CHANNEL ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to make the bot cycle, or part and re-join, a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick cycle"
  putquick "NOTICE $nick :(/msg) $botnick cycle #BotLand"
  }
if {$ns1 == "moduser"} {
  putquick "NOTICE $nick :The proper command to that would be usermod. Please type (/msg) $botnick help usermod :P"
  }
if {$ns1 == "usermod"} {
  putlog "!$nick ($host)! help usermod"
  putquick "NOTICE $nick :HELP ON USERMOD - MINIMUM ACCESS REQUIRED: \002CHANNEL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to modify a user's access in a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick usermod Joe bop"
  putquick "NOTICE $nick :(/msg) $botnick usermod #BotHelp Joe bop"
  }
if {$ns1 == "invite"} {
  putlog "!$nick ($host)! help invite"
  putquick "NOTICE $nick :HELP ON INVITE - MINIMUM ACCESS REQUIRED: \002OP\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to invite a specified user to a specified channel."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick invite Joe"
  putquick "NOTICE $nick :(/msg) $botnick invite #BotLand Joe"
  }
if {$ns1 == "killmodes"} {
  putlog "!$nick ($host)! help killmodes"
  putquick "NOTICE $nick :HELP ON KILLMODES - MINIMUM ACCESS REQUIRED: \002CHANNEL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to kill any channel mode(s) set in a specified channel.Essential to stop a channel takeover and great if your bot is a network service bot."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick killmodes"
  putquick "NOTICE $nick :(/msg) $botnick killmodes #BotHelp"
  }
if {$ns1 == "save"} {
  putlog "!$nick ($host)! help save"
  putquick "NOTICE $nick :HELP ON SAVE - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to save changes whenever a change to any of the bots channel or userfiles are modified."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick save"
  }
if {$ns1 == "chanstats"} {
  putlog "!$nick ($host)! help chanstats"
  putquick "NOTICE $nick :HELP ON CHANSTATS - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to show the registered channels added in the bot's channel records."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick chanstats"
  }
if {$ns1 == "addchan"} {
  putlog "!$nick ($host)! help addchan"
  putquick "NOTICE $nick :HELP ON ADDCHAN - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to add a channel to the bot's channel records."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick addchan #BotLand"
  }
if {$ns1 == "remchan"} {
  putlog "!$nick ($host)! help remchan"
  putquick "NOTICE $nick :HELP ON REMCHAN - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to remove a channel from the bot's channel records."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick remchan #BotLand"
  }
if {$ns1 == "broadcast"} {
  putlog "!$nick ($host)! help broadcast"
  putquick "NOTICE $nick :HELP ON BROADCAST - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to send a message to every channel the bot is in."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick broadcast Bot shutdown in 5 mins."
  }
if {$ns1 == "rehash"} {
  putlog "!$nick ($host)! help rehash"
  putquick "NOTICE $nick :HELP ON REHASH - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used whenever changes are made to a bot's user or channel records."
  putquick "NOTICE $nick :It simply reloads all files."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick rehash"
  }
if {$ns1 == "restart"} {
  putlog "!$nick ($host)! help restart"
  putquick "NOTICE $nick :HELP ON RESTART - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to make the bot restart as a background process in the shell."
  putquick "NOTICE $nick :Command is mainly used if the bot is abnormally lagged or malfunctioning."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick restart"
  }
if {$ns1 == "disable"} {
  putlog "!$nick ($host)! help disable"
  putquick "NOTICE $nick :HELP ON DISABLE - MINIMUM ACCESS REQUIRED - \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command should be used in the matter if anyone is abusing the bot or anything that violates policy."
  putquick "NOTICE $nick :This command makes a users access on a bot unusable in any channel for a temporary period."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick disable Joe"
  putquick "NOTICE $nick :This will completely disable Joe's account and making his access un-useable."
  }
if {$ns1 == "enable"} {
  putlog "!$nick ($host)! help enable"
  putquick "NOTICE $nick :HELP ON ENABLE - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL OPERATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to enable a user whose access was disabled."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick enable Joe"
  }
if {$ns1 == "sendmsg"} {
  putlog "!$nick ($host)! help sndmsg"
  putquick "NOTICE $nick :HELP ON SENDMSG - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to message a user from the bot.Usually used to setpass on a major CService bot such as \002K9\002."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick sndmsg k9@k9.chatnet.org setpass #BotHelp password"
  }
if {$ns1 == "sendnotice"} {
  putlog "!$nick ($host)! help sndnotice"
  putquick "NOTICE $nick :HELP ON SENDNOTICE - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to send a notice to a specified nickname."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick sndnotice Joe my really cool message"
  }
if {$ns1 == "core"} {
  putlog "!$nick ($host)! help core"
  putquick "NOTICE $nick :HELP ON CORE - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL ADMINISTRATOR (root)\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to terminate a bot off irc.This will kill the background process."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick core"
  putquick "NOTICE $nick :(/msg) $botnick core time for maintenance!"
  }
if {$ns1 == "servers"} {
  putlog "!$nick ($host)! help servers"
  putquick "NOTICE $nick :HELP ON SERVERS - MINIMUM ACCESS REQUIRED: \002AlphaChat.TCL CO-ADMINISTRATOR\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to show the set servers in the eggdrop's config the bot is set to use."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick servers"
  }
if {$ns1 == "sendnote"} {
  putlog "!$nick ($host)! help sndnote"
  putquick "NOTICE $nick :HELP ON SENDNOTE - MINIMUM ACCESS REQUIRED: \002AVOICE\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command is used to communicate with other added user on the bot.It's like a virtual e-mail box on the bot."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick sndnote Joe My cool message."
  }
if {$ns1 == "credits"} {
  putlog "!$nick ($host)! help credits"
  putquick "NOTICE $nick :HELP ON CREDITS - MINIMUM ACCESS REQUIRED: \002N/A\002"
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :This command simply show's who coded AlphaChat.tcl and who helped."
  putquick "NOTICE $nick :-"
  putquick "NOTICE $nick :EXAMPLE:"
  putquick "NOTICE $nick :(/msg) $botnick credits"
  }
  return 0
  }
proc botinfo {nick host handle arg} {
  global home easykey easybotnet organization broadcast botnick
  putlog "!$nick ($host)! botinfo"
  bcast u "\002$nick\002 ($host) requested my bot information."
  if {[info exists broadcast_flags]} {
    global broadcast_flags
  } else {
    set broadcast_flags ""
  }
  putquick "NOTICE $nick :Information on \002$botnick\002:"
  if {$easykey == ""} {
    putquick "NOTICE $nick :  \002Easy Key\002: (none)"
  } else {
    putquick "NOTICE $nick :  \002Easy Key\002: $easykey"
  }
  if {$easybotnet != ""} {
    putquick "NOTICE $nick :  \002Easy AlphaChat Key\002: $easybotnet"
  }
  if {$organization == ""} {
    putquick "NOTICE $nick :\002$botnick\002 is operating outside of an organization."
  } else {
    putquick "NOTICE $nick :\002$botnick\002 is operating as part of $organization."
  }
  putquick "NOTICE $nick :\002$botnick\002 is using AlphaChat.TCL version 2.0."
}
proc comment {nick handle host chan ns1 botnet} {
global botnick
if {$ns1 == ""} {
  putlog "!$nick ($host)! comment $chan \[nothing\]"
  bcast u "\002$nick\002 ($host) unset their comment on $chan."
  putquick "NOTICE $nick :Unset comment on $chan"
  set botnet "none"
  setchaninfo $handle $chan $botnet
  return 0
  }
  putlog "!$nick ($host)! comment $chan \[something\]"
  setchaninfo $handle $chan $botnet
  putquick "NOTICE $nick :Set comment to \002'$botnet'\002 on $chan"
  bcast u "\002$nick\002 ($host) set a comment for $chan."
  }
proc topic {nick chan botnet host} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosn't have op status (+o) in $chan"
  return 0
  }
if {$botnet == ""} {
  putlog "!$nick ($host)! topic $chan \[nothing\]"
  putquick "NOTICE $nick :Completedfully unset the topic on $chan"
  bcast u "\002$nick\002 ($host) unset the topic on $chan."
  putquick "TOPIC $chan :"
  return 0
  }
  putlog "!$nick ($host)! topic $chan \[something\]"
  putquick "TOPIC $chan :$botnet"
  putquick "NOTICE $nick :Completedfully set topic to '\002$botnet\002' on $chan"
  bcast u "\002$nick\002 ($host) set the topic on $chan."
  return 0
  }
proc checkaccess {hand1 chan hand2} {
  set hand1lev 0
  set hand2lev 0
if {[matchattr $hand1 |a $chan]} {
  set hand1lev 1
  }
if {[matchattr $hand1 |v $chan]} {
  set hand1lev 2
  }
if {[matchattr $hand1 |o $chan]} {
  set hand1lev 3
  }
if {[matchattr $hand1 |m $chan]} {
  set hand1lev 4
  }
if {[matchattr $hand1 |n $chan]} {
  set hand1lev 5
  }
if {[matchattr $hand1 o]} {
  set hand1lev 6
  }
if {[matchattr $hand1 m]} {
  set hand1lev 7
  }
if {[matchattr $hand1 n]} {
  set hand1lev 8
  }
if {[matchattr $hand2 |a $chan]} {
  set hand2lev 1
  }
if {[matchattr $hand2 |v $chan]} {
  set hand2lev 2
  }
if {[matchattr $hand2 |o $chan]} {
  set hand2lev 3
  }
if {[matchattr $hand2 |m $chan]} {
  set hand2lev 4
  }
if {[matchattr $hand2 |n $chan]} {
  set hand2lev 5
  }
if {[matchattr $hand2 o]} {
  set hand2lev 6
  }
if {[matchattr $hand2 m]} {
  set hand2lev 7
  }
if {[matchattr $hand2 n]} {
  set hand2lev 8
  }
  set result [expr $hand1lev - $hand2lev]
if {$result == -1 } { return 0 }
if {$result == -2 } { return 0 }
if {$result == -3 } { return 0 }
if {$result == -4 } { return 0 }
if {$result == -5 } { return 0 }
  return $result
  }
proc voice {nick handle chan ns1 host botnet} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) in $chan"
  return 0
  }
if {$ns1 == ""} {
  set ns1 $nick
if {[isvoice $nick $chan]} {
  putquick "NOTICE $nick :Already voiced - You are currently voiced on $chan"
  return 0
  }
  putlog "!$nick ($host)! voice $chan"
  pushmode $chan +v $nick
  putquick "NOTICE $nick :Completedfully voiced you in $chan"
  bcast u "\002$nick\002 ($host) used me to gain a voice on $chan."
  return 0
  }
if {![onchan $botnet $chan]} {
  putquick "NOTICE $nick :Not Found - $botnet isn't on $chan"
  } else {
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Not Enough Permissions - You may only voice yourself"
  return 0
  }
if {[isvoice $ns1 $chan]} {
  putquick "NOTICE $nick :Already Voiced - $botnet is currently voiced on $chan"
  } else {
  putlog "!$nick ($host)! voice $chan $botnet"
  pushmode $chan +v $botnet
  putquick "NOTICE $nick :Completedfully voiced $botnet on $chan"
  bcast u "\002$nick\002 ($host) used me to voice $botnet on $chan."
  }
  }
  }
proc devoice {nick handle chan ns1 host botnet} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) in $chan"
  return 0
  }
if {$ns1 == ""} {
  set ns1 $nick
if {![isvoice $nick $chan]} {
  putquick "NOTICE $nick :Not Voiced - You are not currently voiced on $chan"
  return 0
  }
  putlog "!$nick ($host)! devoice $chan"
  putquick "MODE $chan -v $nick"
  putquick "NOTICE $nick :Completedfully devoiced you on $chan"
  bcast u "\002$nick\002 ($host) used me to take away their voice on $chan."
  return 0
  }
if {![onchan $botnet $chan]} {
  putquick "NOTICE $nick :Not Found - $botnet isn't on $chan"
  } else {
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Not Enough Permissions - You may only devoice yourself - Permission Denied."
  return 0
  }
if {![isvoice $ns1 $chan]} {
  putquick "NOTICE $nick :Not Voiced - $botnet is not currently voiced on $chan"
  } else {
  putlog "!$nick ($host)! devoice $chan $botnet"
  pushmode $chan -v $botnet
  putquick "NOTICE $nick :Completedfully devoiced $botnet on $chan"
  bcast u "\002$nick\002 ($host) used me to devoice $botnet on $chan."
  }
  }
  }
proc op {nick chan ns1 host botnet} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) on $chan"
  return 0
  }
if {$ns1 == ""} {
  set ns1 $nick
if {[isop $nick $chan]} {
  putquick "NOTICE $nick :Already Opped - You are currently opped on $chan"
  return 0
  }
  putlog "!$nick ($host)! op $chan $nick"
  pushmode $chan +o $nick
  putquick "NOTICE $nick :Completedfully opped you in $chan"
  bcast u "\002$nick\002 ($host) used me to gain ops in $chan."
  return 0
  }
if {[isop $botnet $chan]} {
  putquick "NOTICE $nick :Already Opped - $botnet is currently opped on $chan"
  return 0
  } else {
if {[onchan $botnet $chan]} {
  putlog "!$nick ($host)! op $chan $botnet"
  pushmode $chan +o $botnet
  putquick "NOTICE $nick :Completedfully opped $botnet in $chan"
  bcast u "\002$nick\002 ($host) used me to op $botnet on $chan."
  return 0
  } else {
  putquick "NOTICE $nick :Not Found - $botnet not found on $chan"
  }
  }
  }
proc deop {nick chan host ns1 botnet handle} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) on $chan"
  return 0
  }
if {$ns1 == "$nick"} {
if {![isop $nick $chan]} {
  putquick "NOTICE $nick :Not Opped - You are currently not opped on $chan"
  return 0
  }
  putlog "!$nick ($host)! deop $chan $nick"
  pushmode $chan -o $nick
  putquick "NOTICE $nick :Completedfully deopped you on $chan"
  bcast u "\002$nick\002 ($host) used me to take away their ops on $chan."
  return 0
  }
if {$ns1 == ""} {
  set ns1 $nick
if {![isop $nick $chan]} {
  putquick "NOTICE $nick :Not Opped - You are currently not opped on $chan"
  return 0
  }
  putlog "!$nick ($host)! deop $chan $nick"
  pushmode $chan -o $nick
  putquick "NOTICE $nick :Completedfully deopped you on $chan"
  bcast u "\002$nick\002 ($host) used me to take away their ops on $chan."
  return 0
  }
if {![isop $botnet $chan]} {
  putquick "NOTICE $nick :Not Opped - $botnet is currently not opped on $chan"
  return 0
  } else {
if {[onchan $botnet $chan]} {
  set hand2 [nick2hand $botnet $chan]
if {[string tolower $botnet] == [string tolower $botnick]} {
  putquick "NOTICE $nick :Unable to deop services - Permission Denied."
  bcast s "\002$nick\002 ($host) attempted to use me to deop myself in $chan."
  return 0
  }
if {[checkaccess $handle $chan $hand2]} {
  putlog "!$nick ($host)! deop $chan $botnet"
  pushmode $chan -o $botnet
  putquick "NOTICE $nick :Completedfully deopped $botnet on $chan"
  bcast u "\002$nick\002 ($host) used me to deop $botnet on $chan."
  } else {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied"
  bcast s "\002$nick\002 ($host) attempted to use me to deop a higher-level user in $chan."
  return 0
  }
  }
  }
  }
proc kick {nick handle chan host ns1 botnet} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) on $chan"
  return 0
  }
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick kick <#channel> <nickname> <reason>"
  return 0
  }
if {[string tolower $ns1] == [string tolower $botnick]} {
  putquick "NOTICE $nick :Unable to kick services - Permission Denied."
  bcast s "\002$nick\002 ($host) tried to make me kick myself from $chan."
  return 0
  }
if {[string tolower $ns1] == [string tolower $nick]} {
if {$botnet == ""} {
  putlog "!$nick ($host)! kick $chan $ns1"
  putquick "KICK $chan $ns1 :\002K\002icked: Requested By: \002$nick\002"
  putquick "NOTICE $nick :Completedfully kicked you from $chan"
  bcast u "\002$nick\002 ($host) used me to kick themself from $chan."
  return 0
  }
  putlog "!$nick ($host)! kick $chan $ns1 $botnet"
  putquick "KICK $chan $ns1 :\002K\002icked: (\002$nick\002) $botnet"
  putquick "NOTICE $nick :Completedfully kicked you from $chan"
  bcast u "\002$nick\002 ($host) used me to kick themself from $chan."
  return 0
  }
if {[onchan $ns1 $chan]} {
  set checkhand [nick2hand $ns1 $chan]
if {[validuser $checkhand]} {
  set hand2 $checkhand
  } else {
  set hand2 $ns1
  }
if {[checkaccess $handle $chan $hand2]} {
if {$botnet == ""} {
  putlog "!$nick ($host)! kick $chan $ns1"
  putquick "KICK $chan $ns1 :\002K\002icked: Requested By: \002$nick\002"
  putquick "NOTICE $nick :Completedfully kicked $ns1 from $chan"
  bcast u "\002$nick\002 ($host) used me to kick $ns1 from $chan."
  return 0
  }
  putlog "!$nick ($host)! kick $chan $ns1 $botnet"
  putquick "KICK $chan $ns1 :\002K\002icked: (\002$nick\002) $botnet"
  putquick "NOTICE $nick :Completedfully kicked $ns1 from $chan"
  bcast u "\002$nick\002 ($host) used me to kick $ns1 from $chan."
  return 0
  }
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied"
  putquick "NOTICE $ns1 :\002$nick\002 ($host) tried to make me kick you in $chan"
  bcast s "\002$nick\002 ($host) attempted to use me to kick a higher-level user in $chan."
  return 0
  }
  putquick "NOTICE $nick :Not Found - $ns1 not found on $chan"
  }
proc ban {nick handle chan ns1 ns botnet2 botnet3 host} {
global botnick
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick ban <#channel> <nick> OR <mask> <time> <reason>"
  return 0
  }
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) on $chan"
  return 0
  }
if {([string tolower $ns1] == [string tolower $botnick]) || ([string match "*$ns1*" "$botnick![getchanhost $botnick $chan]"])} {
  putquick "NOTICE $nick :Unable to ban services - Permission Denied."
  bcast s "\002$nick\002 ($host) attempted to use me to ban myself from $chan."
  return 0
  }
 set time -1
 set reason $botnet2
if {[string tolower $ns] == "1m"} {
  set time 1
  set reason $botnet3
  }
if {[string tolower $ns] == "2m"} {
  set time 2
  set reason $botnet3
  }
if {[string tolower $ns] == "3m"} {
  set time 3
  set reason $botnet3
  }
if {[string tolower $ns] == "4m"} {
  set time 4
  set reason $botnet3
  }
if {[string tolower $ns] == "5m"} {
  set time 5
  set reason $botnet3
  }
if {[string tolower $ns] == "6m"} {
  set time 6
  set reason $botnet3
  }
if {[string tolower $ns] == "7m"} {
  set time 7
  set reason $botnet3
  }
if {[string tolower $ns] == "8m"} {
  set time 8
  set reason $botnet3
  }
if {[string tolower $ns] == "9m"} {
  set time 9
  set reason $botnet3
  }
if {[string tolower $ns] == "10m"} {
  set time 10
  set reason $botnet3
  }
if {[string tolower $ns] == "11m"} {
  set time 11
  set reason $botnet3
  }
if {[string tolower $ns] == "12m"} {
  set time 12
  set reason $botnet3
  }
if {[string tolower $ns] == "13m"} {
  set time 13
  set reason $botnet3
  }
if {[string tolower $ns] == "14m"} {
  set time 14
  set reason $botnet3
  }
if {[string tolower $ns] == "15m"} {
  set time 15
  set reason $botnet3
  }
if {[string tolower $ns] == "16m"} {
  set time 16
  set reason $botnet3
  }
if {[string tolower $ns] == "17m"} {
  set time 17
  set reason $botnet3
  }
if {[string tolower $ns] == "18m"} {
  set time 18
  set reason $botnet3
  }
if {[string tolower $ns] == "19m"} {
  set time 19
  set reason $botnet3
  }
if {[string tolower $ns] == "20m"} {
  set time 20
  set reason $botnet3
  }
if {[string tolower $ns] == "21m"} {
  set time 21
  set reason $botnet3
  }
if {[string tolower $ns] == "22m"} {
  set time 22
  set reason $botnet3
  }
if {[string tolower $ns] == "23m"} {
  set time 23
  set reason $botnet3
  }
if {[string tolower $ns] == "24m"} {
  set time 24
  set reason $botnet3
  }
if {[string tolower $ns] == "25m"} {
  set time 25
  set reason $botnet3
  }
if {[string tolower $ns] == "26m"} {
  set time 26
  set reason $botnet3
  }
if {[string tolower $ns] == "27m"} {
  set time 27
  set reason $botnet3
  }
if {[string tolower $ns] == "28m"} {
  set time 28
  set reason $botnet3
  }
if {[string tolower $ns] == "29m"} {
  set time 29
  set reason $botnet3
  }
if {[string tolower $ns] == "30m"} {
  set time 30
  set reason $botnet3
  }
if {[string tolower $ns] == "1h"} {
  set time 60
  set reason $botnet3
  }
if {[string tolower $ns] == "2h"} {
  set time 120
  set reason $botnet3
  }
if {[string tolower $ns] == "3h"} {
  set time 180
  set reason $botnet3
  }
if {[string tolower $ns] == "4h"} {
  set time 240
  set reason $botnet3
  }
if {[string tolower $ns] == "5h"} {
  set time 300
  set reason $botnet3
  }
if {[string tolower $ns] == "6h"} {
  set time 360
  set reason $botnet3
  }
if {[string tolower $ns] == "7h"} {
  set time 420
  set reason $botnet3
  }
if {[string tolower $ns] == "8h"} {
  set time 480
  set reason $botnet3
  }
if {[string tolower $ns] == "9h"} {
  set time 540
  set reason $botnet3
  }
if {[string tolower $ns] == "10h"} {
  set time 600
  set reason $botnet3
  }
if {[string tolower $ns] == "11h"} {
  set time 660
  set reason $botnet3
  }
if {[string tolower $ns] == "12h"} {
  set time 720
  set reason $botnet3
  }
if {[string tolower $ns] == "13h"} {
  set time 780
  set reason $botnet3
  }
if {[string tolower $ns] == "14h"} {
  set time 840
  set reason $botnet3
  }
if {[string tolower $ns] == "15h"} {
  set time 900
  set reason $botnet3
  }
if {[string tolower $ns] == "16h"} {
  set time 960
  set reason $botnet3
  }
if {[string tolower $ns] == "17h"} {
  set time 1020
  set reason $botnet3
  }
if {[string tolower $ns] == "18h"} {
  set time 1080
  set reason $botnet3
  }
if {[string tolower $ns] == "19h"} {
  set time 1140
  set reason $botnet3
  }
if {[string tolower $ns] == "20h"} {
  set time 1200
  set reason $botnet3
  }
if {[string tolower $ns] == "21h"} {
  set time 1260
  set reason $botnet3
  }
if {[string tolower $ns] == "22h"} {
  set time 1320
  set reason $botnet3
  }
if {[string tolower $ns] == "23h"} {
  set time 1380
  set reason $botnet3
  }
if {[string tolower $ns] == "24h"} {
  set time 1440
  set reason $botnet3
  }
if {[string tolower $ns] == "1d"} {
  set time 1440
  set reason $botnet3
  }
if {[string tolower $ns] == "2d"} {
  set time 2880
  set reason $botnet3
  }
if {[string tolower $ns] == "3d"} {
  set time 4320
  set reason $botnet3
  }
if {[string tolower $ns] == "4d"} {
  set time 5760
  set reason $botnet3
  }
if {[string tolower $ns] == "5d"} {
  set time 7200
  set reason $botnet3
  }
if {[string tolower $ns] == "6d"} {
  set time 8640
  set reason $botnet3
  }
if {[string tolower $ns] == "7d"} {
  set time 10080
  set reason $botnet3
  }
if {[string tolower $ns] == "8d"} {
  set time 11520
  set reason $botnet3
  }
if {[string tolower $ns] == "9d"} {
  set time 12960
  set reason $botnet3
  }
if {[string tolower $ns] == "10d"} {
  set time 14400
  set reason $botnet3
  }
if {[string tolower $ns] == "11d"} {
  set time 15840
  set reason $botnet3
  }
if {[string tolower $ns] == "12d"} {
  set time 17280
  set reason $botnet3
  }
if {[string tolower $ns] == "13d"} {
  set time 18720
  set reason $botnet3
  }
if {[string tolower $ns] == "14d"} {
  set time 20160
  set reason $botnet3
  }
if {[string tolower $ns] == "15d"} {
  set time 21600
  set reason $botnet3
  }
if {[string tolower $ns] == "16d"} {
  set time 23040
  set reason $botnet3
  }
if {[string tolower $ns] == "17d"} {
  set time 24480
  set reason $botnet3
  }
if {[string tolower $ns] == "18d"} {
  set time 25920
  set reason $botnet3
  }
if {[string tolower $ns] == "19d"} {
  set time 27360
  set reason $botnet3
  }
if {[string tolower $ns] == "20d"} {
  set time 28800
  set reason $botnet3
  }
if {[string tolower $ns] == "21d"} {
  set time 30240
  set reason $botnet3
  }
if {[string tolower $ns] == "22d"} {
  set time 31680
  set reason $botnet3
  }
if {[string tolower $ns] == "23d"} {
  set time 33120
  set reason $botnet3
  }
if {[string tolower $ns] == "24d"} {
  set time 34560
  set reason $botnet3
  }
if {[string tolower $ns] == "25d"} {
  set time 36000
  set reason $botnet3
  }
if {[string tolower $ns] == "26d"} {
  set time 37440
  set reason $botnet3
  }
if {[string tolower $ns] == "27d"} {
  set time 38880
  set reason $botnet3
  }
if {[string tolower $ns] == "28d"} {
  set time 40320
  set reason $botnet3
  }
if {[string tolower $ns] == "29d"} {
  set time 41760
  set reason $botnet3
  }
if {[string tolower $ns] == "30d"} {
  set time 43200
  set reason $botnet3
  }
if {[string tolower $ns] == "31d"} {
  set time 44640
  set reason $botnet3
  }
if {[string tolower $ns] == "32d"} {
  set time 46080
  set reason $botnet3
  }
if {[string tolower $ns] == "33d"} {
  set time 47520
  set reason $botnet3
  }
if {[string tolower $ns] == "34d"} {
  set time 48960
  set reason $botnet3
  }
if {[string tolower $ns] == "35d"} {
  set time 50400
  set reason $botnet3
  }
if {[string tolower $ns] == "36d"} {
  set time 51840
  set reason $botnet3
  }
if {[string tolower $ns] == "37d"} {
  set time 53280
  set reason $botnet3
  }
if {[string tolower $ns] == "38d"} {
  set time 54720
  set reason $botnet3
  }
if {[string tolower $ns] == "39d"} {
  set time 56160
  set reason $botnet3
  }
if {[string tolower $ns] == "40d"} {
  set time 57600
  set reason $botnet3
  }
if {[string tolower $ns] == "41d"} {
  set time 59040
  set reason $botnet3
  }
if {[string tolower $ns] == "42d"} {
  set time 60480
  set reason $botnet3
  }
if {[string tolower $ns] == "43d"} {
  set time 61920
  set reason $botnet3
  }
if {[string tolower $ns] == "44d"} {
  set time 63360
  set reason $botnet3
  }
if {[string tolower $ns] == "45d"} {
  set time 64800
  set reason $botnet3
  }
if {[string tolower $ns] == "46d"} {
  set time 66240
  set reason $botnet3
  }
if {[string tolower $ns] == "47d"} {
  set time 67680
  set reason $botnet3
  }
if {[string tolower $ns] == "48d"} {
  set time 69120
  set reason $botnet3
  }
if {[string tolower $ns] == "49d"} {
  set time 70560
  set reason $botnet3
  }
if {[string tolower $ns] == "50d"} {
  set time 72000
  set reason $botnet3
  }
if {[string tolower $ns] == "perm"} {
  set time 0
  set reason $botnet3
  }
if {$time == "-1"} {
  set time 240
  set reason $botnet2
  set ns "4h"
  }
if {![onchan $ns1 $chan]} {
  set hand2 [finduser $ns1]
if {[checkaccess $handle $chan $hand2]} {
if {$reason == ""} {
  putlog "!$nick ($host)! ban $chan $ns1 $ns"
  set banreason "\[AlphaChat.TCL\]\[$ns\]\[$nick\]"
  putquick "NOTICE $nick :Added new channel ban in channel record '$chan'"
  bcast u "\002$nick\002 ($host) used me to place a ban for '$ns1' in $chan."
  } else {
  putlog "!$nick ($host)! ban $chan $ns1 $ns $reason"
  set banreason "\[AlphaChat\]\[$ns\]\[$nick\] $reason"
  putquick "NOTICE $nick :Added new channel ban \002$ns1\002 in channel record '$chan'"
  bcast u "\002$nick\002 ($host) used me to place a ban for '$ns1' in $chan."
  }
  newchanban $chan $ns1 $nick $banreason $time
  putquick "KICK $chan $ns1 :$banreason"
  return 0
  }
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  set hand2 [nick2hand $ns1 $chan]
if {$hand2 == $handle} {
  putquick "NOTICE $nick :Unable To Ban Commanding User."
  return 0
  }
if {[checkaccess $handle $chan $hand2]} {
  set hostname [getchanhost $ns1 $chan]
if {[string match "~*" $hostname]} {
  set hostname [string range $hostname 1 end]
  }
  set banhostname [maskhost *$hostname]
if {$reason == ""} {
  putlog "!$nick ($host)! ban $chan $ns1 ($banhostname) $ns"
  set banreason "\[AlphaChat\]\[$ns\]\[$nick\]"
  newchanban $chan $banhostname $nick $banreason $time
  putquick "NOTICE $nick :Added new channel ban \002$ns1 ($banhostname)\002 in channel record '$chan'"
  putquick "KICK $chan $ns1 :$banreason"
  return 0
  }
  putlog "!$nick ($host)! ban $chan $ns1 ($banhostname) $ns $reason"
  set banreason "\[AlphaChat\]\[$ns\]\[$nick\] $reason"
  newchanban $chan $banhostname $nick $banreason $time
  putquick "NOTICE $nick :Added new channel ban \002$ns1 ($banhostname)\002 in channel record '$chan'"
  bcast u "\002$nick\002 ($host) used me to place a ban for '$ns1 - $banhostname' in $chan."
  putquick "KICK $chan $ns1 :$banreason"
  return 0
  }
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  }
proc unban {nick handle chan ns1 host} {
global botnick
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick unban (#channel) <mask>"
  return 0
  }
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) on $chan"
  return 0
  }
if {[isban $ns1]} {
if {[matchattr $handle o]} {
  putlog "!$nick ($host)! unban $ns1"
  killban $ns1
  putquick "NOTICE $nick :Removed ban from channel records."
  bcast u "\002$nick\002 ($host) is using me to unban '$ns' in $chan."
  return 0
  } else {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  }
if {[isban $ns1 $chan]} {
  putlog "!$nick ($host)! unban $chan $ns1"
  killchanban $chan $ns1
  putquick "NOTICE $nick :Removed ban \002$ns1\002 from channel record '$chan'"
  bcast u "\002$nick\002 ($host) is using me to unban '$ns' $chan."
  return 0
  }
if {[ischanban $ns1 $chan]} {
  putlog "!$nick ($host)! unban $chan $ns1"
  putquick "MODE $chan -b $ns1"
  putquick "NOTICE $nick :Removed ban \002$ns1\002 from channel record '$chan'"
  bcast u "\002$nick\002 ($host) is using me to unban '$ns' $chan."
  return 0
  }
  putquick "NOTICE $nick :Could not find ban - \002$ns1\002 could not be found in the channel recordss ban sector."
  }
proc useradd {nick handle chan ns1 host ns tcl} {
  global botnick
  if {$ns1 == ""} {
    putserv "NOTICE $nick :Invalid Command - Should Be /msg $botnick useradd <nick> <#channel> <level>"
    return 0
  }
  if {$ns == ""} {
    putserv "NOTICE $nick :Unknown Level - use one of these levels: avoice,aop,op,ccadmin,cadmin,bop,bcadmin,root"
    return 0
  }
  if {![onchan $ns1 $chan]} {
    putserv "NOTICE $nick :$ns1 not found on $chan"
    return 0
  }
  set hostname [getchanhost $ns1 $chan]
  if {[string match "~*" $hostname]} {
    set hostname [string range $hostname 1 end]
  }
  set dhost [maskhost *$hostname]
  set hand2 [nick2hand $ns1 $chan]
  set ns [string tolower $ns]
  set newuser 0
  if {$ns == "avoice"} {
    if {![matchattr $handle o|m $chan]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "Auto Voice"
    set uflags "+|vf"
    set glob 0
  } elseif {$ns == "op"} {
    if {![matchattr $handle o|m $chan]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "Op"
    set uflags "+|of"
    set glob 0
  } elseif {$ns == "ccadmin"} {
    if {![matchattr $handle o|n $chan]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "Channel Co-Administrator"
    set uflags "+|fmo"
    set glob 0
  } elseif {$ns == "cadmin"} {
    if {![matchattr $handle o]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "Channel Administrator"
    set uflags "+|fmno"
    set glob 0
  } elseif {$ns == "bop"} {
    if {![matchattr $handle m]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "AlphaChat.TCL Operator"
    set uflags "+ofpxh"
    set glob 1
  } elseif {$ns == "bcadmin"} {
    if {![matchattr $handle n]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "AlphaChat.TCL Co-Administrator"
    set uflags "+fhjmoptx"
    set glob 1
  } elseif {$ns == "root"} {
    if {![matchattr $handle n]} {
      putquick "NOTICE $nick :Unable to execute command - Permission denied."
      return 0
    }
    set ulevel "AlphaChat.TCL Administrator"
    set uflags "+fhjmnoptx"
    set glob 1
  }
  if {([nick2hand $ns1 $chan] != $ns1) && ([nick2hand $ns1 $chan] != "*")} {
    set uhandle [nick2hand $ns1 $chan]
  } else {
    set uhandle $ns1
  }
  if {!$glob} {
    putlog "!$nick ($host)! useradd $uhandle $ulevel $chan"
    bcast c "\002$nick\002 ($host) added '$ns1' as a $ulevel for $chan."
  } else {
    putlog "!$nick ($host)! useradd $uhandle $ulevel"
    bcast g "\002$nick\002 ($host) added '$ns1' as a $ulevel."
  }
  if {![validuser $hand2]} {
    adduser $ns1 $dhost
    set newuser 1
  }
  if {!$glob} {
    chattr $uhandle $uflags $chan
  } else {
    chattr $uhandle $uflags
  }
  chattr $uhandle +hp
  putquick "NOTICE $ns1 :You have been added into my system by \002$nick\002:"
  putquick "NOTICE $nick :Completedfully added \002$ns1\002:"
  putquick "NOTICE $ns1 :  \002Nickname\002: $ns1"
  putquick "NOTICE $nick :  \002Nickname\002: $ns1"
  putquick "NOTICE $ns1 :  \002Handle\002: $uhandle"
  putquick "NOTICE $nick :  \002Handle\002: $uhandle"
  if {!$glob} {
    putquick "NOTICE $ns1 :  \002Channel\002: $chan"
    putquick "NOTICE $nick :  \002Channel\002: $chan"
  }
  putquick "NOTICE $ns1 :  \002Level\002: $ulevel"
  putquick "NOTICE $nick :  \002Level\002: $ulevel"
  putquick "NOTICE $ns1 :  \002Host mask\002: $dhost"
  putquick "NOTICE $nick :  \002Host mask\002: $dhost"
  if {$newuser} {
    putquick "NOTICE $ns1 :Currently, you do \002not\002 have a password set. You \002must\002 set a password before you may use my system."
    putquick "NOTICE $ns1 :To set a password, type \002/msg $botnick pass <password>\002."
    putquick "NOTICE $ns1 :Once your password is set, type \002/msg $botnick auth <password>\002 to begin using the bot."
    putquick "NOTICE $nick :\002$ns1\002 does not have a password set and must set one \002before\002 they may use the bot."
  } else {
    putquick "NOTICE $ns1 :Currently, you have a password set."
    putquick "NOTICE $ns1 :Type \002/msg $botnick auth <password>\002 to begin using the bot."
    putquick "NOTICE $nick :\002$ns1\002 currently has a password set."
  }
}
proc userdel {nick handle chan ns1 ns host} {
global botnick home broadcast
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick userdel <#channel> <nick>"
  return 0
  }
if {[validuser $ns1]} {
  set hand2 $ns1
  } elseif {[onchan $ns1 $chan]} {
  set hand2 [nick2hand $ns1 $chan]
  } else {
  putquick "NOTICE $nick :$ns1 not found in user records."
  return 0
  }
if {$hand2 == $handle} {
  putquick "NOTICE $nick :Unable to userdel commanding user - get a user with higher access to do so."
  bcast s "\002$nick\002 ($host) attempted to delete a higher user."
  return 0
  }
if {$ns == "global"} {
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied"
  return 0
  }
if {[checkaccess $handle $chan $hand2]} {
  deluser $hand2
  putlog "!$nick ($host)! userdel $hand2 global"
  putquick "NOTICE $nick :Completedfully deleted the user account '\002$ns1\002' (No exemptions (completely removed user))"
  bcast u "\002$nick\002 ($host) deleted the user account '$ns1'."
  return 0
  } else {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  putquick "NOTICE $ns1 :\002$nick\002 ($host) tried to userdel you with the 'No Exemptions' option."
  bcast s "\002$nick\002 ($host) attempted to delete a higher user."
  return 0
  }
  }
if {![checkaccess $handle $chan $hand2]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  putquick "NOTICE $ns1 :\002$nick\002 ($host) tried to userdel you in $chan"
  bcast s "\002$nick\002 ($host) attempted to delete a higher user in $chan."
  return 0
  }
if {![delchanrec $hand2 $chan]} {
  putquick "NOTICE $nick :User Not Found - $ns1 not found in channel record '$chan'"
  return 0
  }
  foreach channel [channels] {
  if {[matchattr $hand2 |f $channel]} {
  putlog "!nick ($host)! userdel $chan $hand2"
  putquick "NOTICE $nick :Completedfully deleted $ns1 on $chan"
  bcast u "\002$nick\002 ($host) deleted the user '$ns1' in $chan."
  return 0
  }
  }
if {[matchattr $hand2 f]} {
  putlog "!$nick ($host)! userdel $chan $hand2"
  putquick "NOTICE $nick :Completedfully deleted $ns1 on $chan"
  bcast u "\002$nick\002 ($host) deleted the user '$ns1' in $chan."
  return 0
  }
  deluser $hand2
  putlog "!$nick ($host)! userdel $chan $hand2"
  putquick "NOTICE $nick :Completedfully deleted $ns1 on $chan"
  bcast u "\002$nick\002 ($host) deleted the user '$ns1' in $chan."
  }
proc usermod {nick handle chan ns1 ns tcl host} {
global botnick
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick usermod <#channel> <nick> <level>"
  return 0
  }
if {$ns == ""} {
  putquick "NOTICE $nick :Unspecified Level - You need to specify '1' of these levels: avoice,aop,op,ccadmin,cadmin,bop,bcadmin,root"
  return 0
  }
if {[validuser $ns1]} {
  set hand2 $ns1
  } elseif {[onchan $ns1 $chan]} {
  set hand2 [nick2hand $ns1 $chan]
  } else {
  putquick "NOTICE $nick :Unknown User - User not found in user/root records."
  return 0
  }
if {[matchattr $hand2 D]} {
  putquick "NOTICE $nick :$hand2's user account is disabled - Enable $hand2's user account first - Permission Denied."
  bcast u "\002$nick\002 ($host) tried to modify the user '$hand2' in $chan, but the account is disabled."
  return 0
  }
if {[string match {avoice} $ns] == 1} {
  putlog "!$nick ($host)! usermod $chan $hand2 avoice"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'avoice' on $chan"
  bcast m "\002$nick\002 ($host) modified '$hand2' to an Auto Voice on $chan."
  chattr $hand2 |+vf-aodknm $chan
  save
  return 0
  }
if {[string match {op} $ns] == 1} {
  putlog "!$nick ($host)! usermod $chan $hand2 op"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'op' on $chan"
  bcast m "\002$nick\002 ($host) modified '$hand2' to an Op on $chan."
  chattr $hand2 |+of-vadknm $chan
  save
  return 0
  }
if {[string match {ccadmin} $ns] == 1} {
if {![matchattr $handle o|n $chan]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  putlog "!$nick ($host)! usermod $chan $hand2 ccadmin"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'Channel Co-Administrator' on $chan"
  bcast m "\002$nick\002 ($host) modified '$hand2' to a Channel Co-Administrator on $chan."
  chattr $hand2 |+mof-vadkn $chan
  save
  return 0
  }
if {[string match {cadmin} $ns] == 1} {
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  putlog "!$nick ($host)! usermod $chan $hand2 cadmin"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 To 'Channel Administrator' on $chan"
  bcast m "\002$nick\002 ($host) modified '$hand2' to a Channel Administrator on $chan."
  chattr $hand2 |+fmno-vadk $chan
  save
  return 0
  }
if {[string match {bop} $ns] == 1} {
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  putlog "!$nick ($host)! usermod $hand2 bop"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'AlphaChat.TCL Operator'"
  bcast m "\002$nick\002 ($host) modified '$hand2' to a AlphaChat.TCL Operator."
  chattr $hand2 +foxp-vtjdknm
  save
  return 0
  }
if {[string match {bcadmin} $ns] == 1 } {
if {![matchattr $handle n]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  putlog "!$nick ($host)! usermod $hand2 bcadmin"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'AlphaChat.TCL Co-Administrator'"
  bcast m "\002$nick\002 ($host) modified '$hand2' to a AlphaChat.TCL Co-Administrator."
  chattr $hand2 +fmoxtp-vjdkn
  save
  return 0
  }
if {[string match {root} $ns] == 1} {
if {![matchattr $handle n]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  putlog "!$nick ($host)! usermod $hand2 root"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'root'"
  bcast m "\002$nick\002 ($host) modified '$hand2' to a AlphaChat.TCL Administrator."
  chattr $hand2 +fnmtoxjp-vdk
  save
  return 0
  }
if {[string match {aop} $ns] == 1} {
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Not Enough Permissions - Permission Denied."
  return 0
  }
  putlog "!$nick ($host)! usermod $chan $hand2 aop"
  putquick "NOTICE $nick :Completedfully modified permissions for $ns1 to 'AutoOp' on $chan"
  bcast m "\002$nick\002 ($host) modified '$hand2' to an Auto Op in $chan."
  chattr $hand2 |+fa-nmdkvo $chan
  save
  return 0
  }
  }
proc invite {nick handle host chan ns1} {
global botnick
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick invite <#channel> <nick>"
  return 0
  }
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) in $chan"
  return 0
  }
if {[onchan $ns1 $chan]} {
  putquick "NOTICE $nick :User on Channel - $ns1 is currently on $chan"
  return 0
  }
  putlog "!$nick ($host)! invite $chan $ns1"
  putquick "NOTICE $nick :Invitied $ns1 to $chan"
  putquick "INVITE $ns1 :$chan"
  putquick "NOTICE $ns1 :\002$nick\002 ($host) used me to invite you to $chan"
  bcast s "\002$nick\002 ($host) used me to invite $ns1 into $chan."
  }
proc killmodes {nick chan host} {
global botnick
if {![onchan $botnick $chan]} {
  putquick "NOTICE $nick :Bot Not On Channel - I am currently not on $chan"
  return 0
  }
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) on $chan"
  return 0
  }
  putlog "!$nick ($host)! killmodes $chan"
  bcast s "\002$nick\002 ($host) used me to kill the modes on $chan."
  set chanpasswd [getchanmode $chan]
  set getchanpasswd [lindex $chanpasswd 1]
  putquick "MODE $chan -k :$getchanpasswd"
  set getchanpasswd [lindex $chanpasswd 2]
  putquick "MODE $chan -ntmlkpsi *"
  putquick "MODE $chan -k :$getchanpasswd"
  putquick "NOTICE $nick :Completedfully killed all set channel modes for $chan"
  }
proc mode {nick chan botnet host} {
global botnick
if {![botisop $chan]} {
  putquick "NOTICE $nick :Bot dosen't have op status (+o) in $chan"
  putquick "PRIVMSG $home :Mode change request from \002$nick\002 ($host) in $chan failed - I'm not opped."
  return 0
  }
if {$botnet == ""} {
  putquick "NOTICE $nick :No Mode Specified - (+) or (-) i , n , t , m , p, s , k , l"
  return 0
  }
if {$botnet == "+k"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +k <set key>"
  return 0
  }
if {$botnet == "t"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +t or $botnick mode -t"
  return 0
  }
if {$botnet == "-k"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode -k <key>"
  return 0
  }
if {$botnet == "+l"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +l (whatever limit you want)"
  return 0
  }
if {$botnet == "i"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +i or $botnick mode -i"
  return 0
  }
if {$botnet == "k"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +k or -k <key>"
  return 0
  }
if {$botnet == "l"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +l or -l"
  return 0
  }
if {$botnet == "p"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +p or -p"
  return 0
  }
if {$botnet == "s"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +s or -s"
  return 0
  }
if {$botnet == "m"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +m or -m"
  return 0
  }
if {$botnet == "n"} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick mode +n or -n"
  return 0
  }
  putlog "!$nick ($host)! mode $chan $botnet"
  putquick "MODE $chan $botnet"
  putquick "NOTICE $nick :Completedfully set mode $botnet on $chan"
  bcast u "\002$nick\002 ($host) used me to set mode $botnet on $chan."
  }
proc onjoin {nick chan host botnet} {
  global botnick
  set chanup [string toupper $chan]
  set tmpchan $chan
  set chan $chanup
  set counter 1
  set sparsecmd [split $botnet " "]
  set oncmd [lindex $sparsecmd 0]
  switch -exact $oncmd {
    "add" {
      putlog "!$nick ($host)! onjoin $chan add"
      set fileid [open "$botnick.$chan.onjoin" a+]
        seek $fileid 0 start
      while {![eof $fileid ]} {
        gets $fileid onjoin
        if {$counter == 1} {
          set onjoin1 $onjoin
          if {[eof $fileid]} {
            break
          }
        }
        if {$counter == 2} {
          set onjoin2 $onjoin
          if {[eof $fileid]} {
            break
          }
        }
        if {$counter == 3} {
          set onjoin3 $onjoin
          if {[eof $fileid]} {
            break
          }
        }
        if {$counter == 4} {
          set onjoin4 $onjoin
          if {[eof $fileid]} {
            break
          }
        }
        if {$counter == 5} {
          set onjoin5 $onjoin
          if {[eof $fileid]} {
            break
          }
        }
        if {$counter == 6} {
          set onjoin5 $onjoin
          putquick "NOTICE $nick :Onjoin for $tmpchan is full"
          close $fileid
          return 1
        }
        incr counter
      }
      set onjoinadd [string trimleft $sparsecmd "add "]
      set space " "
      set onjoinad1 $counter$space$onjoinadd
      puts $fileid $onjoinad1
      putquick "NOTICE $nick :Completed - Added '$onjoinadd' to onjoin for $tmpchan"
      close $fileid
      return 1
    }
    "clear" {
      putlog "!$nick ($host)! onjoin $chan clear"
      if {[file exists "$botnick.$chan.onjoin"]} {
        set oncl [open "$botnick.$chan.onjoin" w+]
        close $oncl
        putquick "NOTICE $nick :Completed - Onjoin for $tmpchan cleared"
      } else {
        putquick "NOTICE $nick :There is no Onjoin for $tmpchan"
      }
    }
    "preview" {
      putlog "!$nick ($host)! onjoin $chan preview"
      set ondeb [open "$botnick.$chan.onjoin" a+]
      seek $ondeb 0 start
      while {![eof $ondeb]} {
        gets $ondeb msg
        if {$msg == ""} {
          close $ondeb
          return 0
        }
        putquick "PRIVMSG $chan :$msg"
      }
      close $ondeb
    }
    "replace" {
      putlog "!$nick ($host)! onjoin $chan replace"
      set onlindex [split $botnet " " ]
      set tmp [lindex $onlindex 0]
      append tmp " "
      set oncmd [string trimleft $botnet $tmp ]
      set onlin [lindex $onlindex 1]
      append onlin " "
      set ondel [string trimleft $oncmd $onlin ]
      if {![file exists "$botnick.$chan.onjoin"]} {
        putquick "NOTICE $nick :There is no Onjoin for $tmpchan"
        return 0
      }
      set onget [open "$botnick.$chan.onjoin" a+]
      seek $onget 0 start
      gets $onget line1
      gets $onget line2
      gets $onget line3
      gets $onget line4
      gets $onget line5
      if {$onlin == "1 "} {
        set line1 "1 "
        append line1 $ondel
      }
      if {$onlin == "2 "} {
        set line2 "2 "
        append line2 $ondel
      }
      if {$onlin == "3 "} {
        set line3 "3 "
        append line3 $ondel
      }
      if {$onlin == "4 "} {
        set line4 "4 "
        append line4 $ondel
      }
      if {$onlin == "5 "} {
        set line5 "5 "
        append line5 $ondel
      }
      close $onget
      set onget [open "$botnick.$chan.onjoin" w+]
      puts $onget $line1
      puts $onget $line2
      puts $onget $line3
      puts $onget $line4
      puts $onget $line5
      putquick "NOTICE $nick :Completed - Replaced onjoin for $tmpchan"
      close $onget
    }
  }
}
proc onjoin_disp {nick host handle chan} {
  global botnick
  set chanup [string toupper $chan]
  set chan $chanup
  if {![file exists "$botnick.$chan.onjoin"]} {
    return 0
  }
  set onmsg [open "$botnick.$chan.onjoin" a+]
  seek $onmsg 0 start

  if {$nick == $botnick} {
    return 0
  }

  while {![eof $onmsg]} {
    gets $onmsg msg1
    set tempmsg [string trim [split $msg1 " "]]
    if { [lindex $tempmsg 0] == "1" } {
      set msg [string trimleft $msg1 "1 "]
    }
    if { [lindex $tempmsg 0] == "2" } {
      set msg [string trimleft $msg1 "2 "]
    }
    if { [lindex $tempmsg 0] == "3" } {
      set msg [string trimleft $msg1 "3 "]
    }
    if { [lindex $tempmsg 0] == "4" } {
      set msg [string trimleft $msg1 "4 "]
    }
    if { [lindex $tempmsg 0] == "5" } {
      set msg [string trimleft $msg1 "5 "]
    }
    if {[lindex $tempmsg 0] == ""} {
      close $onmsg
      return 1
    }
    putquick "NOTICE $nick :$msg"
  }
  close $onmsg
}
proc say {nick chan botnet host} {
global botnick
if {$botnet == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick say <#channel> <whatever you want me to say>"
  return 0
  }
  putlog "!$nick ($host)! say $chan $botnet"
  putquick "NOTICE $nick :Completedfully said '$botnet' to $chan"
  bcast s "\002$nick\002 ($host) used me to say '$botnet' to $chan."
  putquick "PRIVMSG $chan :$botnet"
  return 0
  }
proc act {nick chan host botnet} {
global botnick
if {$botnet == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick act <#channel> <text to act>"
  return 0
  }
  putlog "!$nick ($host)! act $chan $botnet"
  putquick "NOTICE $nick :Completedfully acted '$botnet' on $chan"
  bcast s "\002$nick\002 ($host) used me to act '$botnet' on $chan."
  putquick "PRIVMSG $chan :\001ACTION $botnet"
  return 0
  }
proc cycle {nick host handle chan} {
  putlog "!$nick ($host)! cycle $chan"
  putquick "PART $chan :cycle"
  putquick "JOIN $chan"
  putquick "NOTICE $nick :Completedfully cycled $chan"
  bcast u "\002$nick\002 ($host) requested that I cycle $chan."
  return 0
}
proc chanstats {nick host} {
global botnick
  putlog "!$nick ($host)! chanstats"
  bcast u "\002$nick\002 ($host) requested my list of current channels."
  putquick "NOTICE $nick :Listing channels from channel records:"
  putquick "NOTICE $nick :\002[channels]\002"
  putquick "NOTICE $nick :End of channel records listing."
  }
proc addchan {nick ns1 host handle} {
global botnick defchanoptions defchanmodes
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invaild Command - Should Be /msg $botnick addchan <#channel>"
  return 0
  }
if {[validchan $ns1]} {
  putquick "NOTICE $nick :Channel Currently Exists - The channel $ns1 is currently in channel records."
  return 0
  }
if {[string match "#*" $ns1]} {
  channel add $ns1 $defchanmodes
  putlog "!$nick ($host)! addchan $ns1"
  putquick "NOTICE $nick :Completedfully added $ns1 into channel records."
  bcast n "\002$nick\002 ($host) requested that I add '$ns1' as a new channel."
  channel set $ns1 -clearbans +enforcebans -dynamicbans +userbans -autoop -bitch +greet -protectops +statuslog -stopnethack -revenge +autovoice -secret -shared +cycle
  save
  return 0
  }
  putquick "NOTICE $nick :Illegal Channel Name - Try adding a # in front of the name (eg. #bot-solutions)"
  return 0
  }
proc remchan {nick chan ns1 handle host} {
global botnick home
if {($ns1 == "$home") && (![matchattr $handle n])} {
  putquick "NOTICE $nick :Home channel cannot be removed from channel records - Permission Denied."
  bcast s "\002$nick\002 ($host) attempted to remove me from my home channel($home)."
  return 0
  }
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick remchan <#channel>"
  return 0
  }
if {![string match "#*" $ns1]} {
  putquick "NOTICE $nick :Illegal Channel Name - Try adding a # in front of it (eg. #bot-solutions)"
  return 0
  }
if {![validchan $ns1]} {
  putquick "NOTICE $nick :Channel Not Found - The Channel $ns1 could not be found in my channel records."
  return 0
  }
  putlog "!$nick ($host)! remchan $ns1"
  putquick "NOTICE $nick :Completedfully removed $ns1 from channel records."
  bcast u "\002$nick\002 ($host) requested that I remove '$ns1' from my channel records."
  foreach user [userlist] {
  set userdeluser 1
if {[delchanrec $user $ns1]} {
  save
if {![matchattr $user f]} {
  foreach channels [channels] {
if {[matchattr $user |f $channels]} {
  set userdeluser 0
  }
  }
if {$userdeluser} {
  deluser $user
  channel remove $ns1
  save
  return 0
  }
  }
  }
  }
  channel remove $ns1
  if {[file exists "$botnick.[string toupper $ns1]"]} {
    file delete "$botnick.[string toupper $ns1]"
  }
  save
  }
proc broadcast {nick host botnet} {
global botnick home
if {$botnet == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick broadcast <message>"
  return 0
  }
  putlog "!$nick ($host)! broadcast $botnet"
  putquick "NOTICE $nick :Completedfully sent global broadcast '\002$botnet\002' to all channels listed in channel records."
  bcast s "\002$nick\002 ($host) used me to send the global message '$botnet' to all my channels."
  foreach chan [channels] {
  if {$chan != $home} {
    putquick "PRIVMSG $chan :\002Global Message\002: \[$nick\] $botnet"
  }
  }
  return 0
  }
proc do_rehash {nick host} {
global botnick home
  putlog "!$nick ($host)! rehash"
  putquick "NOTICE $nick :Succesfully rehashed"
  bcast u "\002$nick\002 ($host) requested that I rehash my system."
  rehash
  }
proc do_restart {nick host} {
global botnick home
  putlog "!$nick ($host)! restart"
  save
  foreach chan [channels] {
  if {$chan != $home} {
    putquick "PRIVMSG $chan :I'm restarting, I'll be right back."
  }
  }
  bcast s "\002$nick\002 ($host) requested that I restart my system."
  utimer 15 restart
  return 0
  }
proc disable {nick handle host chan ns1} {
global botnick
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invaild Command - Should Be /msg $botnick disable <#channel> <user>"
  return 0
  }
if {[onchan $ns1 $chan]} {
  set hand2 [nick2hand $ns1 $chan]
  } else {
  set hand2 $ns1
  }
if {[matchattr $hand2 D]} {
  putquick "NOTICE $nick :User Is Currently Disabled - The user '\002$hand2\002' is currently disabled."
  return 0
  }
if {[string tolower $hand2] == [string tolower $handle]} {
  putquick "NOTICE $nick :Unable To Disable Commanding User - Get another user to do so."
  bcast s "\002$nick\002 ($host) attempted to disable a higher user."
  return 0
  }
if {[string tolower $hand2] == [string tolower $botnick]} {
  putquick "NOTICE $nick :Unable To Disable Services"
  bcast s "\002$nick\002 ($host) attempted to make me disable myself."
  return 0
  }
if {![validuser $hand2]} {
  putquick "NOTICE $nick :Unknown User - Could not find '\002$hand2\002' in my user records."
  return 0
  }
if {![checkaccess $handle $chan $hand2]} {
  putquick "NOTICE $nick :Permission Denied."
  putquick "NOTICE $ns1 :\002$nick\002 ($host) tried to disable your user account."
  bcast s "\002$nick\002 ($host) attempted to disable a higher user in $chan."
  return 0
  }
  putlog "!$nick ($host)! disable $hand2"
  putquick "NOTICE $nick :Completedfully disable'd user account '\002$hand2\002'"
  bcast u "\002$nick\002 ($host) successfully disabled '$hand2'."
  set permissions [chattr $hand2]
  setuser $hand2 XTRA "DISABLED-PERMISSIONS" +$permissions
  chattr $hand2 -$permissions
  chattr $hand2 +D
  save
  set console [hand2idx $hand2]
if {$console != "-1"} {
  killdcc $console
  }
  return 0
  }
proc enable {nick host chan ns1} {
global botnick
if {$ns1 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick enable <username>"
  return 0
  }
if {[onchan $ns1 $chan]} {
  set hand2 [nick2hand $ns1 $chan]
  } else {
  set hand2 $ns1
  }
if {![validuser $hand2]} {
  putquick "NOTICE $nick :Unknown User - Could not find \002$ns1\002 in user records."
  return 0
  }
if {![matchattr $hand2 D]} {
  putquick "NOTICE $nick :User Not Disabled - The user '\002$hand2\002' is not disable'd."
  return 0
  }
  putlog "!$nick ($host)! enable $hand2"
  putquick "NOTICE $nick :Completedfully enabled user account '\002$hand2\002'"
  bcast s "\002$nick\002 ($host) successfully enabled user '$hand2'."
  set permissions [getuser $hand2 XTRA "DISABLED-PERMISSIONS"]
  chattr $hand2 -D
  chattr $hand2 +$permissions
  setuser $hand2 XTRA "DISABLED-PERMISSIONS" ""
  save
  return 0
  }
proc sndmsg {nick ns1 host botnet2} {
global botnick
if {$ns1 == "" || $botnet2 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick sndmsg <nick> <message>"
  return 0
  }
  putlog "!$nick ($host)! sndmsg $ns1 $botnet2"
  putquick "NOTICE $nick :Sent message '\002$botnet2\002' to $ns1"
  bcast s "\002$nick\002 ($host) used me to message $ns1 with the message '$botnet2'."
  putquick "PRIVMSG $ns1 :$botnet2"
  putquick "NOTICE $ns1 :That message was from: $nick"
  return 0
  }
proc sndnotice {nick ns1 host botnet2} {
global botnick
if {$ns1 == "" || $botnet2 == ""} {
  putquick "NOTICE $nick :Invalid Command - Should Be /msg $botnick sndnotice <nick> <message>"
  return 0
  }
  putlog "!$nick ($host)! sndnotice $ns1 $botnet2"
  putquick "NOTICE $nick :Completedfully sent notice '\002$botnet2\002' to $ns1"
  bcast s "\002$nick\002 ($host) used me to notice $ns1 with the message '$botnet2'."
  putquick "NOTICE $ns1 :$botnet2"
  putquick "NOTICE $ns1 :That notice was from: $nick"
  return 0
  }
proc do_save {nick host} {
global botnick home broadcast
  putlog "!$nick ($host)! save"
  putquick "NOTICE $nick :Saved all records."
  bcast u "\002$nick\002 ($host) requested that I save all my records."
  save
  return 0
  }
proc deopped {nick host handle chan -o victim} {
global botnick home
if {$chan == $home} {
  return 0
  }
if {$victim == $botnick} {
  bcast d "\002$nick\002 ($host) \002deopped\002 me in $chan."
  return 0
}
}
proc kickwarn {nick host handle chan knick reason} {
global botnick
  if {$knick == $botnick} {
  bcast k "\002$nick\002 ($host) kicked me from $chan with the reason '$reason'."
  }
}
proc do_ident {nick host handle arg} {
  if {[validuser $nick]} {
  bcast i "\002$nick\002 ($host) used the ident command to add a new hostname."
  }
  *msg:ident $nick $host $handle $arg
}
proc core {nick host handle message} {
global botnick home broadcast
  putlog "!$nick ($host)! core"
  putquick "NOTICE $nick :Completed - Preparing for shutdown."
  bcast s "\002$nick\002 ($host) requested that I shutdown."
  foreach chan [channels] {
    if {$chan != $home} {
      putquick "PRIVMSG $chan :$nick requested me to dump my core (die) - bye."
    }
  }
  if {$message == ""} {
    utimer 10 "die \"(Requested by: $handle)\""
  } else {
    utimer 10 "die \"(Requested by: $handle) $message\""
  }
  }
proc admin {nick host} {
global botnick home admin broadcast
  putlog "!$nick ($host)! admin"
  bcast u "\002$nick\002 ($host) requested my administrative contact information."
  putquick "NOTICE $nick :Listing administrative contact information for \002$botnick\002"
  putquick "NOTICE $nick :\002$admin\002"
  return 0
  }
proc servers {nick host} {
global botnick home servers broadcast
  putlog "!$nick ($host)! servers"
  putquick "NOTICE $nick :Listing servers for \002$botnick\002:"
  bcast u "\002$nick\002 ($host) requested my server list."
  putquick "NOTICE $nick :[join $servers]"
  return 0
  }
proc sndnote {nick handle ns1 botnet2 host chan} {
global botnick home
if {$ns1 == ""} {
  putquick "NOTICE $nick :No Recipient Specified - You need to specify a recipient."
  return 0
  }
if {$botnet2 == ""} {
  putquick "NOTICE $nick :No Message Specified - You need to specify a message to send to '\002$ns1\002'"
  return 0
  }
if {[onchan $ns1 $chan]} {
  set hand2 [nick2hand $ns1 $chan]
} elseif {[validuser $ns1]} {
  set hand2 $ns1
  } else {
  putquick "NOTICE $nick :Not Found In User Records - The user '\002$ns1\002' could not be found in user records."
  return 0
  }
  set result [sendnote $handle $hand2 $botnet2]
if {$result == "0"} {
  putquick "NOTICE $nick :Delivery Failed - Unreachable User."
  return 0
  }
if {$result == "1"} {
  putquick "NOTICE $nick :Completed - Message delivered to \002$ns1\002 ($hand2)"
  return 0
  }
if {$result == "2"} {
  putquick "NOTICE $nick :Completed - Message delivered to \002$ns1\002 ($hand2)"
  return 0
  }
if {$result == "3"} {
  putquick "NOTICE $nick :Delivery Failed - \002$hand2\002's virtual notebox is currently full."
  return 0
  }
if {$result == "4"} {
  putquick "NOTICE $nick :Delivery Failed - Unexpected error,try re-sending the note.If the problem persist contact your local botnet administrator."
  return 0
  }
if {$result == "5"} {
  putquick "NOTICE $nick :Completed - Message delivered successfully to \002$ns1\002's ($hand2) notebox."
  return 0
  }
  }
proc auth {nick host handle arg} {
global botnick home
if {![validuser $handle]} {
  putquick "NOTICE $nick :Your user account could not be found in my user records - you don't have access on me."
  return 0
  }
if {$arg == ""} {
  putquick "NOTICE $nick :No Password Specified - You need to specify your password."
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Unable To Authenticate - Your user account is disabled therefore you may not auth."
  putlog "\002$handle\002 ($nick) tried to authenticate - the account is disabled - denied authentication."
  bcast a "\002$nick\002 ($host) tried to authenticate, but the account is disabled."
  return 0
  }
if {[validuser $handle]} {
set checkpw [getuser $handle PASS]
if {$checkpw == ""} {
  putquick "NOTICE $nick :You don't have a password set - Please set a password using /msg $botnick PASS <password>"
  putlog "$nick ($handle) attempted to auth but the user dosen't have a password set - prompting user to setpass."
  return 0
  }
  }
if {[passwdok $handle $arg]} {
  putlog "\002$handle\002 ($nick) successfully authenticated."
  putquick "NOTICE $nick :Completed - You are now authenticated on $botnick."
  bcast a "\002$nick\002 ($host) successfully authenticated."
  chattr $handle +A
  save
  return 0
  }
  putlog "\002$handle\002 ($nick) failed authentication."
  putquick "NOTICE $nick :Unable To Authenticate - Failed to authenticate you - invalid password - check your password spelling and remember your password is CaSe SeNsaTive."
  putquick "NOTICE $nick :If you need your new hostmask added type \002/msg $botnick ident <your password>\002"
  bcast a "\002$nick\002 ($host) failed authentication."
  chattr $handle -A
  save
  }
proc logout {nick host handle chan arg} {
global botnick home broadcast
  chattr $handle -A
  putlog "\002$handle\002 ($nick) quit irc - automaticaly removing authentication."
  bcast u "\002$nick\002 ($host) quit IRC - automatically removing user authentication."
  save
  }

##################################################################
# Message Process Binds
#

bind msg - version msg:version
bind msg - credits msg:credits
bind msg - commands msg:commands
bind msg - access msg:access
bind msg - botinfo botinfo
bind msg - banlist msg:banlist
bind msg - userlist msg:userlist
bind msg - help msg:help
bind msg - admin msg:admin
bind msg - voice msg:voice
bind msg - devoice msg:devoice
bind msg - comment msg:comment
bind msg - sndnote msg:sndnote
bind msg - topic msg:topic
bind msg - op msg:op
bind msg - deop msg:deop
bind msg - kick msg:kick
bind msg - ban msg:ban
bind msg - unban msg:unban
bind msg - invite msg:invite
bind msg - usermod msg:usermod
bind msg - killmodes msg:killmodes
bind msg - userdel msg:userdel
bind msg - useradd msg:useradd
bind msg - mode msg:mode
bind msg - onjoin msg:onjoin
bind msg - say msg:say
bind msg - act msg:act
bind msg - cycle msg:cycle
bind msg - chanstats msg:chanstats
bind msg - addchan msg:addchan
bind msg - remchan msg:remchan
bind msg - broadcast msg:broadcast
bind msg - disable msg:disable
bind msg - enable msg:enable
bind msg - save msg:save
bind msg - rehash msg:rehash
bind msg - restart msg:restart
bind msg - sndmsg msg:sndmsg
bind msg - sndnotice msg:sndnotice
bind msg - servers msg:servers
bind msg - core msg:core

proc msg:version {nick host handle arg} {
  version $nick $host
  return 0
  }
proc msg:credits {nick host handle arg} {
  credits $nick $host
  return 0
  }
proc msg:commands {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specifiy a channel."
  return 0
  }
  commands $nick $handle $chan $ns1 $host
  return 0
  }
proc msg:access {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
  do_access $nick $chan $ns1 $host
  return 0
  }
proc msg:banlist {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
  do_banlist $nick $chan $host
  return 0
  }
proc msg:userlist {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
  do_userlist $nick $chan $host $ns1
  return 0
  }
proc msg:help {nick host handle arg} {
  set argument [lindex $arg 0]
  if {[string match "#*" $argument]} {
    if {[validchan $argument]} {
      set chan $argument
      set ns1 [lindex $arg 1]
    } else {
      putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
      return 0
    }
  } else {
    putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
    return 0
  }
  help $nick $arg $ns1 $chan $host
  return 0
}
proc msg:admin {nick host handle arg} {
  admin $nick $host
  return 0
  }
proc msg:voice {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|v $chan] && ![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  voice $nick $handle $chan $ns1 $host $botnet
  return 0
  }
proc msg:devoice {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|v $chan] && ![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  devoice $nick $handle $chan $ns1 $host $botnet
  return 0
  }
proc msg:comment {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|v $chan] && ![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  comment $nick $handle $host $chan $ns1 $botnet
  return 0
  }
proc msg:sndnote {nick host handle arg} {
global botnick home
  set argument [lindex $arg 0]
if {[string match "#*" $argument] && [validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet2 [lrange $arg 2 end]
  } else {
  set chan $home
  set ns1 [lindex $arg 0]
  set botnet2 [lrange $arg 1 end]
  }
  if {![matchattr $handle o|v $chan] && ![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
  if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  sndnote $nick $handle $ns1 $botnet2 $host $chan
  return 0
  }
proc msg:topic {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
    }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Dsiabled - Permission Denied."
  return 0
  }
  topic $nick $chan $botnet $host
  return 0
  }
proc msg:op {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  op $nick $chan $ns1 $host $botnet
  return 0
  }
proc msg:deop {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  deop $nick $chan $host $ns1 $botnet $handle
  return 0
  }
proc msg:kick {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set botnet2 [lrange $arg 2 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  kick $nick $handle $chan $host $ns1 $botnet2
  return 0
  }
proc msg:ban {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set ns [lindex $arg 2]
  set botnet2 [lrange $arg 2 end]
  set botnet3 [lrange $arg 3 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permision Denied."
  return 0
  }
  ban $nick $handle $chan $ns1 $ns $botnet2 $botnet3 $host
  return 0
  }
proc msg:unban {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  unban $nick $handle $chan $ns1 $host
  return 0
  }
proc msg:invite {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|o $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  invite $nick $handle $host $chan $ns1
  return 0
  }
proc msg:usermod {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set ns [lindex $arg 2]
  set tcl [lindex $arg 3]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  usermod $nick $handle $chan $ns1 $ns $tcl $host
  return 0
  }
proc msg:killmodes {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  killmodes $nick $chan $host
  return 0
  }
proc msg:userdel {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set ns [lindex $arg 2]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  userdel $nick $handle $chan $ns1 $ns $host
  return 0
  }
proc msg:useradd {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  set ns [lindex $arg 2]
  set tcl [lindex $arg 3]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  useradd $nick $handle $chan $ns1 $host $ns $tcl
  return 0
  }
proc msg:mode {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  mode $nick $chan $botnet $host
  return 0
  }
proc msg:onjoin {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|m $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  onjoin $nick $chan $host $botnet
  return 0
}
proc msg:say {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|n $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  say $nick $chan $botnet $host
  return 0
  }
proc msg:act {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|n $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  act $nick $chan $host $botnet
  return 0
  }

proc msg:cycle {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set botnet [lrange $arg 1 end]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o|n $chan]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  cycle $nick $host $handle $chan
  return 0
}

proc msg:chanstats {nick host handle arg} {
global botnick
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  chanstats $nick $host
  return 0
  }
proc msg:addchan {nick host handle arg} {
global botnick
  set ns1 [lindex $arg 0]
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  addchan $nick $ns1 $host $handle
  return 0
  }
proc msg:remchan {nick host handle arg} {
global botnick
  set ns1 [lindex $arg 0]
  set chan $ns1
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  remchan $nick $chan $ns1 $handle $host
  return 0
  }
proc msg:broadcast {nick host handle arg} {
global botnick
  set botnet [lrange $arg 0 end]
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  broadcast $nick $host $botnet
  return 0
  }
proc msg:disable {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  disable $nick $handle $host $chan $ns1
  return 0
  }
proc msg:enable {nick host handle arg} {
global botnick
  set argument [lindex $arg 0]
if {[string match "#*" $argument]} {
if {[validchan $argument]} {
  set chan $argument
  set ns1 [lindex $arg 1]
  } else {
  putquick "NOTICE $nick :Channel Not Found - $argument could not be found in the channel records."
  return 0
  }
  } else {
  putquick "NOTICE $nick :No Channel Specified - You need to specify a channel."
  return 0
  }
if {![matchattr $handle o]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  enable $nick $host $chan $ns1
  return 0
  }
proc msg:save {nick host handle arg} {
global botnick
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  do_save $nick $host
  return 0
  }
proc msg:rehash {nick host handle arg} {
global botnick
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  do_rehash $nick $host
  return 0
  }
proc msg:restart {nick host handle arg} {
global botnick
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  do_restart $nick $host
  return 0
  }
proc msg:sndmsg {nick host handle arg} {
global botnick
  set ns1 [lindex $arg 0]
  set botnet2 [lrange $arg 1 end]
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  sndmsg $nick $ns1 $host $botnet2
  return 0
  }
proc msg:sndnotice {nick host handle arg} {
global botnick
  set ns1 [lindex $arg 0]
  set botnet2 [lrange $arg 1 end]
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  sndnotice $nick $ns1 $host $botnet2
  return 0
  }
proc msg:servers {nick host handle arg} {
global botnick
if {![matchattr $handle m]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  servers $nick $host
  return 0
  }
proc msg:core {nick host handle arg} {
global botnick
if {![matchattr $handle n]} {
  putquick "NOTICE $nick :Permission Denied."
  return 0
  }
if {![matchattr $handle A]} {
  putquick "NOTICE $nick :You need to authenticate first - Permission Denied."
  putquick "NOTICE $nick :You may authenticate yourself by typing \002/msg $botnick auth <your password>\002"
  return 0
  }
if {[matchattr $handle D]} {
  putquick "NOTICE $nick :Access Is Disabled - Permission Denied."
  return 0
  }
  core $nick $host $handle $arg
  return 0
  }
if {[info exists numversion] && ($numversion < 1032800)} {
  die "Your eggdrop version is too old to support AlphaChat.tcl, please upgrade before using AlphaChat.TCL"
  }
  putlog "AlphaChat.TCL - An AlphaChat production - now loaded"
