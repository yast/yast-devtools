" Vim syntax file
" Filename:     ycp.vim
" Language:     YCP: SuSE YaST2 scripting language
" Maintainer:   Michal Svec <msvec@suse.cz>
" Last change:  20.8.2003

" Remove any old syntax stuff hanging around
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" YCP statements
syn keyword	ycpStatement	break return continue define global
syn keyword	ycpStatement	module import include textdomain

" YCP conditionals
syn keyword	ycpConditional	if else
syn keyword	ycpRepeat	while do repeat until

" YCP todos
syn keyword	ycpTodo		contained TODO FIXME XXX

" YCP string and character constants
syn match	ycpSpecial	contained "\\x\x\+\|\\\o\{1,3\}\|\\.\|\\$"
syn region	ycpString	start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=ycpSpecial
syn match	ycpCharacter	"'[^\\]'"
syn match	ycpSpecialCharacter "'\\.'"
syn match	ycpSpecialCharacter "'\\\o\{1,3\}'"

" errors caused by wrong parenthesis
syn match	ycpInParen	contained "[{}]"

" YCP numbers
syn case ignore
" integer number, or floating point number without a dot and with "f".
syn match	ycpNumber	"\<\d\+\(u\=l\=\|lu\|f\)\>"
" floating point number, with dot, optional exponent
syn match	ycpFloat	"\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
" floating point number, starting with a dot, optional exponent
syn match	ycpFloat	"\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
" floating point number, without dot, with exponent
syn match	ycpFloat	"\<\d\+e[-+]\=\d\+[fl]\=\>"
" hex number
syn match	ycpNumber	"\<0x\x\+\(u\=l\=\|lu\)\>"
" identifier
" syn match	ycpIdentifier	"\<[a-z_][a-z0-9_]*\>"
syn case match
" flag an octal number with wrong digits
syn match	ycpOctalError	"\<0\o*[89]"

" YCP coding errors
syn match	ycpSpaceError	excludenl "\s\+$"
syn match	ycpSpaceError	" \+\t"me=e-1
syn match	ycpCommentError	"\*/"

" YCP comments
syn region	ycpComment	start="/\*" end="\*/" contains=ycpTodo,ycpSpaceError
syn match	ycpComment	"//.*" contains=ycpTodo,ycpCommentError,ycpSpaceError

"Operators and builtin functions
syn keyword	ycpBuiltin	is select remove change contains
syn keyword	ycpBuiltin	setcontains lookup haskey add union merge size
syn keyword	ycpBuiltin	symbolof sleep foreach filter maplist mapmap
syn keyword	ycpBuiltin	flatten toset sort sformat tointeger
syn keyword	ycpBuiltin	crypt cryptmd5 cryptbigcrypt cryptblowfish
syn keyword	ycpBuiltin	eval find isnil
syn keyword	ycpBuiltin	random srandom
syn keyword	ycpBuiltin	getenv setenv

" WFM builtins
syn keyword	ycpBuiltin	WFM UI SCR Args
syn keyword	ycpBuiltin	Read Write Dir Execute
syn keyword	ycpBuiltin	CallFunction CallModule SetLanguage GetLanguage
syn keyword	ycpBuiltin	SCROpen SCRClose SCRGetName GetClientName
syn keyword	ycpBuiltin	SCRSetDefault SCRGetDefault

" SCR builtins
syn keyword	ycpBuiltin	RegisterAgent
syn keyword	ycpBuiltin	UnregisterAgent UnregisterAllAgents
syn keyword	ycpBuiltin	MountAgent MountAllAgents
syn keyword	ycpBuiltin	UnmountAgent UnmountAllAgents
syn keyword	ycpBuiltin	YaST2Version SuSEVersion

" YUI builtins
syn keyword	ycpBuiltin	AskForExistingDirectory
syn keyword	ycpBuiltin	AskForExistingFile
syn keyword	ycpBuiltin	AskForSaveFileName
syn keyword	ycpBuiltin	Beep
syn keyword	ycpBuiltin	BusyCursor
syn keyword	ycpBuiltin	ChangeWidget
syn keyword	ycpBuiltin	CheckShortcuts
syn keyword	ycpBuiltin	CloseDialog
syn keyword	ycpBuiltin	DumpWidgetTree
syn keyword	ycpBuiltin	FakeUserInput
syn keyword	ycpBuiltin	GetDisplayInfo
syn keyword	ycpBuiltin	GetLanguage
syn keyword	ycpBuiltin	GetModulename
syn keyword	ycpBuiltin	GetProductName
syn keyword	ycpBuiltin	Glyph
syn keyword	ycpBuiltin	HasSpecialWidget
syn keyword	ycpBuiltin	MakeScreenShot
syn keyword	ycpBuiltin	NormalCursor
syn keyword	ycpBuiltin	OpenDialog
syn keyword	ycpBuiltin	PlayMacro
syn keyword	ycpBuiltin	PollInput
syn keyword	ycpBuiltin	PostponeShortcutCheck
syn keyword	ycpBuiltin	QueryWidget
syn keyword	ycpBuiltin	RecalcLayout
syn keyword	ycpBuiltin	Recode
syn keyword	ycpBuiltin	RecordMacro
syn keyword	ycpBuiltin	RedrawScreen
syn keyword	ycpBuiltin	ReplaceWidget
syn keyword	ycpBuiltin	RunPkgSelection
syn keyword	ycpBuiltin	RunInTerminal
syn keyword	ycpBuiltin	SetConsoleFont
syn keyword	ycpBuiltin	SetFocus
syn keyword	ycpBuiltin	SetFunctionKeys
syn keyword	ycpBuiltin	SetKeyboard
syn keyword	ycpBuiltin	SetLanguage
syn keyword	ycpBuiltin	SetModulename
syn keyword	ycpBuiltin	SetProductName
syn keyword	ycpBuiltin	StopRecordMacro
syn keyword	ycpBuiltin	TimeoutUserInput
syn keyword	ycpBuiltin	UserInput
syn keyword	ycpBuiltin	WaitForEvent
syn keyword	ycpBuiltin	WidgetExists
syn keyword	ycpBuiltin	WizardCommand

" YCP builtins
syn keyword	ycpBuiltin	contains
syn keyword	ycpBuiltin	haskey
syn keyword	ycpBuiltin	filter
syn keyword	ycpBuiltin	find
syn keyword	ycpBuiltin	maplist
syn keyword	ycpBuiltin	flatten
syn keyword	ycpBuiltin	sort
syn keyword	ycpBuiltin	toset
syn keyword	ycpBuiltin	tointeger
syn keyword	ycpBuiltin	tofloat
syn keyword	ycpBuiltin	tostring
syn keyword	ycpBuiltin	topath
syn keyword	ycpBuiltin	toterm
syn keyword	ycpBuiltin	crypt
syn keyword	ycpBuiltin	cryptmd5
syn keyword	ycpBuiltin	cryptbigcrypt
syn keyword	ycpBuiltin	cryptblowfish
syn keyword	ycpBuiltin	timestring
syn keyword	ycpBuiltin	substring
syn keyword	ycpBuiltin	findfirstof
syn keyword	ycpBuiltin	findlastof
syn keyword	ycpBuiltin	findfirstnotof
syn keyword	ycpBuiltin	findlastnotof
syn keyword	ycpBuiltin	tolower
syn keyword	ycpBuiltin	toupper
syn keyword	ycpBuiltin	toascii
syn keyword	ycpBuiltin	filterchars
syn keyword	ycpBuiltin	deletechars
syn keyword	ycpBuiltin	time
syn keyword	ycpBuiltin	sleep
syn keyword	ycpBuiltin	random
syn keyword	ycpBuiltin	srandom
syn keyword	ycpBuiltin	sformat
syn keyword	ycpBuiltin	issubstring
syn keyword	ycpBuiltin	regexpmatch
syn keyword	ycpBuiltin	regexppos
syn keyword	ycpBuiltin	splitstring
syn keyword	ycpBuiltin	mergestring
syn keyword	ycpBuiltin	mapmap
syn keyword	ycpBuiltin	prepend
syn keyword	ycpBuiltin	listmap
syn keyword	ycpBuiltin	y2debug
syn keyword	ycpBuiltin	y2milestone
syn keyword	ycpBuiltin	y2warning
syn keyword	ycpBuiltin	regexpsub
syn keyword	ycpBuiltin	y2error
syn keyword	ycpBuiltin	y2security
syn keyword	ycpBuiltin	y2internal
syn keyword	ycpBuiltin	regexptokenize
syn keyword	ycpBuiltin	tohexstring

" YCP types
syn keyword	ycpType		any void boolean integer float string locale
syn keyword	ycpType		symbol list map term path block declaration
syn keyword	ycpType		expression byteblock

" YCP boolean
syn keyword	ycpBoolean	true false nil

" YCP widgets
syn keyword	ycpWidget	Bottom
syn keyword	ycpWidget	CheckBox
syn keyword	ycpWidget	CheckBoxFrame
syn keyword	ycpWidget	ComboBox
syn keyword	ycpWidget	Empty
syn keyword	ycpWidget	Frame
syn keyword	ycpWidget	HBox
syn keyword	ycpWidget	HCenter
syn keyword	ycpWidget	HSpacing
syn keyword	ycpWidget	HSquash
syn keyword	ycpWidget	HStretch
syn keyword	ycpWidget	HVCenter
syn keyword	ycpWidget	HVSquash
syn keyword	ycpWidget	HVStretch
syn keyword	ycpWidget	HWeight
syn keyword	ycpWidget	Heading
syn keyword	ycpWidget	IconButton
syn keyword	ycpWidget	Image
syn keyword	ycpWidget	InputField
syn keyword	ycpWidget	IntField
syn keyword	ycpWidget	Label
syn keyword	ycpWidget	Left
syn keyword	ycpWidget	LogView
syn keyword	ycpWidget	MarginBox
syn keyword	ycpWidget	MenuButton
syn keyword	ycpWidget	MinHeight
syn keyword	ycpWidget	MinSize
syn keyword	ycpWidget	MinWidth
syn keyword	ycpWidget	MultiLineEdit
syn keyword	ycpWidget	MultiSelectionBox
syn keyword	ycpWidget	PackageSelector
syn keyword	ycpWidget	SimplePatchSelector
syn keyword	ycpWidget	Password
syn keyword	ycpWidget	ProgressBar
syn keyword	ycpWidget	PushButton
syn keyword	ycpWidget	RadioButton
syn keyword	ycpWidget	RadioButtonGroup
syn keyword	ycpWidget	ReplacePoint
syn keyword	ycpWidget	RichText
syn keyword	ycpWidget	Right
syn keyword	ycpWidget	SelectionBox
syn keyword	ycpWidget	Table
syn keyword	ycpWidget	TextEntry
syn keyword	ycpWidget	Top
syn keyword	ycpWidget	Tree
syn keyword	ycpWidget	VBox
syn keyword	ycpWidget	VCenter
syn keyword	ycpWidget	VSpacing
syn keyword	ycpWidget	VSquash
syn keyword	ycpWidget	VStretch
syn keyword	ycpWidget	VWeight
syn keyword	ycpWidget	PkgSpecial
syn keyword	ycpWidget	BusyIndicator

syn keyword	ycpWidget	BarGraph
syn keyword	ycpWidget	ColoredLabel
syn keyword	ycpWidget	Date
syn keyword	ycpWidget	DateField
syn keyword	ycpWidget	DownloadProgress
syn keyword	ycpWidget	DumbTab
syn keyword	ycpWidget	DummySpecialWidget
syn keyword	ycpWidget	HMultiProgressMeter
syn keyword	ycpWidget	VMultiProgressMeter
syn keyword	ycpWidget	PartitionSplitter
syn keyword	ycpWidget	PatternSelector
syn keyword	ycpWidget	Slider
syn keyword	ycpWidget	Time
syn keyword	ycpWidget	TimeField
syn keyword	ycpWidget	TimezoneSelector

syn keyword	ycpWidget	CurrentButton
syn keyword	ycpWidget	CurrentItem
syn keyword	ycpWidget	Enabled
syn keyword	ycpWidget	ExpectedSize
syn keyword	ycpWidget	Filename
syn keyword	ycpWidget	Item
syn keyword	ycpWidget	Items
syn keyword	ycpWidget	Label
syn keyword	ycpWidget	Labels
syn keyword	ycpWidget	LastLine
syn keyword	ycpWidget	Notify
syn keyword	ycpWidget	SelectedItems
syn keyword	ycpWidget	ValidChars
syn keyword	ycpWidget	Value
syn keyword	ycpWidget	Values
syn keyword	ycpWidget	WindowID
syn keyword	ycpWidget	EasterEgg

" YCP widget specials
syn keyword	ycpWidgetSpecial	animated
syn keyword	ycpWidgetSpecial	autoScrollDown
syn keyword	ycpWidgetSpecial	autoShortcut
syn keyword	ycpWidgetSpecial	boldFont
syn keyword	ycpWidgetSpecial	centered
syn keyword	ycpWidgetSpecial	countShowDelta
syn keyword	ycpWidgetSpecial	debugLayout
syn keyword	ycpWidgetSpecial	decorated
syn keyword	ycpWidgetSpecial	default
syn keyword	ycpWidgetSpecial	defaultsize
syn keyword	ycpWidgetSpecial	disabled
syn keyword	ycpWidgetSpecial	easterEgg
syn keyword	ycpWidgetSpecial	editable
syn keyword	ycpWidgetSpecial	hstretch
syn keyword	ycpWidgetSpecial	hvstretch
syn keyword	ycpWidgetSpecial	immediate
syn keyword	ycpWidgetSpecial	infocolor
syn keyword	ycpWidgetSpecial	invertAutoEnable
syn keyword	ycpWidgetSpecial	keepSorting
syn keyword	ycpWidgetSpecial	keyEvents
syn keyword	ycpWidgetSpecial	mainDialog
syn keyword	ycpWidgetSpecial	noAutoEnable
syn keyword	ycpWidgetSpecial	notify
syn keyword	ycpWidgetSpecial	outputField
syn keyword	ycpWidgetSpecial	plainText
syn keyword	ycpWidgetSpecial	repoMode
syn keyword	ycpWidgetSpecial	scaleToFit
syn keyword	ycpWidgetSpecial	searchMode
syn keyword	ycpWidgetSpecial	shrinkable
syn keyword	ycpWidgetSpecial	stepsEnabled
syn keyword	ycpWidgetSpecial	summaryMode
syn keyword	ycpWidgetSpecial	testMode
syn keyword	ycpWidgetSpecial	tiled
syn keyword	ycpWidgetSpecial	updateMode
syn keyword	ycpWidgetSpecial	vstretch
syn keyword	ycpWidgetSpecial	warncolor
syn keyword	ycpWidgetSpecial	youMode
syn keyword	ycpWidgetSpecial	zeroHeight
syn keyword	ycpWidgetSpecial	zeroWidth

syn keyword	ycpWidgetSpecial	key_F1
syn keyword	ycpWidgetSpecial	key_F2
syn keyword	ycpWidgetSpecial	key_F3
syn keyword	ycpWidgetSpecial	key_F4
syn keyword	ycpWidgetSpecial	key_F5
syn keyword	ycpWidgetSpecial	key_F6
syn keyword	ycpWidgetSpecial	key_F7
syn keyword	ycpWidgetSpecial	key_F8
syn keyword	ycpWidgetSpecial	key_F9
syn keyword	ycpWidgetSpecial	key_F10
syn keyword	ycpWidgetSpecial	key_F11
syn keyword	ycpWidgetSpecial	key_F12
syn keyword	ycpWidgetSpecial	key_F13
syn keyword	ycpWidgetSpecial	key_F14
syn keyword	ycpWidgetSpecial	key_F15
syn keyword	ycpWidgetSpecial	key_F16
syn keyword	ycpWidgetSpecial	key_F17
syn keyword	ycpWidgetSpecial	key_F18
syn keyword	ycpWidgetSpecial	key_F19
syn keyword	ycpWidgetSpecial	key_F20
syn keyword	ycpWidgetSpecial	key_F21
syn keyword	ycpWidgetSpecial	key_F22
syn keyword	ycpWidgetSpecial	key_F23
syn keyword	ycpWidgetSpecial	key_F24
syn keyword	ycpWidgetSpecial	key_none

syn keyword	ycpWidgetSpecial	ArrowLeft
syn keyword	ycpWidgetSpecial	ArrowRight
syn keyword	ycpWidgetSpecial	ArrowUp
syn keyword	ycpWidgetSpecial	ArrowDown

syn keyword	ycpWidgetSpecial	CheckMark
syn keyword	ycpWidgetSpecial	BulletArrowRight
syn keyword	ycpWidgetSpecial	BulletCircle
syn keyword	ycpWidgetSpecial	BulletSquare

syn keyword	ycpWidgetSpecial	id
syn keyword	ycpWidgetSpecial	opt
syn keyword	ycpWidgetSpecial	icon
syn keyword	ycpWidgetSpecial	item
syn keyword	ycpWidgetSpecial	cell
syn keyword	ycpWidgetSpecial	menu
syn keyword	ycpWidgetSpecial	header
syn keyword	ycpWidgetSpecial	rgb
syn keyword	ycpWidgetSpecial	leftMargin
syn keyword	ycpWidgetSpecial	rightMargin
syn keyword	ycpWidgetSpecial	topMargin
syn keyword	ycpWidgetSpecial	bottomMargin
syn keyword	ycpWidgetSpecial	BackgroundPixmap

" comment miniles
if !exists("c_minlines")
  let c_minlines = 15
endif
exec "syn sync ccomment cComment minlines=" . c_minlines

" highliting colors
if version >= 508 || !exists("did_basic_syntax_inits")
  if version < 508
    let did_basic_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ycpLabel		Label
  HiLink ycpUserLabel		Label
  HiLink ycpConditional		Conditional
  HiLink ycpRepeat		Repeat
  HiLink ycpCharacter		Character
  HiLink ycpSpecialCharacter	ycpSpecial
  HiLink ycpNumber		Number
  HiLink ycpFloat		Float
  HiLink ycpOctalError		ycpError
  HiLink ycpParenError		ycpError
  HiLink ycpInParen		ycpError
  HiLink ycpCommentError	ycpError
  HiLink ycpSpaceError		ycpError
  HiLink ycpBuiltin		Operator
  HiLink ycpStructure		Structure
  HiLink ycpStorageClass	StorageClass
  HiLink ycpInclude		Include
  HiLink ycpPreProc		PreProc
  HiLink ycpDefine		Macro
  HiLink ycpIncluded		ycpString
  HiLink ycpError		Error
  HiLink ycpStatement		Statement
  HiLink ycpPreCondit		PreCondit
  HiLink ycpType		Type
  HiLink ycpCommentError	ycpError
  HiLink ycpCommentSkip		ycpComment
  HiLink ycpString		String
  HiLink ycpComment		Comment
  HiLink ycpSpecial		SpecialChar
  HiLink ycpTodo		Todo
  HiLink ycpWidget		Function
  HiLink ycpWidgetSpecial	Special
  HiLink ycpBoolean		Boolean

  delcommand HiLink
endif

" syntax name
let b:current_syntax = "ycp"
