%{
/* $Id$ */
#include <libxml/tree.h>
xmlNodePtr makexml();
#define XML yyval=makexml(yyn, yyvsp)
#define YYSTYPE xmlNodePtr
extern xmlDocPtr thedoc;

/*
#include <stdio.h>

#include <YCP.h>
#include <ycp/YCPScanner.h>
#include <y2log.h>
#include <parserret.h>
#include <ycp/YCPScope.h>
*/
// compile with full debug info, enable with YCP_YYDEBUG=1 in run-time env
#define YYDEBUG 1
#define YYERROR_VERBOSE 1

int yylex ();

static void yyerror (char *s) {
    extern int yylineno;
    fprintf (stderr, "Line %d: %s\n", yylineno, s);
}

/*
// define type of parser values
typedef struct { YCPElement e; int l; } yystype_type;
#define YYSTYPE yystype_type

#define YYPARSE_PARAM parser_ret
#define YYLEX_PARAM parser_ret

#ifdef YYLSP_NEEDED
#warning YYLSP_NEEDED
#endif

#define LINE_NOW (((struct parserret *)parser_ret)->lineno)
#define FILE_NOW (((struct parserret *)parser_ret)->filename)

// our private error function
static void yyerror_with_lineinfo (const char *s, void *pr_void);
#define yyerror(text) yyerror_with_lineinfo(text, parser_ret)


static YCPValue deepquoted(const YCPValue& v);

static string inside_module = "";

// someone out there needs this var
int yyeof_reached = 0;

static YCPScope scope;
static string current_textdomain;
*/
%}
/*
%pure_parser
*/

%token  EMPTY LIST DEFINE UNDEFINE I18N
%token  RETURN CONTINUE BREAK IF DO WHILE REPEAT UNTIL IS
%token  SYMBOL QUOTED_SYMBOL
%token  DCOLON UI WFM SCR
%token  QUOTED_BLOCK QUOTED_EXPRESSION
%token	YCP_VOID YCP_BOOLEAN YCP_INTEGER YCP_FLOAT YCP_STRING YCP_TIME YCP_BYTEBLOCK YCP_PATH
%token  ANY YCP_DECLTYPE MODULE IMPORT EXPORT MAPEXPR INCLUDE GLOBAL TEXTDOMAIN
//%token	FOREACH
%token  CONST FULLNAME CLOSEBRACKET

 /* bindings in order of precedence, lowest first  */

%right '='
%left '?'
%left OR
%left AND
%left EQUALS NEQ
%left ST GT SE GE
%left '+' '-'
%left '*' '/' '%'
%left LEFT RIGHT
%right NOT
%left ELSE
%left '|'
%left '&'
%right '~'
%right UMINUS
%left DCOLON

/* ---------------------------------------------------------------------- */
%%

start: ycp { thedoc->children = $1; }
;

ycp:
	module { XML; }
|	compact_expression { XML; }
|	/*empty*/ { XML; }
;

/* Expressions */

  /* expressions are either 'compact' (with a defined end-token, no lookahead)
     or 'infix' (which might need a lookahead token)  */

expression:
	compact_expression { XML; }
|	infix_expression { XML; }
;

infix_expression:
	expression '+' expression { XML; }
|	expression '-' expression  { XML; }
|	expression '*' expression  { XML; }
|	expression '/' expression { XML; }
|	expression '%' expression     { XML; }
|	expression LEFT expression     { XML; }
|	expression RIGHT expression     { XML; }
|	expression '&' expression     { XML; }
|	expression '|' expression     { XML; }
|	'~' expression     { XML; }
|	expression AND expression  { XML; }
|	expression OR expression  { XML; }
|	expression EQUALS expression   { XML; }
|	expression ST expression   { XML; }
|	expression GT expression   { XML; }
|	expression SE expression   { XML; }
|	expression GE expression   { XML; }
|	expression NEQ expression   { XML; }
|	NOT expression  { XML; }
|      expression '?' expression ':' expression  { XML; }
|	'-' expression %prec UMINUS  { XML; }
;

compact_expression:
	constant { XML; }
|	tuple { XML; }
|	map { XML; }
|	term { XML; }
|	IS '(' expression ',' typedecl ')' { XML; }
|	TEXTDOMAIN '(' expression ')' { XML; }
|	'(' expression ')' { XML; }
|	block { XML; }
|	QUOTED_EXPRESSION expression ')'	 { XML; }
|	quoted_block { XML; }
;
/* ----------------------------------------------------------*/

constant:
	YCP_VOID { XML; }
|	YCP_BOOLEAN { XML; }
|	YCP_INTEGER { XML; }
|	YCP_FLOAT { XML; }
|	YCP_STRING { XML; }
|       YCP_BYTEBLOCK { XML; }
|	YCP_PATH  { XML; }
;

/* -------------------------------------------------------------- */
/* Tuples */

tuple:
	'[' tuple_elements ']'		 { XML; }
|	'[' tuple_elements ',' ']'	 { XML; }
;

tuple_elements:
	/* empty  */ { XML; }
|	expression { XML; }
|	tuple_elements ',' expression { XML; }
/* hack because of foreach . TODO move it there */
|	typedecl SYMBOL { XML; }
|	tuple_elements ',' typedecl SYMBOL { XML; }
;

/* -------------------------------------------------------------- */
/* Maps */

map:
	MAPEXPR map_elements ']' { XML; }
|	MAPEXPR map_elements ',' ']' { XML; }
;

map_elements:
	/* empty  */ { XML; }
|	expression ':' expression { XML; }
|	map_elements ',' expression ':' expression { XML; }
;

/* -------------------------------------------------------------- */
/* Terms */


term:
	QUOTED_SYMBOL '(' tuple_elements ')' { XML; }
|	special_namespace other_builtin { XML; }
|	identifier '(' tuple_elements ')' { XML; }
|	I18N YCP_STRING ',' YCP_STRING ',' expression ')' { XML; }
|	I18N YCP_STRING ')' { XML; }
|	identifier { XML; }
/* ugh, a term? */
|	identifier '[' tuple_elements CLOSEBRACKET %prec DCOLON expression { XML;}
;

/* -------------------------------------------------------------- */
/* after UI, SCR, or WFM */

special_namespace:
	UI
|	SCR
|	WFM
;

other_builtin:
	DCOLON quoted_block { XML; }
|	DCOLON block { XML; } /* another syntactic sugar, sigh */
|	'(' expression ')' { XML; }
;

/* -------------------------------------------------------------- */
/* Symbols   (YCPSymbol())*/

identifier:
	SYMBOL DCOLON SYMBOL { XML; }
|	special_namespace DCOLON SYMBOL { XML; }
|	DCOLON SYMBOL { XML; }
|	SYMBOL { XML; }
;

/* -------------------------------------------------------------- */
/* Statements */

block:
	'{' block_statements '}' { XML; }
;

block_statements:
  block_statements statement  { XML; }
| /* empty  */ { XML; }
;

// quoted block statements

quoted_block:	QUOTED_BLOCK block_statements '}' { XML; }
;

module:
	'{' MODULE YCP_STRING ';'
	    module_statements '}' { XML; }
;

module_statements:  module_statements novalue_statement { XML; }
| /* empty  */ { XML; }
;

statement:
	novalue_statement { XML; }
|	value_statement { XML; }
;

value_statement:
	assignment ';' { XML; }
|	term ';' { XML; }
|	block { XML; }
|	IF '(' expression ')' statement_as_block opt_else { XML; }
|	WHILE '(' expression ')' statement_as_block { XML; }
|	DO block WHILE '(' expression ')' ';' { XML; }
|	REPEAT block UNTIL '(' expression ')' ';' { XML; }
|	BREAK ';' { XML; }
|	CONTINUE ';' { XML; }
|	RETURN ';' { XML; }
|	RETURN expression ';' { XML; }
;

opt_else:
	ELSE statement_as_block { XML; }
|	/* empty */ { XML; }
;

statement_as_block:
	statement { XML; }
;

/* -------------------------------------------------------------- */
/* Assignment */

assignment:
	identifier '=' expression { XML; }
|	identifier '[' tuple_elements ']' '=' expression { XML; }
;

novalue_statement:
	';' { XML; }
|	INCLUDE YCP_STRING ';' { XML; }
|	IMPORT YCP_STRING ';' { XML; }
|	FULLNAME YCP_STRING ';' { XML; }
|	TEXTDOMAIN YCP_STRING ';' { XML; }
|	EXPORT symbollist ';' { XML; }
|	UNDEFINE symbollist ';' { XML; }
|	vardecl	';' { XML; }
|	definition { XML; }
;

/* -------------------------------------------------------------- */
/* Symbol lists */

symbollist:
	SYMBOL { XML; }
|	symbollist ',' SYMBOL { XML; }
;

/* -------------------------------------------------------------- */
/* Declarations. They have a small arithmetic themselves  */

typedecl:
	ANY { XML; }
|	YCP_DECLTYPE { XML; }
|	LIST { XML; }
|	LIST '(' typedecl ')' { XML; }
|	'[' EMPTY ']' { XML; }
|	'[' tupledecl ']' { XML; }
|       '(' typedecl ')' { XML; }
;

tupledecl:
	typedecl SYMBOL { XML; }
|	tupledecl ',' typedecl SYMBOL { XML; }
;

/* -------------------------------------------------------------- */
/* Variable declaration */

vardecl:
	opt_global typedecl SYMBOL '=' expression { XML; }
;

/* -------------------------------------------------------------- */
/* Macro defintion */

definition:
	opt_global DEFINE opt_type definition_prefix ')' expression { XML; }
|	opt_global DEFINE opt_type UI DCOLON definition_prefix ')' expression { XML; }
;

opt_global:
	GLOBAL { XML; }
|	/*empty*/ { XML; }
;

opt_type:
	typedecl { XML; }
|	/*empty*/ { XML; }
;

definition_prefix:
	definition_symbol { XML; }
|	definition_symbol typedecl SYMBOL { XML; }
|	definition_prefix ',' typedecl SYMBOL { XML; }
;

definition_symbol:
	SYMBOL '(' { XML; }
;

/* ---------------------------------------------------------------------- */
%%

/*
YYNTOKENS = number of tokens (terminal symbols)
YYNNTS = number of non-terminal symbols
YYNRULES
YYNSTATES

yyn = the rule which is reduced
yyvsp = pointer to the value stack (where?)
yyr1[YYNRULES] = symbol that the rule reduces to
yyr2[YYNRULES] = length of right hand side
yytname[YYNTOKENS+YYNNTS] = symbol names
 */
xmlNodePtr makexml(int yyn, xmlNodePtr yyvsp[]) {
  xmlNodePtr n = xmlNewDocNode(thedoc, NULL, yytname[yyr1[yyn]], NULL);
  int yylen = yyr2[yyn];
  int i;
  for (i = yylen; i > 0; --i)
    xmlAddChild(n, yyvsp[1-i]);
  return n;
}

/*
  I define my own yylex, which makes scanner and parser reentrant.

  lvalp_void is a void pointer to yylval (the value of the lexical token)
  void_pr is a pointer to 'our' parser
*/
/*
extern "C" {
int yylex(YYSTYPE *lvalp_void, void *void_pr)
{
    // get 'our' parser
    struct parserret *pr = (struct parserret *)void_pr;

    // call 'our' scanner through the parser
    int token = pr->scanner->yylex();

    if (token != YYEOF) {
	// store the value of the lexical token
	YCPValue *store_here = (YCPValue *) &(lvalp_void->e);
	*store_here = pr->scanner->getScannedValue();
	pr->lineno = pr->scanner->getLineNumber();
    }
    return token;
}
} // extern "C"


static void yyerror_with_lineinfo(const char *s, void *pr_void)
{
    struct parserret *parser_ret = (struct parserret *)pr_void;
    parser_ret->scanner->logError(s, parser_ret->lineno);
}


static YCPValue deepquoted(const YCPValue& v)
{
    YCPBuiltin b(YCPB_DEEPQUOTE);
    b->add(v);
    return b;
}
*/
