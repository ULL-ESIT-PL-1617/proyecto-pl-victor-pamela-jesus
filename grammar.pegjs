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
  = _"const"_ iden:ID IGUAL valor:NUM commas:(COMMA iden2:ID IGUAL valor2:NUM)* _";"_{
    var constan = [];
    constan.push({
      id: iden,
      val: valor
    });
    commas.forEach(function(element) {
        constan.push({id: element[1], val: element[3]});
    });
    return {
      type: "CONSTANTES",
      constantes: constan
    }
  }
  / _"var"_ iden:ID commas:(COMMA iden2:ID)* _";"_{
    var vars = [];
    vars.push({
      id: iden
    });
    commas.forEach(function(element) {
        vars.push({id: element[1]});
    });
    return {
      type: "VARIABLES",
      variables: vars
    }
  }
  / _"procedure"_ iden:ID _"("_ argu:ARGUMENTO commas:(COMMA argu2:ARGUMENTO)* _")"_ _";"_ bloque:BLOQUE _";"_{
    var argumen = [];
    argumen.push({
      arg: argu
    });
    commas.forEach(function(element) {
        argumen.push({arg: element[1]});
    });
    return{
      type: "PROCEDURE",
      id: iden,
      argumentos: argumen,
      bloq: bloque
    }
  }
  / instru:INSTRUCCION{
    return {
      type: "INSTRUCCION",
      instruccion: instru
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
  / _"call"_ iden:ID _"("_ argu:ARGUMENTOCALL commas:(COMMA argu2:ARGUMENTOCALL)* _")"_{
    var argumen = [];
    argumen.push({
      arg: argu
    });
    commas.forEach(function(element) {
        argumen.push({arg: element[1]});
    });
    return {
      type: "CALL",
      id: iden,
      argumentos: argumen
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
    var instruccione = [];
    instruc.forEach(function(element) {
        instruccione.push({instruc: element[0]});
    });
    return {
      type: "BEGIN-END",
      instrucciones: instruccione
    }
  }
  / _"if"_ condi:CONDICION _"then"_ instr1:INSTRUCCION elseterm:((_"else"_) instr2:INSTRUCCION)?{
    return {
      type: "IF",
      condicion: condi,
      instruccion: instr1,
      instruccionelse: elseterm[1]
    }
  }
  / _"while"_ condi:CONDICION _"do"_ instru:(INSTRUCCION)*{
    return {
      type: "WHILE",
      condicion: condi,
      instrucciones: instru
    }
  }
  / _"return"_ iden:$ID{
    return {
      type: "RETURN",
      valor: iden
    }
  }
  
ARGUMENTO
  = id:$ID {
      return {
        type: "ARGUMENTOID",
        value: id
      }
  }
  
ARGUMENTOCALL
  = id:$ID {
      return {
        type: "ARGUMENTOID",
        value: id
      }
  }
  / exp:EXPRESION {
    return {
      type: "ARGUMENTO",
      value: exp
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
  / id:$ID {
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
NUM = _ num:$[0-9]+ _ { return num; }
ID = _ id:$([a-z_]i$([a-z0-9_]i*)) _ { return id; }
COMPARISONOPERATOR = MENOR / MENORQUE / MAYOR / MAYORQUE / IGUAL / HASH
MENOR = _"<"_ { return '<'; }
MENORQUE = _"<="_ { return '<='; }
MAYOR = _">"_ { return '>'; }
MAYORQUE = _">="_ { return '>='; }
IGUAL = _"="_ { return '='; }
HASH = _"#"_ { return '#'; }
COMMA = _","_
PUNTO = _"."_