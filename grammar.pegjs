PROGRAMA
  = codigo:BLOQUE PUNTO{
    return{
      type: "PROGRAMA",
      value: codigo
    }
  }
  
BLOQUE
  = codigo:(PRIMARIO)*{
    return{
        type: "BLOQUE",
        value: codigo
    }
  }
  
PRIMARIO
  = _"const"_ iden:(ID IGUAL NUM (COMMA ID IGUAL NUM)*) _";"_{
    return {
      type: "CONST",
      id: iden
    }
  }
  / _"var"_ iden:(ID (COMMA ID)*) _";"_{
    return {
      type: "VARIABLE",
      id: iden
    }
  }
  / _"procedure"_ iden:ID _"("_ argu:((ARGUMENTO COMMA)* ARGUMENTO)? _")"_ _";"_ bloque:BLOQUE _";"_{
    return{
      type: "PROCEDURE",
      id: iden,
      arg: argu,
      bloq: bloque
    }
  }
  / instru:INSTRUCCION{
    return {
      type: "INSTRUCCION",
      instr: instru
    }
  }
  
INSTRUCCION
  = iden:ID _":="_ expr:EXPRESION{
    return {
      type: "ASIGNACION",
      id: iden,
      exp: expr
    }
  }
  / _"call"_ iden:ID _"("_ argu:((ARGUMENTO COMMA)* ARGUMENTO)? _")"_{
    return {
      type: "CALL",
      id: iden,
      args: argu
    }
  }
  / _"?"_ ident:ID{
    return {
      type: "?",
      id: ident
    }
  }
  / _"!"_ expr:EXPRESION{
    return {
      type: "!",
      exp: expr
    }
  }
  / _"begin"_ instruc:(INSTRUCCION _";"_)* _"end"_{
    return {
      type: "BEGIN-END",
      instr: instruc
    }
  }
  / _"if"_ condi:CONDICION _"then"_ instr1:INSTRUCCION elseterm:(_"else"_ instr2:INSTRUCCION)?{
    return {
      type: "IF",
      cond: condi,
      instr: instr1,
      else: elseterm
    }
  }
  / _"while"_ condi:CONDICION _"do"_ instru:(INSTRUCCION)*{
    return {
      type: "WHILE",
      cond: condi,
      instr: instru
    }
  }
  
ARGUMENTO
  = exp:EXPRESION {
    return {
      type: "ARGUMENTO",
      value: exp
    }
  }
  / id:$ID {
      return {
        type: "ARGUMENTO",
        value: id
      }
  }

CONDICION
  = _"odd"_ exp:EXPRESION{
    return{
      type: "CONDICION ODD",
      value: exp
    }
  }
  / expl:EXPRESION oper:COMPARISONOPERATOR expr:EXPRESION{
    return{
      type: "CONDICION",
      leftT: expl,
      op: oper,
      rightT: expr
    }
  }

EXPRESION
  = left:TERM oper:ADDOP right:EXPRESION{
    return{
      type: "EXPRESION",
      leftT: left,
      op: oper,
      rightT: right
    }
  }
  / left:TERM{
    return{
      type: "EXPRESION",
      value: left
    }
  }
  
TERM
  = left:FACTOR oper:MULOP right:TERM{
    return{
      type: "TERM",
      leftT: left,
      op: oper,
      rightT: right
    }
  }
  / left:FACTOR{
    return{
      type: "TERM",
      value: left
    }
  }

FACTOR
  = _"("_ exp:EXPRESION _")"_ {
    return {
      type: "FACTOR",
      value: expression
    }
  }
  / int:$integer {
      return {
        type: "FACTOR",
        value: int
      }
  }
  / id:ID {
      return {
        type: "FACTOR",
        value: id
      }
  }
  
integer "integer"
  = NUMBER

_ = $[ \t\n\r]*

NUMBER = _ $[0-9]+ _
ADDOP = PLUS / MINUS
MULOP = MULT / DIV
PLUS = _"+"_
MINUS = _"-"_
MULT = _"*"_
DIV = _"/"_
NUM = _ $[0-9]+ _
ID = _ $([a-z_]i$([a-z0-9_]i*)) _
COMPARISONOPERATOR = MENOR / MENORQUE / MAYOR / MAYORQUE / IGUAL / HASH
MENOR = _"<"_ { return '<'; }
MENORQUE = _"<="_ { return '<='; }
MAYOR = _">"_ { return '>'; }
MAYORQUE = _">="_ { return '>='; }
IGUAL = _"="_ { return '='; }
HASH = _"#"_ { return '#'; }
COMMA = _","_
PUNTO = _"."_