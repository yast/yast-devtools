#! /bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

package require Tk
package require Tix
tix resetoptions TK TK
::tk::unsupported::ExposePrivateCommand *
::tk::unsupported::ExposePrivateVariable *

#use Tk::HList;
#use Tk::ItemStyle;

wm geometry . 1200x800+10+10

# ------------------------------------------------------------

bind . <Destroy> appexit

proc app_end {} {
	destroy .
}

proc app_exit {} {
	puts "Exit!"
}

# ------------------------------------------------------------

proc data_init { ce idat dat tim lev hos pid cla fil fnc lin txt } {
	global HLST

	set itxt [list $ce $dat $tim "<$lev>" "$hos\($pid)" "\[$cla]" "$fil\($fnc):$lin" $txt]
	lappend idat $itxt

	$HLST() entryconfigure $ce -data $idat
	for { set i 0 } { $i < $HLST(c_) } { incr i } {
		if { [lindex $HLST(c_state) $i] } {
			$HLST() item configure $ce $i -text [lindex $itxt $i]
		}
	}
}

proc data_get_hc { ce } {
	global HLST
	return [lindex [$HLST() info data $ce] 0]
}

proc data_adjust_hc { ce inc } {
	global HLST
	if { ! $inc } {
		return [data_get_hc $ce]
	}
	set data [$HLST() info data $ce]
	set nhc [expr [lindex $data 0] + $inc]
	lset data 0 $nhc
	$HLST() entryconfigure $ce -data $data
	return $nhc
}

proc data_get_cidx { ce } {
	global HLST
	return [lindex [$HLST() info data $ce] 1]
}

proc data_get_lidx { ce } {
	global HLST
	return [lindex [$HLST() info data $ce] 2]
}

proc data_adjust { ce cidx } {
	global HLST
	if { [lindex $HLST(c_state) $cidx] } {
		set text [lindex [lindex [$HLST() info data $ce] 3] $cidx]

	} else {
		set text [expr {$cidx ? {} : { }}]
	}
	$HLST() item configure $ce $cidx -text $text
}

proc data_append_text { ce txt } {
	global HLST
	set data [$HLST() info data $ce]
	set ntxt "[lindex [lindex $data 3] $HLST(c_txt)]\n$txt"
	lset data 3 $HLST(c_txt) $ntxt
	$HLST() entryconfigure $ce -data $data
	$HLST() item configure $ce $HLST(c_txt) -text $ntxt
}

# ------------------------------------------------------------

set W .f_cl
frame $W
pack $W -side top -fill both

frame $W.l
pack $W.l -side top -anchor w

frame $W.c
pack $W.c -side bottom -fill both

set CN() 0
set CL() $W.c

set Clayout()  { 0 1 2 3 4 5 6 999 }
set Clayout(0)		SkyBlue1
set Clayout(1)		grey95
set Clayout(2)		LightYellow1
set Clayout(3)		RosyBrown1
set Clayout(4)		plum
set Clayout(5)		SeaGreen1
set Clayout(6)		Yellow
set Clayout(999)	GreenYellow
set Clayout(fg)		black
set Clayout(bg)		grey80
set Clayout(dimfg)	grey50
set Clayout(dimbg)	grey80
set Clayout(maxcol)	4
set Clayout(row)	-1
set Clayout(col)	$Clayout(maxcol)

set Cname(0)   D
set Cname(1)   M
set Cname(2)   W
set Cname(3)   E
set Cname(4)   S
set Cname(5)   I
set Cname(6)   U
set Cname(999) -

set _tcol 0
foreach i $Clayout() {
	set CL(.$i) 0
	label $W.l.l$i -text $Cname($i) -bg $Clayout($i)
	checkbutton $W.l.$i -onvalue 0 -offvalue 1 -variable CL(.$i) \
		-bg $Clayout($i) -activebackground $Clayout($i) \
		-command "cl_cmd_l $i"
	grid $W.l.l$i -row 0 -column $_tcol -sticky news
	grid $W.l.$i -row 1 -column $_tcol -sticky news
	incr _tcol
	#pack $W.l.$i -side left
}

proc cl_cb_color { c { l {} } } {
	global CL
	global Clayout
	if { $l == {} } {
		set w $CL().$c.c
		set fg [expr {$CL($c) ? $Clayout(dimfg) : $Clayout(fg)}]
		$w configure -fg $fg -activeforeground $fg
		return
	}

	set w $CL().$c.$l
	if { $CL($c.$l) || $CL(.$l) } {
		set bg $Clayout(dimbg)
		set sel $Clayout(dimbg)
	} else {
		set bg [expr {$CL($c) ? $Clayout(dimbg) : $Clayout($l)}]
		set sel $Clayout($l)
	}
	$w configure -bg $bg -activebackground $bg -selectcolor $sel
}

proc cl_check { c l } {
	global CN
	global CL
	if { [array names CN $c] != {} } {
		set cidx $CN($c)
	} else {
		set cidx $CN()
		incr CN()

		global Clayout
		set CN($c) $cidx
		set CL($cidx) 0
		foreach i $Clayout() {
			set CL($cidx.$i) 0
		}

		set W $CL().$cidx
		frame $W
		foreach i $Clayout() {
			checkbutton $W.$i -onvalue 0 -offvalue 1 -variable CL($cidx.$i) \
				-command "cl_cmd_cl $cidx $i"
			cl_cb_color $cidx $i
			pack $W.$i -side left
		}
		checkbutton $W.c -onvalue 0 -offvalue 1 -variable CL($cidx) \
			-text $c -anchor w -command "cl_cmd_c $cidx"
		cl_cb_color $cidx
		pack $W.c -side left -fill x -expand yes

		if { [incr Clayout(col)] >= $Clayout(maxcol) } {
			set Clayout(col) 0
			incr Clayout(row)
		}
		if { $Clayout(row) == 0 } {
			grid columnconfig $CL() $Clayout(col) -weight 1 -minsize 0
		}
		grid $W -row $Clayout(row) -column $Clayout(col) \
			-rowspan 1 -columnspan 1 -sticky news
	}

	return [list [expr $CL($cidx) + $CL(.$l) + $CL($cidx.$l)] $cidx $l]
}

proc cl_cmd_cl { c l } {
	global CL
	global HLST
	f_lst_save_view
	cl_cb_color $c $l
	set inc [expr {$CL($c.$l) ? 1 : -1}]
	foreach p [$HLST() info children {}] {
		foreach ce [$HLST() info children $p] {
			if { [data_get_cidx $ce] == $c && [data_get_lidx $ce] == $l } {
				f_lst_adjust_hide $ce $inc
			}
		}
	}
	f_lst_restore_view
}

proc cl_cmd_c { c } {
	global CL
	global Clayout
	global HLST
	f_lst_save_view
	foreach l $Clayout() {
		cl_cb_color $c $l
	}
	cl_cb_color $c
	set inc [expr {$CL($c) ? 1 : -1}]
	foreach p [$HLST() info children {}] {
		foreach ce [$HLST() info children $p] {
			if { [data_get_cidx $ce] == $c } {
				f_lst_adjust_hide $ce $inc
			}
		}
	}
	f_lst_restore_view
}

proc cl_cmd_l { l } {
	global CL
	global CN
	global HLST
	f_lst_save_view
	for { set c 0 } { $c < $CN() } { incr c } {
		cl_cb_color $c $l
	}
	set inc [expr {$CL(.$l) ? 1 : -1}]
	foreach p [$HLST() info children {}] {
		foreach ce [$HLST() info children $p] {
			if { [data_get_lidx $ce] == $l } {
				f_lst_adjust_hide $ce $inc
			}
		}
	}
	f_lst_restore_view
}

# ------------------------------------------------------------

set W .f_lst
frame $W
pack $W -side top -fill both -expand 1

set HLST()     $W.lst
set HLST(top)  {}
set HLST(last) {}

set HLST(c_)	  0
set HLST(c_state) {}
foreach { c_n ctext } {
		c_tag { }
		c_dat {Date}
		c_tim {Time}
		c_lev {<L>}
		c_hos {Host(Pid)}
		c_cla {[Class]}
		c_fil {File(Fnc):Line}
		c_txt {Text}
		} {
	set HLST($c_n) $HLST(c_)
	incr HLST(c_)
	lappend HLST(c_state) 1
	lappend HLST(c_text)  $ctext
}
lset HLST(c_state) $HLST(c_dat) 0
lset HLST(c_state) $HLST(c_dat) 0
lset HLST(c_state) $HLST(c_tim) 0
lset HLST(c_state) $HLST(c_lev) 0
lset HLST(c_state) $HLST(c_hos) 0

set HLST(wheel) $W.wheel
set HLST(wheelchar) {}
set HLST(wheeljump) 0

set HLST(selX) 0
set HLST(selY) 0

tixDisplayStyle imagetext -stylename f_lststyle_ -anchor nw
set f_lststyle_font(wdefault) [f_lststyle_ cget -font]
set f_lststyle_font(default)  -adobe-courier-medium-r-*-*-14-*-*-*-*-*-iso10646-1
set f_lststyle_font(small)    -adobe-courier-medium-r-*-*-12-*-*-*-*-*-iso10646-1
set f_lststyle_font(tiny)     -adobe-courier-medium-r-*-*-8-*-*-*-*-*-iso10646-1

f_lststyle_ configure -font $f_lststyle_font(tiny)

for { set col 0 } { $col < $HLST(c_) } { incr col } {
	if { $col == $HLST(c_txt) } {
		set font $f_lststyle_font(default)
	} elseif { $col == $HLST(c_tag) } {
		set font $f_lststyle_font(tiny)
	} else {
		set font $f_lststyle_font(small)
	}
	foreach i $Clayout() {
		tixDisplayStyle imagetext -stylename f_lststyle_${i}_$col -anchor nw -bg $Clayout($i) -font $font
	}

	tixDisplayStyle imagetext -stylename f_lststyle_start_$col -anchor nw -bg GreenYellow -font $f_lststyle_font(wdefault)
}
tixDisplayStyle window -stylename f_lststyle_hstyle

image create pixmap img_plus -data {
/* XPM */
static char * plus_xpm[] = {
"9 9 2 1",
".      s None  c None",
"       c black",
"         ",
" ....... ",
" ... ... ",
" ... ... ",
" .     . ",
" ... ... ",
" ... ... ",
" ....... ",
"         "};
}
image create pixmap img_minus -data {
/* XPM */
static char * minus_xpm[] = {
"9 9 2 1",
".      s None  c None",
"       c black",
"         ",
" ....... ",
" ....... ",
" ....... ",
" .     . ",
" ....... ",
" ....... ",
" ....... ",
"         "};
}

tixHList $HLST() -yscroll "f_lst_topset; $W.ysc set" -xscroll "$W.xsc set" \
	-header 1 -columns $HLST(c_) -itemtype imagetext \
	-selectbackground gray -selectborderwidth 0 -selectmode extended\
	-command f_lst_select
scrollbar $W.xsc -orient horizontal -command "$W.lst xview"
scrollbar $W.ysc -orient vertical -command "$W.lst yview"

label $HLST(wheel) -textvar HLST(wheelchar) -font fixed -borderwidth 2 \
	-relief [expr {$HLST(wheeljump) ? {sunken} : {raised}}]
bind $HLST(wheel) <Button-1> { f_lst_wheel_click }


set HLST(fload) $W.fload
frame $HLST(fload)

grid columnconfigure $W 0 -weight 1
grid rowconfigure $W 0 -weight 1
grid $HLST(fload) -row 0 -column 0 -sticky news
grid remove $HLST(fload)
grid $HLST() -row 0 -column 0 -sticky news
grid $W.ysc -row 0 -column 1 -sticky news
grid $W.xsc -row 1 -column 0 -sticky news
grid $HLST(wheel) -row 1 -column 1 -sticky news

for { set i 0 } { $i < $HLST(c_) } { incr i } {
	button $HLST().b_$i -bd 0 -padx 0 -pady 0 -anchor w -command "f_lst_header $i"
	if { [lindex $HLST(c_state) $i] } {
		$HLST().b_$i configure -text [lindex $HLST(c_text) $i]
	}
	$HLST() header create $i -itemtype window -style f_lststyle_hstyle -window $HLST().b_$i
}

focus $HLST()

bind $HLST() <Key-Home>		{ f_lst_home; break }
bind $HLST() <Key-End>		{ f_lst_end; break }
bind $HLST() <Key-Up>		{ f_lst_prev; break }
bind $HLST() <Key-Down>		{ f_lst_next; break }
bind $HLST() <Shift-Key-Page_Up>	{ f_lst_prevtop; break }
bind $HLST() <Shift-Key-Page_Down>	{ f_lst_nexttop; break }



bind $HLST() <Key-Left>		{ f_lst_hscroll -1; break }
bind $HLST() <Key-Right>	{ f_lst_hscroll 1; break }
bind $HLST() <Shift-Key-Left>	{ f_lst_prevcol; break }
bind $HLST() <Shift-Key-Right>	{ f_lst_nextcol; break }
#bind $HLST() <Shift-Key-Up>	+continue
#bind $HLST() <Shift-Key-Down>	+continue
bind $HLST() <Button-1>	{
   global HLST
   set HLST(selX) %x
   set HLST(selY) %y
   selection own .
}
bind $HLST() <Button-2>	{
   selection own .
}

selection handle . selection_getData

proc selection_getData { a b } {
   global HLST

   set sellist [$HLST() info selection]
   if { [llength $sellist] == 0 } {
      return {}
   }

   set oncols [f_lst_dump_getoncols]
   set ret {}
   foreach ce [$HLST() info selection] {
      set linedat [f_lst_dump_getlinecols $ce $oncols]
      lappend ret $linedat
   }

   return "[join $ret "\n"]\n"

   ## not used:
   if {[catch {f_lst_dump_getline [$HLST() nearest $HLST(selY)]} foo]} {
      return ""
   } else {
      return $foo
   }
}

proc f_lst_wheel_click {} {
	global HLST
	set HLST(wheeljump) [expr {$HLST(wheeljump) ? 0 : 1}]
	$HLST(wheel) configure -relief [expr {$HLST(wheeljump) ? {sunken} : {raised}}]
	if { $HLST(wheeljump) } {
		$HLST() see $HLST(last)
		update idletas
	}
}

proc f_lst_wheel {} {
	global log
	global HLST
	if { ! $log(ispipe) } {
		return
	}
	if { $HLST(wheeljump) } {
		$HLST() see $HLST(last)
	}
	#update idletasks
}

proc f_lst_topvis {} {
	global HLST
	return [$HLST() nearest 37]
}

set in_topset 0

proc f_lst_topset {} {
	global HLST
	global in_topset
	if { $in_topset } {
		return
	}
	set in_topset 1
	set topv [f_lst_topvis]
	if { $topv != {} } {
		$HLST() yview $topv
	}
	set in_topset 0
}

proc f_lst_home {} {
	global HLST
	set topv [lindex [$HLST() info children] 0]
	if { $topv != {} } {
		$HLST() yview $topv
	}
}

proc f_lst_end {} {
	global HLST
	set topv $HLST(last)
	if { $topv != {} } {
		$HLST() yview $topv
	}
}

proc f_lst_prev {} {
	global HLST
	set topv [f_lst_topvis]
	if { $topv == {} } {
		return
	}
	set topv [$HLST() info prev $topv]
	while { $topv != {} && [$HLST() info hidden $topv] } {
		set topv [$HLST() info prev $topv]
	}
	if { $topv == {} } {
		return
	}
	$HLST() yview $topv
}

proc f_lst_next {} {
	global HLST
	set topv [f_lst_topvis]
	if { $topv == {} } {
		return
	}
	set topv [$HLST() info next $topv]
	if { $topv == {} } {
		return
	}
	$HLST() yview $topv
}

proc f_lst_prevtop {} {
	global HLST
	set topv [f_lst_topvis]
	if { $topv == {} } {
		return
	}
	set topv [$HLST() info prev $topv]
	if { $topv == {} } {
		return
	}
	set topp [$HLST() info parent $topv]
	if { $topp == {} } {
		set topp $topv
	}
	$HLST() yview $topp
}

proc f_lst_nexttop {} {
	global HLST
	set topv [f_lst_topvis]
	set topp [$HLST() info parent $topv]
	if { $topp == {} } {
		set topp $topv
	}
	set topl [$HLST() info children]
	set topp [lindex $topl [expr [lsearch -exact $topl $topp]+1]]
	if { $topp == {} } {
		f_lst_end
	} else {
		$HLST() yview $topp
	}
}

proc f_lst_hscroll { d } {
	global HLST
	$HLST() xview scroll $d units
}

proc f_lst_prevcol {} {
}

proc f_lst_nextcol {} {
}

proc f_lst_save_view {} {
	global HLST
	set HLST(sv) [$HLST() nearest 30]
}

proc f_lst_restore_view {} {
	global HLST
	update idletasks
	$HLST() yview $HLST(sv)
}

proc f_lst_adjust_hide { p { i 0 } } {
	global HLST
	if { [data_adjust_hc $p $i] > 0 } {
		$HLST() hide entry $p
	} else {
		$HLST() show entry $p
	}
}

proc f_lst_append_new { dat tim lev hos pid cla fil fnc lin txt } {
	global HLST
	global log

	if [string equal $cla Timecount] {
		set lev 999
	}

	if { $log(newopen) || [string first "Launched YaST2 component" $txt 0] != -1 } {
		set par {}
		set log(newopen) 0
	} else {
		set par $HLST(top)
	}

	if { $par == {} } {
		upvar #0 HLST(top) ce
		set lstyle f_lststyle_start
		set ce [$HLST() addchild $par -style ${lstyle}_0 -image img_minus]
		set idat [list 0 0 0]
	} else {
		set lstyle "f_lststyle_$lev"
		set ce [$HLST() addchild $par -style f_lststyle_ -text { } ]
		set idat [cl_check $cla $lev]
	}

	for { set i 1 } { $i < $HLST(c_) } { incr i } {
		$HLST() item create $ce $i -style ${lstyle}_$i
	}

	data_init $ce $idat $dat $tim $lev $hos $pid $cla $fil $fnc $lin $txt
	set HLST(last) $ce

	if { $par != {} } {
		f_lst_adjust_hide $ce [data_get_hc $par]
	} else {
		# autohide new tops
		#f_lst_select $ce
	}
}

proc f_lst_append_txt { txt } {
	global HLST
	if { $HLST(last) != {} } {
		data_append_text $HLST(last) $txt
	} else {
		if [string length $txt] {
			f_lst_append_new {} {} {} {} {} {} {} {} {} $txt
		}
	}
}

proc f_lst_append { l } {
	switch [llength $l] {
		"1" {
			eval f_lst_append_txt $l
		}
		"10" {
			eval f_lst_append_new $l
		}
		default {
			puts "?:[llength $l]: $l"
		}
	}
}

proc f_lst_clear {} {
	global HLST
	$HLST() delete all
	set HLST(top)  {}
	set HLST(last) {}
}

proc f_lst_select { p } {
	global HLST
	switch -regexp -- $p {
		{^[0-9]+$} {
			if { [data_get_hc $p] == 0 } {
				set img img_plus
				set nhs 1
			} else {
				set img img_minus
				set nhs -1
			}
			data_adjust_hc $p $nhs
			foreach c [$HLST() info children $p] {
				f_lst_adjust_hide $c $nhs
			}
			$HLST() item configure $p $HLST(c_tag) -image $img
		}
		default {
			#puts "Select $p"
		}
	}
}

proc f_lst_dump_getoncols {} {
   global HLST
   set oncols {}
   for { set i 1 } { $i < $HLST(c_) } { incr i } {
      if [lindex $HLST(c_state) $i] {
	 lappend oncols $i
      }
   }
   return $oncols
}

proc f_lst_dump_getlinecols { ce oncols } {
   global HLST
   set linelst [lindex [$HLST() info data $ce] 3]
   set ondat {}
   foreach c $oncols {
      lappend ondat [lindex $linelst $c]
   }
   return [join $ondat]
}

proc f_lst_dump_getline { ce } {

   return [f_lst_dump_getlinecols $ce [f_lst_dump_getoncols]]
}

proc f_lst_dumpselection {} {
	global HLST

	set sellist [$HLST() info selection]
	if { [llength $sellist] == 0 } {
	   puts "***No Selection!"
	   return
	}

	puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	set oncols [f_lst_dump_getoncols]
	foreach ce [$HLST() info selection] {
	        set linedat [f_lst_dump_getlinecols $ce $oncols]
	        puts $linedat
	}
	puts "----------------------------------------------------------"
}
# ------------------------------------------------------------

proc f_lst_header { col } {
	global HLST
	if { $col == $HLST(c_txt) } {
		return
	}
	set cvis [expr [lindex $HLST(c_state) $col] ?  0 : 1]
	lset HLST(c_state) $col $cvis
	set cbut [$HLST() header cget $col -window]

	if { $cvis } {
		$cbut configure -text [lindex $HLST(c_text) $col]
	} else {
		$cbut configure -text {}
	}

	foreach p [$HLST() info children {}] {
		data_adjust $p $col
		foreach c [$HLST() info children $p] {
			data_adjust $c $col
		}
	}
}

# ------------------------------------------------------------

proc t_bbox { w } {
	global HLST
	set bbox [$HLST() info bbox $w]
	if { $bbox == {} } {
		puts "bbox $w: -"
	} else {
		puts "bbox $w: [lindex $bbox 0] - [lindex $bbox 2] : [expr [lindex $bbox 2] - [lindex $bbox 0]]"
	}
}

proc f_lst_test { { d {} } } {
	global HLST
	f_lst_dumpselection
}

# ------------------------------------------------------------

set W .f_msg
frame $W -borderwidth 2 -relief ridge
pack $W -side top -fill x

set MSG() $W.text
set MSG(txt) {}

label $MSG() -textvar MSG(txt) -anchor w
pack $MSG() -side left -fill x -expand yes

proc msg_set { { t {} } { bg {grey80} } { fg {black} } } {
	global MSG
	$MSG() configure -bg $bg -fg $fg
	set MSG(txt) $t
}

proc msg_err { { t {} } } {
	msg_set "***ERROR: $t" red yellow
}

proc msg_note { { t {} } } {
	msg_set "***NOTE: $t" cyan3 black
}

# ------------------------------------------------------------

set W .f_but
frame $W
pack $W -side bottom -fill x

button $W.clear -text Clear -command cmd_clear
button $W.reread -text Reread -command cmd_reread
button $W.test -text {Dump Selection} -command f_lst_test
button $W.exit -text Exit -command app_end

pack $W.clear $W.reread $W.test -side left
pack $W.exit -side right

proc cmd_clear {} {
	f_lst_clear
	msg_set "Log cleared"
}

proc cmd_reread {} {
	global log
	if { $log(ispipe) } {
		msg_note "Can't reread pipe."
	} else {
		f_lst_clear
		log_open
	}
}

# ------------------------------------------------------------

set W $HLST(fload)

scale $W.scale -orient horizontal -from 0 -to 100 -tickinterval 10 -variable HLST(floadsze)
pack $W.scale -side bottom -fill x

proc fload_start {} {
	global log
	global HLST

	set log(offstart) [clock seconds]
	msg_set "Reading file \"$log(file)\"..."

	set v [file size $log(file)]
	set HLST(floadsze) 0
	set HLST(floadinc) [expr $v / 100]
	set HLST(floadupd) $HLST(floadinc)
	$HLST(fload).scale configure -to $v -tickinterval [expr $v / 10]

	grid remove $HLST()
	grid remove .f_lst.xsc
	grid remove .f_lst.ysc
	grid $HLST(fload)

	update idletasks
}

proc fload_set { v } {
	global HLST
	set HLST(floadsze) $v
	if { $HLST(floadsze) >= $HLST(floadupd) } {
		incr HLST(floadupd) $HLST(floadinc)
		update idletasks
	}
}

proc fload_done {} {
	global log
	global HLST

	grid remove $HLST(fload)
	grid $HLST()
	grid .f_lst.xsc
	grid .f_lst.ysc

	msg_set "Close file \"$log(file)\" after [expr [clock seconds] - $log(offstart)] sec."

	update idletasks
}
# ------------------------------------------------------------

set log(file)   {y2log}
set log(fid)    -1
set log(ispipe) 0
set log(newopen) 0

proc log_addline { t } {
	set ldat {}
	## ------    |-date---------------------|    |-time---------------------|     |-leve-|     |-hos-|  |-pid--|        |-cla-|  |-file-|  |-fnc---|     |-line-|
	if [regexp {^([0-9]{4}-[0-9]{2}-[0-9]{2})[ ]+([0-9]{2}:[0-9]{2}:[0-9]{2})[ ]+<([0-9]+)>[ ]+([^ ]*)\(([0-9]+)\)[ ]+\[([^]]+)] ([^( ]+)(\(([^ :]+)\))?:([0-9]+) (.*)} \
			$t lne(dummy) lne(date) lne(time) lne(level) lne(host) lne(pid) lne(class) lne(file) lne(dummy) lne(fnc) lne(lne) lne(text)] {
		if [string match "*++" $lne(class)] {
			set lne(class) [string range $lne(class) 0 end-2]
			set lne(level) 0
		}
		set ldat [list $lne(date) $lne(time) $lne(level) $lne(host) $lne(pid) $lne(class) $lne(file) $lne(fnc) $lne(lne) $lne(text)]
	## ------          |-date---------------------|    |-time------------------------------|    |-leve-----------------|    |-cla-|         |-file-|  |-fnc---|     |-line-|
	} elseif [regexp {^([0-9]{4}-[0-9]{2}-[0-9]{2})[ ]+([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})[ ]+(DEBUG|INFO|ERROR|FATAL)[ ]+([^ ]+)[ ]+-[ ]+([^( ]+)(\(([^ :]+)\))?:([0-9]+) (.*)} \
		       $t lne(dummy) lne(date) lne(time) lne(level) lne(class) lne(file) lne(dummy) lne(fnc) lne(lne) lne(text)] {
		switch $lne(level) {
		   DEBUG { set lne(level) 0 }
		   INFO  { set lne(level) 1 }
		   ERROR { set lne(level) 2 }
		   FATAL { set lne(level) 3 }
		}
		set lne(host) {}
		set lne(pid)  {}
		set ldat [list $lne(date) $lne(time) $lne(level) $lne(host) $lne(pid) $lne(class) $lne(file) $lne(fnc) $lne(lne) $lne(text)]
	} elseif [regexp {^==[0-9]+==} $t] {
		set ldat
		set ldat [list "0000-00-00" "00:00:00" 999 "---" 000 "VALGRIND" "---" "---" 000 $t]
	} else {
		set ldat [list $t]
	}
	f_lst_append $ldat
	f_lst_wheel
}

proc log_get_line {} {
	global log
	set lcnt 0
	while { [gets $log(fid) line] != -1 } {
		if { ! $log(ispipe) } {
			fload_set [tell $log(fid)]
		} elseif { $log(newopen) } {
			cmd_clear
		}
		log_addline $line
		if { $lcnt > 100 } {
			set lcnt 0
			update idletasks
		} else {
			incr lcnt
		}
	}
	if [eof $log(fid)] {
		if { $line != {} } {
			log_addline $line
		}
		log_close
	}
	update idletasks
}

proc log_close {} {
	global log
	if { $log(fid) != -1 } {
		close $log(fid)
		set log(fid) -1
		if { $log(ispipe) } {
			log_open
		} else {
			fload_done
		}
	}
}

proc log_open { { f {} } } {
	global log
	if { $log(fid) != -1 } {
		log_close
	}
	if { $f != {} } {
		set log(file) $f
	}

	global HLST
	catch {file type $log(file)} ftype
	switch -exact -- $ftype {
		"file" {
			set log(ispipe) 0
			fload_start
		}
		"fifo" {
			set log(ispipe) 1
			update idletasks
		}
		default {
			set log(ispipe) 0
			msg_err "Open \"$log(file)\": $ftype"
			update idletasks
			return
		}
	}
	set log(newopen) 1
	set log(fid) [open $log(file) {RDONLY NONBLOCK}]
	fconfigure $log(fid) -blocking off -buffersize 1000000
	fileevent $log(fid) readable log_get_line
}

# ------------------------------------------------------------
tkwait visibility .
update idletasks

if { [llength $argv] } {
	set log(file) [lindex $argv 0]
}
log_open
