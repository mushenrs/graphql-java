grammar Graphql;

@header {
    package graphql.parser.antlr;
}

// Document 

document : definition+;

definition:
operationDefinition |
fragmentDefinition |
typeSystemDefinition
;

operationDefinition:
selectionSet |
operationType  name? variableDefinitions? directives? selectionSet;

operationType : NAME;

variableDefinitions : '(' variableDefinition+ ')';

variableDefinition : variable ':' type defaultValue?;

variable : '$' name;

defaultValue : '=' value;

// Operations

selectionSet :  '{' selection+ '}';

selection :
field |
fragmentSpread |
inlineFragment;

field : alias? name arguments? directives? selectionSet?;

alias : name ':';

arguments : '(' argument+ ')';

argument : name ':' valueWithVariable;

// Fragments

fragmentSpread : '...' fragmentName directives?;

inlineFragment : '...' 'on' typeCondition directives? selectionSet;

fragmentDefinition : 'fragment' fragmentName 'on' typeCondition directives? selectionSet;

fragmentName :  name;

typeCondition : typeName;

// Value

name: NAME | SCALAR | TYPE | INTERFACE | IMPLEMENTS | ENUM | UNION | INPUT | EXTEND | DIRECTIVE;

value :
IntValue |
FloatValue |
StringValue |
BooleanValue |
enumValue |
arrayValue |
objectValue;

valueWithVariable :
variable |
IntValue |
FloatValue |
StringValue |
BooleanValue |
enumValue |
arrayValueWithVariable |
objectValueWithVariable;


enumValue : name ;

// Array Value

arrayValue: '[' value* ']';

arrayValueWithVariable: '[' valueWithVariable* ']';


// Object Value

objectValue: '{' objectField* '}';
objectValueWithVariable: '{' objectFieldWithVariable* '}';
objectField : name ':' value;
objectFieldWithVariable : name ':' valueWithVariable;

// Directives

directives : directive+;

directive :'@' name arguments?;

// Types

type : typeName | listType | nonNullType;

typeName : name;
listType : '[' type ']';
nonNullType: typeName '!' | listType '!';


// Type System
typeSystemDefinition:
scalarTypeDefinition |
objectTypeDefinition |
interfaceTypeDefinition |
unionTypeDefinition |
enumTypeDefinition |
inputObjectTypeDefinition
;

namedType : name;

scalarTypeDefinition : SCALAR name directives?;


objectTypeDefinition : TYPE name implementsInterfaces? directives? '{' fieldDefinition+ '}';

implementsInterfaces : IMPLEMENTS namedType+;

fieldDefinition : name argumentsDefinition? ':' type directives?;

argumentsDefinition : '(' inputValueDefinition+ ')';

inputValueDefinition : name ':' type defaultValue? directives?;

interfaceTypeDefinition : INTERFACE name directives? '{' fieldDefinition+ '}';

unionTypeDefinition : UNION name directives? '=' unionMembers;

unionMembers:
namedType |
unionMembers '|' namedType
;

enumTypeDefinition : ENUM name directives? '{' enumValueDefinition+ '}';

enumValueDefinition : enumValue directives?;

inputObjectTypeDefinition : INPUT name directives? '{' inputValueDefinition+ '}';

typeExtensionDefinition : EXTEND objectTypeDefinition;

directiveDefinition : DIRECTIVE '@' name argumentsDefinition? 'on' directiveLocations;

directiveLocations :
name |
directiveLocations '|' name
;


// Token

BooleanValue: 'true' | 'false';

SCALAR: 'scalar';
TYPE: 'type';
INTERFACE: 'interface';
IMPLEMENTS: 'implements';
ENUM: 'enum';
UNION: 'union';
INPUT: 'input';
EXTEND: 'extend';
DIRECTIVE: 'directive';
NAME: [_A-Za-z][_0-9A-Za-z]*;


IntValue : Sign? IntegerPart;

FloatValue : Sign? IntegerPart ('.' Digit*)? ExponentPart?;

Sign : '-';

IntegerPart : '0' | NonZeroDigit | NonZeroDigit Digit+;

NonZeroDigit: '1'.. '9';

ExponentPart : ('e'|'E') Sign? Digit+;

Digit : '0'..'9';


StringValue: '"' (~(["\\\n\r\u2028\u2029])|EscapedChar)* '"';

fragment EscapedChar :   '\\' (["\\/bfnrt] | Unicode) ;
fragment Unicode : 'u' Hex Hex Hex Hex ;
fragment Hex : [0-9a-fA-F] ;

Ignored: (Whitespace|Comma|LineTerminator|Comment) -> skip;

fragment Comment: '#' ~[\n\r\u2028\u2029]*;

fragment LineTerminator: [\n\r\u2028\u2029];

fragment Whitespace : [\t\u000b\f\u0020\u00a0];
fragment Comma : ',';
